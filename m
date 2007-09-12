Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXILWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXILWmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXILWmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:42:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbXILWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:42:36 -0400
Date: Wed, 12 Sep 2007 15:42:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: check and enable MMCONFIG for AMD Family 10h
 Opteron
Message-Id: <20070912154226.312e99fd.akpm@linux-foundation.org>
In-Reply-To: <200709121233.39218.yinghai.lu@sun.com>
References: <200709121233.39218.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 12:33:38 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: check and enable MMCONFIG for AMD Family 10h Opteron
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> Index: linux-2.6/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86_64/kernel/setup.c	2007-09-12 11:28:08.000000000 -0700
> +++ linux-2.6/arch/x86_64/kernel/setup.c	2007-09-12 12:09:32.000000000 -0700
> @@ -507,6 +507,32 @@
>  }
>  #endif
>  
> +/*[39:8] */
> +/* why not using 0xfe000000 ? */
> +#define FAM10H_PCI_MMIO_BASE 0xc0000000
> +static void fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
> +{
> +	u32 low, high, address;
> +
> +	address = 0xc0010058;
> +	if (rdmsr_safe(address, &low, &high))
> +		return;
> +
> +	if (low & 1)
> +		return;
> +
> +	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
> +	/*
> +	 * if it is not enable, let enable it and assume only one segement
> +	 * with 256 buses
> +	 */
> +	low &= ~(0xfff00000 | (0xf<<2));
> +	low |= (8<<2) | (1<<0);
> +	high &= ~(0x0000ffff);
> +	high |= (FAM10H_PCI_MMIO_BASE>>(32-8));
> +	wrmsr_safe(address, low, high);
> +}
> +
>  /*
>   * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
>   * Assumes number of cores is a power of two.
> @@ -655,6 +681,9 @@
>  	/* Family 10 doesn't support C states in MWAIT so don't use it */
>  	if (c->x86 == 0x10 && !force_mwait)
>  		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
> +
> +	if (c->x86 == 0x10)
> +		fam10h_check_enable_mmcfg(c);
>  }
>  
>  static void __cpuinit detect_ht(struct cpuinfo_x86 *c)

fixes:

--- a/arch/x86_64/kernel/setup.c~x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix
+++ a/arch/x86_64/kernel/setup.c
@@ -494,7 +494,7 @@ static int nearby_node(int apicid)
 /*[39:8] */
 /* why not using 0xfe000000 ? */
 #define FAM10H_PCI_MMIO_BASE 0xc0000000
-static void fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
+static void __cpuinit fam10h_check_enable_mmcfg(struct cpuinfo_x86 *c)
 {
 	u32 low, high, address;
 
@@ -507,8 +507,8 @@ static void fam10h_check_enable_mmcfg(st
 
 	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
 	/*
-	 * if it is not enable, let enable it and assume only one segement
-	 * with 256 buses
+	 * If it is not enabled, enable it and assume only one segment
+	 * with 256 busses.
 	 */
 	low &= ~(0xfff00000 | (0xf<<2));
 	low |= (8<<2) | (1<<0);
_

