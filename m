Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYFBGZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYFBGZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYFBGYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:24:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:33215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYFBGYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:24:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="389289981"
Subject: [PATCH 1/5] x86_64 boot: find_overlapped_early
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jun 2008 14:26:14 +0800
Message-Id: <1212387974.301.26.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 02 Jun 2008 06:24:26.0869 (UTC) FILETIME=[4E976250:01C8C479]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clean up reserve_early() family functions by extracting the
common part of reserve_early(), free_early() and bad_addr() into
find_overlapped_early().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820.c |   50 +++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -558,20 +558,34 @@ static struct early_res early_res[MAX_EA
 	{}
 };
 
-void __init reserve_early(u64 start, u64 end, char *name)
+static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
 	struct early_res *r;
+
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		r = &early_res[i];
 		if (end > r->start && start < r->end)
-			panic("Overlapping early reservations %llx-%llx %s to %llx-%llx %s\n",
-			      start, end - 1, name?name:"", r->start,
-			      r->end - 1, r->name);
+			break;
 	}
+
+	return i;
+}
+
+void __init reserve_early(u64 start, u64 end, char *name)
+{
+	int i;
+	struct early_res *r;
+
+	i = find_overlapped_early(start, end);
 	if (i >= MAX_EARLY_RES)
 		panic("Too many early reservations");
 	r = &early_res[i];
+	if (r->end)
+		panic("Overlapping early reservations "
+		      "%llx-%llx %s to %llx-%llx %s\n",
+		      start, end - 1, name?name:"", r->start,
+		      r->end - 1, r->name);
 	r->start = start;
 	r->end = end;
 	if (name)
@@ -583,14 +597,11 @@ void __init free_early(u64 start, u64 en
 	struct early_res *r;
 	int i, j;
 
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		r = &early_res[i];
-		if (start == r->start && end == r->end)
-			break;
-	}
-	if (i >= MAX_EARLY_RES || !early_res[i].end)
+	i = find_overlapped_early(start, end);
+	r = &early_res[i];
+	if (i >= MAX_EARLY_RES || r->end != end || r->start != start)
 		panic("free_early on not reserved area: %llx-%llx!",
-			 start, end);
+			 start, end - 1);
 
 	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
 		;
@@ -626,17 +637,16 @@ void __init early_res_to_bootmem(u64 sta
 static inline int __init bad_addr(u64 *addrp, u64 size, u64 align)
 {
 	int i;
-	u64 addr = *addrp, last;
+	u64 addr = *addrp;
 	int changed = 0;
+	struct early_res *r;
 again:
-	last = addr + size;
-	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
-		struct early_res *r = &early_res[i];
-		if (last >= r->start && addr < r->end) {
-			*addrp = addr = round_up(r->end, align);
-			changed = 1;
-			goto again;
-		}
+	i = find_overlapped_early(addr, addr + size);
+	r = &early_res[i];
+	if (i < MAX_EARLY_RES && r->end) {
+		*addrp = addr = round_up(r->end, align);
+		changed = 1;
+		goto again;
 	}
 	return changed;
 }

