Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXIZTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXIZTBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXIZTBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:01:23 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:53510 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbXIZTBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:01:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/4] dmapool: Validate parameters to dma_pool_create
Date: Wed, 26 Sep 2007 15:01:17 -0400
Message-Id: <11908332793750-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.5.3.1
In-Reply-To: <20070926185757.GM3899@parisc-linux.org>
References: <20070926185757.GM3899@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check that 'align' is a power of two, like the API specifies.
Align 'size' to 'align' correctly -- the current code has an off-by-one.
The ALIGN macro in kernel.h doesn't.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/dmapool.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index a359b5e..f5d12a7 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -107,17 +107,18 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
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
1.5.3.1

