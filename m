Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYJBAJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYJBAJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYJBAIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:08:43 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:38605 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYJBAIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:08:40 -0400
From: Tom Tucker <tom@opengridcomputing.com>
To: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org
Cc: rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov, tom@opengridcomputing.com
Subject: [PATCH 01/03] 9prdma: RDMA Transport Support for 9P
Date: Wed,  1 Oct 2008 19:08:37 -0500
Message-Id: <1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
X-Mailer: git-send-email 1.5.3.4.452.g09149
In-Reply-To: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
References: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file implements the RDMA transport provider for 9P. It allows
mounts to be performed over iWARP and IB capable network interfaces
and uses the OpenFabrics API to perform I/O.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Latchesar Ionkov <lionkov@lanl.gov>

---
 net/9p/trans_rdma.c | 1025 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1025 insertions(+), 0 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
new file mode 100644
index 0000000..f919768
--- /dev/null
+++ b/net/9p/trans_rdma.c
@@ -0,0 +1,1025 @@
+/*
+ * linux/fs/9p/trans_rdma.c
+ *
+ * RDMA transport layer based on the trans_fd.c implementation.
+ *
+ *  Copyright (C) 2008 by Tom Tucker <tom@opengridcomputing.com>
+ *  Copyright (C) 2006 by Russ Cox <rsc@swtch.com>
+ *  Copyright (C) 2004-2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004-2008 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 1997-2002 by Ron Minnich <rminnich@sarnoff.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/in.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <linux/ipv6.h>
+#include <linux/kthread.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/un.h>
+#include <linux/uaccess.h>
+#include <linux/inet.h>
+#include <linux/idr.h>
+#include <linux/file.h>
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/rdma_cm.h>
+#include <rdma/ib_verbs.h>
+
+#define P9_PORT			5640
+#define P9_RDMA_SQ_DEPTH	32
+#define P9_RDMA_RQ_DEPTH	32
+#define P9_RDMA_SEND_SGE	4
+#define P9_RDMA_RECV_SGE	4
+#define P9_RDMA_IRD		0
+#define P9_RDMA_ORD		0
+#define P9_RDMA_TIMEOUT		30000		/* 30 seconds */
+#define P9_RDMA_MAXSIZE		(4*4096)	/* Min SGE is 4, so we can
+						 * safely advertise a maxsize
+						 * of 64k */
+
+#define P9_RDMA_MAX_SGE (P9_RDMA_MAXSIZE >> PAGE_SHIFT)
+/**
+ * struct p9_trans_rdma - RDMA transport instance
+ *
+ * @state: tracks the transport state machine for connection setup and tear down
+ * @cm_id: The RDMA CM ID
+ * @pd: Protection Domain pointer
+ * @qp: Queue Pair pointer
+ * @cq: Completion Queue pointer
+ * @lkey: The local access only memory region key
+ * @next_tag: The next tag for tracking rpc
+ * @timeout: Number of uSecs to wait for connection management events
+ * @sq_depth: The depth of the Send Queue
+ * @sq_count: Number of WR on the Send Queue
+ * @rq_depth: The depth of the Receive Queue. NB: I _think_ that 9P is
+ * purely req/rpl (i.e. no unaffiliated replies, but I'm not sure, so
+ * I'm allowing this to be tweaked separately.
+ * @addr: The remote peer's address
+ * @req_lock: Protects the active request list
+ * @req_list: List of sent RPC awaiting replies
+ * @send_wait: Wait list when the SQ fills up
+ * @cm_done: Completion event for connection management tracking
+ */
+struct p9_trans_rdma {
+	enum {
+		P9_RDMA_INIT,
+		P9_RDMA_ADDR_RESOLVED,
+		P9_RDMA_ROUTE_RESOLVED,
+		P9_RDMA_CONNECTED,
+		P9_RDMA_FLUSHING,
+		P9_RDMA_CLOSING,
+		P9_RDMA_CLOSED,
+	} state;
+	struct rdma_cm_id *cm_id;
+	struct ib_pd *pd;
+	struct ib_qp *qp;
+	struct ib_cq *cq;
+	struct ib_mr *dma_mr;
+	u32 lkey;
+	atomic_t next_tag;
+	long timeout;
+	int sq_depth;
+	atomic_t sq_count;
+	int rq_depth;
+	struct sockaddr_in addr;
+
+	spinlock_t req_lock;
+	struct list_head req_list;
+
+	wait_queue_head_t send_wait;
+	struct completion cm_done;
+	struct p9_idpool *tagpool;
+};
+
+/**
+ * p9_rdma_context - Keeps track of in-process WR
+ *
+ * @wc_op: Mellanox's broken HW doesn't provide the original WR op
+ * when the CQE completes in error. This forces apps to keep track of
+ * the op themselves. Yes, it's a Pet Peeve of mine ;-)
+ * @busa: Bus address to unmap when the WR completes
+ * @req: Keeps track of requests (send)
+ * @rcall: Keepts track of replies (receive)
+ */
+struct p9_rdma_req;
+struct p9_rdma_context {
+	enum ib_wc_opcode wc_op;
+	dma_addr_t busa;
+	union {
+		struct p9_rdma_req *req;
+		struct p9_fcall *rcall;
+	};
+};
+
+#define P9_RDMA_REQ_FLUSHING 0
+#define P9_RDMA_REQ_COMPLETE 1
+/**
+ * struct p9_rdma_req - tracks the request and reply fcall structures.
+ *
+ * @req_lock: protects req_list
+ * @tcall: request &p9_fcall structure
+ * @rcall: response &p9_fcall structure
+ * @err: error state
+ * @cb: callback for when response is received
+ * @cba: argument to pass to callback
+ * @flush: flag to indicate RPC has been flushed
+ * @req_list: list link for higher level objects to chain requests
+ *
+ */
+struct p9_rdma_req {
+	struct p9_fcall *tcall;
+	struct p9_fcall *rcall;
+	struct completion done;
+	struct list_head list;
+	u16 tag;
+	int err;
+	atomic_t ref;
+	unsigned long flags;
+	spinlock_t lock;
+};
+
+static struct p9_rdma_req *rdma_req_get(void)
+{
+	struct p9_rdma_req *req;
+	req = kzalloc(sizeof *req, GFP_KERNEL);
+	if (req) {
+		atomic_set(&req->ref, 1);
+		init_completion(&req->done);
+		INIT_LIST_HEAD(&req->list);
+		spin_lock_init(&req->lock);
+		req->flags = 0;
+	}
+	return req;
+}
+
+static void rdma_req_put(struct p9_rdma_req *req)
+{
+	if (req && atomic_dec_and_test(&req->ref))
+		kfree(req);
+}
+
+/**
+ * p9_rdma_opts - Collection of mount options
+ *
+ * @sq_depth: The requested depth of the SQ. This really doesn't need
+ * to be any deeper than the number of threads used in the client
+ * @rq_depth: The depth of the RQ. Should be greater than or equal to SQ depth
+ * @timeout: Time to wait in msecs for CM events
+ */
+struct p9_rdma_opts {
+	short port;
+	int sq_depth;
+	int rq_depth;
+	long timeout;
+};
+
+/*
+  * Option Parsing (code inspired by NFS code)
+  */
+
+enum {
+	/* Options that take integer arguments */
+	Opt_port, Opt_rq_depth, Opt_sq_depth, Opt_timeout, Opt_err,
+};
+
+static match_table_t tokens = {
+	{Opt_port, "port=%u"},
+	{Opt_sq_depth, "sq=%u"},
+	{Opt_rq_depth, "rq=%u"},
+	{Opt_timeout, "timeout=%u"},
+	{Opt_err, NULL},
+};
+
+static int
+rdma_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc);
+
+/**
+ * parse_options - parse mount options into session structure
+ * @options: options string passed from mount
+ * @opts: transport-specific structure to parse options into
+ *
+ * Returns 0 upon success, -ERRNO upon failure
+ */
+static int parse_opts(char *params, struct p9_rdma_opts *opts)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+	char *options;
+	int ret;
+
+	opts->port = P9_PORT;
+	opts->sq_depth = P9_RDMA_SQ_DEPTH;
+	opts->rq_depth = P9_RDMA_RQ_DEPTH;
+	opts->timeout = P9_RDMA_TIMEOUT;
+
+	if (!params)
+		return 0;
+
+	options = kstrdup(params, GFP_KERNEL);
+	if (!options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		return -ENOMEM;
+	}
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		int r;
+		if (!*p)
+			continue;
+		token = match_token(p, tokens, args);
+		r = match_int(&args[0], &option);
+		if (r < 0) {
+			P9_DPRINTK(P9_DEBUG_ERROR,
+				   "integer field, but no integer?\n");
+			ret = r;
+			continue;
+		}
+		switch (token) {
+		case Opt_port:
+			opts->port = option;
+			break;
+		case Opt_sq_depth:
+			opts->sq_depth = option;
+			break;
+		case Opt_rq_depth:
+			opts->rq_depth = option;
+			break;
+		case Opt_timeout:
+			opts->timeout = option;
+			break;
+		default:
+			continue;
+		}
+	}
+	/* RQ must be at least as large as the SQ */
+	opts->rq_depth = max(opts->rq_depth, opts->sq_depth);
+	kfree(options);
+	return 0;
+}
+
+/*
+ * Queues the request to the list of active requests on the transport
+ */
+static void enqueue_request(struct p9_trans_rdma *rdma,
+			    struct p9_rdma_context *c)
+{
+	struct p9_rdma_req *req = c->req;
+	unsigned long flags;
+	atomic_inc(&req->ref);
+	spin_lock_irqsave(&rdma->req_lock, flags);
+	list_add_tail(&req->list, &rdma->req_list);
+	spin_unlock_irqrestore(&rdma->req_lock, flags);
+}
+
+static void dequeue_request(struct p9_trans_rdma *rdma, struct p9_rdma_req *req)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&rdma->req_lock, flags);
+	list_del(&req->list);
+	spin_unlock_irqrestore(&rdma->req_lock, flags);
+	rdma_req_put(req);
+}
+
+/*
+ * Searches the list of requests on the transport and returns the request
+ * with the matching tag
+ */
+static struct p9_rdma_req *
+find_req(struct p9_trans_rdma *rdma, u16 tag)
+{
+	unsigned long flags;
+	struct p9_rdma_req *req;
+	int found = 0;
+
+	spin_lock_irqsave(&rdma->req_lock, flags);
+	list_for_each_entry(req, &rdma->req_list, list) {
+		if (req->tag == tag) {
+			found = 1;
+			atomic_inc(&req->ref);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&rdma->req_lock, flags);
+
+	return found ? req : 0;
+}
+
+static int
+p9_cm_event_handler(struct rdma_cm_id *id,
+		 struct rdma_cm_event *event)
+{
+	struct p9_trans *t = id->context;
+	struct p9_trans_rdma *rdma = t->priv;
+	switch (event->event) {
+	case RDMA_CM_EVENT_ADDR_RESOLVED:
+		BUG_ON(rdma->state != P9_RDMA_INIT);
+		rdma->state = P9_RDMA_ADDR_RESOLVED;
+		break;
+
+	case RDMA_CM_EVENT_ROUTE_RESOLVED:
+		BUG_ON(rdma->state != P9_RDMA_ADDR_RESOLVED);
+		rdma->state = P9_RDMA_ROUTE_RESOLVED;
+		break;
+
+	case RDMA_CM_EVENT_ESTABLISHED:
+		BUG_ON(rdma->state != P9_RDMA_ROUTE_RESOLVED);
+		rdma->state = P9_RDMA_CONNECTED;
+		break;
+
+	case RDMA_CM_EVENT_DISCONNECTED:
+		if (rdma)
+			rdma->state = P9_RDMA_CLOSED;
+		if (t)
+			t->status = Disconnected;
+		break;
+
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
+		break;
+
+	case RDMA_CM_EVENT_ADDR_CHANGE:
+	case RDMA_CM_EVENT_ROUTE_ERROR:
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
+	case RDMA_CM_EVENT_MULTICAST_JOIN:
+	case RDMA_CM_EVENT_MULTICAST_ERROR:
+	case RDMA_CM_EVENT_REJECTED:
+	case RDMA_CM_EVENT_CONNECT_REQUEST:
+	case RDMA_CM_EVENT_CONNECT_RESPONSE:
+	case RDMA_CM_EVENT_CONNECT_ERROR:
+	case RDMA_CM_EVENT_ADDR_ERROR:
+	case RDMA_CM_EVENT_UNREACHABLE:
+		t->status = Disconnected;
+		rdma_disconnect(rdma->cm_id);
+		break;
+	default:
+		BUG();
+	}
+	complete(&rdma->cm_done);
+	return 0;
+}
+
+static void process_request(struct p9_trans *trans, struct p9_rdma_req *req)
+{
+	int ecode;
+	struct p9_str *ename;
+
+	if (req->rcall->id == P9_RERROR) {
+		ecode = req->rcall->params.rerror.errno;
+		ename = &req->rcall->params.rerror.error;
+
+		P9_DPRINTK(P9_DEBUG_MUX, "Rerror %.*s\n", ename->len,
+			   ename->str);
+
+		if (trans->extended)
+			req->err = -ecode;
+
+		if (!req->err) {
+			req->err = p9_errstr2errno(ename->str, ename->len);
+
+			/* string match failed */
+			if (!req->err) {
+				PRINT_FCALL_ERROR("unknown error", req->rcall);
+				req->err = -ESERVERFAULT;
+			}
+		}
+	} else if (req->tcall && req->rcall->id != req->tcall->id + 1) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+				"fcall mismatch: expected %d, got %d\n",
+				req->tcall->id + 1, req->rcall->id);
+		if (!req->err)
+			req->err = -EIO;
+	}
+}
+
+static void
+handle_recv(struct p9_trans *trans, struct p9_trans_rdma *rdma,
+	    struct p9_rdma_context *c, enum ib_wc_status status, u32 byte_len)
+{
+	struct p9_rdma_req *req;
+	unsigned long flags;
+	int err;
+
+	req = NULL;
+	err = -EIO;
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa, trans->msize,
+			    DMA_FROM_DEVICE);
+
+	if (status != IB_WC_SUCCESS)
+		goto err_out;
+
+	err = p9_deserialize_fcall(c->rcall->sdata, byte_len,
+				   c->rcall, trans->extended);
+	if (err < 0)
+		goto err_out;
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), c->rcall,
+			      trans->extended);
+		printk(KERN_NOTICE ">>> %p %s\n", trans, buf);
+	}
+#endif
+	req = find_req(rdma, c->rcall->tag);
+	if (req) {
+		spin_lock_irqsave(&req->lock, flags);
+		if (!test_bit(P9_RDMA_REQ_FLUSHING, &req->flags)) {
+			set_bit(P9_RDMA_REQ_COMPLETE, &req->flags);
+			req->rcall = c->rcall;
+			process_request(trans, req);
+			complete(&req->done);
+		}
+		spin_unlock_irqrestore(&req->lock, flags);
+		rdma_req_put(req);
+	}
+	return;
+
+ err_out:
+	P9_DPRINTK(P9_DEBUG_ERROR, "req %p err %d status %d\n",
+		   req, err, status);
+	rdma->state = P9_RDMA_FLUSHING;
+	trans->status = Disconnected;
+	return;
+}
+
+static void
+handle_send(struct p9_trans *trans, struct p9_trans_rdma *rdma,
+	    struct p9_rdma_context *c, enum ib_wc_status status, u32 byte_len)
+{
+	ib_dma_unmap_single(rdma->cm_id->device,
+			    c->busa, c->req->tcall->size,
+			    DMA_TO_DEVICE);
+}
+
+static void qp_event_handler(struct ib_event *event, void *context)
+{
+	P9_DPRINTK(P9_DEBUG_ERROR, "QP event %d context %p\n",
+		   event->event, context);
+}
+
+static void cq_comp_handler(struct ib_cq *cq, void *cq_context)
+{
+	struct p9_trans *trans = cq_context;
+	struct p9_trans_rdma *rdma = trans->priv;
+	int ret;
+	struct ib_wc wc;
+
+	ib_req_notify_cq(rdma->cq, IB_CQ_NEXT_COMP);
+	while ((ret = ib_poll_cq(cq, 1, &wc)) > 0) {
+		struct p9_rdma_context *c = (void *)wc.wr_id;
+
+		switch (c->wc_op) {
+		case IB_WC_RECV:
+			handle_recv(trans, rdma, c, wc.status, wc.byte_len);
+			break;
+
+		case IB_WC_SEND:
+			handle_send(trans, rdma, c, wc.status, wc.byte_len);
+			atomic_dec(&rdma->sq_count);
+			wake_up(&rdma->send_wait);
+			rdma_req_put(c->req);
+			break;
+
+		default:
+			printk(KERN_ERR "9prdma: unexpected completion type, "
+			       "c->wc_op=%d, wc.opcode=%d, status=%d\n",
+			       c->wc_op, wc.opcode, wc.status);
+			break;
+		}
+		kfree(c);
+	}
+}
+
+static void cq_event_handler(struct ib_event *e, void *v)
+{
+	P9_DPRINTK(P9_DEBUG_ERROR, "CQ event %d context %p\n",
+		   e->event, v);
+}
+
+static void rdma_destroy_trans(struct p9_trans *t)
+{
+	struct p9_trans_rdma *rdma = t->priv;
+
+	if (!rdma)
+		return;
+
+	if (rdma->dma_mr && !IS_ERR(rdma->dma_mr))
+		ib_dereg_mr(rdma->dma_mr);
+
+	if (rdma->qp && !IS_ERR(rdma->qp))
+		ib_destroy_qp(rdma->qp);
+
+	if (rdma->pd && !IS_ERR(rdma->pd))
+		ib_dealloc_pd(rdma->pd);
+
+	if (rdma->cq && !IS_ERR(rdma->cq))
+		ib_destroy_cq(rdma->cq);
+
+	if (rdma->cm_id && !IS_ERR(rdma->cm_id))
+		rdma_destroy_id(rdma->cm_id);
+
+	if (rdma->tagpool)
+		p9_idpool_destroy(rdma->tagpool);
+
+	kfree(rdma);
+}
+
+static int
+post_recv(struct p9_trans *trans, struct p9_rdma_context *c)
+{
+	struct p9_trans_rdma *rdma = trans->priv;
+	struct ib_recv_wr wr, *bad_wr;
+	struct ib_sge sge;
+	int ret;
+
+	c->busa = ib_dma_map_single(rdma->cm_id->device,
+				    c->rcall->sdata, trans->msize,
+				    DMA_FROM_DEVICE);
+	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa))
+		goto error;
+
+	sge.addr = c->busa;
+	sge.length = trans->msize;
+	sge.lkey = rdma->lkey;
+
+	wr.next = NULL;
+	c->wc_op = IB_WC_RECV;
+	wr.wr_id = (u64)c;
+	wr.sg_list = &sge;
+	wr.num_sge = 1;
+	ret = ib_post_recv(rdma->qp, &wr, &bad_wr);
+	return ret;
+
+ error:
+	P9_DPRINTK(P9_DEBUG_ERROR, "EIO\n");
+	return -EIO;
+}
+
+static struct p9_fcall *alloc_fcall(struct p9_trans *trans)
+{
+	struct p9_fcall *fc;
+	fc = kmalloc(sizeof(struct p9_fcall) + trans->msize, GFP_KERNEL);
+	if (fc)
+		fc->sdata = fc + 1;
+	return fc;
+}
+
+static u16 p9_get_tag(struct p9_trans *trans)
+{
+	int tag;
+	struct p9_trans_rdma *rdma;
+
+	rdma = trans->priv;
+	tag = p9_idpool_get(rdma->tagpool);
+	if (tag < 0)
+		return P9_NOTAG;
+	else
+		return (u16) tag;
+}
+
+static void p9_put_tag(struct p9_trans *trans, u16 tag)
+{
+	struct p9_trans_rdma *rdma;
+
+	rdma = trans->priv;
+	if (tag != P9_NOTAG && p9_idpool_check(tag, rdma->tagpool))
+		p9_idpool_put(tag, rdma->tagpool);
+}
+
+static int send_request(struct p9_trans *trans, struct p9_rdma_context *c)
+{
+	struct p9_trans_rdma *rdma = trans->priv;
+	struct ib_send_wr wr, *bad_wr;
+	struct ib_sge sge;
+
+	c->busa = ib_dma_map_single(rdma->cm_id->device,
+				    c->req->tcall->sdata, c->req->tcall->size,
+				    DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa))
+		goto error;
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
+		char buf[150];
+
+		p9_printfcall(buf, sizeof(buf), c->req->tcall, trans->extended);
+		printk(KERN_NOTICE "<<< %p %s\n", trans, buf);
+	}
+#endif
+	sge.addr = c->busa;
+	sge.length = c->req->tcall->size;
+	sge.lkey = rdma->lkey;
+
+	wr.next = NULL;
+	c->wc_op = IB_WC_SEND;
+	wr.wr_id = (u64)c;
+	wr.opcode = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+	wr.sg_list = &sge;
+	wr.num_sge = 1;
+
+	if (atomic_inc_return(&rdma->sq_count) >= rdma->sq_depth)
+		wait_event_interruptible
+			(rdma->send_wait,
+			 (atomic_read(&rdma->sq_count) < rdma->sq_depth));
+
+	return ib_post_send(rdma->qp, &wr, &bad_wr);
+
+ error:
+	P9_DPRINTK(P9_DEBUG_ERROR, "EIO\n");
+	return -EIO;
+}
+
+static void flush_request(struct p9_trans *trans, struct p9_rdma_req *req)
+{
+	struct p9_trans_rdma *rdma = trans->priv;
+	struct p9_fcall *tc;
+	struct p9_fcall *rc;
+	unsigned long flags;
+	int err;
+
+	/* Check if we received a response despite being interrupted. */
+	spin_lock_irqsave(&req->lock, flags);
+	if (!test_bit(P9_RDMA_REQ_COMPLETE, &req->flags))
+		set_bit(P9_RDMA_REQ_FLUSHING, &req->flags);
+	spin_unlock_irqrestore(&req->lock, flags);
+	if (!test_bit(P9_RDMA_REQ_FLUSHING, &req->flags))
+		goto out;
+
+	tc = p9_create_tflush(req->tag);
+	if (!tc) {
+		rdma->state = P9_RDMA_FLUSHING;
+		goto out;
+	}
+
+	clear_thread_flag(TIF_SIGPENDING);
+	err = rdma_rpc(trans, tc, &rc);
+	kfree(tc);
+out:
+	return;
+}
+
+/**
+ * rdma_rpc- sends 9P request and waits until a response is available.
+ *	The function can be interrupted.
+ * @t: transport data
+ * @tc: request to be sent
+ * @rc: pointer where a pointer to the response is stored
+ *
+ */
+static int
+rdma_rpc(struct p9_trans *t, struct p9_fcall *tc, struct p9_fcall **rc)
+{
+	int err = -ENOMEM, sigpending;
+	u16 tag;
+	struct p9_rdma_req *req;
+	struct p9_trans_rdma *rdma;
+	struct p9_rdma_context *req_context = NULL;
+	struct p9_rdma_context *rpl_context = NULL;
+	unsigned long flags;
+
+	if (t && t->status != Disconnected)
+		rdma = t->priv;
+	else
+		return -EREMOTEIO;
+
+	/* Initialize the request */
+	req = rdma_req_get();
+	if (!req)
+		goto err_close_0;
+	req->tcall = tc;
+	if (req->tcall->id == P9_TVERSION)
+		tag = P9_NOTAG;
+	else
+		tag = p9_get_tag(t);
+
+	req->tag = tag;
+	p9_set_tag(req->tcall, tag);
+
+	/* Allocate an fcall for the reply */
+	rpl_context = kmalloc(sizeof *rpl_context, GFP_KERNEL);
+	if (!rpl_context)
+		goto err_close_1;
+
+	rpl_context->rcall = alloc_fcall(t);
+	if (!rpl_context->rcall) {
+		kfree(rpl_context);
+		goto err_close_1;
+	}
+
+	/*
+	 * Post a receive buffer for this request. We don't know
+	 * which request this reply buffer will end up servicing, but
+	 * we allocate it here to ensure that there is a receive
+	 * buffer available for every request
+	 */
+	err = post_recv(t, rpl_context);
+	if (err) {
+		kfree(rpl_context->rcall);
+		kfree(rpl_context);
+		goto err_close_1;
+	}
+
+	/* Post the request */
+	req_context = kmalloc(sizeof *req_context, GFP_KERNEL);
+	if (!req_context)
+		goto err_close_1;
+	req_context->req = req;
+	enqueue_request(rdma, req_context);
+	atomic_inc(&req->ref);
+	err = send_request(t, req_context);
+	if (err) {
+		dequeue_request(rdma, req);
+		rdma_req_put(req);
+		kfree(req_context);
+		goto err_close_1;
+	}
+
+	sigpending = 0;
+	if (signal_pending(current)) {
+		sigpending = 1;
+		clear_thread_flag(TIF_SIGPENDING);
+	}
+
+	/* Wait for the response */
+	err = wait_for_completion_interruptible(&req->done);
+
+	/* Take request off the active queue */
+	dequeue_request(rdma, req);
+
+	/* If not, we need to flush request at the server. */
+	if (err == -ERESTARTSYS && rdma->state == P9_RDMA_CONNECTED &&
+	    tc->id != P9_TFLUSH) {
+		flush_request(t, req);
+		sigpending = 1;
+	}
+
+	if (sigpending) {
+		spin_lock_irqsave(&current->sighand->siglock, flags);
+		recalc_sigpending();
+		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	}
+
+	/* If we got disconnected while waiting, return an error */
+	if (rdma->state != P9_RDMA_CONNECTED) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "EIO\n");
+		err = -EIO;
+		goto err_close_1;
+	}
+
+	if (rc)
+		*rc = req->rcall;
+	else
+		kfree(req->rcall);
+
+	/* Return the RPC request's error if there is one */
+	if (req->err < 0)
+		err = req->err;
+
+	rdma_req_put(req);
+	p9_put_tag(t, tag);
+	return err;
+
+ err_close_1:
+	rdma_req_put(req);
+	p9_put_tag(t, tag);
+
+ err_close_0:
+	spin_lock_irqsave(&rdma->req_lock, flags);
+	if (rdma->state < P9_RDMA_CLOSING) {
+		rdma->state = P9_RDMA_CLOSING;
+		spin_unlock_irqrestore(&rdma->req_lock, flags);
+		rdma_disconnect(rdma->cm_id);
+	} else
+		spin_unlock_irqrestore(&rdma->req_lock, flags);
+	return err;
+}
+
+static void rdma_close(struct p9_trans *trans)
+{
+	struct p9_trans_rdma *rdma = trans->priv;
+	if (!rdma)
+		return;
+
+	trans->status = Disconnected;
+	rdma_disconnect(rdma->cm_id);
+	rdma_destroy_trans(trans);
+}
+
+/**
+ * alloc_trans - Allocate and initialize the rdma transport structure
+ * @msize: MTU
+ * @dotu: Extension attribute
+ * @opts: Mount options structure
+ */
+static struct p9_trans *
+alloc_trans(int msize, unsigned char dotu, struct p9_rdma_opts *opts)
+{
+	struct p9_trans *trans;
+	struct p9_trans_rdma *rdma;
+
+	trans = kmalloc(sizeof(struct p9_trans), GFP_KERNEL);
+	if (!trans)
+		return NULL;
+
+	trans->msize = msize;
+	trans->extended = dotu;
+	trans->rpc = rdma_rpc;
+	trans->close = rdma_close;
+
+	rdma = trans->priv = kzalloc(sizeof(struct p9_trans_rdma), GFP_KERNEL);
+	if (!rdma) {
+		kfree(trans);
+		return NULL;
+	}
+
+	rdma->sq_depth = opts->sq_depth;
+	rdma->rq_depth = opts->rq_depth;
+	rdma->timeout = opts->timeout;
+	spin_lock_init(&rdma->req_lock);
+	INIT_LIST_HEAD(&rdma->req_list);
+	init_waitqueue_head(&rdma->send_wait);
+	init_completion(&rdma->cm_done);
+	atomic_set(&rdma->sq_count, 0);
+	atomic_set(&rdma->next_tag, 1);
+
+	trans->priv  = rdma;
+
+	return trans;
+}
+
+/**
+ * trans_create_rdma - Transport method for creating atransport instance
+ * @addr: IP address string
+ * @args: Mount options string
+ * @msize: Max message size
+ * @dotu: Protocol extension flag
+ */
+static struct p9_trans *
+rdma_create_trans(const char *addr, char *args, int msize, unsigned char dotu)
+{
+	int err;
+	struct p9_trans *trans;
+	struct p9_rdma_opts opts;
+	struct p9_trans_rdma *rdma;
+	struct rdma_conn_param conn_param;
+	struct ib_qp_init_attr qp_attr;
+	struct ib_device_attr devattr;
+
+	/* Parse the transport specific mount options */
+	err = parse_opts(args, &opts);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	/* Create and initialize the RDMA transport structure */
+	trans = alloc_trans(msize, dotu, &opts);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	/* Create the RDMA CM ID */
+	rdma = trans->priv;
+	rdma->cm_id = rdma_create_id(p9_cm_event_handler, trans, RDMA_PS_TCP);
+	if (IS_ERR(rdma->cm_id))
+		goto error;
+
+	/* Resolve the server's address */
+	rdma->addr.sin_family = AF_INET;
+	rdma->addr.sin_addr.s_addr = in_aton(addr);
+	rdma->addr.sin_port = htons(opts.port);
+	err = rdma_resolve_addr(rdma->cm_id, NULL,
+				(struct sockaddr *)&rdma->addr,
+				rdma->timeout);
+	if (err)
+		goto error;
+	wait_for_completion_interruptible(&rdma->cm_done);
+	if (rdma->state != P9_RDMA_ADDR_RESOLVED)
+		goto error;
+
+	/* Resolve the route to the server */
+	err = rdma_resolve_route(rdma->cm_id, rdma->timeout);
+	if (err)
+		goto error;
+	wait_for_completion_interruptible(&rdma->cm_done);
+	if (rdma->state != P9_RDMA_ROUTE_RESOLVED)
+		goto error;
+
+	/* Query the device attributes */
+	err = ib_query_device(rdma->cm_id->device, &devattr);
+	if (err)
+		goto error;
+
+	/* Create the Completion Queue */
+	rdma->cq = ib_create_cq(rdma->cm_id->device, cq_comp_handler,
+				cq_event_handler, trans,
+				opts.sq_depth + opts.rq_depth + 1, 0);
+	if (IS_ERR(rdma->cq))
+		goto error;
+	ib_req_notify_cq(rdma->cq, IB_CQ_NEXT_COMP);
+
+	/* Create the Protection Domain */
+	rdma->pd = ib_alloc_pd(rdma->cm_id->device);
+	if (IS_ERR(rdma->pd))
+		goto error;
+
+	/* Cache the DMA lkey in the transport */
+	rdma->dma_mr = NULL;
+	if (0 == (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)) {
+		rdma->dma_mr = ib_get_dma_mr(rdma->pd, IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(rdma->dma_mr))
+			goto error;
+		rdma->lkey = rdma->dma_mr->lkey;
+	} else
+		rdma->lkey = rdma->cm_id->device->local_dma_lkey;
+
+	/* Create the Queue Pair */
+	memset(&qp_attr, 0, sizeof qp_attr);
+	qp_attr.event_handler = qp_event_handler;
+	qp_attr.qp_context = trans;
+	qp_attr.cap.max_send_wr = opts.sq_depth;
+	qp_attr.cap.max_recv_wr = opts.rq_depth;
+	qp_attr.cap.max_send_sge = P9_RDMA_SEND_SGE;
+	qp_attr.cap.max_recv_sge = P9_RDMA_RECV_SGE;
+	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
+	qp_attr.qp_type = IB_QPT_RC;
+	qp_attr.send_cq = rdma->cq;
+	qp_attr.recv_cq = rdma->cq;
+	err = rdma_create_qp(rdma->cm_id, rdma->pd, &qp_attr);
+	if (err)
+		goto error;
+	rdma->qp = rdma->cm_id->qp;
+
+	/* Request a connection */
+	memset(&conn_param, 0, sizeof(conn_param));
+	conn_param.private_data = NULL;
+	conn_param.private_data_len = 0;
+	conn_param.responder_resources = P9_RDMA_IRD;
+	conn_param.initiator_depth = P9_RDMA_ORD;
+	err = rdma_connect(rdma->cm_id, &conn_param);
+	if (err)
+		goto error;
+	wait_for_completion_interruptible(&rdma->cm_done);
+	if (rdma->state != P9_RDMA_CONNECTED)
+		goto error;
+
+	rdma->tagpool = p9_idpool_create();
+	if (IS_ERR(rdma->tagpool)) {
+		rdma->tagpool = NULL;
+		goto error;
+	}
+
+	return trans;
+
+error:
+	rdma_destroy_trans(trans);
+	return ERR_PTR(-ENOTCONN);
+}
+
+static struct p9_trans_module p9_rdma_trans = {
+	.name = "rdma",
+	.maxsize = P9_RDMA_MAXSIZE,
+	.def = 0,
+	.create = rdma_create_trans,
+};
+
+/**
+ * p9_trans_rdma_init - Register the 9P RDMA transport driver
+ */
+static int __init p9_trans_rdma_init(void)
+{
+	v9fs_register_trans(&p9_rdma_trans);
+	return 0;
+}
+
+static void __exit p9_trans_rdma_exit(void)
+{
+	v9fs_unregister_trans(&p9_rdma_trans);
+}
+
+module_init(p9_trans_rdma_init);
+module_exit(p9_trans_rdma_exit);
+
+MODULE_AUTHOR("Tom Tucker <tom@opengridcomputing.com>");
+MODULE_DESCRIPTION("RDMA Transport for 9P");
+MODULE_LICENSE("Dual BSD/GPL");
