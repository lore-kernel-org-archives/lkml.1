Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXJLVr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXJLVr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXJLVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:43 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42271 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760455AbXJLVol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:41 -0400
Message-Id: <20071012211148.465174000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>
Subject: [PATCH 07/10] xen: ask the hypervisor how much space it needs reserved
Content-Disposition: inline; filename=xen-dynamic-topaddr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ask the hypervisor how much space it needs reserved, since 32-on-64
doesn't need any space, and it may change in future.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/enlighten.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -1085,6 +1085,17 @@ static const struct machine_ops __initda
 };
 
 
+static void __init xen_reserve_top(void)
+{
+	unsigned long top = HYPERVISOR_VIRT_START;
+	struct xen_platform_parameters pp;
+
+	if (HYPERVISOR_xen_version(XENVER_platform_parameters, &pp) == 0)
+		top = pp.virt_start;
+
+	reserve_top_address(-top + 2 * PAGE_SIZE);
+}
+
 /* First C function to be called on Xen boot */
 asmlinkage void __init xen_start_kernel(void)
 {
@@ -1134,7 +1145,7 @@ asmlinkage void __init xen_start_kernel(
 		paravirt_ops.kernel_rpl = 0;
 
 	/* set the limit of our address space */
-	reserve_top_address(-HYPERVISOR_VIRT_START + 2 * PAGE_SIZE);
+	xen_reserve_top();
 
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);

-- 

