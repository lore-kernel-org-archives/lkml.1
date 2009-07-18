Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZGRJgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZGRJgC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZGRJgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:36:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47019 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZGRJgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:36:00 -0400
Date: Sat, 18 Jul 2009 11:35:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Add alignment-faults and
	emulation-faults sw events
Message-ID: <20090718093500.GC9142@elte.hu>
References: <20090706120815.GC4391@kryten> <20090710093757.GG27445@elte.hu> <20090715120319.GE9805@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715120319.GE9805@kryten>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Anton Blanchard <anton@samba.org> wrote:

> Hi Ingo,
> 
> > Looks useful.
> > 
> > I'm wondering about the enumeration space: in other cases when 
> > some simple event was further refined we went to add a new 
> > perf_type_id and a separate enumeration space, with no limits to 
> > extensibility. We'd have a new 'enum perf_sw_fault_id' space.
> > 
> > Page faults are special anyway, because they carry a 'data' 
> > (faulting address) sample as well.
> > 
> > So i'm wondering how a good, generic enumeration of all things 
> > page faults would look like. If we extend perf_sw_ids linearly 
> > we might lose some structure.
> > 
> > For example major versus minor might be a dimension (bit) in the 
> > enumeration space, so we'd have:
> > 
> >    { major | minor } x { native, unaligned, emulated }
> > 
> > This provides an advantage already: the current 'all' page 
> > faults counter would become the 'major|minor' case in the new 
> > enumeration.
> > 
> > We could still keep around the old events as well for some time, 
> > but the tools would use the new enumeration.
> 
> My initial feeling is that emulation and alignment faults 
> shouldn't roll up into page faults, because that may cause cause 
> someone to think the problem is something to do with translation. 
> I don't have a strong opinion on it however :)

I have no strong feelings either so please pick the variant that 
feels most natural. I do think we should try to generalize it a bit 
and move it into its own enumeration space, out of the generic sw 
counters - do you agree with that?

> Since we are talking about SW events, I thought I'd bring up some 
> ideas I was discussing with Paul the other day. The hardware guys 
> like to build CPI stacks, basically breaking down the CPI into its 
> components (CPI due to TLB misses, CPI due to dcache misses etc). 
> This offers a great high level view of what needs to be fixed in 
> order to improve performance.
> 
> Taking a step back, it would be great if we could have enough SW 
> events and counters to be able to do this at the kernel level. A 
> few events/counters that come to mind are cputime lost due to 
> swap, IO initiated by the process, interrupts and other processes 
> being scheduled. I wonder if the delay accounting code has 
> anything we can reuse for this.
> 
> With these events we could simply run perf stat and instantly see 
> what needs fixing at both the cpu level (via CPI analysis) and at 
> the kernel level (via SW counters).

Yeah, i like this direction.

Mind extending your patch-set in this way, and also do the more 
structured pagefault enumeration thing? (unless you have better 
suggestions)

Thanks,

	Ingo
