Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYFVOXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYFVOXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbYFVOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:22:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34856 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755372AbYFVOWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:22:08 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 22 Jun 2008 07:22:07 -0700
Message-Id: <20080622142207.5591.68851.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 3/5 v2] x86 boot: allow overlapping early reserve memory ranges
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Add support for overlapping early memory reservations.

In general, they still can't overlap, and will panic
with "Overlapping early reservations" if they do overlap.

But if a memory range is reserved with the new call:
    reserve_early_overlap_ok()
rather than with the usual call:
    reserve_early()
then subsequent early reservations are allowed to overlap.

This new reserve_early_overlap_ok() call is only used in one
place so far, which is the "BIOS reserved" reservation for the
the EBDA region, which out of Paranoia reserves more than what
the BIOS might have specified, and which thus might overlap with
another legitimate early memory reservation (such as, perhaps,
the EFI memmap.)

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820.c |  140 +++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/head.c |    2 
 include/asm-x86/e820.h |    1 
 3 files changed, 133 insertions(+), 10 deletions(-)

--- linux-next.orig/arch/x86/kernel/e820.c	2008-06-22 06:36:04.391767162 -0700
+++ linux-next/arch/x86/kernel/e820.c	2008-06-22 06:36:07.203937695 -0700
@@ -536,6 +536,7 @@ void __init e820_mark_nosave_regions(uns
 struct early_res {
 	u64 start, end;
 	char name[16];
+	char overlap_ok;
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page" },	/* BIOS data page */
@@ -572,7 +573,93 @@ static int __init find_overlapped_early(
 	return i;
 }
 
-void __init reserve_early(u64 start, u64 end, char *name)
+/*
+ * Drop the i-th range from the early reservation map,
+ * by copying any higher ranges down one over it, and
+ * clearing what had been the last slot.
+ */
+static void __init drop_range(int i)
+{
+	int j;
+
+	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
+		;
+
+	memmove(&early_res[i], &early_res[i + 1],
+	       (j - 1 - i) * sizeof(struct early_res));
+
+	early_res[j - 1].end = 0;
+}
+
+/*
+ * Split any existing ranges that:
+ *  1) are marked 'overlap_ok', and
+ *  2) overlap with the stated range [start, end)
+ * into whatever portion (if any) of the existing range is entirely
+ * below or entirely above the stated range.  Drop the portion
+ * of the existing range that overlaps with the stated range,
+ * which will allow the caller of this routine to then add that
+ * stated range without conflicting with any existing range.
+ */
+static void __init drop_overlaps_that_are_ok(u64 start, u64 end)
+{
+	int i;
+	struct early_res *r;
+	u64 lower_start, lower_end;
+	u64 upper_start, upper_end;
+	char name[16];
+
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+
+		/* Continue past non-overlapping ranges */
+		if (end <= r->start || start >= r->end)
+			continue;
+
+		/*
+		 * Leave non-ok overlaps as is; let caller
+		 * panic "Overlapping early reservations"
+		 * when it hits this overlap.
+		 */
+		if (!r->overlap_ok)
+			return;
+
+		/*
+		 * We have an ok overlap.  We will drop it from the early
+		 * reservation map, and add back in any non-overlapping
+		 * portions (lower or upper) as separate, overlap_ok,
+		 * non-overlapping ranges.
+		 */
+
+		/* 1. Note any non-overlapping (lower or upper) ranges. */
+		strncpy(name, r->name, sizeof(name) - 1);
+
+		lower_start = lower_end = 0;
+		upper_start = upper_end = 0;
+		if (r->start < start) {
+		 	lower_start = r->start;
+			lower_end = start;
+		}
+		if (r->end > end) {
+			upper_start = end;
+			upper_end = r->end;
+		}
+
+		/* 2. Drop the original ok overlapping range */
+		drop_range(i);
+
+		i--;		/* resume for-loop on copied down entry */
+
+		/* 3. Add back in any non-overlapping ranges. */
+		if (lower_end)
+			reserve_early_overlap_ok(lower_start, lower_end, name);
+		if (upper_end)
+			reserve_early_overlap_ok(upper_start, upper_end, name);
+	}
+}
+
+static void __init __reserve_early(u64 start, u64 end, char *name,
+						int overlap_ok)
 {
 	int i;
 	struct early_res *r;
@@ -588,14 +675,55 @@ void __init reserve_early(u64 start, u64
 		      r->end - 1, r->name);
 	r->start = start;
 	r->end = end;
+	r->overlap_ok = overlap_ok;
 	if (name)
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
+/*
+ * A few early reservtations come here.
+ *
+ * The 'overlap_ok' in the name of this routine does -not- mean it
+ * is ok for these reservations to overlap an earlier reservation.
+ * Rather it means that it is ok for subsequent reservations to
+ * overlap this one.
+ *
+ * Use this entry point to reserve early ranges when you are doing
+ * so out of "Paranoia", reserving perhaps more memory than you need,
+ * just in case, and don't mind a subsequent overlapping reservation
+ * that is known to be needed.
+ *
+ * The drop_overlaps_that_are_ok() call here isn't really needed.
+ * It would be needed if we had two colliding 'overlap_ok'
+ * reservations, so that the second such would not panic on the
+ * overlap with the first.  We don't have any such as of this
+ * writing, but might as well tolerate such if it happens in
+ * the future.
+ */
+void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
+{
+	drop_overlaps_that_are_ok(start, end);
+	__reserve_early(start, end, name, 1);
+}
+
+/*
+ * Most early reservations come here.
+ *
+ * We first have drop_overlaps_that_are_ok() drop any pre-existing
+ * 'overlap_ok' ranges, so that we can then reserve this memory
+ * range without risk of panic'ing on an overlapping overlap_ok
+ * early reservation.
+ */
+void __init reserve_early(u64 start, u64 end, char *name)
+{
+	drop_overlaps_that_are_ok(start, end);
+	__reserve_early(start, end, name, 0);
+}
+
 void __init free_early(u64 start, u64 end)
 {
 	struct early_res *r;
-	int i, j;
+	int i;
 
 	i = find_overlapped_early(start, end);
 	r = &early_res[i];
@@ -603,13 +731,7 @@ void __init free_early(u64 start, u64 en
 		panic("free_early on not reserved area: %llx-%llx!",
 			 start, end - 1);
 
-	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
-		;
-
-	memmove(&early_res[i], &early_res[i + 1],
-	       (j - 1 - i) * sizeof(struct early_res));
-
-	early_res[j - 1].end = 0;
+	drop_range(i);
 }
 
 void __init early_res_to_bootmem(u64 start, u64 end)
--- linux-next.orig/arch/x86/kernel/head.c	2008-06-22 06:35:50.286911826 -0700
+++ linux-next/arch/x86/kernel/head.c	2008-06-22 06:36:07.215938422 -0700
@@ -51,7 +51,7 @@ void __init reserve_ebda_region(void)
 		lowmem = 0x9f000;
 
 	/* reserve all memory between lowmem and the 1MB mark */
-	reserve_early(lowmem, 0x100000, "BIOS reserved");
+	reserve_early_overlap_ok(lowmem, 0x100000, "BIOS reserved");
 }
 
 void __init reserve_setup_data(void)
--- linux-next.orig/include/asm-x86/e820.h	2008-06-22 06:35:53.227090122 -0700
+++ linux-next/include/asm-x86/e820.h	2008-06-22 06:36:07.231939393 -0700
@@ -84,6 +84,7 @@ extern unsigned long end_user_pfn;
 extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
 extern void reserve_early(u64 start, u64 end, char *name);
+extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
