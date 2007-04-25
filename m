Return-Path: <linux-kernel-owner+w=401wt.eu-S1161582AbXDYCDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582AbXDYCDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 22:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161594AbXDYCDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 22:03:49 -0400
Received: from gw.goop.org ([64.81.55.164]:54839 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161582AbXDYCDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 22:03:48 -0400
Message-ID: <462EB6CF.7040902@goop.org>
Date: Tue, 24 Apr 2007 19:02:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
References: <20070423215638.563901986@goop.org> <20070423215710.355105690@goop.org> <200704242325.23447.ak@suse.de>
In-Reply-To: <200704242325.23447.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 23 April 2007 23:56:44 Jeremy Fitzhardinge wrote:
>   
>> Core Xen Implementation
>>
>> This patch is a rollup of all the core pieces of the Xen
>> implementation, including booting, memory management, interrupts, time
>> and so on.
>>     
>
> The patch is definitely too big.
>   

Yes.  It was originally smaller patches, which I tried to keep in a
state where everything was incrementally buildable, but it got too hard
to keep it all together.

I guess I can break it down into functional groups, and put the config
stuff at the end.

>> +#ifdef CONFIG_XEN
>> +/* Xen only supports sysenter/sysexit in ring0 guests,
>> +   and only if it the guest asks for it.  So for now,
>> +   this should never be used. */
>> +ENTRY(xen_sti_sysexit)
>> +	CFI_STARTPROC
>> +	ud2
>> +	CFI_ENDPROC
>> +ENDPROC(xen_sti_sysexit)
>>     
>
> Put that elsewhere? It doesn't need to be here.
>   

Yes, I can drop it.  It's not needed in this kernel.

>> +++ b/arch/i386/xen/enlighten.c
>> @@ -0,0 +1,727 @@
>>     
>
> Comments describing what all the files do? 
>   

OK.

>> +	unsigned maskedx = ~0;
>> +	if (*eax == 1)
>> +		maskedx = ~((1 << X86_FEATURE_APIC) |
>> +			    (1 << X86_FEATURE_ACPI) |
>> +			    (1 << X86_FEATURE_ACC));
>>     
>
> Why ACC? 
>
> And why doesn't Xen mask those by itself?
>   

Because it doesn't care whether they're set or not.  I'm suppressing
them here to prevent the kernel from trying to use these features.  I
suppress ACC in particular to stop the P4 thermal interrupt code from
trying to do anything.

I'll comment it.

> And you got apic functions later which would be never called?
> Why are the hooks needed then? 
>   

They aren't.  They're only for VMI.  I've only got them to make sure
that there are no stray APIC usages.

>> +
>> +static unsigned long xen_save_fl(void)
>> +{
>> +	struct vcpu_info *vcpu;
>> +	unsigned long flags;
>> +
>> +	preempt_disable();
>> +	vcpu = x86_read_percpu(xen_vcpu);
>> +	/* flag has opposite sense of mask */
>> +	flags = !vcpu->evtchn_upcall_mask;
>> +	preempt_enable();
>>     
>
> If you use get_cpu/put_cpu it will be optimized away on PREEMPT && !SMP
> (more occurrences)
>   

Won't preempt_disable disappear as well?  I don't need the CPU number.

>> +static void xen_restore_fl(unsigned long flags)
>> +{
>> +	struct vcpu_info *vcpu;
>> +
>> +	preempt_disable();
>> +
>> +	/* convert from IF type flag */
>> +	flags = !(flags & X86_EFLAGS_IF);
>> +	vcpu = x86_read_percpu(xen_vcpu);
>> +	vcpu->evtchn_upcall_mask = flags;
>> +	if (flags == 0) {
>> +		barrier(); /* unmask then check (avoid races) */
>>     
>
> Don't you need a rmb() here then? The CPU could speculate reads
> (more occurrences) 
>   

OK.

>> +		if (unlikely(vcpu->evtchn_upcall_pending))
>> +			force_evtchn_callback();
>> +		preempt_enable();
>> +	} else
>> +		preempt_enable_no_resched();
>> +}
>> +
>> +static void xen_irq_disable(void)
>> +{
>> +	struct vcpu_info *vcpu;
>> +	preempt_disable();
>> +	vcpu = x86_read_percpu(xen_vcpu);
>> +	vcpu->evtchn_upcall_mask = 1;
>> +	preempt_enable_no_resched();
>>     
>
> First with the new per cpu the preempt disable shouldn't be needed
> anymore because the thing is atomic. In the worst case you do 
> the change on the previous CPU, but that can happen anyways after
> preempt_enable
>   

No, there's a one instruction preempt window there.  If I do:

    mov %fs:xen_vcpu, %eax
    movb $1,1(%eax)

and a preempt happens in between, then the interrupt will be disabled on
the wrong cpu.

Once we can put the vcpu structure into the percpu area directly, then I
can do:

    movb $1,%fs:xen_vcpu+1

which is preempt-safe, of course.

> And then when you have enabled who transfers the irq off state to the
> new CPU? 
>   

I don't follow you.

>> +static void xen_halt(void)
>> +{
>> +#if 0
>> +	if (irqs_disabled())
>> +		HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
>> +#endif
>> +}
>>     
>
> Who halts then?
>   

I fix this up in the xen-machine-ops.patch.

>> +static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
>> +{
>> +	unsigned long *frames;
>> +	unsigned long va = dtr->address;
>> +	unsigned int size = dtr->size + 1;
>> +	int f;
>> +	struct multicall_space mcs;
>> +
>> +	BUG_ON(size > 16*PAGE_SIZE);
>>     
>
> Why 16?
>   

I'll make it more explicit.  It's 64k of GDT entries == 16 pages.

>> +	count = desc->size / 8;
>> +	BUG_ON(count > 256);
>>     
>
> should be >= ?
>   

I think 256 idt entries is OK, but it should be (desc->size+1) / 8.

>> +static void xen_set_iopl_mask(unsigned mask)
>> +{
>> +#if 0
>> +	struct physdev_set_iopl set_iopl;
>> +
>> +	/* Force the change at ring 0. */
>> +	set_iopl.iopl = (mask == 0) ? 1 : (mask >> 12) & 3;
>> +	HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
>> +#endif
>>     
>
> And who does iopl then?
>   

Nobody at the moment.  I don't think there's much need for it in an
unprivileged Xen domU.  I could just nop it out for now.

>> + * Page-directory addresses above 4GB do not fit into architectural %cr3.
>> + * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
>> + * must use the following accessor macros to pack/unpack valid MFNs.
>> + */
>> +#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
>> +#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
>>     
>
> Don't you lose bits >4GB here due to the casts before shift?
>   

Erm, good point.

>> +	BUG_ON(memcmp(xen_start_info->magic, "xen-3.0", 7) != 0);
>>     
>
> Hopefully Xen 4.0 can handle this then.
>   

It would probably present xen-3 guests a xen-3 signature.

>> +
>> +	/* Poke various useful things into boot_params */
>> +	LOADER_TYPE = (9 << 4) | 0;
>>     
>
> | 0 ? Probably should be something symbolic
>   

0 is the version number.  I don't think there are symbols for the
bootloader types.

>> +unsigned long xen_pmd_val(pmd_t pmd)
>> +{
>> +	BUG();
>> +	return 0;
>> +}
>>     
>
> Why do we have pmd_val hooks then?
>
>   
>> +pmd_t xen_make_pmd(unsigned long pmd)
>> +{
>> +	BUG();
>> +	return __pmd(0);
>> +}
>>     
>
> and make_pmd hooks?
>   

That's the !PAE case, so we expect to never have any PMD calls.  The
hooks exist for !PAE because I didn't want to have more ifdefs.

>> --- /dev/null
>> +++ b/arch/i386/xen/time.c
>>     
>
> ... will review the rest later.
>
> Can you please split it up a bit?
>   

OK.

    J

