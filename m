Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYB1QFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYB1QFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYB1QE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:04:57 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35392 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYB1QE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:04:57 -0500
Date: Thu, 28 Feb 2008 19:08:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080228160834.GA11510@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281633540.3391@jikos.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Jiri Kosina wrote:
>
> On Thu, 28 Feb 2008, Oleg Nesterov wrote:
> 
> > Currently I have the very vagues idea, please see the "patch" below (it 
> > is not right of course, just for illustration).
> > These unlock(->siglock)'s on the signal sending path are really nasty,
> > it would be wonderfull to avoid them. Note also sig_needs_tasklist(),
> > we take tasklist_lock() exactly because we will probably drop siglock.
> 
> Whould it be problematic to change do_notify_parent_cldstop() so that it 
> doesn't acquire siglock, but asumes that is is called with siglock held 
> instead? I can't immediately see any reason why this shouldn't be 
> possible.

Please note that do_notify_parent_cldstop() needs _another_ ->siglock,
the parent's one. We drop target's one because we can't take both, this
is deadlockable.

> > What do you think about the approach at least?
> 
> So it basically does the same thing my patch did -- postpones signalling 
> the parent until it is safe, right?

Well, yes and no. Yes, it postpones signalling, but actually it removes
these do_notify_parent_cldstop()'s from the senfer path completely.
Instead, this task itself (the reciever) should notify the parent.

I am still not sure this doesn't have some fundamental problems, at least
I need to think more... Actually, I hope Roland will shed a light ;)

Hmm... Can't we make a simpler patch for the start? See below.
We can notify the parent earlier, before waking the TASK_STOPPED
child. This should fix this race, no?

Oleg.


--- kernel/signal.c	2008-02-15 16:59:17.000000000 +0300
+++ kernel/signal.c	2008-02-28 19:06:16.970253164 +0300
@@ -600,6 +600,25 @@ static void handle_stop_signal(int sig, 
 			do_notify_parent_cldstop(p, CLD_STOPPED);
 			spin_lock(&p->sighand->siglock);
 		}
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
@@ -629,25 +648,6 @@ static void handle_stop_signal(int sig, 
 
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

