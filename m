Return-Path: <linux-kernel-owner+w=401wt.eu-S935715AbYEBQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935715AbYEBQSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763392AbYEBQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:17:46 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:43354 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762311AbYEBQRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:17:44 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.26 2/3] RDMA/cxgb3: Silently ignore close reply after abort.
Date: Fri, 02 May 2008 11:17:43 -0500
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080502161743.30500.27928.stgit@dell3.ogc.int>
In-Reply-To: <20080502161741.30500.95337.stgit@dell3.ogc.int>
References: <20080502161741.30500.95337.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove bad BUG_ON() in close_con_rpl().  It is possible to get a close_rpl
message on a dead connection.  The sequence is:
	host refs ep for close exchange
	host posts close_req
	hw posts PEER_ABORT from incoming RST
	host marks ep DEAD
	host posts ABORT_RPL and releases ep resources
	hw posts CLOSE_RPL
	host derefs ep and ep freed.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index f4f3c9e..b2db0a9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1650,8 +1650,8 @@ static int close_con_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 		release = 1;
 		break;
 	case ABORTING:
-		break;
 	case DEAD:
+		break;
 	default:
 		BUG_ON(1);
 		break;
