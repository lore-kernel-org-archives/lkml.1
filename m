Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbXJDEGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbXJDEGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbXJDEAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37868 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbXJDEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:06 -0400
Message-Id: <20071004040004.253793692@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:46 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [11/18] Page allocator: Use a higher order allocation for the zone wait table.
Content-Disposition: inline; filename=vcompound_wait_table_no_vmalloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmalloc is used for the zone wait table. Therefore the vmalloc
page tables have to be consulted by the MMU to access the wait table.
We can now use GFP_VFALLBACK to attempt the use of a physically contiguous
page that can then use the large kernel TLBs.

Drawback: The zone wait table is rounded up to the next power of two which
may cost some memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-10-03 18:07:16.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-10-03 18:07:20.000000000 -0700
@@ -2585,7 +2585,9 @@ int zone_wait_table_init(struct zone *zo
 		 * To use this new node's memory, further consideration will be
 		 * necessary.
 		 */
-		zone->wait_table = (wait_queue_head_t *)vmalloc(alloc_size);
+		zone->wait_table = (wait_queue_head_t *)
+			__get_free_pages(GFP_VFALLBACK,
+					get_order(alloc_size));
 	}
 	if (!zone->wait_table)
 		return -ENOMEM;

-- 
