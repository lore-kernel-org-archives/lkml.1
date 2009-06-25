Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZFYBtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZFYBtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZFYBtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:49:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53326 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZFYBtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:49:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3] slow-work: add (module*)work->owner to fix races with
	module clients
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com
Date: Wed, 24 Jun 2009 21:49:22 -0400
Message-ID: <20090625014520.449.98923.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Try 3: applies to Linus' git master:626f380d)

[ Changelog:

    v3:
        *) moved (module*)owner to slow_work_ops 
        *) removed useless barrier()
	*) updated documentation/comments 

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

This patch attempts to address this issue by mapping "struct module* owner"
to the slow_work_ops item, and maintaining a module reference
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

 Documentation/slow-work.txt |    6 +++++-
 include/linux/slow-work.h   |    3 +++
 kernel/slow-work.c          |   20 +++++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index ebc50f8..2a38878 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -80,6 +80,7 @@ Slow work items may then be set up by:
  (2) Declaring the operations to be used for this item:
 
 	struct slow_work_ops myitem_ops = {
+	        .owner   = THIS_MODULE,
 		.get_ref = myitem_get_ref,
 		.put_ref = myitem_put_ref,
 		.execute = myitem_execute,
@@ -102,7 +103,10 @@ A suitably set up work item can then be enqueued for processing:
 	int ret = slow_work_enqueue(&myitem);
 
 This will return a -ve error if the thread pool is unable to gain a reference
-on the item, 0 otherwise.
+on the item, 0 otherwise.  Loadable modules may only enqueue work if at least
+one reference to the module is known to be held.  The slow-work infrastructure
+will acquire a reference to the module and hold it until after the item's
+reference is dropped, assuring the stability of the callback.
 
 
 The items are reference counted, so there ought to be no need for a flush
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b65c888..1382918 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_SLOW_WORK
 
 #include <linux/sysctl.h>
+#include <linux/module.h>
 
 struct slow_work;
 
@@ -24,6 +25,8 @@ struct slow_work;
  * The operations used to support slow work items
  */
 struct slow_work_ops {
+	struct module *owner;
+
 	/* get a ref on a work item
 	 * - return 0 if successful, -ve if not
 	 */
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 09d7519..18dee34 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -145,6 +145,15 @@ static unsigned slow_work_calc_vsmax(void)
 	return min(vsmax, slow_work_max_threads - 1);
 }
 
+static void slow_work_put(struct slow_work *work)
+{
+	/* cache values that are needed during/after pointer invalidation */
+	struct module *owner = work->ops->owner;
+
+	work->ops->put_ref(work);
+	module_put(owner);
+}
+
 /*
  * Attempt to execute stuff queued on a slow thread.  Return true if we managed
  * it, false if there was nothing to do.
@@ -219,7 +228,7 @@ static bool slow_work_execute(void)
 		spin_unlock_irq(&slow_work_queue_lock);
 	}
 
-	work->ops->put_ref(work);
+	slow_work_put(work);
 	return true;
 
 auto_requeue:
@@ -299,6 +308,14 @@ int slow_work_enqueue(struct slow_work *work)
 		if (test_bit(SLOW_WORK_EXECUTING, &work->flags)) {
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 		} else {
+			/*
+			 * Callers must ensure that their module has at least
+			 * one reference held while the work is enqueued.  We
+			 * will acquire another reference here and drop it
+			 * once we do the last ops->put_ref()
+			 */
+			__module_get(work->ops->owner);
+
 			if (work->ops->get_ref(work) < 0)
 				goto cant_get_ref;
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
@@ -313,6 +330,7 @@ int slow_work_enqueue(struct slow_work *work)
 	return 0;
 
 cant_get_ref:
+	module_put(work->ops->owner);
 	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
 	return -EAGAIN;
 }

