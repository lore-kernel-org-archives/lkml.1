Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYKMTnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYKMTnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKMTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:29 -0500
Received: from gw.goop.org ([64.81.55.164]:34434 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYKMTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:10 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 38] paravirt/xen: add pvop for page_is_ram
X-Mercurial-Node: 79d4bb7c2d2875753e7ce497e13a55ce9e9f5d66
Message-Id: <79d4bb7c2d2875753e7c.1226603426@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/xen/enlighten.c        |   11 +++++++++++
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
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
 extern int pagerange_is_ram(unsigned long start, unsigned long end);
 extern int devmem_is_allowed(unsigned long pagenr);
 extern void map_devmem(unsigned long pfn, unsigned long size,
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -321,6 +321,8 @@
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
 			   unsigned long phys, pgprot_t flags);
+
+	int (*page_is_ram)(unsigned long pfn);
 };
 
 struct raw_spinlock;
@@ -1386,6 +1388,11 @@
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
 
+static inline int page_is_ram(unsigned long pfn)
+{
+	return PVOP_CALL1(int, pv_mmu_ops.page_is_ram, pfn);
+}
+
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -451,6 +451,7 @@
 	},
 
 	.set_fixmap = native_set_fixmap,
+	.page_is_ram = native_page_is_ram,
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -97,7 +97,7 @@
 
 #endif
 
-int page_is_ram(unsigned long pagenr)
+int native_page_is_ram(unsigned long pagenr)
 {
 	resource_size_t addr, end;
 	int i;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1190,6 +1190,16 @@
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
 static const struct pv_info xen_info __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
@@ -1364,6 +1374,7 @@
 	},
 
 	.set_fixmap = xen_set_fixmap,
+	.page_is_ram = xen_page_is_ram,
 };
 
 static void xen_reboot(int reason)


