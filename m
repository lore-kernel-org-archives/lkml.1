Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYCSXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYCSXUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938594AbYCSVrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:47:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:49834 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938586AbYCSVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:47:14 -0400
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: trim mtrr don't close gap for resource allocation.
Date: Tue, 18 Mar 2008 16:44:19 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: steve@lobefin.net, Jesse Barnes <jbarnes@virtuousgeek.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com> <200803181255.10402.yhlu.kernel@gmail.com>
In-Reply-To: <200803181255.10402.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803181644.20356.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: trim mtrr don't close gap for resource allocation.

for
	http://bugzilla.kernel.org/show_bug.cgi?id=10232

use update_memory_range instead of add_memory_range directly
to avoid closing that gap.

Signed-off-by: Yinghai Lu <yhlu.kenrel@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -711,7 +711,8 @@ int __init mtrr_trim_uncached_memory(uns
 		trim_size = end_pfn;
 		trim_size <<= PAGE_SHIFT;
 		trim_size -= trim_start;
-		add_memory_region(trim_start, trim_size, E820_RESERVED);
+		update_memory_range(trim_start, trim_size, E820_RAM,
+					E820_RESERVED);
 		update_e820();
 		return 1;
 	}
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -749,6 +749,32 @@ static int __init parse_memmap(char *arg
 	return 0;
 }
 early_param("memmap", parse_memmap);
+void __init update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type)
+{
+	int i;
+
+	BUG_ON(old_type == new_type);
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 final_start, final_end;
+		if (ei->type != old_type)
+			continue;
+		/* totally covered? */
+		if (ei->addr >= start && ei->size <= size) {
+			ei->type = new_type;
+			continue;
+		}
+		/* partially covered */
+		final_start = max(start, ei->addr);
+		final_end = min(start + size, ei->addr + ei->size);
+		if (final_start >= final_end)
+			continue;
+		add_memory_region(final_start, final_end - final_start,
+					 new_type);
+	}
+}
 void __init update_e820(void)
 {
 	u8 nr_map;
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -735,6 +735,33 @@ void __init finish_e820_parsing(void)
 	}
 }
 
+void __init update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type)
+{
+	int i;
+
+	BUG_ON(old_type == new_type);
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 final_start, final_end;
+		if (ei->type != old_type)
+			continue;
+		/* totally covered? */
+		if (ei->addr >= start && ei->size <= size) {
+			ei->type = new_type;
+			continue;
+		}
+		/* partially covered */
+		final_start = max(start, ei->addr);
+		final_end = min(start + size, ei->addr + ei->size);
+		if (final_start >= final_end)
+			continue;
+		add_memory_region(final_start, final_end - final_start,
+					 new_type);
+	}
+}
+
 void __init update_e820(void)
 {
 	u8 nr_map;
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -28,6 +28,8 @@ extern void find_max_pfn(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
+extern void update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -18,6 +18,8 @@ extern unsigned long find_e820_area(unsi
 				    unsigned long size, unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size, 
 			      int type);
+extern void update_memory_range(u64 start, u64 size, unsigned old_type,
+				unsigned new_type);
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void); 
 extern unsigned long e820_end_of_ram(void);
