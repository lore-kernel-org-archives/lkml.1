Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbZFXUXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbZFXUXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZFXUW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:22:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42086 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZFXUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:22:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH v2] slow-work: add (module*)work->owner to fix races with
	module clients
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com
Date: Wed, 24 Jun 2009 16:22:50 -0400
Message-ID: <20090624202107.15071.51490.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Try 2: applies to Linus' git master:626f380d)

[ Changelog:

    v2:
       *) cache "owner" value to prevent invalid access after put_ref

    v1:
       *) initial release
]


-------------------------

slow-work: add (module*)work->owner to fix races with module clients

The slow_work facility was designed to use reference counting instead of
barriers for synchronization.  The reference counting mechanism is
implemented as a vtable op (->get_ref, ->put_ref) callback.  This is
problematic for module use of the slow_work facility because it is
impossible to synchronize against the .text installed in the callbacks:
There is no way to ensure that the slow-work threads have completely
exited the .text in question and rmmod may yank it out from under the
slow_work thread.

This patch attempts to address this issue by transparently mapping "struct
module* owner" to the slow_work item, and maintaining a module reference
count coincident with the more externally visible reference count.  Since
the slow_work facility is resident in kernel, it should be a race-free
location to issue a module_put() call.  This will ensure that modules
can properly cleanup before exiting.

A module_get()/module_put() pair on slow_work_enqueue() and the subsequent
dequeue technically adds the overhead of the atomic operations for every
work item scheduled.  However, slow_work is designed for deferring
relatively long-running and/or sleepy tasks to begin with, so this
overhead will hopefully be negligible.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: David Howells <dhowells@redhat.com>
---

 include/linux/slow-work.h |    4 ++++
 kernel/slow-work.c        |   17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b65c888..9f48dab 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_SLOW_WORK
 
 #include <linux/sysctl.h>
+#include <linux/module.h>
 
 struct slow_work;
 
@@ -42,6 +43,7 @@ struct slow_work_ops {
  *   queued
  */
 struct slow_work {
+	struct module          *owner;
 	unsigned long		flags;
 #define SLOW_WORK_PENDING	0	/* item pending (further) execution */
 #define SLOW_WORK_EXECUTING	1	/* item currently executing */
@@ -61,6 +63,7 @@ struct slow_work {
 static inline void slow_work_init(struct slow_work *work,
 				  const struct slow_work_ops *ops)
 {
+	work->owner = THIS_MODULE;
 	work->flags = 0;
 	work->ops = ops;
 	INIT_LIST_HEAD(&work->link);
@@ -78,6 +81,7 @@ static inline void slow_work_init(struct slow_work *work,
 static inline void vslow_work_init(struct slow_work *work,
 				   const struct slow_work_ops *ops)
 {
+	work->owner = THIS_MODULE;
 	work->flags = 1 << SLOW_WORK_VERY_SLOW;
 	work->ops = ops;
 	INIT_LIST_HEAD(&work->link);
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 09d7519..468af2a 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -145,6 +145,17 @@ static unsigned slow_work_calc_vsmax(void)
 	return min(vsmax, slow_work_max_threads - 1);
 }
 
+static void slow_work_put(struct slow_work *work)
+{
+	/* cache values that are needed during/after pointer invalidation */
+	struct module *owner = work->owner;
+
+	work->ops->put_ref(work);
+
+	barrier(); /* ensure that put_ref is not re-ordered with module_put */
+	module_put(owner);
+}
+
 /*
  * Attempt to execute stuff queued on a slow thread.  Return true if we managed
  * it, false if there was nothing to do.
@@ -219,7 +230,7 @@ static bool slow_work_execute(void)
 		spin_unlock_irq(&slow_work_queue_lock);
 	}
 
-	work->ops->put_ref(work);
+	slow_work_put(work);
 	return true;
 
 auto_requeue:
@@ -299,6 +310,8 @@ int slow_work_enqueue(struct slow_work *work)
 		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 		} else {
+			if (!try_module_get(work->owner))
+				goto cant_get_mod;
 			if (work->ops->get_ref(work) < 0)
 				goto cant_get_ref;
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
@@ -313,6 +326,8 @@ int slow_work_enqueue(struct slow_work *work)
 	return 0;
 
 cant_get_ref:
+	module_put(work->owner);
+cant_get_mod:
 	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
 	return -EAGAIN;
 }

