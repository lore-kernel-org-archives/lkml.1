Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0CKLwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:52:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553Ab0CKLwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:52:50 -0500
Date: Thu, 11 Mar 2010 12:52:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com, davem@davemloft.net,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf_events: add sampling period randomization support
 (v2)
Message-ID: <20100311115214.GD31354@elte.hu>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
 <20100304113212.GG21977@elte.hu>
 <bd4cb8901003040925t28ddcc5bmfce11dcfa8b9b0ba@mail.gmail.com>
 <20100304211332.GA3643@elte.hu>
 <bd4cb8901003041834l61bc510er21c9da4de8639d9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901003041834l61bc510er21c9da4de8639d9b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Thu, Mar 4, 2010 at 1:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> On Thu, Mar 4, 2010 at 3:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * eranian@google.com <eranian@google.com> wrote:
> >> >
> >> >> This patch adds support for randomizing the sampling period. ??Randomization
> >> >> is very useful to mitigate the bias that exists with sampling. The random
> >> >> number generator does not need to be sophisticated. This patch uses the
> >> >> builtin random32() generator.
> >> >
> >> >> + ?? ?? if (width > 63 || attr->freq)
> >> >> + ?? ?? ?? ?? ?? ?? return -EINVAL;
> >> >
> >> > Why not for freq counters? Those are semi-randomized already, but it might
> >> > make sense to make them 'more' randomized in special circumstances. That would
> >> > also allow us to enable the randomization in perf top and perf record, by
> >> > default.
> >> >
> >>
> >> What's the goal of freq?
> >> Achieve and maintain the target interrupt/rate.
> >> In doing so, it has to adjust the period (not randomly).
> >
> > No, the goal of auto-freq is to keep a steady average rate of sampling.
>
> rate of samples = rate of interrupts (if period < 32 bits on Intel).

What's your point? I corrected your statement which said that the goal of 
auto-freq was to maintain a target interrupt-rate and as such wouldnt be 
randomizable. So i said that auto-freq is slightly different from that: it 
provides a steady _average_ rate, and as such small amounts of randomization 
'fuzz' could still be injected - the auto-freq system would auto-correct the 
effects of that.

Think of it as a dynamic steady-state equilibrium with noise injected. If the 
noise isnt too brutal and the system can adapt, the average sampling rate 
doesnt change.

> > There is no requirement to keep it 'steady' - each sample comes with a 
> > specific weight.
> >
> >> Randomization may prevent achieving the rate, or it may slow it down. 
> >> What's the value add of that?
> >
> > Why do you assume that the two are incompatible? We can randomize 
> > auto-freq and still have a perfectly stable average rate.
>
> What would that buy you compared to what you already have?

The same goal as randomization in general: to decrease the chance for sampling 
artifacts that can occur due to the sampling frequency oscillating together 
with some internal workload parameter, skewing the sample.

	Ingo
