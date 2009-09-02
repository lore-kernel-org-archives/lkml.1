Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZIBLou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZIBLou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZIBLot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:44:49 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38175 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbZIBLos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:44:48 -0400
Subject: Re: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected for
	kmemleak_lock
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1251888848.28251.7.camel@pc1117.cambridge.arm.com>
References: <1251838545.2158.67.camel@dhcp231-106.rdu.redhat.com>
	 <1251888848.28251.7.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 02 Sep 2009 12:44:37 +0100
Message-Id: <1251891877.28251.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2009 11:44:38.0566 (UTC) FILETIME=[C06F7460:01CA2BC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 11:54 +0100, Catalin Marinas wrote:
> On Tue, 2009-09-01 at 16:55 -0400, Eric Paris wrote:
> > I wrote a multithreaded inotify syscall pounder intended to create
> > files, destroy files, create watches, and destroy watches with the
> > maximum number of races possible.  Instead after letting it run a while
> > I came upon this!  And then my system started to crash in all sorts of
> > fun and glorious ways (kmem_cache_alloc bugs/panics/whatever)
> > 
> > -Eric
> > 
> > [ 2235.913737] ======================================================
> > [ 2235.914084] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> > [ 2235.914084] 2.6.31-rc8-next-20090901 #64
> > [ 2235.914084] ------------------------------------------------------
> > [ 2235.914084] syscall_thrash/2516 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > [ 2235.914084]  (kthread_create_lock){+.+...}, at: [<ffffffff81091543>] kthread_create+0x73/0x180
> > [ 2235.914084] 
> > [ 2235.914084] and this task is already holding:
> > [ 2235.914084]  (kmemleak_lock){..----}, at: [<ffffffff81152611>] create_object+0x161/0x2e0
> > [ 2235.914084] which would create a new lock dependency:
> > [ 2235.914084]  (kmemleak_lock){..----} -> (kthread_create_lock){+.+...}
> 
> Are there other messages from kmemleak printed before that? It looks to
> me like kmemleak got an exceptional situation (not being able to
> allocate memory or inserting a pointer into the prio search tree) and it
> disabled itself. When disabling, it starts a clean-up thread and AFAICT
> that's the only condition when kmemleak_lock -> kthread_create_lock
> dependency would be created.
> 
> I'm not sure whether disabling interrupts around kthread_run in
> kmemleak_cleanup() would solve the problem. Otherwise, maybe the
> kmemleak clean-up thread should take a different form or just a thread
> waiting for a clean-up event (it currently acquires a mutex and cannot
> be used in interrupt context).

It looks like the kthread_create_lock cannot be acquired in interrupt
context anyway, so the patch below changes this to a workqueue.


kmemleak: Do no create the clean-up thread during kmemleak_disable()

From: Catalin Marinas <catalin.marinas@arm.com>

The kmemleak_disable() function could be called from various contexts
including IRQ. It creates a clean-up thread but the kthread_create()
function has restrictions on which contexts it can be called from,
mainly because of the kthread_create_lock. The patch changes the
kmemleak clean-up thread to a workqueue.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Eric Paris <eparis@redhat.com>
---
 mm/kmemleak.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 401a89a..b336201 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -92,6 +92,7 @@
 #include <linux/string.h>
 #include <linux/nodemask.h>
 #include <linux/mm.h>
+#include <linux/workqueue.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -1477,7 +1478,7 @@ static const struct file_operations kmemleak_fops = {
  * Perform the freeing of the kmemleak internal objects after waiting for any
  * current memory scan to complete.
  */
-static int kmemleak_cleanup_thread(void *arg)
+static void kmemleak_do_cleanup(struct work_struct *work)
 {
 	struct kmemleak_object *object;
 
@@ -1489,22 +1490,9 @@ static int kmemleak_cleanup_thread(void *arg)
 		delete_object_full(object->pointer);
 	rcu_read_unlock();
 	mutex_unlock(&scan_mutex);
-
-	return 0;
 }
 
-/*
- * Start the clean-up thread.
- */
-static void kmemleak_cleanup(void)
-{
-	struct task_struct *cleanup_thread;
-
-	cleanup_thread = kthread_run(kmemleak_cleanup_thread, NULL,
-				     "kmemleak-clean");
-	if (IS_ERR(cleanup_thread))
-		pr_warning("Failed to create the clean-up thread\n");
-}
+static DECLARE_WORK(cleanup_work, kmemleak_do_cleanup);
 
 /*
  * Disable kmemleak. No memory allocation/freeing will be traced once this
@@ -1522,7 +1510,7 @@ static void kmemleak_disable(void)
 
 	/* check whether it is too early for a kernel thread */
 	if (atomic_read(&kmemleak_initialized))
-		kmemleak_cleanup();
+		schedule_work(&cleanup_work);
 
 	pr_info("Kernel memory leak detector disabled\n");
 }
@@ -1618,7 +1606,7 @@ static int __init kmemleak_late_init(void)
 		 * after setting kmemleak_initialized and we may end up with
 		 * two clean-up threads but serialized by scan_mutex.
 		 */
-		kmemleak_cleanup();
+		schedule_work(&cleanup_work);
 		return -ENOMEM;
 	}
 


-- 
Catalin

