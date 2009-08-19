Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZHSQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZHSQQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZHSQQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:16:33 -0400
Received: from claw.goop.org ([74.207.240.146]:36774 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZHSQQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:16:32 -0400
Message-ID: <4A8C2561.5080304@goop.org>
Date: Wed, 19 Aug 2009 09:16:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Miroslav Rezanina <mrezanin@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Gianluca Guida <gianluca.guida@citrix.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
References: <1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/09 06:05, Miroslav Rezanina wrote:
> when running linux as XEN guest and use boot parameter mem= to set memory lower then is assigned to guest, not used memory should be returned to hypervisor as free. This is working with kernel available on xen.org pages, but is not working with kernel 2.6.29. Comparing both kernels I found code for returning unused memory to hypervisor is missing. Following patch add this functionality to 2.6.29 kernel.
>   

The idea is sound, but I think it might be better to walk the e820
table, and remove any memory ranges which aren't marked as E820_RAM. 
That makes it possible to carve holes in the address space as well as
simply truncate it.

Also, something appears to have smashed your indentation.

    J

> Miroslav Rezanina <mrezanin@redhat.com>
> --
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 6a8811a..fd6b0e7 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -118,6 +118,10 @@ struct boot_params __initdata boot_params;
>  struct boot_params boot_params;
>  #endif
>  
> +#ifdef CONFIG_XEN
> +void __init xen_return_unused_mem(void);
> +#endif
> +
>  /*
>   * Machine setup..
>   */
> @@ -920,6 +924,9 @@ void __init setup_arch(char **cmdline_p)
>  	paging_init();
>  	paravirt_pagetable_setup_done(swapper_pg_dir);
>  	paravirt_post_allocator_init();
> +#ifdef CONFIG_XEN
> +	xen_return_unused_mem();
> +#endif
>  
>  #ifdef CONFIG_X86_64
>  	map_vsyscall();
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 15c6c68..bc5d2bc 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -20,6 +20,7 @@
>  #include <xen/page.h>
>  #include <xen/interface/callback.h>
>  #include <xen/interface/physdev.h>
> +#include <xen/interface/memory.h>
>  #include <xen/features.h>
>  
>  #include "xen-ops.h"
> @@ -34,6 +35,36 @@ extern void xen_syscall32_target(void);
>  
>  
>  /**
> + * Author: Miroslav Rezanina <mrezanin@redhat.com>
> + * Function retuns unused memory to hypevisor
> + **/
> +void __init xen_return_unused_mem(void)
> +{
> +	if (xen_start_info->nr_pages > max_pfn) {
> +        /*
> +	* the max_pfn was shrunk (probably by mem=
> +	* kernel parameter); shrink reservation with the HV
> +	*/
> +	struct xen_memory_reservation reservation = {
> +	.address_bits = 0,
> +	.extent_order = 0,
> +	.domid = DOMID_SELF
> +	};
> +	unsigned int difference;
> +	int ret;
> +
> +	difference = xen_start_info->nr_pages - max_pfn;
> +
> +	set_xen_guest_handle(reservation.extent_start,
> +		((unsigned long *)xen_start_info->mfn_list) + max_pfn);
> +	reservation.nr_extents = difference;
> +	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
> +		&reservation);
> +	BUG_ON (ret != difference);
> +	}
> +}
> +
> +/**
>   * machine_specific_memory_setup - Hook for machine specific memory setup.
>   **/
>  
>
>   

