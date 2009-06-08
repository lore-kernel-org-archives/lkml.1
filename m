Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZFHNdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZFHNdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZFHNdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:33:09 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:55549 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbZFHNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:33:06 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 2/5] nfnetlink_queue: Use rcu_barrier() on module unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Date: Mon, 08 Jun 2009 15:11:33 +0200
Message-ID: <20090608131133.10052.40836.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
References: <20090608130959.10052.54590.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module uses rcu_call() thus it should use rcu_barrier() on module unload.

Also fixed a trivial typo 'nfetlink' -> 'nfnetlink' in comment.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 net/netfilter/nfnetlink_queue.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8c86011..71daa09 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1,6 +1,6 @@
 /*
  * This is a module which is used for queueing packets and communicating with
- * userspace via nfetlink.
+ * userspace via nfnetlink.
  *
  * (C) 2005 by Harald Welte <laforge@netfilter.org>
  * (C) 2007 by Patrick McHardy <kaber@trash.net>
@@ -932,6 +932,8 @@ static void __exit nfnetlink_queue_fini(void)
 #endif
 	nfnetlink_subsys_unregister(&nfqnl_subsys);
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
+
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
 MODULE_DESCRIPTION("netfilter packet queue handler");

