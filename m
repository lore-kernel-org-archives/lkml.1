Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbYDQBPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbYDQBPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbYDQBHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:41 -0400
Received: from sous-sol.org ([216.99.217.87]:58863 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096AbYDQBHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:38 -0400
Message-Id: <20080417010329.108019916@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: xen: fix UP setup of shared_info
Content-Disposition: inline; filename=xen-fix-up-setup-of-shared_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

upstream commit: 2e8fe719b57bbdc9e313daed1204bb55fed3ed44

We need to set up the shared_info pointer once we've mapped the real
shared_info into its fixmap slot.  That needs to happen once the general
pagetable setup has been done.  Previously, the UP shared_info was set
up one in xen_start_kernel, but that was left pointing to the dummy
shared info.  Unfortunately there's no really good place to do a later
setup of the shared_info in UP, so just do it once the pagetable setup
has been done.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[chrisw@sous-sol.org: backport to 2.6.24.4]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/xen/enlighten.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -103,6 +103,7 @@ static void __init xen_vcpu_setup(int cp
 	int err;
 	struct vcpu_info *vcpup;
 
+	BUG_ON(HYPERVISOR_shared_info == &dummy_shared_info);
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
 	if (!have_vcpu_info_placement)
@@ -792,30 +793,40 @@ static __init void xen_pagetable_setup_s
 	xen_write_cr3(__pa(base));
 }
 
-static __init void xen_pagetable_setup_done(pgd_t *base)
+static __init void setup_shared_info(void)
 {
-	/* This will work as long as patching hasn't happened yet
-	   (which it hasn't) */
-	pv_mmu_ops.alloc_pt = xen_alloc_pt;
-	pv_mmu_ops.set_pte = xen_set_pte;
-
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		unsigned long addr = fix_to_virt(FIX_PARAVIRT_BOOTMAP);
+
 		/*
 		 * Create a mapping for the shared info page.
 		 * Should be set_fixmap(), but shared_info is a machine
 		 * address with no corresponding pseudo-phys address.
 		 */
-		set_pte_mfn(fix_to_virt(FIX_PARAVIRT_BOOTMAP),
+		set_pte_mfn(addr,
 			    PFN_DOWN(xen_start_info->shared_info),
 			    PAGE_KERNEL);
 
-		HYPERVISOR_shared_info =
-			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
-
+		HYPERVISOR_shared_info = (struct shared_info *)addr;
 	} else
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
 
+#ifndef CONFIG_SMP
+	/* In UP this is as good a place as any to set up shared info */
+	xen_setup_vcpu_info_placement();
+#endif
+}
+
+static __init void xen_pagetable_setup_done(pgd_t *base)
+{
+	/* This will work as long as patching hasn't happened yet
+	   (which it hasn't) */
+	pv_mmu_ops.alloc_pt = xen_alloc_pt;
+	pv_mmu_ops.set_pte = xen_set_pte;
+
+	setup_shared_info();
+
 	/* Actually pin the pagetable down, but we can't set PG_pinned
 	   yet because the page structures don't exist yet. */
 	{
@@ -1166,15 +1177,9 @@ asmlinkage void __init xen_start_kernel(
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

-- 
