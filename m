Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYB2NQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYB2NQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYB2NQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:16:29 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39918 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYB2NQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:16:28 -0500
Date: Fri, 29 Feb 2008 16:20:30 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080229132030.GA2301@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <20080228153043.GA11484@tv-sign.ru> <20080229023902.D93E12700FD@magilla.localdomain> <20080229120101.GA1410@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229120101.GA1410@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Oleg Nesterov wrote:
>
> On 02/28, Roland McGrath wrote:
> >
> > I don't dislike the direction of your flag-setting approach above.  But
> > it does introduce more new subtleties that warrant more thought.
>
> Yes sure.

Still. The more I think about it, the more I like it. It is so simple,
and allows us to do further cleanups. Please look at the patch below.
Now we don't need tasklist to send the signal.

handle_stop_signal() should be cleanuped as you pointed out, but this
patch only does the requied minimum.

I am worried about ptrace, but hopefully there is no problem.

Oleg.

--- 25/include/linux/sched.h~SIG_NP	2008-02-25 19:13:05.000000000 +0300
+++ 25/include/linux/sched.h	2008-02-29 15:38:00.000000000 +0300
@@ -455,6 +455,8 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	unsigned int		notify_parent; /* will be moved into ->flags */
+
 	/* POSIX.1b Interval Timers */
 	struct list_head posix_timers;
 
--- 25/kernel/signal.c~SIG_NP	2008-02-29 15:28:28.000000000 +0300
+++ 25/kernel/signal.c	2008-02-29 15:54:54.000000000 +0300
@@ -597,9 +597,7 @@ static void handle_stop_signal(int sig, 
 			 */
 			p->signal->group_stop_count = 0;
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_STOPPED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->notify_parent = CLD_STOPPED;
 		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
@@ -638,9 +636,7 @@ static void handle_stop_signal(int sig, 
 			 */
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->notify_parent = CLD_CONTINUED;
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
@@ -1748,6 +1744,21 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
+static int handle_notify_parent(void)
+{
+	int why = current->signal->notify_parent;
+	if (likely(!why))
+		return 0;
+	current->signal->notify_parent = 0;
+	spin_unlock_irq(&current->sighand->siglock);
+
+	read_lock(&tasklist_lock);
+	do_notify_parent_cldstop(current, why);
+	read_unlock(&tasklist_lock);
+
+	return 1;
+}
+
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
 {
@@ -1761,6 +1772,9 @@ relock:
 	for (;;) {
 		struct k_sigaction *ka;
 
+		if (unlikely(handle_notify_parent()))
+			goto relock;
+
 		if (unlikely(current->signal->group_stop_count > 0) &&
 		    do_signal_stop(0))
 			goto relock;

