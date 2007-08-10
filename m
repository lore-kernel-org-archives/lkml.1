Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbXHJDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbXHJDvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 23:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXHJDvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 23:51:05 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41597 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbXHJDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 23:51:04 -0400
Subject: [PATCH] [MTD] Fix CFI build error with meaningless nonfunctional
	.config
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070806161537.GA1269@elte.hu>
References: <20070806161537.GA1269@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 11:50:41 +0800
Message-Id: <1186717841.7282.104.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 18:15 +0200, Ingo Molnar wrote:
> randconfig testing on .23-rc2 triggered the following build error:

When building NOR flash support, you have compile-time options for the
bus width and the number of individual chips which are interleaved
together onto that bus. The code to deal with arbitrary geometry is a
bit convoluted, and people want to just configure it for the specific
hardware they have, to avoid the runtime overhead.

Selecting _none_ of the available options doesn't make any sense. You
should have at least one. This makes it build though, since people
persist in trying.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index 123948b..e17c534 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -57,6 +57,15 @@
 #define cfi_interleave_is_8(cfi) (0)
 #endif
 
+#ifndef cfi_interleave
+#warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.
+static inline int cfi_interleave(void *cfi)
+{
+	BUG();
+	return 0;
+}
+#endif
+
 static inline int cfi_interleave_supported(int i)
 {
 	switch (i) {
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 81f3a31..a9fae03 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -125,7 +125,15 @@
 #endif
 
 #ifndef map_bankwidth
-#error "No bus width supported. What's the point?"
+#warning "No CONFIG_MTD_MAP_BANK_WIDTH_xx selected. No NOR chip support can work"
+static inline int map_bankwidth(void *map)
+{
+	BUG();
+	return 0;
+}
+#define map_bankwidth_is_large(map) (0)
+#define map_words(map) (0)
+#define MAX_MAP_BANKWIDTH 1
 #endif
 
 static inline int map_bankwidth_supported(int w)


-- 
dwmw2

