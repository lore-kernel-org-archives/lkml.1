Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYFXQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYFXQfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYFXQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:35:31 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11750 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYFXQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:35:30 -0400
Date: Tue, 24 Jun 2008 10:35:29 -0600
From: Alex Chiang <achiang@hp.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Robin Holt <holt@sgi.com>, linux-ia64@vger.kernel.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: FW: [BISECT] Boot failure on ia64.
Message-ID: <20080624163529.GD3599@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Jes Sorensen <jes@sgi.com>,
	Robin Holt <holt@sgi.com>, linux-ia64@vger.kernel.org,
	tony.luck@intel.com, linux-kernel@vger.kernel.org
References: <20080624143922.GK10123@sgi.com> <yq0hcbiluke.fsf@jaguar.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq0hcbiluke.fsf@jaguar.mkp.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jes Sorensen <jes@sgi.com>:
> >>>>> "Robin" == Robin Holt <holt@sgi.com> writes:
> 
> Robin> Oops, missed sending this to the ia64 mailing list.  Robin
> 
> Hi Robin,
> 
> Just hit the same problem and did a little digging. It's because
> platform_send_ipi() ends up doing a cpuid_to_nasid() on sn2, which
> relies on NUMA information etc. being setup. 
> 
> In fact, check_sal_cache_flush() is called a fair bit before
> platform_setup() in arch/ia64/kernel/setup.c, which I would claim is
> completely broken.

Yeah, using platform_* before platform_setup() completes is
probably a bad idea. :-/

> Either check_sal_cache_flush() needs to be moved to after
> platform_setup() or Alex's patch should be reverted until a better
> solution is found. I am attaching a patch that does the former, but I
> don't know if this is safe on HP's systems.
> 
> This boots on SN2.

This patch works on 

	- rx5670 (the original buggy HP platform)
	- rx6600 (low-end HP platform)
	- rx7620 (mid-range HP platform)

Thanks for fixing this.

Tested-by: Alex Chiang <achiang@hp.com>

/ac

> 
> Cheers,
> Jes
> 
> Call check_sal_cache_flush() after platform_setup() as
> check_sal_cache_flush() now relies on being able to call platform
> vector code.
> 
> Signed-off-by: Jes Sorensen <jes@sgi.com>
> ---
>  arch/ia64/kernel/setup.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6.git/arch/ia64/kernel/setup.c
> ===================================================================
> --- linux-2.6.git.orig/arch/ia64/kernel/setup.c
> +++ linux-2.6.git/arch/ia64/kernel/setup.c
> @@ -578,8 +578,6 @@ setup_arch (char **cmdline_p)
>  	cpu_init();	/* initialize the bootstrap CPU */
>  	mmu_context_init();	/* initialize context_id bitmap */
>  
> -	check_sal_cache_flush();
> -
>  #ifdef CONFIG_ACPI
>  	acpi_boot_init();
>  #endif
> @@ -607,6 +605,7 @@ setup_arch (char **cmdline_p)
>  		ia64_mca_init();
>  
>  	platform_setup(cmdline_p);
> +	check_sal_cache_flush();
>  	paging_init();
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
