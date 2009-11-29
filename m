Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZK2PUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZK2PUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZK2PUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:20:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:44066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZK2PUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:20:53 -0500
Subject: Re: [PATCH] sched: Optimize branch hint in context_switch()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B128F65.40804@redhat.com>
References: <4B1262AC.8000903@klingt.org>  <4B128F65.40804@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 16:20:50 +0100
Message-ID: <1259508050.13695.160.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-29 at 17:12 +0200, Avi Kivity wrote:
> On 11/29/2009 02:01 PM, Tim Blechmann wrote:
> > Branch hint profiling on my nehalem machine showed 88%
> > incorrect branch hints:
> >
> > 42017484 326957902  88 context_switch                 sched.c              3043
> > 42038493 326953687  88 context_switch                 sched.c              3050
> >
> > @@ -3040,14 +3040,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
> >   	 */
> >   	arch_start_context_switch(prev);
> >
> > -	if (likely(!mm)) {
> > +	if (unlikely(!mm)) {
> >   		next->active_mm = oldmm;
> >   		atomic_inc(&oldmm->mm_count);
> >   		enter_lazy_tlb(oldmm, next);
> >   	} else
> >   		switch_mm(oldmm, mm, next);
> >
> > -	if (likely(!prev->mm)) {
> > +	if (unlikely(!prev->mm)) {
> >   		prev->active_mm = NULL;
> >   		rq->prev_mm = oldmm;
> >   	}
> >    
> 
> I don't think either the original or the patch is correct.  Whether or 
> not a task has an mm is entirely workload dependent, we shouldn't be 
> giving hints here.

There are reasons to still use branch hints, for example if the unlikely
branch is very expensive anyway and it pays to have the likely branch be
ever so slightly less expensive.

Now I don't think that applies here, but there are cases where such code
generation issues are the main motivator not the actual usage patterns.

