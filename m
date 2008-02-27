Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYB0PWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYB0PWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYB0PWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:22:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:48305 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766AbYB0PWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:22:08 -0500
Date: Wed, 27 Feb 2008 16:22:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SIGCONT-handling related comment in handle_stop_signal() states:

                         * If there is a handler for SIGCONT, we must make
                         * sure that no thread returns to user mode before
                         * we post the signal, in case it was the only
                         * thread eligible to run the signal handler--then
                         * it must not do anything between resuming and
                         * running the handler.  With the TIF_SIGPENDING
                         * flag set, the thread will pause and acquire the
                         * siglock that we hold now and until we've queued
                         * the pending signal.
                         *
                         * Wake up the stopped thread _after_ setting
                         * TIF_SIGPENDING

Unfortunately, just a few lines below, the siglock is unlocked for a short 
time, in order to call 

	do_notify_parent_cldstop(p, CLD_CONTINUED);

Therefore the synchronization on siglock doesn't work properly. If the 
task is waiting on siglock and gets scheduled when the siglock is 
unlocked, but before SIGCONT is queued (this is done later, after 
handle_stop_signal() finishes), the process misses the SIGCONT signal (as 
it has already run, but SIGCONT has not been queued yet).

This patch solves it by postponing the do_notify_parent_cldstop() call 
(and therefore also unlocking of siglock) until the SIGCONT is properly 
queued on the shared-pending queue, and therefore it is not missed by the 
process' SIGCONT handler. Also updates the callsites.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..24786ba 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -556,6 +556,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
  * actual continuing for SIGCONT, but not the actual stopping for stop
  * signals.  The process stop is done as a signal action for SIG_DFL.
  */
+
 static void handle_stop_signal(int sig, struct task_struct *p)
 {
 	struct task_struct *t;
@@ -630,24 +631,6 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 			t = next_thread(t);
 		} while (t != p);
 
-		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
-			/*
-			 * We were in fact stopped, and are now continued.
-			 * Notify the parent with CLD_CONTINUED.
-			 */
-			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
-		} else {
-			/*
-			 * We are not stopped, but there could be a stop
-			 * signal in the middle of being processed after
-			 * being removed from the queue.  Clear that too.
-			 */
-			p->signal->flags = 0;
-		}
 	} else if (sig == SIGKILL) {
 		/*
 		 * Make sure that any pending stop signal already dequeued
@@ -657,6 +640,43 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 	}
 }
 
+/* This must not be called before the SIGCONT has been queued, otherwise
+ * the userspace task (waiting on siglock) might run too soon and miss
+ * the SIGCONT.
+ */
+static void handle_stop_signal_finish(int sig, struct task_struct *p)
+{
+
+	if (p->signal->flags & SIGNAL_GROUP_EXIT)
+		/*
+		 * The process is in the middle of dying already.
+		 */
+		return;
+
+	if (sig != SIGCONT)
+		return;
+
+	if (p->signal->flags & SIGNAL_STOP_STOPPED) {
+		/*
+		 * We were in fact stopped, and are now continued.
+		 * Notify the parent with CLD_CONTINUED.
+		 */
+		p->signal->flags = SIGNAL_STOP_CONTINUED;
+		p->signal->group_exit_code = 0;
+		spin_unlock(&p->sighand->siglock);
+		do_notify_parent_cldstop(p, CLD_CONTINUED);
+		spin_lock(&p->sighand->siglock);
+	} else {
+		/*
+		 * We are not stopped, but there could be a stop
+		 * signal in the middle of being processed after
+		 * being removed from the queue.  Clear that too.
+		 */
+		p->signal->flags = 0;
+	}
+}
+
+
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
@@ -946,6 +966,8 @@ __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	if (unlikely(ret))
 		return ret;
 
+	handle_stop_signal_finish(sig, p);
+
 	__group_complete_signal(sig, p);
 	return 0;
 }
@@ -1389,6 +1411,8 @@ send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	list_add_tail(&q->list, &p->signal->shared_pending.list);
 	sigaddset(&p->signal->shared_pending.signal, sig);
 
+	handle_stop_signal_finish(sig, p);
+
 	__group_complete_signal(sig, p);
 out:
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
