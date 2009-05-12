Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZEMDIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZEMDIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZEMDGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:05 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36221
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755093AbZEMDGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:01 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Juan Quintela <quintela@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/16] xen dom0: Set up basic IO permissions for dom0.
Date: Tue, 12 May 2009 14:28:25 -0700
Message-Id: <1242163718-2934-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242163718-2934-1-git-send-email-jeremy@goop.org>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

Add the direct mapping area for ISA bus access, and enable IO space
access for the guest when running as dom0.

[ Impact: set iopl for dom0 kernel; map ISA ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 arch/x86/xen/enlighten.c |    8 ++++++++
 arch/x86/xen/mmu.c       |   24 ++++++++++++++++++++++++
 arch/x86/xen/setup.c     |    6 +++++-
 arch/x86/xen/xen-ops.h   |    1 +
 4 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0a1700a..50580fc 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1045,6 +1045,7 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
+	xen_ident_map_ISA();
 
 	init_mm.pgd = pgd;
 
@@ -1054,6 +1055,13 @@ asmlinkage void __init xen_start_kernel(void)
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
 
+	if (xen_initial_domain()) {
+		struct physdev_set_iopl set_iopl;
+		set_iopl.iopl = 1;
+		if (HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl) == -1)
+			BUG();
+	}
+
 	/* set the limit of our address space */
 	xen_reserve_top();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 760e3a5..dc840ed 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1615,6 +1615,7 @@ static void *m2v(phys_addr_t maddr)
 	return __ka(m2p(maddr));
 }
 
+/* Set the page permissions on an identity-mapped pages */
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
@@ -1840,6 +1841,29 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #endif
 }
 
+__init void xen_ident_map_ISA(void)
+{
+	unsigned long pa;
+
+	/*
+	 * If we're dom0, then linear map the ISA machine addresses into
+	 * the kernel's address space.
+	 */
+	if (!xen_initial_domain())
+		return;
+
+	xen_raw_printk("Xen: setup ISA identity maps\n");
+
+	for (pa = ISA_START_ADDRESS; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
+		pte_t pte = mfn_pte(PFN_DOWN(pa), PAGE_KERNEL_IO);
+
+		if (HYPERVISOR_update_va_mapping(PAGE_OFFSET + pa, pte, 0))
+			BUG();
+	}
+
+	xen_flush_tlb();
+}
+
 __init void xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index ad0047f..dc55171 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -51,6 +51,9 @@ char * __init xen_memory_setup(void)
 	 * Even though this is normal, usable memory under Xen, reserve
 	 * ISA memory anyway because too many things think they can poke
 	 * about in there.
+	 *
+	 * In a dom0 kernel, this region is identity mapped with the
+	 * hardware ISA area, so it really is out of bounds.
 	 */
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
 			E820_RESERVED);
@@ -188,7 +191,8 @@ void __init xen_arch_setup(void)
 
 	pm_idle = xen_idle;
 
-	paravirt_disable_iospace();
+	if (!xen_initial_domain())
+		paravirt_disable_iospace();
 
 	fiddle_vdso();
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 5c50a10..6ff6203 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -29,6 +29,7 @@ void xen_setup_machphys_mapping(void);
 pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
 void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
+void xen_ident_map_ISA(void);
 
 void xen_post_allocator_init(void);
 
-- 
1.6.0.6

