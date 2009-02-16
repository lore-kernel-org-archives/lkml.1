Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbZBPXtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbZBPXtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZBPXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:24 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50805
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbZBPXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:18 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/19] paravirt/xen: add pvop for page_is_ram
Date: Mon, 16 Feb 2009 15:46:02 -0800
Message-Id: <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <8349825a016bec5b8712940ad6f8c3f18f8003fb.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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

