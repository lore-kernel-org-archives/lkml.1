Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935327Ab0BZGTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 01:19:21 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:49240 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935299Ab0BZGTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 01:19:20 -0500
Date: Fri, 26 Feb 2010 01:18:45 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com
Subject: Re: [tip:x86/mrst] x86, olpc: Use pci subarch init for OLPC
Message-ID: <20100226011845.4fa30e26@droptest.queued.net>
In-Reply-To: <tip-d5d0e88c1e5b069aadb050ff6ec95df312de876a@git.kernel.org>
References: <43F901BD926A4E43B106BF17856F0755A318CE89@orsmsx508.amr.corp.intel.com>
	<tip-d5d0e88c1e5b069aadb050ff6ec95df312de876a@git.kernel.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 04:45:59 GMT
tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:

> Commit-ID:  d5d0e88c1e5b069aadb050ff6ec95df312de876a
> Gitweb:     http://git.kernel.org/tip/d5d0e88c1e5b069aadb050ff6ec95df312de876a
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 22 Feb 2010 05:42:04 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 25 Feb 2010 19:26:23 -0800
> 
> x86, olpc: Use pci subarch init for OLPC
> 
> Replace the #ifdef'ed OLPC-specific init functions by a conditional
> x86_init function.  If the function returns 0 we leave pci_arch_init,
> otherwise we continue.


Looks like a win in my book.

Acked-by: Andres Salomon <dilinger@collabora.co.uk>

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Andres Salomon <dilinger@collabora.co.uk>
> LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318CE89@orsmsx508.amr.corp.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/include/asm/olpc.h    |   20 ++------------------
>  arch/x86/include/asm/pci_x86.h |    1 -
>  arch/x86/kernel/olpc.c         |   10 +++++++---
>  arch/x86/pci/init.c            |    8 ++++----
>  arch/x86/pci/olpc.c            |    3 ---
>  5 files changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
> index 3a57385..101229b 100644
> --- a/arch/x86/include/asm/olpc.h
> +++ b/arch/x86/include/asm/olpc.h
> @@ -13,7 +13,6 @@ struct olpc_platform_t {
>  
>  #define OLPC_F_PRESENT		0x01
>  #define OLPC_F_DCON		0x02
> -#define OLPC_F_VSA		0x04
>  
>  #ifdef CONFIG_OLPC
>  
> @@ -51,18 +50,6 @@ static inline int olpc_has_dcon(void)
>  }
>  
>  /*
> - * The VSA is software from AMD that typical Geode bioses will include.
> - * It is used to emulate the PCI bus, VGA, etc.  OLPC's Open Firmware does
> - * not include the VSA; instead, PCI is emulated by the kernel.
> - *
> - * The VSA is described further in arch/x86/pci/olpc.c.
> - */
> -static inline int olpc_has_vsa(void)
> -{
> -	return (olpc_platform_info.flags & OLPC_F_VSA) ? 1 : 0;
> -}
> -
> -/*
>   * The "Mass Production" version of OLPC's XO is identified as being model
>   * C2.  During the prototype phase, the following models (in chronological
>   * order) were created: A1, B1, B2, B3, B4, C1.  The A1 through B2 models
> @@ -87,13 +74,10 @@ static inline int olpc_has_dcon(void)
>  	return 0;
>  }
>  
> -static inline int olpc_has_vsa(void)
> -{
> -	return 0;
> -}
> -
>  #endif
>  
> +extern int pci_olpc_init(void);
> +
>  /* EC related functions */
>  
>  extern int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
> diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
> index 6e69edf..3608551 100644
> --- a/arch/x86/include/asm/pci_x86.h
> +++ b/arch/x86/include/asm/pci_x86.h
> @@ -104,7 +104,6 @@ extern bool port_cf9_safe;
>  extern int pci_direct_probe(void);
>  extern void pci_direct_init(int type);
>  extern void pci_pcbios_init(void);
> -extern int pci_olpc_init(void);
>  extern void __init dmi_check_pciprobe(void);
>  extern void __init dmi_check_skip_isa_align(void);
>  
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 9d1d263..8297160 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -17,7 +17,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
>  #include <linux/string.h>
> +
>  #include <asm/geode.h>
> +#include <asm/setup.h>
>  #include <asm/olpc.h>
>  
>  #ifdef CONFIG_OPEN_FIRMWARE
> @@ -243,9 +245,11 @@ static int __init olpc_init(void)
>  	olpc_ec_cmd(EC_FIRMWARE_REV, NULL, 0,
>  			(unsigned char *) &olpc_platform_info.ecver, 1);
>  
> -	/* check to see if the VSA exists */
> -	if (cs5535_has_vsa2())
> -		olpc_platform_info.flags |= OLPC_F_VSA;
> +#ifdef CONFIG_PCI_OLPC
> +	/* If the VSA exists let it emulate PCI, if not emulate in kernel */
> +	if (!cs5535_has_vsa2())
> +		x86_init.pci.arch_init = pci_olpc_init;
> +#endif
>  
>  	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
>  			((olpc_platform_info.boardrev & 0xf) < 8) ? "pre" : "",
> diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
> index 25a1f8e..adb62aa 100644
> --- a/arch/x86/pci/init.c
> +++ b/arch/x86/pci/init.c
> @@ -1,6 +1,7 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  #include <asm/pci_x86.h>
> +#include <asm/x86_init.h>
>  
>  /* arch_initcall has too random ordering, so call the initializers
>     in the right sequence from here. */
> @@ -15,10 +16,9 @@ static __init int pci_arch_init(void)
>  	if (!(pci_probe & PCI_PROBE_NOEARLY))
>  		pci_mmcfg_early_init();
>  
> -#ifdef CONFIG_PCI_OLPC
> -	if (!pci_olpc_init())
> -		return 0;	/* skip additional checks if it's an XO */
> -#endif
> +	if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
> +		return 0;
> +
>  #ifdef CONFIG_PCI_BIOS
>  	pci_pcbios_init();
>  #endif
> diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
> index b889d82..b348154 100644
> --- a/arch/x86/pci/olpc.c
> +++ b/arch/x86/pci/olpc.c
> @@ -304,9 +304,6 @@ static struct pci_raw_ops pci_olpc_conf = {
>  
>  int __init pci_olpc_init(void)
>  {
> -	if (!machine_is_olpc() || olpc_has_vsa())
> -		return -ENODEV;
> -
>  	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
>  	raw_pci_ops = &pci_olpc_conf;
>  	is_lx = is_geode_lx();

