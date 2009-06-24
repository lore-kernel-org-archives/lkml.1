Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZFXMiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZFXMiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZFXMiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:38:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZFXMiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:38:00 -0400
Date: Wed, 24 Jun 2009 14:37:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624123755.GA32306@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624121750.GB20564@elte.hu> <20090624122533.GA9510@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624122533.GA9510@linux-sh.org>
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

> On Wed, Jun 24, 2009 at 02:17:50PM +0200, Ingo Molnar wrote:
> > 
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > In practice oprofile has never been a good fit for these sorts of 
> > > counters, so this has fairly limited use. If there's a way to 
> > > wiggle these types of counters in to the new perf_counter API, 
> > > then I'll convert that over and just kill the old oprofile driver 
> > > off completely. Barring that, I'll just end up converting it over 
> > > to hrtimers as well, so don't let that stop you from ripping out 
> > > the timer hook bits.
> > > 
> > > Most of this code predates hrtimers anyways, and it also predates 
> > > the timer hook, which is only something that we converted to some 
> > > years back.
> > 
> > Note, the current initial upstream SH support for perfcounters:
> > 
> >  arch/sh/include/asm/perf_counter.h:#define set_perf_counter_pending()	do { } while (0)
> >  arch/sh/include/asm/unistd_32.h:#define __NR_perf_counter_open	336
> >  arch/sh/include/asm/unistd_64.h:#define __NR_perf_counter_open	364
> >  arch/sh/kernel/syscalls_32.S:	.long sys_perf_counter_open
> >  arch/sh/kernel/syscalls_64.S:	.long sys_perf_counter_open
> > 
> > Should already give you hrtimers straight away.
> > 
> > To test it, could you try to run 'perf top' after:
> > 
> > 	cd tools/perf/
> > 	make install
> > 
> > It should display a hrtimer driven kernel profile already. You can 
> > increase/decrease the frequency of sampling by using -F option - say 
> > 'perf top -F 10000' should sample at 10 KHz.
> > 
> > Please let me know if any of this does not work as expected.
> 
> Yes, that all works fine. [...]

Great! :)

> [...] My comment was more in reference to the hardware performance 
> counters that don't have IRQs of their own, which still need to be 
> tied in to the perf_counter API.

Yeah. Note that you dont have to implement explicit interrupts 
support for that (especially if it's non-existent in the hardware): 
just implement the enable/disable and read methods, and then you can 
sample based on that counter by using it together in a counter-group 
with a sampling software-counter.

Each software-counter IRQ (hrtimer driven) will cause a sample of 
the hw counter to be emitted too.

This would work here and today.

A step further would be to librarize this in kernel/perf_counter.c 
and allow architectures to offer such 'hw backed' counters to 
user-space as a single item, under the generic enumeration:

        PERF_COUNT_HW_CPU_CYCLES                = 0,
        PERF_COUNT_HW_INSTRUCTIONS              = 1,
        PERF_COUNT_HW_CACHE_REFERENCES          = 2,
        PERF_COUNT_HW_CACHE_MISSES              = 3,
        PERF_COUNT_HW_BRANCH_INSTRUCTIONS       = 4,
        PERF_COUNT_HW_BRANCH_MISSES             = 5,

Note that with the latest tools it does not skew the results or 
profiles if the 'period metric' is not the hardware counter itself, 
but an independent hrtimer. All the tooling/reporting (perf top and 
perf report) is using event weights, so the period is an invariant. 

(and especially with self-tuning auto-freq counters the period is 
never truly constant anyway)

So for all tooling and analysis purposes such counters would be 
fully equivalent to 'real' hw counters that can generate interrupts.

	Ingo
