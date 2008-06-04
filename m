Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYFDSvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYFDSvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYFDSvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:51:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFDSvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:51:41 -0400
Subject: Re: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080604173318.GH3549@parisc-linux.org>
References: <20080604170905.GA10273@tv-sign.ru>
	 <20080604173318.GH3549@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 20:51:08 +0200
Message-Id: <1212605468.19205.15.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 11:33 -0600, Matthew Wilcox wrote:
> On Wed, Jun 04, 2008 at 09:09:05PM +0400, Oleg Nesterov wrote:

> > --- 26-rc2/kernel/sched.c~1_SCHED_KILLABLE	2008-05-18 15:44:18.000000000 +0400
> > +++ 26-rc2/kernel/sched.c	2008-06-04 17:42:59.000000000 +0400
> > @@ -4510,12 +4510,10 @@ need_resched_nonpreemptible:
> >  	clear_tsk_need_resched(prev);
> >  
> >  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> > -		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> > -				signal_pending(prev))) {
> > +		if (unlikely(signal_pending_state(prev->state, prev)))
> >  			prev->state = TASK_RUNNING;
> > -		} else {
> > +		else
> >  			deactivate_task(rq, prev, 1);
> > -		}
> 
> Getting rid of the extra braces is against CodingStyle:

No it doesn't.

>   Do not unnecessarily use braces where a single statement will do.
> 
>   if (condition)
>           action();
> 
>   This does not apply if one branch of a conditional statement is a single
>   statement. Use braces in both branches.
> 
>   if (condition) {
>           do_this();
>           do_that();
>   } else {
>           otherwise();
>   }

Which does not say anything about

 if (cond)
   stmt1;
 else
   stmt2;

like the above.

