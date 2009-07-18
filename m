Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZGROIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZGROIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZGROIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:08:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59053 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZGROIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:08:30 -0400
Date: Sat, 18 Jul 2009 16:07:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090718140727.GF32618@elte.hu>
References: <20090701133007.GC27539@redhat.com> <1246482017.27006.10670.camel@localhost.localdomain> <20090703082905.GF21833@elte.hu> <20090705143254.GJ881@redhat.com> <20090710135618.GC26264@elte.hu> <20090712120604.GA28046@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712120604.GA28046@redhat.com>
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


i've only got some small stylistic gripes:

> +void __init enable_IR_x2apic(void)
> +{
> +	unsigned long flags;
> +	struct IO_APIC_route_entry **ioapic_entries = NULL;
> +	int ret, x2apic_enabled = 0;
> +
>  	ioapic_entries = alloc_ioapic_entries();
>  	if (!ioapic_entries) {
> -		pr_info("Allocate ioapic_entries failed: %d\n", ret);
> -		goto end;
> +		pr_info("Allocate ioapic_entries failed\n");
> +		goto out;

That's probably a fatal condition so perhaps a WARN() or pr_err() 
would be more appropriate.

> +	ret = enable_IR();
> +	if (!ret) {
> +		/* IR is required if x2apic is enabled by BIOS even
> +		 * when running in kvm since this indicates present
> +		 * of APIC ID > 255 */

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +		if (max_physical_apicid > 255 || !kvm_para_available())
> +			goto nox2apic;
> +		/* without IR all CPUs can be addressed by IOAPIC/MSI
> +		 * only in physical mode */

ditto.

> +		x2apic_phys = 1;
> +	}
>  
> -	pr_info("Enabled Interrupt-remapping\n");
> +	x2apic_enabled = 1;
>  
>  	if (x2apic_supported() && !x2apic_mode) {
>  		x2apic_mode = 1;
> @@ -1414,41 +1437,30 @@ void __init enable_IR_x2apic(void)
>  		pr_info("Enabled x2apic\n");
>  	}
>  
> -end_restore:
> -	if (ret)
> -		/*
> -		 * IR enabling failed
> -		 */
> +nox2apic:
> +	if (!ret) /* IR enabling failed */
>  		restore_IO_APIC_setup(ioapic_entries);
> -
>  	unmask_8259A();
>  	local_irq_restore(flags);
>  
> -end:
> +out:
>  	if (ioapic_entries)
>  		free_ioapic_entries(ioapic_entries);
>  
> -	if (!ret)
> +	if (x2apic_enabled)
>  		return;
>  
> -ir_failed:
> -	if (x2apic_preenabled)
> +	if (x2apic_preenabled) {
> +#ifdef CONFIG_INTR_REMAP
>  		panic("x2apic enabled by bios. But IR enabling failed");
> -	else if (cpu_has_x2apic)
> -		pr_info("Not enabling x2apic,Intr-remapping\n");
>  #else
> -	if (!cpu_has_x2apic)
> -		return;
> -
> -	if (x2apic_preenabled)
>  		panic("x2apic enabled prior OS handover,"
> -		      " enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
> +				" enable CONFIG_X86_X2APIC, CONFIG_INTR_REMAP");
>  #endif

can this #ifdef be avoided?

> -
> -	return;
> +	} else if (cpu_has_x2apic)
> +		pr_info("Not enabling x2apic,Intr-remapping\n");

please put a space after commas.

Thanks,

	Ingo
