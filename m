Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZHTLga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZHTLga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZHTLg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZHTLg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:36:28 -0400
Date: Thu, 20 Aug 2009 07:36:27 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Gianluca Guida <gianluca.guida@citrix.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Message-ID: <9027724.7841250768187449.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <19085.6134.99317.256150@gianluca.uk.xensource.com>
Subject: Re: [PATCH v2][v2.6.29][XEN] Return unused memory to hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
From: "Gianluca Guida" <gianluca.guida@citrix.com>
To: "Miroslav Rezanina" <mrezanin@redhat.com>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Sent: Thursday, August 20, 2009 11:31:34 AM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
Subject: [Xen-devel] [PATCH][v2.6.29][XEN] Return unused memory to hypervisor

Miroslav Rezanina writes:
> > Hi,
> > 
> > when running linux as XEN guest and use boot parameter mem= to set memory lower then is assigned to guest, not used memory should be returned to hypervisor as free. This is working with kernel available on xen.org pages, but is not working with kernel 2.6.29. Comparing both kernels I found code for returning unused memory to hypervisor is missing. Following patch add this functionality to 2.6.29 kernel.
> > 
>
> A good idea would be to avoid putting this code in the generic kernel
> code. For now just placing it in at the end of Xen's post-allocator
> init would make it completely transparent to the non-xen kernel.
>

Hi Gianluca,
good point. You're right. I moved calling to xen_post_allocator_init function. 
It is better place for it.

Regards,
Mirek

----diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b58e963..2a9cc80 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -28,6 +28,7 @@
 #include <linux/console.h>
 
 #include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
@@ -122,6 +123,36 @@ static int have_vcpu_info_placement =
 #endif
 	;
 
+/**
+ *  * Author: Miroslav Rezanina <mrezanin@redhat.com>
+ *   * Function retuns unused memory to hypevisor
+ *    **/
+void __init xen_return_unused_mem(void)
+{
+	if (xen_start_info->nr_pages > max_pfn) {
+	/*
+	 * the max_pfn was shrunk (probably by mem=
+         * kernel parameter); shrink reservation with the HV
+	 */
+		struct xen_memory_reservation reservation = {
+			.address_bits = 0,
+			.extent_order = 0,
+			.domid = DOMID_SELF
+		};
+		unsigned int difference;
+		int ret;
+
+		difference = xen_start_info->nr_pages - max_pfn;
+
+		set_xen_guest_handle(reservation.extent_start,
+			((unsigned long *)xen_start_info->mfn_list) + max_pfn);
+		reservation.nr_extents = difference;
+		ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
+			&reservation);
+		BUG_ON (ret != difference);
+	}
+}
+
 
 static void xen_vcpu_setup(int cpu)
 {
@@ -1057,6 +1088,8 @@ static __init void xen_post_allocator_init(void)
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
 	xen_mark_init_mm_pinned();
+
+	xen_return_unused_mem();
 }
 
 /* This is called once we have the cpu_possible_map */
