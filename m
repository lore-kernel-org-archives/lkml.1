Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZGWOyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZGWOyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZGWOyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:54:05 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:30476 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZGWOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:54:03 -0400
Date: Thu, 23 Jul 2009 07:53:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       linux-next <linux-next@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: next: sfi build fails when !CONFIG_ACPI
Message-Id: <20090723075351.ca41bc81.randy.dunlap@oracle.com>
In-Reply-To: <20090723163322.615e1f8e@feng-desktop>
References: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
	<20090722150617.13c24350.randy.dunlap@oracle.com>
	<20090723163322.615e1f8e@feng-desktop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A687981.024C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 16:33:22 +0800 Feng Tang wrote:

> On Thu, 23 Jul 2009 06:06:17 +0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Thu, 16 Jul 2009 12:48:01 +0400 Alexander Beregalov wrote:
> > 
> > > Hi
> > > 
> > > drivers/sfi/sfi_core.c: In function 'sfi_init':
> > > drivers/sfi/sfi_core.c:346: error: 'acpi_disabled' undeclared (first
> > > use in this function)
> > > drivers/sfi/sfi_core.c:346: error: (Each undeclared identifier is
> > > reported only once
> > > drivers/sfi/sfi_core.c:346: error: for each function it appears in.)
> > > 
> > > 
> > > $ grep ACPI .config
> > > # Power management and ACPI options
> > > --
> > 
> > next-20090722 still fails on x86_32 when SFI=y & ACPI=n:
> > 
> > arch/x86/pci/mmconfig_32.c:34: error: invalid use of undefined type
> > 'struct acpi_mcfg_allocation' arch/x86/pci/mmconfig_32.c:34: error:
> > dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig_32.c:35: error: dereferencing pointer to
> > incomplete type arch/x86/pci/mmconfig_32.c:36: error: dereferencing
> > pointer to incomplete type arch/x86/pci/mmconfig_32.c:37: error:
> > dereferencing pointer to incomplete type
> > arch/x86/pci/mmconfig_32.c:38: error: dereferencing pointer to
> > incomplete type
> > 
> > config is attached.
> Hi Randy,
> 
> Thanks for the catch. Could you try the following patch? thanks!

Works for me.  Thanks.


> - Feng
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 25a0d9f..e89bf33 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -557,15 +557,15 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
>  		i -= sizeof(struct acpi_mcfg_allocation);
>  	};
>  	if (pci_mmcfg_config_num == 0) {
> -		printk(KERN_ERR PREFIX "MMCONFIG has no entries\n");
> +		printk(KERN_ERR "PCI: MMCONFIG has no entries\n");
>  		return -ENODEV;
>  	}
>  
>  	config_size = pci_mmcfg_config_num * sizeof(*pci_mmcfg_config);
>  	pci_mmcfg_config = kmalloc(config_size, GFP_KERNEL);
>  	if (!pci_mmcfg_config) {
> -		printk(KERN_WARNING PREFIX
> -		       "No memory for MCFG config tables\n");
> +		printk(KERN_WARNING
> +		       "PCI: No memory for MCFG config tables\n");
>  		return -ENOMEM;
>  	}
>  
> @@ -576,8 +576,8 @@ static int __init pci_parse_mcfg(struct acpi_table_header *header)
>  	for (i = 0; i < pci_mmcfg_config_num; ++i) {
>  		if ((pci_mmcfg_config[i].address > 0xFFFFFFFF) &&
>  		    !acpi_mcfg_64bit_base_addr) {
> -			printk(KERN_ERR PREFIX
> -			       "MMCONFIG not in low 4GB of memory\n");
> +			printk(KERN_ERR
> +			       "PCI: MMCONFIG not in low 4GB of memory\n");
>  			kfree(pci_mmcfg_config);
>  			pci_mmcfg_config_num = 0;
>  			return -ENODEV;
> @@ -609,7 +609,9 @@ static void __init __pci_mmcfg_init(int early)
>  	if (!known_bridge)
>  		x86_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
>  
> +#ifdef CONFIG_ACPI
>  	pci_mmcfg_reject_broken(early);
> +#endif
>  
>  	if ((pci_mmcfg_config_num == 0) ||
>  	    (pci_mmcfg_config == NULL) ||
> diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
> index 8b2d561..f10a7e9 100644
> --- a/arch/x86/pci/mmconfig_32.c
> +++ b/arch/x86/pci/mmconfig_32.c
> @@ -11,9 +11,9 @@
>  
>  #include <linux/pci.h>
>  #include <linux/init.h>
> -#include <linux/acpi.h>
>  #include <asm/e820.h>
>  #include <asm/pci_x86.h>
> +#include <acpi/acpi.h>
>  
>  /* Assume systems with more busses have correct MCFG */
>  #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
> diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> index 356d0a2..3c645bb 100644
> --- a/include/linux/sfi_acpi.h
> +++ b/include/linux/sfi_acpi.h
> @@ -50,8 +50,10 @@ extern int sfi_acpi_table_parse(char *signature, char *oem_id,
>  static inline int x86_table_parse(char *signature,
>  				int (*handler)(struct acpi_table_header *))
>  {
> +#ifdef CONFIG_ACPI
>  	if (!acpi_table_parse(signature, handler))
>  		return 0;
> +#endif
>  
>  	return sfi_acpi_table_parse(signature, NULL, NULL, handler);
>  }


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
