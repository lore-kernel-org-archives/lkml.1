Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYBTXcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYBTXcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYBTXbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:31:50 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:36075 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYBTXbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:31:49 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.25] RDMA/cxgb3: Shift calculation wrong for single sge entries.
Date: Wed, 20 Feb 2008 17:31:48 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Message-Id: <20080220233148.25301.54457.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: Shift calculation wrong for single sge entries.

A single entry (addr 0x10001000, size 0x2000) will get converted to
page address 0x10000000 with a page size of 0x4000.  The code as it
stands doesn't address the single buffer case, but in fact it allows
the subsequent single-buffer special case to be eliminated entirely.
Because the mask now includes the (page adjusted) starting and ending
addresses, the general case works for the single buffer case as well.

Signed-off-by: Bryan Rosenburg <rosnbrg@us.ibm.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_mem.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_mem.c b/drivers/infiniband/hw/cxgb3/iwch_mem.c
index 73bfd16..b8797c6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -136,14 +136,8 @@ int build_phys_page_list(struct ib_phys_buf *buffer_list,
 
 	/* Find largest page shift we can use to cover buffers */
 	for (*shift = PAGE_SHIFT; *shift < 27; ++(*shift))
-		if (num_phys_buf > 1) {
-			if ((1ULL << *shift) & mask)
-				break;
-		} else
-			if (1ULL << *shift >=
-			    buffer_list[0].size +
-			    (buffer_list[0].addr & ((1ULL << *shift) - 1)))
-				break;
+		if ((1ULL << *shift) & mask)
+			break;
 
 	buffer_list[0].size += buffer_list[0].addr & ((1ULL << *shift) - 1);
 	buffer_list[0].addr &= ~0ull << *shift;
