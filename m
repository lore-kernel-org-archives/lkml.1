Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZFHNdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZFHNdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFHNdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:33:12 -0400
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:55548 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbZFHNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:33:06 -0400
From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 4/5] sctp: protocol.c call rcu_barrier() on unload.
To: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <hawk@comx.dk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, wg@grandegger.com,
       vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
       Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Date: Mon, 08 Jun 2009 15:11:43 +0200
Message-ID: <20090608131143.10052.96470.stgit@localhost>
In-Reply-To: <20090608130959.10052.54590.stgit@localhost>
References: <20090608130959.10052.54590.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On module unload call rcu_barrier(), this is needed as synchronize_rcu()
is not strong enough.  The kmem_cache_destroy() does invoke
synchronize_rcu() but it does not provide same protection.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 net/sctp/protocol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index cb2c50d..79cbd47 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1370,6 +1370,8 @@ SCTP_STATIC __exit void sctp_exit(void)
 	sctp_proc_exit();
 	cleanup_sctp_mibs();
 
+	rcu_barrier(); /* Wait for completion of call_rcu()'s */
+
 	kmem_cache_destroy(sctp_chunk_cachep);
 	kmem_cache_destroy(sctp_bucket_cachep);
 }

