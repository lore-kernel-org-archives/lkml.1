Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXBEMTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXBEMTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXBEMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:19:55 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39197 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXBEMTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:19:53 -0500
Date: Mon, 5 Feb 2007 13:18:39 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm 4/7][AIO] Resend - Make good_sigevent() non-static
Message-ID: <20070205131839.6f601c3e@frecb000686>
In-Reply-To: <20070202180039.GA658@tv-sign.ru>
References: <20070201102252.240130c6@frecb000686>
	<20070201103053.64489048@frecb000686>
	<20070202180039.GA658@tv-sign.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 13:20:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/02/2007 13:20:57,
	Serialize complete at 05/02/2007 13:20:57
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Andrew,

  Could you replace make-good_sigevent-non-static.patch with this
patch, as it fixes some problems reported by Oleg Nesterov.

  Oleg, chime in if you still see something I missed.

  Hopefully I will have gotten it right this time.

  Sorry for the hassle.

  Sébastien.


From: Sébastien Dugué <sebastien.dugue@bull.net>

                Make good_sigevent() non-static and rename it


  Move good_sigevent() from posix-timers.c to signal.c where it belongs,
clean it up, rename it to sigevent_find_task() to better describe what the
function does and make it non-static so that it can be used by other
 subsystems.


 include/linux/signal.h |    1 +
 kernel/posix-timers.c  |   19 +------------------
 kernel/signal.c        |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 18 deletions(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>


Index: linux-2.6.20-rc6-mm3/include/linux/signal.h
===================================================================
--- linux-2.6.20-rc6-mm3.orig/include/linux/signal.h	2007-01-30 11:41:27.000000000 +0100
+++ linux-2.6.20-rc6-mm3/include/linux/signal.h	2007-02-05 12:25:12.000000000 +0100
@@ -240,6 +240,7 @@ extern int sigprocmask(int, sigset_t *, 
 
 struct pt_regs;
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern struct task_struct * sigevent_find_task(sigevent_t *);
 
 extern struct kmem_cache *sighand_cachep;
 
Index: linux-2.6.20-rc6-mm3/kernel/posix-timers.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/kernel/posix-timers.c	2007-01-30 11:41:27.000000000 +0100
+++ linux-2.6.20-rc6-mm3/kernel/posix-timers.c	2007-01-30 11:41:36.000000000 +0100
@@ -367,23 +367,6 @@ static enum hrtimer_restart posix_timer_
 	return ret;
 }
 
-static struct task_struct * good_sigevent(sigevent_t * event)
-{
-	struct task_struct *rtn = current->group_leader;
-
-	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
-		(!(rtn = find_task_by_pid(event->sigev_notify_thread_id)) ||
-		 rtn->tgid != current->tgid ||
-		 (event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL))
-		return NULL;
-
-	if (((event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) &&
-	    ((event->sigev_signo <= 0) || (event->sigev_signo > SIGRTMAX)))
-		return NULL;
-
-	return rtn;
-}
-
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
@@ -496,7 +479,7 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_value = event.sigev_value;
 
 		read_lock(&tasklist_lock);
-		if ((process = good_sigevent(&event))) {
+		if ((process = sigevent_find_task(&event))) {
 			/*
 			 * We may be setting up this process for another
 			 * thread.  It may be exiting.  To catch this
Index: linux-2.6.20-rc6-mm3/kernel/signal.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/kernel/signal.c	2007-01-30 11:41:27.000000000 +0100
+++ linux-2.6.20-rc6-mm3/kernel/signal.c	2007-02-05 12:27:33.000000000 +0100
@@ -1213,6 +1213,34 @@ int group_send_sig_info(int sig, struct 
 	return ret;
 }
 
+/***
+ * sigevent_find_task - check and get target task from a sigevent.
+ * @event: the sigevent to be checked
+ *
+ * This function must be called with the tasklist_lock held for reading.
+ */
+struct task_struct * sigevent_find_task(sigevent_t * event)
+{
+	struct task_struct *task = current->group_leader;
+
+	if ((event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
+		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
+			return NULL;
+	}
+
+	if (event->sigev_notify & SIGEV_THREAD_ID) {
+		if ((event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL)
+			return NULL;
+
+		task = find_task_by_pid(event->sigev_notify_thread_id);
+
+		if (!task || task->tgid != current->tgid)
+			task = NULL;
+	}
+
+	return task;
+}
+
 /*
  * kill_pgrp_info() sends a signal to a process group: this is what the tty
  * control characters do (^C, ^Z etc)
