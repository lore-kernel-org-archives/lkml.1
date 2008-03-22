Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYCVByU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYCVByU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 21:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYCVByG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 21:54:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:13412 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYCVByD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 21:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=B3n5rhaQVd1J4OFuWQZQ7YyDD406qxSQU4emrytagw66GC3KjOIwbl+mjNdGmeBcwtZjZQCBXF43c72OhoPSr7EE0JpzpFuZB4NG8VxbAy0nSa+GZ3PQR2TAQ7gbmI6WC3NYIncGBcYZaZMk8/hO0VdwK2XN1yxt7Jzj4Fq/zt8=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: memtest bootparam
Date: Fri, 21 Mar 2008 18:56:19 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211856.19772.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: memtest bootparam

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1149,6 +1149,11 @@ and is between 256 and 4096 characters. 
 			[KNL,ACPI] Mark specific memory as reserved.
 			Region of memory to be used, from ss to ss+nn.
 
+	memtest=	[KNL,X86_64] Enable memtest
+			Format: <integer>
+			range: 0,4 : pattern number
+			default : 0 <disable>
+
 	meye.*=		[HW] Set MotionEye Camera parameters
 			See Documentation/video4linux/meye.txt.
 
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -386,6 +386,35 @@ config PARAVIRT
 
 endif
 
+config MEMTEST_BOOTPARAM
+	bool "Memtest boot parameter"
+	depends on X86_64
+	default y
+	help
+	  This option adds a kernel parameter 'memtest', which allows memtest
+	  to be disabled at boot.  If this option is selected, memtest
+	  functionality can be disabled with memtest=0 on the kernel
+	  command line.  The purpose of this option is to allow a single
+	  kernel image to be distributed with memtest built in, but not
+	  necessarily enabled.
+
+	  If you are unsure how to answer this question, answer Y.
+
+config MEMTEST_BOOTPARAM_VALUE
+	int "Memtest boot parameter default value (0-4)"
+	depends on MEMTEST_BOOTPARAM
+	range 0 4
+	default 0
+	help
+	  This option sets the default value for the kernel parameter
+	  'memtest', which allows memtest to be disabled at boot.  If this
+	  option is set to 0 (zero), the memtest kernel parameter will
+	  default to 0, disabling memtest at bootup.  If this option is
+	  set to 4, the memtest kernel parameter will default to 4,
+	  enabling memtest at bootup, and use that as pattern number.
+
+	  If you are unsure how to answer this question, answer 0.
+
 config ACPI_SRAT
 	def_bool y
 	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -246,7 +246,9 @@ unsigned long __init find_e820_area(unsi
 /*
  * Find next free range after *start
  */
-unsigned long __init find_e820_area_size(unsigned long start, unsigned long *sizep, unsigned long align)
+unsigned long __init find_e820_area_size(unsigned long start,
+					 unsigned long *sizep,
+					 unsigned long align)
 {
 	int i;
 
@@ -259,17 +261,15 @@ unsigned long __init find_e820_area_size
 			continue;
 		addr = round_up(ei->addr, align);
 		ei_last = ei->addr + ei->size;
-//		printk(KERN_DEBUG "find_e820_area_size : e820 %d [%llx, %lx]\n", i, ei->addr, ei_last);
 		if (addr < start)
 			addr = round_up(start, align);
-//		printk(KERN_DEBUG "find_e820_area_size : 0 [%lx, %lx]\n", addr, ei_last);
 		if (addr >= ei_last)
 			continue;
 		*sizep = ei_last - addr;
-		while (bad_addr_size(&addr, sizep, align) && addr+ *sizep <= ei_last)
+		while (bad_addr_size(&addr, sizep, align) &&
+			addr + *sizep <= ei_last)
 			;
 		last = addr + *sizep;
-//		printk(KERN_DEBUG "find_e820_area_size : 1 [%lx, %lx]\n", addr, last);
 		if (last > ei_last)
 			continue;
 		return addr;
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -427,7 +427,10 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
-static void __init memtest(unsigned long start_phys, unsigned long size, unsigned pattern)
+#ifdef CONFIG_MEMTEST_BOOTPARAM
+
+static void __init memtest(unsigned long start_phys, unsigned long size,
+				 unsigned pattern)
 {
 	unsigned long i;
 	unsigned long *start;
@@ -486,11 +489,12 @@ static void __init memtest(unsigned long
 
 }
 
-static int __initdata memtest_pattern;
+static int memtest_pattern __initdata = CONFIG_MEMTEST_BOOTPARAM_VALUE;
+
 static int __init parse_memtest(char *arg)
 {
 	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0) + 1;
+		memtest_pattern = simple_strtoul(arg, NULL, 0);
 	return 0;
 }
 
@@ -501,8 +505,10 @@ static void __init early_memtest(unsigne
 	unsigned long t_start, t_size;
 	unsigned pattern;
 
-	if (memtest_pattern)
-		printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
+	if (!memtest_pattern)
+		return;
+
+	printk(KERN_INFO "early_memtest: pattern num %d", memtest_pattern);
 	for (pattern = 0; pattern < memtest_pattern; pattern++) {
 		t_start = start;
 		t_size = 0;
@@ -523,9 +529,13 @@ static void __init early_memtest(unsigne
 			t_start += t_size;
 		}
 	}
-	if (memtest_pattern)
-		printk(KERN_CONT "\n");
+	printk(KERN_CONT "\n");
 }
+#else
+static void __init early_memtest(unsigned long start, unsigned long end)
+{
+}
+#endif
 
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
