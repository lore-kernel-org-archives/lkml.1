Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbXHJKUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbXHJKUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXHJKU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:20:26 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:33412 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbXHJKUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:20:25 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: patches@x86-64.org
Subject: Re: [patches] [PATCH] [1/12] x86: Work around mmio config space
 quirk on AMD Fam10h
Date: Fri, 10 Aug 2007 12:19:50 +0200
User-Agent: KMail/1.9.7
cc: "Andi Kleen" <ak@suse.de>, dean@arctic.org, linux-kernel@vger.kernel.org
References: <20070809241.425881000@suse.de>
 <20070809124128.886BE14F3B@wotan.suse.de>
In-Reply-To: <20070809124128.886BE14F3B@wotan.suse.de>
MIME-Version: 1.0
Message-ID: <200708101219.51158.joachim.deguara@amd.com>
X-OriginalArrivalTime: 10 Aug 2007 10:19:52.0907 (UTC)
 FILETIME=[FDADF9B0:01C7DB37]
X-WSS-ID: 6AA2E451R0G4883217-02-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was just queuing up an identical patch ;) We didn't run into a problem yet 
but we were going to fix this to fit our BKDG documentation.  I didn't see 
the original email, could you point me to it?

-Joachim

On Thursday 09 August 2007 14:41:28 Andi Kleen wrote:
> From: dean gaudet <dean@arctic.org>
>
> Some broken devices have been discovered to require %al/%ax/%eax registers
> for MMIO config space accesses.  Modify mmconfig.c to use these registers
> explicitly (rather than modify the global readb/writeb/etc inlines).
>
> AK: also changed i386 to always use eax
> AK: moved change to extended space probing to different patch
> AK: reworked with inlines according to Linus' requirements.
> AK: improve comments.
>
> Signed-off-by: dean gaudet <dean@arctic.org>
> Signed-off-by: Andi Kleen <ak@suse.de>

ACKED-by: Joachim Deguara <joachim.deguara@amd.com

>
>
> ---
>  arch/i386/pci/mmconfig.c   |   14 ++++++--------
>  arch/i386/pci/pci.h        |   43
> +++++++++++++++++++++++++++++++++++++++++++ arch/x86_64/pci/mmconfig.c |  
> 12 ++++++------
>  3 files changed, 55 insertions(+), 14 deletions(-)
>
> Index: linux/arch/x86_64/pci/mmconfig.c
> ===================================================================
> --- linux.orig/arch/x86_64/pci/mmconfig.c
> +++ linux/arch/x86_64/pci/mmconfig.c
> @@ -66,13 +66,13 @@ static int pci_mmcfg_read(unsigned int s
>
>  	switch (len) {
>  	case 1:
> -		*value = readb(addr + reg);
> +		*value = mmio_config_readb(addr + reg);
>  		break;
>  	case 2:
> -		*value = readw(addr + reg);
> +		*value = mmio_config_readw(addr + reg);
>  		break;
>  	case 4:
> -		*value = readl(addr + reg);
> +		*value = mmio_config_readl(addr + reg);
>  		break;
>  	}
>
> @@ -94,13 +94,13 @@ static int pci_mmcfg_write(unsigned int
>
>  	switch (len) {
>  	case 1:
> -		writeb(value, addr + reg);
> +		mmio_config_writeb(addr + reg, value);
>  		break;
>  	case 2:
> -		writew(value, addr + reg);
> +		mmio_config_writew(addr + reg, value);
>  		break;
>  	case 4:
> -		writel(value, addr + reg);
> +		mmio_config_writel(addr + reg, value);
>  		break;
>  	}
>
> Index: linux/arch/i386/pci/mmconfig.c
> ===================================================================
> --- linux.orig/arch/i386/pci/mmconfig.c
> +++ linux/arch/i386/pci/mmconfig.c
> @@ -82,16 +82,15 @@ static int pci_mmcfg_read(unsigned int s
>
>  	switch (len) {
>  	case 1:
> -		*value = readb(mmcfg_virt_addr + reg);
> +		*value = mmio_config_readb(mmcfg_virt_addr + reg);
>  		break;
>  	case 2:
> -		*value = readw(mmcfg_virt_addr + reg);
> +		*value = mmio_config_readw(mmcfg_virt_addr + reg);
>  		break;
>  	case 4:
> -		*value = readl(mmcfg_virt_addr + reg);
> +		*value = mmio_config_readl(mmcfg_virt_addr + reg);
>  		break;
>  	}
> -
>  	spin_unlock_irqrestore(&pci_config_lock, flags);
>
>  	return 0;
> @@ -116,16 +115,15 @@ static int pci_mmcfg_write(unsigned int
>
>  	switch (len) {
>  	case 1:
> -		writeb(value, mmcfg_virt_addr + reg);
> +		mmio_config_writeb(mmcfg_virt_addr, value);
>  		break;
>  	case 2:
> -		writew(value, mmcfg_virt_addr + reg);
> +		mmio_config_writew(mmcfg_virt_addr, value);
>  		break;
>  	case 4:
> -		writel(value, mmcfg_virt_addr + reg);
> +		mmio_config_writel(mmcfg_virt_addr, value);
>  		break;
>  	}
> -
>  	spin_unlock_irqrestore(&pci_config_lock, flags);
>
>  	return 0;
> Index: linux/arch/i386/pci/pci.h
> ===================================================================
> --- linux.orig/arch/i386/pci/pci.h
> +++ linux/arch/i386/pci/pci.h
> @@ -104,3 +104,46 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
>  extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int
> bus, unsigned int devfn);
>  extern int __init pci_mmcfg_arch_init(void);
> +
> +/*
> + * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
> + * on their northbrige except through the * %eax register. As such, you
> MUST + * NOT use normal IOMEM accesses, you need to only use the magic
> mmio-config + * accessor functions.
> + * In fact just use pci_config_*, nothing else please.
> + */
> +static inline unsigned char mmio_config_readb(void __iomem *pos)
> +{
> +	u8 val;
> +	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline unsigned short mmio_config_readw(void __iomem *pos)
> +{
> +	u16 val;
> +	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline unsigned int mmio_config_readl(void __iomem *pos)
> +{
> +	u32 val;
> +	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline void mmio_config_writeb(void __iomem *pos, u8 val)
> +{
> +	asm volatile("movb %%al,(%1)" :: "a" (val), "r" (pos) : "memory");
> +}
> +
> +static inline void mmio_config_writew(void __iomem *pos, u16 val)
> +{
> +	asm volatile("movw %%ax,(%1)" :: "a" (val), "r" (pos) : "memory");
> +}
> +
> +static inline void mmio_config_writel(void __iomem *pos, u32 val)
> +{
> +	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
> +}
> _______________________________________________
> patches mailing list
> patches@x86-64.org
> https://www.x86-64.org/mailman/listinfo/patches




