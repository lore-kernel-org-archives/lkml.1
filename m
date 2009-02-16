Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZBPXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZBPXvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZBPXq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:27 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50812
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753012AbZBPXqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:19 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/19] xen: implement XENMEM_machphys_mapping
Date: Mon, 16 Feb 2009 15:46:05 -0800
Message-Id: <2fe9663efa1686898ebf9d28e911daac3185b6b7.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
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
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f156acbfffc23cccd71b71d36e6668c6c246f3b4.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <e59d440a548af3d4e4bb483c73e24614a5b3af63.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This hypercall allows Xen to specify a non-default location for the
machine to physical mapping. This capability is used when running a 32
bit domain 0 on a 64 bit hypervisor to shrink the hypervisor hole to
exactly the size required.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/interface.h    |    6 +++---
 arch/x86/include/asm/xen/interface_32.h |    5 +++++
 arch/x86/include/asm/xen/interface_64.h |   13 +------------
 arch/x86/include/asm/xen/page.h         |    7 ++++---
 arch/x86/xen/enlighten.c                |    7 +++++++
 arch/x86/xen/mmu.c                      |   15 +++++++++++++++
 include/xen/interface/memory.h          |   13 +++++++++++++
 7 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index e8506c1..1c10c88 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -61,9 +61,9 @@ DEFINE_GUEST_HANDLE(void);
 #define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
 #endif
 
-#ifndef machine_to_phys_mapping
-#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
-#endif
+#define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
+#define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
+#define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>__MACH2PHYS_SHIFT)
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
 #define MAX_VIRT_CPUS 32
diff --git a/arch/x86/include/asm/xen/interface_32.h b/arch/x86/include/asm/xen/interface_32.h
index 42a7e00..8413688 100644
--- a/arch/x86/include/asm/xen/interface_32.h
+++ b/arch/x86/include/asm/xen/interface_32.h
@@ -32,6 +32,11 @@
 /* And the trap vector is... */
 #define TRAP_INSTR "int $0x82"
 
+#define __MACH2PHYS_VIRT_START 0xF5800000
+#define __MACH2PHYS_VIRT_END   0xF6800000
+
+#define __MACH2PHYS_SHIFT      2
+
 /*
  * Virtual addresses beyond this are not modifiable by guest OSes. The
  * machine->physical mapping table starts at this address, read-only.
diff --git a/arch/x86/include/asm/xen/interface_64.h b/arch/x86/include/asm/xen/interface_64.h
index 100d266..839a481 100644
--- a/arch/x86/include/asm/xen/interface_64.h
+++ b/arch/x86/include/asm/xen/interface_64.h
@@ -39,18 +39,7 @@
 #define __HYPERVISOR_VIRT_END   0xFFFF880000000000
 #define __MACH2PHYS_VIRT_START  0xFFFF800000000000
 #define __MACH2PHYS_VIRT_END    0xFFFF804000000000
-
-#ifndef HYPERVISOR_VIRT_START
-#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
-#define HYPERVISOR_VIRT_END   mk_unsigned_long(__HYPERVISOR_VIRT_END)
-#endif
-
-#define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
-#define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
-#define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>3)
-#ifndef machine_to_phys_mapping
-#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
-#endif
+#define __MACH2PHYS_SHIFT       3
 
 /*
  * int HYPERVISOR_set_segment_base(unsigned int which, unsigned long base)
diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 20c3872..95a3122 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/pfn.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -35,6 +36,8 @@ typedef struct xpaddr {
 #define MAX_DOMAIN_PAGES						\
     ((unsigned long)((u64)CONFIG_XEN_MAX_DOMAIN_MEMORY * 1024 * 1024 * 1024 / PAGE_SIZE))
 
+extern unsigned long *machine_to_phys_mapping;
+extern unsigned int   machine_to_phys_order;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern void set_phys_to_machine(unsigned long pfn, unsigned long mfn);
@@ -62,10 +65,8 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return mfn;
 
-#if 0
 	if (unlikely((mfn >> machine_to_phys_order) != 0))
-		return max_mapnr;
-#endif
+		return ~0;
 
 	pfn = 0;
 	/*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c12a3c8..62d229a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -62,6 +62,11 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 enum xen_domain_type xen_domain_type = XEN_NATIVE;
 EXPORT_SYMBOL_GPL(xen_domain_type);
 
+unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
+EXPORT_SYMBOL(machine_to_phys_mapping);
+unsigned int   machine_to_phys_order;
+EXPORT_SYMBOL(machine_to_phys_order);
+
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
@@ -890,6 +895,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_setup_features();
 
+	xen_setup_machphys_mapping();
+
 	/* Install Xen paravirt ops */
 	pv_info = xen_info;
 	pv_init_ops = xen_init_ops;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f0d8190..367a7d2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -57,6 +57,7 @@
 #include <xen/page.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/version.h>
+#include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
 
 #include "multicalls.h"
@@ -1866,6 +1867,20 @@ static int xen_page_is_ram(unsigned long pfn)
 	return native_page_is_ram(pfn);
 }
 
+__init void xen_setup_machphys_mapping(void)
+{
+	struct xen_machphys_mapping mapping;
+	unsigned long machine_to_phys_nr_ents;
+
+	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, &mapping) == 0) {
+		machine_to_phys_mapping = (unsigned long *)mapping.v_start;
+		machine_to_phys_nr_ents = mapping.max_mfn + 1;
+	} else {
+		machine_to_phys_nr_ents = MACH2PHYS_NR_ENTRIES;
+	}
+	machine_to_phys_order = fls(machine_to_phys_nr_ents - 1);
+}
+
 __init void xen_ident_map_ISA(void)
 {
 	unsigned long pa;
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index e6c6bcb..f548f7c 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -97,6 +97,19 @@ struct xen_machphys_mfn_list {
 DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
 
 /*
+ * Returns the location in virtual address space of the machine_to_phys
+ * mapping table. Architectures which do not have a m2p table, or which do not
+ * map it by default into guest address space, do not implement this command.
+ * arg == addr of xen_machphys_mapping_t.
+ */
+#define XENMEM_machphys_mapping     12
+struct xen_machphys_mapping {
+    unsigned long v_start, v_end; /* Start and end virtual addresses.   */
+    unsigned long max_mfn;        /* Maximum MFN that can be looked up. */
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
+
+/*
  * Sets the GPFN at which a particular page appears in the specified guest's
  * pseudophysical address space.
  * arg == addr of xen_add_to_physmap_t.
-- 
1.6.0.6

