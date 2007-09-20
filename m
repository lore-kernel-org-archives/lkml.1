Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXITRVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXITRVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbXITRTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:19:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbXITRSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:18:48 -0400
Message-Id: <20070920171847.117044000@stravinsky.suse.de>
References: <20070920171845.774383000@stravinsky.suse.de>
User-Agent: quilt/0.46-47.1
Date: Thu, 20 Sep 2007 19:18:51 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 6/7] Use extended crashkernel command line on sh
Content-Disposition: inline; filename=crashkernel-sh
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the crashkernel parsing from arch/sh/kernel/machine_kexec.c
and calls the generic function, introduced in the generic patch, in
setup_bootmem_allocator().

This is necessary because the amount of System RAM must be known in this
function now because of the new syntax.

NOTE: Due to the lack of a SH processor, this patch is untested (and
uncompiled). Because the code in that area is quite similar as i386/x86_64
(contrary to PPC and IA64), it should compile and work. However, if someone of
the SH people could test for me and provide feedback, that would be very nice.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
Acked-by: Paul Mundt <lethal@linux-sh.org>

---
 arch/sh/kernel/machine_kexec.c |   21 ---------------------
 arch/sh/kernel/setup.c         |   38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 26 deletions(-)

--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -104,24 +104,3 @@ NORET_TYPE void machine_kexec(struct kim
 	(*rnk)(page_list, reboot_code_buffer, image->start, vbr_reg);
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
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -121,6 +121,37 @@ static void __init register_bootmem_low_
 	free_bootmem(PFN_PHYS(curr_pfn), PFN_PHYS(pages));
 }
 
+#ifdef CONFIG_KEXEC
+static void __init reserve_crashkernel(void)
+{
+	unsigned long long 	free_mem;
+	unsigned long long 	crash_size, crash_base;
+	int			ret;
+
+	free_mem = (max_low_pfn - min_low_pfn) << PAGE_SHIFT;
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
 void __init setup_bootmem_allocator(unsigned long free_pfn)
 {
 	unsigned long bootmap_size;
@@ -182,11 +213,8 @@ void __init setup_bootmem_allocator(unsi
 		}
 	}
 #endif
-#ifdef CONFIG_KEXEC
-	if (crashk_res.start != crashk_res.end)
-		reserve_bootmem(crashk_res.start,
-			crashk_res.end - crashk_res.start + 1);
-#endif
+
+	reserve_crashkernel();
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES

-- 
