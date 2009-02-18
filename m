Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZBRQky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZBRQky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZBRQkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:40:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZBRQkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:40:45 -0500
Date: Wed, 18 Feb 2009 18:37:22 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090218163722.GJ26845@redhat.com>
References: <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <20090218162116.GC29863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090218162116.GC29863@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 05:21:16PM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Wed, 18 Feb 2009, Nick Piggin wrote:
> > > 
> > > I agree with you both that we *should* make arch interrupt code
> > > do the ordering, but given the subtle lockups on some architectures
> > > in this new code, I didn't want to make it significantly weaker...
> > > 
> > > Though perhaps it appears that I have, if I have removed an smp_mb
> > > that x86 was relying on to emit an mfence to serialise the apic.
> > 
> > The thing is, if the architecture doesn't order IPI wrt cache coherency, 
> > then the "smp_mb()" doesn't really do so _either_. 
> > 
> > It might hide some architecture-specific implementation issue, of course, 
> > so random amounts of "smp_mb()"s sprinkled around might well make some 
> > architecture "work", but it's in no way guaranteed. A smp_mb() does not 
> > guarantee that some separate IPI network is ordered - that may well take 
> > some random machine-specific IO cycle.
> > 
> > That said, at least on x86, taking an interrupt should be a serializing 
> > event, so there should be no reason for anything on the receiving side. 
> > The _sending_ side might need to make sure that there is serialization 
> > when generating the IPI (so that the IPI cannot happen while the writes 
> > are still in some per-CPU write buffer and haven't become part of the 
> > cache coherency domain).
> > 
> > And at least on x86 it's actually pretty hard to generate out-of-order 
> > accesses to begin with (_regardless_ of any issues external to the CPU). 
> > You have to work at it, and use a WC memory area, and I'm pretty sure we 
> > use UC for the apic accesses.
> 
> yeah, we do. I do remember one x2apic related memory ordering 
> bug though which happened in the past 6 months or so, lemme find 
> the commit.
> 
> This one is it:
> 
>   d6f0f39: x86: add smp_mb() before sending INVALIDATE_TLB_VECTOR
> 
> attached below.
> 
> The reason for that is that x2apic changes the access sequence 
> from mmio (which old lapic used to be, and which was mapped UC), 
> to an MSR sequence:
> 
>  static inline void native_x2apic_icr_write(u32 low, u32 id)
>  {
>          wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
>  }
> 
> But ... WRMSR should already be serializing - it is documented 
> as a serializing instruction.
> 
FWIW that is what Intel docs says:

To allow for efficient access to the APIC registers in x2APIC mode,
the serializing semantics of WRMSR are relaxed when writing to the APIC
registers. Thus, system software should not use “WRMSR to APIC registers
in x2APIC mode” as a serializing instruction. Read and write accesses
to the APIC registers will occur in program order.

> I've cc:-ed Suresh & other APIC experts - exactly what type of 
> hang did that patch fix? Do certain CPUs perhaps cut 
> serialization corners, to speed up x2apic accesses?
> 
> 	Ingo
> 
> ------------------->
> >From d6f0f39b7d05e62b347c4352d070e4afb3ade4b5 Mon Sep 17 00:00:00 2001
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Date: Tue, 4 Nov 2008 13:53:04 -0800
> Subject: [PATCH] x86: add smp_mb() before sending INVALIDATE_TLB_VECTOR
> 
> Impact: fix rare x2apic hang
> 
> On x86, x2apic mode accesses for sending IPI's don't have serializing
> semantics. If the IPI receivner refers(in lock-free fashion) to some
> memory setup by the sender, the need for smp_mb() before sending the
> IPI becomes critical in x2apic mode.
> 
> Add the smp_mb() in native_flush_tlb_others() before sending the IPI.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/tlb_32.c |    6 ++++++
>  arch/x86/kernel/tlb_64.c |    5 +++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
> index e00534b..f4049f3 100644
> --- a/arch/x86/kernel/tlb_32.c
> +++ b/arch/x86/kernel/tlb_32.c
> @@ -154,6 +154,12 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
>  	flush_mm = mm;
>  	flush_va = va;
>  	cpus_or(flush_cpumask, cpumask, flush_cpumask);
> +
> +	/*
> +	 * Make the above memory operations globally visible before
> +	 * sending the IPI.
> +	 */
> +	smp_mb();
>  	/*
>  	 * We have to send the IPI only to
>  	 * CPUs affected.
> diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
> index dcbf7a1..8f919ca 100644
> --- a/arch/x86/kernel/tlb_64.c
> +++ b/arch/x86/kernel/tlb_64.c
> @@ -183,6 +183,11 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
>  	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
>  
>  	/*
> +	 * Make the above memory operations globally visible before
> +	 * sending the IPI.
> +	 */
> +	smp_mb();
> +	/*
>  	 * We have to send the IPI only to
>  	 * CPUs affected.
>  	 */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
