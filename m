Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXDPLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXDPLrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXDPLrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:47:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:49799 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXDPLrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:47:20 -0400
Date: Mon, 16 Apr 2007 15:47:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH -mm] scheduler: fix the return of the first time_slice
Message-ID: <20070416114701.GB84@tv-sign.ru>
References: <877isozllw.wl%takeuchi_satoru@jp.fujitsu.com> <20070408230927.9a49c504.akpm@linux-foundation.org> <200704140131.12500.kernel@kolivas.org> <871wilrrlz.wl%takeuchi_satoru@jp.fujitsu.com> <87wt0dq6jn.wl%takeuchi_satoru@jp.fujitsu.com> <20070416104559.GA84@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416104559.GA84@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Oleg Nesterov wrote:
>
> On 04/16, Satoru Takeuchi wrote:
> >
> > --- linux-2.6.21-rc6-mm1.tsfix.orig/kernel/exit.c	2007-04-15 16:56:12.000000000 +0900
> > +++ linux-2.6.21-rc6-mm1.tsfix/kernel/exit.c	2007-04-15 16:56:17.000000000 +0900
> > @@ -680,10 +680,14 @@
> >  			reaper = child_reaper(father);
> >  			break;
> >  		}
> > +		if (reaper->time_slice_reaper == father)
> > +			reaper->time_slice_reaper = NULL;
> >  	} while (reaper->exit_state);
> >  
> >  	list_for_each_safe(_p, _n, &father->children) {
> >  		p = list_entry(_p, struct task_struct, sibling);
> > +		if (p->time_slice_reaper == father)
> > +			p->time_slice_reaper = NULL;
> >  		choose_new_parent(p, reaper);
> >  		reparent_thread(p, father);
> >  	}
> > Index: linux-2.6.21-rc6-mm1.tsfix/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.21-rc6-mm1.tsfix.orig/kernel/sched.c	2007-04-15 16:56:12.000000000 +0900
> > +++ linux-2.6.21-rc6-mm1.tsfix/kernel/sched.c	2007-04-15 16:56:17.000000000 +0900
> > @@ -1693,7 +1693,7 @@
> >  	 * The remainder of the first timeslice might be recovered by
> >  	 * the parent if the child exits early enough.
> >  	 */
> > -	p->first_time_slice = 1;
> > +	p->time_slice_reaper = current;
> >  	p->timestamp = sched_clock();
> >  	local_irq_enable();
> 
> I am afraid this doesn't work for CLONE_THREAD. Suppose that some sub-thread (not
> main thread) T1 creates another sub-thread, T2.
> 
> 	T2->time_slice_reaper = T1.
> 
> then T1 exits, but forget_original_parent(T1) doesn't change T2->time_slice_reaper,
> because T2 is not on T1->children list. Now T2->time_slice_reaper points to an
> already freed task_struct.

In case I was not clear...

Note that "do {} while ()" loop in forget_original_parent() stops when it finds
a sub-thread with ->exit_state == 0. This means we can miss another sub-thread
which has ->time_slice_reaper == father.

To make this correct, we should iterate over all thread-group, but this can slow
down exit() when we have a lot of threads.

I guess we need Ingo's opinion on that.

Oleg.

