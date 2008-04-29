Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbYD2JAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbYD2JAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYD2JAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:00:43 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:8547 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYD2JAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Nw7QKIOdLGAorlmkpBgrOQXqYPbsTonAYV3Pgs65q/uhZRt1bVfULoTU1aljb2Sh2uardQfQBIGKEehDVrJStQObey66EzddQ6pywFlNUXD2mDkMLVqKY3+bQkM+wmO8FwAI+K2eRonCamFPq4H/lEt4nMvMCslqlT38pTcUGYc=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: [PATCH 2/2] x86: fix trimming e820 with MTRR holes.
Date: Tue, 29 Apr 2008 01:59:49 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <200804290157.30651.yhlu.kernel@gmail.com>
In-Reply-To: <200804290157.30651.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290159.49882.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


converting MTRR layout from continous to discrete, some time could run out of
MTRRs. So add gran_sizek to prevent that by dumpping small RAM piece less than
gran_sizek.

previous trimming only can handle highest_pfn from mtrr to end_pfn from e820.
when have more than 4g RAM installed, there will be holes below 4g. so need to
check ram below 4g is coverred well.

need to be applied after
	[PATCH] x86: mtrr cleanup for converting continuous to discrete layout v7

Signed-off-by: Yinghai Lu <yinghai.lu@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1093,6 +1093,17 @@ int __init amd_special_default_mtrr(void
 	return 0;
 }
 
+static u64 __init real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
+{
+	u64 trim_start, trim_size;
+	trim_start =  start_pfn;
+	trim_start <<= PAGE_SHIFT;
+	trim_size = limit_pfn;
+	trim_size <<= PAGE_SHIFT;
+	trim_size -= trim_start;
+	return update_memory_range(trim_start, trim_size, E820_RAM,
+				E820_RESERVED);
+}
 /**
  * mtrr_trim_uncached_memory - trim RAM not covered by MTRRs
  * @end_pfn: ending page frame number
@@ -1108,8 +1119,13 @@ int __init mtrr_trim_uncached_memory(uns
 {
 	unsigned long i, base, size, highest_pfn = 0, def, dummy;
 	mtrr_type type;
-	u64 trim_start, trim_size;
+	struct res_range range[RANGE_NUM];
+	int nr_range;
+	u64 total_real_trim_size;
+	int changed;
 
+	/* extra one for all 0 */
+	int num[MTRR_NUM_TYPES + 1];
 	/*
 	 * Make sure we only trim uncachable memory on machines that
 	 * support the Intel MTRR architecture:
@@ -1121,9 +1137,6 @@ int __init mtrr_trim_uncached_memory(uns
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
 
-	if (amd_special_default_mtrr())
-		return 0;
-
 	/* Find highest cached pfn */
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i, &base, &size, &type);
@@ -1143,26 +1156,80 @@ int __init mtrr_trim_uncached_memory(uns
 		return 0;
 	}
 
-	if (highest_pfn < end_pfn) {
+	/* check entries number */
+	memset(num, 0, sizeof(num));
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type >= MTRR_NUM_TYPES)
+			continue;
+		if (!size)
+			type = MTRR_NUM_TYPES;
+		num[type]++;
+	}
+
+	/* no entry for WB? */
+	if (!num[MTRR_TYPE_WRBACK])
+		return 0;
+
+	/* check if we only had WB and UC */
+	if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
+		num_var_ranges - num[MTRR_NUM_TYPES])
+		return 0;
+
+	memset(range, 0, sizeof(range));
+	nr_range = 0;
+	if (mtrr_tom2) {
+		range[nr_range].start = (1ULL<<(32 - PAGE_SHIFT));
+		range[nr_range].end = (mtrr_tom2 >> PAGE_SHIFT) - 1;
+		if (highest_pfn < range[nr_range].end + 1)
+			highest_pfn = range[nr_range].end + 1;
+		nr_range++;
+	}
+	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
+
+	changed = 0;
+	total_real_trim_size = 0;
+
+	/* check the top at first */
+	i = nr_range - 1;
+	if (range[i].end + 1 < end_pfn) {
+			total_real_trim_size += real_trim_memory(range[i].end + 1, end_pfn);
+	}
+
+	if (total_real_trim_size) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
-			" all of memory, losing %luMB of RAM.\n",
-			(end_pfn - highest_pfn) >> (20 - PAGE_SHIFT));
+			" all of memory, losing %lluMB of RAM.\n",
+			total_real_trim_size >> 20);
 
 		WARN_ON(1);
 
-		printk(KERN_INFO "update e820 for mtrr\n");
-		trim_start = highest_pfn;
-		trim_start <<= PAGE_SHIFT;
-		trim_size = end_pfn;
-		trim_size <<= PAGE_SHIFT;
-		trim_size -= trim_start;
-		update_memory_range(trim_start, trim_size, E820_RAM,
-					E820_RESERVED);
+		printk(KERN_INFO "update e820 for mtrr -- end_pfn\n");
 		update_e820();
-		return 1;
+		changed = 1;
 	}
 
-	return 0;
+	total_real_trim_size = 0;
+	if (range[0].start)
+		total_real_trim_size += real_trim_memory(0, range[0].start);
+
+	for (i = 0; i < nr_range - 1; i--) {
+		if (range[i].end + 1 < range[i+1].start)
+			total_real_trim_size += real_trim_memory(range[i].end + 1, range[i+1].start);
+	}
+
+	if (total_real_trim_size) {
+		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
+			" all of memory, losing %lluMB of RAM.\n",
+			total_real_trim_size >> 20);
+
+		WARN_ON(1);
+
+		printk(KERN_INFO "update e820 for mtrr -- holes\n");
+		update_e820();
+		changed = 1;
+	}
+
+	return changed;
 }
 
 /**
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -736,10 +736,11 @@ static int __init parse_memmap(char *arg
 	return 0;
 }
 early_param("memmap", parse_memmap);
-void __init update_memory_range(u64 start, u64 size, unsigned old_type,
+u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type)
 {
 	int i;
+	u64 real_updated_size = 0;
 
 	BUG_ON(old_type == new_type);
 
@@ -751,6 +752,7 @@ void __init update_memory_range(u64 star
 		/* totally covered? */
 		if (ei->addr >= start && ei->size <= size) {
 			ei->type = new_type;
+			real_updated_size += ei->size;
 			continue;
 		}
 		/* partially covered */
@@ -760,7 +762,10 @@ void __init update_memory_range(u64 star
 			continue;
 		add_memory_region(final_start, final_end - final_start,
 					 new_type);
+		real_updated_size += find_end - final_start;
 	}
+
+	return real_update_size;
 }
 void __init update_e820(void)
 {
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -829,10 +829,11 @@ void __init finish_e820_parsing(void)
 	}
 }
 
-void __init update_memory_range(u64 start, u64 size, unsigned old_type,
+u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type)
 {
 	int i;
+	u64 real_updated_size = 0;
 
 	BUG_ON(old_type == new_type);
 
@@ -844,6 +845,7 @@ void __init update_memory_range(u64 star
 		/* totally covered? */
 		if (ei->addr >= start && ei->size <= size) {
 			ei->type = new_type;
+			real_updated_size += ei->size;
 			continue;
 		}
 		/* partially covered */
@@ -853,7 +855,9 @@ void __init update_memory_range(u64 star
 			continue;
 		add_memory_region(final_start, final_end - final_start,
 					 new_type);
+		real_updated_size += final_end - final_start;
 	}
+	return real_updated_size;
 }
 
 void __init update_e820(void)
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -28,7 +28,7 @@ extern void propagate_e820_map(void);
 extern void register_bootmem_low_pages(unsigned long max_low_pfn);
 extern void add_memory_region(unsigned long long start,
 			      unsigned long long size, int type);
-extern void update_memory_range(u64 start, u64 size, unsigned old_type,
+extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -21,7 +21,7 @@ extern unsigned long find_e820_area_size
 					 unsigned long align);
 extern void add_memory_region(unsigned long start, unsigned long size,
 			      int type);
-extern void update_memory_range(u64 start, u64 size, unsigned old_type,
+extern u64 update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
