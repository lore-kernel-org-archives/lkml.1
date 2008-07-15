Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYGOHFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYGOHFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYGOHEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:04:40 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:26648 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYGOHEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=dSCKIo2VnYrEjrlcwBSYjpqAYeXFNGSRCKYzARmWKelFvHHIV3OLdIZemQALoSGY+1
         MK+p/wPuWo6VHQX+LjU8aLKaK8yAwWUngHlqi5F4NwNSR3P3HpUNVTFNwxDHwI4jepQN
         QIFHSJ2H+B3+7nuY8ikO6sR9t5a34fFCwxW6g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: seperate memtest from init_64.c
Date: Tue, 15 Jul 2008 00:02:28 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150002.28398.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/Makefile   |    1 
 arch/x86/mm/init_64.c  |  112 --------------------------------------------
 arch/x86/mm/memtest.c  |  123 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/e820.h |    8 +++
 4 files changed, 132 insertions(+), 112 deletions(-)

Index: linux-2.6/arch/x86/mm/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/mm/Makefile
+++ linux-2.6/arch/x86/mm/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_K8_NUMA)		+= k8topology_64.
 endif
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
+obj-$(CONFIG_MEMTEST)		+= memtest.o
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -517,118 +517,6 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
-#ifdef CONFIG_MEMTEST
-
-static void __init memtest(unsigned long start_phys, unsigned long size,
-				 unsigned pattern)
-{
-	unsigned long i;
-	unsigned long *start;
-	unsigned long start_bad;
-	unsigned long last_bad;
-	unsigned long val;
-	unsigned long start_phys_aligned;
-	unsigned long count;
-	unsigned long incr;
-
-	switch (pattern) {
-	case 0:
-		val = 0UL;
-		break;
-	case 1:
-		val = -1UL;
-		break;
-	case 2:
-		val = 0x5555555555555555UL;
-		break;
-	case 3:
-		val = 0xaaaaaaaaaaaaaaaaUL;
-		break;
-	default:
-		return;
-	}
-
-	incr = sizeof(unsigned long);
-	start_phys_aligned = ALIGN(start_phys, incr);
-	count = (size - (start_phys_aligned - start_phys))/incr;
-	start = __va(start_phys_aligned);
-	start_bad = 0;
-	last_bad = 0;
-
-	for (i = 0; i < count; i++)
-		start[i] = val;
-	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
-		if (*start != val) {
-			if (start_phys_aligned == last_bad + incr) {
-				last_bad += incr;
-			} else {
-				if (start_bad) {
-					printk(KERN_CONT "\n  %016lx bad mem addr %016lx - %016lx reserved",
-						val, start_bad, last_bad + incr);
-					reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
-				}
-				start_bad = last_bad = start_phys_aligned;
-			}
-		}
-	}
-	if (start_bad) {
-		printk(KERN_CONT "\n  %016lx bad mem addr %016lx - %016lx reserved",
-			val, start_bad, last_bad + incr);
-		reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
-	}
-
-}
-
-/* default is disabled */
-static int memtest_pattern __initdata;
-
-static int __init parse_memtest(char *arg)
-{
-	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0);
-	return 0;
-}
-
-early_param("memtest", parse_memtest);
-
-static void __init early_memtest(unsigned long start, unsigned long end)
-{
-	u64 t_start, t_size;
-	unsigned pattern;
-
-	if (!memtest_pattern)
-		return;
-
-	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
-	for (pattern = 0; pattern < memtest_pattern; pattern++) {
-		t_start = start;
-		t_size = 0;
-		while (t_start < end) {
-			t_start = find_e820_area_size(t_start, &t_size, 1);
-
-			/* done ? */
-			if (t_start >= end)
-				break;
-			if (t_start + t_size > end)
-				t_size = end - t_start;
-
-			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
-				(unsigned long long)t_start,
-				(unsigned long long)t_start + t_size, pattern);
-
-			memtest(t_start, t_size, pattern);
-
-			t_start += t_size;
-		}
-	}
-	printk(KERN_CONT "\n");
-}
-#else
-static void __init early_memtest(unsigned long start, unsigned long end)
-{
-}
-#endif
-
 static unsigned long __init kernel_physical_mapping_init(unsigned long start,
 						unsigned long end,
 						unsigned long page_size_mask)
Index: linux-2.6/arch/x86/mm/memtest.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/mm/memtest.c
@@ -0,0 +1,123 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/pfn.h>
+
+#include <asm/e820.h>
+
+static void __init memtest(unsigned long start_phys, unsigned long size,
+				 unsigned pattern)
+{
+	unsigned long i;
+	unsigned long *start;
+	unsigned long start_bad;
+	unsigned long last_bad;
+	unsigned long val;
+	unsigned long start_phys_aligned;
+	unsigned long count;
+	unsigned long incr;
+
+	switch (pattern) {
+	case 0:
+		val = 0UL;
+		break;
+	case 1:
+		val = -1UL;
+		break;
+	case 2:
+#ifdef CONFIG_X86_64
+		val = 0x5555555555555555UL;
+#else
+		val = 0x55555555UL;
+#endif
+		break;
+	case 3:
+#ifdef CONFIG_X86_64
+		val = 0xaaaaaaaaaaaaaaaaUL;
+#else
+		val = 0xaaaaaaaaUL;
+#endif
+		break;
+	default:
+		return;
+	}
+
+	incr = sizeof(unsigned long);
+	start_phys_aligned = ALIGN(start_phys, incr);
+	count = (size - (start_phys_aligned - start_phys))/incr;
+	start = __va(start_phys_aligned);
+	start_bad = 0;
+	last_bad = 0;
+
+	for (i = 0; i < count; i++)
+		start[i] = val;
+	for (i = 0; i < count; i++, start++, start_phys_aligned += incr) {
+		if (*start != val) {
+			if (start_phys_aligned == last_bad + incr) {
+				last_bad += incr;
+			} else {
+				if (start_bad) {
+					printk(KERN_CONT "\n  %010lx bad mem addr %010lx - %010lx reserved",
+						val, start_bad, last_bad + incr);
+					reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+				}
+				start_bad = last_bad = start_phys_aligned;
+			}
+		}
+	}
+	if (start_bad) {
+		printk(KERN_CONT "\n  %016lx bad mem addr %010lx - %010lx reserved",
+			val, start_bad, last_bad + incr);
+		reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
+	}
+
+}
+
+/* default is disabled */
+static int memtest_pattern __initdata;
+
+static int __init parse_memtest(char *arg)
+{
+	if (arg)
+		memtest_pattern = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+
+early_param("memtest", parse_memtest);
+
+void __init early_memtest(unsigned long start, unsigned long end)
+{
+	u64 t_start, t_size;
+	unsigned pattern;
+
+	if (!memtest_pattern)
+		return;
+
+	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
+	for (pattern = 0; pattern < memtest_pattern; pattern++) {
+		t_start = start;
+		t_size = 0;
+		while (t_start < end) {
+			t_start = find_e820_area_size(t_start, &t_size, 1);
+
+			/* done ? */
+			if (t_start >= end)
+				break;
+			if (t_start + t_size > end)
+				t_size = end - t_start;
+
+			printk(KERN_CONT "\n  %010llx - %010llx pattern %d",
+				(unsigned long long)t_start,
+				(unsigned long long)t_start + t_size, pattern);
+
+			memtest(t_start, t_size, pattern);
+
+			t_start += t_size;
+		}
+	}
+	printk(KERN_CONT "\n");
+}
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -89,6 +89,14 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
+#ifdef CONFIG_MEMTEST
+extern void early_memtest(unsigned long start, unsigned long end);
+#else
+static inline void early_memtest(unsigned long start, unsigned long end)
+{
+}
+#endif
+
 extern unsigned long end_user_pfn;
 
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
