Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbZKVFaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbZKVFaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 00:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZKVFaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 00:30:35 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:34002 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZKVFae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 00:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=R/VgGHTCJiua7/HzItLmJtWV9tlgDHzBefeAkjp14jkkkZrvrEaz2ZEa6+G07PpwrM
         mAUMiotBBKgGdtpuPIyznqsP6Fgyt2Kab3P7g3eIMJdM2+HijOVBaZXPJfrtzZJ65hp/
         824L87BIcUQhrAOCbH+QR3ToYaQo5Or4BDMl4=
Subject: Re: [PATCH v1] MIPS: Add a high precision sched_clock() via
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
In-Reply-To: <0d92a3c45f7ffff2b0df815c4345d6e9a01cb00c.1258814214.git.wuzhangjin@gmail.com>
References: <0d92a3c45f7ffff2b0df815c4345d6e9a01cb00c.1258814214.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sun, 22 Nov 2009 13:30:26 +0800
Message-ID: <1258867826.1864.2.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 22:49 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch adds a cnt32_to_63() and MIPS c0 count based sched_clock(),
> which can provide high resolution. and also, two new kernel options are
> added. the HR_SCHED_CLOCK is used to enable/disable this sched_clock(),
> and the HT_SCHED_CLOCK_UPDATE is used to allow whether update the
> sched_clock() automatically or not.
> 
> Without it, the Ftrace for MIPS will give useless timestamp information.
> 
> (Because cnt32_to_63() needs to be called at least once per half period
> to work properly, Differ from the old version, this v1 revision set up a
> kernel timer to ensure the requirement of some MIPSs which have short c0
> count period.)
[...]
>  
> diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
> index e95a3cd..5048989 100644
> --- a/arch/mips/kernel/csrc-r4k.c
> +++ b/arch/mips/kernel/csrc-r4k.c
> @@ -6,10 +6,62 @@
>   * Copyright (C) 2007 by Ralf Baechle
>   */
>  #include <linux/clocksource.h>
> +#include <linux/cnt32_to_63.h>
> +#include <linux/timer.h>
>  #include <linux/init.h>
>  
>  #include <asm/time.h>
>  
> +/*
> + * MIPS' sched_clock implementation.
> + *
> + * because cnt32_to_63() needs to be called at least once per half period to
> + * work properly, and some of the MIPS' frequency is very low, perhaps a kernel
> + * timer is needed to be set up to ensure this requirement is always met.
> + * please refer to  arch/arm/plat-orion/time.c and include/linux/cnt32_to_63.h
> + */
> +static unsigned long __maybe_unused tclk2ns_scale;
> +static unsigned long __maybe_unused tclk2ns_scale_factor;
> +

need to be:

#ifdef CONFIG_HR_SCHED_CLOCK
> +unsigned long long notrace sched_clock(void)
> +{
> +	unsigned long long v = cnt32_to_63(read_c0_count());
> +	return (v * tclk2ns_scale) >> tclk2ns_scale_factor;
> +}
> +
#endif

Regards,
	Wu Zhangjin

