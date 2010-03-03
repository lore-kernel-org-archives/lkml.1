Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0CCAup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:50:45 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54209 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0CCAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:49 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 13/26] ceph: OSD client
Date: Tue,  2 Mar 2010 16:46:44 -0800
Message-Id: <1267577217-31923-14-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
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
 fs/ceph/osd_client.c | 1537 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/osd_client.h |  166 ++++++
 fs/ceph/osdmap.c     | 1019 +++++++++++++++++++++++++++++++++
 fs/ceph/osdmap.h     |  125 ++++
 4 files changed, 2847 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/osd_client.c
 create mode 100644 fs/ceph/osd_client.h
 create mode 100644 fs/ceph/osdmap.c
 create mode 100644 fs/ceph/osdmap.h

diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
new file mode 100644
index 0000000..daf545f
--- /dev/null
+++ b/fs/ceph/osd_client.c
@@ -0,0 +1,1537 @@
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
+#include "auth.h"
+
+#define OSD_OP_FRONT_LEN	4096
+#define OSD_OPREPLY_FRONT_LEN	512
+
+const static struct ceph_connection_operations osd_con_ops;
+static int __kick_requests(struct ceph_osd_client *osdc,
+			  struct ceph_osd *kickosd);
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
+/*
+ * requests
+ */
+void ceph_osdc_release_request(struct kref *kref)
+{
+	struct ceph_osd_request *req = container_of(kref,
+						    struct ceph_osd_request,
+						    r_kref);
+
+	if (req->r_request)
+		ceph_msg_put(req->r_request);
+	if (req->r_reply)
+		ceph_msg_put(req->r_reply);
+	if (req->r_con_filling_msg) {
+		dout("release_request revoking pages %p from con %p\n",
+		     req->r_pages, req->r_con_filling_msg);
+		ceph_con_revoke_message(req->r_con_filling_msg,
+				      req->r_reply);
+		ceph_con_put(req->r_con_filling_msg);
+	}
+	if (req->r_own_pages)
+		ceph_release_page_vector(req->r_pages,
+					 req->r_num_pages);
+	ceph_put_snap_context(req->r_snapc);
+	if (req->r_mempool)
+		mempool_free(req, req->r_osdc->req_mempool);
+	else
+		kfree(req);
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
+	int num_op = 1 + do_sync;
+	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
+	int i;
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
+	req->r_osdc = osdc;
+	req->r_mempool = use_mempool;
+	kref_init(&req->r_kref);
+	init_completion(&req->r_completion);
+	init_completion(&req->r_safe_completion);
+	INIT_LIST_HEAD(&req->r_unsafe_item);
+	req->r_flags = flags;
+
+	WARN_ON((flags & (CEPH_OSD_FLAG_READ|CEPH_OSD_FLAG_WRITE)) == 0);
+
+	/* create reply message */
+	if (use_mempool)
+		msg = ceph_msgpool_get(&osdc->msgpool_op_reply, 0);
+	else
+		msg = ceph_msg_new(CEPH_MSG_OSD_OPREPLY,
+				   OSD_OPREPLY_FRONT_LEN, 0, 0, NULL);
+	if (IS_ERR(msg)) {
+		ceph_osdc_put_request(req);
+		return ERR_PTR(PTR_ERR(msg));
+	}
+	req->r_reply = msg;
+
+	/* create request message; allow space for oid */
+	msg_size += 40;
+	if (snapc)
+		msg_size += sizeof(u64) * snapc->num_snaps;
+	if (use_mempool)
+		msg = ceph_msgpool_get(&osdc->msgpool_op, 0);
+	else
+		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, 0, 0, NULL);
+	if (IS_ERR(msg)) {
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
+	op->extent.truncate_size = cpu_to_le64(truncate_size);
+	op->extent.truncate_seq = cpu_to_le32(truncate_seq);
+
+	/* fill in oid */
+	head->object_len = cpu_to_le32(req->r_oid_len);
+	memcpy(p, req->r_oid, req->r_oid_len);
+	p += req->r_oid_len;
+
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
+	msg_size = p - msg->front.iov_base;
+	msg->front.iov_len = msg_size;
+	msg->hdr.front_len = cpu_to_le32(msg_size);
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
+ * If the osd connection drops, we need to resubmit all requests.
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
+	INIT_LIST_HEAD(&osd->o_osd_lru);
+	osd->o_incarnation = 1;
+
+	ceph_con_init(osdc->client->msgr, &osd->o_con);
+	osd->o_con.private = osd;
+	osd->o_con.ops = &osd_con_ops;
+	osd->o_con.peer_name.type = CEPH_ENTITY_TYPE_OSD;
+
+	INIT_LIST_HEAD(&osd->o_keepalive_item);
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
+	if (atomic_dec_and_test(&osd->o_ref))
+		kfree(osd);
+}
+
+/*
+ * remove an osd from our map
+ */
+static void __remove_osd(struct ceph_osd_client *osdc, struct ceph_osd *osd)
+{
+	dout("__remove_osd %p\n", osd);
+	BUG_ON(!list_empty(&osd->o_requests));
+	rb_erase(&osd->o_node, &osdc->osds);
+	list_del_init(&osd->o_osd_lru);
+	ceph_con_close(&osd->o_con);
+	put_osd(osd);
+}
+
+static void __move_osd_to_lru(struct ceph_osd_client *osdc,
+			      struct ceph_osd *osd)
+{
+	dout("__move_osd_to_lru %p\n", osd);
+	BUG_ON(!list_empty(&osd->o_osd_lru));
+	list_add_tail(&osd->o_osd_lru, &osdc->osd_lru);
+	osd->lru_ttl = jiffies + osdc->client->mount_args->osd_idle_ttl * HZ;
+}
+
+static void __remove_osd_from_lru(struct ceph_osd *osd)
+{
+	dout("__remove_osd_from_lru %p\n", osd);
+	if (!list_empty(&osd->o_osd_lru))
+		list_del_init(&osd->o_osd_lru);
+}
+
+static void remove_old_osds(struct ceph_osd_client *osdc, int remove_all)
+{
+	struct ceph_osd *osd, *nosd;
+
+	dout("__remove_old_osds %p\n", osdc);
+	mutex_lock(&osdc->request_mutex);
+	list_for_each_entry_safe(osd, nosd, &osdc->osd_lru, o_osd_lru) {
+		if (!remove_all && time_before(jiffies, osd->lru_ttl))
+			break;
+		__remove_osd(osdc, osd);
+	}
+	mutex_unlock(&osdc->request_mutex);
+}
+
+/*
+ * reset osd connect
+ */
+static int __reset_osd(struct ceph_osd_client *osdc, struct ceph_osd *osd)
+{
+	int ret = 0;
+
+	dout("__reset_osd %p osd%d\n", osd, osd->o_osd);
+	if (list_empty(&osd->o_requests)) {
+		__remove_osd(osdc, osd);
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
+static void __schedule_osd_timeout(struct ceph_osd_client *osdc)
+{
+	schedule_delayed_work(&osdc->timeout_work,
+			osdc->client->mount_args->osd_keepalive_timeout * HZ);
+}
+
+static void __cancel_osd_timeout(struct ceph_osd_client *osdc)
+{
+	cancel_delayed_work_sync(&osdc->timeout_work);
+}
+
+/*
+ * Register request, assign tid.  If this is the first request, set up
+ * the timeout event.
+ */
+static void register_request(struct ceph_osd_client *osdc,
+			     struct ceph_osd_request *req)
+{
+	mutex_lock(&osdc->request_mutex);
+	req->r_tid = ++osdc->last_tid;
+	req->r_request->hdr.tid = cpu_to_le64(req->r_tid);
+	INIT_LIST_HEAD(&req->r_req_lru_item);
+
+	dout("register_request %p tid %lld\n", req, req->r_tid);
+	__insert_request(osdc, req);
+	ceph_osdc_get_request(req);
+	osdc->num_requests++;
+
+	if (osdc->num_requests == 1) {
+		dout(" first request, scheduling timeout\n");
+		__schedule_osd_timeout(osdc);
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
+	if (req->r_osd) {
+		/* make sure the original request isn't in flight. */
+		ceph_con_revoke(&req->r_osd->o_con, req->r_request);
+
+		list_del_init(&req->r_osd_item);
+		if (list_empty(&req->r_osd->o_requests))
+			__move_osd_to_lru(osdc, req->r_osd);
+		req->r_osd = NULL;
+	}
+
+	ceph_osdc_put_request(req);
+
+	list_del_init(&req->r_req_lru_item);
+	if (osdc->num_requests == 0) {
+		dout(" no requests, canceling timeout\n");
+		__cancel_osd_timeout(osdc);
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
+	list_del_init(&req->r_req_lru_item);
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
+	struct ceph_pg pgid;
+	int o = -1;
+	int err;
+
+	dout("map_osds %p tid %lld\n", req, req->r_tid);
+	err = ceph_calc_object_layout(&reqhead->layout, req->r_oid,
+				      &req->r_file_layout, osdc->osdmap);
+	if (err)
+		return err;
+	pgid = reqhead->layout.ol_pgid;
+	req->r_pgid = pgid;
+
+	o = ceph_calc_pg_primary(osdc->osdmap, pgid);
+
+	if ((req->r_osd && req->r_osd->o_osd == o &&
+	     req->r_sent >= req->r_osd->o_incarnation) ||
+	    (req->r_osd == NULL && o == -1))
+		return 0;  /* no change */
+
+	dout("map_osds tid %llu pgid %d.%x osd%d (was osd%d)\n",
+	     req->r_tid, le32_to_cpu(pgid.pool), le16_to_cpu(pgid.ps), o,
+	     req->r_osd ? req->r_osd->o_osd : -1);
+
+	if (req->r_osd) {
+		__cancel_request(req);
+		list_del_init(&req->r_osd_item);
+		req->r_osd = NULL;
+	}
+
+	req->r_osd = __lookup_osd(osdc, o);
+	if (!req->r_osd && o >= 0) {
+		err = -ENOMEM;
+		req->r_osd = create_osd(osdc);
+		if (!req->r_osd)
+			goto out;
+
+		dout("map_osds osd %p is osd%d\n", req->r_osd, o);
+		req->r_osd->o_osd = o;
+		req->r_osd->o_con.peer_name.num = cpu_to_le64(o);
+		__insert_osd(osdc, req->r_osd);
+
+		ceph_con_open(&req->r_osd->o_con, &osdc->osdmap->osd_addr[o]);
+	}
+
+	if (req->r_osd) {
+		__remove_osd_from_lru(req->r_osd);
+		list_add(&req->r_osd_item, &req->r_osd->o_requests);
+	}
+	err = 1;   /* osd changed */
+
+out:
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
+	req->r_sent_stamp = jiffies;
+	list_move_tail(&osdc->req_lru, &req->r_req_lru_item);
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
+	struct ceph_osd_request *req, *last_req = NULL;
+	struct ceph_osd *osd;
+	unsigned long timeout = osdc->client->mount_args->osd_timeout * HZ;
+	unsigned long keepalive =
+		osdc->client->mount_args->osd_keepalive_timeout * HZ;
+	unsigned long last_sent = 0;
+	struct rb_node *p;
+	struct list_head slow_osds;
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
+
+	/*
+	 * reset osds that appear to be _really_ unresponsive.  this
+	 * is a failsafe measure.. we really shouldn't be getting to
+	 * this point if the system is working properly.  the monitors
+	 * should mark the osd as failed and we should find out about
+	 * it from an updated osd map.
+	 */
+	while (!list_empty(&osdc->req_lru)) {
+		req = list_entry(osdc->req_lru.next, struct ceph_osd_request,
+				 r_req_lru_item);
+
+		if (time_before(jiffies, req->r_sent_stamp + timeout))
+			break;
+
+		BUG_ON(req == last_req && req->r_sent_stamp == last_sent);
+		last_req = req;
+		last_sent = req->r_sent_stamp;
+
+		osd = req->r_osd;
+		BUG_ON(!osd);
+		pr_warning(" tid %llu timed out on osd%d, will reset osd\n",
+			   req->r_tid, osd->o_osd);
+		__kick_requests(osdc, osd);
+	}
+
+	/*
+	 * ping osds that are a bit slow.  this ensures that if there
+	 * is a break in the TCP connection we will notice, and reopen
+	 * a connection with that osd (from the fault callback).
+	 */
+	INIT_LIST_HEAD(&slow_osds);
+	list_for_each_entry(req, &osdc->req_lru, r_req_lru_item) {
+		if (time_before(jiffies, req->r_sent_stamp + keepalive))
+			break;
+
+		osd = req->r_osd;
+		BUG_ON(!osd);
+		dout(" tid %llu is slow, will send keepalive on osd%d\n",
+		     req->r_tid, osd->o_osd);
+		list_move_tail(&osd->o_keepalive_item, &slow_osds);
+	}
+	while (!list_empty(&slow_osds)) {
+		osd = list_entry(slow_osds.next, struct ceph_osd,
+				 o_keepalive_item);
+		list_del_init(&osd->o_keepalive_item);
+		ceph_con_keepalive(&osd->o_con);
+	}
+
+	__schedule_osd_timeout(osdc);
+	mutex_unlock(&osdc->request_mutex);
+
+	up_read(&osdc->map_sem);
+}
+
+static void handle_osds_timeout(struct work_struct *work)
+{
+	struct ceph_osd_client *osdc =
+		container_of(work, struct ceph_osd_client,
+			     osds_timeout_work.work);
+	unsigned long delay =
+		osdc->client->mount_args->osd_idle_ttl * HZ >> 2;
+
+	dout("osds timeout\n");
+	down_read(&osdc->map_sem);
+	remove_old_osds(osdc, 0);
+	up_read(&osdc->map_sem);
+
+	schedule_delayed_work(&osdc->osds_timeout_work,
+			      round_jiffies_relative(delay));
+}
+
+/*
+ * handle osd op reply.  either call the callback if it is specified,
+ * or do the completion to wake up the waiting thread.
+ */
+static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
+			 struct ceph_connection *con)
+{
+	struct ceph_osd_reply_head *rhead = msg->front.iov_base;
+	struct ceph_osd_request *req;
+	u64 tid;
+	int numops, object_len, flags;
+
+	tid = le64_to_cpu(msg->hdr.tid);
+	if (msg->front.iov_len < sizeof(*rhead))
+		goto bad;
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
+	/*
+	 * if this connection filled our message, drop our reference now, to
+	 * avoid a (safe but slower) revoke later.
+	 */
+	if (req->r_con_filling_msg == con && req->r_reply == msg) {
+		dout(" dropping con_filling_msg ref %p\n", con);
+		req->r_con_filling_msg = NULL;
+		ceph_con_put(con);
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
+		mutex_unlock(&osdc->request_mutex);
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
+	ceph_msg_dump(msg);
+}
+
+
+static int __kick_requests(struct ceph_osd_client *osdc,
+			  struct ceph_osd *kickosd)
+{
+	struct ceph_osd_request *req;
+	struct rb_node *p, *n;
+	int needmap = 0;
+	int err;
+
+	dout("kick_requests osd%d\n", kickosd ? kickosd->o_osd : -1);
+	if (kickosd) {
+		__reset_osd(osdc, kickosd);
+	} else {
+		for (p = rb_first(&osdc->osds); p; p = n) {
+			struct ceph_osd *osd =
+				rb_entry(p, struct ceph_osd, o_node);
+
+			n = rb_next(p);
+			if (!ceph_osd_is_up(osdc->osdmap, osd->o_osd) ||
+			    memcmp(&osd->o_con.peer_addr,
+				   ceph_osd_addr(osdc->osdmap,
+						 osd->o_osd),
+				   sizeof(struct ceph_entity_addr)) != 0)
+				__reset_osd(osdc, osd);
+		}
+	}
+
+	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+		req = rb_entry(p, struct ceph_osd_request, r_node);
+
+		if (req->r_resend) {
+			dout(" r_resend set on tid %llu\n", req->r_tid);
+			__cancel_request(req);
+			goto kick;
+		}
+		if (req->r_osd && kickosd == req->r_osd) {
+			__cancel_request(req);
+			goto kick;
+		}
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
+		dout("kicking %p tid %llu osd%d\n", req, req->r_tid,
+		     req->r_osd->o_osd);
+		req->r_flags |= CEPH_OSD_FLAG_RETRY;
+		err = __send_request(osdc, req);
+		if (err) {
+			dout(" setting r_resend on %llu\n", req->r_tid);
+			req->r_resend = true;
+		}
+	}
+
+	return needmap;
+}
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
+	int needmap;
+
+	mutex_lock(&osdc->request_mutex);
+	needmap = __kick_requests(osdc, kickosd);
+	mutex_unlock(&osdc->request_mutex);
+
+	if (needmap) {
+		dout("%d requests for down osds, need new map\n", needmap);
+		ceph_monc_request_next_osdmap(&osdc->client->monc);
+	}
+
+}
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
+	if (ceph_check_fsid(osdc->client, &fsid) < 0)
+		return;
+
+	down_write(&osdc->map_sem);
+
+	/* incremental maps */
+	ceph_decode_32_safe(&p, end, nr_maps, bad);
+	dout(" %d inc maps\n", nr_maps);
+	while (nr_maps > 0) {
+		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
+		epoch = ceph_decode_32(&p);
+		maplen = ceph_decode_32(&p);
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
+			BUG_ON(!newmap);
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
+		epoch = ceph_decode_32(&p);
+		maplen = ceph_decode_32(&p);
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
+			BUG_ON(!newmap);
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
+	ceph_msg_dump(msg);
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
+static int __prepare_pages(struct ceph_connection *con,
+			 struct ceph_msg_header *hdr,
+			 struct ceph_osd_request *req,
+			 u64 tid,
+			 struct ceph_msg *m)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc;
+	int ret = -1;
+	int data_len = le32_to_cpu(hdr->data_len);
+	unsigned data_off = le16_to_cpu(hdr->data_off);
+
+	int want = calc_pages_for(data_off & ~PAGE_MASK, data_len);
+
+	if (!osd)
+		return -1;
+
+	osdc = osd->o_osdc;
+
+	dout("__prepare_pages on msg %p tid %llu, has %d pages, want %d\n", m,
+	     tid, req->r_num_pages, want);
+	if (unlikely(req->r_num_pages < want))
+		goto out;
+	m->pages = req->r_pages;
+	m->nr_pages = req->r_num_pages;
+	ret = 0; /* success */
+out:
+	BUG_ON(ret < 0 || m->nr_pages < want);
+
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
+	int rc = 0;
+
+	req->r_request->pages = req->r_pages;
+	req->r_request->nr_pages = req->r_num_pages;
+
+	register_request(osdc, req);
+
+	down_read(&osdc->map_sem);
+	mutex_lock(&osdc->request_mutex);
+	/*
+	 * a racing kick_requests() may have sent the message for us
+	 * while we dropped request_mutex above, so only send now if
+	 * the request still han't been touched yet.
+	 */
+	if (req->r_sent == 0) {
+		rc = __send_request(osdc, req);
+		if (rc) {
+			if (nofail) {
+				dout("osdc_start_request failed send, "
+				     " marking %lld\n", req->r_tid);
+				req->r_resend = true;
+				rc = 0;
+			} else {
+				__unregister_request(osdc, req);
+			}
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
+		__unregister_request(osdc, req);
+		mutex_unlock(&osdc->request_mutex);
+		dout("wait_request tid %llu canceled/timed out\n", req->r_tid);
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
+	osdc->last_tid = 0;
+	osdc->osds = RB_ROOT;
+	INIT_LIST_HEAD(&osdc->osd_lru);
+	osdc->requests = RB_ROOT;
+	INIT_LIST_HEAD(&osdc->req_lru);
+	osdc->num_requests = 0;
+	INIT_DELAYED_WORK(&osdc->timeout_work, handle_timeout);
+	INIT_DELAYED_WORK(&osdc->osds_timeout_work, handle_osds_timeout);
+
+	schedule_delayed_work(&osdc->osds_timeout_work,
+	   round_jiffies_relative(osdc->client->mount_args->osd_idle_ttl * HZ));
+
+	err = -ENOMEM;
+	osdc->req_mempool = mempool_create_kmalloc_pool(10,
+					sizeof(struct ceph_osd_request));
+	if (!osdc->req_mempool)
+		goto out;
+
+	err = ceph_msgpool_init(&osdc->msgpool_op, OSD_OP_FRONT_LEN, 10, true);
+	if (err < 0)
+		goto out_mempool;
+	err = ceph_msgpool_init(&osdc->msgpool_op_reply,
+				OSD_OPREPLY_FRONT_LEN, 10, true);
+	if (err < 0)
+		goto out_msgpool;
+	return 0;
+
+out_msgpool:
+	ceph_msgpool_destroy(&osdc->msgpool_op);
+out_mempool:
+	mempool_destroy(osdc->req_mempool);
+out:
+	return err;
+}
+
+void ceph_osdc_stop(struct ceph_osd_client *osdc)
+{
+	cancel_delayed_work_sync(&osdc->timeout_work);
+	cancel_delayed_work_sync(&osdc->osds_timeout_work);
+	if (osdc->osdmap) {
+		ceph_osdmap_destroy(osdc->osdmap);
+		osdc->osdmap = NULL;
+	}
+	remove_old_osds(osdc, 1);
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
+	struct ceph_osd_client *osdc;
+	int type = le16_to_cpu(msg->hdr.type);
+
+	if (!osd)
+		return;
+	osdc = osd->o_osdc;
+
+	switch (type) {
+	case CEPH_MSG_OSD_MAP:
+		ceph_osdc_handle_map(osdc, msg);
+		break;
+	case CEPH_MSG_OSD_OPREPLY:
+		handle_reply(osdc, msg, con);
+		break;
+
+	default:
+		pr_err("received unknown message type %d %s\n", type,
+		       ceph_msg_type_name(type));
+	}
+	ceph_msg_put(msg);
+}
+
+/*
+ * lookup and return message for incoming reply
+ */
+static struct ceph_msg *get_reply(struct ceph_connection *con,
+				  struct ceph_msg_header *hdr,
+				  int *skip)
+{
+	struct ceph_osd *osd = con->private;
+	struct ceph_osd_client *osdc = osd->o_osdc;
+	struct ceph_msg *m;
+	struct ceph_osd_request *req;
+	int front = le32_to_cpu(hdr->front_len);
+	int data_len = le32_to_cpu(hdr->data_len);
+	u64 tid;
+	int err;
+
+	tid = le64_to_cpu(hdr->tid);
+	mutex_lock(&osdc->request_mutex);
+	req = __lookup_request(osdc, tid);
+	if (!req) {
+		*skip = 1;
+		m = NULL;
+		pr_info("get_reply unknown tid %llu from osd%d\n", tid,
+			osd->o_osd);
+		goto out;
+	}
+
+	if (req->r_con_filling_msg) {
+		dout("get_reply revoking msg %p from old con %p\n",
+		     req->r_reply, req->r_con_filling_msg);
+		ceph_con_revoke_message(req->r_con_filling_msg, req->r_reply);
+		ceph_con_put(req->r_con_filling_msg);
+	}
+
+	if (front > req->r_reply->front.iov_len) {
+		pr_warning("get_reply front %d > preallocated %d\n",
+			   front, (int)req->r_reply->front.iov_len);
+		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front, 0, 0, NULL);
+		if (IS_ERR(m))
+			goto out;
+		ceph_msg_put(req->r_reply);
+		req->r_reply = m;
+	}
+	m = ceph_msg_get(req->r_reply);
+
+	if (data_len > 0) {
+		err = __prepare_pages(con, hdr, req, tid, m);
+		if (err < 0) {
+			*skip = 1;
+			ceph_msg_put(m);
+			m = ERR_PTR(err);
+		}
+	}
+	*skip = 0;
+	req->r_con_filling_msg = ceph_con_get(con);
+	dout("get_reply tid %lld %p\n", tid, m);
+
+out:
+	mutex_unlock(&osdc->request_mutex);
+	return m;
+
+}
+
+static struct ceph_msg *alloc_msg(struct ceph_connection *con,
+				  struct ceph_msg_header *hdr,
+				  int *skip)
+{
+	struct ceph_osd *osd = con->private;
+	int type = le16_to_cpu(hdr->type);
+	int front = le32_to_cpu(hdr->front_len);
+
+	switch (type) {
+	case CEPH_MSG_OSD_MAP:
+		return ceph_msg_new(type, front, 0, 0, NULL);
+	case CEPH_MSG_OSD_OPREPLY:
+		return get_reply(con, hdr, skip);
+	default:
+		pr_info("alloc_msg unexpected msg type %d from osd%d\n", type,
+			osd->o_osd);
+		*skip = 1;
+		return NULL;
+	}
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
+/*
+ * authentication
+ */
+static int get_authorizer(struct ceph_connection *con,
+	                  void **buf, int *len, int *proto,
+	                  void **reply_buf, int *reply_len, int force_new)
+{
+	struct ceph_osd *o = con->private;
+	struct ceph_osd_client *osdc = o->o_osdc;
+	struct ceph_auth_client *ac = osdc->client->monc.auth;
+	int ret = 0;
+
+	if (force_new && o->o_authorizer) {
+		ac->ops->destroy_authorizer(ac, o->o_authorizer);
+		o->o_authorizer = NULL;
+	}
+	if (o->o_authorizer == NULL) {
+		ret = ac->ops->create_authorizer(
+			ac, CEPH_ENTITY_TYPE_OSD,
+			&o->o_authorizer,
+			&o->o_authorizer_buf,
+			&o->o_authorizer_buf_len,
+			&o->o_authorizer_reply_buf,
+			&o->o_authorizer_reply_buf_len);
+		if (ret)
+		return ret;
+	}
+
+	*proto = ac->protocol;
+	*buf = o->o_authorizer_buf;
+	*len = o->o_authorizer_buf_len;
+	*reply_buf = o->o_authorizer_reply_buf;
+	*reply_len = o->o_authorizer_reply_buf_len;
+	return 0;
+}
+
+
+static int verify_authorizer_reply(struct ceph_connection *con, int len)
+{
+	struct ceph_osd *o = con->private;
+	struct ceph_osd_client *osdc = o->o_osdc;
+	struct ceph_auth_client *ac = osdc->client->monc.auth;
+
+	return ac->ops->verify_authorizer_reply(ac, o->o_authorizer, len);
+}
+
+static int invalidate_authorizer(struct ceph_connection *con)
+{
+	struct ceph_osd *o = con->private;
+	struct ceph_osd_client *osdc = o->o_osdc;
+	struct ceph_auth_client *ac = osdc->client->monc.auth;
+
+	if (ac->ops->invalidate_authorizer)
+		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
+
+	return ceph_monc_validate_auth(&osdc->client->monc);
+}
+
+const static struct ceph_connection_operations osd_con_ops = {
+	.get = get_osd_con,
+	.put = put_osd_con,
+	.dispatch = dispatch,
+	.get_authorizer = get_authorizer,
+	.verify_authorizer_reply = verify_authorizer_reply,
+	.invalidate_authorizer = invalidate_authorizer,
+	.alloc_msg = alloc_msg,
+	.fault = osd_reset,
+};
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
new file mode 100644
index 0000000..1b1a3ca
--- /dev/null
+++ b/fs/ceph/osd_client.h
@@ -0,0 +1,166 @@
+#ifndef _FS_CEPH_OSD_CLIENT_H
+#define _FS_CEPH_OSD_CLIENT_H
+
+#include <linux/completion.h>
+#include <linux/kref.h>
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
+struct ceph_authorizer;
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
+	struct list_head o_osd_lru;
+	struct ceph_authorizer *o_authorizer;
+	void *o_authorizer_buf, *o_authorizer_reply_buf;
+	size_t o_authorizer_buf_len, o_authorizer_reply_buf_len;
+	unsigned long lru_ttl;
+	int o_marked_for_keepalive;
+	struct list_head o_keepalive_item;
+};
+
+/* an in-flight request */
+struct ceph_osd_request {
+	u64             r_tid;              /* unique for this client */
+	struct rb_node  r_node;
+	struct list_head r_req_lru_item;
+	struct list_head r_osd_item;
+	struct ceph_osd *r_osd;
+	struct ceph_pg   r_pgid;
+
+	struct ceph_connection *r_con_filling_msg;
+
+	struct ceph_msg  *r_request, *r_reply;
+	int               r_result;
+	int               r_flags;     /* any additional flags for the osd */
+	u32               r_sent;      /* >0 if r_request is sending/sent */
+	int               r_got_reply;
+
+	struct ceph_osd_client *r_osdc;
+	struct kref       r_kref;
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
+	unsigned long     r_sent_stamp;
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
+	struct list_head       osd_lru;       /* idle osds */
+	u64                    timeout_tid;   /* tid of timeout triggering rq */
+	u64                    last_tid;      /* tid of last request */
+	struct rb_root         requests;      /* pending requests */
+	struct list_head       req_lru;	      /* pending requests lru */
+	int                    num_requests;
+	struct delayed_work    timeout_work;
+	struct delayed_work    osds_timeout_work;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry 	       *debugfs_file;
+#endif
+
+	mempool_t              *req_mempool;
+
+	struct ceph_msgpool	msgpool_op;
+	struct ceph_msgpool	msgpool_op_reply;
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
+	kref_get(&req->r_kref);
+}
+extern void ceph_osdc_release_request(struct kref *kref);
+static inline void ceph_osdc_put_request(struct ceph_osd_request *req)
+{
+	kref_put(&req->r_kref, ceph_osdc_release_request);
+}
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
index 0000000..b83f269
--- /dev/null
+++ b/fs/ceph/osdmap.c
@@ -0,0 +1,1019 @@
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
+	b->item_weight = ceph_decode_32(p);
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
+		b->item_weights[j] = ceph_decode_32(p);
+		b->sum_weights[j] = ceph_decode_32(p);
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
+		b->node_weights[j] = ceph_decode_32(p);
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
+		b->item_weights[j] = ceph_decode_32(p);
+		b->straws[j] = ceph_decode_32(p);
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
+	magic = ceph_decode_32(p);
+	if (magic != CRUSH_MAGIC) {
+		pr_err("crush_decode magic %x != current %x\n",
+		       (unsigned)magic, (unsigned)CRUSH_MAGIC);
+		goto bad;
+	}
+	c->max_buckets = ceph_decode_32(p);
+	c->max_rules = ceph_decode_32(p);
+	c->max_devices = ceph_decode_32(p);
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
+			err = -EINVAL;
+			goto bad;
+		}
+		BUG_ON(size == 0);
+		b = c->buckets[i] = kzalloc(size, GFP_NOFS);
+		if (b == NULL)
+			goto badmem;
+
+		ceph_decode_need(p, end, 4*sizeof(u32), bad);
+		b->id = ceph_decode_32(p);
+		b->type = ceph_decode_16(p);
+		b->alg = ceph_decode_8(p);
+		b->hash = ceph_decode_8(p);
+		b->weight = ceph_decode_32(p);
+		b->size = ceph_decode_32(p);
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
+			b->items[j] = ceph_decode_32(p);
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
+		err = -EINVAL;
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
+			r->steps[j].op = ceph_decode_32(p);
+			r->steps[j].arg1 = ceph_decode_32(p);
+			r->steps[j].arg2 = ceph_decode_32(p);
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
+	while (!RB_EMPTY_ROOT(&map->pg_temp)) {
+		struct ceph_pg_mapping *pg =
+			rb_entry(rb_first(&map->pg_temp),
+				 struct ceph_pg_mapping, node);
+		rb_erase(&pg->node, &map->pg_temp);
+		kfree(pg);
+	}
+	while (!RB_EMPTY_ROOT(&map->pg_pools)) {
+		struct ceph_pg_pool_info *pi =
+			rb_entry(rb_first(&map->pg_pools),
+				 struct ceph_pg_pool_info, node);
+		rb_erase(&pi->node, &map->pg_pools);
+		kfree(pi);
+	}
+	kfree(map->osd_state);
+	kfree(map->osd_weight);
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
+ * rbtree of pg_mapping for handling pg_temp (explicit mapping of pgid
+ * to a set of osds)
+ */
+static int pgid_cmp(struct ceph_pg l, struct ceph_pg r)
+{
+	u64 a = *(u64 *)&l;
+	u64 b = *(u64 *)&r;
+
+	if (a < b)
+		return -1;
+	if (a > b)
+		return 1;
+	return 0;
+}
+
+static int __insert_pg_mapping(struct ceph_pg_mapping *new,
+			       struct rb_root *root)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct ceph_pg_mapping *pg = NULL;
+	int c;
+
+	while (*p) {
+		parent = *p;
+		pg = rb_entry(parent, struct ceph_pg_mapping, node);
+		c = pgid_cmp(new->pgid, pg->pgid);
+		if (c < 0)
+			p = &(*p)->rb_left;
+		else if (c > 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&new->node, parent, p);
+	rb_insert_color(&new->node, root);
+	return 0;
+}
+
+static struct ceph_pg_mapping *__lookup_pg_mapping(struct rb_root *root,
+						   struct ceph_pg pgid)
+{
+	struct rb_node *n = root->rb_node;
+	struct ceph_pg_mapping *pg;
+	int c;
+
+	while (n) {
+		pg = rb_entry(n, struct ceph_pg_mapping, node);
+		c = pgid_cmp(pgid, pg->pgid);
+		if (c < 0)
+			n = n->rb_left;
+		else if (c > 0)
+			n = n->rb_right;
+		else
+			return pg;
+	}
+	return NULL;
+}
+
+/*
+ * rbtree of pg pool info
+ */
+static int __insert_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *new)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct ceph_pg_pool_info *pi = NULL;
+
+	while (*p) {
+		parent = *p;
+		pi = rb_entry(parent, struct ceph_pg_pool_info, node);
+		if (new->id < pi->id)
+			p = &(*p)->rb_left;
+		else if (new->id > pi->id)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&new->node, parent, p);
+	rb_insert_color(&new->node, root);
+	return 0;
+}
+
+static struct ceph_pg_pool_info *__lookup_pg_pool(struct rb_root *root, int id)
+{
+	struct ceph_pg_pool_info *pi;
+	struct rb_node *n = root->rb_node;
+
+	while (n) {
+		pi = rb_entry(n, struct ceph_pg_pool_info, node);
+		if (id < pi->id)
+			n = n->rb_left;
+		else if (id > pi->id)
+			n = n->rb_right;
+		else
+			return pi;
+	}
+	return NULL;
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
+	u8 ev;
+	int err = -EINVAL;
+	void *start = *p;
+	struct ceph_pg_pool_info *pi;
+
+	dout("osdmap_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	map = kzalloc(sizeof(*map), GFP_NOFS);
+	if (map == NULL)
+		return ERR_PTR(-ENOMEM);
+	map->pg_temp = RB_ROOT;
+
+	ceph_decode_16_safe(p, end, version, bad);
+	if (version > CEPH_OSDMAP_VERSION) {
+		pr_warning("got unknown v %d > %d of osdmap\n", version,
+			   CEPH_OSDMAP_VERSION);
+		goto bad;
+	}
+
+	ceph_decode_need(p, end, 2*sizeof(u64)+6*sizeof(u32), bad);
+	ceph_decode_copy(p, &map->fsid, sizeof(map->fsid));
+	map->epoch = ceph_decode_32(p);
+	ceph_decode_copy(p, &map->created, sizeof(map->created));
+	ceph_decode_copy(p, &map->modified, sizeof(map->modified));
+
+	ceph_decode_32_safe(p, end, max, bad);
+	while (max--) {
+		ceph_decode_need(p, end, 4 + 1 + sizeof(pi->v), bad);
+		pi = kmalloc(sizeof(*pi), GFP_NOFS);
+		if (!pi)
+			goto bad;
+		pi->id = ceph_decode_32(p);
+		ev = ceph_decode_8(p); /* encoding version */
+		if (ev > CEPH_PG_POOL_VERSION) {
+			pr_warning("got unknown v %d > %d of ceph_pg_pool\n",
+				   ev, CEPH_PG_POOL_VERSION);
+			goto bad;
+		}
+		ceph_decode_copy(p, &pi->v, sizeof(pi->v));
+		__insert_pg_pool(&map->pg_pools, pi);
+		calc_pg_masks(pi);
+		*p += le32_to_cpu(pi->v.num_snaps) * sizeof(u64);
+		*p += le32_to_cpu(pi->v.num_removed_snap_intervals)
+			* sizeof(u64) * 2;
+	}
+	ceph_decode_32_safe(p, end, map->pool_max, bad);
+
+	ceph_decode_32_safe(p, end, map->flags, bad);
+
+	max = ceph_decode_32(p);
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
+		map->osd_weight[i] = ceph_decode_32(p);
+
+	*p += 4; /* skip length field (should match max) */
+	ceph_decode_copy(p, map->osd_addr, map->max_osd*sizeof(*map->osd_addr));
+	for (i = 0; i < map->max_osd; i++)
+		ceph_decode_addr(&map->osd_addr[i]);
+
+	/* pg_temp */
+	ceph_decode_32_safe(p, end, len, bad);
+	for (i = 0; i < len; i++) {
+		int n, j;
+		struct ceph_pg pgid;
+		struct ceph_pg_mapping *pg;
+
+		ceph_decode_need(p, end, sizeof(u32) + sizeof(u64), bad);
+		ceph_decode_copy(p, &pgid, sizeof(pgid));
+		n = ceph_decode_32(p);
+		ceph_decode_need(p, end, n * sizeof(u32), bad);
+		err = -ENOMEM;
+		pg = kmalloc(sizeof(*pg) + n*sizeof(u32), GFP_NOFS);
+		if (!pg)
+			goto bad;
+		pg->pgid = pgid;
+		pg->len = n;
+		for (j = 0; j < n; j++)
+			pg->osds[j] = ceph_decode_32(p);
+
+		err = __insert_pg_mapping(pg, &map->pg_temp);
+		if (err)
+			goto bad;
+		dout(" added pg_temp %llx len %d\n", *(u64 *)&pgid, len);
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
+	struct crush_map *newcrush = NULL;
+	struct ceph_fsid fsid;
+	u32 epoch = 0;
+	struct ceph_timespec modified;
+	u32 len, pool;
+	__s32 new_pool_max, new_flags, max;
+	void *start = *p;
+	int err = -EINVAL;
+	u16 version;
+	struct rb_node *rbp;
+
+	ceph_decode_16_safe(p, end, version, bad);
+	if (version > CEPH_OSDMAP_INC_VERSION) {
+		pr_warning("got unknown v %d > %d of inc osdmap\n", version,
+			   CEPH_OSDMAP_INC_VERSION);
+		goto bad;
+	}
+
+	ceph_decode_need(p, end, sizeof(fsid)+sizeof(modified)+2*sizeof(u32),
+			 bad);
+	ceph_decode_copy(p, &fsid, sizeof(fsid));
+	epoch = ceph_decode_32(p);
+	BUG_ON(epoch != map->epoch+1);
+	ceph_decode_copy(p, &modified, sizeof(modified));
+	new_pool_max = ceph_decode_32(p);
+	new_flags = ceph_decode_32(p);
+
+	/* full map? */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len > 0) {
+		dout("apply_incremental full map len %d, %p to %p\n",
+		     len, *p, end);
+		return osdmap_decode(p, min(*p+len, end));
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
+	if (new_pool_max >= 0)
+		map->pool_max = new_pool_max;
+
+	ceph_decode_need(p, end, 5*sizeof(u32), bad);
+
+	/* new max? */
+	max = ceph_decode_32(p);
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
+		__u8 ev;
+		struct ceph_pg_pool_info *pi;
+
+		ceph_decode_32_safe(p, end, pool, bad);
+		ceph_decode_need(p, end, 1 + sizeof(pi->v), bad);
+		ev = ceph_decode_8(p);  /* encoding version */
+		if (ev > CEPH_PG_POOL_VERSION) {
+			pr_warning("got unknown v %d > %d of ceph_pg_pool\n",
+				   ev, CEPH_PG_POOL_VERSION);
+			goto bad;
+		}
+		pi = __lookup_pg_pool(&map->pg_pools, pool);
+		if (!pi) {
+			pi = kmalloc(sizeof(*pi), GFP_NOFS);
+			if (!pi) {
+				err = -ENOMEM;
+				goto bad;
+			}
+			pi->id = pool;
+			__insert_pg_pool(&map->pg_pools, pi);
+		}
+		ceph_decode_copy(p, &pi->v, sizeof(pi->v));
+		calc_pg_masks(pi);
+	}
+
+	/* old_pool */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		struct ceph_pg_pool_info *pi;
+
+		ceph_decode_32_safe(p, end, pool, bad);
+		pi = __lookup_pg_pool(&map->pg_pools, pool);
+		if (pi) {
+			rb_erase(&pi->node, &map->pg_pools);
+			kfree(pi);
+		}
+	}
+
+	/* new_up */
+	err = -EINVAL;
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd;
+		struct ceph_entity_addr addr;
+		ceph_decode_32_safe(p, end, osd, bad);
+		ceph_decode_copy_safe(p, end, &addr, sizeof(addr), bad);
+		ceph_decode_addr(&addr);
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
+		pr_info("osd%d down\n", osd);
+		if (osd < map->max_osd)
+			map->osd_state[osd] &= ~CEPH_OSD_UP;
+	}
+
+	/* new_weight */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd, off;
+		ceph_decode_need(p, end, sizeof(u32)*2, bad);
+		osd = ceph_decode_32(p);
+		off = ceph_decode_32(p);
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
+		struct ceph_pg pgid;
+		u32 pglen;
+		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
+		ceph_decode_copy(p, &pgid, sizeof(pgid));
+		pglen = ceph_decode_32(p);
+
+		/* remove any? */
+		while (rbp && pgid_cmp(rb_entry(rbp, struct ceph_pg_mapping,
+						node)->pgid, pgid) <= 0) {
+			struct rb_node *cur = rbp;
+			rbp = rb_next(rbp);
+			dout(" removed pg_temp %llx\n",
+			     *(u64 *)&rb_entry(cur, struct ceph_pg_mapping,
+					       node)->pgid);
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
+			for (j = 0; j < pglen; j++)
+				pg->osds[j] = ceph_decode_32(p);
+			err = __insert_pg_mapping(pg, &map->pg_temp);
+			if (err)
+				goto bad;
+			dout(" added pg_temp %llx len %d\n", *(u64 *)&pgid,
+			     pglen);
+		}
+	}
+	while (rbp) {
+		struct rb_node *cur = rbp;
+		rbp = rb_next(rbp);
+		dout(" removed pg_temp %llx\n",
+		     *(u64 *)&rb_entry(cur, struct ceph_pg_mapping,
+				       node)->pgid);
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
+	print_hex_dump(KERN_DEBUG, "osdmap: ",
+		       DUMP_PREFIX_OFFSET, 16, 1,
+		       start, end - start, true);
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
+				   u64 *ono,
+				   u64 *oxoff, u64 *oxlen)
+{
+	u32 osize = le32_to_cpu(layout->fl_object_size);
+	u32 su = le32_to_cpu(layout->fl_stripe_unit);
+	u32 sc = le32_to_cpu(layout->fl_stripe_count);
+	u32 bl, stripeno, stripepos, objsetno;
+	u32 su_per_object;
+	u64 t, su_offset;
+
+	dout("mapping %llu~%llu  osize %u fl_su %u\n", off, *plen,
+	     osize, su);
+	su_per_object = osize / su;
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
+	*ono = objsetno * sc + stripepos;
+	dout("objset %u * sc %u = ono %u\n", objsetno, sc, (unsigned)*ono);
+
+	/* *oxoff = *off % layout->fl_stripe_unit;  # offset in su */
+	t = off;
+	su_offset = do_div(t, su);
+	*oxoff = su_offset + (stripeno % su_per_object) * su;
+
+	/*
+	 * Calculate the length of the extent being written to the selected
+	 * object. This is the minimum of the full length requested (plen) or
+	 * the remainder of the current stripe being written to.
+	 */
+	*oxlen = min_t(u64, *plen, su - su_offset);
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
+	struct ceph_pg pgid;
+	s32 preferred = (s32)le32_to_cpu(fl->fl_pg_preferred);
+	int poolid = le32_to_cpu(fl->fl_pg_pool);
+	struct ceph_pg_pool_info *pool;
+	unsigned ps;
+
+	BUG_ON(!osdmap);
+
+	pool = __lookup_pg_pool(&osdmap->pg_pools, poolid);
+	if (!pool)
+		return -EIO;
+	ps = ceph_str_hash(pool->v.object_hash, oid, strlen(oid));
+	if (preferred >= 0) {
+		ps += preferred;
+		num = le32_to_cpu(pool->v.lpg_num);
+		num_mask = pool->lpg_num_mask;
+	} else {
+		num = le32_to_cpu(pool->v.pg_num);
+		num_mask = pool->pg_num_mask;
+	}
+
+	pgid.ps = cpu_to_le16(ps);
+	pgid.preferred = cpu_to_le16(preferred);
+	pgid.pool = fl->fl_pg_pool;
+	if (preferred >= 0)
+		dout("calc_object_layout '%s' pgid %d.%xp%d\n", oid, poolid, ps,
+		     (int)preferred);
+	else
+		dout("calc_object_layout '%s' pgid %d.%x\n", oid, poolid, ps);
+
+	ol->ol_pgid = pgid;
+	ol->ol_stripe_unit = fl->fl_object_stripe_unit;
+	return 0;
+}
+
+/*
+ * Calculate raw osd vector for the given pgid.  Return pointer to osd
+ * array, or NULL on failure.
+ */
+static int *calc_pg_raw(struct ceph_osdmap *osdmap, struct ceph_pg pgid,
+			int *osds, int *num)
+{
+	struct ceph_pg_mapping *pg;
+	struct ceph_pg_pool_info *pool;
+	int ruleno;
+	unsigned poolid, ps, pps;
+	int preferred;
+
+	/* pg_temp? */
+	pg = __lookup_pg_mapping(&osdmap->pg_temp, pgid);
+	if (pg) {
+		*num = pg->len;
+		return pg->osds;
+	}
+
+	/* crush */
+	poolid = le32_to_cpu(pgid.pool);
+	ps = le16_to_cpu(pgid.ps);
+	preferred = (s16)le16_to_cpu(pgid.preferred);
+
+	/* don't forcefeed bad device ids to crush */
+	if (preferred >= osdmap->max_osd ||
+	    preferred >= osdmap->crush->max_devices)
+		preferred = -1;
+
+	pool = __lookup_pg_pool(&osdmap->pg_pools, poolid);
+	if (!pool)
+		return NULL;
+	ruleno = crush_find_rule(osdmap->crush, pool->v.crush_ruleset,
+				 pool->v.type, pool->v.size);
+	if (ruleno < 0) {
+		pr_err("no crush rule pool %d type %d size %d\n",
+		       poolid, pool->v.type, pool->v.size);
+		return NULL;
+	}
+
+	if (preferred >= 0)
+		pps = ceph_stable_mod(ps,
+				      le32_to_cpu(pool->v.lpgp_num),
+				      pool->lpgp_num_mask);
+	else
+		pps = ceph_stable_mod(ps,
+				      le32_to_cpu(pool->v.pgp_num),
+				      pool->pgp_num_mask);
+	pps += poolid;
+	*num = crush_do_rule(osdmap->crush, ruleno, pps, osds,
+			     min_t(int, pool->v.size, *num),
+			     preferred, osdmap->osd_weight);
+	return osds;
+}
+
+/*
+ * Return primary osd for given pgid, or -1 if none.
+ */
+int ceph_calc_pg_primary(struct ceph_osdmap *osdmap, struct ceph_pg pgid)
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
index 0000000..1fb55af
--- /dev/null
+++ b/fs/ceph/osdmap.h
@@ -0,0 +1,125 @@
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
+	struct rb_node node;
+	int id;
+	struct ceph_pg_pool v;
+	int pg_num_mask, pgp_num_mask, lpg_num_mask, lpgp_num_mask;
+};
+
+struct ceph_pg_mapping {
+	struct rb_node node;
+	struct ceph_pg pgid;
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
+	struct rb_root pg_pools;
+	u32 pool_max;
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
+extern int ceph_calc_pg_primary(struct ceph_osdmap *osdmap,
+				struct ceph_pg pgid);
+
+#endif
-- 
1.7.0

