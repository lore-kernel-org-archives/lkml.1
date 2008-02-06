Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYBFSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYBFSFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYBFSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:05:21 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:52132 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYBFSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:05:20 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.25] cxgb3: Handle ARP completions that mark neighbors stale.
Date: Wed, 06 Feb 2008 12:05:19 -0600
To: jeff@garzik.org, divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080206180519.4680.34741.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cxgb3: Handle ARP completions that mark neighbors stale.

When ARP completes due to a request rather than a reply the neighbor is
marked NUD_STALE instead of reachable (see arp_process()).  The handler
for the resulting netevent needs to check also for NUD_STALE.

Failure to use the arp entry can cause RDMA connection failures.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/net/cxgb3/l2t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/l2t.c b/drivers/net/cxgb3/l2t.c
index d660af7..d80bbdb 100644
--- a/drivers/net/cxgb3/l2t.c
+++ b/drivers/net/cxgb3/l2t.c
@@ -404,7 +404,7 @@ found:
 			if (neigh->nud_state & NUD_FAILED) {
 				arpq = e->arpq_head;
 				e->arpq_head = e->arpq_tail = NULL;
-			} else if (neigh_is_connected(neigh))
+			} else if (neigh->nud_state & (NUD_CONNECTED|NUD_STALE))
 				setup_l2e_send_pending(dev, NULL, e);
 		} else {
 			e->state = neigh_is_connected(neigh) ?
