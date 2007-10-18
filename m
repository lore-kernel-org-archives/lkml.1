Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXJRLQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXJRLQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762434AbXJRLPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:15:39 -0400
Received: from mail.suse.de ([195.135.220.2]:34947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762208AbXJRLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:15:38 -0400
Message-Id: <20071018111536.623351733@strauss.suse.de>
References: <20071018111535.356215664@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 18 Oct 2007 13:15:38 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de, vgoyal@in.ibm.com
Subject: [patch 3/3] Use BOOTMEM_EXCLUSIVE on x86
Content-Disposition: inline; filename=bootmem-alloc-use-crashkernel
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the BOOTMEM_EXCLUSIVE, introduced in the previous patch,
to avoid conflicts while reserving the memory for the kdump carpture kernel
(crashkernel=).

The modification has been tested on i386.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/setup_32.c |   28 ++++++++++++++++++----------
 arch/x86/kernel/setup_64.c |   35 +++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 24 deletions(-)

--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -403,18 +403,26 @@ static void __init reserve_crashkernel(v
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(total_mem >> 20));
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size, BOOTMEM_DEFAULT);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
 	}
 }
 #else
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -201,28 +201,35 @@ static inline void copy_edd(void)
 #ifdef CONFIG_KEXEC
 static void __init reserve_crashkernel(void)
 {
-	unsigned long long free_mem;
+	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	free_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
+	total_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
 
-	ret = parse_crashkernel(boot_command_line, free_mem,
+	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(free_mem >> 20));
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
 	}
 }
 #else

-- 
