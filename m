Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZDWKWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZDWKWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZDWKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:22:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbZDWKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:22:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/3] bitops: Add __ffs64 bitop
Date: Thu, 23 Apr 2009 10:16:54 +0100
Message-Id: <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finds the first set bit in a 64 bit word. This is required in order
to fix a bug in GFS2, but I think it should be a generic function
in case of future users.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Willy Tarreau <w@1wt.eu>

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 6182913..c05a29c 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -112,6 +112,25 @@ static inline unsigned fls_long(unsigned long l)
 	return fls64(l);
 }
 
+/**
+ * __ffs64 - find first set bit in a 64 bit word
+ * @word: The 64 bit word
+ *
+ * On 64 bit arches this is a synomyn for __ffs
+ * The result is not defined if no bits are set, so check that @word
+ * is non-zero before calling this.
+ */
+static inline unsigned long __ffs64(u64 word)
+{
+#if BITS_PER_LONG == 32
+	if (((u32)word) == 0UL)
+		return __ffs((u32)(word >> 32)) + 32;
+#elif BITS_PER_LONG != 64
+#error BITS_PER_LONG not 32 or 64
+#endif
+	return __ffs((unsigned long)word);
+}
+
 #ifdef __KERNEL__
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
-- 
1.6.0.6

