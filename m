Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXJWOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXJWOVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXJWOUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:20:52 -0400
Received: from gw.goop.org ([64.81.55.164]:45188 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbXJWOUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:20:51 -0400
Message-ID: <471E0343.1070902@goop.org>
Date: Tue, 23 Oct 2007 07:20:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in	2.6.23-final.
References: <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu>
In-Reply-To: <20071023084546.GA17007@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>>> Should we re-add them for the function pointers in 
>>>> asm-x86/paravirt.h?
>>>>         
>>> yes, yes, yes. :-) It was a nightmare to sort it out in -rt (and 
>>> still is).
>>>       
>> Do you have a patch to do this already?
>>     
>
> yes, attached. Ack?
>
> 	Ingo
>
> ---------------------------->
> Subject: [patch] paravirt: mark assembly dependencies as fastcall
> From: Ingo Molnar <mingo@elte.hu>
>
> the 'fastcall removal' changes to paravirt.c were over-eager: they
> removed fastcall annotations from functions that are (or might be)
> implemented in assembly. So if someone changes the compiler model,
> such as -pg which disables regparm, the kernel breaks in nasty ways.
>
> so this patch adds back fastcall annotations. This serves as
> documentation for assembly calling-convention dependencies as
> well.
>   

It would be really nice if we could get the compiler to warn about
whether mismatches in fastcall use.  Without at least a compiler warning
about mismatches between the function pointer type in paravirt_ops and
the actual function, it will almost certainly rot and fail if you
actually need to depend on the annotations.

What's the issue with regparm and -pg?

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/i386/kernel/paravirt.c       |    6 -
>  arch/i386/kernel/smp.c            |    7 +
>  include/asm-i386/desc.h           |   18 ++--
>  include/asm-i386/io.h             |    2 
>  include/asm-i386/irqflags.h       |   12 +-
>  include/asm-i386/msr.h            |   13 +--
>  include/asm-i386/page.h           |   21 ++---
>  include/asm-i386/paravirt.h       |  156 +++++++++++++++++++-------------------
>  include/asm-i386/pgtable-2level.h |   10 +-
>  include/asm-i386/pgtable-3level.h |   18 ++--
>  include/asm-i386/pgtable.h        |    2 
>  include/asm-i386/processor.h      |    8 -
>  include/asm-i386/system.h         |   22 ++---
>  include/asm-i386/time.h           |    4 
>  include/asm-i386/tlbflush.h       |    4 
>  15 files changed, 154 insertions(+), 149 deletions(-)
>   

Hm,  so it will still need a fair amount of work to update to the
current kernel and add all the lguest/vmi/xen functions (and presumably
the out of tree kvm stuff too).

> Index: linux-2.6.23-rt1/arch/i386/kernel/paravirt.c
> ===================================================================
> --- linux-2.6.23-rt1.orig/arch/i386/kernel/paravirt.c	2007-10-11 15:58:08.000000000 -0400
> +++ linux-2.6.23-rt1/arch/i386/kernel/paravirt.c	2007-10-11 16:00:03.000000000 -0400
> @@ -208,7 +208,7 @@ void init_IRQ(void)
>  	paravirt_ops.init_IRQ();
>  }
>  
> -static void native_flush_tlb(void)
> +static fastcall void native_flush_tlb(void)
>  {
>  	__native_flush_tlb();
>  }
> @@ -217,12 +217,12 @@ static void native_flush_tlb(void)
>   * Global pages have to be flushed a bit differently. Not a real
>   * performance problem because this does not happen often.
>   */
> -static void native_flush_tlb_global(void)
> +static fastcall void native_flush_tlb_global(void)
>  {
>  	__native_flush_tlb_global();
>  }
>  
> -static void native_flush_tlb_single(unsigned long addr)
> +static fastcall void native_flush_tlb_single(unsigned long addr)
>  {
>  	__native_flush_tlb_single(addr);
>  }
> Index: linux-2.6.23-rt1/arch/i386/kernel/smp.c
> ===================================================================
> --- linux-2.6.23-rt1.orig/arch/i386/kernel/smp.c	2007-10-11 15:58:08.000000000 -0400
> +++ linux-2.6.23-rt1/arch/i386/kernel/smp.c	2007-10-11 16:00:03.000000000 -0400
> @@ -344,8 +344,9 @@ out:
>  	put_cpu_no_resched();
>  }
>  
> -void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
> -			     unsigned long va)
> +void fastcall
> +native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
> +			unsigned long va)
>  {
>  	cpumask_t cpumask = *cpumaskp;
>  
> @@ -470,6 +471,7 @@ void flush_tlb_all(void)
>   */
>  static void native_smp_send_reschedule(int cpu)
>  {
> +	trace_special(cpu, 0, 0);
>  	WARN_ON(cpu_is_offline(cpu));
>  	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
>  }
> @@ -639,6 +641,7 @@ static void native_smp_send_stop(void)
>   */
>  fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
>  {
> +	trace_special(regs->eip, 0, 0);
>  	ack_APIC_irq();
>  }
>   

What's trace_special()?  Has this escaped from another patch?

    J
