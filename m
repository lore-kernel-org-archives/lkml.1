Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXKPRZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXKPRZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXKPRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:24:40 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57182 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757390AbXKPRYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:24:39 -0500
Date: Fri, 16 Nov 2007 20:24:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] wait_task_stopped: fix racy ->exit_code/exit_state manipulations
Message-ID: <20071116172421.GA7299@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(don't know how to test this, hopefully Roland can take a look and ack/nack)

wait_task_stopped() writes to p->exit_code before checking that this is still
safe to do. Suppose for example that the child resumed and entered do_exit()
at the time we re-acquired tasklist lock. We can see ->exit_code != 0 and
->exit_state == 0 (the window is not that small), in that case we report the
the wrong value, and confuse the subsequent wait_task_zombie() because we
clear ->exit_code.

Change the code to ensure that the child is still TASK_TRACED/TASK_STOPPED
when we play with its ->exit_code. Actually, now we return EAGAIN if the
->state is "valid" but was was changed in between, this looks like a right
thing to do.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/kernel/exit.c~3_REAP	2007-11-16 18:18:24.000000000 +0300
+++ 24/kernel/exit.c	2007-11-16 19:31:49.000000000 +0300
@@ -1357,6 +1357,7 @@ static int wait_task_stopped(struct task
 			     int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval, exit_code = p->exit_code;
+	long state = p->state;
 	pid_t pid;
 
 	if (!exit_code)
@@ -1392,26 +1393,14 @@ static int wait_task_stopped(struct task
 	write_lock_irq(&tasklist_lock);
 
 	/*
-	 * This uses xchg to be atomic with the thread resuming and setting
-	 * it.  It must also be done with the write lock held to prevent a
-	 * race with the EXIT_ZOMBIE case.
+	 * This uses xchg to be atomic with the thread resuming and setting it
 	 */
-	exit_code = xchg(&p->exit_code, 0);
-	if (unlikely(p->exit_state)) {
-		/*
-		 * The task resumed and then died.  Let the next iteration
-		 * catch it in EXIT_ZOMBIE.  Note that exit_code might
-		 * already be zero here if it resumed and did _exit(0).
-		 * The task itself is dead and won't touch exit_code again;
-		 * other processors in this function are locked out.
-		 */
-		p->exit_code = exit_code;
-		exit_code = 0;
-	}
-	if (unlikely(exit_code == 0)) {
+	if (unlikely(p->state != state) ||
+	    !likely(exit_code = xchg(&p->exit_code, 0))) {
 		/*
-		 * Another thread in this function got to it first, or it
-		 * resumed, or it resumed and then died.
+		 * The task resumed and changed its state, or another thread
+		 * stealed its ->exit_code. Let the next iteration inspect the
+		 * child again.
 		 */
 		write_unlock_irq(&tasklist_lock);
 		put_task_struct(p);

