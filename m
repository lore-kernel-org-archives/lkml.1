Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbZHSPwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbZHSPwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZHSPwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:52:02 -0400
Received: from www.tglx.de ([62.245.132.106]:49947 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZHSPwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:52:01 -0400
Date: Wed, 19 Aug 2009 17:51:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 7/10] x86/tsc: enable APB timer based calibration
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF9@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191750140.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF9@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> >From e9264a1e5f8662d64f7d042544a03504b325bac9 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Wed, 15 Jul 2009 14:20:02 -0700
> Subject: [PATCH] x86/tsc: enable APB timer based calibration
> 
> for platform that do not have PIT, we can use APB timer (if available)
> to calibrate TSC by counting the two. APB timer frequency is known to
> the system by SFI table provided by FW.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/kernel/tsc.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 6e1a368..8b38a9d 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -18,6 +18,9 @@
>  #include <asm/delay.h>
>  #include <asm/hypervisor.h>
>  
> +#include <asm/platform_feature.h>
> +#include <asm/apb_timer.h>
> +
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
>  
> @@ -394,6 +397,14 @@ unsigned long native_calibrate_tsc(void)
>  		return hv_tsc_khz;
>  	}
>  
> +	/* first check if apb timer exist and is usable */
> +	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +		local_irq_save(flags);
> +		fast_calibrate = apbt_quick_calibrate();
> +		local_irq_restore(flags);
> +		if (fast_calibrate)
> +			return fast_calibrate;

  And what is calibrating the TSC here. There is not PIT or comes that
  magically when the APBT thing fails ?

> +	}
>  	local_irq_save(flags);
>  	fast_calibrate = quick_pit_calibrate();
>  	local_irq_restore(flags);
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
