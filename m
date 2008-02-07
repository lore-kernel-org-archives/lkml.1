Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYBGKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYBGKRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbYBGKRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:17:33 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbYBGKRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:17:32 -0500
Date: Thu, 7 Feb 2008 11:17:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de
Subject: Re: [PATCH 4/8] x86: add support for remotely triggering the block  softirq
Message-ID: <20080207101727.GE15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207100738.GB7716@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  arch/x86/kernel/smp_32.c                   |   15 +++++++++++++++
> >  arch/x86/kernel/smpboot_32.c               |    3 +++
> >  include/asm-x86/hw_irq_32.h                |    1 +
> >  include/asm-x86/mach-default/entry_arch.h  |    1 +
> >  include/asm-x86/mach-default/irq_vectors.h |    1 +
> >  5 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
> > index dc0cde9..668b8a4 100644
> > --- a/arch/x86/kernel/smp_32.c
> > +++ b/arch/x86/kernel/smp_32.c
> > @@ -672,6 +672,21 @@ void smp_call_function_interrupt(struct pt_regs *regs)
> >  	}
> >  }
> >  
> > +fastcall void smp_raise_block_softirq(struct pt_regs *regs)
> 
> small detail: there's no fastcall used in arch/x86 anymore.

Yeah, andrew already complained about that, fixed up.

> > +{
> > +	unsigned long flags;
> > +
> > +	ack_APIC_irq();
> > +	local_irq_save(flags);
> > +	raise_softirq_irqoff(BLOCK_SOFTIRQ);
> > +	local_irq_restore(flags);
> > +}
> 
> if then this should be a general facility to trigger any softirq - not 
> just the block one.

Oh yeah, definitely agree, I wrote that in the intro as well. The
interface is horrible, not meant to go anywhere, just serve for testing.

> >  #define CALL_FUNCTION_VECTOR	0xfb
> > +#define BLOCK_SOFTIRQ_VECTOR	0xfa
> 
> this wastes another irq vector and is very special-purpose. Why not make 
> the smp_call_function() one more scalable instead?

That's definitely a possibility, Nick had something like that. I just
didn't like having to allocate a cookie object to store the function and
data.

> on the more conceptual level, shouldnt we just move to threads instead 
> of softirqs? That way you can become affine to any CPU and can do 
> cross-CPU wakeups anytime - which will be nice and fast via the 
> smp_reschedule_interrupt() facility.

That would indeed be nicer and not require any arch changes. I was
afraid it would be more costly than massaging the softirqs a bit though,
perhaps that is unfounded.

-- 
Jens Axboe

