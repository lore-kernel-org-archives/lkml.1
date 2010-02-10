Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0BJJY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:24:56 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60095 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0BJJWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:22:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/35] early_res: enhance check_and_double_early_res
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make it always try to start from low at first.

so make it more safe for early_memtest to reserve bad range.
aka put new early_res to range that is already tested.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/early_res.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/early_res.c b/arch/x86/kernel/early_res.c
index d0a70cc..52804e9 100644
--- a/arch/x86/kernel/early_res.c
+++ b/arch/x86/kernel/early_res.c
@@ -180,9 +180,9 @@ void __init reserve_early_overlap_ok(u64 start, u64 end, char *name)
 	__reserve_early(start, end, name, 1);
 }
 
-static void __init __check_and_double_early_res(u64 start)
+static void __init __check_and_double_early_res(u64 ex_start, u64 ex_end)
 {
-	u64 end, size, mem;
+	u64 start, end, size, mem;
 	struct early_res *new;
 
 	/* do we have enough slots left ? */
@@ -190,10 +190,23 @@ static void __init __check_and_double_early_res(u64 start)
 		return;
 
 	/* double it */
-	end = max_pfn_mapped << PAGE_SHIFT;
+	mem = -1ULL;
 	size = sizeof(struct early_res) * max_early_res * 2;
-	mem = find_e820_area(start, end, size, sizeof(struct early_res));
-
+	if (early_res == early_res_x)
+		start = 0;
+	else
+		start = early_res[0].end;
+	end = ex_start;
+	if (start + size < end)
+		mem = find_e820_area(start, end, size,
+					 sizeof(struct early_res));
+	if (mem == -1ULL) {
+		start = ex_end;
+		end = max_pfn_mapped << PAGE_SHIFT;
+		if (start + size < end)
+			mem = find_e820_area(start, end, size,
+						 sizeof(struct early_res));
+	}
 	if (mem == -1ULL)
 		panic("can not find more space for early_res array");
 
@@ -235,7 +248,7 @@ void __init reserve_early(u64 start, u64 end, char *name)
 	if (start >= end)
 		return;
 
-	__check_and_double_early_res(end);
+	__check_and_double_early_res(start, end);
 
 	drop_overlaps_that_are_ok(start, end);
 	__reserve_early(start, end, name, 0);
@@ -248,7 +261,7 @@ void __init reserve_early_without_check(u64 start, u64 end, char *name)
 	if (start >= end)
 		return;
 
-	__check_and_double_early_res(end);
+	__check_and_double_early_res(start, end);
 
 	r = &early_res[early_res_count];
 
-- 
1.6.4.2

