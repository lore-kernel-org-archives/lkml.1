Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXDMNC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXDMNC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXDMNC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:02:26 -0400
Received: from mail.screens.ru ([213.234.233.54]:33975 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbXDMNCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:02:14 -0400
Date: Fri, 13 Apr 2007 17:02:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] make kthread_create() more scalable
Message-ID: <20070413130201.GA170@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
complete(&create->started) + schedule(). After that it can't be woken because
nobody can see the new task yet. This means:

	- we don't need tasklist_lock for find_task_by_pid().

	- create_kthread() doesn't need to wait for create->started. Instead,
	  kthread_create() first waits for create->created to get the result of
	  kernel_thread(), then waits for create->started to synchronize with
	  kthread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/kernel/kthread.c~1_CREATE	2007-04-13 14:39:21.000000000 +0400
+++ 2.6.21-rc5/kernel/kthread.c	2007-04-13 14:52:44.000000000 +0400
@@ -24,11 +24,11 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
+	struct completion created;
 	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
-	struct task_struct *result;
-	struct completion done;
+	pid_t result;
 
 	struct list_head list;
 };
@@ -91,15 +91,9 @@ static void create_kthread(struct kthrea
 
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
-	if (pid < 0) {
-		create->result = ERR_PTR(pid);
-	} else {
-		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid(pid);
-		read_unlock(&tasklist_lock);
-	}
-	complete(&create->done);
+	create->result = pid;
+
+	complete(&create->created);
 }
 
 /**
@@ -127,27 +121,31 @@ struct task_struct *kthread_create(int (
 				   ...)
 {
 	struct kthread_create_info create;
+	struct task_struct *ret;
+	va_list args;
 
 	create.threadfn = threadfn;
 	create.data = data;
+	init_completion(&create.created);
 	init_completion(&create.started);
-	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);
 	list_add_tail(&create.list, &kthread_create_list);
-	wake_up_process(kthreadd_task);
 	spin_unlock(&kthread_create_lock);
+	wake_up_process(kthreadd_task);
 
-	wait_for_completion(&create.done);
+	wait_for_completion(&create.created);
+	if (create.result < 0)
+		return ERR_PTR(create.result);
 
-	if (!IS_ERR(create.result)) {
-		va_list args;
-		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
-		va_end(args);
-	}
-	return create.result;
+	wait_for_completion(&create.started);
+	ret = find_task_by_pid(create.result);
+
+	va_start(args, namefmt);
+	vsnprintf(ret->comm, sizeof(ret->comm), namefmt, args);
+	va_end(args);
+
+	return ret;
 }
 EXPORT_SYMBOL(kthread_create);
 

