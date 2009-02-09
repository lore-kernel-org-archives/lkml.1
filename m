Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZBITne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZBITne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZBITnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:43:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:48362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZBITnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:43:24 -0500
Message-ID: <4990871C.60605@kernel.org>
Date: Mon, 09 Feb 2009 11:42:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ed Swierk <eswierk@aristanetworks.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
References: <1233765552.16414.6.camel@localhost.localdomain>	 <20090204170440.GA31973@elte.hu> <1234207599.16237.6.camel@localhost.localdomain>
In-Reply-To: <1234207599.16237.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Swierk wrote:
> Detect and enable memory-mapped PCI configuration space on the nVidia
> MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
> development board with one MCP55, Coreboot firmware, no ACPI.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
> 
> ---
> 
> I've tried to incorporate the code style feedback from Ingo.  I'm not
> sure whether this correctly handles boards with more than one MCP55, or
> with an AMD 10h--Yinghai?
> 
> Index: linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.27.4.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6.27.4/arch/x86/pci/mmconfig-shared.c
> @@ -166,6 +166,36 @@ static const char __init *pci_mmcfg_amd_
>  	return "AMD Family 10h NB";
>  }
>  
> +static const char __init *pci_mmcfg_nvidia_mcp55(void)
> +{
> +	u32 extcfg;
> +	u64 base;
> +	int end;
> +	static const u32 extcfg_regnum =      0x90;
> +	static const u32 extcfg_regsize =     4;
> +	static const u32 extcfg_enable_mask = 0x80000000;
> +	static const u32 extcfg_end_mask =    0x30000000;
> +	static const int extcfg_end_shift =   28;
> +	static const int extcfg_endbus[] =    { 255, 127, 63, 31 };
> +	static const u32 extcfg_base_mask =   0x00007fff;
> +	static const int extcfg_base_lshift = 25;
> +
> +	raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), extcfg_regnum, extcfg_regsize,
> +			  &extcfg);
1. mcp55 could one bus1
2. io55 could be on 0x40, 0x80, 0xc0

so it seems we could loop all 0-255 to find those HT in one function and add them one by one.

YH
> +
> +	if (!(extcfg & extcfg_enable_mask))
> +		return NULL;
> +
> +	if (extend_mmcfg(1) == -1)
> +		return NULL;
> +
> +	base = (extcfg & extcfg_base_mask) << extcfg_base_lshift;
> +	end = (extcfg & extcfg_end_mask) >> extcfg_end_shift;
> +	fill_one_mmcfg(base, 0, 0, extcfg_endbus[end]);
> +
> +	return "nVidia MCP55";
> +}
> +
>  struct pci_mmcfg_hostbridge_probe {
>  	u32 bus;
>  	u32 devfn;
> @@ -183,6 +213,8 @@ static struct pci_mmcfg_hostbridge_probe
>  	  0x1200, pci_mmcfg_amd_fam10h },
>  	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
>  	  0x1200, pci_mmcfg_amd_fam10h },
> +	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_NVIDIA,
> +	  0x0369, pci_mmcfg_nvidia_mcp55 },
>  };
>  
>  static int __init pci_mmcfg_check_hostbridge(void)
> 

