Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXISDjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXISDjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXISDgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54944 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbXISDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:43 -0400
Message-Id: <20070919033642.843541917@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:16 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [11/17] GFP_VFALLBACK for zone wait table.
Content-Disposition: inline; filename=vcompound_wait_table_no_vmalloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have to use vmalloc for the zone wait table possibly generating
the need to create lots of TLBs to access the tables. We can now use
GFP_VFALLBACK to attempt the use of a physically contiguous page that can then
use the large kernel TLBs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-18 14:29:05.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-18 14:29:10.000000000 -0700
@@ -2572,7 +2572,9 @@ int zone_wait_table_init(struct zone *zo
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
