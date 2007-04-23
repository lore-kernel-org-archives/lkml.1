Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXDWSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXDWSct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161306AbXDWSct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:32:49 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51177 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161276AbXDWScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:32:48 -0400
Date: Mon, 23 Apr 2007 19:32:46 +0100
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Message-ID: <20070423183246.GA11841@skynet.ie>
References: <20070413140533.A239.Y-GOTO@jp.fujitsu.com> <20070421232248.431ef2da.akpm@linux-foundation.org> <20070423203837.23AD.Y-GOTO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070423203837.23AD.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wasn't even aware of this kernelcore thing.  It's pretty nasty-looking. 
> > yet another reminder that this code hasn't been properly reviewed in the
> > past year or three.
> 
> Just now, I'm making memory-unplug patches with current MOVABLE_ZONE
> code. So, I might be the first user of it on ia64.
> 
> Anyway, I'll try to fix it.
> 

Can you review this patch and see does it fix the problem please? There
was a second problem that showed up while testing this in relation to the
bootmem allocator assumptions about zone boundary alignment. I'll follow up
this mail with the patch in case you are seeing that problem.

Subject: Fix parsing kernelcore boot option V2
cmdline_parse_kernelcore() should return the next pointer of boot option
like memparse() doing. If not, it is cause of eternal loop on ia64 box.
This patch is for 2.6.21-rc6-mm1. This patch changes the kernelcore command
line parsing so that is compatible with both early_param() way of doing
things and IA64.

[y-goto@jp.fujitsu.com: Fix parsing kernelcore boot option V1]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/arch/i386/kernel/setup.c linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/i386/kernel/setup.c
--- linux-2.6.21-rc6-mm1-001_latest/arch/i386/kernel/setup.c	2007-04-17 14:31:59.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/i386/kernel/setup.c	2007-04-23 11:08:20.000000000 +0100
@@ -195,7 +195,7 @@ static int __init parse_mem(char *arg)
 	return 0;
 }
 early_param("mem", parse_mem);
-early_param("kernelcore", cmdline_parse_kernelcore);
+early_param("kernelcore", early_parse_kernelcore);
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/arch/ia64/kernel/efi.c linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/ia64/kernel/efi.c
--- linux-2.6.21-rc6-mm1-001_latest/arch/ia64/kernel/efi.c	2007-04-23 10:46:27.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/ia64/kernel/efi.c	2007-04-23 11:08:43.000000000 +0100
@@ -423,7 +423,7 @@ efi_init (void)
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
 			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else if (memcmp(cp, "kernelcore=",11) == 0) {
-			cmdline_parse_kernelcore(cp+11);
+			parse_kernelcore(cp+11, &cp);
 		} else if (memcmp(cp, "min_addr=", 9) == 0) {
 			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else {
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/arch/powerpc/kernel/prom.c linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/powerpc/kernel/prom.c
--- linux-2.6.21-rc6-mm1-001_latest/arch/powerpc/kernel/prom.c	2007-04-17 14:31:59.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/powerpc/kernel/prom.c	2007-04-23 11:11:54.000000000 +0100
@@ -431,7 +431,7 @@ static int __init early_parse_mem(char *
 	return 0;
 }
 early_param("mem", early_parse_mem);
-early_param("kernelcore", cmdline_parse_kernelcore);
+early_param("kernelcore", early_parse_kernelcore);
 
 /*
  * The device tree may be allocated below our memory limit, or inside the
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/arch/ppc/mm/init.c linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/ppc/mm/init.c
--- linux-2.6.21-rc6-mm1-001_latest/arch/ppc/mm/init.c	2007-04-17 14:31:59.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/ppc/mm/init.c	2007-04-23 11:08:58.000000000 +0100
@@ -214,7 +214,7 @@ void MMU_setup(void)
 	}
 }
 
-early_param("kernelcore", cmdline_parse_kernelcore);
+early_param("kernelcore", early_parse_kernelcore);
 
 /*
  * MMU_init sets up the basic memory mappings for the kernel,
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/arch/x86_64/kernel/e820.c linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/x86_64/kernel/e820.c
--- linux-2.6.21-rc6-mm1-001_latest/arch/x86_64/kernel/e820.c	2007-04-17 14:32:00.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/arch/x86_64/kernel/e820.c	2007-04-23 11:09:09.000000000 +0100
@@ -604,7 +604,7 @@ static int __init parse_memopt(char *p)
 	return 0;
 } 
 early_param("mem", parse_memopt);
-early_param("kernelcore", cmdline_parse_kernelcore);
+early_param("kernelcore", early_parse_kernelcore);
 
 static int userdef __initdata;
 
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/include/linux/mm.h linux-2.6.21-rc6-mm1-002_ia64cmdline/include/linux/mm.h
--- linux-2.6.21-rc6-mm1-001_latest/include/linux/mm.h	2007-04-23 10:46:27.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/include/linux/mm.h	2007-04-23 11:04:07.000000000 +0100
@@ -1051,7 +1051,8 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
-extern int cmdline_parse_kernelcore(char *p);
+extern int parse_kernelcore(char *p, char **retp);
+extern int early_parse_kernelcore(char *p);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-001_latest/mm/page_alloc.c linux-2.6.21-rc6-mm1-002_ia64cmdline/mm/page_alloc.c
--- linux-2.6.21-rc6-mm1-001_latest/mm/page_alloc.c	2007-04-23 10:46:27.000000000 +0100
+++ linux-2.6.21-rc6-mm1-002_ia64cmdline/mm/page_alloc.c	2007-04-23 12:27:32.000000000 +0100
@@ -3728,13 +3728,13 @@ void __init free_area_init_nodes(unsigne
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
  */
-int __init cmdline_parse_kernelcore(char *p)
+int __init parse_kernelcore(char *p, char **retp)
 {
 	unsigned long long coremem;
 	if (!p)
 		return -EINVAL;
 
-	coremem = memparse(p, &p);
+	coremem = memparse(p, retp);
 	required_kernelcore = coremem >> PAGE_SHIFT;
 
 	/* Paranoid check that UL is enough for required_kernelcore */
@@ -3742,6 +3742,12 @@ int __init cmdline_parse_kernelcore(char
 
 	return 0;
 }
+
+/* For use with early_param where available */
+int __init early_parse_kernelcore(char *p)
+{
+	return parse_kernelcore(p, &p);
+}
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 /**
