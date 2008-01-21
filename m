Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYAUUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYAUUjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYAUUjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:39:37 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:50168 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627AbYAUUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:39:36 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2/3] RDMA/cxgb3: fix page shift calculation in build_phys_page_list()
Date: Mon, 21 Jan 2008 14:39:36 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080121203935.3143.12791.stgit@dell3.ogc.int>
In-Reply-To: <20080121203829.3143.26181.stgit@dell3.ogc.int>
References: <20080121203829.3143.26181.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: fix page shift calculation in build_phys_page_list()

The existing logic incorrectly maps this buffer list:

0: addr 0x10001000, size 0x1000
1: addr 0x10002000, size 0x1000

To this bogus page list:

0: 0x10000000
1: 0x10002000

The shift calculation must also take into account the address of the first
entry masked by the page_mask as well as the last address+size rounded
up to the next page size.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_mem.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_mem.c b/drivers/infiniband/hw/cxgb3/iwch_mem.c
index a6c2c4b..73bfd16 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_mem.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_mem.c
@@ -122,6 +122,13 @@ int build_phys_page_list(struct ib_phys_buf *buffer_list,
 		*total_size += buffer_list[i].size;
 		if (i > 0)
 			mask |= buffer_list[i].addr;
+		else
+			mask |= buffer_list[i].addr & PAGE_MASK;
+		if (i != num_phys_buf - 1)
+			mask |= buffer_list[i].addr + buffer_list[i].size;
+		else
+			mask |= (buffer_list[i].addr + buffer_list[i].size +
+				PAGE_SIZE - 1) & PAGE_MASK;
 	}
 
 	if (*total_size > 0xFFFFFFFFULL)
