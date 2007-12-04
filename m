Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXLDUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXLDUjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXLDUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:38:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:44562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbXLDUiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:38:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,250,1194249600"; 
   d="scan'208";a="223801806"
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/7] dmapool: Validate parameters to dma_pool_create
Date: Tue,  4 Dec 2007 13:26:05 -0800
Message-Id: <11968035682211-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11968035684180-git-send-email-matthew@wil.cx>
References: <20071204170915.GE9405@parisc-linux.org> <11968035682899-git-send-email-matthew@wil.cx> <11968035681680-git-send-email-matthew@wil.cx> <11968035684180-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that 'align' is a power of two, like the API specifies.
Align 'size' to 'align' correctly -- the current code has an off-by-one.
The ALIGN macro in kernel.h doesn't.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 mm/dmapool.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index b5ff9ce..744d541 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -106,17 +106,18 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 {
 	struct dma_pool *retval;
 
-	if (align == 0)
+	if (align == 0) {
 		align = 1;
-	if (size == 0)
+	} else if (align & (align - 1)) {
 		return NULL;
-	else if (size < align)
-		size = align;
-	else if ((size % align) != 0) {
-		size += align + 1;
-		size &= ~(align - 1);
 	}
 
+	if (size == 0)
+		return NULL;
+
+	if ((size % align) != 0)
+		size = ALIGN(size, align);
+
 	if (allocation == 0) {
 		if (PAGE_SIZE < size)
 			allocation = size;
-- 
1.4.4.4
