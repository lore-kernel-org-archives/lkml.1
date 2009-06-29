Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZF2HyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZF2HyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2HyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:54:11 -0400
Received: from mga12.intel.com ([143.182.124.36]:16399 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbZF2HyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:54:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,308,1243839600"; 
   d="scan'208";a="159498097"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: kvm@vger.kernel.org
Subject: Re: [PATCH] enable x2APIC without interrupt remapping under KVM
Date: Mon, 29 Jun 2009 15:53:58 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; x86_64; ; )
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       avi@redhat.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <20090628125114.GO20289@redhat.com>
In-Reply-To: <20090628125114.GO20289@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291553.59347.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 20:51:14 Gleb Natapov wrote:
 > KVM would like to provide x2APIC interface to a guest without emulating
 > interrupt remapping device. The reason KVM prefers guest to use x2APIC
 > is that x2APIC interface is better virtualizable and provides better
 > performance than mmio xAPIC interface:
 >
 > - msr exits are faster than mmio (no page table walk, emulation)
 > - no need to read back ICR to look at the busy bit
 > - one 64 bit ICR write instead of two 32 bit writes
 > - shared code with the Hyper-V paravirt interface
 >
 > Included patch changes x2APIC enabling logic to enable it even if IR
 > initialization failed, but kernel runs under KVM and no apic id is
 > greater than 255 (if there is one spec requires BIOS to move to x2apic
 > mode before starting an OS).
 
[Resend, sorry for html noise...]

Add Suresh here. And some comments and unclear points below.

> Signed-off-by: Gleb Natapov <gleb@redhat.com>
 > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
 > index d1430ef..7438c5c 100644
 > --- a/arch/x86/Kconfig
 > +++ b/arch/x86/Kconfig
 > @@ -260,7 +260,7 @@ config SMP
 >
 > config X86_X2APIC
 > bool "Support x2apic"
 > - depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
 > + depends on X86_LOCAL_APIC && X86_64
 > ---help---
 > This enables x2apic support on CPUs that have this feature.
 

We may need to note x2apic won't work without interrupt remapping or as a 
guest in KVM here?
 >
 > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
 > index 8c7c042..48a63b6 100644
 > --- a/arch/x86/kernel/apic/apic.c
 > +++ b/arch/x86/kernel/apic/apic.c
 > @@ -49,6 +49,7 @@
 > #include <asm/mtrr.h>
 > #include <asm/smp.h>
 > #include <asm/mce.h>
 > +#include <asm/kvm_para.h>
 >
 > unsigned int num_processors;
 >
 > @@ -1363,11 +1364,10 @@ void enable_x2apic(void)
 > }
 > #endif /* CONFIG_X86_X2APIC */
 >
 > -void __init enable_IR_x2apic(void)
 > +int __init enable_IR(void)
 > {
 > #ifdef CONFIG_INTR_REMAP
 > int ret;
 > - unsigned long flags;
 > struct IO_APIC_route_entry **ioapic_entries = NULL;
 >
 > ret = dmar_table_init();
 > @@ -1381,11 +1381,10 @@ void __init enable_IR_x2apic(void)
 > goto ir_failed;
 > }
 >
 > -
 > if (!x2apic_preenabled && skip_ioapic_setup) {
 > pr_info("Skipped enabling intr-remap because of skipping "
 > "io-apic setup\n");
 > - return;
 > + goto ir_failed;
 > }
 >
 > ioapic_entries = alloc_ioapic_entries();
 > @@ -1400,22 +1399,14 @@ void __init enable_IR_x2apic(void)
 > goto end;
 > }
 >
 > - local_irq_save(flags);
 > mask_IO_APIC_setup(ioapic_entries);
 > - mask_8259A();
 >
 > ret = enable_intr_remapping(x2apic_supported());
 > if (ret)
 > goto end_restore;
 > -

Unrelated...

> pr_info("Enabled Interrupt-remapping\n");
 >
 > - if (x2apic_supported() && !x2apic_mode) {
 > - x2apic_mode = 1;
 > - enable_x2apic();
 > - pr_info("Enabled x2apic\n");
 > - }
 > -
 > + return 1;
 > end_restore:
 > if (ret)
 > /*
 > @@ -1423,30 +1414,50 @@ end_restore:
 > */
 > restore_IO_APIC_setup(ioapic_entries);
 >
 > - unmask_8259A();
 > - local_irq_restore(flags);
 > -
 > end:
 > if (ioapic_entries)
 > free_ioapic_entries(ioapic_entries);
 >
 > - if (!ret)
 > - return;
 > -
 > ir_failed:
 > - if (x2apic_preenabled)
 > +#endif
 > + return 0;
 > +}
 > +
 > +void __init enable_IR_x2apic(void)
 > +{
 > + unsigned long flags;
 > +
 > + local_irq_save(flags);
 > + mask_8259A();
 > +
 > + /* IR is required if x2apic is enabled by BIOS even when running in kvm
 > + * since this indicates present of APIC ID > 255 */
 > + if (!enable_IR() && (x2apic_preenabled || !kvm_para_available()))
 > + goto nox2apic;
 > +

Not quite understand the comment here. Could you explain why "since this 
indicates present of APIC ID > 255?" In another word, why enable_IR() needed 
for KVM even it would be fail at dmar_table_init()?
 
Another question is, we supposed KVM would use physical mode of x2apic, for 
IOAPIC and MSI won't support APIC ID > 255. But seems not, or I miss 
something?

-- 
regards
Yang, Sheng
 

> + if (x2apic_supported() && !x2apic_mode) {
 > + x2apic_mode = 1;
 > + enable_x2apic();
 > + pr_info("Enabled x2apic\n");
 > + }
 > +
 > + unmask_8259A();
 > + local_irq_restore(flags);
 > + return;
 > +
 > +nox2apic:
 > + unmask_8259A();
 > + local_irq_restore(flags);
 > +
 > + if (x2apic_preenabled) {
 > +#ifdef CONFIG_INTR_REMAP
 > panic("x2apic enabled by bios. But IR enabling failed");
 > - else if (cpu_has_x2apic)
 > - pr_info("Not enabling x2apic,Intr-remapping\n");
 > #else
 > - if (!cpu_has_x2apic)
 > - return;
 > -
 > - if (x2apic_preenabled)
 > panic("x2apic enabled prior OS handover,"
 > " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
 > #endif
 > -
 > + } else if (cpu_has_x2apic)
 > + pr_info("Not enabling x2apic,Intr-remapping\n");
 > return;
 > }
 >
 > --
 > Gleb.
 > --
 > To unsubscribe from this list: send the line "unsubscribe kvm" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at http://vger.kernel.org/majordomo-info.html
 

