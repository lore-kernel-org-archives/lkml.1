Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbXJ3FMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbXJ3FMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXJ3FMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:12:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47793 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXJ3FMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:12:40 -0400
Date: Tue, 30 Oct 2007 16:12:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rpc_rdma: we need to cast u64 to unsigned long long for
 printing
Message-Id: <20071030161240.bc81cad3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

as some architectures have unsigned long for u64.

net/sunrpc/xprtrdma/rpc_rdma.c: In function 'rpcrdma_create_chunks':
net/sunrpc/xprtrdma/rpc_rdma.c:222: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/sunrpc/xprtrdma/rpc_rdma.c:234: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/sunrpc/xprtrdma/rpc_rdma.c: In function 'rpcrdma_count_chunks':
net/sunrpc/xprtrdma/rpc_rdma.c:577: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64

Noticed on PowerPC pseries_defconfig build.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index f877b88..9e11ce7 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -221,8 +221,8 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 					seg->mr_base);
 			dprintk("RPC:       %s: read chunk "
 				"elem %d@0x%llx:0x%x pos %d (%s)\n", __func__,
-				seg->mr_len, seg->mr_base, seg->mr_rkey, pos,
-				n < nsegs ? "more" : "last");
+				seg->mr_len, (unsigned long long)seg->mr_base,
+				seg->mr_rkey, pos, n < nsegs ? "more" : "last");
 			cur_rchunk++;
 			r_xprt->rx_stats.read_chunk_count++;
 		} else {		/* write/reply */
@@ -234,8 +234,8 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 			dprintk("RPC:       %s: %s chunk "
 				"elem %d@0x%llx:0x%x (%s)\n", __func__,
 				(type == rpcrdma_replych) ? "reply" : "write",
-				seg->mr_len, seg->mr_base, seg->mr_rkey,
-				n < nsegs ? "more" : "last");
+				seg->mr_len, (unsigned long long)seg->mr_base,
+				seg->mr_rkey, n < nsegs ? "more" : "last");
 			cur_wchunk++;
 			if (type == rpcrdma_replych)
 				r_xprt->rx_stats.reply_chunk_count++;
@@ -577,7 +577,7 @@ rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, __be32 **ipt
 			dprintk("RPC:       %s: chunk %d@0x%llx:0x%x\n",
 				__func__,
 				ntohl(seg->rs_length),
-				off,
+				(unsigned long long)off,
 				ntohl(seg->rs_handle));
 		}
 		total_len += ntohl(seg->rs_length);
-- 
1.5.3.4

