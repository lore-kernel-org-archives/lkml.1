Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXITRTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXITRTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXITRSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:18:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:47519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbXITRSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:18:48 -0400
Message-Id: <20070920171846.278376000@stravinsky.suse.de>
References: <20070920171845.774383000@stravinsky.suse.de>
User-Agent: quilt/0.46-47.1
Date: Thu, 20 Sep 2007 19:18:47 +0200
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
 arch/i386/kernel/e820.c          |    3 ++-
 arch/i386/kernel/machine_kexec.c |   22 ----------------------
 arch/i386/kernel/setup.c         |   37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 28 deletions(-)

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
@@ -381,6 +381,37 @@ extern unsigned long __init setup_memory
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long 	free_mem;
+	unsigned long long 	crash_size, crash_base;
+	int			ret;
+
+	free_mem = (max_low_pfn + highend_pfn - highstart_pfn) << PAGE_SHIFT;
+
+	ret = parse_crashkernel(boot_command_line, free_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
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
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -456,11 +487,7 @@ void __init setup_bootmem_allocator(void
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
