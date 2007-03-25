Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXCYXDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXCYXDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCYXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:03:05 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:37406 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932794AbXCYXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:03:03 -0400
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: [patch] sched: accurate user accounting
Date: Mon, 26 Mar 2007 09:01:54 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <200703260128.09856.kernel@kolivas.org> <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703260901.54943.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 03:14, malc wrote:
> On Mon, 26 Mar 2007, Con Kolivas wrote:
> > On Monday 26 March 2007 01:19, malc wrote:
> >> On Mon, 26 Mar 2007, Con Kolivas wrote:
> >>> So before we go any further with this patch, can you try the following
> >>> one and see if this simple sanity check is enough?
> >>
> >> Sure (compiling the kernel now), too bad old axiom that testing can not
> >> confirm absence of bugs holds.
> >>
> >> I have one nit and one request from clarification. Question first (i
> >> admit i haven't looked at the surroundings of the patch maybe things
> >> would have been are self evident if i did):
> >>
> >> What this patch amounts to is that the accounting logic is moved from
> >> timer interrupt to the place where scheduler switches task (or something
> >> to that effect)?
> >
> > Both the scheduler tick and context switch now. So yes it adds overhead
> > as I said, although we already do update_cpu_clock on context switch, but
> > it's not this complex.
> >
> >> [..snip..]
> >>
> >>>  * These are the 'tuning knobs' of the scheduler:
> >>> @@ -3017,8 +3018,53 @@ EXPORT_PER_CPU_SYMBOL(kstat);
> >>> static inline void
> >>> update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long
> >>> long now) {
> >>> -	p->sched_time += now - p->last_ran;
> >>> +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> >>> +	cputime64_t time_diff;
> >>> +
> >>> 	p->last_ran = rq->most_recent_timestamp = now;
> >>> +	/* Sanity check. It should never go backwards or ruin accounting */
> >>> +	if (unlikely(now < p->last_ran))
> >>> +		return;
> >>> +	time_diff = now - p->last_ran;
> >>
> >> A nit. Anything wrong with:
> >>
> >> time_diff = now - p->last_ran;
> >> if (unlikeley (LESS_THAN_ZERO (time_diff))
> >>          return;
> >
> > Does LESS_THAN_ZERO work on a cputime64_t on all arches? I can't figure
> > that out just by looking myself which is why I did it the other way.
>
> I have no idea what type cputime64_t really is, so used this imaginary
> LESS_THAN_ZERO thing.
>
> Erm... i just looked at the code and suddenly it stopped making any sense
> at all:
>
>          p->last_ran = rq->most_recent_timestamp = now;
>          /* Sanity check. It should never go backwards or ruin accounting
> */ if (unlikely(now < p->last_ran))
>                  return;
>          time_diff = now - p->last_ran;
>
> First `now' is assigned to `p->last_ran' and the very next line
> compares those two values, and then the difference is taken.. I quite
> frankly am either very tired or fail to see the point.. time_diff is
> either always zero or there's always a race here.

Bah major thinko error on my part! That will teach me to post patches untested 
at 1:30 am. I'll try again shortly sorry.

-- 
-ck
