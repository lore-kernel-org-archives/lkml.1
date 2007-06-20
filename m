Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXFUAhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXFUAhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXFUAgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:36:55 -0400
Received: from bay-wan-b-65.sfo.dsl.cerfnet.com ([216.148.65.65]:39546 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755431AbXFUAgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:36:54 -0400
Message-Id: <20070620231853.295485100@goop.org>
References: <20070620231726.834538992@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 16:17:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/9] ask the hypervisor how much space it needs reserved
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

