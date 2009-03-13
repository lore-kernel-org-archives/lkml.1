Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZCMINU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZCMINU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZCMIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:12 -0400
Received: from gw.goop.org ([64.81.55.164]:34777 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751933AbZCMIMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/24] xen: separate p2m allocation from setting
Date: Fri, 13 Mar 2009 01:11:38 -0700
Message-Id: <1236931920-6861-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When doing very early p2m setting, we need to separate setting
from allocation, so split things up accordingly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   61 +++++++++++++++++++++++++++++++++++++--------------
 arch/x86/xen/mmu.h |    3 ++
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index eceff87..d534986 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -233,47 +233,74 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
-static void alloc_p2m(unsigned long **pp, unsigned long *mfnp)
+/* install a  new p2m_top page */
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p)
 {
-	unsigned long *p;
+	unsigned topidx = p2m_top_index(pfn);
+	unsigned long **pfnp, *mfnp;
 	unsigned i;
 
-	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
-	BUG_ON(p == NULL);
+	pfnp = &p2m_top[topidx];
+	mfnp = &p2m_top_mfn[topidx];
 
 	for (i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
 		p[i] = INVALID_P2M_ENTRY;
 
-	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
-		free_page((unsigned long)p);
-	else
+	if (cmpxchg(pfnp, p2m_missing, p) == p2m_missing) {
 		*mfnp = virt_to_mfn(p);
+		return true;
+	}
+
+	return false;
 }
 
-void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+static void alloc_p2m(unsigned long pfn)
 {
-	unsigned topidx, idx;
+	unsigned long *p;
 
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return;
-	}
+	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
+	BUG_ON(p == NULL);
+
+	if (!install_p2mtop_page(pfn, p))
+		free_page((unsigned long)p);
+}
+
+/* Try to install p2m mapping; fail if intermediate bits missing */
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	unsigned topidx, idx;
 
 	if (unlikely(pfn >= MAX_DOMAIN_PAGES)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
-		return;
+		return true;
 	}
 
 	topidx = p2m_top_index(pfn);
 	if (p2m_top[topidx] == p2m_missing) {
-		/* no need to allocate a page to store an invalid entry */
 		if (mfn == INVALID_P2M_ENTRY)
-			return;
-		alloc_p2m(&p2m_top[topidx], &p2m_top_mfn[topidx]);
+			return true;
+		return false;
 	}
 
 	idx = p2m_index(pfn);
 	p2m_top[topidx][idx] = mfn;
+
+	return true;
+}
+
+void set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return;
+	}
+
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		alloc_p2m(pfn);
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			BUG();
+	}
 }
 
 unsigned long arbitrary_virt_to_mfn(void *vaddr)
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 24d1b44..da73026 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -11,6 +11,9 @@ enum pt_level {
 };
 
 
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+bool install_p2mtop_page(unsigned long pfn, unsigned long *p);
+
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 
-- 
1.6.0.6

