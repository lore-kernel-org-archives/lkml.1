Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXJLVsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXJLVsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760547AbXJLVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:44 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42270 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758549AbXJLVol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:41 -0400
Message-Id: <20071012211148.610399000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>,
       Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: [PATCH 08/10] xen: fix incorrect vcpu_register_vcpu_info hypercall argument
Content-Disposition: inline; filename=xen-fix-register_vcpu_info.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's copy of struct vcpu_register_vcpu_info was out of date,
at best causing the hypercall to fail and the guest kernel to fall
back to the old mechanism, or worse, causing random memory corruption.

[ Stable folks: applies to 2.6.23 ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stable Kernel <stable@kernel.org>
Cc: Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>
Cc: Mark Williamson <mark.williamson@cl.cam.ac.uk>

---
 arch/i386/xen/enlighten.c    |    2 +-
 include/xen/interface/vcpu.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -115,7 +115,7 @@ static void __init xen_vcpu_setup(int cp
 	info.mfn = virt_to_mfn(vcpup);
 	info.offset = offset_in_page(vcpup);
 
-	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %x, offset %d\n",
+	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %llx, offset %d\n",
 	       cpu, vcpup, info.mfn, info.offset);
 
 	/* Check to see if the hypervisor will put the vcpu_info
===================================================================
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -160,8 +160,9 @@ struct vcpu_set_singleshot_timer {
  */
 #define VCPUOP_register_vcpu_info   10  /* arg == struct vcpu_info */
 struct vcpu_register_vcpu_info {
-    uint32_t mfn;               /* mfn of page to place vcpu_info */
-    uint32_t offset;            /* offset within page */
+    uint64_t mfn;    /* mfn of page to place vcpu_info */
+    uint32_t offset; /* offset within page */
+    uint32_t rsvd;   /* unused */
 };
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */

-- 

