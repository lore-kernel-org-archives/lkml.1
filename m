Return-Path: <linux-kernel-owner+w=401wt.eu-S1764874AbXJOLvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764874AbXJOLvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760361AbXJOLuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:51301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbXJOLuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:50:44 -0400
Message-Id: <20071015115043.244612028@strauss.suse.de>
References: <20071015115042.391348549@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Mon, 15 Oct 2007 13:50:44 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de
Subject: [patch 2/2] Check if the crashkernel area is behind BSS
Content-Disposition: inline; filename=crashkernel_check_end
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if the crashkernel base address is after the end of BSS
on i386 and x86_64.

Having "Kernel bss" in the resource tree is not sufficient since that only
prevents "crash kernel" from appearing in the resource tree and therefore kexec
from loading the crashdump kernel since it checks /proc/iomem. However, the
crashkernel memory would still be reserved.



Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/setup_32.c |   31 +++++++++++++++++++++----------
 arch/x86/kernel/setup_64.c |   31 +++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -403,18 +403,29 @@ static void __init reserve_crashkernel(v
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
-			reserve_bootmem(crash_base, crash_size);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (base < virt_to_phys(&_end)) {
+			printk(KERN_WARNING "base address for crashkernel "
+					"(%luMB) is too low -- 0M-%luMB area "
+					"is needed by the kernel\n",
+					base >> 20,  virt_to_phys(&_end) << 20);
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		reserve_bootmem(crash_base, crash_size);
 	}
 }
 #else
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -210,18 +210,29 @@ static void __init reserve_crashkernel(v
 	ret = parse_crashkernel(boot_command_line, free_mem,
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
-			reserve_bootmem(crash_base, crash_size);
-		} else
+		if (crash_base <= 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
+			return;
+		}
+
+		if (crash_base < virt_to_phys(&_end)) {
+			printk(KERN_WARNING "base address for crashkernel "
+					"(%lluMB) is too low -- 0M-%luMB area "
+					"is needed by the kernel\n",
+					crash_base >> 20,
+					virt_to_phys(&_end) << 20);
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(free_mem >> 20));
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		reserve_bootmem(crash_base, crash_size);
 	}
 }
 #else

-- 
