Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbXDQImH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbXDQImH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXDQImG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:42:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXDQImF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:42:05 -0400
Date: Tue, 17 Apr 2007 10:41:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417084153.GE20026@wotan.suse.de>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com> <20070417081857.GD20026@wotan.suse.de> <20070417082628.GD5076@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417082628.GD5076@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 10:26:31AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Actually I think this is something that makes sense to add, even if 
> > just for debugging, but maybe also for production, depending on how 
> > much it impacts things. Child runs first is an heuristic optimisation 
> > that exploits a VM detail (however fundamental). But for things that 
> > don't exec right after forking (and maybe some things that do), it can 
> > be nicer to reduce context switches, improve cache patterns, and allow 
> > children to be load balanced away before touching memory, if 
> > child_runs_first is turned off.
> 
> yeah, the primary intent was debug. Nick, am i confused to conclude that 
> mainline in fact runs the _parent_ first, despite all the elaborate 
> runqueue juggling we do there? This piece of code in wake_up_new_task() 
> caught my eyes:
> 
>                                 p->prio = current->prio;
>                                 p->normal_prio = current->normal_prio;
>                                 list_add_tail(&p->run_list, &current->run_list);
>                                 p->array = current->array;
>                                 p->array->nr_active++;
>                                 inc_nr_running(p, rq);
> 
> shouldnt the list_add_tail() be list_add(), so that task pickup sees the 
> child first? Maybe we still do child-runs-first in practice, due to the 
> timeslice and sleep average fixups that happen if the parent preempts, 
> but the above piece of code seems a quite elaborate way of doing 
> activate_task(). To have the child _before_ the parent we'd need the 
> add-on patch below. But ... i could be wrong, this is just a quick 
> thought.

I think that it works because the list we're adding to is not the
normal runqueue list head, but the parent's list_head on that runqueue.
Which adds the child directly ahead of the parent... I think?

> 
> 	Ingo
> 
> ---
>  kernel/sched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -1685,7 +1685,7 @@ void fastcall wake_up_new_task(struct ta
>  			else {
>  				p->prio = current->prio;
>  				p->normal_prio = current->normal_prio;
> -				list_add_tail(&p->run_list, &current->run_list);
> +				list_add(&p->run_list, &current->run_list);
>  				p->array = current->array;
>  				p->array->nr_active++;
>  				inc_nr_running(p, rq);
