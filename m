Return-Path: <linux-kernel-owner+w=401wt.eu-S1765267AbYCDS5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765267AbYCDS5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbYCDSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:54:28 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:50732 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbYCDSy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:54:26 -0500
Date: Tue, 4 Mar 2008 21:57:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 1/2] signals: re-assign CLD_CONTINUED notification from the sender to reciever
Message-ID: <20080304185744.GA8479@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on discussion with Jiri and Roland.

In short: currently handle_stop_signal(SIGCONT, p) sends the notification
to p->parent, with this patch p itself notifies its parent when it becomes
running.

handle_stop_signal(SIGCONT) has to drop ->siglock temporary in order to
notify the parent with do_notify_parent_cldstop(). This leads to multiple
problems:

	- as Jiri Kosina pointed out, the stopped task can resume without
	  actually seeing SIGCONT which may have a handler.

	- we race with another sig_kernel_stop() signal which may come in
	  that window.

	- we race with sig_fatal() signals which may set SIGNAL_GROUP_EXIT
	  in that window.

	- we can't avoid taking tasklist_lock() while sending SIGCONT.

With this patch handle_stop_signal() just sets the new SIGNAL_CLD_CONTINUED
flag in p->signal->flags and returns. The notification is sent by the first
task which returns from finish_stop() (there should be at least one) or any
other signalled thread from get_signal_to_deliver().

This is a user-visible change. Say, currently kill(SIGCONT, stopped_child)
can't return without seeing SIGCHLD, with this patch SIGCHLD can be delayed
unpredictably. Another oddity is that if the child is ptraced by another
process, CLD_CONTINUED may be delivered to ->real_parent after ptrace_detach().
Hopefully these problems are minor.

The patch asks for the futher obvious cleanups, I'll send them separately.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    6 ++++++
 kernel/signal.c       |   29 +++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

--- 25/include/linux/sched.h~1_SIGCONT_IMPL	2008-03-02 15:35:23.000000000 +0300
+++ 25/include/linux/sched.h	2008-03-03 17:06:53.000000000 +0300
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
--- 25/kernel/signal.c~1_SIGCONT_IMPL	2008-03-02 15:35:23.000000000 +0300
+++ 25/kernel/signal.c	2008-03-03 17:06:53.000000000 +0300
@@ -596,10 +596,8 @@ static void handle_stop_signal(int sig, 
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
@@ -636,25 +634,23 @@ static void handle_stop_signal(int sig, 
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
 
@@ -1758,6 +1754,19 @@ int get_signal_to_deliver(siginfo_t *inf
 
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
 

