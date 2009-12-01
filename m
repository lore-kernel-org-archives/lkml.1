Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZLANwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZLANwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZLANwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:52:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZLANww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.org, mingo@elte.hu
cc: dhowells@redhat.com, steved@redhat.com, jens.axboe@oracle.com,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: [PATCH] SLOW_WORK: Fix the CONFIG_MODULES=n case
Date: Tue, 01 Dec 2009 13:52:08 +0000
Message-ID: <25668.1259675528@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Commits 3d7a641 ("SLOW_WORK: Wait for outstanding work items belonging to a
module to clear") introduced some code to make sure that all of a module's
slow-work items were complete before that module was removed, and commit
3bde31a ("SLOW_WORK: Allow a requeueable work item to sleep till the thread is
needed") further extended that, breaking it in the process if CONFIG_MODULES=n:

  CC      kernel/slow-work.o
kernel/slow-work.c: In function 'slow_work_execute':
kernel/slow-work.c:313: error: 'slow_work_thread_processing' undeclared (first use in this function)
kernel/slow-work.c:313: error: (Each undeclared identifier is reported only once
kernel/slow-work.c:313: error: for each function it appears in.)
kernel/slow-work.c: In function 'slow_work_wait_for_items':
kernel/slow-work.c:950: error: 'slow_work_unreg_sync_lock' undeclared (first use in this function)
kernel/slow-work.c:951: error: 'slow_work_unreg_wq' undeclared (first use in this function)
kernel/slow-work.c:961: error: 'slow_work_unreg_work_item' undeclared (first use in this function)
kernel/slow-work.c:974: error: 'slow_work_unreg_module' undeclared (first use in this function)
kernel/slow-work.c:977: error: 'slow_work_thread_processing' undeclared (first use in this function)
make[1]: *** [kernel/slow-work.o] Error 1

Fix this by:

 (1) Extracting the bits of slow_work_execute() that are contingent on
     CONFIG_MODULES, and the bits that should be, into inline functions and
     placing them into the #ifdef'd section that defines the relevant variables
     and adding stubs for moduleless kernels.  This allows the removal of some
     #ifdefs.

 (2) #ifdef'ing out the contents of slow_work_wait_for_items() in moduleless
     kernels.

The four functions related to handling module unloading synchronisation (and
their associated variables) could be offloaded into a separate .c file, but
each function is only used once and three of them are tiny, so doing so would
prevent them from being inlined.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/slow-work.c |   46 +++++++++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 17 deletions(-)


diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index da94f3c..b5c17f1 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -109,6 +109,30 @@ static struct module *slow_work_unreg_module;
 static struct slow_work *slow_work_unreg_work_item;
 static DECLARE_WAIT_QUEUE_HEAD(slow_work_unreg_wq);
 static DEFINE_MUTEX(slow_work_unreg_sync_lock);
+
+static void slow_work_set_thread_processing(int id, struct slow_work *work)
+{
+	if (work)
+		slow_work_thread_processing[id] = work->owner;
+}
+static void slow_work_done_thread_processing(int id, struct slow_work *work)
+{
+	struct module *module = slow_work_thread_processing[id];
+
+	slow_work_thread_processing[id] = NULL;
+	smp_mb();
+	if (slow_work_unreg_work_item == work ||
+	    slow_work_unreg_module == module)
+		wake_up_all(&slow_work_unreg_wq);
+}
+static void slow_work_clear_thread_processing(int id)
+{
+	slow_work_thread_processing[id] = NULL;
+}
+#else
+static void slow_work_set_thread_processing(int id, struct slow_work *work) {}
+static void slow_work_done_thread_processing(int id, struct slow_work *work) {}
+static void slow_work_clear_thread_processing(int id) {}
 #endif
 
 /*
@@ -197,9 +221,6 @@ static unsigned slow_work_calc_vsmax(void)
  */
 static noinline bool slow_work_execute(int id)
 {
-#ifdef CONFIG_MODULES
-	struct module *module;
-#endif
 	struct slow_work *work = NULL;
 	unsigned vsmax;
 	bool very_slow;
@@ -236,10 +257,7 @@ static noinline bool slow_work_execute(int id)
 		very_slow = false; /* avoid the compiler warning */
 	}
 
-#ifdef CONFIG_MODULES
-	if (work)
-		slow_work_thread_processing[id] = work->owner;
-#endif
+	slow_work_set_thread_processing(id, work);
 	if (work) {
 		slow_work_mark_time(work);
 		slow_work_begin_exec(id, work);
@@ -287,15 +305,7 @@ static noinline bool slow_work_execute(int id)
 
 	/* sort out the race between module unloading and put_ref() */
 	slow_work_put_ref(work);
-
-#ifdef CONFIG_MODULES
-	module = slow_work_thread_processing[id];
-	slow_work_thread_processing[id] = NULL;
-	smp_mb();
-	if (slow_work_unreg_work_item == work ||
-	    slow_work_unreg_module == module)
-		wake_up_all(&slow_work_unreg_wq);
-#endif
+	slow_work_done_thread_processing(id, work);
 
 	return true;
 
@@ -310,7 +320,7 @@ auto_requeue:
 	else
 		list_add_tail(&work->link, &slow_work_queue);
 	spin_unlock_irq(&slow_work_queue_lock);
-	slow_work_thread_processing[id] = NULL;
+	slow_work_clear_thread_processing(id);
 	return true;
 }
 
@@ -943,6 +953,7 @@ EXPORT_SYMBOL(slow_work_register_user);
  */
 static void slow_work_wait_for_items(struct module *module)
 {
+#ifdef CONFIG_MODULES
 	DECLARE_WAITQUEUE(myself, current);
 	struct slow_work *work;
 	int loop;
@@ -989,6 +1000,7 @@ static void slow_work_wait_for_items(struct module *module)
 
 	remove_wait_queue(&slow_work_unreg_wq, &myself);
 	mutex_unlock(&slow_work_unreg_sync_lock);
+#endif /* CONFIG_MODULES */
 }
 
 /**
