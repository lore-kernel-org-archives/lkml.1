Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbXIYSYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbXIYSYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXIYSXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:23:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:53030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXIYSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:23:00 -0400
Message-Id: <20070925182258.761957672@strauss.suse.de>
References: <20070925182257.900701776@strauss.suse.de>
User-Agent: quilt/0.46-58
Date: Tue, 25 Sep 2007 20:23:00 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       discuss@x86-64.org
Subject: [patch 3/7] Use extended crashkernel command line on x86_64
Content-Disposition: inline; filename=crashkernel-x86_64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the crashkernel parsing from
arch/x86_64/kernel/machine_kexec.c and calls the generic function, introduced in
the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


---
 arch/x86_64/kernel/e820.c          |    3 +-
 arch/x86_64/kernel/machine_kexec.c |   27 -------------------------
 arch/x86_64/kernel/setup.c         |   39 ++++++++++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 35 deletions(-)

--- a/arch/x86_64/kernel/e820.c
+++ b/arch/x86_64/kernel/e820.c
@@ -226,7 +226,8 @@ void __init e820_reserve_resources(void)
 			request_resource(res, &code_resource);
 			request_resource(res, &data_resource);
 #ifdef CONFIG_KEXEC
-			request_resource(res, &crashk_res);
+			if (crashk_res.start != crashk_res.end)
+				request_resource(res, &crashk_res);
 #endif
 		}
 	}
--- a/arch/x86_64/kernel/machine_kexec.c
+++ b/arch/x86_64/kernel/machine_kexec.c
@@ -231,33 +231,6 @@ NORET_TYPE void machine_kexec(struct kim
 			image->start);
 }
 
-/* crashkernel=size@addr specifies the location to reserve for
- * a crash kernel.  By reserving this memory we guarantee
- * that linux never set's it up as a DMA target.
- * Useful for holding code to do something appropriate
- * after a kernel panic.
- */
-static int __init setup_crashkernel(char *arg)
-{
-	unsigned long size, base;
-	char *p;
-	if (!arg)
-		return -EINVAL;
-	size = memparse(arg, &p);
-	if (arg == p)
-		return -EINVAL;
-	if (*p == '@') {
-		base = memparse(p+1, &p);
-		/* FIXME: Do I want a sanity check to validate the
-		 * memory range?  Yes you do, but it's too early for
-		 * e820 -AK */
-		crashk_res.start = base;
-		crashk_res.end   = base + size - 1;
-	}
-	return 0;
-}
-early_param("crashkernel", setup_crashkernel);
-
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -194,6 +194,37 @@ static inline void copy_edd(void)
 }
 #endif
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long free_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	free_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
+
+	ret = parse_crashkernel(boot_command_line, free_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size) {
+		if (crash_base > 0) {
+			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+					"for crashkernel (System RAM: %ldMB)\n",
+					(unsigned long)(crash_size >> 20),
+					(unsigned long)(crash_base >> 20),
+					(unsigned long)(free_mem >> 20));
+			crashk_res.start = crash_base;
+			crashk_res.end   = crash_base + crash_size - 1;
+			reserve_bootmem(crash_base, crash_size);
+		} else
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+	}
+}
+#else
+static inline void __init reserve_crashkernel(void)
+{}
+#endif
+
 #define EBDA_ADDR_POINTER 0x40E
 
 unsigned __initdata ebda_addr;
@@ -365,13 +396,7 @@ void __init setup_arch(char **cmdline_p)
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end) {
-		reserve_bootmem_generic(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-	}
-#endif
-
+	reserve_crashkernel();
 	paging_init();
 
 #ifdef CONFIG_PCI

-- 
