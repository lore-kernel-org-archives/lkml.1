Return-Path: <linux-kernel-owner+w=401wt.eu-S1163354AbXD1SD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163354AbXD1SD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163350AbXD1SBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:34688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163347AbXD1R7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [16/22] x86: Move swsusp __pa() dependent code to arch portion
Message-Id: <20070428175903.99FE9151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o __pa() should be used only on kernel linearly mapped virtual addresses
  and not on kernel text and data addresses.

o Hibernation code needs to determine the physical address associated
  with kernel symbol to mark a section boundary which contains pages which
  don't have to be saved and restored during hibernate/resume operation.

o Move this piece of code in arch dependent section. So that architectures
  which don't have kernel text/data mapped into kernel linearly mapped
  region can come up with their own ways of determining physical addresses
  associated with a kernel text.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/power/suspend.c     |   14 ++++++++++++++
 arch/powerpc/kernel/Makefile  |    1 +
 arch/powerpc/kernel/suspend.c |   24 ++++++++++++++++++++++++
 arch/x86_64/kernel/suspend.c  |   14 ++++++++++++++
 kernel/power/power.h          |    5 ++---
 kernel/power/snapshot.c       |   11 -----------
 6 files changed, 55 insertions(+), 14 deletions(-)

Index: linux/arch/i386/power/suspend.c
===================================================================
--- linux.orig/arch/i386/power/suspend.c
+++ linux/arch/i386/power/suspend.c
@@ -16,6 +16,9 @@
 /* Defined in arch/i386/power/swsusp.S */
 extern int restore_image(void);
 
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
 /* Pointer to the temporary resume page tables */
 pgd_t *resume_pg_dir;
 
@@ -156,3 +159,14 @@ int swsusp_arch_resume(void)
 	restore_image();
 	return 0;
 }
+
+/*
+ *	pfn_is_nosave - check if given pfn is in the 'nosave' section
+ */
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
+	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
Index: linux/arch/powerpc/kernel/Makefile
===================================================================
--- linux.orig/arch/powerpc/kernel/Makefile
+++ linux/arch/powerpc/kernel/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_6xx)		+= idle_6xx.o l2cr_6xx.o cpu_setup_6xx.o
 obj-$(CONFIG_TAU)		+= tau_6xx.o
 obj32-$(CONFIG_SOFTWARE_SUSPEND) += swsusp_32.o
+obj-$(CONFIG_SOFTWARE_SUSPEND) += suspend.o
 obj32-$(CONFIG_MODULES)		+= module_32.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
Index: linux/arch/powerpc/kernel/suspend.c
===================================================================
--- /dev/null
+++ linux/arch/powerpc/kernel/suspend.c
@@ -0,0 +1,24 @@
+/*
+ * Suspend support specific for power.
+ *
+ * Distribute under GPLv2
+ *
+ * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
+ */
+
+#include <asm/page.h>
+
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
+/*
+ *	pfn_is_nosave - check if given pfn is in the 'nosave' section
+ */
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long nosave_begin_pfn = __pa(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa(&__nosave_end)) >> PAGE_SHIFT;
+	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
Index: linux/arch/x86_64/kernel/suspend.c
===================================================================
--- linux.orig/arch/x86_64/kernel/suspend.c
+++ linux/arch/x86_64/kernel/suspend.c
@@ -13,6 +13,9 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
+/* References to section boundaries */
+extern const void __nosave_begin, __nosave_end;
+
 struct saved_context saved_context;
 
 unsigned long saved_context_eax, saved_context_ebx, saved_context_ecx, saved_context_edx;
@@ -220,4 +223,15 @@ int swsusp_arch_resume(void)
 	restore_image();
 	return 0;
 }
+
+/*
+ *	pfn_is_nosave - check if given pfn is in the 'nosave' section
+ */
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
+	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
 #endif /* CONFIG_SOFTWARE_SUSPEND */
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -23,6 +23,8 @@ static inline int pm_suspend_disk(void)
 }
 #endif
 
+extern int pfn_is_nosave(unsigned long);
+
 extern struct mutex pm_mutex;
 
 #define power_attr(_name) \
@@ -37,9 +39,6 @@ static struct subsys_attribute _name##_a
 
 extern struct subsystem power_subsys;
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 /* Preferred image size in bytes (default 500 MB) */
 extern unsigned long image_size;
 extern int in_suspend;
Index: linux/kernel/power/snapshot.c
===================================================================
--- linux.orig/kernel/power/snapshot.c
+++ linux/kernel/power/snapshot.c
@@ -651,17 +651,6 @@ static inline unsigned int count_highmem
 #endif /* CONFIG_HIGHMEM */
 
 /**
- *	pfn_is_nosave - check if given pfn is in the 'nosave' section
- */
-
-static inline int pfn_is_nosave(unsigned long pfn)
-{
-	unsigned long nosave_begin_pfn = __pa(&__nosave_begin) >> PAGE_SHIFT;
-	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa(&__nosave_end)) >> PAGE_SHIFT;
-	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
-}
-
-/**
  *	saveable - Determine whether a non-highmem page should be included in
  *	the suspend image.
  *
