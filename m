Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXCGH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXCGH3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161287AbXCGH3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:29:10 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59729 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXCGH2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:28:00 -0500
Date: Wed, 7 Mar 2007 12:48:50 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 15/20] Move swsusp __pa() dependent code to arch portion
Message-ID: <20070307071850.GP23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



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
---

 arch/i386/power/suspend.c     |   14 ++++++++++++++
 arch/powerpc/kernel/Makefile  |    1 +
 arch/powerpc/kernel/suspend.c |   24 ++++++++++++++++++++++++
 arch/x86_64/kernel/suspend.c  |   14 ++++++++++++++
 kernel/power/power.h          |    5 ++---
 kernel/power/snapshot.c       |   11 -----------
 6 files changed, 55 insertions(+), 14 deletions(-)

diff -puN arch/i386/power/suspend.c~move-swsusp-__pa-dependent-code-to-arch-portion arch/i386/power/suspend.c
--- linux-2.6.21-rc2-reloc/arch/i386/power/suspend.c~move-swsusp-__pa-dependent-code-to-arch-portion	2007-03-07 01:30:18.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/i386/power/suspend.c	2007-03-07 01:30:18.000000000 +0530
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
diff -puN arch/powerpc/kernel/Makefile~move-swsusp-__pa-dependent-code-to-arch-portion arch/powerpc/kernel/Makefile
--- linux-2.6.21-rc2-reloc/arch/powerpc/kernel/Makefile~move-swsusp-__pa-dependent-code-to-arch-portion	2007-03-07 01:30:18.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/powerpc/kernel/Makefile	2007-03-07 01:30:18.000000000 +0530
@@ -37,6 +37,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_6xx)		+= idle_6xx.o l2cr_6xx.o cpu_setup_6xx.o
 obj-$(CONFIG_TAU)		+= tau_6xx.o
 obj32-$(CONFIG_SOFTWARE_SUSPEND) += swsusp_32.o
+obj-$(CONFIG_SOFTWARE_SUSPEND) += suspend.o
 obj32-$(CONFIG_MODULES)		+= module_32.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
diff -puN /dev/null arch/powerpc/kernel/suspend.c
--- /dev/null	2007-03-07 00:46:17.354096448 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/powerpc/kernel/suspend.c	2007-03-07 01:30:18.000000000 +0530
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
diff -puN arch/x86_64/kernel/suspend.c~move-swsusp-__pa-dependent-code-to-arch-portion arch/x86_64/kernel/suspend.c
--- linux-2.6.21-rc2-reloc/arch/x86_64/kernel/suspend.c~move-swsusp-__pa-dependent-code-to-arch-portion	2007-03-07 01:30:18.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/kernel/suspend.c	2007-03-07 01:30:18.000000000 +0530
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
diff -puN kernel/power/power.h~move-swsusp-__pa-dependent-code-to-arch-portion kernel/power/power.h
--- linux-2.6.21-rc2-reloc/kernel/power/power.h~move-swsusp-__pa-dependent-code-to-arch-portion	2007-03-07 01:30:18.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/kernel/power/power.h	2007-03-07 01:30:18.000000000 +0530
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
diff -puN kernel/power/snapshot.c~move-swsusp-__pa-dependent-code-to-arch-portion kernel/power/snapshot.c
--- linux-2.6.21-rc2-reloc/kernel/power/snapshot.c~move-swsusp-__pa-dependent-code-to-arch-portion	2007-03-07 01:30:18.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/kernel/power/snapshot.c	2007-03-07 01:30:18.000000000 +0530
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
_
