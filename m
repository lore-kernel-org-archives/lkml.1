Return-Path: <linux-kernel-owner+w=401wt.eu-S1422731AbXCBC4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731AbXCBC4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422795AbXCBC4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:56:07 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52759 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422742AbXCBCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:55:59 -0500
Date: Thu, 1 Mar 2007 18:55:58 -0800
Message-Id: <200703020255.l222twSE009700@zach-dev.vmware.com>
Subject: [PATCH 9/9] Vmi smp fixes.patch
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <ak@muc.de>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 02 Mar 2007 02:55:58.0659 (UTC) FILETIME=[4DEC8130:01C75C76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Critical fixes for SMP.

Fix a couple functions which needed to be __devinit and fix a bogus
parameter to AP startup that just so happened to work because the
low virtual mapping of memory was still established.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r baf2e278a482 arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Mar 01 18:08:53 2007 -0800
+++ b/arch/i386/kernel/vmi.c	Thu Mar 01 18:10:18 2007 -0800
@@ -525,13 +525,14 @@ void vmi_pmd_clear(pmd_t *pmd)
 #endif
 
 #ifdef CONFIG_SMP
-struct vmi_ap_state ap;
 extern void setup_pda(void);
 
-static void __init /* XXX cpu hotplug */
+static void __devinit
 vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 		     unsigned long start_esp)
 {
+	struct vmi_ap_state ap;
+
 	/* Default everything to zero.  This is fine for most GPRs. */
 	memset(&ap, 0, sizeof(struct vmi_ap_state));
 
@@ -570,7 +571,7 @@ vmi_startup_ipi_hook(int phys_apicid, un
 	/* Protected mode, paging, AM, WP, NE, MP. */
 	ap.cr0 = 0x80050023;
 	ap.cr4 = mmu_cr4_features;
-	vmi_ops.set_initial_ap_state(__pa(&ap), phys_apicid);
+	vmi_ops.set_initial_ap_state((u32)&ap, phys_apicid);
 }
 #endif
 
diff -r baf2e278a482 arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Thu Mar 01 18:08:53 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Thu Mar 01 18:08:53 2007 -0800
@@ -243,7 +243,7 @@ void __init vmi_timer_setup_boot_alarm(v
 
 /* Initialize the time accounting variables for an AP on an SMP system.
  * Also, set the local alarm for the AP. */
-void __init vmi_timer_setup_secondary_alarm(void)
+void __devinit vmi_timer_setup_secondary_alarm(void)
 {
 	int cpu = smp_processor_id();
 
