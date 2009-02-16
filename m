Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZBPOEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZBPOEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbZBPODx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:03:53 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:40161 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbZBPODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:03:53 -0500
X-Greylist: delayed 3887 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 09:03:51 EST
From: Benny Halevy <bhalevy@panasas.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>
Subject: [PATCH] bitmap: Cleanup find_last_bit
Date: Mon, 16 Feb 2009 14:58:40 +0200
Message-Id: <1234789120-31543-1-git-send-email-bhalevy@panasas.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <200812011848.31552.rusty@rustcorp.com.au>
References: <200812011848.31552.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cut & paste error in header comment.
Simplify implementation a bit.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---

Rusty, we're using a similar mechanism for finding the highest slot ID
in use in the nfsv4.1 slot table and I'm going to moev it over to
using find_last_bit in our 2.6.29 patchset.
While going over your implementation I noticed a tiny cut & paste error in
bitops.h and I'd also like to propose a couple simplifications to make
the implementation a bit more readable (at least to me :).

Benny

 include/linux/bitops.h |    2 +-
 lib/find_last_bit.c    |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 6182913..886ebf0 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -142,7 +142,7 @@ extern unsigned long find_first_zero_bit(const unsigned long *addr,
  * @addr: The address to start the search at
  * @size: The maximum size to search
  *
- * Returns the bit number of the first set bit, or size.
+ * Returns the bit number of the last set bit, or size.
  */
 extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
diff --git a/lib/find_last_bit.c b/lib/find_last_bit.c
index 5d202e3..e9d9cdc 100644
--- a/lib/find_last_bit.c
+++ b/lib/find_last_bit.c
@@ -24,22 +24,23 @@ unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
 	words = size / BITS_PER_LONG;
 
 	/* Partial final word? */
-	if (size & (BITS_PER_LONG-1)) {
-		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
-					 - (size & (BITS_PER_LONG-1)))));
+	tmp = size & (BITS_PER_LONG-1);
+	if (tmp) {
+		tmp = addr[words] & (~0UL >> (BITS_PER_LONG - tmp));
 		if (tmp)
 			goto found;
 	}
 
 	while (words) {
 		tmp = addr[--words];
-		if (tmp) {
-found:
-			return words * BITS_PER_LONG + __fls(tmp);
-		}
+		if (tmp)
+			goto found;
 	}
 
 	/* Not found */
 	return size;
+
+found:
+	return words * BITS_PER_LONG + __fls(tmp);
 }
 EXPORT_SYMBOL(find_last_bit);
-- 
1.6.1.3

