Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYHGNjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYHGNjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYHGNix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:38:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYHGNiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:38:52 -0400
Date: Thu, 7 Aug 2008 09:38:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 6/6] kexec jump: fix for ftrace
Message-ID: <20080807133805.GD27783@redhat.com>
References: <1218099937.5164.37.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099937.5164.37.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:05:37PM +0800, Huang Ying wrote:
> Restore ftrace after jumping back from kexeced kernel.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/machine_kexec_32.c |   19 +++++++++++++++++++
>  kernel/kexec.c                     |    2 --
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/numa.h>
>  #include <linux/ftrace.h>
> +#include <linux/suspend.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -117,6 +118,7 @@ void machine_kexec(struct kimage *image)
>  {
>  	unsigned long page_list[PAGES_NR];
>  	void *control_page;
> +	int save_ftrace_enabled;
>  	asmlinkage unsigned long
>  		(*relocate_kernel_ptr)(unsigned long indirection_page,
>  				       unsigned long control_page,
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

Hi Huang,

What kind of problem we run into if we don't disable the ftracer?

I think there are too many #ifdefs now and probably we can at least
get rid if #ifdef CONFIG_FTRACE thing.

I think ftracer needs to export the function to enable the tracer
back (tracer_enable()) so that we don't directly play with ftrace_enabled
variable. tracer_enable() can be do {} while{0} in case of CONFIG_FTRACE=n
so that we can get rid of #ifdefs here.

Thanks
Vivek
