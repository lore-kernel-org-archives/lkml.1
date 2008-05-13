Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYEMAm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYEMAm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbYEMAl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:41:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756015AbYEMAl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:41:58 -0400
Date: Mon, 12 May 2008 17:41:52 -0700 (PDT)
Message-Id: <20080512.174152.123760440.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org, paulus@samba.org, mikpe@it.uu.se
Subject: [PATCH 1/2]: lmb: Fix inconsistent alignment of size argument.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When allocating, if we will align up the size when making
the reservation, we should also align the size for the
check that the space is actually available.

The simplest thing is to just aling the size up from
the beginning, then we can use plain 'size' throughout.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 lib/lmb.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 83287d3..93445dc 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -286,8 +286,7 @@ static u64 __init lmb_alloc_nid_unreserved(u64 start, u64 end,
 		j = lmb_overlaps_region(&lmb.reserved, base, size);
 		if (j < 0) {
 			/* this area isn't reserved, take it */
-			if (lmb_add_region(&lmb.reserved, base,
-					   lmb_align_up(size, align)) < 0)
+			if (lmb_add_region(&lmb.reserved, base, size) < 0)
 				base = ~(u64)0;
 			return base;
 		}
@@ -333,6 +332,10 @@ u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
 	struct lmb_region *mem = &lmb.memory;
 	int i;
 
+	BUG_ON(0 == size);
+
+	size = lmb_align_up(size, align);
+
 	for (i = 0; i < mem->cnt; i++) {
 		u64 ret = lmb_alloc_nid_region(&mem->region[i],
 					       nid_range,
@@ -370,6 +373,8 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 
 	BUG_ON(0 == size);
 
+	size = lmb_align_up(size, align);
+
 	/* On some platforms, make sure we allocate lowmem */
 	/* Note that LMB_REAL_LIMIT may be LMB_ALLOC_ANYWHERE */
 	if (max_addr == LMB_ALLOC_ANYWHERE)
@@ -393,8 +398,7 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 			j = lmb_overlaps_region(&lmb.reserved, base, size);
 			if (j < 0) {
 				/* this area isn't reserved, take it */
-				if (lmb_add_region(&lmb.reserved, base,
-						   lmb_align_up(size, align)) < 0)
+				if (lmb_add_region(&lmb.reserved, base, size) < 0)
 					return 0;
 				return base;
 			}
-- 
1.5.5.1.57.g5909c

