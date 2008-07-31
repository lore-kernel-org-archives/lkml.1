Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYGaVuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYGaVuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYGaVuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:50:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbYGaVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:50:05 -0400
Date: Thu, 31 Jul 2008 14:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: fdiv bug detection fix
Message-Id: <20080731144920.0016e02d.akpm@linux-foundation.org>
In-Reply-To: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl>
References: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 23:43:44 +0200
Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The fdiv detection code writes s32 integer into
> the boot_cpu_data.fdiv_bug. 
> However, the boot_cpu_data.fdiv_bug is only char (s8)
> field so the detection overwrites already set fields for
> other bugs, e.g. the f00f bug field.
> 
> Use local s32 variable to receive result.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
> 
> This is a partial fix to Bugzilla #9928  - fixes wrong 
> information about the f00f bug (tested) and probably
> for coma bug (I have no cpu to test this).
> 
> diff -urp linux-alsa/arch/x86/kernel/cpu/bugs.c linux-new/arch/x86/kernel/cpu/bugs.c
> --- linux-alsa/arch/x86/kernel/cpu/bugs.c	2008-07-31 12:40:31.000000000 +0200
> +++ linux-new/arch/x86/kernel/cpu/bugs.c	2008-07-31 23:24:07.722657435 +0200
> @@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
>   */
>  static void __init check_fpu(void)
>  {
> +	s32 fdiv_bug;
> +
>  	if (!boot_cpu_data.hard_math) {
>  #ifndef CONFIG_MATH_EMULATION
>  		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
> @@ -74,8 +76,10 @@ static void __init check_fpu(void)
>  		"fistpl %0\n\t"
>  		"fwait\n\t"
>  		"fninit"
> -		: "=m" (*&boot_cpu_data.fdiv_bug)
> +		: "=m" (*&fdiv_bug)
>  		: "m" (*&x), "m" (*&y));
> +
> +	boot_cpu_data.fdiv_bug = fdiv_bug;
>  	if (boot_cpu_data.fdiv_bug)
>  		printk("Hmm, FPU with FDIV bug.\n");
>  }

hm, the code seems to have been that way for quite some time.  I wonder
why nobody noticed this before.  
