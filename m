Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbZKXKsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbZKXKsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZKXKsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:48:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:48463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbZKXKsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:48:03 -0500
Message-ID: <4B0BB9A3.5020908@kernel.org>
Date: Tue, 24 Nov 2009 02:46:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix sorting of mtrr after subtracting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some case: after subracting, could have more entries

also when we got bland entries in middles, we need compress them before sorting.

introducing clean_sort_range to to compress and sort

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   49 ++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -170,6 +170,41 @@ static int __init cmp_range(const void *
 	return start1 - start2;
 }
 
+static int __init clean_sort_range(struct res_range *range, int az)
+{
+	int i, j, k = az - 1, nr_range = 0;
+
+	for (i = 0; i < k; i++) {
+		if (range[i].end)
+			continue;
+		for (j = k; j > i; j--) {
+			if (range[j].end) {
+				k = j;
+				break;
+			}
+		}
+		if (j == i)
+			break;
+		range[i].start = range[k].start;
+		range[i].end   = range[k].end;
+		range[k].start = 0;
+		range[k].end   = 0;
+		k--;
+	}
+	/* count it */
+	for (i = 0; i < az; i++) {
+		if (!range[i].end) {
+			nr_range = i;
+			break;
+		}
+	}
+
+	/* sort them */
+	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+
+	return nr_range;
+}
+
 #define BIOS_BUG_MSG KERN_WARNING \
 	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
@@ -223,22 +258,18 @@ x86_get_mtrr_mem_range(struct res_range
 		subtract_range(range, extra_remove_base,
 				 extra_remove_base + extra_remove_size  - 1);
 
-	/* get new range num */
-	nr_range = 0;
-	for (i = 0; i < RANGE_NUM; i++) {
-		if (!range[i].end)
-			continue;
-		nr_range++;
-	}
 	if  (debug_print) {
 		printk(KERN_DEBUG "After UC checking\n");
-		for (i = 0; i < nr_range; i++)
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
 			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
 				 range[i].start, range[i].end + 1);
+		}
 	}
 
 	/* sort the ranges */
-	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+	nr_range = clean_sort_range(range, RANGE_NUM);
 	if  (debug_print) {
 		printk(KERN_DEBUG "After sorting\n");
 		for (i = 0; i < nr_range; i++)
