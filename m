Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYFXOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYFXOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYFXOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:38:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:47955 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYFXOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:38:15 -0400
Subject: [PATCH] net/inet_lro: remove setting skb->ip_summed when not
	LRO-able
From: Eli Cohen <eli@dev.mellanox.co.il>
Reply-To: eli@dev.mellanox.co.il
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Vladimir Sokolovsky <vlad@mellanox.co.il>,
       Or Gerlitz <or.gerlitz@gmail.com>,
       OpenFabrics General <general@lists.openfabrics.org>,
       Jan-Bernd Themann <THEMANN@de.ibm.com>
Content-Type: text/plain
Organization: Mellanox Tecnologies
Date: Tue, 24 Jun 2008 17:39:46 +0300
Message-Id: <1214318386.23583.37.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 59c28d377ddfb7c13e2e1ecbf184211704d0e61d Mon Sep 17 00:00:00 2001
From: Eli Cohen <eli@mellanox.co.il>
Date: Tue, 24 Jun 2008 17:17:14 +0300
Subject: [PATCH] net/inet_lro: remove setting skb->ip_summed when not LRO-able

When an SKB cannot be chained to a session, the current code attempts
to "restore" its ip_summed field from lro_mgr->ip_summed. However,
lro_mgr->ip_summed does not hold the original value; in fact, we'd
better not touch skb->ip_summed since it is not modified by the code
in the path leading to a failure to chain it.

Issue raised by Or Gerlitz <ogerlitz@voltaire.com>

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
 net/ipv4/inet_lro.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_lro.c b/net/ipv4/inet_lro.c
index 4a4d49f..cfd034a 100644
--- a/net/ipv4/inet_lro.c
+++ b/net/ipv4/inet_lro.c
@@ -383,8 +383,7 @@ static int __lro_proc_skb(struct net_lro_mgr *lro_mgr, struct sk_buff *skb,
 out2: /* send aggregated SKBs to stack */
 	lro_flush(lro_mgr, lro_desc);
 
-out:  /* Original SKB has to be posted to stack */
-	skb->ip_summed = lro_mgr->ip_summed;
+out:
 	return 1;
 }
 
-- 
1.5.6



