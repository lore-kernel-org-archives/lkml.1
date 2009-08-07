Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZHGKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZHGKbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZHGKbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:31:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56961 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZHGKbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:31:36 -0400
Date: Fri, 7 Aug 2009 12:31:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090807103127.GA23139@elte.hu>
References: <20090721155648.A17047@sedona.ch.intel.com> <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu> <20090804113555.GA28198@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com> <1249633282.32113.613.camel@twins> <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >Sent: Friday, August 07, 2009 10:21 AM
> >To: Metzger, Markus T
> >Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
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
> In case someone requests a bigger sample-period, we would use the 
> normal counter - as we do without this patch. We would also use 
> the normal counter in case BTS is not available.
> 
> In that case, we won't have BTS, we will have normal performance 
> monitoring. It will be throttled just like any other sampling 
> request with small sample_period.
> 
> If we forced sample_period = 1 for 
> PERF_COUNT_HW_BRANCH_INSTRUCTIONS, we would remove functionality.

i'm inclined to agree with you.

period=1 branch execution sampling without BTS might be seriously 
limited, but it could still be (borderline) applied to user mode 
tasks and the result ought to be usable as a crude poor man's trace 
of execution. So no matter how sucky it may be, we shouldnt limit 
it.

	Ingo
