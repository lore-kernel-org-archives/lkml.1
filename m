Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0CEUjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:39:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:56885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0CEUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:39:54 -0500
Message-ID: <4B916BD6.8010701@kernel.org>
Date: Fri, 05 Mar 2010 12:38:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/bootmem: introduce bootmem_default_goal
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> 	<20100305032106.GA12065@cmpxchg.org> <49b004811003042117n720f356h7e10997a1a783475@mail.gmail.com> <4B915074.4020704@kernel.org>
In-Reply-To: <4B915074.4020704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if you don't want to drop
|  bootmem: avoid DMA32 zone by default

today mainline tree actually DO NOT need that patch according to print out ...

please apply this one too.

[PATCH] x86/bootmem: introduce bootmem_default_goal

don't punish the 64bit systems with less 4G RAM.
they should use _pa(MAX_DMA_ADDRESS) at first pass instead of failback...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   13 +++++++++++++
 include/linux/bootmem.h |    3 ++-
 mm/bootmem.c            |    4 ++++
 3 files changed, 19 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -686,6 +686,18 @@ static void __init trim_bios_range(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+#ifdef MAX_DMA32_PFN
+static void __init set_bootmem_default_goal(void)
+{
+	if (max_pfn_mapped < MAX_DMA32_PFN)
+		bootmem_default_goal = __pa(MAX_DMA_ADDRESS);
+}
+#else
+static void __init set_bootmem_default_goal(void)
+{
+}
+#endif
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -931,6 +943,7 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 	}
 #endif
+	set_bootmem_default_goal();
 
 	/*
 	 * NOTE: On x86-32, only from this point on, fixmaps are ready for use.
Index: linux-2.6/include/linux/bootmem.h
===================================================================
--- linux-2.6.orig/include/linux/bootmem.h
+++ linux-2.6/include/linux/bootmem.h
@@ -104,7 +104,8 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long goal);
 
 #ifdef MAX_DMA32_PFN
-#define BOOTMEM_DEFAULT_GOAL	(MAX_DMA32_PFN << PAGE_SHIFT)
+extern unsigned long bootmem_default_goal;
+#define BOOTMEM_DEFAULT_GOAL	bootmem_default_goal
 #else
 #define BOOTMEM_DEFAULT_GOAL	__pa(MAX_DMA_ADDRESS)
 #endif
Index: linux-2.6/mm/bootmem.c
===================================================================
--- linux-2.6.orig/mm/bootmem.c
+++ linux-2.6/mm/bootmem.c
@@ -25,6 +25,10 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
+#ifdef MAX_DMA32_PFN
+unsigned long bootmem_default_goal = (MAX_DMA32_PFN << PAGE_SHIFT);
+#endif
+
 #ifdef CONFIG_CRASH_DUMP
 /*
  * If we have booted due to a crash, max_pfn will be a very low value. We need
