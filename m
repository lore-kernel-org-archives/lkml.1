Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZLOCJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZLOCJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbZLOCJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:09:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:48101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318AbZLOCJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:09:27 -0500
Message-ID: <4B26EF84.4020903@kernel.org>
Date: Mon, 14 Dec 2009 18:08:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: dynamic increase early_res array size
References: <4B22D4DA.2000104@kernel.org> <4B22D754.2020706@kernel.org> <4B26EF1B.5090706@kernel.org> <4B26EF49.6010306@kernel.org>
In-Reply-To: <4B26EF49.6010306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



use early_res_count to track the num, and use find_e820 to get new buffer.
and copy from old to new one.

also clear early_res to prevent later invalid using

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -908,6 +908,49 @@ void __init reserve_early_overlap_ok(u64
 	__reserve_early(start, end, name, 1);
 }
 
+static void __init __check_and_double_early_res(void)
+{
+	u64 size;
+	u64 mem;
+	struct early_res *new;
+
+	/* do we have enough slots left ? */
+	if ((max_early_res - early_res_count) > max(max_early_res/8, 2))
+		return;
+
+	/* double it */
+	size = sizeof(struct early_res) * max_early_res * 2;
+	mem = find_e820_area(0, max_pfn_mapped << PAGE_SHIFT, size,
+		 sizeof(struct early_res));
+
+	if (mem == -1ULL)
+		panic("can not find more space for early_res array");
+
+	new = __va(mem);
+	/* save the first one for own */
+	new[0].start = mem;
+	new[0].end = mem + size;
+	new[0].overlap_ok = 0;
+	/* copy old to new */
+	if (early_res == early_res_x) {
+		memcpy(&new[1], &early_res[0],
+			 sizeof(struct early_res) * max_early_res);
+		memset(&new[max_early_res+1], 0,
+			 sizeof(struct early_res) * (max_early_res - 1));
+		early_res_count++;
+	} else {
+		memcpy(&new[1], &early_res[1],
+			 sizeof(struct early_res) * (max_early_res - 1));
+		memset(&new[max_early_res], 0,
+			 sizeof(struct early_res) * max_early_res);
+	}
+	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
+	early_res = new;
+	max_early_res *= 2;
+	printk(KERN_DEBUG "early_res array is doubled to %d at [%llx - %llx]\n",
+		max_early_res, mem, mem + size - 1);
+}
+
 /*
  * Most early reservations come here.
  *
@@ -921,6 +964,8 @@ void __init reserve_early(u64 start, u64
 	if (start >= end)
 		return;
 
+	__check_and_double_early_res();
+
 	drop_overlaps_that_are_ok(start, end);
 	__reserve_early(start, end, name, 0);
 }
@@ -949,6 +994,10 @@ void __init early_res_to_bootmem(u64 sta
 	for (i = 0; i < max_early_res && early_res[i].end; i++)
 		count++;
 
+	/* need to skip first one ?*/
+	if (early_res != early_res_x)
+		idx = 1;
+
 	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
 			 count - idx, max_early_res, start, end);
 	for (i = idx; i < count; i++) {
@@ -966,6 +1015,11 @@ void __init early_res_to_bootmem(u64 sta
 		reserve_bootmem_generic(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);
 	}
+	/* clear them */
+	memset(&early_res[0], 0, sizeof(struct early_res) * max_early_res);
+	early_res = NULL;
+	max_early_res = 0;
+	early_res_count = 0;
 }
 
 /* Check for already reserved areas */
