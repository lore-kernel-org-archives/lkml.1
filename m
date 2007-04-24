Return-Path: <linux-kernel-owner+w=401wt.eu-S1423097AbXDXVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423097AbXDXVZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423116AbXDXVZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:25:35 -0400
Received: from ns.suse.de ([195.135.220.2]:41272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423097AbXDXVZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:25:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
Date: Tue, 24 Apr 2007 23:25:23 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>
References: <20070423215638.563901986@goop.org> <20070423215710.355105690@goop.org>
In-Reply-To: <20070423215710.355105690@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704242325.23447.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 23:56:44 Jeremy Fitzhardinge wrote:
> Core Xen Implementation
> 
> This patch is a rollup of all the core pieces of the Xen
> implementation, including booting, memory management, interrupts, time
> and so on.

The patch is definitely too big.

> +#ifdef CONFIG_XEN
> +/* Xen only supports sysenter/sysexit in ring0 guests,
> +   and only if it the guest asks for it.  So for now,
> +   this should never be used. */
> +ENTRY(xen_sti_sysexit)
> +	CFI_STARTPROC
> +	ud2
> +	CFI_ENDPROC
> +ENDPROC(xen_sti_sysexit)

Put that elsewhere? It doesn't need to be here.


> +++ b/arch/i386/xen/enlighten.c
> @@ -0,0 +1,727 @@

Comments describing what all the files do? 

> +	unsigned maskedx = ~0;
> +	if (*eax == 1)
> +		maskedx = ~((1 << X86_FEATURE_APIC) |
> +			    (1 << X86_FEATURE_ACPI) |
> +			    (1 << X86_FEATURE_ACC));

Why ACC? 

And why doesn't Xen mask those by itself?

And you got apic functions later which would be never called?
Why are the hooks needed then? 

> +
> +static unsigned long xen_save_fl(void)
> +{
> +	struct vcpu_info *vcpu;
> +	unsigned long flags;
> +
> +	preempt_disable();
> +	vcpu = x86_read_percpu(xen_vcpu);
> +	/* flag has opposite sense of mask */
> +	flags = !vcpu->evtchn_upcall_mask;
> +	preempt_enable();

If you use get_cpu/put_cpu it will be optimized away on PREEMPT && !SMP
(more occurrences)

> +static void xen_restore_fl(unsigned long flags)
> +{
> +	struct vcpu_info *vcpu;
> +
> +	preempt_disable();
> +
> +	/* convert from IF type flag */
> +	flags = !(flags & X86_EFLAGS_IF);
> +	vcpu = x86_read_percpu(xen_vcpu);
> +	vcpu->evtchn_upcall_mask = flags;
> +	if (flags == 0) {
> +		barrier(); /* unmask then check (avoid races) */

Don't you need a rmb() here then? The CPU could speculate reads
(more occurrences) 

> +		if (unlikely(vcpu->evtchn_upcall_pending))
> +			force_evtchn_callback();
> +		preempt_enable();
> +	} else
> +		preempt_enable_no_resched();
> +}
> +
> +static void xen_irq_disable(void)
> +{
> +	struct vcpu_info *vcpu;
> +	preempt_disable();
> +	vcpu = x86_read_percpu(xen_vcpu);
> +	vcpu->evtchn_upcall_mask = 1;
> +	preempt_enable_no_resched();

First with the new per cpu the preempt disable shouldn't be needed
anymore because the thing is atomic. In the worst case you do 
the change on the previous CPU, but that can happen anyways after
preempt_enable

And then when you have enabled who transfers the irq off state to the
new CPU? 


> +static void xen_halt(void)
> +{
> +#if 0
> +	if (irqs_disabled())
> +		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
> +#endif
> +}

Who halts then?

> +static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
> +{
> +	unsigned long *frames;
> +	unsigned long va = dtr->address;
> +	unsigned int size = dtr->size + 1;
> +	int f;
> +	struct multicall_space mcs;
> +
> +	BUG_ON(size > 16*PAGE_SIZE);

Why 16?

> +	count = desc->size / 8;
> +	BUG_ON(count > 256);

should be >= ?


> +static void xen_set_iopl_mask(unsigned mask)
> +{
> +#if 0
> +	struct physdev_set_iopl set_iopl;
> +
> +	/* Force the change at ring 0. */
> +	set_iopl.iopl = (mask == 0) ? 1 : (mask >> 12) & 3;
> +	HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
> +#endif

And who does iopl then?


> + * Page-directory addresses above 4GB do not fit into architectural %cr3.
> + * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
> + * must use the following accessor macros to pack/unpack valid MFNs.
> + */
> +#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
> +#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))

Don't you lose bits >4GB here due to the casts before shift?

> +	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);

Hopefully Xen 4.0 can handle this then.

> +
> +	/* Poke various useful things into boot_params */
> +	LOADER_TYPE = (9 << 4) | 0;

| 0 ? Probably should be something symbolic

> +unsigned long xen_pmd_val(pmd_t pmd)
> +{
> +	BUG();
> +	return 0;
> +}

Why do we have pmd_val hooks then?

> +pmd_t xen_make_pmd(unsigned long pmd)
> +{
> +	BUG();
> +	return __pmd(0);
> +}

and make_pmd hooks?

> --- /dev/null
> +++ b/arch/i386/xen/time.c

... will review the rest later.

Can you please split it up a bit?

-Andi

