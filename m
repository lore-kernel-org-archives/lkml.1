Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZHGK32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZHGK32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZHGK31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:29:27 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:5294 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbZHGK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:29:27 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
	 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
	 <20090804113555.GA28198@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
	 <1249633282.32113.613.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 12:29:09 +0200
Message-Id: <1249640949.32113.647.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 11:18 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >Sent: Friday, August 07, 2009 10:21 AM
> >To: Metzger, Markus T
> >Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail..com; linux-
> >kernel@vger.kernel.org
> >Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
> >
> >On Fri, 2009-08-07 at 08:29 +0100, Metzger, Markus T wrote:
> >
> >> I incorporated Peter's review comments, except that I would not enforce sample_period == 1
> >> when branch tracing is requested. There might be users who want to sample the IP every 100.000'th
> >> branch for profiling reasons.
> >
> >But in case you don't set sample_period==1 then you won't be able to
> >match the BTS counter:
> >
> >+       if (unlikely((event ==
> >+                     x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
> >+                    (hwc->sample_period == 1)))
> >+               return X86_PMC_IDX_FIXED_BTS;
> >
> >Also,
> >
> >+               /*
> >+                * Try to use BTS for branch tracing. If that is not
> >+                * available, try to get a generic counter.
> >+                */
> >+               if (unlikely(!cpuc->ds))
> >+                       goto try_generic;
> >
> >How will be use a generic counter for BTS, will it generate an NMI for
> >every encountered branch? That might very will hit the throttle as that
> >might be many.
> >
> >Would it not be better to force sample_period==1 usage onto the BTS and
> >simply fail if its not available?
> 
> In case someone requests a bigger sample-period, we would use the normal counter - as we
> do without this patch.
> We would also use the normal counter in case BTS is not available.
> 
> In that case, we won't have BTS, we will have normal performance monitoring.
> It will be throttled just like any other sampling request with small sample_period.
> 
> If we forced sample_period = 1 for PERF_COUNT_HW_BRANCH_INSTRUCTIONS, we would remove
> functionality.

Right, what I'm worried about though is the BTS overload scenario.
Normally when we'd create more counters than we'd have hardware for we'd
simply time share the stuff.

However BTS now has a second class fallback for period==1 which
complicates all this because it will likely not generate consistent
results.

So I was thinking that _if_ the hardware supports BTS we'd not do the
fallback to generic bits if event == HW_BRANCH_INST && period == 1.

I agree on the period > 1 using the generic counters.

