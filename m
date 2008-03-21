Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYCUGVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYCUGVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYCUGTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753498AbYCUGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:55 -0400
Message-Id: <20080321061726.035952517@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:11 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [08/14] vcompound: Fallback for zone wait table
Content-Disposition: inline; filename=0010-vcompound-Fallback-for-wait-table.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmalloc may be used for allocating zone wait table.
Use virtual compound page in order to be able to use a physically contiguous
page that can then use the large kernel TLBs.

Drawback: The zone wait table is rounded up to the next power of two which
may cost some memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc5-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/page_alloc.c	2008-03-20 20:03:50.885900600 -0700
+++ linux-2.6.25-rc5-mm1/mm/page_alloc.c	2008-03-20 20:04:43.282104684 -0700
@@ -2866,7 +2866,8 @@ int zone_wait_table_init(struct zone *zo
 		 * To use this new node's memory, further consideration will be
 		 * necessary.
 		 */
-		zone->wait_table = vmalloc(alloc_size);
+		zone->wait_table = __alloc_vcompound(GFP_KERNEL,
+						get_order(alloc_size));
 	}
 	if (!zone->wait_table)
 		return -ENOMEM;

-- 
