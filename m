Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXLKPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXLKPcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXLKPck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:32:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57238 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbXLKPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:32:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Neil Horman <nhorman@redhat.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071206213951.GB28898@hmsreliant.think-freely.org>
	<20071206221143.GC2863@redhat.com>
	<m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
	<86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	<86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	<20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
	<20071207175832.GA18485@hmsreliant.think-freely.org>
	<m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
	<20071211034349.GA3635@localhost.localdomain>
	<m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
	<20071211143910.GA10999@hmsreliant.think-freely.org>
Date: Tue, 11 Dec 2007 08:29:20 -0700
In-Reply-To: <20071211143910.GA10999@hmsreliant.think-freely.org> (Neil
	Horman's message of "Tue, 11 Dec 2007 09:39:10 -0500")
Message-ID: <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Mon, Dec 10, 2007 at 09:48:11PM -0700, Eric W. Biederman wrote:
>> Neil Horman <nhorman@tuxdriver.com> writes:
>> 
>> Almost there.
> cool! :)
>
> <snip>
>> 
>> We should not need check_hypertransport_config as the generic loop
>> now does the work for us.
>> > +
>> >  static void __init nvidia_bugs(void)
>> >  {
>> >  #ifdef CONFIG_ACPI
>> > @@ -83,15 +127,25 @@ static void __init ati_bugs(void)
>> >  #endif
>> >  }
>> >  
>> > +static void __init amd_host_bugs(void)
>> > +{
>> > +	printk(KERN_CRIT "IN AMD_HOST_BUGS\n");
>> > +	check_hypertransport_config();
>> > +}
>> 
>> Likewise this function is unneeded and the printk is likely confusing
>> for users.
>> 
> Copy that. Fixed
>
> <snip>
>> >  	{}
>> So make that fix_hypertransport_config and we should be good.
> Done
>
>> 
>> We don't need to shift device.  Although we can do:
>> device_vendor = read_pci_config(num, slot, func, PCI_VENDOR_ID);
>> device = device_vendor >> 16;
>> vendor = device_vendor & 0xffff;
>> 
> I'm not so sure about this.  In my testing, it was clear that I needed to do a
> shift on device to make valid comparisons to the defined PCI_DEVICE_* macros.
> The origional code had to do the same thing with the class field, which is
> simmilarly positioned in the pci config space.

Ok.  I just looked at read_pci_config.  It doesn't do the right thing for
a non-aligned 32bit access.  (Not that I am convinced there is a right
thing we can do).  Please make this read_pci_config_16 instead
and you won't need the shift.

Either that or as I earlier suggested just do a 32bit read from offset 0
and use shifts and masks to get vendor and device fields.

The current code doing a shift where none should be needed (because
we ignore the two low order bits in our read) is totally weird
when looking at it.

> Other than that, new patch attached.  Enables the detection of AMD
> hypertransport functions and checks for the proper quirk just as before, and
> incoporates your comments above Eric, as well as yours Yinghai.

You almost got YH's comment.  You need return 2 for the old functions
so we don't try and apply a per chipset fixup for every device in
the system.

I'm actually inclined to remove the return magic and just do something
like:
	static fix_applied;
	if (fix_applied++)
        	return;
In those functions that should be called only once.

Eric

>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>
>
>  early-quirks.c | 76 +++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 61 insertions(+), 15 deletions(-)
>
>
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 88bb83e..e13c999 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -21,7 +21,7 @@
>  #include <asm/gart.h>
>  #endif
>  
> -static void __init via_bugs(void)
> +static int __init via_bugs(int  num, int slot, int func)
>  {
>  #ifdef CONFIG_GART_IOMMU
>  	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
> @@ -32,6 +32,7 @@ static void __init via_bugs(void)
>  		gart_iommu_aperture_disabled = 1;
>  	}
>  #endif
> +	return 1;
return 2;
>  }
>  
>  #ifdef CONFIG_ACPI
> @@ -44,7 +45,31 @@ static int __init nvidia_hpet_check(struct acpi_table_header
> *header)
>  #endif /* CONFIG_X86_IO_APIC */
>  #endif /* CONFIG_ACPI */
>  
> -static void __init nvidia_bugs(void)
> +static int __init fix_hypertransport_config(int num, int slot, int func)
> +{
> +	u32 htcfg;
> +	/*
> +	 *we found a hypertransport bus
> +	 *make sure that are broadcasting
> +	 *interrupts to all cpus on the ht bus
> +	 *if we're using extended apic ids
> +	 */
> +	htcfg = read_pci_config(num, slot, func, 0x68);
> +	if (htcfg & (1 << 18)) {	
> + printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> +		if ((htcfg & (1 << 17)) == 0) {
> + printk(KERN_INFO "Enabling hypertransport extended apic interrupt
> broadcast\n");
> + printk(KERN_INFO "Note this is a bios bug, please contact your hw vendor\n");
> +			htcfg |= (1 << 17);
> +			write_pci_config(num, slot, func, 0x68, htcfg);
> +		}
> +	}
> +
> +	return 1;
> +	
> +}
> +

Hmm.  I don't think we want this code positioned in the middle of the
nvidia bug checks.

> +static int __init nvidia_bugs(int num, int slot, int func)
>  {
>  #ifdef CONFIG_ACPI
>  #ifdef CONFIG_X86_IO_APIC
> @@ -56,7 +81,7 @@ static void __init nvidia_bugs(void)
>  	 * at least allow a command line override.
>  	 */
>  	if (acpi_use_timer_override)
> -		return;
> +		return 1;
>  
>  	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
>  		acpi_skip_timer_override = 1;
> @@ -70,9 +95,10 @@ static void __init nvidia_bugs(void)
>  #endif
>  	/* RED-PEN skip them on mptables too? */
>  
> +	return 1;
return 2;
>  }
>  
> -static void __init ati_bugs(void)
> +static int __init ati_bugs(int num, int slot, int func)
>  {
>  #ifdef CONFIG_X86_IO_APIC
>  	if (timer_over_8254 == 1) {
> @@ -81,17 +107,22 @@ static void __init ati_bugs(void)
>  		"ATI board detected. Disabling timer routing over 8254.\n");
>  	}
>  #endif
> +	return 1;
return 2;
>  }
>  
>  struct chipset {
> -	u16 vendor;
> -	void (*f)(void);
> +	u32 vendor;
> +	u32 device;
> +	u32 class;
> +	u32 class_mask;
> +	int (*f)(int num, int slot, int func);
>  };
>  
>  static struct chipset early_qrk[] __initdata = {
> -	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
> -	{ PCI_VENDOR_ID_VIA, via_bugs },
> -	{ PCI_VENDOR_ID_ATI, ati_bugs },
> + { PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID,
> nvidia_bugs },
> + { PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, via_bugs },
> + { PCI_VENDOR_ID_ATI, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, ati_bugs },
> + { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB, PCI_CLASS_BRIDGE_HOST,
> PCI_ANY_ID, fix_hypertransport_config },
>  	{}
>  };
>  
> @@ -108,25 +139,40 @@ void __init early_quirks(void)
>  			for (func = 0; func < 8; func++) {
>  				u32 class;
>  				u32 vendor;
> +				u32 device;
>  				u8 type;
> +				int ret;
>  				int i;
> +
>  				class = read_pci_config(num,slot,func,
>  							PCI_CLASS_REVISION);
>  				if (class == 0xffffffff)
>  					break;
>  
> -				if ((class >> 16) != PCI_CLASS_BRIDGE_PCI)
> -					continue;
> +				class >>= 16;
>  
>  				vendor = read_pci_config(num, slot, func,
>  							 PCI_VENDOR_ID);
>  				vendor &= 0xffff;
				vendor = read_pci_config_16(num, slot, func,
							    PCI_VENDOR_ID);
>  
> -				for (i = 0; early_qrk[i].f; i++)
> -					if (early_qrk[i].vendor == vendor) {
> -						early_qrk[i].f();
> -						return;
> +				device = read_pci_config(num, slot, func,
> +							PCI_DEVICE_ID);
> +				device >>= 16;

				device = read_pci_config_16(num, slot, func,
							    PCI_DEVICE_ID);
				
> +
> +				for(i=0;early_qrk[i].f != NULL;i++) {
> + if (((early_qrk[i].vendor == PCI_ANY_ID) ||
> +					    (early_qrk[i].vendor == vendor)) &&
> + ((early_qrk[i].device == PCI_ANY_ID) ||
> +					    (early_qrk[i].device == device)) &&
> +					   (!((early_qrk[i].class ^ class) & 
> +					     early_qrk[i].class_mask))) {
> + ret = early_qrk[i].f(num, slot, func);
> +						if (ret == 1)
> +							break;
> +						if (ret == 2)
> +							return;


>  					}
> +				}
>  
>  				type = read_pci_config_byte(num, slot, func,
>  							    PCI_HEADER_TYPE);
