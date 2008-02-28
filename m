Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYB1P1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYB1P1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYB1P1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:27:11 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:36202 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYB1P1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:27:10 -0500
Date: Thu, 28 Feb 2008 18:30:43 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080228153043.GA11484@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228102649.071572700FD@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Roland McGrath wrote:
>
> -static void handle_stop_signal(int sig, struct task_struct *p)
> +static int prepare_signal(int sig, struct task_struct *p)
>  {
>  	struct task_struct *t;
> +	int cont = 0;
>  
>  	if (p->signal->flags & SIGNAL_GROUP_EXIT)
>  		/*
>  		 * The process is in the middle of dying already.
>  		 */
> -		return;
> +		return cont;
>  
>  	if (sig_kernel_stop(sig)) {
>  		/*
> @@ -635,11 +639,9 @@ static void handle_stop_signal(int sig, struct task_struct *p)
>  			 * We were in fact stopped, and are now continued.
>  			 * Notify the parent with CLD_CONTINUED.
>  			 */
> +			cont = 1;
>  			p->signal->flags = SIGNAL_STOP_CONTINUED;
>  			p->signal->group_exit_code = 0;
> -			spin_unlock(&p->sighand->siglock);
> -			do_notify_parent_cldstop(p, CLD_CONTINUED);
> -			spin_lock(&p->sighand->siglock);
>  		} else {

Oh, I'd like to suggest something simpler, but I can't :(

BTW, I think we have the same problem when handle_stop_signal() does
do_notify_parent_cldstop(p, CLD_STOPPED) above. The multithreaded app
in the middle of the group stop can resume without actually seeing
SIGCONT, no?

Currently I have the very vagues idea, please see the "patch" below
(it is not right of course, just for illustration).

These unlock(->siglock)'s on the signal sending path are really nasty,
it would be wonderfull to avoid them. Note also sig_needs_tasklist(),
we take tasklist_lock() exactly because we will probably drop siglock.

What do you think about the approach at least?

Oleg.

--- include/linux/sched.h	2008-02-15 16:59:17.000000000 +0300
+++ include/linux/sched.h	2008-02-28 18:12:20.833069408 +0300
@@ -455,6 +455,10 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	#define __CLD_STOPPED		1
+	#define	__CLD_CONTINUED		2
+	unsigned int		notify_parent;	/* can live in fact in ->flags */
+
 	/* POSIX.1b Interval Timers */
 	struct list_head posix_timers;
 
--- kernel/signal.c	2008-02-15 16:59:17.000000000 +0300
+++ kernel/signal.c	2008-02-28 18:19:01.542067371 +0300
@@ -596,9 +596,7 @@ static void handle_stop_signal(int sig, 
 			 */
 			p->signal->group_stop_count = 0;
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_STOPPED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->notify_parent |= __CLD_STOPPED;
 		}
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		t = p;
@@ -637,9 +635,7 @@ static void handle_stop_signal(int sig, 
 			 */
 			p->signal->flags = SIGNAL_STOP_CONTINUED;
 			p->signal->group_exit_code = 0;
-			spin_unlock(&p->sighand->siglock);
-			do_notify_parent_cldstop(p, CLD_CONTINUED);
-			spin_lock(&p->sighand->siglock);
+			p->signal->notify_parent |= __CLD_CONTINUED;
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
@@ -1755,6 +1751,7 @@ int get_signal_to_deliver(siginfo_t *inf
 			  struct pt_regs *regs, void *cookie)
 {
 	sigset_t *mask = &current->blocked;
+	int notify_parent;
 	int signr = 0;
 
 	try_to_freeze();
@@ -1890,7 +1887,15 @@ relock:
 		do_group_exit(signr);
 		/* NOTREACHED */
 	}
+	notify_parent = current->signal->notify_parent;
+	current->signal->notify_parent = 0;
 	spin_unlock_irq(&current->sighand->siglock);
+
+	if (notify_parent & __CLD_STOPPED)
+		do_notify_parent_cldstop(p, CLD_STOPPED);
+	if (notify_parent & __CLD_CONTINUED)
+		do_notify_parent_cldstop(p, CLD_CONTINUED);
+
 	return signr;
 }
 

