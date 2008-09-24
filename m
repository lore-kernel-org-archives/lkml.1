Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYIXMy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYIXMy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIXMyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:54:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46706 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYIXMyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:54:18 -0400
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
In-Reply-To: <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com>
	 <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Wed, 24 Sep 2008 14:54:14 +0200
Message-Id: <1222260854.4166.3.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 septembre 2008 à 20:24 +0800, Yan Li a écrit :
> Since the mtrr empty was detected very early before we can use DMI or
> PCI to check whether we are running as a VMware guest or not, we now
> only print an info there. Warning will only be issued later when we
> are sure that we are not running as a VMware guest.
> 
> mtrr_trim_uncached_memory() is modified to return meaningful codes for
> later warning decision.
> 
> Signed-off-by: Yan Li <elliot.li.tech@gmail.com>
> ---
>  arch/x86/kernel/cpu/mtrr/main.c |   16 +++++++++++++++-
>  arch/x86/kernel/setup.c         |   27 ++++++++++++++++++++++++++-
>  include/asm-x86/mtrr.h          |    2 ++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index b117d7f..95d1cc0 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -1453,6 +1453,11 @@ static u64 __init real_trim_memory(unsigned long start_pfn,
>   * all of the memory the kernel is intending to use. If not, it'll trim any
>   * memory off the end by adjusting end_pfn, removing it from the kernel's
>   * allocation pools, warning the user with an obnoxious message.
> + *
> + * Return code:
> + * EMTRR_ALL_BLANK (-1):  not trimmed due to CPU MTRRs all blank
> + *                    0:  not trimmed due to other reasons
> + *                    1:  trimmed successfully
>   */
>  int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
>  {
> @@ -1494,11 +1499,20 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
>  			highest_pfn = base + size;
>  	}
>  
> -	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
> +	/* kvm/qemu/VMware doesn't have mtrr set right, don't trim them all */
>  	if (!highest_pfn) {
> +#ifdef CONFIG_VMWARE_GUEST_DETECT
> +		/* the "mtrr all blank" warning will be deferred until
> +		 * after DMI scanning and we know the machine is not a
> +		 * VMware guest
> +		 */
> +		printk(KERN_INFO "CPU MTRRs all blank\n");
> +		return EMTRR_ALL_BLANK;
> +#else
>  		WARN(!kvm_para_available(), KERN_WARNING
>  				"WARNING: strange, CPU MTRRs all blank?\n");
>  		return 0;
> +#endif
>  	}

perhaps something like:

#ifdef CONFIG_VMWARE_GUEST_DETECT
 		WARN(!kvm_para_available() && !is_vmware_guest(), KERN_WARNING
				"WARNING: strange, CPU MTRRs all blank?\n");
#else
 		WARN(!kvm_para_available(), KERN_WARNING
  				"WARNING: strange, CPU MTRRs all blank?\n");
...

???

Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
  "La perfection est atteinte non quand il ne reste rien à
ajouter mais quand il ne reste rien à enlever." Saint Exupéry

