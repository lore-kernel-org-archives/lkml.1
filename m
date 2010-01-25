Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812Ab0AYPBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0AYPBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540Ab0AYPBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:01:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:44279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab0AYPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:01:14 -0500
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v6
 incremental)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <1264192074.4283.1602.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 16:01:01 +0100
Message-ID: <1264431661.4283.1924.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 21:27 +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-21 at 17:39 +0200, Stephane Eranian wrote:
> > @@ -1395,40 +1430,28 @@ void hw_perf_enable(void)
> >                  * apply assignment obtained either from
> >                  * hw_perf_group_sched_in() or x86_pmu_enable()
> >                  *
> > -                * step1: save events moving to new counters
> > -                * step2: reprogram moved events into new counters
> > +                * We either re-enable or re-program and re-enable.
> > +                * All events are disabled by the time we come here.
> > +                * That means their state has been saved already.
> >                  */
> 
> I'm not seeing how it is true.
> 
> Suppose a core2 with counter0 active counting a non-restricted event,
> say cpu_cycles. Then we do:
> 
> perf_disable()
>   hw_perf_disable()
>     intel_pmu_disable_all
>       wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> 
> ->enable(MEM_LOAD_RETIRED) /* constrained to counter0 */
>   x86_pmu_enable()
>     collect_events()
>     x86_schedule_events()
>     n_added = 1
> 
>     /* also slightly confused about this */
>     if (hwc->idx != -1)
>       x86_perf_event_set_period()
> 
> perf_enable()
>   hw_perf_enable()
> 
>     /* and here we'll assign the new event to counter0
>      * except we never disabled it... */
> 
>     intel_pmu_enable_all()
>       wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, intel_ctrl)
> 
> Or am I missing something?
> 
> >                 for(i=0; i < cpuc->n_events; i++) {
> >  
> >                         event = cpuc->event_list[i];
> >                         hwc = &event->hw;
> >  
> > -                       if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
> > -                               continue;
> > -
> > -                       x86_pmu.disable(hwc, hwc->idx);
> > -
> > -                       clear_bit(hwc->idx, cpuc->active_mask);
> > -                       barrier();
> > -                       cpuc->events[hwc->idx] = NULL;
> > -
> > -                       x86_perf_event_update(event, hwc, hwc->idx);
> > -
> > -                       hwc->idx = -1;
> > -               }
> > -

I've split your -v6 delta in two, one part doing that fastpath
scheduling, and one part this hw_perf_enable optimization, for now I've
dropped the second part.

On top of that I did a patch that shares the above code with
x86_pmu_disable() so that we don't have that sequence twice.




