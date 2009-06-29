Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZF2IMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZF2IMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZF2IMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:12:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZF2IMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:12:15 -0400
Date: Mon, 29 Jun 2009 11:12:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090629081214.GS20289@redhat.com>
References: <20090628125114.GO20289@redhat.com> <200906291549.46581.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906291549.46581.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 03:49:45PM +0800, Sheng Yang wrote:
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index d1430ef..7438c5c 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -260,7 +260,7 @@ config SMP
> >
> >  config X86_X2APIC
> >  	bool "Support x2apic"
> > -	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
> > +	depends on X86_LOCAL_APIC && X86_64
> >  	---help---
> >  	  This enables x2apic support on CPUs that have this feature.
> 
> We may need to note x2apic won't work without interrupt remapping or as a 
> guest in KVM here?
Will add help text to say this.

> >
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 8c7c042..48a63b6 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -49,6 +49,7 @@
> >  #include <asm/mtrr.h>
> >  #include <asm/smp.h>
> >  #include <asm/mce.h>
> > +#include <asm/kvm_para.h>
> >
> >  unsigned int num_processors;
> >
> > @@ -1363,11 +1364,10 @@ void enable_x2apic(void)
> >  }
> >  #endif /* CONFIG_X86_X2APIC */
> >
> > -void __init enable_IR_x2apic(void)
> > +int __init enable_IR(void)
> >  {
> >  #ifdef CONFIG_INTR_REMAP
> >  	int ret;
> > -	unsigned long flags;
> >  	struct IO_APIC_route_entry **ioapic_entries = NULL;
> >
> >  	ret = dmar_table_init();
> > @@ -1381,11 +1381,10 @@ void __init enable_IR_x2apic(void)
> >  		goto ir_failed;
> >  	}
> >
> > -
> >  	if (!x2apic_preenabled && skip_ioapic_setup) {
> >  		pr_info("Skipped enabling intr-remap because of skipping "
> >  			"io-apic setup\n");
> > -		return;
> > +		goto ir_failed;
> >  	}
> >
> >  	ioapic_entries = alloc_ioapic_entries();
> > @@ -1400,22 +1399,14 @@ void __init enable_IR_x2apic(void)
> >  		goto end;
> >  	}
> >
> > -	local_irq_save(flags);
> >  	mask_IO_APIC_setup(ioapic_entries);
> > -	mask_8259A();
> >
> >  	ret = enable_intr_remapping(x2apic_supported());
> >  	if (ret)
> >  		goto end_restore;
> > -
> 
> Unrelated...
> 
> >  	pr_info("Enabled Interrupt-remapping\n");
> >
> > -	if (x2apic_supported() && !x2apic_mode) {
> > -		x2apic_mode = 1;
> > -		enable_x2apic();
> > -		pr_info("Enabled x2apic\n");
> > -	}
> > -
> > +	return 1;
> >  end_restore:
> >  	if (ret)
> >  		/*
> > @@ -1423,30 +1414,50 @@ end_restore:
> >  		 */
> >  		restore_IO_APIC_setup(ioapic_entries);
> >
> > -	unmask_8259A();
> > -	local_irq_restore(flags);
> > -
> >  end:
> >  	if (ioapic_entries)
> >  		free_ioapic_entries(ioapic_entries);
> >
> > -	if (!ret)
> > -		return;
> > -
> >  ir_failed:
> > -	if (x2apic_preenabled)
> > +#endif
> > +	return 0;
> > +}
> > +
> > +void __init enable_IR_x2apic(void)
> > +{
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	mask_8259A();
> > +
> > +	/* IR is required if x2apic is enabled by BIOS even when running in kvm
> > +	 * since this indicates present of APIC ID > 255 */
> > +	if (!enable_IR() && (x2apic_preenabled || !kvm_para_available()))
> > +		goto nox2apic;
> > +
> 
> Not quite understand the comment here. Could you explain why "since this 
> indicates present of APIC ID > 255?" In another word, why enable_IR() needed 
> for KVM even it would be fail at dmar_table_init()?
> 
The x2APIC doc says:

  The default will be for the BIOS to pass the control to the OS with the
  local x2APICs in xAPIC mode if all x2APIC IDs reported by CPUID.0BH:EDX
  are less than 255, and in x2APIC mode if there are any logical processor
  reporting its x2APIC ID at 255 or greater.

So x2apic_preenabled will be true if there is an APIC ID greater then 255
and in this case we don't want to allow x2APIC use without IR even in KVM
for the reason you mention: IOAPIC and MSI will not be able to address
all CPUs. The reason to try to enable IR first is so that when KVM will
want to support more then 255 CPUs it will be possible to implement IR
device and use existing kernel without additional changes.

> Another question is, we supposed KVM would use physical mode of x2apic, for 
> IOAPIC and MSI won't support APIC ID > 255. But seems not, or I miss 
> something?
> 
Good point. The patch should be fixed to require physical mode for x2apic.
 
--
			Gleb.
