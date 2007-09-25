Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbXIYSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbXIYSXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXIYSXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:23:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:53026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXIYSW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:22:59 -0400
Message-Id: <20070925182258.453511196@strauss.suse.de>
References: <20070925182257.900701776@strauss.suse.de>
User-Agent: quilt/0.46-58
Date: Tue, 25 Sep 2007 20:22:59 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 2/7] Use extended crashkernel command line on i386
Content-Disposition: inline; filename=crashkernel-i386
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the crashkernel parsing from
arch/i386/kernel/machine_kexec.c and calls the generic function, introduced in
the last patch, in setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


---
 arch/i386/kernel/e820.c          |    3 +-
 arch/i386/kernel/machine_kexec.c |   22 -----------------
 arch/i386/kernel/setup.c         |   49 +++++++++++++++++++++++++++++++++++----
 3 files changed, 46 insertions(+), 28 deletions(-)

Files a/arch/i386/kernel/.setup.c.swp and b/arch/i386/kernel/.setup.c.swp differ
--- a/arch/i386/kernel/e820.c
+++ b/arch/i386/kernel/e820.c
@@ -288,7 +288,8 @@ legacy_init_iomem_resources(struct resou
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
 #ifdef CONFIG_KEXEC
-			request_resource(res, &crashk_res);
+			if (crashk_res.start != crashk_res.end)
+				request_resource(res, &crashk_res);
 #endif
 		}
 	}
--- a/arch/i386/kernel/machine_kexec.c
+++ b/arch/i386/kernel/machine_kexec.c
@@ -149,28 +149,6 @@ NORET_TYPE void machine_kexec(struct kim
 			image->start, cpu_has_pae);
 }
 
-/* crashkernel=size@addr specifies the location to reserve for
- * a crash kernel.  By reserving this memory we guarantee
- * that linux never sets it up as a DMA target.
- * Useful for holding code to do something appropriate
- * after a kernel panic.
- */
-static int __init parse_crashkernel(char *arg)
-{
-	unsigned long size, base;
-	size = memparse(arg, &arg);
-	if (*arg == '@') {
-		base = memparse(arg+1, &arg);
-		/* FIXME: Do I want a sanity check
-		 * to validate the memory range?
-		 */
-		crashk_res.start = base;
-		crashk_res.end   = base + size - 1;
-	}
-	return 0;
-}
-early_param("crashkernel", parse_crashkernel);
-
 void arch_crash_save_vmcoreinfo(void)
 {
 #ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -381,6 +381,49 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
+static inline unsigned long long get_total_mem(void)
+{
+	unsigned long long total;
+
+	total = max_low_pfn - min_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	total += highend_pfn - highstart_pfn;
+#endif
+
+	return total << PAGE_SHIFT;
+}
+
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	total_mem = get_total_mem();
+
+	ret = parse_crashkernel(boot_command_line, total_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base > 0) {
+			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+					"for crashkernel (System RAM: %ldMB)\n",
+					(unsigned long)(crash_size >> 20),
+					(unsigned long)(crash_base >> 20),
+					(unsigned long)(total_mem >> 20));
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
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -456,11 +499,7 @@ void __init setup_bootmem_allocator(void
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end)
-		reserve_bootmem(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-#endif
+	reserve_crashkernel();
 }
 
 /*

-- 
