Return-Path: <linux-kernel-owner+w=401wt.eu-S1765335AbYEUBJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765335AbYEUBJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934574AbYEUBH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:07:58 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44746 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934491AbYEUBH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:07:57 -0400
Message-ID: <4833767D.3080903@keyaccess.nl>
Date: Wed, 21 May 2008 03:10:21 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Mikael Pettersson <mikpe@it.uu.se>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add a boot parameter to force-enable PAT
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com> <20080520132306.GB4843@redhat.com> <18482.58121.130009.555407@harpo.it.uu.se> <20080520195846.GA29806@redhat.com> <48334766.1020701@keyaccess.nl> <48334EFA.3070109@zytor.com> <483353DB.7010708@keyaccess.nl> <483353E9.7090001@zytor.com> <20080520225617.GA19002@redhat.com>
In-Reply-To: <20080520225617.GA19002@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 00:56, Dave Jones wrote:

> Not boot-tested, but it compiles for me..

It doesn't even apply for me. Moreover though -- __early_param() still 
seems to be too late for validate_pat_support() so this isn't going to work.

__setup() is even later than that. I guess this just wants to set a flag 
from validate_pat_support() which arch/x86/mm/pat.c can then check later?

> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -51,8 +51,15 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  }
>  
>  #ifdef CONFIG_X86_PAT
> +int forcepat;
> +
>  void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
>  {
> +	if (forcepat == 1) {
> +		printk(KERN_INFO "Force enabling PAT\n");
> +		return;
> +	}
> +
>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_AMD:
>  		if (c->x86 >= 0xf && c->x86 <= 0x11)
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index e83b770..7429bee 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -25,8 +25,11 @@
>  #include <asm/mtrr.h>
>  #include <asm/io.h>
>  
> +static int debug_enable;
> +
>  #ifdef CONFIG_X86_PAT
>  int __read_mostly pat_wc_enabled = 1;
> +extern int forcepat;
>  
>  void __cpuinit pat_disable(char *reason)
>  {
> @@ -34,23 +37,22 @@ void __cpuinit pat_disable(char *reason)
>  	printk(KERN_INFO "%s\n", reason);
>  }
>  
> -static int nopat(char *str)
> +static int __init patsetup(char *str)
>  {
> -	pat_disable("PAT support disabled.");
> +	if (strcmp("force", str) == 0) {
> +		forcepat = 1;
> +		printk(KERN_INFO "Force enabling PAT\n");
> +	}
> +	if (strcmp("off", str) == 0)
> +		pat_disable("PAT support disabled.");
> +	if (strcmp("debug", str) == 0)
> +		debug_enable = 1;
>  	return 0;
>  }
> -early_param("nopat", nopat);
> +early_param("pat=", patsetup);
>  #endif
>  
>  
> -static int debug_enable;
> -static int __init pat_debug_setup(char *str)
> -{
> -	debug_enable = 1;
> -	return 0;
> -}
> -__setup("debugpat", pat_debug_setup);
> -
>  #define dprintk(fmt, arg...) \
>  	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
>  
> 

Rene.

