Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZIPH4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZIPH4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZIPH4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZIPH4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:56:14 -0400
Date: Wed, 16 Sep 2009 03:56:17 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Message-ID: <1250041003.152221253087777235.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1582654680.152201253087647836.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Jeremy Fitzhardinge" <jeremy@goop.org>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
> Sent: Friday, September 4, 2009 1:26:24 AM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> On 08/19/09 06:05, Miroslav Rezanina wrote:
> > when running linux as XEN guest and use boot parameter mem= to set
> memory lower then is assigned to guest, not used memory should be
> returned to hypervisor as free. This is working with kernel available
> on xen.org pages, but is not working with kernel 2.6.29. Comparing
> both kernels I found code for returning unused memory to hypervisor is
> missing. Following patch add this functionality to 2.6.29 kernel.
> >   
> 
> Are you planning on submitting a revised patch along the lines I
> suggested?
> 
> Thanks,
>     J
General version of patch. This version checks the e820 map for holes
and returns all memory that is not mapped.

Patch:
===========
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b58e963..acc9166 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <xen/interface/version.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
+#include <xen/interface/memory.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvc-console.h>
@@ -122,6 +123,59 @@ static int have_vcpu_info_placement =
 #endif
 	;
 
+void __init xen_return_unused_memory(void)
+{
+	static struct e820map holes = {
+		.nr_map = 0
+	};
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+	unsigned long last_end = 0;
+	int i;
+
+	for(i=0;i<e820.nr_map;i++) {
+		if (e820.map[i].addr > last_end) {
+			holes.map[holes.nr_map].addr = last_end;
+			holes.map[holes.nr_map].size =
+				e820.map[i].addr - last_end;
+			holes.nr_map++;
+		}		
+		last_end = e820.map[i].addr + e820.map[i].size;
+	}
+
+	if (last_end < PFN_PHYS((u64)xen_start_info->nr_pages)) {
+		holes.map[holes.nr_map].addr=last_end;
+		holes.map[holes.nr_map].size =
+			PFN_PHYS((u64)xen_start_info->nr_pages) - last_end;
+		holes.nr_map++;
+	}
+
+	if (holes.nr_map == 0)
+		return;
+
+	for(i=0;i<holes.nr_map;i++) {
+		unsigned long spfn = holes.map[i].addr >> PAGE_SHIFT;
+		unsigned long epfn = ((holes.map[i].addr + holes.map[i].size) >> PAGE_SHIFT);
+		int ret;
+
+		if (spfn % PAGE_SIZE != 0)
+			spfn++;
+
+		if (spfn >= epfn)
+			continue;
+
+		set_xen_guest_handle(reservation.extent_start,
+			((unsigned long *)xen_start_info->mfn_list) + spfn);
+
+		reservation.nr_extents = epfn - spfn;
+		ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
+			&reservation);
+		BUG_ON (ret != epfn - spfn);
+	}
+}
 
 static void xen_vcpu_setup(int cpu)
 {
@@ -1057,6 +1111,8 @@ static __init void xen_post_allocator_init(void)
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
 	xen_mark_init_mm_pinned();
+
+/*	xen_return_unused_memory(); */
 }
 
 /* This is called once we have the cpu_possible_map */
-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

