Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYFQSnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYFQSnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbYFQSmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:42:44 -0400
Received: from gw.goop.org ([64.81.55.164]:51615 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661AbYFQSmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:42:43 -0400
Message-ID: <48580579.40607@goop.org>
Date: Tue, 17 Jun 2008 11:42:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86/paravirt/xen: Add set_fixmap pv_mmu_ops
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the logic necessary to map by mfn rather than pfn when we set up
fixmaps to point to IO space.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/paravirt.c |    2 ++
 arch/x86/mm/pgtable.c      |    9 +++++++--
 arch/x86/xen/enlighten.c   |   29 +++++++++++++++++++++++++++++
 include/asm-x86/fixmap.h   |   14 ++++++++++++--
 include/asm-x86/paravirt.h |   13 +++++++++++++
 5 files changed, 63 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -429,6 +429,8 @@
 		.enter = paravirt_nop,
 		.leave = paravirt_nop,
 	},
+
+	.set_fixmap = native_set_fixmap,
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
===================================================================
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -277,7 +277,7 @@
 
 int fixmaps_set;
 
-void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 {
 	unsigned long address = __fix_to_virt(idx);
 
@@ -285,6 +285,11 @@
 		BUG();
 		return;
 	}
-	set_pte_vaddr(address, pfn_pte(phys >> PAGE_SHIFT, flags));
+	set_pte_vaddr(address, pte);
 	fixmaps_set++;
 }
+
+void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+{
+	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1013,6 +1013,33 @@
 	return ret;
 }
 
+static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+{
+	pte_t pte;
+
+	phys >>= PAGE_SHIFT;
+
+	switch (idx) {
+	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
+#ifdef CONFIG_X86_F00F_BUG
+	case FIX_F00F_IDT:
+#endif
+	case FIX_WP_TEST:
+	case FIX_VDSO:
+#ifdef CONFIG_X86_LOCAL_APIC
+	case FIX_APIC_BASE:	/* maps dummy local APIC */
+#endif
+		pte = pfn_pte(phys, prot);
+		break;
+
+	default:
+		pte = mfn_pte(phys, prot);
+		break;
+	}
+
+	__native_set_fixmap(idx, pte);
+}
+
 static const struct pv_info xen_info __initdata = {
 	.paravirt_enabled = 1,
 	.shared_kernel_pmd = 0,
@@ -1171,6 +1198,8 @@
 		.enter = paravirt_enter_lazy_mmu,
 		.leave = xen_leave_lazy,
 	},
+
+	.set_fixmap = xen_set_fixmap,
 };
 
 #ifdef CONFIG_SMP
diff --git a/include/asm-x86/fixmap.h b/include/asm-x86/fixmap.h
===================================================================
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -9,8 +9,18 @@
 
 extern int fixmaps_set;
 
-extern void __set_fixmap(enum fixed_addresses idx,
-			 unsigned long phys, pgprot_t flags);
+void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
+void native_set_fixmap(enum fixed_addresses idx,
+		       unsigned long phys, pgprot_t flags);
+
+#ifndef CONFIG_PARAVIRT
+static inline void __set_fixmap(enum fixed_addresses idx,
+				unsigned long phys, pgprot_t flags)
+{
+	native_set_fixmap(idx, phys, flags);
+}
+#endif
+
 #define set_fixmap(idx, phys)				\
 	__set_fixmap(idx, phys, PAGE_KERNEL)
 
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -287,6 +287,13 @@
 #endif
 
 	struct pv_lazy_ops lazy_mode;
+
+	/* dom0 ops */
+
+	/* Sometimes the physical address is a pfn, and sometimes its
+	   an mfn.  We can tell which is which from the index. */
+	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
+			   unsigned long phys, pgprot_t flags);
 };
 
 /* This contains all the paravirt structures: we get a convenient
@@ -1318,6 +1325,12 @@
 	}
 }
 
+static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
+				unsigned long phys, pgprot_t flags)
+{
+	pv_mmu_ops.set_fixmap(idx, phys, flags);
+}
+
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 


