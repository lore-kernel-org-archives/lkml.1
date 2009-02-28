Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZB1CEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZB1CEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759688AbZB1B7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:40 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59185
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757114AbZB1B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:32 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] paravirt/xen: add pvop for page_is_ram
Date: Fri, 27 Feb 2009 17:59:15 -0800
Message-Id: <1235786365-17744-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

A guest domain may have external pages mapped into its address space,
in order to share memory with other domains.  These shared pages are
more akin to io mappings than real RAM, and should not pass the
page_is_ram test.  Add a paravirt op for this so that a hypervisor
backend can validate whether a page should be considered ram or not.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Conflicts:

	arch/x86/include/asm/page.h
---
 arch/x86/include/asm/page.h     |    9 ++++++++-
 arch/x86/include/asm/paravirt.h |    7 +++++++
 arch/x86/kernel/paravirt.c      |    1 +
 arch/x86/mm/ioremap.c           |    2 +-
 arch/x86/xen/mmu.c              |   11 +++++++++++
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 05f2da7..719b9aa 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -56,7 +56,14 @@
 typedef struct { pgdval_t pgd; } pgd_t;
 typedef struct { pgprotval_t pgprot; } pgprot_t;
 
-extern int page_is_ram(unsigned long pagenr);
+extern int native_page_is_ram(unsigned long pagenr);
+#ifndef CONFIG_PARAVIRT
+static inline int page_is_ram(unsigned long pagenr)
+{
+	return native_page_is_ram(pagenr);
+}
+#endif
+
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
 		       pgprot_t vma_prot);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index b788dfd..d07eea5 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -350,6 +350,8 @@ struct pv_mmu_ops {
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
 			   unsigned long phys, pgprot_t flags);
+
+	int (*page_is_ram)(unsigned long pfn);
 };
 
 struct raw_spinlock;
@@ -1452,6 +1454,11 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
 
+static inline int page_is_ram(unsigned long pfn)
+{
+	return PVOP_CALL1(int, pv_mmu_ops.page_is_ram, pfn);
+}
+
 void _paravirt_nop(void);
 u32 _paravirt_ident_32(u32);
 u64 _paravirt_ident_64(u64);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 6dc4dca..62e00cc 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -504,6 +504,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	},
 
 	.set_fixmap = native_set_fixmap,
+	.page_is_ram = native_page_is_ram,
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 433f7bd..28ac8d0 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(__virt_addr_valid);
 
 #endif
 
-int page_is_ram(unsigned long pagenr)
+int native_page_is_ram(unsigned long pagenr)
 {
 	resource_size_t addr, end;
 	int i;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6aa6d55..f0d8190 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1856,6 +1856,16 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 #endif
 }
 
+static int xen_page_is_ram(unsigned long pfn)
+{
+	/* Granted pages are not RAM.  They will not have a proper
+	   identity pfn<->mfn translation. */
+	if (mfn_to_local_pfn(pfn_to_mfn(pfn)) != pfn)
+		return 0;
+
+	return native_page_is_ram(pfn);
+}
+
 __init void xen_ident_map_ISA(void)
 {
 	unsigned long pa;
@@ -1984,6 +1994,7 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	},
 
 	.set_fixmap = xen_set_fixmap,
+	.page_is_ram = xen_page_is_ram,
 };
 
 
-- 
1.6.0.6

