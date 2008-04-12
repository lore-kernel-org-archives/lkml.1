Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYDLFWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYDLFWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 01:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbYDLFW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 01:22:27 -0400
Received: from ozlabs.org ([203.10.76.45]:48542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYDLFW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 01:22:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18432.18107.854417.50018@cargo.ozlabs.ibm.com>
Date: Sat, 12 Apr 2008 15:20:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: davem@davemloft.net
Subject: [LMB][2/2] Restructure allocation loops to avoid unsigned underflow
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential bug in __lmb_alloc_base where we subtract `size'
from the base address of a reserved region without checking whether
the subtraction could wrap around and produce a very large unsigned
value.  In fact it probably isn't possible to hit the bug in practice
since it would only occur in the situation where we can't satisfy the
allocation request and there is a reserved region starting at 0.

This fixes the potential bug by breaking out of the loop when we get
to the point where the base of the reserved region is less than the
size requested.  This also restructures the loop to be a bit easier to
follow. 

The same logic got copied into lmb_alloc_nid_unreserved, so this makes
a similar change there.  Here the bug is more likely to be hit because
the outer loop  (in lmb_alloc_nid) goes through the memory regions in
increasing order rather than decreasing order as __lmb_alloc_base
does, and we are therefore more likely to hit the case where we are
testing against a reserved region with a base address of 0.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/lib/lmb.c b/lib/lmb.c
index 265daf5..cabb942 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -230,20 +230,23 @@ static u64 lmb_align_up(u64 addr, u64 size)
 static u64 __init lmb_alloc_nid_unreserved(u64 start, u64 end,
 					   u64 size, u64 align)
 {
-	u64 base;
+	u64 base, res_base;
 	long j;
 
 	base = lmb_align_down((end - size), align);
-	while (start <= base &&
-	       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0))
-		base = lmb_align_down(lmb.reserved.region[j].base - size,
-				      align);
-
-	if (base != 0 && start <= base) {
-		if (lmb_add_region(&lmb.reserved, base,
-				   lmb_align_up(size, align)) < 0)
-			base = ~(u64)0;
-		return base;
+	while (start <= base) {
+		j = lmb_overlaps_region(&lmb.reserved, base, size);
+		if (j < 0) {
+			/* this area isn't reserved, take it */
+			if (lmb_add_region(&lmb.reserved, base,
+					   lmb_align_up(size, align)) < 0)
+				base = ~(u64)0;
+			return base;
+		}
+		res_base = lmb.reserved.region[j].base;
+		if (res_base < size)
+			break;
+		base = lmb_align_down(res_base - size, align);
 	}
 
 	return ~(u64)0;
@@ -315,10 +318,12 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
 	u64 base = 0;
+	u64 res_base;
 
 	BUG_ON(0 == size);
 
 	/* On some platforms, make sure we allocate lowmem */
+	/* Note that LMB_REAL_LIMIT may be LMB_ALLOC_ANYWHERE */
 	if (max_addr == LMB_ALLOC_ANYWHERE)
 		max_addr = LMB_REAL_LIMIT;
 
@@ -326,6 +331,8 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 		u64 lmbbase = lmb.memory.region[i].base;
 		u64 lmbsize = lmb.memory.region[i].size;
 
+		if (lmbsize < size)
+			continue;
 		if (max_addr == LMB_ALLOC_ANYWHERE)
 			base = lmb_align_down(lmbbase + lmbsize - size, align);
 		else if (lmbbase < max_addr) {
@@ -334,25 +341,22 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 		} else
 			continue;
 
-		while (lmbbase <= base) {
+		while (base && lmbbase <= base) {
 			j = lmb_overlaps_region(&lmb.reserved, base, size);
-			if (j < 0)
+			if (j < 0) {
+				/* this area isn't reserved, take it */
+				if (lmb_add_region(&lmb.reserved, base,
+						   size) < 0)
+					return 0;
+				return base;
+			}
+			res_base = lmb.reserved.region[j].base;
+			if (res_base < size)
 				break;
-			base = lmb_align_down(lmb.reserved.region[j].base - size,
-					      align);
+			base = lmb_align_down(res_base - size, align);
 		}
-
-		if ((base != 0) && (lmbbase <= base))
-			break;
 	}
-
-	if (i < 0)
-		return 0;
-
-	if (lmb_add_region(&lmb.reserved, base, lmb_align_up(size, align)) < 0)
-		return 0;
-
-	return base;
+	return 0;
 }
 
 /* You must call lmb_analyze() before this. */
