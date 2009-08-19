Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZHSO51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZHSO51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZHSO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:57:26 -0400
Received: from www.tglx.de ([62.245.132.106]:46417 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZHSO50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:57:26 -0400
Date: Wed, 19 Aug 2009 16:56:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 4/10] x86: make use of platform feature flags during
 setup
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF6@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191652040.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF6@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index 7bf325a..c0839f7 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -32,6 +32,7 @@ struct x86_quirks {
>  				unsigned short oemsize);
>  	int (*setup_ioapic_ids)(void);
>  	void (*setup_secondary_clock)(void);
> +	void (*reserve_ebda_region)(void);
>  };

Nice you used the field in the previous patch already

> -	reserve_ebda_region();
> +	platform_feature_init_default();
> +
> +	if (x86_quirks->reserve_ebda_region)
> +		reserve_ebda_region();

Eek. What's the quirks function pointer for ?
 
>  static struct resource system_rom_resource = {
>  	.name	= "System ROM",
> @@ -99,6 +100,8 @@ void __init probe_roms(void)
>  	unsigned char c;
>  	int i;
>  
> +	if (!platform_has(X86_PLATFORM_FEATURE_BIOS))
> +		return;

That should be done with a function pointer which is initialized in
the platform code.

>  
>  #ifdef CONFIG_X86_32
> -	request_resource(&iomem_resource, &video_ram_resource);
> +	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
> +		request_resource(&iomem_resource, &video_ram_resource);
>  #endif
> -	reserve_standard_io_resources();
> +	if (platform_has(X86_PLATFORM_FEATURE_ISA))
> +		reserve_standard_io_resources();

Ditto. And the function pointer could eliminate the X86_32 ifdef as well.
 
> @@ -1190,6 +1195,24 @@ static int pirq_enable_irq(struct pci_dev *dev)
>  	u8 pin;
>  
>  	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
> +#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SFI)
> +	/* For platforms only have IOAPIC, the PCI irq line is 1:1 mapped to
> +	 * IOAPIC RTE entries, so we just enable RTE for the device.
> +	 */
> +	if (platform_has(X86_PLATFORM_FEATURE_IOAPIC) &&
> +		!platform_has(X86_PLATFORM_FEATURE_8259) &&
> +		!platform_has(X86_PLATFORM_FEATURE_ACPI) &&
> +		!platform_has(X86_PLATFORM_FEATURE_BIOS) &&

You are not serious about that #ifdef and featuritis mess ?

Thanks,

	tglx
