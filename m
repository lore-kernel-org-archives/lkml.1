Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYEWNqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYEWNqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYEWNoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:23 -0400
Received: from gw.goop.org ([64.81.55.164]:53238 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbYEWNoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 12] xen: add p2m mfn_list_list
X-Mercurial-Node: a405e5f9ddf6f5f142ead73e60cd5252cf9f2256
Message-Id: <a405e5f9ddf6f5f142ea.1211550072@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:12 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When saving a domain, the Xen tools need to remap all our mfns to
portable pfns.  In order to remap our p2m table, it needs to know
where all its pages are, so maintain the references to the p2m table
for it to use.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    2 ++
 arch/x86/xen/mmu.c       |   39 ++++++++++++++++++++++++++++++++++++---
 arch/x86/xen/xen-ops.h   |    2 ++
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -880,6 +880,8 @@
 	/* In UP this is as good a place as any to set up shared info */
 	xen_setup_vcpu_info_placement();
 #endif
+
+	xen_setup_mfn_list_list();
 }
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -69,6 +69,13 @@
 	__attribute__((section(".data.page_aligned"))) =
 		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
 
+/* Arrays of p2m arrays expressed in mfns used for save/restore */
+static unsigned long p2m_top_mfn[TOP_ENTRIES]
+	__attribute__((section(".bss.page_aligned")));
+
+static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
+	__attribute__((section(".bss.page_aligned")));
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_DOMAIN_PAGES);
@@ -80,11 +87,35 @@
 	return pfn % P2M_ENTRIES_PER_PAGE;
 }
 
+/* Build the parallel p2m_top_mfn structures */
+void xen_setup_mfn_list_list(void)
+{
+	unsigned pfn, idx;
+
+	for(pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_ENTRIES_PER_PAGE) {
+		unsigned topidx = p2m_top_index(pfn);
+
+		p2m_top_mfn[topidx] = virt_to_mfn(p2m_top[topidx]);
+	}
+
+	for(idx = 0; idx < ARRAY_SIZE(p2m_top_mfn_list); idx++) {
+		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
+		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
+	}
+
+	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
+
+	HYPERVISOR_shared_info->arch.pfn_to_mfn_frame_list_list =
+		virt_to_mfn(p2m_top_mfn_list);
+	HYPERVISOR_shared_info->arch.max_pfn = xen_start_info->nr_pages;
+}
+
+/* Set up p2m_top to point to the domain-builder provided p2m pages */
 void __init xen_build_dynamic_phys_to_machine(void)
 {
-	unsigned pfn;
 	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
 	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
+	unsigned pfn;
 
 	for(pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
@@ -105,7 +136,7 @@
 	return p2m_top[topidx][idx];
 }
 
-static void alloc_p2m(unsigned long **pp)
+static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
 {
 	unsigned long *p;
 	unsigned i;
@@ -118,6 +149,8 @@
 
 	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
 		free_page((unsigned long)p);
+	else
+		*mfnp = virt_to_mfn(p);
 }
 
 void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
@@ -139,7 +172,7 @@
 		/* no need to allocate a page to store an invalid entry */
 		if (mfn == INVALID_P2M_ENTRY)
 			return;
-		alloc_p2m(&p2m_top[topidx]);
+		alloc_p2m(&p2m_top[topidx], &p2m_top_mfn[topidx]);
 	}
 
 	idx = p2m_index(pfn);
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -17,6 +17,8 @@
 extern struct start_info *xen_start_info;
 extern struct shared_info xen_dummy_shared_info;
 extern struct shared_info *HYPERVISOR_shared_info;
+
+void xen_setup_mfn_list_list(void);
 
 char * __init xen_memory_setup(void);
 void __init xen_arch_setup(void);


