Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZHTKGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZHTKGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZHTKGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:06:32 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:27628 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZHTKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:06:32 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 06:06:31 EDT
X-IronPort-AV: E=Sophos;i="4.43,413,1246838400"; 
   d="scan'208";a="6692406"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19085.6134.99317.256150@gianluca.uk.xensource.com>
Date: Thu, 20 Aug 2009 10:31:34 +0100
From: Gianluca Guida <gianluca.guida@citrix.com>
To: Miroslav Rezanina <mrezanin@redhat.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Xen-devel] [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
In-Reply-To: <1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <131246341.771871250687008542.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1962776416.772071250687130436.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Mailer: VM 8.0.12 under 22.3.1 (i486-pc-linux-gnu)
X-OriginalArrivalTime: 20 Aug 2009 09:56:46.0857 (UTC) FILETIME=[87A04790:01CA217C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miroslav Rezanina writes:
 > Hi,
 > 
 > when running linux as XEN guest and use boot parameter mem= to set memory lower then is assigned to guest, not used memory should be returned to hypervisor as free. This is working with kernel available on xen.org pages, but is not working with kernel 2.6.29. Comparing both kernels I found code for returning unused memory to hypervisor is missing. Following patch add this functionality to 2.6.29 kernel.
 > 

A good idea would be to avoid putting this code in the generic kernel
code. For now just placing it in at the end of Xen's post-allocator
init would make it completely transparent to the non-xen kernel.

There's a patch in Jeremy's rebase/master (at the moment reverted)
that allows guest to boot ballooned (which is the opposite of this
case, roughly) which does this kind of calculations while walking the
e820 table. Perhaps this can be moved there after things get to work
again.

Thanks,
Gianluca

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
 > _______________________________________________
 > Xen-devel mailing list
 > Xen-devel@lists.xensource.com
 > http://lists.xensource.com/xen-devel
