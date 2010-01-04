Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174Ab0ADDHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0ADDHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846Ab0ADDHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:07:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65078 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0ADDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/29] x86: introduce max_early_res and early_res_count
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to prepare allocate early res array from fine_e820_area

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a1a7876..291f6d2 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -724,14 +724,18 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * Early reserved memory areas.
  */
-#define MAX_EARLY_RES 32
+/*
+ * need to make sure this one is bigger enough before
+ * find_e820_area could be used
+ */
+#define MAX_EARLY_RES_X 32
 
 struct early_res {
 	u64 start, end;
-	char name[16];
+	char name[15];
 	char overlap_ok;
 };
-static struct early_res early_res[MAX_EARLY_RES] __initdata = {
+static struct early_res early_res_x[MAX_EARLY_RES_X] __initdata = {
 	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
 #if defined(CONFIG_X86_32) && defined(CONFIG_X86_TRAMPOLINE)
 	/*
@@ -745,12 +749,22 @@ static struct early_res early_res[MAX_EARLY_RES] __initdata = {
 	{}
 };
 
+static int max_early_res __initdata = MAX_EARLY_RES_X;
+static struct early_res *early_res __initdata = &early_res_x[0];
+static int early_res_count __initdata =
+#ifdef CONFIG_X86_32
+	2
+#else
+	1
+#endif
+	;
+
 static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
 	struct early_res *r;
 
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
 		r = &early_res[i];
 		if (end > r->start && start < r->end)
 			break;
@@ -768,13 +782,14 @@ static void __init drop_range(int i)
 {
 	int j;
 
-	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
+	for (j = i + 1; j < max_early_res && early_res[j].end; j++)
 		;
 
 	memmove(&early_res[i], &early_res[i + 1],
 	       (j - 1 - i) * sizeof(struct early_res));
 
 	early_res[j - 1].end = 0;
+	early_res_count--;
 }
 
 /*
@@ -793,9 +808,9 @@ static void __init drop_overlaps_that_are_ok(u64 start, u64 end)
 	struct early_res *r;
 	u64 lower_start, lower_end;
 	u64 upper_start, upper_end;
-	char name[16];
+	char name[15];
 
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
 		r = &early_res[i];
 
 		/* Continue past non-overlapping ranges */
@@ -851,7 +866,7 @@ static void __init __reserve_early(u64 start, u64 end, char *name,
 	struct early_res *r;
 
 	i = find_overlapped_early(start, end);
-	if (i >= MAX_EARLY_RES)
+	if (i >= max_early_res)
 		panic("Too many early reservations");
 	r = &early_res[i];
 	if (r->end)
@@ -864,6 +879,7 @@ static void __init __reserve_early(u64 start, u64 end, char *name,
 	r->overlap_ok = overlap_ok;
 	if (name)
 		strncpy(r->name, name, sizeof(r->name) - 1);
+	early_res_count++;
 }
 
 /*
@@ -916,7 +932,7 @@ void __init free_early(u64 start, u64 end)
 
 	i = find_overlapped_early(start, end);
 	r = &early_res[i];
-	if (i >= MAX_EARLY_RES || r->end != end || r->start != start)
+	if (i >= max_early_res || r->end != end || r->start != start)
 		panic("free_early on not reserved area: %llx-%llx!",
 			 start, end - 1);
 
@@ -927,14 +943,15 @@ void __init early_res_to_bootmem(u64 start, u64 end)
 {
 	int i, count;
 	u64 final_start, final_end;
+	int idx = 0;
 
 	count  = 0;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++)
+	for (i = 0; i < max_early_res && early_res[i].end; i++)
 		count++;
 
-	printk(KERN_INFO "(%d early reservations) ==> bootmem [%010llx - %010llx]\n",
-			 count, start, end);
-	for (i = 0; i < count; i++) {
+	printk(KERN_INFO "(%d/%d early reservations) ==> bootmem [%010llx - %010llx]\n",
+			 count - idx, max_early_res, start, end);
+	for (i = idx; i < count; i++) {
 		struct early_res *r = &early_res[i];
 		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
 			r->start, r->end, r->name);
@@ -961,7 +978,7 @@ static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
 again:
 	i = find_overlapped_early(addr, addr + size);
 	r = &early_res[i];
-	if (i < MAX_EARLY_RES && r->end) {
+	if (i < max_early_res && r->end) {
 		*addrp = addr = round_up(r->end, align);
 		changed = 1;
 		goto again;
@@ -978,7 +995,7 @@ static inline int __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
 	int changed = 0;
 again:
 	last = addr + size;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+	for (i = 0; i < max_early_res && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
 		if (last > r->start && addr < r->start) {
 			size = r->start - addr;
-- 
1.6.4.2

