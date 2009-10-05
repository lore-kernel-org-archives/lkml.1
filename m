Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZJEWxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZJEWxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZJEWxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:53:15 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49333 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZJEWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:52:52 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 11/21] ceph: OSD client
Date: Mon,  5 Oct 2009 15:50:41 -0700
Message-Id: <1254783051-26217-12-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1254783051-26217-11-git-send-email-sage@newdream.net>
References: <1254783051-26217-1-git-send-email-sage@newdream.net>
 <1254783051-26217-2-git-send-email-sage@newdream.net>
 <1254783051-26217-3-git-send-email-sage@newdream.net>
 <1254783051-26217-4-git-send-email-sage@newdream.net>
 <1254783051-26217-5-git-send-email-sage@newdream.net>
 <1254783051-26217-6-git-send-email-sage@newdream.net>
 <1254783051-26217-7-git-send-email-sage@newdream.net>
 <1254783051-26217-8-git-send-email-sage@newdream.net>
 <1254783051-26217-9-git-send-email-sage@newdream.net>
 <1254783051-26217-10-git-send-email-sage@newdream.net>
 <1254783051-26217-11-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OSD client is responsible for reading and writing data from/to the
object storage pool.  This includes determining where objects are
stored in the cluster, and ensuring that requests are retried or
redirected in the event of a node failure or data migration.

If an OSD does not respond before a timeout expires, keepalive
messages are sent across the lossless, ordered communications channel
to ensure that any break in the TCP is discovered.  If the session
does reset, a reconnection is attempted and affected requests are
resent (by the message transport layer).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/osd_client.c | 1294 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/osd_client.h |  144 ++++++
 fs/ceph/osdmap.c     |  875 ++++++++++++++++++++++++++++++++++
 fs/ceph/osdmap.h     |  123 +++++
 4 files changed, 2436 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/osd_client.c
 create mode 100644 fs/ceph/osd_client.h
 create mode 100644 fs/ceph/osdmap.c
 create mode 100644 fs/ceph/osdmap.h

diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
new file mode 100644
index 0000000..978593a
--- /dev/null
+++ b/fs/ceph/osd_client.c
@@ -0,0 +1,1294 @@
+#include "ceph_debug.h"
+
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "super.h"
+#include "osd_client.h"
+#include "messenger.h"
+#include "decode.h"
+
+const static struct ceph_connection_operations osd_con_ops;
+
+static void kick_requests(struct ceph_osd_client *osdc, struct ceph_osd *osd);
+
+/*
+ * Implement client access to distributed object storage cluster.
+ *
+ * All data objects are stored within a cluster/cloud of OSDs, or
+ * "object storage devices."  (Note that Ceph OSDs have _nothing_ to
+ * do with the T10 OSD extensions to SCSI.)  Ceph OSDs are simply
+ * remote daemons serving up and coordinating consistent and safe
+ * access to storage.
+ *
+ * Cluster membership and the mapping of data objects onto storage devices
+ * are described by the osd map.
+ *
+ * We keep track of pending OSD requests (read, write), resubmit
+ * requests to different OSDs when the cluster topology/data layout
+ * change, or retry the affected requests when the communications
+ * channel with an OSD is reset.
+ */
+
+/*
+ * calculate the mapping of a file extent onto an object, and fill out the
+ * request accordingly.  shorten extent as necessary if it crosses an
+ * object boundary.
+ *
+ * fill osd op in request message.
+ */
+static void calc_layout(struct ceph_osd_client *osdc,
+			struct ceph_vino vino, struct ceph_file_layout *layout,
+			u64 off, u64 *plen,
+			struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
+	struct ceph_osd_op *op = (void *)(reqhead + 1);
+	u64 orig_len = *plen;
+	u64 objoff, objlen;    /* extent in object */
+	u64 bno;
+
+	reqhead->snapid = cpu_to_le64(vino.snap);
+
+	/* object extent? */
+	ceph_calc_file_object_mapping(layout, off, plen, &bno,
+				      &objoff, &objlen);
+	if (*plen < orig_len)
+		dout(" skipping last %llu, final file extent %llu~%llu\n",
+		     orig_len - *plen, off, *plen);
+
+	sprintf(req->r_oid, "%llx.%08llx", vino.ino, bno);
+	req->r_oid_len = strlen(req->r_oid);
+
+	op->extent.offset = cpu_to_le64(objoff);
+	op->extent.length = cpu_to_le64(objlen);
+	req->r_num_pages = calc_pages_for(off, *plen);
+
+	dout("calc_layout %s (%d) %llu~%llu (%d pages)\n",
+	     req->r_oid, req->r_oid_len, objoff, objlen, req->r_num_pages);
+}
+
+
+/*
+ * requests
+ */
+void ceph_osdc_put_request(struct ceph_osd_request *req)
+{
+	dout("osdc put_request %p %d -> %d\n", req, atomic_read(&req->r_ref),
+	     atomic_read(&req->r_ref)-1);
+	BUG_ON(atomic_read(&req->r_ref) <= 0);
+	if (atomic_dec_and_test(&req->r_ref)) {
+		if (req->r_request)
+			ceph_msg_put(req->r_request);
+		if (req->r_reply)
+			ceph_msg_put(req->r_reply);
+		if (req->r_own_pages)
+			ceph_release_page_vector(req->r_pages,
+						 req->r_num_pages);
+		ceph_put_snap_context(req->r_snapc);
+		if (req->r_mempool)
+			mempool_free(req, req->r_osdc->req_mempool);
+		else
+			kfree(req);
+	}
+}
+
+/*
+ * build new request AND message, calculate layout, and adjust file
+ * extent as needed.
+ *
+ * if the file was recently truncated, we include information about its
+ * old and new size so that the object can be updated appropriately.  (we
+ * avoid synchronously deleting truncated objects because it's slow.)
+ *
+ * if @do_sync, include a 'startsync' command so that the osd will flush
+ * data quickly.
+ */
+struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
+					       struct ceph_file_layout *layout,
+					       struct ceph_vino vino,
+					       u64 off, u64 *plen,
+					       int opcode, int flags,
+					       struct ceph_snap_context *snapc,
+					       int do_sync,
+					       u32 truncate_seq,
+					       u64 truncate_size,
+					       struct timespec *mtime,
+					       bool use_mempool, int num_reply)
+{
+	struct ceph_osd_request *req;
+	struct ceph_msg *msg;
+	struct ceph_osd_request_head *head;
+	struct ceph_osd_op *op;
+	void *p;
+	int do_trunc = truncate_seq && (off + *plen > truncate_size);
+	int num_op = 1 + do_sync + do_trunc;
+	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
+	int err, i;
+	u64 prevofs;
+
+	if (use_mempool) {
+		req = mempool_alloc(osdc->req_mempool, GFP_NOFS);
+		memset(req, 0, sizeof(*req));
+	} else {
+		req = kzalloc(sizeof(*req), GFP_NOFS);
+	}
+	if (req == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	err = ceph_msgpool_resv(&osdc->msgpool_op_reply, num_reply);
+	if (err) {
+		ceph_osdc_put_request(req);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	req->r_osdc = osdc;
+	req->r_mempool = use_mempool;
+	atomic_set(&req->r_ref, 1);
+	init_completion(&req->r_completion);
+	init_completion(&req->r_safe_completion);
+	INIT_LIST_HEAD(&req->r_unsafe_item);
+	req->r_flags = flags;
+
+	WARN_ON((flags & (CEPH_OSD_FLAG_READ|CEPH_OSD_FLAG_WRITE)) == 0);
+
+	/* create message; allow space for oid */
+	msg_size += 40;
+	if (snapc)
+		msg_size += sizeof(u64) * snapc->num_snaps;
+	if (use_mempool)
+		msg = ceph_msgpool_get(&osdc->msgpool_op);
+	else
+		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, 0, 0, NULL);
+	if (IS_ERR(msg)) {
+		ceph_msgpool_resv(&osdc->msgpool_op_reply, num_reply);
+		ceph_osdc_put_request(req);
+		return ERR_PTR(PTR_ERR(msg));
+	}
+	msg->hdr.type = cpu_to_le16(CEPH_MSG_OSD_OP);
+	memset(msg->front.iov_base, 0, msg->front.iov_len);
+	head = msg->front.iov_base;
+	op = (void *)(head + 1);
+	p = (void *)(op + num_op);
+
+	req->r_request = msg;
+	req->r_snapc = ceph_get_snap_context(snapc);
+
+	head->client_inc = cpu_to_le32(1); /* always, for now. */
+	head->flags = cpu_to_le32(flags);
+	if (flags & CEPH_OSD_FLAG_WRITE)
+		ceph_encode_timespec(&head->mtime, mtime);
+	head->num_ops = cpu_to_le16(num_op);
+	op->op = cpu_to_le16(opcode);
+
+	/* calculate max write size */
+	calc_layout(osdc, vino, layout, off, plen, req);
+	req->r_file_layout = *layout;  /* keep a copy */
+
+	if (flags & CEPH_OSD_FLAG_WRITE) {
+		req->r_request->hdr.data_off = cpu_to_le16(off);
+		req->r_request->hdr.data_len = cpu_to_le32(*plen);
+		op->payload_len = cpu_to_le32(*plen);
+	}
+
+	/* fill in oid */
+	head->object_len = cpu_to_le32(req->r_oid_len);
+	memcpy(p, req->r_oid, req->r_oid_len);
+	p += req->r_oid_len;
+
+	/* additional ops */
+	if (do_trunc) {
+		op++;
+		op->op = cpu_to_le16(opcode == CEPH_OSD_OP_READ ?
+			     CEPH_OSD_OP_MASKTRUNC : CEPH_OSD_OP_SETTRUNC);
+		op->trunc.truncate_seq = cpu_to_le32(truncate_seq);
+		prevofs = le64_to_cpu((op-1)->extent.offset);
+		op->trunc.truncate_size = cpu_to_le64(truncate_size -
+						      (off-prevofs));
+	}
+	if (do_sync) {
+		op++;
+		op->op = cpu_to_le16(CEPH_OSD_OP_STARTSYNC);
+	}
+	if (snapc) {
+		head->snap_seq = cpu_to_le64(snapc->seq);
+		head->num_snaps = cpu_to_le32(snapc->num_snaps);
+		for (i = 0; i < snapc->num_snaps; i++) {
+			put_unaligned_le64(snapc->snaps[i], p);
+			p += sizeof(u64);
+		}
+	}
+
+	BUG_ON(p > msg->front.iov_base + msg->front.iov_len);
+	return req;
+}
+
+/*
+ * We keep osd requests in an rbtree, sorted by ->r_tid.
+ */
+static void __insert_request(struct ceph_osd_client *osdc,
+			     struct ceph_osd_request *new)
+{
+	struct rb_node **p = &osdc->requests.rb_node;
+	struct rb_node *parent = NULL;
+	struct ceph_osd_request *req = NULL;
+
+	while (*p) {
+		parent = *p;
+		req = rb_entry(parent, struct ceph_osd_request, r_node);
+		if (new->r_tid < req->r_tid)
+			p = &(*p)->rb_left;
+		else if (new->r_tid > req->r_tid)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&new->r_node, parent, p);
+	rb_insert_color(&new->r_node, &osdc->requests);
+}
+
+static struct ceph_osd_request *__lookup_request(struct ceph_osd_client *osdc,
+						 u64 tid)
+{
+	struct ceph_osd_request *req;
+	struct rb_node *n = osdc->requests.rb_node;
+
+	while (n) {
+		req = rb_entry(n, struct ceph_osd_request, r_node);
+		if (tid < req->r_tid)
+			n = n->rb_left;
+		else if (tid > req->r_tid)
+			n = n->rb_right;
+		else
+			return req;
+	}
+	return NULL;
+}
+
+static struct ceph_osd_request *
+__lookup_request_ge(struct ceph_osd_client *osdc,
+		    u64 tid)
+{
+	struct ceph_osd_request *req;
+	struct rb_node *n = osdc->requests.rb_node;
+
+	while (n) {
+		req = rb_entry(n, struct ceph_osd_request, r_node);
+		if (tid < req->r_tid) {
+			if (!n->rb_left)
+				return req;
+			n = n->rb_left;
+		} else if (tid > req->r_tid) {
+			n = n->rb_right;
+		} else {
+			return req;
+		}
+	}
+	return NULL;
+}
+
+
+/*
+ * The messaging layer will reconnect to the osd as needed.  If the
+ * session has dropped, the OSD will have dropped the session state,
+ * and we'll get notified by the messaging layer.  If that happens, we
+ * need to resubmit all requests for that osd.
+ */
+static void osd_reset(struct ceph_connection *con)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc;
+
+	if (!osd)
+		return;
+	dout("osd_reset osd%d\n", osd->o_osd);
+	osdc = osd->o_osdc;
+	osd->o_incarnation++;
+	down_read(&osdc->map_sem);
+	kick_requests(osdc, osd);
+	up_read(&osdc->map_sem);
+}
+
+/*
+ * Track open sessions with osds.
+ */
+static struct ceph_osd *create_osd(struct ceph_osd_client *osdc)
+{
+	struct ceph_osd *osd;
+
+	osd = kzalloc(sizeof(*osd), GFP_NOFS);
+	if (!osd)
+		return NULL;
+
+	atomic_set(&osd->o_ref, 1);
+	osd->o_osdc = osdc;
+	INIT_LIST_HEAD(&osd->o_requests);
+	osd->o_incarnation = 1;
+
+	ceph_con_init(osdc->client->msgr, &osd->o_con);
+	osd->o_con.private = osd;
+	osd->o_con.ops = &osd_con_ops;
+	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
+	return osd;
+}
+
+static struct ceph_osd *get_osd(struct ceph_osd *osd)
+{
+	if (atomic_inc_not_zero(&osd->o_ref)) {
+		dout("get_osd %p %d -> %d\n", osd, atomic_read(&osd->o_ref)-1,
+		     atomic_read(&osd->o_ref));
+		return osd;
+	} else {
+		dout("get_osd %p FAIL\n", osd);
+		return NULL;
+	}
+}
+
+static void put_osd(struct ceph_osd *osd)
+{
+	dout("put_osd %p %d -> %d\n", osd, atomic_read(&osd->o_ref),
+	     atomic_read(&osd->o_ref) - 1);
+	if (atomic_dec_and_test(&osd->o_ref)) {
+		ceph_con_shutdown(&osd->o_con);
+		kfree(osd);
+	}
+}
+
+/*
+ * remove an osd from our map
+ */
+static void remove_osd(struct ceph_osd_client *osdc, struct ceph_osd *osd)
+{
+	dout("remove_osd %p\n", osd);
+	BUG_ON(!list_empty(&osd->o_requests));
+	rb_erase(&osd->o_node, &osdc->osds);
+	ceph_con_close(&osd->o_con);
+	put_osd(osd);
+}
+
+/*
+ * reset osd connect
+ */
+static int reset_osd(struct ceph_osd_client *osdc, struct ceph_osd *osd)
+{
+	int ret = 0;
+
+	dout("reset_osd %p osd%d\n", osd, osd->o_osd);
+	if (list_empty(&osd->o_requests)) {
+		remove_osd(osdc, osd);
+	} else {
+		ceph_con_close(&osd->o_con);
+		ceph_con_open(&osd->o_con, &osdc->osdmap->osd_addr[osd->o_osd]);
+		osd->o_incarnation++;
+	}
+	return ret;
+}
+
+static void __insert_osd(struct ceph_osd_client *osdc, struct ceph_osd *new)
+{
+	struct rb_node **p = &osdc->osds.rb_node;
+	struct rb_node *parent = NULL;
+	struct ceph_osd *osd = NULL;
+
+	while (*p) {
+		parent = *p;
+		osd = rb_entry(parent, struct ceph_osd, o_node);
+		if (new->o_osd < osd->o_osd)
+			p = &(*p)->rb_left;
+		else if (new->o_osd > osd->o_osd)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&new->o_node, parent, p);
+	rb_insert_color(&new->o_node, &osdc->osds);
+}
+
+static struct ceph_osd *__lookup_osd(struct ceph_osd_client *osdc, int o)
+{
+	struct ceph_osd *osd;
+	struct rb_node *n = osdc->osds.rb_node;
+
+	while (n) {
+		osd = rb_entry(n, struct ceph_osd, o_node);
+		if (o < osd->o_osd)
+			n = n->rb_left;
+		else if (o > osd->o_osd)
+			n = n->rb_right;
+		else
+			return osd;
+	}
+	return NULL;
+}
+
+
+/*
+ * Register request, assign tid.  If this is the first request, set up
+ * the timeout event.
+ */
+static void register_request(struct ceph_osd_client *osdc,
+			     struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *head = req->r_request->front.iov_base;
+
+	mutex_lock(&osdc->request_mutex);
+	req->r_tid = ++osdc->last_tid;
+	head->tid = cpu_to_le64(req->r_tid);
+
+	dout("register_request %p tid %lld\n", req, req->r_tid);
+	__insert_request(osdc, req);
+	ceph_osdc_get_request(req);
+	osdc->num_requests++;
+
+	req->r_timeout_stamp =
+		jiffies + osdc->client->mount_args.osd_timeout*HZ;
+
+	if (osdc->num_requests == 1) {
+		osdc->timeout_tid = req->r_tid;
+		dout("  timeout on tid %llu at %lu\n", req->r_tid,
+		     req->r_timeout_stamp);
+		schedule_delayed_work(&osdc->timeout_work,
+		      round_jiffies_relative(req->r_timeout_stamp - jiffies));
+	}
+	mutex_unlock(&osdc->request_mutex);
+}
+
+/*
+ * called under osdc->request_mutex
+ */
+static void __unregister_request(struct ceph_osd_client *osdc,
+				 struct ceph_osd_request *req)
+{
+	dout("__unregister_request %p tid %lld\n", req, req->r_tid);
+	rb_erase(&req->r_node, &osdc->requests);
+	osdc->num_requests--;
+
+	list_del_init(&req->r_osd_item);
+	if (list_empty(&req->r_osd->o_requests))
+		remove_osd(osdc, req->r_osd);
+	req->r_osd = NULL;
+
+	ceph_osdc_put_request(req);
+
+	if (req->r_tid == osdc->timeout_tid) {
+		if (osdc->num_requests == 0) {
+			dout("no requests, canceling timeout\n");
+			osdc->timeout_tid = 0;
+			cancel_delayed_work(&osdc->timeout_work);
+		} else {
+			req = rb_entry(rb_first(&osdc->requests),
+				       struct ceph_osd_request, r_node);
+			osdc->timeout_tid = req->r_tid;
+			dout("rescheduled timeout on tid %llu at %lu\n",
+			     req->r_tid, req->r_timeout_stamp);
+			schedule_delayed_work(&osdc->timeout_work,
+			      round_jiffies_relative(req->r_timeout_stamp -
+						     jiffies));
+		}
+	}
+}
+
+/*
+ * Cancel a previously queued request message
+ */
+static void __cancel_request(struct ceph_osd_request *req)
+{
+	if (req->r_sent) {
+		ceph_con_revoke(&req->r_osd->o_con, req->r_request);
+		req->r_sent = 0;
+	}
+}
+
+/*
+ * Pick an osd (the first 'up' osd in the pg), allocate the osd struct
+ * (as needed), and set the request r_osd appropriately.  If there is
+ * no up osd, set r_osd to NULL.
+ *
+ * Return 0 if unchanged, 1 if changed, or negative on error.
+ *
+ * Caller should hold map_sem for read and request_mutex.
+ */
+static int __map_osds(struct ceph_osd_client *osdc,
+		      struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
+	union ceph_pg pgid;
+	int o = -1;
+	int err;
+	struct ceph_osd *newosd = NULL;
+
+	dout("map_osds %p tid %lld\n", req, req->r_tid);
+	err = ceph_calc_object_layout(&reqhead->layout, req->r_oid,
+				      &req->r_file_layout, osdc->osdmap);
+	if (err)
+		return err;
+	pgid.pg64 = le64_to_cpu(reqhead->layout.ol_pgid);
+	o = ceph_calc_pg_primary(osdc->osdmap, pgid);
+
+	if ((req->r_osd && req->r_osd->o_osd == o &&
+	     req->r_sent >= req->r_osd->o_incarnation) ||
+	    (req->r_osd == NULL && o == -1))
+		return 0;  /* no change */
+
+	dout("map_osds tid %llu pgid %llx pool %d osd%d (was osd%d)\n",
+	     req->r_tid, pgid.pg64, pgid.pg.pool, o,
+	     req->r_osd ? req->r_osd->o_osd : -1);
+
+	if (req->r_osd) {
+		__cancel_request(req);
+		list_del_init(&req->r_osd_item);
+		if (list_empty(&req->r_osd->o_requests)) {
+			/* try to re-use r_osd if possible */
+			newosd = get_osd(req->r_osd);
+			remove_osd(osdc, newosd);
+		}
+		req->r_osd = NULL;
+	}
+
+	req->r_osd = __lookup_osd(osdc, o);
+	if (!req->r_osd && o >= 0) {
+		if (newosd) {
+			req->r_osd = newosd;
+			newosd = NULL;
+		} else {
+			err = -ENOMEM;
+			req->r_osd = create_osd(osdc);
+			if (!req->r_osd)
+				goto out;
+		}
+
+		dout("map_osds osd %p is osd%d\n", req->r_osd, o);
+		req->r_osd->o_osd = o;
+		req->r_osd->o_con.peer_name.num = cpu_to_le64(o);
+		__insert_osd(osdc, req->r_osd);
+
+		ceph_con_open(&req->r_osd->o_con, &osdc->osdmap->osd_addr[o]);
+	}
+
+	if (req->r_osd)
+		list_add(&req->r_osd_item, &req->r_osd->o_requests);
+	err = 1;   /* osd changed */
+
+out:
+	if (newosd)
+		put_osd(newosd);
+	return err;
+}
+
+/*
+ * caller should hold map_sem (for read) and request_mutex
+ */
+static int __send_request(struct ceph_osd_client *osdc,
+			  struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead;
+	int err;
+
+	err = __map_osds(osdc, req);
+	if (err < 0)
+		return err;
+	if (req->r_osd == NULL) {
+		dout("send_request %p no up osds in pg\n", req);
+		ceph_monc_request_next_osdmap(&osdc->client->monc);
+		return 0;
+	}
+
+	dout("send_request %p tid %llu to osd%d flags %d\n",
+	     req, req->r_tid, req->r_osd->o_osd, req->r_flags);
+
+	reqhead = req->r_request->front.iov_base;
+	reqhead->osdmap_epoch = cpu_to_le32(osdc->osdmap->epoch);
+	reqhead->flags |= cpu_to_le32(req->r_flags);  /* e.g., RETRY */
+	reqhead->reassert_version = req->r_reassert_version;
+
+	req->r_timeout_stamp = jiffies+osdc->client->mount_args.osd_timeout*HZ;
+
+	ceph_msg_get(req->r_request); /* send consumes a ref */
+	ceph_con_send(&req->r_osd->o_con, req->r_request);
+	req->r_sent = req->r_osd->o_incarnation;
+	return 0;
+}
+
+/*
+ * Timeout callback, called every N seconds when 1 or more osd
+ * requests has been active for more than N seconds.  When this
+ * happens, we ping all OSDs with requests who have timed out to
+ * ensure any communications channel reset is detected.  Reset the
+ * request timeouts another N seconds in the future as we go.
+ * Reschedule the timeout event another N seconds in future (unless
+ * there are no open requests).
+ */
+static void handle_timeout(struct work_struct *work)
+{
+	struct ceph_osd_client *osdc =
+		container_of(work, struct ceph_osd_client, timeout_work.work);
+	struct ceph_osd_request *req;
+	struct ceph_osd *osd;
+	unsigned long timeout = osdc->client->mount_args.osd_timeout * HZ;
+	unsigned long next_timeout = timeout + jiffies;
+	struct rb_node *p;
+
+	dout("timeout\n");
+	down_read(&osdc->map_sem);
+
+	ceph_monc_request_next_osdmap(&osdc->client->monc);
+
+	mutex_lock(&osdc->request_mutex);
+	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+		req = rb_entry(p, struct ceph_osd_request, r_node);
+
+		if (req->r_resend) {
+			int err;
+
+			dout("osdc resending prev failed %lld\n", req->r_tid);
+			err = __send_request(osdc, req);
+			if (err)
+				dout("osdc failed again on %lld\n", req->r_tid);
+			else
+				req->r_resend = false;
+			continue;
+		}
+	}
+	for (p = rb_first(&osdc->osds); p; p = rb_next(p)) {
+		osd = rb_entry(p, struct ceph_osd, o_node);
+		if (list_empty(&osd->o_requests))
+			continue;
+		req = list_first_entry(&osd->o_requests,
+				       struct ceph_osd_request, r_osd_item);
+		if (time_before(jiffies, req->r_timeout_stamp))
+			continue;
+
+		dout(" tid %llu (at least) timed out on osd%d\n",
+		     req->r_tid, osd->o_osd);
+		req->r_timeout_stamp = next_timeout;
+		ceph_con_keepalive(&osd->o_con);
+	}
+
+	if (osdc->timeout_tid)
+		schedule_delayed_work(&osdc->timeout_work,
+				      round_jiffies_relative(timeout));
+
+	mutex_unlock(&osdc->request_mutex);
+
+	up_read(&osdc->map_sem);
+}
+
+/*
+ * handle osd op reply.  either call the callback if it is specified,
+ * or do the completion to wake up the waiting thread.
+ */
+static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg)
+{
+	struct ceph_osd_reply_head *rhead = msg->front.iov_base;
+	struct ceph_osd_request *req;
+	u64 tid;
+	int numops, object_len, flags;
+
+	if (msg->front.iov_len < sizeof(*rhead))
+		goto bad;
+	tid = le64_to_cpu(rhead->tid);
+	numops = le32_to_cpu(rhead->num_ops);
+	object_len = le32_to_cpu(rhead->object_len);
+	if (msg->front.iov_len != sizeof(*rhead) + object_len +
+	    numops * sizeof(struct ceph_osd_op))
+		goto bad;
+	dout("handle_reply %p tid %llu\n", msg, tid);
+
+	/* lookup */
+	mutex_lock(&osdc->request_mutex);
+	req = __lookup_request(osdc, tid);
+	if (req == NULL) {
+		dout("handle_reply tid %llu dne\n", tid);
+		mutex_unlock(&osdc->request_mutex);
+		return;
+	}
+	ceph_osdc_get_request(req);
+	flags = le32_to_cpu(rhead->flags);
+
+	if (req->r_reply) {
+		/*
+		 * once we see the message has been received, we don't
+		 * need a ref (which is only needed for revoking
+		 * pages)
+		 */
+		ceph_msg_put(req->r_reply);
+		req->r_reply = NULL;
+	}
+
+	if (!req->r_got_reply) {
+		unsigned bytes;
+
+		req->r_result = le32_to_cpu(rhead->result);
+		bytes = le32_to_cpu(msg->hdr.data_len);
+		dout("handle_reply result %d bytes %d\n", req->r_result,
+		     bytes);
+		if (req->r_result == 0)
+			req->r_result = bytes;
+
+		/* in case this is a write and we need to replay, */
+		req->r_reassert_version = rhead->reassert_version;
+
+		req->r_got_reply = 1;
+	} else if ((flags & CEPH_OSD_FLAG_ONDISK) == 0) {
+		dout("handle_reply tid %llu dup ack\n", tid);
+		goto done;
+	}
+
+	dout("handle_reply tid %llu flags %d\n", tid, flags);
+
+	/* either this is a read, or we got the safe response */
+	if ((flags & CEPH_OSD_FLAG_ONDISK) ||
+	    ((flags & CEPH_OSD_FLAG_WRITE) == 0))
+		__unregister_request(osdc, req);
+
+	mutex_unlock(&osdc->request_mutex);
+
+	if (req->r_callback)
+		req->r_callback(req, msg);
+	else
+		complete(&req->r_completion);
+
+	if (flags & CEPH_OSD_FLAG_ONDISK) {
+		if (req->r_safe_callback)
+			req->r_safe_callback(req, msg);
+		complete(&req->r_safe_completion);  /* fsync waiter */
+	}
+
+done:
+	ceph_osdc_put_request(req);
+	return;
+
+bad:
+	pr_err("corrupt osd_op_reply got %d %d expected %d\n",
+	       (int)msg->front.iov_len, le32_to_cpu(msg->hdr.front_len),
+	       (int)sizeof(*rhead));
+}
+
+
+/*
+ * Resubmit osd requests whose osd or osd address has changed.  Request
+ * a new osd map if osds are down, or we are otherwise unable to determine
+ * how to direct a request.
+ *
+ * Close connections to down osds.
+ *
+ * If @who is specified, resubmit requests for that specific osd.
+ *
+ * Caller should hold map_sem for read and request_mutex.
+ */
+static void kick_requests(struct ceph_osd_client *osdc,
+			  struct ceph_osd *kickosd)
+{
+	struct ceph_osd_request *req;
+	struct rb_node *p, *n;
+	int needmap = 0;
+	int err;
+
+	dout("kick_requests osd%d\n", kickosd ? kickosd->o_osd : -1);
+	mutex_lock(&osdc->request_mutex);
+	if (!kickosd) {
+		for (p = rb_first(&osdc->osds); p; p = n) {
+			struct ceph_osd *osd =
+				rb_entry(p, struct ceph_osd, o_node);
+
+			n = rb_next(p);
+			if (!ceph_osd_is_up(osdc->osdmap, osd->o_osd) ||
+			    !ceph_entity_addr_equal(&osd->o_con.peer_addr,
+					    ceph_osd_addr(osdc->osdmap,
+							  osd->o_osd)))
+				reset_osd(osdc, osd);
+		}
+	}
+
+	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+		req = rb_entry(p, struct ceph_osd_request, r_node);
+
+		if (req->r_resend) {
+			dout(" r_resend set on tid %llu\n", req->r_tid);
+			goto kick;
+		}
+		if (req->r_osd && kickosd == req->r_osd)
+			goto kick;
+
+		err = __map_osds(osdc, req);
+		if (err == 0)
+			continue;  /* no change */
+		if (err < 0) {
+			/*
+			 * FIXME: really, we should set the request
+			 * error and fail if this isn't a 'nofail'
+			 * request, but that's a fair bit more
+			 * complicated to do.  So retry!
+			 */
+			dout(" setting r_resend on %llu\n", req->r_tid);
+			req->r_resend = true;
+			continue;
+		}
+		if (req->r_osd == NULL) {
+			dout("tid %llu maps to no valid osd\n", req->r_tid);
+			needmap++;  /* request a newer map */
+			continue;
+		}
+
+kick:
+		dout("kicking tid %llu osd%d\n", req->r_tid, req->r_osd->o_osd);
+		req->r_flags |= CEPH_OSD_FLAG_RETRY;
+		err = __send_request(osdc, req);
+		if (err) {
+			dout(" setting r_resend on %llu\n", req->r_tid);
+			req->r_resend = true;
+		}
+	}
+	mutex_unlock(&osdc->request_mutex);
+
+	if (needmap) {
+		dout("%d requests for down osds, need new map\n", needmap);
+		ceph_monc_request_next_osdmap(&osdc->client->monc);
+	}
+}
+
+/*
+ * Process updated osd map.
+ *
+ * The message contains any number of incremental and full maps, normally
+ * indicating some sort of topology change in the cluster.  Kick requests
+ * off to different OSDs as needed.
+ */
+void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
+{
+	void *p, *end, *next;
+	u32 nr_maps, maplen;
+	u32 epoch;
+	struct ceph_osdmap *newmap = NULL, *oldmap;
+	int err;
+	struct ceph_fsid fsid;
+
+	dout("handle_map have %u\n", osdc->osdmap ? osdc->osdmap->epoch : 0);
+	p = msg->front.iov_base;
+	end = p + msg->front.iov_len;
+
+	/* verify fsid */
+	ceph_decode_need(&p, end, sizeof(fsid), bad);
+	ceph_decode_copy(&p, &fsid, sizeof(fsid));
+	if (ceph_fsid_compare(&fsid, &osdc->client->monc.monmap->fsid)) {
+		pr_err("got osdmap with wrong fsid, ignoring\n");
+		return;
+	}
+
+	down_write(&osdc->map_sem);
+
+	/* incremental maps */
+	ceph_decode_32_safe(&p, end, nr_maps, bad);
+	dout(" %d inc maps\n", nr_maps);
+	while (nr_maps > 0) {
+		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
+		ceph_decode_32(&p, epoch);
+		ceph_decode_32(&p, maplen);
+		ceph_decode_need(&p, end, maplen, bad);
+		next = p + maplen;
+		if (osdc->osdmap && osdc->osdmap->epoch+1 == epoch) {
+			dout("applying incremental map %u len %d\n",
+			     epoch, maplen);
+			newmap = osdmap_apply_incremental(&p, next,
+							  osdc->osdmap,
+							  osdc->client->msgr);
+			if (IS_ERR(newmap)) {
+				err = PTR_ERR(newmap);
+				goto bad;
+			}
+			if (newmap != osdc->osdmap) {
+				ceph_osdmap_destroy(osdc->osdmap);
+				osdc->osdmap = newmap;
+			}
+		} else {
+			dout("ignoring incremental map %u len %d\n",
+			     epoch, maplen);
+		}
+		p = next;
+		nr_maps--;
+	}
+	if (newmap)
+		goto done;
+
+	/* full maps */
+	ceph_decode_32_safe(&p, end, nr_maps, bad);
+	dout(" %d full maps\n", nr_maps);
+	while (nr_maps) {
+		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
+		ceph_decode_32(&p, epoch);
+		ceph_decode_32(&p, maplen);
+		ceph_decode_need(&p, end, maplen, bad);
+		if (nr_maps > 1) {
+			dout("skipping non-latest full map %u len %d\n",
+			     epoch, maplen);
+		} else if (osdc->osdmap && osdc->osdmap->epoch >= epoch) {
+			dout("skipping full map %u len %d, "
+			     "older than our %u\n", epoch, maplen,
+			     osdc->osdmap->epoch);
+		} else {
+			dout("taking full map %u len %d\n", epoch, maplen);
+			newmap = osdmap_decode(&p, p+maplen);
+			if (IS_ERR(newmap)) {
+				err = PTR_ERR(newmap);
+				goto bad;
+			}
+			oldmap = osdc->osdmap;
+			osdc->osdmap = newmap;
+			if (oldmap)
+				ceph_osdmap_destroy(oldmap);
+		}
+		p += maplen;
+		nr_maps--;
+	}
+
+done:
+	downgrade_write(&osdc->map_sem);
+	ceph_monc_got_osdmap(&osdc->client->monc, osdc->osdmap->epoch);
+	if (newmap)
+		kick_requests(osdc, NULL);
+	up_read(&osdc->map_sem);
+	return;
+
+bad:
+	pr_err("osdc handle_map corrupt msg\n");
+	up_write(&osdc->map_sem);
+	return;
+}
+
+
+/*
+ * A read request prepares specific pages that data is to be read into.
+ * When a message is being read off the wire, we call prepare_pages to
+ * find those pages.
+ *  0 = success, -1 failure.
+ */
+static int prepare_pages(struct ceph_connection *con, struct ceph_msg *m,
+			 int want)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc;
+	struct ceph_osd_reply_head *rhead = m->front.iov_base;
+	struct ceph_osd_request *req;
+	u64 tid;
+	int ret = -1;
+	int type = le16_to_cpu(m->hdr.type);
+
+	if (!osd)
+		return -1;
+	osdc = osd->o_osdc;
+
+	dout("prepare_pages on msg %p want %d\n", m, want);
+	if (unlikely(type != CEPH_MSG_OSD_OPREPLY))
+		return -1;  /* hmm! */
+
+	tid = le64_to_cpu(rhead->tid);
+	mutex_lock(&osdc->request_mutex);
+	req = __lookup_request(osdc, tid);
+	if (!req) {
+		dout("prepare_pages unknown tid %llu\n", tid);
+		goto out;
+	}
+	dout("prepare_pages tid %llu has %d pages, want %d\n",
+	     tid, req->r_num_pages, want);
+	if (likely(req->r_num_pages >= want && !req->r_prepared_pages)) {
+		m->pages = req->r_pages;
+		m->nr_pages = req->r_num_pages;
+		req->r_reply = m;  /* only for duration of read over socket */
+		ceph_msg_get(m);
+		req->r_prepared_pages = 1;
+		ret = 0; /* success */
+	}
+out:
+	mutex_unlock(&osdc->request_mutex);
+	return ret;
+}
+
+/*
+ * Register request, send initial attempt.
+ */
+int ceph_osdc_start_request(struct ceph_osd_client *osdc,
+			    struct ceph_osd_request *req,
+			    bool nofail)
+{
+	int rc;
+
+	req->r_request->pages = req->r_pages;
+	req->r_request->nr_pages = req->r_num_pages;
+
+	register_request(osdc, req);
+
+	down_read(&osdc->map_sem);
+	mutex_lock(&osdc->request_mutex);
+	rc = __send_request(osdc, req);
+	if (rc) {
+		if (nofail) {
+			dout("osdc_start_request failed send, marking %lld\n",
+			     req->r_tid);
+			req->r_resend = true;
+			rc = 0;
+		} else {
+			__unregister_request(osdc, req);
+		}
+	}
+	mutex_unlock(&osdc->request_mutex);
+	up_read(&osdc->map_sem);
+	return rc;
+}
+
+/*
+ * wait for a request to complete
+ */
+int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
+			   struct ceph_osd_request *req)
+{
+	int rc;
+
+	rc = wait_for_completion_interruptible(&req->r_completion);
+	if (rc < 0) {
+		mutex_lock(&osdc->request_mutex);
+		__cancel_request(req);
+		mutex_unlock(&osdc->request_mutex);
+		dout("wait_request tid %llu timed out\n", req->r_tid);
+		return rc;
+	}
+
+	dout("wait_request tid %llu result %d\n", req->r_tid, req->r_result);
+	return req->r_result;
+}
+
+/*
+ * sync - wait for all in-flight requests to flush.  avoid starvation.
+ */
+void ceph_osdc_sync(struct ceph_osd_client *osdc)
+{
+	struct ceph_osd_request *req;
+	u64 last_tid, next_tid = 0;
+
+	mutex_lock(&osdc->request_mutex);
+	last_tid = osdc->last_tid;
+	while (1) {
+		req = __lookup_request_ge(osdc, next_tid);
+		if (!req)
+			break;
+		if (req->r_tid > last_tid)
+			break;
+
+		next_tid = req->r_tid + 1;
+		if ((req->r_flags & CEPH_OSD_FLAG_WRITE) == 0)
+			continue;
+
+		ceph_osdc_get_request(req);
+		mutex_unlock(&osdc->request_mutex);
+		dout("sync waiting on tid %llu (last is %llu)\n",
+		     req->r_tid, last_tid);
+		wait_for_completion(&req->r_safe_completion);
+		mutex_lock(&osdc->request_mutex);
+		ceph_osdc_put_request(req);
+	}
+	mutex_unlock(&osdc->request_mutex);
+	dout("sync done (thru tid %llu)\n", last_tid);
+}
+
+/*
+ * init, shutdown
+ */
+int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
+{
+	int err;
+
+	dout("init\n");
+	osdc->client = client;
+	osdc->osdmap = NULL;
+	init_rwsem(&osdc->map_sem);
+	init_completion(&osdc->map_waiters);
+	osdc->last_requested_map = 0;
+	mutex_init(&osdc->request_mutex);
+	osdc->timeout_tid = 0;
+	osdc->last_tid = 0;
+	osdc->osds = RB_ROOT;
+	osdc->requests = RB_ROOT;
+	osdc->num_requests = 0;
+	INIT_DELAYED_WORK(&osdc->timeout_work, handle_timeout);
+
+	osdc->req_mempool = mempool_create_kmalloc_pool(10,
+					sizeof(struct ceph_osd_request));
+	if (!osdc->req_mempool)
+		return -ENOMEM;
+
+	err = ceph_msgpool_init(&osdc->msgpool_op, 4096, 10, true);
+	if (err < 0)
+		return -ENOMEM;
+	err = ceph_msgpool_init(&osdc->msgpool_op_reply, 512, 0, false);
+	if (err < 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void ceph_osdc_stop(struct ceph_osd_client *osdc)
+{
+	cancel_delayed_work_sync(&osdc->timeout_work);
+	if (osdc->osdmap) {
+		ceph_osdmap_destroy(osdc->osdmap);
+		osdc->osdmap = NULL;
+	}
+	mempool_destroy(osdc->req_mempool);
+	ceph_msgpool_destroy(&osdc->msgpool_op);
+	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
+}
+
+/*
+ * Read some contiguous pages.  If we cross a stripe boundary, shorten
+ * *plen.  Return number of bytes read, or error.
+ */
+int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			struct ceph_vino vino, struct ceph_file_layout *layout,
+			u64 off, u64 *plen,
+			u32 truncate_seq, u64 truncate_size,
+			struct page **pages, int num_pages)
+{
+	struct ceph_osd_request *req;
+	int rc = 0;
+
+	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
+	     vino.snap, off, *plen);
+	req = ceph_osdc_new_request(osdc, layout, vino, off, plen,
+				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+				    NULL, 0, truncate_seq, truncate_size, NULL,
+				    false, 1);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short read due to an object boundary */
+	req->r_pages = pages;
+	num_pages = calc_pages_for(off, *plen);
+	req->r_num_pages = num_pages;
+
+	dout("readpages  final extent is %llu~%llu (%d pages)\n",
+	     off, *plen, req->r_num_pages);
+
+	rc = ceph_osdc_start_request(osdc, req, false);
+	if (!rc)
+		rc = ceph_osdc_wait_request(osdc, req);
+
+	ceph_osdc_put_request(req);
+	dout("readpages result %d\n", rc);
+	return rc;
+}
+
+/*
+ * do a synchronous write on N pages
+ */
+int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
+			 struct ceph_file_layout *layout,
+			 struct ceph_snap_context *snapc,
+			 u64 off, u64 len,
+			 u32 truncate_seq, u64 truncate_size,
+			 struct timespec *mtime,
+			 struct page **pages, int num_pages,
+			 int flags, int do_sync, bool nofail)
+{
+	struct ceph_osd_request *req;
+	int rc = 0;
+
+	BUG_ON(vino.snap != CEPH_NOSNAP);
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_WRITE,
+				    flags | CEPH_OSD_FLAG_ONDISK |
+					    CEPH_OSD_FLAG_WRITE,
+				    snapc, do_sync,
+				    truncate_seq, truncate_size, mtime,
+				    nofail, 1);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short write due to an object boundary */
+	req->r_pages = pages;
+	req->r_num_pages = calc_pages_for(off, len);
+	dout("writepages %llu~%llu (%d pages)\n", off, len,
+	     req->r_num_pages);
+
+	rc = ceph_osdc_start_request(osdc, req, nofail);
+	if (!rc)
+		rc = ceph_osdc_wait_request(osdc, req);
+
+	ceph_osdc_put_request(req);
+	if (rc == 0)
+		rc = len;
+	dout("writepages result %d\n", rc);
+	return rc;
+}
+
+/*
+ * handle incoming message
+ */
+static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc = osd->o_osdc;
+	int type = le16_to_cpu(msg->hdr.type);
+
+	if (!osd)
+		return;
+
+	switch (type) {
+	case CEPH_MSG_OSD_MAP:
+		ceph_osdc_handle_map(osdc, msg);
+		break;
+	case CEPH_MSG_OSD_OPREPLY:
+		handle_reply(osdc, msg);
+		break;
+
+	default:
+		pr_err("received unknown message type %d %s\n", type,
+		       ceph_msg_type_name(type));
+	}
+	ceph_msg_put(msg);
+}
+
+static struct ceph_msg *alloc_msg(struct ceph_connection *con,
+				  struct ceph_msg_header *hdr)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc = osd->o_osdc;
+	int type = le16_to_cpu(hdr->type);
+
+	switch (type) {
+	case CEPH_MSG_OSD_OPREPLY:
+		return ceph_msgpool_get(&osdc->msgpool_op_reply);
+	}
+	return ceph_alloc_msg(con, hdr);
+}
+
+/*
+ * Wrappers to refcount containing ceph_osd struct
+ */
+static struct ceph_connection *get_osd_con(struct ceph_connection *con)
+{
+	struct ceph_osd *osd = con->private;
+	if (get_osd(osd))
+		return con;
+	return NULL;
+}
+
+static void put_osd_con(struct ceph_connection *con)
+{
+	struct ceph_osd *osd = con->private;
+	put_osd(osd);
+}
+
+const static struct ceph_connection_operations osd_con_ops = {
+	.get = get_osd_con,
+	.put = put_osd_con,
+	.dispatch = dispatch,
+	.alloc_msg = alloc_msg,
+	.peer_reset = osd_reset,
+	.alloc_middle = ceph_alloc_middle,
+	.prepare_pages = prepare_pages,
+};
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
new file mode 100644
index 0000000..9a4addf
--- /dev/null
+++ b/fs/ceph/osd_client.h
@@ -0,0 +1,144 @@
+#ifndef _FS_CEPH_OSD_CLIENT_H
+#define _FS_CEPH_OSD_CLIENT_H
+
+#include <linux/completion.h>
+#include <linux/mempool.h>
+#include <linux/rbtree.h>
+
+#include "types.h"
+#include "osdmap.h"
+#include "messenger.h"
+
+struct ceph_msg;
+struct ceph_snap_context;
+struct ceph_osd_request;
+struct ceph_osd_client;
+
+/*
+ * completion callback for async writepages
+ */
+typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *,
+				     struct ceph_msg *);
+
+/* a given osd we're communicating with */
+struct ceph_osd {
+	atomic_t o_ref;
+	struct ceph_osd_client *o_osdc;
+	int o_osd;
+	int o_incarnation;
+	struct rb_node o_node;
+	struct ceph_connection o_con;
+	struct list_head o_requests;
+};
+
+/* an in-flight request */
+struct ceph_osd_request {
+	u64             r_tid;              /* unique for this client */
+	struct rb_node  r_node;
+	struct list_head r_osd_item;
+	struct ceph_osd *r_osd;
+
+	struct ceph_msg  *r_request, *r_reply;
+	int               r_result;
+	int               r_flags;     /* any additional flags for the osd */
+	u32               r_sent;      /* >0 if r_request is sending/sent */
+	int r_prepared_pages, r_got_reply;
+
+	struct ceph_osd_client *r_osdc;
+	atomic_t          r_ref;
+	bool              r_mempool;
+	struct completion r_completion, r_safe_completion;
+	ceph_osdc_callback_t r_callback, r_safe_callback;
+	struct ceph_eversion r_reassert_version;
+	struct list_head  r_unsafe_item;
+
+	struct inode *r_inode;         	      /* for use by callbacks */
+	struct writeback_control *r_wbc;      /* ditto */
+
+	char              r_oid[40];          /* object name */
+	int               r_oid_len;
+	unsigned long     r_timeout_stamp;
+	bool              r_resend;           /* msg send failed, needs retry */
+
+	struct ceph_file_layout r_file_layout;
+	struct ceph_snap_context *r_snapc;    /* snap context for writes */
+	unsigned          r_num_pages;        /* size of page array (follows) */
+	struct page     **r_pages;            /* pages for data payload */
+	int               r_pages_from_pool;
+	int               r_own_pages;        /* if true, i own page list */
+};
+
+struct ceph_osd_client {
+	struct ceph_client     *client;
+
+	struct ceph_osdmap     *osdmap;       /* current map */
+	struct rw_semaphore    map_sem;
+	struct completion      map_waiters;
+	u64                    last_requested_map;
+
+	struct mutex           request_mutex;
+	struct rb_root         osds;          /* osds */
+	u64                    timeout_tid;   /* tid of timeout triggering rq */
+	u64                    last_tid;      /* tid of last request */
+	struct rb_root         requests;      /* pending requests */
+	int                    num_requests;
+	struct delayed_work    timeout_work;
+	struct dentry 	       *debugfs_file;
+
+	mempool_t              *req_mempool;
+
+	struct ceph_msgpool   msgpool_op;
+	struct ceph_msgpool   msgpool_op_reply;
+};
+
+extern int ceph_osdc_init(struct ceph_osd_client *osdc,
+			  struct ceph_client *client);
+extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
+
+extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
+				   struct ceph_msg *msg);
+extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
+				 struct ceph_msg *msg);
+
+extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
+				      struct ceph_file_layout *layout,
+				      struct ceph_vino vino,
+				      u64 offset, u64 *len, int op, int flags,
+				      struct ceph_snap_context *snapc,
+				      int do_sync, u32 truncate_seq,
+				      u64 truncate_size,
+				      struct timespec *mtime,
+				      bool use_mempool, int num_reply);
+
+static inline void ceph_osdc_get_request(struct ceph_osd_request *req)
+{
+	atomic_inc(&req->r_ref);
+}
+extern void ceph_osdc_put_request(struct ceph_osd_request *req);
+
+extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
+				   struct ceph_osd_request *req,
+				   bool nofail);
+extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
+				  struct ceph_osd_request *req);
+extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
+
+extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			       struct ceph_vino vino,
+			       struct ceph_file_layout *layout,
+			       u64 off, u64 *plen,
+			       u32 truncate_seq, u64 truncate_size,
+			       struct page **pages, int nr_pages);
+
+extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
+				struct ceph_vino vino,
+				struct ceph_file_layout *layout,
+				struct ceph_snap_context *sc,
+				u64 off, u64 len,
+				u32 truncate_seq, u64 truncate_size,
+				struct timespec *mtime,
+				struct page **pages, int nr_pages,
+				int flags, int do_sync, bool nofail);
+
+#endif
+
diff --git a/fs/ceph/osdmap.c b/fs/ceph/osdmap.c
new file mode 100644
index 0000000..e38fe63
--- /dev/null
+++ b/fs/ceph/osdmap.c
@@ -0,0 +1,875 @@
+
+#include <asm/div64.h>
+
+#include "super.h"
+#include "osdmap.h"
+#include "crush/hash.h"
+#include "crush/mapper.h"
+#include "decode.h"
+#include "ceph_debug.h"
+
+char *ceph_osdmap_state_str(char *str, int len, int state)
+{
+	int flag = 0;
+
+	if (!len)
+		goto done;
+
+	*str = '\0';
+	if (state) {
+		if (state & CEPH_OSD_EXISTS) {
+			snprintf(str, len, "exists");
+			flag = 1;
+		}
+		if (state & CEPH_OSD_UP) {
+			snprintf(str, len, "%s%s%s", str, (flag ? ", " : ""),
+				 "up");
+			flag = 1;
+		}
+	} else {
+		snprintf(str, len, "doesn't exist");
+	}
+done:
+	return str;
+}
+
+/* maps */
+
+static int calc_bits_of(unsigned t)
+{
+	int b = 0;
+	while (t) {
+		t = t >> 1;
+		b++;
+	}
+	return b;
+}
+
+/*
+ * the foo_mask is the smallest value 2^n-1 that is >= foo.
+ */
+static void calc_pg_masks(struct ceph_pg_pool_info *pi)
+{
+	pi->pg_num_mask = (1 << calc_bits_of(le32_to_cpu(pi->v.pg_num)-1)) - 1;
+	pi->pgp_num_mask =
+		(1 << calc_bits_of(le32_to_cpu(pi->v.pgp_num)-1)) - 1;
+	pi->lpg_num_mask =
+		(1 << calc_bits_of(le32_to_cpu(pi->v.lpg_num)-1)) - 1;
+	pi->lpgp_num_mask =
+		(1 << calc_bits_of(le32_to_cpu(pi->v.lpgp_num)-1)) - 1;
+}
+
+/*
+ * decode crush map
+ */
+static int crush_decode_uniform_bucket(void **p, void *end,
+				       struct crush_bucket_uniform *b)
+{
+	dout("crush_decode_uniform_bucket %p to %p\n", *p, end);
+	ceph_decode_need(p, end, (1+b->h.size) * sizeof(u32), bad);
+	ceph_decode_32(p, b->item_weight);
+	return 0;
+bad:
+	return -EINVAL;
+}
+
+static int crush_decode_list_bucket(void **p, void *end,
+				    struct crush_bucket_list *b)
+{
+	int j;
+	dout("crush_decode_list_bucket %p to %p\n", *p, end);
+	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
+	if (b->item_weights == NULL)
+		return -ENOMEM;
+	b->sum_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
+	if (b->sum_weights == NULL)
+		return -ENOMEM;
+	ceph_decode_need(p, end, 2 * b->h.size * sizeof(u32), bad);
+	for (j = 0; j < b->h.size; j++) {
+		ceph_decode_32(p, b->item_weights[j]);
+		ceph_decode_32(p, b->sum_weights[j]);
+	}
+	return 0;
+bad:
+	return -EINVAL;
+}
+
+static int crush_decode_tree_bucket(void **p, void *end,
+				    struct crush_bucket_tree *b)
+{
+	int j;
+	dout("crush_decode_tree_bucket %p to %p\n", *p, end);
+	ceph_decode_32_safe(p, end, b->num_nodes, bad);
+	b->node_weights = kcalloc(b->num_nodes, sizeof(u32), GFP_NOFS);
+	if (b->node_weights == NULL)
+		return -ENOMEM;
+	ceph_decode_need(p, end, b->num_nodes * sizeof(u32), bad);
+	for (j = 0; j < b->num_nodes; j++)
+		ceph_decode_32(p, b->node_weights[j]);
+	return 0;
+bad:
+	return -EINVAL;
+}
+
+static int crush_decode_straw_bucket(void **p, void *end,
+				     struct crush_bucket_straw *b)
+{
+	int j;
+	dout("crush_decode_straw_bucket %p to %p\n", *p, end);
+	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
+	if (b->item_weights == NULL)
+		return -ENOMEM;
+	b->straws = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
+	if (b->straws == NULL)
+		return -ENOMEM;
+	ceph_decode_need(p, end, 2 * b->h.size * sizeof(u32), bad);
+	for (j = 0; j < b->h.size; j++) {
+		ceph_decode_32(p, b->item_weights[j]);
+		ceph_decode_32(p, b->straws[j]);
+	}
+	return 0;
+bad:
+	return -EINVAL;
+}
+
+static struct crush_map *crush_decode(void *pbyval, void *end)
+{
+	struct crush_map *c;
+	int err = -EINVAL;
+	int i, j;
+	void **p = &pbyval;
+	void *start = pbyval;
+	u32 magic;
+
+	dout("crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	c = kzalloc(sizeof(*c), GFP_NOFS);
+	if (c == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(p, end, 4*sizeof(u32), bad);
+	ceph_decode_32(p, magic);
+	if (magic != CRUSH_MAGIC) {
+		pr_err("crush_decode magic %x != current %x\n",
+		       (unsigned)magic, (unsigned)CRUSH_MAGIC);
+		goto bad;
+	}
+	ceph_decode_32(p, c->max_buckets);
+	ceph_decode_32(p, c->max_rules);
+	ceph_decode_32(p, c->max_devices);
+
+	c->device_parents = kcalloc(c->max_devices, sizeof(u32), GFP_NOFS);
+	if (c->device_parents == NULL)
+		goto badmem;
+	c->bucket_parents = kcalloc(c->max_buckets, sizeof(u32), GFP_NOFS);
+	if (c->bucket_parents == NULL)
+		goto badmem;
+
+	c->buckets = kcalloc(c->max_buckets, sizeof(*c->buckets), GFP_NOFS);
+	if (c->buckets == NULL)
+		goto badmem;
+	c->rules = kcalloc(c->max_rules, sizeof(*c->rules), GFP_NOFS);
+	if (c->rules == NULL)
+		goto badmem;
+
+	/* buckets */
+	for (i = 0; i < c->max_buckets; i++) {
+		int size = 0;
+		u32 alg;
+		struct crush_bucket *b;
+
+		ceph_decode_32_safe(p, end, alg, bad);
+		if (alg == 0) {
+			c->buckets[i] = NULL;
+			continue;
+		}
+		dout("crush_decode bucket %d off %x %p to %p\n",
+		     i, (int)(*p-start), *p, end);
+
+		switch (alg) {
+		case CRUSH_BUCKET_UNIFORM:
+			size = sizeof(struct crush_bucket_uniform);
+			break;
+		case CRUSH_BUCKET_LIST:
+			size = sizeof(struct crush_bucket_list);
+			break;
+		case CRUSH_BUCKET_TREE:
+			size = sizeof(struct crush_bucket_tree);
+			break;
+		case CRUSH_BUCKET_STRAW:
+			size = sizeof(struct crush_bucket_straw);
+			break;
+		default:
+			goto bad;
+		}
+		BUG_ON(size == 0);
+		b = c->buckets[i] = kzalloc(size, GFP_NOFS);
+		if (b == NULL)
+			goto badmem;
+
+		ceph_decode_need(p, end, 4*sizeof(u32), bad);
+		ceph_decode_32(p, b->id);
+		ceph_decode_16(p, b->type);
+		ceph_decode_16(p, b->alg);
+		ceph_decode_32(p, b->weight);
+		ceph_decode_32(p, b->size);
+
+		dout("crush_decode bucket size %d off %x %p to %p\n",
+		     b->size, (int)(*p-start), *p, end);
+
+		b->items = kcalloc(b->size, sizeof(__s32), GFP_NOFS);
+		if (b->items == NULL)
+			goto badmem;
+		b->perm = kcalloc(b->size, sizeof(u32), GFP_NOFS);
+		if (b->perm == NULL)
+			goto badmem;
+		b->perm_n = 0;
+
+		ceph_decode_need(p, end, b->size*sizeof(u32), bad);
+		for (j = 0; j < b->size; j++)
+			ceph_decode_32(p, b->items[j]);
+
+		switch (b->alg) {
+		case CRUSH_BUCKET_UNIFORM:
+			err = crush_decode_uniform_bucket(p, end,
+				  (struct crush_bucket_uniform *)b);
+			if (err < 0)
+				goto bad;
+			break;
+		case CRUSH_BUCKET_LIST:
+			err = crush_decode_list_bucket(p, end,
+			       (struct crush_bucket_list *)b);
+			if (err < 0)
+				goto bad;
+			break;
+		case CRUSH_BUCKET_TREE:
+			err = crush_decode_tree_bucket(p, end,
+				(struct crush_bucket_tree *)b);
+			if (err < 0)
+				goto bad;
+			break;
+		case CRUSH_BUCKET_STRAW:
+			err = crush_decode_straw_bucket(p, end,
+				(struct crush_bucket_straw *)b);
+			if (err < 0)
+				goto bad;
+			break;
+		}
+	}
+
+	/* rules */
+	dout("rule vec is %p\n", c->rules);
+	for (i = 0; i < c->max_rules; i++) {
+		u32 yes;
+		struct crush_rule *r;
+
+		ceph_decode_32_safe(p, end, yes, bad);
+		if (!yes) {
+			dout("crush_decode NO rule %d off %x %p to %p\n",
+			     i, (int)(*p-start), *p, end);
+			c->rules[i] = NULL;
+			continue;
+		}
+
+		dout("crush_decode rule %d off %x %p to %p\n",
+		     i, (int)(*p-start), *p, end);
+
+		/* len */
+		ceph_decode_32_safe(p, end, yes, bad);
+#if BITS_PER_LONG == 32
+		if (yes > ULONG_MAX / sizeof(struct crush_rule_step))
+			goto bad;
+#endif
+		r = c->rules[i] = kmalloc(sizeof(*r) +
+					  yes*sizeof(struct crush_rule_step),
+					  GFP_NOFS);
+		if (r == NULL)
+			goto badmem;
+		dout(" rule %d is at %p\n", i, r);
+		r->len = yes;
+		ceph_decode_copy_safe(p, end, &r->mask, 4, bad); /* 4 u8's */
+		ceph_decode_need(p, end, r->len*3*sizeof(u32), bad);
+		for (j = 0; j < r->len; j++) {
+			ceph_decode_32(p, r->steps[j].op);
+			ceph_decode_32(p, r->steps[j].arg1);
+			ceph_decode_32(p, r->steps[j].arg2);
+		}
+	}
+
+	/* ignore trailing name maps. */
+
+	dout("crush_decode success\n");
+	return c;
+
+badmem:
+	err = -ENOMEM;
+bad:
+	dout("crush_decode fail %d\n", err);
+	crush_destroy(c);
+	return ERR_PTR(err);
+}
+
+
+/*
+ * osd map
+ */
+void ceph_osdmap_destroy(struct ceph_osdmap *map)
+{
+	dout("osdmap_destroy %p\n", map);
+	if (map->crush)
+		crush_destroy(map->crush);
+	while (!RB_EMPTY_ROOT(&map->pg_temp))
+		rb_erase(rb_first(&map->pg_temp), &map->pg_temp);
+	kfree(map->osd_state);
+	kfree(map->osd_weight);
+	kfree(map->pg_pool);
+	kfree(map->osd_addr);
+	kfree(map);
+}
+
+/*
+ * adjust max osd value.  reallocate arrays.
+ */
+static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
+{
+	u8 *state;
+	struct ceph_entity_addr *addr;
+	u32 *weight;
+
+	state = kcalloc(max, sizeof(*state), GFP_NOFS);
+	addr = kcalloc(max, sizeof(*addr), GFP_NOFS);
+	weight = kcalloc(max, sizeof(*weight), GFP_NOFS);
+	if (state == NULL || addr == NULL || weight == NULL) {
+		kfree(state);
+		kfree(addr);
+		kfree(weight);
+		return -ENOMEM;
+	}
+
+	/* copy old? */
+	if (map->osd_state) {
+		memcpy(state, map->osd_state, map->max_osd*sizeof(*state));
+		memcpy(addr, map->osd_addr, map->max_osd*sizeof(*addr));
+		memcpy(weight, map->osd_weight, map->max_osd*sizeof(*weight));
+		kfree(map->osd_state);
+		kfree(map->osd_addr);
+		kfree(map->osd_weight);
+	}
+
+	map->osd_state = state;
+	map->osd_weight = weight;
+	map->osd_addr = addr;
+	map->max_osd = max;
+	return 0;
+}
+
+/*
+ * Insert a new pg_temp mapping
+ */
+static void __insert_pg_mapping(struct ceph_pg_mapping *new,
+				struct rb_root *root)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct ceph_pg_mapping *pg = NULL;
+
+	while (*p) {
+		parent = *p;
+		pg = rb_entry(parent, struct ceph_pg_mapping, node);
+		if (new->pgid < pg->pgid)
+			p = &(*p)->rb_left;
+		else if (new->pgid > pg->pgid)
+			p = &(*p)->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&new->node, parent, p);
+	rb_insert_color(&new->node, root);
+}
+
+/*
+ * decode a full map.
+ */
+struct ceph_osdmap *osdmap_decode(void **p, void *end)
+{
+	struct ceph_osdmap *map;
+	u16 version;
+	u32 len, max, i;
+	int err = -EINVAL;
+	void *start = *p;
+
+	dout("osdmap_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	map = kzalloc(sizeof(*map), GFP_NOFS);
+	if (map == NULL)
+		return ERR_PTR(-ENOMEM);
+	map->pg_temp = RB_ROOT;
+
+	ceph_decode_16_safe(p, end, version, bad);
+
+	ceph_decode_need(p, end, 2*sizeof(u64)+6*sizeof(u32), bad);
+	ceph_decode_copy(p, &map->fsid, sizeof(map->fsid));
+	ceph_decode_32(p, map->epoch);
+	ceph_decode_copy(p, &map->created, sizeof(map->created));
+	ceph_decode_copy(p, &map->modified, sizeof(map->modified));
+
+	ceph_decode_32(p, map->num_pools);
+	map->pg_pool = kcalloc(map->num_pools, sizeof(*map->pg_pool),
+			       GFP_NOFS);
+	if (!map->pg_pool) {
+		err = -ENOMEM;
+		goto bad;
+	}
+	ceph_decode_32_safe(p, end, max, bad);
+	while (max--) {
+		ceph_decode_need(p, end, 4+sizeof(map->pg_pool->v), bad);
+		ceph_decode_32(p, i);
+		if (i >= map->num_pools)
+			goto bad;
+		ceph_decode_copy(p, &map->pg_pool[i].v,
+				 sizeof(map->pg_pool->v));
+		calc_pg_masks(&map->pg_pool[i]);
+		p += le32_to_cpu(map->pg_pool[i].v.num_snaps) * sizeof(u64);
+		p += le32_to_cpu(map->pg_pool[i].v.num_removed_snap_intervals)
+			* sizeof(u64) * 2;
+	}
+
+	ceph_decode_32_safe(p, end, map->flags, bad);
+
+	ceph_decode_32(p, max);
+
+	/* (re)alloc osd arrays */
+	err = osdmap_set_max_osd(map, max);
+	if (err < 0)
+		goto bad;
+	dout("osdmap_decode max_osd = %d\n", map->max_osd);
+
+	/* osds */
+	err = -EINVAL;
+	ceph_decode_need(p, end, 3*sizeof(u32) +
+			 map->max_osd*(1 + sizeof(*map->osd_weight) +
+				       sizeof(*map->osd_addr)), bad);
+	*p += 4; /* skip length field (should match max) */
+	ceph_decode_copy(p, map->osd_state, map->max_osd);
+
+	*p += 4; /* skip length field (should match max) */
+	for (i = 0; i < map->max_osd; i++)
+		ceph_decode_32(p, map->osd_weight[i]);
+
+	*p += 4; /* skip length field (should match max) */
+	ceph_decode_copy(p, map->osd_addr, map->max_osd*sizeof(*map->osd_addr));
+
+	/* pg_temp */
+	ceph_decode_32_safe(p, end, len, bad);
+	for (i = 0; i < len; i++) {
+		int n, j;
+		u64 pgid;
+		struct ceph_pg_mapping *pg;
+
+		ceph_decode_need(p, end, sizeof(u32) + sizeof(u64), bad);
+		ceph_decode_64(p, pgid);
+		ceph_decode_32(p, n);
+		ceph_decode_need(p, end, n * sizeof(u32), bad);
+		pg = kmalloc(sizeof(*pg) + n*sizeof(u32), GFP_NOFS);
+		if (!pg) {
+			err = -ENOMEM;
+			goto bad;
+		}
+		pg->pgid = pgid;
+		pg->len = n;
+		for (j = 0; j < n; j++)
+			ceph_decode_32(p, pg->osds[j]);
+
+		__insert_pg_mapping(pg, &map->pg_temp);
+		dout(" added pg_temp %llx len %d\n", pgid, len);
+	}
+
+	/* crush */
+	ceph_decode_32_safe(p, end, len, bad);
+	dout("osdmap_decode crush len %d from off 0x%x\n", len,
+	     (int)(*p - start));
+	ceph_decode_need(p, end, len, bad);
+	map->crush = crush_decode(*p, end);
+	*p += len;
+	if (IS_ERR(map->crush)) {
+		err = PTR_ERR(map->crush);
+		map->crush = NULL;
+		goto bad;
+	}
+
+	/* ignore the rest of the map */
+	*p = end;
+
+	dout("osdmap_decode done %p %p\n", *p, end);
+	return map;
+
+bad:
+	dout("osdmap_decode fail\n");
+	ceph_osdmap_destroy(map);
+	return ERR_PTR(err);
+}
+
+/*
+ * decode and apply an incremental map update.
+ */
+struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
+					     struct ceph_osdmap *map,
+					     struct ceph_messenger *msgr)
+{
+	struct ceph_osdmap *newmap = map;
+	struct crush_map *newcrush = NULL;
+	struct ceph_fsid fsid;
+	u32 epoch = 0;
+	struct ceph_timespec modified;
+	u32 len, pool;
+	__s32 new_flags, max;
+	void *start = *p;
+	int err = -EINVAL;
+	u16 version;
+	struct rb_node *rbp;
+
+	ceph_decode_16_safe(p, end, version, bad);
+
+	ceph_decode_need(p, end, sizeof(fsid)+sizeof(modified)+2*sizeof(u32),
+			 bad);
+	ceph_decode_copy(p, &fsid, sizeof(fsid));
+	ceph_decode_32(p, epoch);
+	BUG_ON(epoch != map->epoch+1);
+	ceph_decode_copy(p, &modified, sizeof(modified));
+	ceph_decode_32(p, new_flags);
+
+	/* full map? */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len > 0) {
+		dout("apply_incremental full map len %d, %p to %p\n",
+		     len, *p, end);
+		newmap = osdmap_decode(p, min(*p+len, end));
+		return newmap;  /* error or not */
+	}
+
+	/* new crush? */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len > 0) {
+		dout("apply_incremental new crush map len %d, %p to %p\n",
+		     len, *p, end);
+		newcrush = crush_decode(*p, min(*p+len, end));
+		if (IS_ERR(newcrush))
+			return ERR_PTR(PTR_ERR(newcrush));
+	}
+
+	/* new flags? */
+	if (new_flags >= 0)
+		map->flags = new_flags;
+
+	ceph_decode_need(p, end, 5*sizeof(u32), bad);
+
+	/* new max? */
+	ceph_decode_32(p, max);
+	if (max >= 0) {
+		err = osdmap_set_max_osd(map, max);
+		if (err < 0)
+			goto bad;
+	}
+
+	map->epoch++;
+	map->modified = map->modified;
+	if (newcrush) {
+		if (map->crush)
+			crush_destroy(map->crush);
+		map->crush = newcrush;
+		newcrush = NULL;
+	}
+
+	/* new_pool */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		ceph_decode_32_safe(p, end, pool, bad);
+		if (pool >= map->num_pools) {
+			void *pg_pool = kcalloc(pool + 1,
+						sizeof(*map->pg_pool),
+						GFP_NOFS);
+			if (!pg_pool) {
+				err = -ENOMEM;
+				goto bad;
+			}
+			memcpy(pg_pool, map->pg_pool,
+			       map->num_pools * sizeof(*map->pg_pool));
+			kfree(map->pg_pool);
+			map->pg_pool = pg_pool;
+			map->num_pools = pool+1;
+		}
+		ceph_decode_copy(p, &map->pg_pool[pool].v,
+				 sizeof(map->pg_pool->v));
+		calc_pg_masks(&map->pg_pool[pool]);
+	}
+
+	/* old_pool (ignore) */
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * sizeof(u32);
+
+	/* new_up */
+	err = -EINVAL;
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd;
+		struct ceph_entity_addr addr;
+		ceph_decode_32_safe(p, end, osd, bad);
+		ceph_decode_copy_safe(p, end, &addr, sizeof(addr), bad);
+		pr_info("osd%d up\n", osd);
+		BUG_ON(osd >= map->max_osd);
+		map->osd_state[osd] |= CEPH_OSD_UP;
+		map->osd_addr[osd] = addr;
+	}
+
+	/* new_down */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd;
+		ceph_decode_32_safe(p, end, osd, bad);
+		(*p)++;  /* clean flag */
+		pr_info("ceph osd%d down\n", osd);
+		if (osd < map->max_osd)
+			map->osd_state[osd] &= ~CEPH_OSD_UP;
+	}
+
+	/* new_weight */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd, off;
+		ceph_decode_need(p, end, sizeof(u32)*2, bad);
+		ceph_decode_32(p, osd);
+		ceph_decode_32(p, off);
+		pr_info("osd%d weight 0x%x %s\n", osd, off,
+		     off == CEPH_OSD_IN ? "(in)" :
+		     (off == CEPH_OSD_OUT ? "(out)" : ""));
+		if (osd < map->max_osd)
+			map->osd_weight[osd] = off;
+	}
+
+	/* new_pg_temp */
+	rbp = rb_first(&map->pg_temp);
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		struct ceph_pg_mapping *pg;
+		int j;
+		u64 pgid;
+		u32 pglen;
+		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
+		ceph_decode_64(p, pgid);
+		ceph_decode_32(p, pglen);
+
+		/* remove any? */
+		while (rbp && rb_entry(rbp, struct ceph_pg_mapping,
+				       node)->pgid <= pgid) {
+			struct rb_node *cur = rbp;
+			rbp = rb_next(rbp);
+			dout(" removed pg_temp %llx\n",
+			     rb_entry(cur, struct ceph_pg_mapping, node)->pgid);
+			rb_erase(cur, &map->pg_temp);
+		}
+
+		if (pglen) {
+			/* insert */
+			ceph_decode_need(p, end, pglen*sizeof(u32), bad);
+			pg = kmalloc(sizeof(*pg) + sizeof(u32)*pglen, GFP_NOFS);
+			if (!pg) {
+				err = -ENOMEM;
+				goto bad;
+			}
+			pg->pgid = pgid;
+			pg->len = pglen;
+			for (j = 0; j < len; j++)
+				ceph_decode_32(p, pg->osds[j]);
+			__insert_pg_mapping(pg, &map->pg_temp);
+			dout(" added pg_temp %llx len %d\n", pgid, pglen);
+		}
+	}
+	while (rbp) {
+		struct rb_node *cur = rbp;
+		rbp = rb_next(rbp);
+		dout(" removed pg_temp %llx\n",
+		     rb_entry(cur, struct ceph_pg_mapping, node)->pgid);
+		rb_erase(cur, &map->pg_temp);
+	}
+
+	/* ignore the rest */
+	*p = end;
+	return map;
+
+bad:
+	pr_err("corrupt inc osdmap epoch %d off %d (%p of %p-%p)\n",
+	       epoch, (int)(*p - start), *p, start, end);
+	if (newcrush)
+		crush_destroy(newcrush);
+	return ERR_PTR(err);
+}
+
+
+
+
+/*
+ * calculate file layout from given offset, length.
+ * fill in correct oid, logical length, and object extent
+ * offset, length.
+ *
+ * for now, we write only a single su, until we can
+ * pass a stride back to the caller.
+ */
+void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
+				   u64 off, u64 *plen,
+				   u64 *bno,
+				   u64 *oxoff, u64 *oxlen)
+{
+	u32 osize = le32_to_cpu(layout->fl_object_size);
+	u32 su = le32_to_cpu(layout->fl_stripe_unit);
+	u32 sc = le32_to_cpu(layout->fl_stripe_count);
+	u32 bl, stripeno, stripepos, objsetno;
+	u32 su_per_object;
+	u64 t;
+
+	dout("mapping %llu~%llu  osize %u fl_su %u\n", off, *plen,
+	     osize, su);
+	su_per_object = osize / le32_to_cpu(layout->fl_stripe_unit);
+	dout("osize %u / su %u = su_per_object %u\n", osize, su,
+	     su_per_object);
+
+	BUG_ON((su & ~PAGE_MASK) != 0);
+	/* bl = *off / su; */
+	t = off;
+	do_div(t, su);
+	bl = t;
+	dout("off %llu / su %u = bl %u\n", off, su, bl);
+
+	stripeno = bl / sc;
+	stripepos = bl % sc;
+	objsetno = stripeno / su_per_object;
+
+	*bno = objsetno * sc + stripepos;
+	dout("objset %u * sc %u = bno %u\n", objsetno, sc, (unsigned)*bno);
+	/* *oxoff = *off / layout->fl_stripe_unit; */
+	t = off;
+	*oxoff = do_div(t, su);
+	*oxlen = min_t(u64, *plen, su - *oxoff);
+	*plen = *oxlen;
+
+	dout(" obj extent %llu~%llu\n", *oxoff, *oxlen);
+}
+
+/*
+ * calculate an object layout (i.e. pgid) from an oid,
+ * file_layout, and osdmap
+ */
+int ceph_calc_object_layout(struct ceph_object_layout *ol,
+			    const char *oid,
+			    struct ceph_file_layout *fl,
+			    struct ceph_osdmap *osdmap)
+{
+	unsigned num, num_mask;
+	union ceph_pg pgid;
+	s32 preferred = (s32)le32_to_cpu(fl->fl_pg_preferred);
+	int poolid = le32_to_cpu(fl->fl_pg_pool);
+	struct ceph_pg_pool_info *pool;
+
+	if (poolid >= osdmap->num_pools)
+		return -EIO;
+	pool = &osdmap->pg_pool[poolid];
+
+	if (preferred >= 0) {
+		num = le32_to_cpu(pool->v.lpg_num);
+		num_mask = pool->lpg_num_mask;
+	} else {
+		num = le32_to_cpu(pool->v.pg_num);
+		num_mask = pool->pg_num_mask;
+	}
+
+	pgid.pg64 = 0;   /* start with it zeroed out */
+	pgid.pg.ps = ceph_full_name_hash(oid, strlen(oid));
+	pgid.pg.preferred = preferred;
+	pgid.pg.pool = le32_to_cpu(fl->fl_pg_pool);
+	if (preferred >= 0)
+		dout("calc_object_layout '%s' pgid %d.%xp%d (%llx)\n", oid,
+		     pgid.pg.pool, pgid.pg.ps, (int)preferred, pgid.pg64);
+	else
+		dout("calc_object_layout '%s' pgid %d.%x (%llx)\n", oid,
+		     pgid.pg.pool, pgid.pg.ps, pgid.pg64);
+
+	ol->ol_pgid = cpu_to_le64(pgid.pg64);
+	ol->ol_stripe_unit = fl->fl_object_stripe_unit;
+
+	return 0;
+}
+
+/*
+ * Calculate raw osd vector for the given pgid.  Return pointer to osd
+ * array, or NULL on failure.
+ */
+static int *calc_pg_raw(struct ceph_osdmap *osdmap, union ceph_pg pgid,
+			int *osds, int *num)
+{
+	struct rb_node *n = osdmap->pg_temp.rb_node;
+	struct ceph_pg_mapping *pg;
+	struct ceph_pg_pool_info *pool;
+	int ruleno;
+	unsigned pps; /* placement ps */
+
+	/* pg_temp? */
+	while (n) {
+		pg = rb_entry(n, struct ceph_pg_mapping, node);
+		if (pgid.pg64 < pg->pgid)
+			n = n->rb_left;
+		else if (pgid.pg64 > pg->pgid)
+			n = n->rb_right;
+		else {
+			*num = pg->len;
+			return pg->osds;
+		}
+	}
+
+	/* crush */
+	if (pgid.pg.pool >= osdmap->num_pools)
+		return NULL;
+	pool = &osdmap->pg_pool[pgid.pg.pool];
+	ruleno = crush_find_rule(osdmap->crush, pool->v.crush_ruleset,
+				 pool->v.type, pool->v.size);
+	if (ruleno < 0) {
+		pr_err("no crush rule pool %d type %d size %d\n",
+		       pgid.pg.pool, pool->v.type, pool->v.size);
+		return NULL;
+	}
+
+	if (pgid.pg.preferred >= 0)
+		pps = ceph_stable_mod(pgid.pg.ps,
+				      le32_to_cpu(pool->v.lpgp_num),
+				      pool->lpgp_num_mask);
+	else
+		pps = ceph_stable_mod(pgid.pg.ps,
+				      le32_to_cpu(pool->v.pgp_num),
+				      pool->pgp_num_mask);
+	pps += pgid.pg.pool;
+	*num = crush_do_rule(osdmap->crush, ruleno, pps, osds,
+			     min_t(int, pool->v.size, *num),
+			     pgid.pg.preferred, osdmap->osd_weight);
+	return osds;
+}
+
+/*
+ * Return primary osd for given pgid, or -1 if none.
+ */
+int ceph_calc_pg_primary(struct ceph_osdmap *osdmap, union ceph_pg pgid)
+{
+	int rawosds[10], *osds;
+	int i, num = ARRAY_SIZE(rawosds);
+
+	osds = calc_pg_raw(osdmap, pgid, rawosds, &num);
+	if (!osds)
+		return -1;
+
+	/* primary is first up osd */
+	for (i = 0; i < num; i++)
+		if (ceph_osd_is_up(osdmap, osds[i])) {
+			return osds[i];
+			break;
+		}
+	return -1;
+}
diff --git a/fs/ceph/osdmap.h b/fs/ceph/osdmap.h
new file mode 100644
index 0000000..07127c6
--- /dev/null
+++ b/fs/ceph/osdmap.h
@@ -0,0 +1,123 @@
+#ifndef _FS_CEPH_OSDMAP_H
+#define _FS_CEPH_OSDMAP_H
+
+#include <linux/rbtree.h>
+#include "types.h"
+#include "ceph_fs.h"
+#include "crush/crush.h"
+
+/*
+ * The osd map describes the current membership of the osd cluster and
+ * specifies the mapping of objects to placement groups and placement
+ * groups to (sets of) osds.  That is, it completely specifies the
+ * (desired) distribution of all data objects in the system at some
+ * point in time.
+ *
+ * Each map version is identified by an epoch, which increases monotonically.
+ *
+ * The map can be updated either via an incremental map (diff) describing
+ * the change between two successive epochs, or as a fully encoded map.
+ */
+struct ceph_pg_pool_info {
+	struct ceph_pg_pool v;
+	int pg_num_mask, pgp_num_mask, lpg_num_mask, lpgp_num_mask;
+};
+
+struct ceph_pg_mapping {
+	struct rb_node node;
+	u64 pgid;
+	int len;
+	int osds[];
+};
+
+struct ceph_osdmap {
+	struct ceph_fsid fsid;
+	u32 epoch;
+	u32 mkfs_epoch;
+	struct ceph_timespec created, modified;
+
+	u32 flags;         /* CEPH_OSDMAP_* */
+
+	u32 max_osd;       /* size of osd_state, _offload, _addr arrays */
+	u8 *osd_state;     /* CEPH_OSD_* */
+	u32 *osd_weight;   /* 0 = failed, 0x10000 = 100% normal */
+	struct ceph_entity_addr *osd_addr;
+
+	struct rb_root pg_temp;
+
+	u32 num_pools;
+	struct ceph_pg_pool_info *pg_pool;
+
+	/* the CRUSH map specifies the mapping of placement groups to
+	 * the list of osds that store+replicate them. */
+	struct crush_map *crush;
+};
+
+/*
+ * file layout helpers
+ */
+#define ceph_file_layout_su(l) ((__s32)le32_to_cpu((l).fl_stripe_unit))
+#define ceph_file_layout_stripe_count(l) \
+	((__s32)le32_to_cpu((l).fl_stripe_count))
+#define ceph_file_layout_object_size(l) ((__s32)le32_to_cpu((l).fl_object_size))
+#define ceph_file_layout_cas_hash(l) ((__s32)le32_to_cpu((l).fl_cas_hash))
+#define ceph_file_layout_object_su(l) \
+	((__s32)le32_to_cpu((l).fl_object_stripe_unit))
+#define ceph_file_layout_pg_preferred(l) \
+	((__s32)le32_to_cpu((l).fl_pg_preferred))
+#define ceph_file_layout_pg_pool(l) \
+	((__s32)le32_to_cpu((l).fl_pg_pool))
+
+static inline unsigned ceph_file_layout_stripe_width(struct ceph_file_layout *l)
+{
+	return le32_to_cpu(l->fl_stripe_unit) *
+		le32_to_cpu(l->fl_stripe_count);
+}
+
+/* "period" == bytes before i start on a new set of objects */
+static inline unsigned ceph_file_layout_period(struct ceph_file_layout *l)
+{
+	return le32_to_cpu(l->fl_object_size) *
+		le32_to_cpu(l->fl_stripe_count);
+}
+
+
+static inline int ceph_osd_is_up(struct ceph_osdmap *map, int osd)
+{
+	return (osd < map->max_osd) && (map->osd_state[osd] & CEPH_OSD_UP);
+}
+
+static inline bool ceph_osdmap_flag(struct ceph_osdmap *map, int flag)
+{
+	return map && (map->flags & flag);
+}
+
+extern char *ceph_osdmap_state_str(char *str, int len, int state);
+
+static inline struct ceph_entity_addr *ceph_osd_addr(struct ceph_osdmap *map,
+						     int osd)
+{
+	if (osd >= map->max_osd)
+		return NULL;
+	return &map->osd_addr[osd];
+}
+
+extern struct ceph_osdmap *osdmap_decode(void **p, void *end);
+extern struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
+					    struct ceph_osdmap *map,
+					    struct ceph_messenger *msgr);
+extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
+
+/* calculate mapping of a file extent to an object */
+extern void ceph_calc_file_object_mapping(struct ceph_file_layout *layout,
+					  u64 off, u64 *plen,
+					  u64 *bno, u64 *oxoff, u64 *oxlen);
+
+/* calculate mapping of object to a placement group */
+extern int ceph_calc_object_layout(struct ceph_object_layout *ol,
+				   const char *oid,
+				   struct ceph_file_layout *fl,
+				   struct ceph_osdmap *osdmap);
+extern int ceph_calc_pg_primary(struct ceph_osdmap *osdmap, union ceph_pg pgid);
+
+#endif
-- 
1.5.6.5

