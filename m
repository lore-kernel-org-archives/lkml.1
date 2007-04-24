Return-Path: <linux-kernel-owner+w=401wt.eu-S1161693AbXDXHcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161693AbXDXHcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161691AbXDXHcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:32:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39349 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161687AbXDXHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:31:57 -0400
Date: Tue, 24 Apr 2007 16:31:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070424092625.b2b24a76.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070423183246.GA11841@skynet.ie> <20070424092625.b2b24a76.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070424162320.FD92.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel-san.

I tested your patch (Thanks!). It worked. But......

> In my understanding, why ia64 doesn't use early_param() macro for mem= at el. is that 
> it has to use mem= option at efi handling which is called before parse_early_param().
> 
> Current ia64's boot path is
>  setup_arch()
>     -> efi handling -> parse_early_param() -> numa handling -> pgdat/zone init
> 
> kernelcore= option is just used at pgdat/zone initialization. (no arch dependent part...)
> 
> So I think just adding
> ==
> early_param("kernelcore",cmpdline_parse_kernelcore)
> ==
> to ia64 is ok.....

Then, it can be common code.
How is this patch? I confirmed this can work well too.

--------

When "kernelcore" boot option is specified, kernel can't boot up
on ia64. It is cause of eternal loop.
In addition, its code can be common code. This is fix for it.
I tested this patch on my ia64 box.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---------

 arch/i386/kernel/setup.c   |    1 -
 arch/ia64/kernel/efi.c     |    2 --
 arch/powerpc/kernel/prom.c |    1 -
 arch/ppc/mm/init.c         |    2 --
 arch/x86_64/kernel/e820.c  |    1 -
 include/linux/mm.h         |    1 -
 mm/page_alloc.c            |    3 +++
 7 files changed, 3 insertions(+), 8 deletions(-)

Index: kernelcore/arch/ia64/kernel/efi.c
===================================================================
--- kernelcore.orig/arch/ia64/kernel/efi.c	2007-04-24 15:09:37.000000000 +0900
+++ kernelcore/arch/ia64/kernel/efi.c	2007-04-24 15:25:22.000000000 +0900
@@ -423,8 +423,6 @@ efi_init (void)
 			mem_limit = memparse(cp + 4, &cp);
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
 			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
-		} else if (memcmp(cp, "kernelcore=",11) == 0) {
-			cmdline_parse_kernelcore(cp+11);
 		} else if (memcmp(cp, "min_addr=", 9) == 0) {
 			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else {
Index: kernelcore/arch/i386/kernel/setup.c
===================================================================
--- kernelcore.orig/arch/i386/kernel/setup.c	2007-04-24 15:29:20.000000000 +0900
+++ kernelcore/arch/i386/kernel/setup.c	2007-04-24 15:29:39.000000000 +0900
@@ -195,7 +195,6 @@ static int __init parse_mem(char *arg)
 	return 0;
 }
 early_param("mem", parse_mem);
-early_param("kernelcore", cmdline_parse_kernelcore);
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
Index: kernelcore/arch/powerpc/kernel/prom.c
===================================================================
--- kernelcore.orig/arch/powerpc/kernel/prom.c	2007-04-24 15:04:47.000000000 +0900
+++ kernelcore/arch/powerpc/kernel/prom.c	2007-04-24 15:30:25.000000000 +0900
@@ -431,7 +431,6 @@ static int __init early_parse_mem(char *
 	return 0;
 }
 early_param("mem", early_parse_mem);
-early_param("kernelcore", cmdline_parse_kernelcore);
 
 /*
  * The device tree may be allocated below our memory limit, or inside the
Index: kernelcore/arch/ppc/mm/init.c
===================================================================
--- kernelcore.orig/arch/ppc/mm/init.c	2007-04-24 15:04:47.000000000 +0900
+++ kernelcore/arch/ppc/mm/init.c	2007-04-24 15:30:56.000000000 +0900
@@ -214,8 +214,6 @@ void MMU_setup(void)
 	}
 }
 
-early_param("kernelcore", cmdline_parse_kernelcore);
-
 /*
  * MMU_init sets up the basic memory mappings for the kernel,
  * including both RAM and possibly some I/O regions,
Index: kernelcore/arch/x86_64/kernel/e820.c
===================================================================
--- kernelcore.orig/arch/x86_64/kernel/e820.c	2007-04-24 15:04:47.000000000 +0900
+++ kernelcore/arch/x86_64/kernel/e820.c	2007-04-24 15:34:02.000000000 +0900
@@ -604,7 +604,6 @@ static int __init parse_memopt(char *p)
 	return 0;
 } 
 early_param("mem", parse_memopt);
-early_param("kernelcore", cmdline_parse_kernelcore);
 
 static int userdef __initdata;
 
Index: kernelcore/include/linux/mm.h
===================================================================
--- kernelcore.orig/include/linux/mm.h	2007-04-24 15:09:37.000000000 +0900
+++ kernelcore/include/linux/mm.h	2007-04-24 15:35:52.000000000 +0900
@@ -1051,7 +1051,6 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
-extern int cmdline_parse_kernelcore(char *p);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
Index: kernelcore/mm/page_alloc.c
===================================================================
--- kernelcore.orig/mm/page_alloc.c	2007-04-24 15:09:37.000000000 +0900
+++ kernelcore/mm/page_alloc.c	2007-04-24 16:00:21.000000000 +0900
@@ -3728,6 +3728,9 @@ int __init cmdline_parse_kernelcore(char
 
 	return 0;
 }
+
+early_param("kernelcore", cmdline_parse_kernelcore);
+
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 /**


-- 
Yasunori Goto 


