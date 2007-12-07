Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbXLGVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbXLGVLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXLGVLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:11:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40239 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXLGVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:11:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, ak@suse.de, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
	<20071204163946.63ac73ce.akpm@linux-foundation.org>
	<20071205094837.GB17911@elte.hu> <200712062141.05195.lenb@kernel.org>
	<m1mysmqprt.fsf@ebiederm.dsl.xmission.com>
	<20071207202613.GA18700@elte.hu>
Date: Fri, 07 Dec 2007 14:09:08 -0700
In-Reply-To: <20071207202613.GA18700@elte.hu> (Ingo Molnar's message of "Fri,
	7 Dec 2007 21:26:13 +0100")
Message-ID: <m1ejdyqkjv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Attached below is my patch from last time I was looking at this 
>> problem, it doesn't quite apply but it is gives a good idea of where I 
>> think we should go.
>
> merged it up to x86.git - see below. Alas, have no tried to build, let 
> alone boot it. Does it look good to you?

Well the forward port looks good.  Assuming nothing has changed in
this area since February we should be good.

We have one now unnecessary definition of IRQ_VECTORS in irqs-64.h

Nothing actually changes with the patch below until we actually
disable the irq compression.


> ----------------->
> Subject: x83: i386 IOAPIC: de-fang IRQ compression
> From: ebiederm@xmission.com (Eric W. Biederman)
>
> Due to hardware and software implementation limits the i386 kernel
> can only use 224 or so different IRQs at one time.  However except
> for actually having the irqs delivered there are no limits except
> the arbitrary number NR_IRQS on how many irqs we can talk about
> and deal with.
>
> Frequently not all io_apics inputs are connected to interrupt traces
> going to real devices, and since even when they are devices don't
>  always use all of interrupt traces routed to them.  So it makes
> sense to be able to talk about many more irq sources then we can
> actually use.
>
> So this patch consolidates NR_IRQS and NR_IRQ_VECTORS into just
> NR_IRQS and raises NR_IRQS where appropriate above the number of
> irqs we can use at one time.
>
> Allowing the kernel to work on big machines without complicated
> and error prone irq remapping logic.
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/acpi/boot.c                       |    4 ++--
>  arch/x86/kernel/io_apic_32.c                      |    4 ++--
>  include/asm-x86/mach-default/irq_vectors_limits.h |    8 +++-----
>  include/asm-x86/mach-generic/irq_vectors_limits.h |    3 +--
>  include/asm-x86/mach-summit/irq_vectors_limits.h  |    3 +--
>  include/asm-x86/mach-visws/irq_vectors.h          |    1 -
>  include/asm-x86/mach-voyager/irq_vectors.h        |    1 -
>  7 files changed, 9 insertions(+), 15 deletions(-)
>
> Index: linux-x86.q/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-x86.q/arch/x86/kernel/acpi/boot.c
> @@ -855,7 +855,7 @@ static int __init acpi_parse_madt_ioapic
>  
>  	count =
>  	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
> acpi_parse_int_src_ovr,
> -				  NR_IRQ_VECTORS);
> +				  NR_IRQS);
>  	if (count < 0) {
>  		printk(KERN_ERR PREFIX
>  		       "Error parsing interrupt source overrides entry\n");
> @@ -875,7 +875,7 @@ static int __init acpi_parse_madt_ioapic
>  
>  	count =
>  	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
> -				  NR_IRQ_VECTORS);
> +				  NR_IRQS);
>  	if (count < 0) {
>  		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
>  		/* TBD: Cleanup to allow fallback to MPS */
> Index: linux-x86.q/arch/x86/kernel/io_apic_32.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/io_apic_32.c
> +++ linux-x86.q/arch/x86/kernel/io_apic_32.c
> @@ -1191,14 +1191,14 @@ static inline int IO_APIC_irq_trigger(in
>  }
>  
>  /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
> -static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0
> };
> +static u8 irq_vector[NR_IRQS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
>  
>  static int __assign_irq_vector(int irq)
>  {
>  	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
>  	int vector, offset;
>  
> -	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
> +	BUG_ON((unsigned)irq >= NR_IRQS);
>  
>  	if (irq_vector[irq] > 0)
>  		return irq_vector[irq];
> Index: linux-x86.q/include/asm-x86/mach-default/irq_vectors_limits.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/mach-default/irq_vectors_limits.h
> +++ linux-x86.q/include/asm-x86/mach-default/irq_vectors_limits.h
> @@ -2,15 +2,13 @@
>  #define _ASM_IRQ_VECTORS_LIMITS_H
>  
>  #if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT)
> -#define NR_IRQS 224
> -# if (224 >= 32 * NR_CPUS)
> -# define NR_IRQ_VECTORS NR_IRQS
> +# if (200 >= 32 * NR_CPUS)
> +#  define NR_IRQS 200
>  # else
> -# define NR_IRQ_VECTORS (32 * NR_CPUS)
> +#  define NR_IRQS (32 * NR_CPUS)
>  # endif
>  #else
>  #define NR_IRQS 16
> -#define NR_IRQ_VECTORS NR_IRQS
>  #endif
>  
>  #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
> Index: linux-x86.q/include/asm-x86/mach-generic/irq_vectors_limits.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/mach-generic/irq_vectors_limits.h
> +++ linux-x86.q/include/asm-x86/mach-generic/irq_vectors_limits.h
> @@ -8,7 +8,6 @@
>   * This value should be the same in both the generic and summit subarches.
>   * Change one, change 'em both.
>   */
> -#define NR_IRQS	224
> -#define NR_IRQ_VECTORS	1024
> +#define NR_IRQS	1024
>  
>  #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
> Index: linux-x86.q/include/asm-x86/mach-summit/irq_vectors_limits.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/mach-summit/irq_vectors_limits.h
> +++ linux-x86.q/include/asm-x86/mach-summit/irq_vectors_limits.h
> @@ -8,7 +8,6 @@
>   * This value should be the same in both the generic and summit subarches.
>   * Change one, change 'em both.
>   */
> -#define NR_IRQS	224
> -#define NR_IRQ_VECTORS	1024
> +#define NR_IRQS	1024
>  
>  #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
> Index: linux-x86.q/include/asm-x86/mach-visws/irq_vectors.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/mach-visws/irq_vectors.h
> +++ linux-x86.q/include/asm-x86/mach-visws/irq_vectors.h
> @@ -51,7 +51,6 @@
>   */
>  #define NR_VECTORS 256
>  #define NR_IRQS 224
> -#define NR_IRQ_VECTORS NR_IRQS
>  
>  #define FPU_IRQ			13
>  
> Index: linux-x86.q/include/asm-x86/mach-voyager/irq_vectors.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/mach-voyager/irq_vectors.h
> +++ linux-x86.q/include/asm-x86/mach-voyager/irq_vectors.h
> @@ -57,7 +57,6 @@
>  
>  #define NR_VECTORS 256
>  #define NR_IRQS 224
> -#define NR_IRQ_VECTORS NR_IRQS
>  
>  #define FPU_IRQ				13
>  
