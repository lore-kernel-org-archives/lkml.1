Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYEWNon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYEWNon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYEWNoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:19 -0400
Received: from gw.goop.org ([64.81.55.164]:53224 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbYEWNoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 12] xen: make phys_to_machine structure dynamic
X-Mercurial-Node: ae3daa70eeb5bcc33db236799ec228f8a1482882
Message-Id: <ae3daa70eeb5bcc33db2.1211550068@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:08 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now support the use of memory hotplug, so the physical to machine
page mapping structure must be dynamic.  This is implemented as a
two-level radix tree structure, which allows us to efficiently
incrementally allocate memory for the p2m table as new pages are
added.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c   |    2 -
 arch/x86/xen/mmu.c         |   85 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/setup.c       |    2 -
 arch/x86/xen/xen-ops.h     |    2 +
 include/asm-x86/xen/page.h |   20 +++-------
 5 files changed, 94 insertions(+), 17 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1222,7 +1222,7 @@
 
 	/* Get mfn list */
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		phys_to_machine_mapping = (unsigned long *)xen_start_info->mfn_list;
+		xen_build_dynamic_phys_to_machine();
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -55,6 +55,91 @@
 
 #include "multicalls.h"
 #include "mmu.h"
+
+/*
+ * This should probably be a config option.  On 32-bit, it costs 1
+ * page/gig of memory; on 64-bit its 2 pages/gig.  If we want it to be
+ * completely unbounded we can add another level to the p2m structure.
+ */
+#define MAX_GUEST_PAGES		(16ull * 1024*1024*1024 / PAGE_SIZE)
+#define P2M_ENTRIES_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long))
+
+static unsigned long *p2m_top[MAX_GUEST_PAGES / P2M_ENTRIES_PER_PAGE];
+
+static inline unsigned p2m_top_index(unsigned long pfn)
+{
+	BUG_ON(pfn >= MAX_GUEST_PAGES);
+	return pfn / P2M_ENTRIES_PER_PAGE;
+}
+
+static inline unsigned p2m_index(unsigned long pfn)
+{
+	return pfn % P2M_ENTRIES_PER_PAGE;
+}
+
+void __init xen_build_dynamic_phys_to_machine(void)
+{
+	unsigned pfn;
+	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
+
+	BUG_ON(xen_start_info->nr_pages >= MAX_GUEST_PAGES);
+
+	for(pfn = 0;
+	    pfn < xen_start_info->nr_pages;
+	    pfn += P2M_ENTRIES_PER_PAGE) {
+		unsigned topidx = p2m_top_index(pfn);
+
+		p2m_top[topidx] = &mfn_list[pfn];
+	}
+}
+
+unsigned long get_phys_to_machine(unsigned long pfn)
+{
+	unsigned topidx, idx;
+
+	topidx = p2m_top_index(pfn);
+	if (p2m_top[topidx] == NULL)
+		return INVALID_P2M_ENTRY;
+
+	idx = p2m_index(pfn);
+	return p2m_top[topidx][idx];
+}
+
+static void alloc_p2m(unsigned long **pp)
+{
+	unsigned long *p;
+	unsigned i;
+
+	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
+	BUG_ON(p == NULL);
+
+	for(i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
+		p[i] = INVALID_P2M_ENTRY;
+
+	if (cmpxchg(pp, NULL, p) != NULL)
+		free_page((unsigned long)p);
+}
+
+void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	unsigned topidx, idx;
+
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+
+	topidx = p2m_top_index(pfn);
+	if (p2m_top[topidx] == NULL) {
+		/* no need to allocate a page to store an invalid entry */
+		if (mfn == INVALID_P2M_ENTRY)
+			return;
+		alloc_p2m(&p2m_top[topidx]);
+	}
+
+	idx = p2m_index(pfn);
+	p2m_top[topidx][idx] = mfn;
+}
 
 xmaddr_t arbitrary_virt_to_machine(unsigned long address)
 {
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -27,8 +27,6 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 
-unsigned long *phys_to_machine_mapping;
-EXPORT_SYMBOL(phys_to_machine_mapping);
 
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -21,6 +21,8 @@
 void __init xen_arch_setup(void);
 void __init xen_init_IRQ(void);
 void xen_enable_sysenter(void);
+
+void __init xen_build_dynamic_phys_to_machine(void);
 
 void xen_setup_timer(int cpu);
 void xen_setup_cpu_clockevents(void);
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -26,15 +26,15 @@
 #define FOREIGN_FRAME_BIT	(1UL<<31)
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
 
-extern unsigned long *phys_to_machine_mapping;
+extern unsigned long get_phys_to_machine(unsigned long pfn);
+extern void set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return pfn;
 
-	return phys_to_machine_mapping[(unsigned int)(pfn)] &
-		~FOREIGN_FRAME_BIT;
+	return get_phys_to_machine(pfn) & ~FOREIGN_FRAME_BIT;
 }
 
 static inline int phys_to_machine_mapping_valid(unsigned long pfn)
@@ -42,7 +42,7 @@
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return 1;
 
-	return (phys_to_machine_mapping[pfn] != INVALID_P2M_ENTRY);
+	return get_phys_to_machine(pfn) != INVALID_P2M_ENTRY;
 }
 
 static inline unsigned long mfn_to_pfn(unsigned long mfn)
@@ -106,18 +106,10 @@
 	unsigned long pfn = mfn_to_pfn(mfn);
 	if ((pfn < max_mapnr)
 	    && !xen_feature(XENFEAT_auto_translated_physmap)
-	    && (phys_to_machine_mapping[pfn] != mfn))
+	    && (get_phys_to_machine(pfn) != mfn))
 		return max_mapnr; /* force !pfn_valid() */
+	/* XXX fixme; not true with sparsemem */
 	return pfn;
-}
-
-static inline void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	if (xen_feature(XENFEAT_auto_translated_physmap)) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
-	phys_to_machine_mapping[pfn] = mfn;
 }
 
 /* VIRT <-> MACHINE conversion */


