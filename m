Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXD3CKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXD3CKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 22:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422746AbXD3CKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 22:10:32 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55631 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744AbXD3CKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 22:10:23 -0400
Date: Sun, 29 Apr 2007 20:10:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] support PCI MCFG space on Intel i915 bridges
In-reply-to: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <46355007.5030807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Add support for Intel 915 bridge chips to the new PCI MMConfig detection
> code.  Tested and works on my sole 915 based platform (a Toshiba laptop).  I
> added register masking per Oliver's suggestion, and moved the __init
> qualifier to after the 'static const char' to match Ogawa-san's recent
> cleanup patches.
> 
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> 
> diff --git a/arch/i386/pci/mmconfig-shared.c b/arch/i386/pci/mmconfig-shared.c
> index 747d8c6..1339d31 100644
> --- a/arch/i386/pci/mmconfig-shared.c
> +++ b/arch/i386/pci/mmconfig-shared.c
> @@ -72,6 +72,26 @@ static const char __init *pci_mmcfg_e7520(void)
>  	return "Intel Corporation E7520 Memory Controller Hub";
>  }
>  
> +static const char __init *pci_mmcfg_intel_915(void)
> +{
> +       u32 pciexbar, len = 0;
> +
> +       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
> +
> +       /* No enable bit or size field, so assume 256M range is enabled. */
> +       len = 0x10000000U;

Check the 915 spec more carefully, there is an enable bit, it's in the 
DEVEN register offset 54h, the bit is called PCIEXBAREN (bit 31). If 
that is not set you should be setting pci_mmcfg_config_num to 0 and 
bailing out.

The size is indeed always 256MB though.

> +       pci_mmcfg_config_num = 1;
> +       pciexbar &= 0xe0000000; /* mask out potentially bogus bits */
> +
> +       pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
> +       pci_mmcfg_config[0].address = pciexbar;
> +       pci_mmcfg_config[0].pci_segment = 0;
> +       pci_mmcfg_config[0].start_bus_number = 0;
> +       pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
> +
> +       return "Intel Corporation 915PM/GM/GMS Express Memory Controller Hub";
> +}
> +
>  static const char __init *pci_mmcfg_intel_945(void)
>  {
>  	u32 pciexbar, mask = 0, len = 0;
> @@ -129,6 +149,7 @@ struct pci_mmcfg_hostbridge_probe {
>  
>  static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
>  	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
> +	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82915GM_HB, pci_mmcfg_intel_915 },
>  	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
>  };

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

