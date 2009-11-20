Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZKTNUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZKTNUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZKTNUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:20:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50603 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZKTNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:20:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=FEXt1WCeQJvUQi7J2sA4uEyzOHvxtexeFvqvi+DgHdA+d30hB2kH3CVF654wuR0qqW
         fHCwQ8gx68yUVe+mVUi1Vrqzn57IzQ2Hom0yLr1XU78luim/u2v0cAzzoyPfME3kabKG
         vu8QgfuHl5vBGbCMtPhq5sXdnoUgl/Ui7fuLE=
Subject: Re: [PATCH] MIPS: Add a high precision sched_clock() via
 cnt32_to_63().
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1258703602-29065-1-git-send-email-wuzhangjin@gmail.com>
References: <1258703602-29065-1-git-send-email-wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 20 Nov 2009 21:20:37 +0800
Message-ID: <1258723237.5791.18.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> ---
>  arch/mips/kernel/csrc-r4k.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
> index e95a3cd..865035d 100644
> --- a/arch/mips/kernel/csrc-r4k.c
> +++ b/arch/mips/kernel/csrc-r4k.c
> @@ -6,10 +6,45 @@
>   * Copyright (C) 2007 by Ralf Baechle
>   */
>  #include <linux/clocksource.h>
> +#include <linux/cnt32_to_63.h>
> +#include <linux/timer.h>

Sorry, <linux/timer.h> is not needed here, I have used it in the old
version with setup_timer()/mod_timer().

>  #include <linux/init.h>
>  
>  #include <asm/time.h>
>  
> +/*
> + * MIPS' sched_clock implementation.
> + *
> + * NOTE: because cnt32_to_63() needs to be called at least once per half period
> + * to work properly, and some of the MIPS' frequency is very low, perhaps a
> + * kernel timer is needed to be set up to ensure this requirement is always
> + * met. please refer to  arch/arm/plat-orion/time.c and
> + * include/linux/cnt32_to_63.h
> + */
> +static unsigned long tclk2ns_scale, tclk2ns_scale_factor;
> +
> +unsigned long long notrace sched_clock(void)
> +{
> +	unsigned long long v = cnt32_to_63(read_c0_count());
> +	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
> +}
> +
> +static void __init setup_sched_clock(struct clocksource *cs, unsigned long tclk)

the tclk is not used, I have also used it in the old version with
setup_timer()/mod_timer(). so, we can remove it for this version.

> +{
> +	unsigned long long v;
> +
> +	v = cs->mult;
> +	/*
> +	 * We want an even value to automatically clear the top bit
> +	 * returned by cnt32_to_63() without an additional run time
> +	 * instruction. So if the LSB is 1 then round it up.
> +	 */
> +	if (v & 1)
> +		v++;
> +	tclk2ns_scale = v;
> +	tclk2ns_scale_factor = cs->shift;
> +}
> +
>  static cycle_t c0_hpt_read(struct clocksource *cs)
>  {
>  	return read_c0_count();
> @@ -32,6 +67,8 @@ int __init init_r4k_clocksource(void)
>  
>  	clocksource_set_clock(&clocksource_mips, mips_hpt_frequency);
>  
> +	setup_sched_clock(&clocksource_mips, mips_hpt_frequency);
> +

And here should be setup_sched_clock(&clocksource_mips);

Regards,
	Wu Zhangjin

