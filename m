Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbXIYXqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbXIYXqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXIYXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36409 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbXIYXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:52 -0400
Message-Id: <20070925234251.740483810@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:15 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [11/17] GFP_VFALLBACK for zone wait table.
Content-Disposition: inline; filename=vcompound_wait_table_no_vmalloc
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently vmalloc is used for the zone wait table possibly generating the need
to generate lots of TLBs to access the tables. We can now use GFP_VFALLBACK to
attempt the use of a physically contiguous page that can then use the large
kernel TLBs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-09-24 18:48:06.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-09-24 18:48:16.000000000 -0700
@@ -2550,7 +2550,9 @@ int zone_wait_table_init(struct zone *zo
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
