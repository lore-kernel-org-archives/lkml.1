Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXISDkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXISDkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXISDhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752141AbXISDgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:44 -0400
Message-Id: <20070919033643.537998421@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:19 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [14/17] Allow bit_waitqueue to wait on a bit in a vmalloc area
Content-Disposition: inline; filename=vcompound_wait_on_virtually_mapped_object
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If bit waitqueue is passed a virtual address then it must use
vmalloc_to_page instead of virt_to_page to get to the page struct.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/wait.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/wait.c
===================================================================
--- linux-2.6.orig/kernel/wait.c	2007-09-18 19:19:27.000000000 -0700
+++ linux-2.6/kernel/wait.c	2007-09-18 20:10:39.000000000 -0700
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
+#include <linux/vmalloc.h>
 
 void init_waitqueue_head(wait_queue_head_t *q)
 {
@@ -245,9 +246,16 @@ EXPORT_SYMBOL(wake_up_bit);
 fastcall wait_queue_head_t *bit_waitqueue(void *word, int bit)
 {
 	const int shift = BITS_PER_LONG == 32 ? 5 : 6;
-	const struct zone *zone = page_zone(virt_to_page(word));
 	unsigned long val = (unsigned long)word << shift | bit;
+	struct page *page;
+	struct zone *zone;
 
+	if (is_vmalloc_addr(word))
+		page = vmalloc_to_page(word)
+	else
+		page = virt_to_page(word);
+
+	zone = page_zone(page);
 	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];
 }
 EXPORT_SYMBOL(bit_waitqueue);

-- 
