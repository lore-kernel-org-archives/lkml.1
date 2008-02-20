Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYBTCh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYBTCh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYBTChO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:37:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38479 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbYBTChM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:37:12 -0500
Date: Tue, 19 Feb 2008 18:45:28 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] mm: fix dma_poor_create
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802191845.28802.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dev_to_node could return node that without RAM. So check it before use it in kmalloc_node

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 34aaac4..6be5b5a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -128,6 +128,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	int node;
 
 	if (align == 0) {
 		align = 1;
@@ -152,7 +153,11 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 		return NULL;
 	}
 
-	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
+	node = dev_to_node(dev);
+	if (node == -1 || !node_online(node))
+		node = numa_node_id();
+
+	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
 	if (!retval)
 		return retval;
 
