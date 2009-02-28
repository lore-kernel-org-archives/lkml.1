Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZB1Byc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZB1Byc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762951AbZB1Bv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:29 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45522
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762937AbZB1Bv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:26 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: reserve brk earlier
Date: Fri, 27 Feb 2009 17:51:19 -0800
Message-Id: <1235785882-17580-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We need to reserve the brk segment before doing the pagetable
construction, so that it doesn't allocate the same memory.

Also, pre-initialize brk to _end (but still leave init_brk for cases
where that's not correct, like i386 (for now) and Xen).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head64.c |    2 --
 arch/x86/kernel/setup.c  |   16 ++++++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 4b29802..f5b2722 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -91,8 +91,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
-	init_brk((unsigned long)&_end);
-
 	x86_64_start_reservations(real_mode_data);
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6a21423..c246dc4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,7 +113,8 @@
 #endif
 
 unsigned int boot_cpu_id __read_mostly;
-__initdata unsigned long _brk_start, _brk_end;
+__initdata unsigned long _brk_start = (unsigned long)&_end;
+__initdata unsigned long _brk_end = (unsigned long)&_end;
 
 #ifdef CONFIG_X86_64
 int default_cpu_present_to_apicid(int mps_cpu)
@@ -356,6 +357,14 @@ void * __init extend_brk(size_t size, size_t align)
 	return ret;
 }
 
+static void __init reserve_brk(void)
+{
+	if (_brk_end > _brk_start)
+		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
+
+	_brk_end = _brk_start = 0xdeadb00c + POISON_POINTER_DELTA;
+}
+
 static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -856,6 +865,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
+	reserve_brk();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
@@ -898,9 +909,6 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
-	if (_brk_end > _brk_start)
-		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
-
 	initmem_init(0, max_pfn);
 
 #ifdef CONFIG_ACPI_SLEEP
-- 
1.6.0.6

