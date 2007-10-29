Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbXJ2EiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbXJ2EiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXJ2EiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:38:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40963 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXJ2EiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:38:02 -0400
Date: Mon, 29 Oct 2007 04:37:58 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [SUNRPC] endianness annotations
Message-ID: <20071029043758.GZ8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rpcrdma stuff lacks endianness annotations for on-the-wire data.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/sunrpc/rpc_rdma.h b/include/linux/sunrpc/rpc_rdma.h
index 0013a0d..87b895d 100644
--- a/include/linux/sunrpc/rpc_rdma.h
+++ b/include/linux/sunrpc/rpc_rdma.h
@@ -41,17 +41,17 @@
 #define _LINUX_SUNRPC_RPC_RDMA_H
 
 struct rpcrdma_segment {
-	uint32_t rs_handle;	/* Registered memory handle */
-	uint32_t rs_length;	/* Length of the chunk in bytes */
-	uint64_t rs_offset;	/* Chunk virtual address or offset */
+	__be32 rs_handle;	/* Registered memory handle */
+	__be32 rs_length;	/* Length of the chunk in bytes */
+	__be64 rs_offset;	/* Chunk virtual address or offset */
 };
 
 /*
  * read chunk(s), encoded as a linked list.
  */
 struct rpcrdma_read_chunk {
-	uint32_t rc_discrim;	/* 1 indicates presence */
-	uint32_t rc_position;	/* Position in XDR stream */
+	__be32 rc_discrim;	/* 1 indicates presence */
+	__be32 rc_position;	/* Position in XDR stream */
 	struct rpcrdma_segment rc_target;
 };
 
@@ -66,29 +66,29 @@ struct rpcrdma_write_chunk {
  * write chunk(s), encoded as a counted array.
  */
 struct rpcrdma_write_array {
-	uint32_t wc_discrim;	/* 1 indicates presence */
-	uint32_t wc_nchunks;	/* Array count */
+	__be32 wc_discrim;	/* 1 indicates presence */
+	__be32 wc_nchunks;	/* Array count */
 	struct rpcrdma_write_chunk wc_array[0];
 };
 
 struct rpcrdma_msg {
-	uint32_t rm_xid;	/* Mirrors the RPC header xid */
-	uint32_t rm_vers;	/* Version of this protocol */
-	uint32_t rm_credit;	/* Buffers requested/granted */
-	uint32_t rm_type;	/* Type of message (enum rpcrdma_proc) */
+	__be32 rm_xid;	/* Mirrors the RPC header xid */
+	__be32 rm_vers;	/* Version of this protocol */
+	__be32 rm_credit;	/* Buffers requested/granted */
+	__be32 rm_type;	/* Type of message (enum rpcrdma_proc) */
 	union {
 
 		struct {			/* no chunks */
-			uint32_t rm_empty[3];	/* 3 empty chunk lists */
+			__be32 rm_empty[3];	/* 3 empty chunk lists */
 		} rm_nochunks;
 
 		struct {			/* no chunks and padded */
-			uint32_t rm_align;	/* Padding alignment */
-			uint32_t rm_thresh;	/* Padding threshold */
-			uint32_t rm_pempty[3];	/* 3 empty chunk lists */
+			__be32 rm_align;	/* Padding alignment */
+			__be32 rm_thresh;	/* Padding threshold */
+			__be32 rm_pempty[3];	/* 3 empty chunk lists */
 		} rm_padded;
 
-		uint32_t rm_chunks[0];	/* read, write and reply chunks */
+		__be32 rm_chunks[0];	/* read, write and reply chunks */
 
 	} rm_body;
 };
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 12db635..f877b88 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -181,7 +181,7 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 	struct rpcrdma_read_chunk *cur_rchunk = NULL;
 	struct rpcrdma_write_array *warray = NULL;
 	struct rpcrdma_write_chunk *cur_wchunk = NULL;
-	u32 *iptr = headerp->rm_body.rm_chunks;
+	__be32 *iptr = headerp->rm_body.rm_chunks;
 
 	if (type == rpcrdma_readch || type == rpcrdma_areadch) {
 		/* a read chunk - server will RDMA Read our memory */
@@ -217,7 +217,7 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 			cur_rchunk->rc_target.rs_handle = htonl(seg->mr_rkey);
 			cur_rchunk->rc_target.rs_length = htonl(seg->mr_len);
 			xdr_encode_hyper(
-					(u32 *)&cur_rchunk->rc_target.rs_offset,
+					(__be32 *)&cur_rchunk->rc_target.rs_offset,
 					seg->mr_base);
 			dprintk("RPC:       %s: read chunk "
 				"elem %d@0x%llx:0x%x pos %d (%s)\n", __func__,
@@ -229,7 +229,7 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 			cur_wchunk->wc_target.rs_handle = htonl(seg->mr_rkey);
 			cur_wchunk->wc_target.rs_length = htonl(seg->mr_len);
 			xdr_encode_hyper(
-					(u32 *)&cur_wchunk->wc_target.rs_offset,
+					(__be32 *)&cur_wchunk->wc_target.rs_offset,
 					seg->mr_base);
 			dprintk("RPC:       %s: %s chunk "
 				"elem %d@0x%llx:0x%x (%s)\n", __func__,
@@ -257,14 +257,14 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 	 * finish off header. If write, marshal discrim and nchunks.
 	 */
 	if (cur_rchunk) {
-		iptr = (u32 *) cur_rchunk;
+		iptr = (__be32 *) cur_rchunk;
 		*iptr++ = xdr_zero;	/* finish the read chunk list */
 		*iptr++ = xdr_zero;	/* encode a NULL write chunk list */
 		*iptr++ = xdr_zero;	/* encode a NULL reply chunk */
 	} else {
 		warray->wc_discrim = xdr_one;
 		warray->wc_nchunks = htonl(nchunks);
-		iptr = (u32 *) cur_wchunk;
+		iptr = (__be32 *) cur_wchunk;
 		if (type == rpcrdma_writech) {
 			*iptr++ = xdr_zero; /* finish the write chunk list */
 			*iptr++ = xdr_zero; /* encode a NULL reply chunk */
@@ -559,7 +559,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
  * RDMA'd by server. See map at rpcrdma_create_chunks()! :-)
  */
 static int
-rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, u32 **iptrp)
+rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, __be32 **iptrp)
 {
 	unsigned int i, total_len;
 	struct rpcrdma_write_chunk *cur_wchunk;
@@ -573,7 +573,7 @@ rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, u32 **iptrp)
 		struct rpcrdma_segment *seg = &cur_wchunk->wc_target;
 		ifdebug(FACILITY) {
 			u64 off;
-			xdr_decode_hyper((u32 *)&seg->rs_offset, &off);
+			xdr_decode_hyper((__be32 *)&seg->rs_offset, &off);
 			dprintk("RPC:       %s: chunk %d@0x%llx:0x%x\n",
 				__func__,
 				ntohl(seg->rs_length),
@@ -585,7 +585,7 @@ rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, u32 **iptrp)
 	}
 	/* check and adjust for properly terminated write chunk */
 	if (wrchunk) {
-		u32 *w = (u32 *) cur_wchunk;
+		__be32 *w = (__be32 *) cur_wchunk;
 		if (*w++ != xdr_zero)
 			return -1;
 		cur_wchunk = (struct rpcrdma_write_chunk *) w;
@@ -593,7 +593,7 @@ rpcrdma_count_chunks(struct rpcrdma_rep *rep, int max, int wrchunk, u32 **iptrp)
 	if ((char *) cur_wchunk > rep->rr_base + rep->rr_len)
 		return -1;
 
-	*iptrp = (u32 *) cur_wchunk;
+	*iptrp = (__be32 *) cur_wchunk;
 	return total_len;
 }
 
@@ -721,7 +721,7 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	struct rpc_rqst *rqst;
 	struct rpc_xprt *xprt = rep->rr_xprt;
 	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
-	u32 *iptr;
+	__be32 *iptr;
 	int i, rdmalen, status;
 
 	/* Check status. If bad, signal disconnect and return rep to pool */
@@ -801,7 +801,7 @@ repost:
 			r_xprt->rx_stats.total_rdma_reply += rdmalen;
 		} else {
 			/* else ordinary inline */
-			iptr = (u32 *)((unsigned char *)headerp + 28);
+			iptr = (__be32 *)((unsigned char *)headerp + 28);
 			rep->rr_len -= 28; /*sizeof *headerp;*/
 			status = rep->rr_len;
 		}
@@ -816,7 +816,7 @@ repost:
 		    headerp->rm_body.rm_chunks[2] != xdr_one ||
 		    req->rl_nchunks == 0)
 			goto badheader;
-		iptr = (u32 *)((unsigned char *)headerp + 28);
+		iptr = (__be32 *)((unsigned char *)headerp + 28);
 		rdmalen = rpcrdma_count_chunks(rep, req->rl_nchunks, 0, &iptr);
 		if (rdmalen < 0)
 			goto badheader;
