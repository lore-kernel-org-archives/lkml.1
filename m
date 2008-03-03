Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYCCNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYCCNVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYCCNVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:21:14 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:43926 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYCCNVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:21:13 -0500
Date: Mon, 3 Mar 2008 16:25:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080303132502.GA81@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <20080229023902.D93E12700FD@magilla.localdomain> <20080229120101.GA1410@tv-sign.ru> <20080301015956.A0D262700FE@magilla.localdomain> <20080301164102.GA171@tv-sign.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20080301164102.GA171@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Actually, it is easy to re-use signal_struct->flags from the very beginning,
no need to introduce the new flag temporary, see the attached patches. I also
have a couple of simple cleanups on top of them (use cached ->signal value).

Perhaps, we can add the new helper which sets SIGNAL_GROUP_EXIT but preserves
SIGNAL_CLD_MASK, but I don't think this is really needed.

Oleg.

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1_SIGCONT_IMPL.patch"

--- 25/include/linux/sched.h~1_SIGCONT_IMPL	2008-02-17 23:40:09.000000000 +0300
+++ 25/include/linux/sched.h	2008-03-03 13:40:14.000000000 +0300
@@ -555,6 +555,12 @@ struct signal_struct {
 #define SIGNAL_STOP_DEQUEUED	0x00000002 /* stop signal dequeued */
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
+/*
+ * Pending notifications to parent.
+ */
+#define SIGNAL_CLD_STOPPED	0x00000010
+#define SIGNAL_CLD_CONTINUED	0x00000020
+#define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
 
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
--- 25/kernel/signal.c~1_SIGCONT_IMPL	2008-02-17 23:40:09.000000000 +0300
+++ 25/kernel/signal.c	2008-03-03 13:51:55.000000000 +0300
@@ -595,10 +595,8 @@ static void handle_stop_signal(int sig, 
 			 * the SIGCHLD was pending on entry to this kill.
 			 */
 			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_STOPPED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->flags = SIGNAL_STOP_CONTINUED |
+						SIGNAL_CLD_STOPPED;
 		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
@@ -635,25 +633,23 @@ static void handle_stop_signal(int sig, 
 			 * We were in fact stopped, and are now continued.
 			 * Notify the parent with CLD_CONTINUED.
 			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
+			p->signal->flags = SIGNAL_STOP_CONTINUED |
+						SIGNAL_CLD_CONTINUED;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
 			 * signal in the middle of being processed after
 			 * being removed from the queue.  Clear that too.
 			 */
-			p->signal->flags = 0;
+			p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
 		 * is undone by the wakeup for SIGKILL.
 		 */
-		p->signal->flags = 0;
+		p->signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 
@@ -1761,6 +1757,19 @@ int get_signal_to_deliver(siginfo_t *inf
 
 relock:
 	spin_lock_irq(&current->sighand->siglock);
+
+	if (unlikely(current->signal->flags & SIGNAL_CLD_MASK)) {
+		int why = (current->signal->flags & SIGNAL_STOP_CONTINUED)
+				? CLD_CONTINUED : CLD_STOPPED;
+		current->signal->flags &= ~SIGNAL_CLD_MASK;
+		spin_unlock_irq(&current->sighand->siglock);
+
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(current->group_leader, why);
+		read_unlock(&tasklist_lock);
+		goto relock;
+	}
+
 	for (;;) {
 		struct k_sigaction *ka;
 

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2_HSS_SIMPLIFY.patch"

--- 25/kernel/signal.c~2_HSS_SIMPLIFY	2008-03-03 13:51:55.000000000 +0300
+++ 25/kernel/signal.c	2008-03-03 14:47:39.000000000 +0300
@@ -577,33 +577,16 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 	} else if (sig == SIGCONT) {
+		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues,
 		 * and wake all threads.
 		 */
-		if (unlikely(p->signal->group_stop_count > 0)) {
-			/*
-			 * There was a group stop in progress.  We'll
-			 * pretend it finished before we got here.  We are
-			 * obliged to report it to the parent: if the
-			 * SIGSTOP happened "after" this SIGCONT, then it
-			 * would have cleared this pending SIGCONT.  If it
-			 * happened "before" this SIGCONT, then the parent
-			 * got the SIGCHLD about the stop finishing before
-			 * the continue happened.  We do the notification
-			 * now, and it's as if the stop had finished and
-			 * the SIGCHLD was pending on entry to this kill.
-			 */
-			p->signal->group_stop_count = 0;
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_STOPPED;
-		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -613,7 +596,7 @@ static void handle_stop_signal(int sig, 
 			 * running the handler.  With the TIF_SIGPENDING
 			 * flag set, the thread will pause and acquire the
 			 * siglock that we hold now and until we've queued
-			 * the pending signal. 
+			 * the pending signal.
 			 *
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
@@ -628,13 +611,23 @@ static void handle_stop_signal(int sig, 
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED |
-						SIGNAL_CLD_CONTINUED;
+		/*
+		 * Notify the parent with CLD_CONTINUED if we were stopped.
+		 *
+		 * If we were in the middle of a group stop, we pretend it
+		 * was already finished, and then continued. Since SIGCHLD
+		 * doesn't queue we report only CLD_STOPPED, as if the next
+		 * CLD_CONTINUED was dropped.
+		 */
+		why = 0;
+		if (p->signal->flags & SIGNAL_STOP_STOPPED)
+			why |= SIGNAL_CLD_CONTINUED;
+		else if (p->signal->group_stop_count)
+			why |= SIGNAL_CLD_STOPPED;
+
+		if (why) {
+			p->signal->flags = why | SIGNAL_STOP_CONTINUED;
+			p->signal->group_stop_count = 0;
 			p->signal->group_exit_code = 0;
 		} else {
 			/*

--ZPt4rx8FFjLCG7dd--

