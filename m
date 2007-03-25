Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbXCYP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbXCYP2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXCYP2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:28:34 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:33102 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbXCYP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:28:33 -0400
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: [patch] sched: accurate user accounting
Date: Mon, 26 Mar 2007 01:28:09 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <200703260108.22239.kernel@kolivas.org> <Pine.LNX.4.64.0703251914110.9659@linmac.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0703251914110.9659@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260128.09856.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 01:19, malc wrote:
> On Mon, 26 Mar 2007, Con Kolivas wrote:
> > So before we go any further with this patch, can you try the following
> > one and see if this simple sanity check is enough?
>
> Sure (compiling the kernel now), too bad old axiom that testing can not
> confirm absence of bugs holds.
>
> I have one nit and one request from clarification. Question first (i
> admit i haven't looked at the surroundings of the patch maybe things
> would have been are self evident if i did):
>
> What this patch amounts to is that the accounting logic is moved from
> timer interrupt to the place where scheduler switches task (or something
> to that effect)?

Both the scheduler tick and context switch now. So yes it adds overhead as I 
said, although we already do update_cpu_clock on context switch, but it's not 
this complex.

> [..snip..]
>
> >  * These are the 'tuning knobs' of the scheduler:
> > @@ -3017,8 +3018,53 @@ EXPORT_PER_CPU_SYMBOL(kstat);
> > static inline void
> > update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long
> > now) {
> > -	p->sched_time += now - p->last_ran;
> > +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> > +	cputime64_t time_diff;
> > +
> > 	p->last_ran = rq->most_recent_timestamp = now;
> > +	/* Sanity check. It should never go backwards or ruin accounting */
> > +	if (unlikely(now < p->last_ran))
> > +		return;
> > +	time_diff = now - p->last_ran;
>
> A nit. Anything wrong with:
>
> time_diff = now - p->last_ran;
> if (unlikeley (LESS_THAN_ZERO (time_diff))
>          return;

Does LESS_THAN_ZERO work on a cputime64_t on all arches? I can't figure that 
out just by looking myself which is why I did it the other way.

-- 
-ck
