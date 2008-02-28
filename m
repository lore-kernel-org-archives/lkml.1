Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbYB1QmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbYB1QmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYB1Ql4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:41:56 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:45724 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbYB1Qlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:41:55 -0500
Date: Thu, 28 Feb 2008 19:45:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] handle_stop_signal: don't wake up the stopped task until it sees SIGCONT
Message-ID: <20080228164529.GA12695@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz> <20080228160834.GA11510@tv-sign.ru> <Pine.LNX.4.64.0802281711500.3391@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281711500.3391@jikos.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Jiri Kosina wrote:
>
> On Thu, 28 Feb 2008, Oleg Nesterov wrote:
> 
> > Hmm... Can't we make a simpler patch for the start? See below.
> > We can notify the parent earlier, before waking the TASK_STOPPED
> > child. This should fix this race, no?
> 
> Yes, this looks also like a correct fix to me (haven't tried to run the 
> actual test yet, but 'obviously' it should close the race).

Thanks, please ack this patch unless you have any objections.

I tested this patch with Jiri's test-case, seems to work.
The Roland's review is still needed ;)

-------------------------------------------------------------------------------
[PATCH] handle_stop_signal: don't wake up the stopped task until it sees SIGCONT

The bug was found by Jiri Kosina <jkosina@suse.cz>, and the patch is based
on his ideas.

handle_stop_signal(SIGCONT) wakes up the stopped task and unlocks ->siglock
for do_notify_parent_cldstop(p, CLD_CONTINUED). The woken task returns from
do_signal_stop(), takes ->siglock and resumes to user-space without actually
seeing SIGCONT which may have a handler.

Move the code realated to do_notify_parent_cldstop(CLD_CONTINUED) up, before
"wake_up_state(t, state)".

NOTE: It is possible that the subsequent rm_from_queue(SIG_KERNEL_STOP_MASK)
removes SIGSTOP which comes after SIGCONT when we drop ->siglock. Not nice,
but possible even without this change. Hopefully we can remove the parent
notifying code from the sender path completely, but this needs more thinking.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~HSS_SIGCONT_RACE	2008-02-28 19:22:32.000000000 +0300
+++ 25/kernel/signal.c	2008-02-28 19:27:52.000000000 +0300
@@ -601,12 +601,31 @@ static void handle_stop_signal(int sig, 
 			do_notify_parent_cldstop(p, CLD_STOPPED);
 			spin_lock(&p->sighand->siglock);
 		}
+
+		if (p->signal->flags & SIGNAL_STOP_STOPPED) {
+			/*
+			 * We were in fact stopped, and are now continued.
+			 * Notify the parent with CLD_CONTINUED.
+			 */
+			p->signal->flags = SIGNAL_STOP_CONTINUED;
+			p->signal->group_exit_code = 0;
+			spin_unlock(&p->sighand->siglock);
+			do_notify_parent_cldstop(p, CLD_CONTINUED);
+			spin_lock(&p->sighand->siglock);
+		} else {
+			/*
+			 * We are not stopped, but there could be a stop
+			 * signal in the middle of being processed after
+			 * being removed from the queue.  Clear that too.
+			 */
+			p->signal->flags = 0;
+		}
+
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
 		do {
 			unsigned int state;
 			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
-			
 			/*
 			 * If there is a handler for SIGCONT, we must make
 			 * sure that no thread returns to user mode before
@@ -630,25 +649,6 @@ static void handle_stop_signal(int sig, 
 
 			t = next_thread(t);
 		} while (t != p);
-
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

