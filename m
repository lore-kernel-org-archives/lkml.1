Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXDBLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXDBLSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXDBLSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:18:17 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3278 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXDBLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:18:16 -0400
Date: Mon, 2 Apr 2007 13:17:45 +0200
From: thunder7@xs4all.nl
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070402111745.GA9882@amd64.of.nowhere>
Reply-To: Jurriaan <thunder7@xs4all.nl>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331071220.GA26910@aitel.hist.no> <20070331005303.354411f0.akpm@linux-foundation.org> <20070401052932.GA9894@amd64.of.nowhere> <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402074159.GA13704@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@in.ibm.com>
Date: Mon, Apr 02, 2007 at 01:11:59PM +0530
> 
> How about attached patch?
> 
> o X86_64 kernel should run from 2MB aligned address for two reasons.
> 	- Performance.
> 	- For relocatable kernels, page tables are updated based on difference
> 	  between compile time address and load time physical address.
> 	  This difference should be multiple of 2MB as kernel text and data
> 	  is mapped using 2MB pages and PMD should be pointing to a 2MB
> 	  aligned address. Life is simpler if both compile time and load time
> 	  kernel addresses are 2MB aligned.
> 
> o Flag the error at compile time if one is trying to build a kernel which
>   does not meet alignment restrictions.
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> ---
> 
>  arch/x86_64/kernel/head64.c |    8 ++++++++
>  include/asm-x86_64/page.h   |    1 +
>  2 files changed, 9 insertions(+)
> 
> diff -puN arch/x86_64/kernel/head64.c~x86_64-check-for-config-physical-start-aligned-2M arch/x86_64/kernel/head64.c
> --- linux-2.6.21-rc5-mm3-vanilla/arch/x86_64/kernel/head64.c~x86_64-check-for-config-physical-start-aligned-2M	2007-04-02 20:46:43.000000000 +0530
> +++ linux-2.6.21-rc5-mm3-vanilla-root/arch/x86_64/kernel/head64.c	2007-04-02 21:20:45.000000000 +0530
> @@ -62,6 +62,14 @@ void __init x86_64_start_kernel(char * r
>  {
>  	int i;
>  
> +	/*
> +	 * Make sure kernel is aligned to 2MB address. Catching it at compile
> +	 * time is better. Change your config file and compile the kernel
> +	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
> +	 */
> +	BUILD_BUG_ON(ALIGN(CONFIG_PHYSICAL_START, __KERNEL_ALIGN)
> +			!= CONFIG_PHYSICAL_START);
> +
>  	/* clear bss before set_intr_gate with early_idt_handler */
>  	clear_bss();
>  
> diff -puN include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M include/asm-x86_64/page.h
> --- linux-2.6.21-rc5-mm3-vanilla/include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M	2007-04-02 20:50:55.000000000 +0530
> +++ linux-2.6.21-rc5-mm3-vanilla-root/include/asm-x86_64/page.h	2007-04-02 20:51:34.000000000 +0530
> @@ -79,6 +79,7 @@ extern unsigned long phys_base;
>  #endif /* !__ASSEMBLY__ */
>  
>  #define __PHYSICAL_START	CONFIG_PHYSICAL_START
> +#define __KERNEL_ALIGN		0x200000
>  #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
>  #define __START_KERNEL_map	0xffffffff80000000
>  #define __PAGE_OFFSET           0xffff810000000000
> _

I'm only a user, so I'm not uptodate on these addresses and how they
work. However, how does this solve the problem that running 

make oldconfig

on a working 2.6.21-rc3-mm2 .config gives an unbootable 2.6.21-rc5-mm3
kernel? If I read things correctly, you now get a BUG, but the kernel
still won't boot. If that is correct, than I, as a user, don't think
that this is the solution that I feel comfortable with. 

If the kernel only boots CONFIG_PHYSICAL_START is aligned on a 2MB
address, then we should align it, not BUG out when it's not, and
especially not when it's unaligned through no fault of the user.

Kind regards,
Jurriaan
-- 
Debian (Unstable) GNU/Linux 2.6.21-rc5-mm3 2x2010 bogomips load 0.89
the Jack Vance Integral Edition: http://www.integralarchive.org
