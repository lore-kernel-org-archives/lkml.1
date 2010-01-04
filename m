Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224Ab0ADDHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0ADDHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145Ab0ADDHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:07:32 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65084 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0ADDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/29] x86: dynamic increase early_res array size
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use early_res_count to track the num, and use find_e820 to get new buffer.
and copy from old to new one.

also clear early_res to prevent later invalid using

-v2 _check_and_double_early_res should take new start

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 291f6d2..949d688 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -908,6 +908,48 @@ void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
 	__reserve_early(start, end, name, 1);
 }
 
+static void __init __check_and_double_early_res(u64 start)
+{
+	u64 end, size, mem;
+	struct early_res *new;
+
+	/* do we have enough slots left ? */
+	if ((max_early_res - early_res_count) > max(max_early_res/8, 2))
+		return;
+
+	/* double it */
+	end = max_pfn_mapped << PAGE_SHIFT;
+	size = sizeof(struct early_res) * max_early_res * 2;
+	mem = find_e820_area(start, end, size, sizeof(struct early_res));
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
@@ -921,6 +963,8 @@ void __init reserve_early(u64 start, u64 end, char *name)
 	if (start >= end)
 		return;
 
+	__check_and_double_early_res(end);
+
 	drop_overlaps_that_are_ok(start, end);
 	__reserve_early(start, end, name, 0);
 }
@@ -949,6 +993,10 @@ void __init early_res_to_bootmem(u64 start, u64 end)
 	for (i = 0; i < max_early_res && early_res[i].end; i++)
 		count++;
 
+	/* need to skip first one ?*/
+	if (early_res != early_res_x)
+		idx = 1;
+
 	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
 			 count - idx, max_early_res, start, end);
 	for (i = idx; i < count; i++) {
@@ -966,6 +1014,11 @@ void __init early_res_to_bootmem(u64 start, u64 end)
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
-- 
1.6.4.2

