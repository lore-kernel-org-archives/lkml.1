Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXGSNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXGSNt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932749AbXGSNse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:34 -0400
Received: from ns.suse.de ([195.135.220.2]:54505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477AbXGSNsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:33 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: rjw@sisk.pl, ak@suse.de, rientjes@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [3/48] i386: do not restore reserved memory after hibernation
Message-Id: <20070719134831.C514714E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems the ACPI NVS area is located in the first 1 MB of RAM and
it is overwritten by the i386 code during the restore after hibernation. 
This confuses the ACPI platform firmware that doesn't update the AC adapter
status appropriately as a result
(http://bugzilla.kernel.org/show_bug.cgi?id=7995).

The solution is to register the reserved memory in the first 1 MB as
'nosave', so that swsusp doesn't touch it during the restore.  Also, this
has been done on x86_64 for a long time now, so this patch makes the i386
restore code behave like the x86_64 one.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c  |   32 ++++++++++++++++++++++++++++++++
 arch/i386/kernel/setup.c |    1 +
 include/asm-i386/e820.h  |    8 ++++++++
 3 files changed, 41 insertions(+)

Index: linux/arch/i386/kernel/e820.c
===================================================================
--- linux.orig/arch/i386/kernel/e820.c
+++ linux/arch/i386/kernel/e820.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -320,6 +321,37 @@ static int __init request_standard_resou
 
 subsys_initcall(request_standard_resources);
 
+#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+/**
+ * e820_mark_nosave_regions - Find the ranges of physical addresses that do not
+ * correspond to e820 RAM areas and mark the corresponding pages as nosave for
+ * hibernation.
+ *
+ * This function requires the e820 map to be sorted and without any
+ * overlapping entries and assumes the first e820 area to be RAM.
+ */
+void __init e820_mark_nosave_regions(void)
+{
+	int i;
+	unsigned long pfn;
+
+	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
+	for (i = 1; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (pfn < PFN_UP(ei->addr))
+			register_nosave_region(pfn, PFN_UP(ei->addr));
+
+		pfn = PFN_DOWN(ei->addr + ei->size);
+		if (ei->type != E820_RAM)
+			register_nosave_region(PFN_UP(ei->addr), pfn);
+
+		if (pfn >= max_low_pfn)
+			break;
+	}
+}
+#endif
+
 void __init add_memory_region(unsigned long long start,
 			      unsigned long long size, int type)
 {
Index: linux/arch/i386/kernel/setup.c
===================================================================
--- linux.orig/arch/i386/kernel/setup.c
+++ linux/arch/i386/kernel/setup.c
@@ -640,6 +640,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	e820_register_memory();
+	e820_mark_nosave_regions();
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
Index: linux/include/asm-i386/e820.h
===================================================================
--- linux.orig/include/asm-i386/e820.h
+++ linux/include/asm-i386/e820.h
@@ -47,6 +47,14 @@ extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
 
+#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+extern void e820_mark_nosave_regions(void);
+#else
+static inline void e820_mark_nosave_regions(void)
+{
+}
+#endif
+
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
