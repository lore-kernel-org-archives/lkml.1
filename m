Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYHGMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYHGMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYHGMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYHGMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:51 -0400
Date: Thu, 7 Aug 2008 11:24:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 6/6] kexec jump: fix for ftrace
Message-ID: <20080807092405.GF372@atrey.karlin.mff.cuni.cz>
References: <1218099937.5164.37.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099937.5164.37.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Restore ftrace after jumping back from kexeced kernel.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/machine_kexec_32.c |   19 +++++++++++++++++++
>  kernel/kexec.c                     |    2 --
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> @@ -124,7 +126,15 @@ void machine_kexec(struct kimage *image)
>  				       unsigned int has_pae,
>  				       unsigned int preserve_context);
>  
> +#ifdef CONFIG_KEXEC_JUMP
> +	if (kexec_image->preserve_context)
> +		save_processor_state();
> +#endif
> +
> +#ifdef CONFIG_FTRACE
> +	save_ftrace_enabled = ftrace_enabled;
>  	tracer_disable();
> +#endif
>  
>  	/* Interrupts aren't acceptable while we reboot */
>  	raw_local_irq_disable();

The patch does way more than its changelog says...
									Pavel


> @@ -182,6 +192,15 @@ void machine_kexec(struct kimage *image)
>  					   (unsigned long)page_list,
>  					   image->start, cpu_has_pae,
>  					   image->preserve_context);
> +
> +#ifdef CONFIG_KEXEC_JUMP
> +	if (kexec_image->preserve_context)
> +		restore_processor_state();
> +#endif
> +
> +#ifdef CONFIG_FTRACE
> +	ftrace_enabled = save_ftrace_enabled;
> +#endif
>  }
>  
>  void arch_crash_save_vmcoreinfo(void)
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1469,7 +1469,6 @@ int kernel_kexec(void)
>  		error = device_power_down(PMSG_FREEZE);
>  		if (error)
>  			goto Enable_irqs;
> -		save_processor_state();
>  	} else
>  #endif
>  	{
> @@ -1482,7 +1481,6 @@ int kernel_kexec(void)
>  
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
> -		restore_processor_state();
>  		device_power_up(PMSG_RESTORE);
>   Enable_irqs:
>  		local_irq_enable();
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
