Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYCRFYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYCRFYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYCRFYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:07 -0400
Received: from gw.goop.org ([64.81.55.164]:37830 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 31] xen: fix UP setup of shared_info
X-Mercurial-Node: 8c4f7164541786e23ed8747f39b6ad861cfc23ef
Message-Id: <8c4f7164541786e23ed8.1205797013@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Kernel <stable@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set up the shared_info pointer once we've mapped the real
shared_info into its fixmap slot.  That needs to happen once the general
pagetable setup has been done.  Previously, the UP shared_info was set
up one in xen_start_kernel, but that was left pointing to the dummy
shared info.  Unfortunately there's no really good place to do a later
setup of the shared_info in UP, so just do it once the pagetable setup
has been done.

[ Stable: needed in 2.6.24.x ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable Kernel <stable@kernel.org>
---
 arch/x86/xen/enlighten.c |   51 +++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -104,6 +104,7 @@
 	int err;
 	struct vcpu_info *vcpup;
 
+	BUG_ON(HYPERVISOR_shared_info == &dummy_shared_info);
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
 	if (!have_vcpu_info_placement)
@@ -806,6 +807,31 @@
 			  PFN_DOWN(__pa(xen_start_info->pt_base)));
 }
 
+static __init void setup_shared_info(void)
+{
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long addr = fix_to_virt(FIX_PARAVIRT_BOOTMAP);
+
+		/*
+		 * Create a mapping for the shared info page.
+		 * Should be set_fixmap(), but shared_info is a machine
+		 * address with no corresponding pseudo-phys address.
+		 */
+		set_pte_mfn(addr,
+			    PFN_DOWN(xen_start_info->shared_info),
+			    PAGE_KERNEL);
+
+		HYPERVISOR_shared_info = (struct shared_info *)addr;
+	} else
+		HYPERVISOR_shared_info =
+			(struct shared_info *)__va(xen_start_info->shared_info);
+
+#ifndef CONFIG_SMP
+	/* In UP this is as good a place as any to set up shared info */
+	xen_setup_vcpu_info_placement();
+#endif
+}
+
 static __init void xen_pagetable_setup_done(pgd_t *base)
 {
 	/* This will work as long as patching hasn't happened yet
@@ -816,22 +842,7 @@
 	pv_mmu_ops.release_pd = xen_release_pt;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
-	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		/*
-		 * Create a mapping for the shared info page.
-		 * Should be set_fixmap(), but shared_info is a machine
-		 * address with no corresponding pseudo-phys address.
-		 */
-		set_pte_mfn(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
-			    PFN_DOWN(xen_start_info->shared_info),
-			    PAGE_KERNEL);
-
-		HYPERVISOR_shared_info =
-			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
-
-	} else
-		HYPERVISOR_shared_info =
-			(struct shared_info *)__va(xen_start_info->shared_info);
+	setup_shared_info();
 
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
@@ -1182,15 +1193,9 @@
 	x86_write_percpu(xen_cr3, __pa(pgd));
 	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
-#ifdef CONFIG_SMP
 	/* Don't do the full vcpu_info placement stuff until we have a
-	   possible map. */
+	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
-#else
-	/* May as well do it now, since there's no good time to call
-	   it later on UP. */
-	xen_setup_vcpu_info_placement();
-#endif
 
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))


