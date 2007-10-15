Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXJOVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXJOVvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXJOVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:50 -0400
Received: from zrnetservice.com ([209.133.52.163]:33162 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761444AbXJOVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:49 -0400
Message-Id: <20071015210115.276797606@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 09/12] xen: ask the hypervisor how much space it needs reserved
Content-Disposition: inline; filename=xen-dynamic-topaddr.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ask the hypervisor how much space it needs reserved, since 32-on-64
doesn't need any space, and it may change in future.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/xen/enlighten.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
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

