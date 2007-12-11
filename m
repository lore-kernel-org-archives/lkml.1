Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbXLKIn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbXLKIn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbXLKInv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:43:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54162 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbXLKInu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:43:50 -0500
Date: Tue, 11 Dec 2007 09:43:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071211084324.GC20172@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071210204212.GA5502@elte.hu> <20071210125923.37bd2f10.akpm@linux-foundation.org> <20071210224508.GB27178@elte.hu> <20071210230425.GA641@elte.hu> <20071211003433.5cf0230d@morte> <20071210155611.512ab381@laptopd505.fenrus.org> <20071211010125.75e2e807@inria.fr> <20071210170650.0026ad01@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210170650.0026ad01@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > That sounds like a big problem.
> 
> it'll get way worse going forward. (but even on todays systems, the 
> tsc no longer represents frequency, but is some fixed clock totally 
> unrelated to cpu frequency)

X86_FEATURE_CONSTANT_TSC CPUs (all modern Intel CPUs) should be fine - 
we dont do any TSC frequency fixups for them. The loops_per_jiffy fixup 
looks like this:

                if (!(freq->flags & CPUFREQ_CONST_LOOPS))
                        cpu_data(freq->cpu).loops_per_jiffy =
                                cpufreq_scale(loops_per_jiffy_ref,
                                                ref_freq, freq->new);

i.e. X86_FEATURE_CONSTANT_TSC excluded. The sched_clock() scaling factor 
is modified like this:

                        if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
                                tsc_khz = cpu_khz;
                                preempt_disable();
                                set_cyc2ns_scale(cpu_khz, smp_processor_id());

so here X86_FEATURE_CONSTANT_TSC is excluded again. So the whole 
frequency scaling issue will become a pure legacy issue only with time.

	Ingo
