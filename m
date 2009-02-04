Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZBDAlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZBDAlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZBDAlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:41:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42667 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbZBDAlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:41:02 -0500
Date: Tue, 3 Feb 2009 18:40:59 -0600
From: Robin Holt <holt@sgi.com>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: [Patch] bte_copy of BTE_MAX_XFER trips BUG_ON.
Message-ID: <20090204004059.GM8559@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTE_MAX_XFER is wrong.  It is one greater than the number of cache
lines the BTE is actually able to transfer.  If you request a transfer
of exactly BTE_MAX_XFER size, you trip a very cryptic BUG_ON() which
should certainly be made more clear.

This patch fixes that constant and also cleans up the BUG_ON()s in
arch/ia64/sn/kernel/bte.c to test one condition per line.

Signed-off-by: Robin Holt <holt@sgi.com>

---

 arch/ia64/include/asm/sn/bte.h |    2 +-
 arch/ia64/sn/kernel/bte.c      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: bte_max_xfer_fix/arch/ia64/include/asm/sn/bte.h
===================================================================
--- bte_max_xfer_fix.orig/arch/ia64/include/asm/sn/bte.h	2009-02-03 18:07:26.000000000 -0600
+++ bte_max_xfer_fix/arch/ia64/include/asm/sn/bte.h	2009-02-03 18:09:38.749729353 -0600
@@ -39,7 +39,7 @@
 /* BTE status register only supports 16 bits for length field */
 #define BTE_LEN_BITS (16)
 #define BTE_LEN_MASK ((1 << BTE_LEN_BITS) - 1)
-#define BTE_MAX_XFER ((1 << BTE_LEN_BITS) * L1_CACHE_BYTES)
+#define BTE_MAX_XFER (BTE_LEN_MASK << L1_CACHE_SHIFT)
 
 
 /* Define hardware */
Index: bte_max_xfer_fix/arch/ia64/sn/kernel/bte.c
===================================================================
--- bte_max_xfer_fix.orig/arch/ia64/sn/kernel/bte.c	2009-02-03 18:07:26.000000000 -0600
+++ bte_max_xfer_fix/arch/ia64/sn/kernel/bte.c	2009-02-03 18:15:42.854040475 -0600
@@ -97,9 +97,10 @@ bte_result_t bte_copy(u64 src, u64 dest,
 		return BTE_SUCCESS;
 	}
 
-	BUG_ON((len & L1_CACHE_MASK) ||
-		 (src & L1_CACHE_MASK) || (dest & L1_CACHE_MASK));
-	BUG_ON(!(len < ((BTE_LEN_MASK + 1) << L1_CACHE_SHIFT)));
+	BUG_ON(len & L1_CACHE_MASK);
+	BUG_ON(src & L1_CACHE_MASK);
+	BUG_ON(dest & L1_CACHE_MASK);
+	BUG_ON(len > BTE_MAX_XFER);
 
 	/*
 	 * Start with interface corresponding to cpu number
