Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZHKMlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZHKMlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZHKMls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:41:48 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:34976 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZHKMlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:41:42 -0400
Date: Tue, 11 Aug 2009 10:45:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Feng Tang <feng.tang@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH]x86/RTC: introduce a new generic rtc_ops for x86
Message-ID: <20090811084529.GB25647@elte.hu>
References: <20090811154850.3127fff0@feng-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811154850.3127fff0@feng-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> Please help to review this patch, thanks!
> 
> It is generated against kernel 2.6.31-rc5
> 
> - Feng
> 
> From a8ee2a78bcc1df57f2f43ff526269d69a2801a64 Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Wed, 17 Jun 2009 10:31:17 +0800
> Subject: [PATCH] x86/RTC: introduce a new generic rtc_ops for x86
> 
> System time keeping needs get_wallclock/set_wallclock supports, 
> currently this support comes from Motorola 146818 like RTC device 
> or EFI, or even virtualization, but in the future, there will be 
> other x86 platforms which don't have these options and have their 
> own RTC devices other than the 146818. So a more generic structure 
> is needed to support all platforms' need
> 
> This patch adds a arch_rtc_ops structure, which only has 2 API 
> pointers of get/set wall clock, each platform can register its own 
> desired RTC ops to be the one to use
> 
> Current patch only modifies the rtc.c and efi.c to incorporate 
> this change, further on we can think about to use it for the 
> paravirt code, which could make the asm/time.h much cleaner
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  arch/x86/include/asm/time.h |   45 +++++++++++-------------------------------
>  arch/x86/kernel/efi.c       |   12 +++++++++++
>  arch/x86/kernel/rtc.c       |    5 ++++
>  3 files changed, 29 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
> index 50c733a..3665a9c 100644
> --- a/arch/x86/include/asm/time.h
> +++ b/arch/x86/include/asm/time.h
> @@ -1,53 +1,32 @@
>  #ifndef _ASM_X86_TIME_H
>  #define _ASM_X86_TIME_H
>  
> +#include <asm/mc146818rtc.h>
> +
>  extern void hpet_time_init(void);
> +extern void time_init(void);
>  
> -#include <asm/mc146818rtc.h>
> -#ifdef CONFIG_X86_32
> -#include <linux/efi.h>
> +struct arch_rtc_dev_ops {
> +	unsigned long	(*get_wall_time)(void);
> +	int		(*set_wall_time)(unsigned long);
> +};
> +extern struct arch_rtc_dev_ops *x86_rtc_ops;

looks like the right direction at first glance. What's the 
management interface around the driver (there's none at the moment)? 
Set up at early boot time and never changed afterwards?

Have you looked at other architectures (MIPS, ARM, etc.) to see how 
they abstracted away their RTC functionality?

	Ingo
