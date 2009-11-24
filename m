Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbZKXWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbZKXWTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZKXWTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:19:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:39245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbZKXWTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:19:16 -0500
Date: Tue, 24 Nov 2009 22:18:57 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <4B0BB9A3.5020908@kernel.org>
References: <4B0BB9A3.5020908@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mtrr: Fix sorting of mtrr after subtracting
Message-ID: <tip-5bf65b9ba67226eae9ffc398a0369fc4da35c259@git.kernel.org>
Git-Commit-ID: 5bf65b9ba67226eae9ffc398a0369fc4da35c259
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bf65b9ba67226eae9ffc398a0369fc4da35c259
Gitweb:     http://git.kernel.org/tip/5bf65b9ba67226eae9ffc398a0369fc4da35c259
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 24 Nov 2009 02:46:59 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 24 Nov 2009 13:06:16 -0800

x86, mtrr: Fix sorting of mtrr after subtracting

In some cases we can coalesce MTRR entries after cleanup; this may
allow us to have more entries.  As such, introduce clean_sort_range to
to sort and coaelsce the MTRR entries.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B0BB9A3.5020908@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   49 +++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 6e49f6f..6987af7 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -170,6 +170,41 @@ static int __init cmp_range(const void *x1, const void *x2)
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
 
@@ -223,22 +258,18 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
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
