Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZFXNY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZFXNY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZFXNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:24:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZFXNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:24:48 -0400
Date: Wed, 24 Jun 2009 15:24:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624132447.GD6224@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org> <20090624124542.GB32306@elte.hu> <20090624131440.GA9700@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624131440.GA9700@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> > The main complication that such counters bring is that in their 
> > 'own metric' they do interrupt periods in an 'irregular' way 
> > (because they interrupt in the nanosec metric - being hrtimers) 
> > - but both the tools can deal with uneven periods just fine and 
> > the auto-freq code can auto-balance based on this just fine too.
> 
> How we have mostly handled these counters in the past have been 
> for long-term workload analysis. A given user wants to measure 
> certain events across the lifetime of their workload to get an 
> idea of where the hot spots are, and then send us numbers later. 
> 64-bit hardware counters give them quite a bit of time to 
> accumulate results, and in these cases precision is not so 
> important as continuous non-interactive monitoring.

Note that if i understand the constraints correctly, SH's counters 
will be _exactly_ as precise as x86 counters or PowerPC counters.

Even if SH uses a hrtimer to drive the sampling of them. [*]

The reason is that perfcounters are designed to be 'sampling 
frequency/precision invariant'. We deal with 
[delta_count,delta_time] pairs in the histograms, etc. and nothing 
assumes that periods are static.

[ And long-term analysis ('perf stat' type of runs) dont need IRQs 
  anyway - perfcounters reads outs the counts and summarizes them 
  across the measured workload. ]

Furthermore, -F (auto-freq) counters are by design variable-period 
and self-adjusting, even on x86 and PowerPC.

[ Btw., we plan to switch over the tools to use a 10 KHz auto-freq 
  sampling by default - as that gives us meaningful samples all the 
  time, regardless of how rare the underlying hardware event is. ]

	Ingo

[*] The only tradeoff is that you wont have NMI sampling. But if you 
    have _some_ sort of NMI source in SH (regardless of whether it's 
    the PMU that drives it), you can still expose that and drive 
    your perfcounter sampling via that.
