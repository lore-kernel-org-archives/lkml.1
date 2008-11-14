Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbYKNBZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbYKNBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbYKNBWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:22:04 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38163 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbYKNBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:38 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 10/19] ceph: OSD client
Date: Thu, 13 Nov 2008 16:56:09 -0800
Message-Id: <1226624178-3761-11-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226624178-3761-10-git-send-email-sage@newdream.net>
References: <1226624178-3761-1-git-send-email-sage@newdream.net>
 <1226624178-3761-2-git-send-email-sage@newdream.net>
 <1226624178-3761-3-git-send-email-sage@newdream.net>
 <1226624178-3761-4-git-send-email-sage@newdream.net>
 <1226624178-3761-5-git-send-email-sage@newdream.net>
 <1226624178-3761-6-git-send-email-sage@newdream.net>
 <1226624178-3761-7-git-send-email-sage@newdream.net>
 <1226624178-3761-8-git-send-email-sage@newdream.net>
 <1226624178-3761-9-git-send-email-sage@newdream.net>
 <1226624178-3761-10-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OSD client is responsible for reading and writing data from/to the
object storage pool.  This includes determining where objects are
stored in the cluster, and ensuring that requests are retried or
redirected in the event of a node failure or data migration.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/osd_client.c | 1125 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/osd_client.h |  135 ++++++
 fs/ceph/osdmap.c     |  664 +++++++++++++++++++++++++++++
 fs/ceph/osdmap.h     |   82 ++++
 4 files changed, 2006 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/osd_client.c
 create mode 100644 fs/ceph/osd_client.h
 create mode 100644 fs/ceph/osdmap.c
 create mode 100644 fs/ceph/osdmap.h

diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
new file mode 100644
index 0000000..c25c9c7
--- /dev/null
+++ b/fs/ceph/osd_client.c
@@ -0,0 +1,1125 @@
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "ceph_debug.h"
+
+int ceph_debug_osdc = -1;
+#define DOUT_MASK DOUT_MASK_OSDC
+#define DOUT_VAR ceph_debug_osdc
+#define DOUT_PREFIX "osdc: "
+#include "super.h"
+
+#include "osd_client.h"
+#include "messenger.h"
+#include "crush/mapper.h"
+#include "decode.h"
+
+
+static void reschedule_timeout(struct ceph_osd_client *osdc,
+			       unsigned long base_time);
+
+
+
+/*
+ * calculate the mapping of a file extent onto an object, and fill out the
+ * request accordingly.  shorten extent as necessary if it crosses an
+ * object boundary.
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
+
+	/* object extent? */
+	reqhead->oid.ino = cpu_to_le64(vino.ino);
+	reqhead->oid.snap = cpu_to_le64(vino.snap);
+
+	calc_file_object_mapping(layout, off, plen, &reqhead->oid,
+				 &objoff, &objlen);
+	if (*plen < orig_len)
+		dout(10, " skipping last %llu, final file extent %llu~%llu\n",
+		     orig_len - *plen, off, *plen);
+	op->offset = cpu_to_le64(objoff);
+	op->length = cpu_to_le64(objlen);
+	req->r_num_pages = calc_pages_for(off, *plen);
+
+	/* pgid? */
+	calc_object_layout(&reqhead->layout, &reqhead->oid, layout,
+			   osdc->osdmap);
+
+	dout(10, "calc_layout %llx.%08x %llu~%llu pgid %llx (%d pages)\n",
+	     le64_to_cpu(reqhead->oid.ino), le32_to_cpu(reqhead->oid.bno),
+	     objoff, objlen, le64_to_cpu(reqhead->layout.ol_pgid),
+	     req->r_num_pages);
+}
+
+
+/*
+ * requests
+ */
+static void get_request(struct ceph_osd_request *req)
+{
+	atomic_inc(&req->r_ref);
+}
+
+void ceph_osdc_put_request(struct ceph_osd_request *req)
+{
+	dout(10, "put_request %p %d -> %d\n", req, atomic_read(&req->r_ref),
+	     atomic_read(&req->r_ref)-1);
+	BUG_ON(atomic_read(&req->r_ref) <= 0);
+	if (atomic_dec_and_test(&req->r_ref)) {
+		if (req->r_request)
+			ceph_msg_put(req->r_request);
+		if (req->r_reply)
+			ceph_msg_put(req->r_reply);
+		ceph_put_snap_context(req->r_snapc);
+		kfree(req);
+	}
+}
+
+/*
+ * build osd request message only.
+ */
+static struct ceph_msg *new_request_msg(struct ceph_osd_client *osdc, short opc,
+					struct ceph_snap_context *snapc)
+{
+	struct ceph_msg *req;
+	struct ceph_osd_request_head *head;
+	struct ceph_osd_op *op;
+	__le64 *snaps;
+	size_t size = sizeof(*head) + sizeof(*op);
+	int i;
+
+	if (snapc)
+		size += sizeof(u64) * snapc->num_snaps;
+	req = ceph_msg_new(CEPH_MSG_OSD_OP, size, 0, 0, NULL);
+	if (IS_ERR(req))
+		return req;
+	memset(req->front.iov_base, 0, req->front.iov_len);
+	head = req->front.iov_base;
+	op = (void *)(head + 1);
+	snaps = (void *)(op + 1);
+
+	/* encode head */
+	head->client_inc = cpu_to_le32(1); /* always, for now. */
+	head->flags = 0;
+	head->num_ops = cpu_to_le16(1);
+	op->op = cpu_to_le16(opc);
+
+	if (snapc) {
+		head->snap_seq = cpu_to_le64(snapc->seq);
+		head->num_snaps = cpu_to_le32(snapc->num_snaps);
+		for (i = 0; i < snapc->num_snaps; i++)
+			snaps[i] = cpu_to_le64(snapc->snaps[i]);
+	}
+	return req;
+}
+
+/*
+ * build new request AND message, calculate layout, and adjust file
+ * extent as needed.
+ */
+struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
+					       struct ceph_file_layout *layout,
+					       struct ceph_vino vino,
+					       u64 off, u64 *plen, int op,
+					       struct ceph_snap_context *snapc)
+{
+	struct ceph_osd_request *req;
+	struct ceph_msg *msg;
+	int num_pages = calc_pages_for(off, *plen);
+	struct ceph_osd_request_head *head;
+
+	/* we may overallocate here, if our write extent is shortened below */
+	req = kzalloc(sizeof(*req) + num_pages*sizeof(void *), GFP_NOFS);
+	if (req == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	msg = new_request_msg(osdc, op, snapc);
+	if (IS_ERR(msg)) {
+		kfree(req);
+		return ERR_PTR(PTR_ERR(msg));
+	}
+	req->r_request = msg;
+	req->r_snapc = ceph_get_snap_context(snapc);
+
+	/* calculate max write size, pgid */
+	calc_layout(osdc, vino, layout, off, plen, req);
+
+	head = msg->front.iov_base;
+	req->r_pgid.pg64 = le64_to_cpu(head->layout.ol_pgid);
+
+	atomic_set(&req->r_ref, 1);
+	init_completion(&req->r_completion);
+	return req;
+}
+
+
+/*
+ * register request, assign tid.
+ */
+static int register_request(struct ceph_osd_client *osdc,
+			    struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *head = req->r_request->front.iov_base;
+	int rc;
+
+	mutex_lock(&osdc->request_mutex);
+	req->r_tid = ++osdc->last_tid;
+	head->tid = cpu_to_le64(req->r_tid);
+
+	dout(30, "register_request %p tid %lld\n", req, req->r_tid);
+	rc = radix_tree_insert(&osdc->request_tree, req->r_tid, (void *)req);
+	if (rc < 0)
+		goto out;
+
+	get_request(req);
+	if (osdc->num_requests == 0) {
+		osdc->timeout_tid = req->r_tid;
+		dout(10, "setting timeout_tid=%lld\n", osdc->timeout_tid);
+		reschedule_timeout(osdc, 0);
+	}
+	osdc->num_requests++;
+
+out:
+	mutex_unlock(&osdc->request_mutex);
+	return rc;
+}
+
+
+static void __register_next_request_timeout(struct ceph_osd_client *osdc,
+				 struct ceph_osd_request *req)
+{
+	struct ceph_osd_request *next_req;
+	int ret;
+
+	ret = radix_tree_gang_lookup(&osdc->request_tree, (void **)&next_req,
+						     req->r_tid+1, 1);
+	if (!ret || (next_req->r_tid == osdc->timeout_tid))
+			ret = radix_tree_gang_lookup(&osdc->request_tree,
+						     (void **)&next_req, 0, 1);
+
+	if (ret == 1) {
+		dout(10, "replacing timeout_tid: %lld-> %lld\n",
+		     osdc->timeout_tid, next_req->r_tid);
+		osdc->timeout_tid = next_req->r_tid;
+		reschedule_timeout(osdc, req->r_last_stamp);
+	}
+}
+
+/*
+ * called under osdc->request_mutex
+ */
+static void __unregister_request(struct ceph_osd_client *osdc,
+				 struct ceph_osd_request *req)
+{
+	dout(30, "__unregister_request %p tid %lld\n", req, req->r_tid);
+	radix_tree_delete(&osdc->request_tree, req->r_tid);
+
+	osdc->num_requests--;
+	if (req->r_tid == osdc->timeout_tid) {
+		cancel_delayed_work(&osdc->timeout_work);
+		if (osdc->num_requests)
+			__register_next_request_timeout(osdc, req);
+	}
+
+	ceph_osdc_put_request(req);
+}
+
+/*
+ * pick an osd.  the first up osd in the pg.  or -1.
+ * caller should hold map_sem for read.
+ */
+static int pick_osd(struct ceph_osd_client *osdc,
+		    struct ceph_osd_request *req)
+{
+	int ruleno;
+	unsigned pps; /* placement ps */
+	int osds[10];
+	int i, num;
+
+	ruleno = crush_find_rule(osdc->osdmap->crush, req->r_pgid.pg.pool,
+				 req->r_pgid.pg.type, req->r_pgid.pg.size);
+	if (ruleno < 0) {
+		derr(0, "pick_osd no crush rule for pool %d type %d size %d\n",
+		     req->r_pgid.pg.pool, req->r_pgid.pg.type,
+		     req->r_pgid.pg.size);
+		return -1;
+	}
+
+	if (req->r_pgid.pg.preferred >= 0)
+		pps = ceph_stable_mod(req->r_pgid.pg.ps,
+				     osdc->osdmap->lpgp_num,
+				     osdc->osdmap->lpgp_num_mask);
+	else
+		pps = ceph_stable_mod(req->r_pgid.pg.ps,
+				     osdc->osdmap->pgp_num,
+				     osdc->osdmap->pgp_num_mask);
+	num = crush_do_rule(osdc->osdmap->crush, ruleno, pps, osds,
+			    min_t(int, req->r_pgid.pg.size, ARRAY_SIZE(osds)),
+			    req->r_pgid.pg.preferred, osdc->osdmap->osd_weight);
+
+	for (i = 0; i < num; i++)
+		if (ceph_osd_is_up(osdc->osdmap, osds[i]))
+			return osds[i];
+	return -1;
+}
+
+/*
+ * caller should hold map_sem (for read)
+ */
+static int send_request(struct ceph_osd_client *osdc,
+			struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead;
+	int osd;
+
+	osd = pick_osd(osdc, req);
+	if (osd < 0) {
+		dout(10, "send_request %p no up osds in pg\n", req);
+		ceph_monc_request_osdmap(&osdc->client->monc,
+					 osdc->osdmap->epoch+1);
+		return 0;
+	}
+
+	dout(10, "send_request %p tid %llu to osd%d flags %d\n",
+	     req, req->r_tid, osd, req->r_flags);
+
+	reqhead = req->r_request->front.iov_base;
+	reqhead->osdmap_epoch = cpu_to_le32(osdc->osdmap->epoch);
+	reqhead->flags |= cpu_to_le32(req->r_flags);  /* e.g., RETRY */
+
+	req->r_request->hdr.dst.name.type =
+		cpu_to_le32(CEPH_ENTITY_TYPE_OSD);
+	req->r_request->hdr.dst.name.num = cpu_to_le32(osd);
+	req->r_request->hdr.dst.addr = osdc->osdmap->osd_addr[osd];
+
+	req->r_last_osd = osd;
+	req->r_last_osd_addr = req->r_request->hdr.dst.addr;
+	req->r_last_stamp = jiffies;
+
+	ceph_msg_get(req->r_request); /* send consumes a ref */
+	return ceph_msg_send(osdc->client->msgr, req->r_request,
+			     BASE_DELAY_INTERVAL);
+}
+
+/*
+ * handle osd op reply.  either call the callback if it is specified,
+ * or do the completion to wake up the waiting thread.
+ */
+void ceph_osdc_handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg)
+{
+	struct ceph_osd_reply_head *rhead = msg->front.iov_base;
+	struct ceph_osd_request *req;
+	u64 tid;
+	int numops;
+
+	if (msg->front.iov_len < sizeof(*rhead))
+		goto bad;
+	tid = le64_to_cpu(rhead->tid);
+	numops = le32_to_cpu(rhead->num_ops);
+	if (msg->front.iov_len != sizeof(*rhead) +
+	    numops * sizeof(struct ceph_osd_op))
+		goto bad;
+	dout(10, "handle_reply %p tid %llu\n", msg, tid);
+
+	/* lookup */
+	mutex_lock(&osdc->request_mutex);
+	req = radix_tree_lookup(&osdc->request_tree, tid);
+	if (req == NULL) {
+		dout(10, "handle_reply tid %llu dne\n", tid);
+		mutex_unlock(&osdc->request_mutex);
+		return;
+	}
+	get_request(req);
+	if (req->r_reply == NULL) {
+		/* no data payload, or r_reply would have been set by
+		   prepare_pages. */
+		ceph_msg_get(msg);
+		req->r_reply = msg;
+	} else if (req->r_reply == msg) {
+		/* r_reply was set by prepare_pages; now it's fully read. */
+	} else {
+		dout(10, "handle_reply tid %llu already had reply?\n", tid);
+		goto done;
+	}
+	dout(10, "handle_reply tid %llu flags %d\n", tid,
+	     le32_to_cpu(rhead->flags));
+	__unregister_request(osdc, req);
+	mutex_unlock(&osdc->request_mutex);
+
+	if (req->r_callback)
+		req->r_callback(req);
+	else
+		complete(&req->r_completion);  /* see do_sync_request */
+done:
+	ceph_osdc_put_request(req);
+	return;
+
+bad:
+	derr(0, "got corrupt osd_op_reply got %d %d expected %d\n",
+	     (int)msg->front.iov_len, le32_to_cpu(msg->hdr.front_len),
+	     (int)sizeof(*rhead));
+}
+
+
+/*
+ * Resubmit osd requests whose osd or osd address has changed.  Request
+ * a new osd map if osds are down, or we are otherwise unable to determine
+ * how to direct a request.
+ *
+ * If @who is specified, resubmit requests for that specific osd.
+ *
+ * Caller should hold map_sem for read.
+ */
+static void kick_requests(struct ceph_osd_client *osdc,
+			  struct ceph_entity_addr *who)
+{
+	struct ceph_osd_request *req;
+	u64 next_tid = 0;
+	int got;
+	int osd;
+	int needmap = 0;
+
+	mutex_lock(&osdc->request_mutex);
+	while (1) {
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+		if (got == 0)
+			break;
+		next_tid = req->r_tid + 1;
+		osd = pick_osd(osdc, req);
+		if (osd < 0 || osd >= osdc->osdmap->max_osd) {
+			dout(20, "tid %llu maps to no valid osd\n", req->r_tid);
+			needmap++;  /* request a newer map */
+			req->r_last_osd = -1;
+			memset(&req->r_last_osd_addr, 0,
+			       sizeof(req->r_last_osd_addr));
+			continue;
+		}
+		if (!ceph_entity_addr_equal(&req->r_last_osd_addr,
+					    &osdc->osdmap->osd_addr[osd]) ||
+		    (who && ceph_entity_addr_equal(&req->r_last_osd_addr,
+						   who))) {
+			dout(20, "kicking tid %llu osd%d\n", req->r_tid, osd);
+			get_request(req);
+			mutex_unlock(&osdc->request_mutex);
+			req->r_request = ceph_msg_maybe_dup(req->r_request);
+			if (!req->r_aborted) {
+				req->r_flags |= CEPH_OSD_OP_RETRY;
+				send_request(osdc, req);
+			}
+			ceph_osdc_put_request(req);
+			mutex_lock(&osdc->request_mutex);
+		}
+	}
+	mutex_unlock(&osdc->request_mutex);
+
+	if (needmap) {
+		dout(10, "%d requests for down osds, need new map\n", needmap);
+		ceph_monc_request_osdmap(&osdc->client->monc,
+					 osdc->osdmap->epoch+1);
+	}
+}
+
+/*
+ * Process updated osd map.
+ *
+ * The message contains any number of incremental and full maps.
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
+	dout(2, "handle_map have %u\n", osdc->osdmap ? osdc->osdmap->epoch : 0);
+	p = msg->front.iov_base;
+	end = p + msg->front.iov_len;
+
+	/* verify fsid */
+	ceph_decode_need(&p, end, sizeof(fsid), bad);
+	ceph_decode_64_le(&p, fsid.major);
+	ceph_decode_64_le(&p, fsid.minor);
+	if (!ceph_fsid_equal(&fsid, &osdc->client->monc.monmap->fsid)) {
+		derr(0, "got map with wrong fsid, ignoring\n");
+		return;
+	}
+
+	down_write(&osdc->map_sem);
+
+	/* incremental maps */
+	ceph_decode_32_safe(&p, end, nr_maps, bad);
+	dout(10, " %d inc maps\n", nr_maps);
+	while (nr_maps > 0) {
+		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
+		ceph_decode_32(&p, epoch);
+		ceph_decode_32(&p, maplen);
+		ceph_decode_need(&p, end, maplen, bad);
+		next = p + maplen;
+		if (osdc->osdmap && osdc->osdmap->epoch+1 == epoch) {
+			dout(10, "applying incremental map %u len %d\n",
+			     epoch, maplen);
+			newmap = apply_incremental(&p, next, osdc->osdmap,
+						   osdc->client->msgr);
+			if (IS_ERR(newmap)) {
+				err = PTR_ERR(newmap);
+				goto bad;
+			}
+			if (newmap != osdc->osdmap) {
+				osdmap_destroy(osdc->osdmap);
+				osdc->osdmap = newmap;
+			}
+		} else {
+			dout(10, "ignoring incremental map %u len %d\n",
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
+	dout(30, " %d full maps\n", nr_maps);
+	while (nr_maps) {
+		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
+		ceph_decode_32(&p, epoch);
+		ceph_decode_32(&p, maplen);
+		ceph_decode_need(&p, end, maplen, bad);
+		if (nr_maps > 1) {
+			dout(5, "skipping non-latest full map %u len %d\n",
+			     epoch, maplen);
+		} else if (osdc->osdmap && osdc->osdmap->epoch >= epoch) {
+			dout(10, "skipping full map %u len %d, "
+			     "older than our %u\n", epoch, maplen,
+			     osdc->osdmap->epoch);
+		} else {
+			dout(10, "taking full map %u len %d\n", epoch, maplen);
+			newmap = osdmap_decode(&p, p+maplen);
+			if (IS_ERR(newmap)) {
+				err = PTR_ERR(newmap);
+				goto bad;
+			}
+			oldmap = osdc->osdmap;
+			osdc->osdmap = newmap;
+			if (oldmap)
+				osdmap_destroy(oldmap);
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
+	derr(1, "handle_map corrupt msg\n");
+	up_write(&osdc->map_sem);
+	return;
+}
+
+/*
+ * If we detect that a tcp connection to an osd resets, we need to
+ * resubmit all requests for that osd.  That's because although we reliably
+ * deliver our requests, the osd doesn't not try as hard to deliver the
+ * reply (because it does not get notification when clients, mds' leave
+ * the cluster).
+ */
+void ceph_osdc_handle_reset(struct ceph_osd_client *osdc,
+			    struct ceph_entity_addr *addr)
+{
+	down_read(&osdc->map_sem);
+	kick_requests(osdc, addr);
+	up_read(&osdc->map_sem);
+}
+
+
+/*
+ * A read request prepares specific pages that data is to be read into.
+ * When a message is being read off the wire, we call prepare_pages to
+ * find those pages.
+ *  0 = success, -1 failure.
+ */
+int ceph_osdc_prepare_pages(void *p, struct ceph_msg *m, int want)
+{
+	struct ceph_client *client = p;
+	struct ceph_osd_client *osdc = &client->osdc;
+	struct ceph_osd_reply_head *rhead = m->front.iov_base;
+	struct ceph_osd_request *req;
+	u64 tid;
+	int ret = -1;
+	int type = le16_to_cpu(m->hdr.type);
+
+	dout(10, "prepare_pages on msg %p want %d\n", m, want);
+	if (unlikely(type != CEPH_MSG_OSD_OPREPLY))
+		return -1;  /* hmm! */
+
+	tid = le64_to_cpu(rhead->tid);
+	mutex_lock(&osdc->request_mutex);
+	req = radix_tree_lookup(&osdc->request_tree, tid);
+	if (!req) {
+		dout(10, "prepare_pages unknown tid %llu\n", tid);
+		goto out;
+	}
+	dout(10, "prepare_pages tid %llu has %d pages, want %d\n",
+	     tid, req->r_num_pages, want);
+	if (likely(req->r_num_pages >= want && req->r_reply == NULL)) {
+		m->pages = req->r_pages;
+		m->nr_pages = req->r_num_pages;
+		ceph_msg_get(m);
+		req->r_reply = m;
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
+static int start_request(struct ceph_osd_client *osdc,
+			 struct ceph_osd_request *req)
+{
+	int rc;
+
+	rc = register_request(osdc, req);
+	if (rc < 0)
+		return rc;
+	down_read(&osdc->map_sem);
+	rc = send_request(osdc, req);
+	up_read(&osdc->map_sem);
+	return rc;
+}
+
+/*
+ * synchronously do an osd request.
+ *
+ * If we are interrupted, take our pages away from any previous sent
+ * request message that may still be being written to the socket.
+ */
+static int do_sync_request(struct ceph_osd_client *osdc,
+			   struct ceph_osd_request *req)
+{
+	struct ceph_osd_reply_head *replyhead;
+	__s32 rc;
+	int bytes;
+
+	rc = start_request(osdc, req);	/* register+send request */
+	if (rc)
+		return rc;
+
+	rc = wait_for_completion_interruptible(&req->r_completion);
+	if (rc < 0) {
+		struct ceph_msg *msg;
+
+		dout(0, "tid %llu err %d, revoking %p pages\n", req->r_tid,
+		     rc, req->r_request);
+		/*
+		 * we were interrupted.
+		 *
+		 * mark req aborted _before_ revoking pages, so that
+		 * if a racing kick_request _does_ dup the page vec
+		 * pointer, it will definitely then see the aborted
+		 * flag and not send the request.
+		 */
+		req->r_aborted = 1;
+		msg = req->r_request;
+		mutex_lock(&msg->page_mutex);
+		msg->pages = NULL;
+		mutex_unlock(&msg->page_mutex);
+		if (req->r_reply) {
+			mutex_lock(&req->r_reply->page_mutex);
+			req->r_reply->pages = NULL;
+			mutex_unlock(&req->r_reply->page_mutex);
+		}
+		return rc;
+	}
+
+	/* parse reply */
+	replyhead = req->r_reply->front.iov_base;
+	rc = le32_to_cpu(replyhead->result);
+	bytes = le32_to_cpu(req->r_reply->hdr.data_len);
+	dout(10, "do_sync_request tid %llu result %d, %d bytes\n",
+	     req->r_tid, rc, bytes);
+	if (rc < 0)
+		return rc;
+	return bytes;
+}
+
+
+
+
+/*
+ * if one or more requests takes too long, a timeout expires.
+ *
+ * FIXME.
+ */
+static void reschedule_timeout(struct ceph_osd_client *osdc,
+			       unsigned long base_time)
+{
+	int timeout = osdc->client->mount_args.osd_timeout;
+	long jifs = 0;
+
+	if (base_time)
+		jifs = jiffies-base_time;
+
+	jifs = timeout * HZ - jifs;
+
+	if (jifs < 0) {
+		jifs %= timeout * HZ;
+		jifs += timeout * HZ;
+	}
+
+	dout(10, "reschedule timeout (%ld jiffies)\n", jifs);
+
+	schedule_delayed_work(&osdc->timeout_work,
+			      round_jiffies_relative(jifs));
+}
+
+static void handle_timeout(struct work_struct *work)
+{
+	u64 next_tid = 0;
+	struct ceph_osd_client *osdc =
+		container_of(work, struct ceph_osd_client, timeout_work.work);
+	struct ceph_osd_request *req;
+	int got;
+	int timeout = osdc->client->mount_args.osd_timeout * HZ;
+
+	dout(10, "timeout\n");
+	down_read(&osdc->map_sem);
+	ceph_monc_request_osdmap(&osdc->client->monc, osdc->osdmap->epoch+1);
+
+	/*
+	 * ping any osds with pending requests to ensure the communications
+	 * channel hasn't reset
+	 */
+	mutex_lock(&osdc->request_mutex);
+	got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+				     osdc->timeout_tid, 1);
+
+	__register_next_request_timeout(osdc, req);
+
+	while (1) {
+		if (got == 0)
+			break;
+		next_tid = req->r_tid + 1;
+		if (time_after(jiffies, req->r_last_stamp + timeout)) {
+			struct ceph_entity_name n = {
+				.type = cpu_to_le32(CEPH_ENTITY_TYPE_OSD),
+				.num = cpu_to_le32(req->r_last_osd)
+			};
+			ceph_ping(osdc->client->msgr, n, &req->r_last_osd_addr);
+		}
+
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+	}
+	mutex_unlock(&osdc->request_mutex);
+
+	up_read(&osdc->map_sem);
+}
+
+
+/*
+ * init, shutdown
+ */
+void ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
+{
+	dout(5, "init\n");
+	osdc->client = client;
+	osdc->osdmap = NULL;
+	init_rwsem(&osdc->map_sem);
+	init_completion(&osdc->map_waiters);
+	osdc->last_requested_map = 0;
+	mutex_init(&osdc->request_mutex);
+	osdc->last_tid = 0;
+	INIT_RADIX_TREE(&osdc->request_tree, GFP_NOFS);
+	osdc->num_requests = 0;
+	INIT_DELAYED_WORK(&osdc->timeout_work, handle_timeout);
+}
+
+void ceph_osdc_stop(struct ceph_osd_client *osdc)
+{
+	cancel_delayed_work_sync(&osdc->timeout_work);
+	if (osdc->osdmap) {
+		osdmap_destroy(osdc->osdmap);
+		osdc->osdmap = NULL;
+	}
+}
+
+
+
+/*
+ * synchronous read direct to user buffer.
+ *
+ * if read spans object boundary, just do two separate reads.
+ *
+ * FIXME: for a correct atomic read, we should take read locks on all
+ * objects.
+ */
+int ceph_osdc_sync_read(struct ceph_osd_client *osdc, struct ceph_vino vino,
+			struct ceph_file_layout *layout,
+			u64 off, u64 len,
+			char __user *data)
+{
+	struct ceph_osd_request *req;
+	int i, po, left, l;
+	int rc;
+	int finalrc = 0;
+
+	dout(10, "sync_read on vino %llx.%llx at %llu~%llu\n", vino.ino,
+	     vino.snap, off, len);
+
+more:
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_READ, NULL);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	dout(10, "sync_read %llu~%llu -> %d pages\n", off, len,
+	     req->r_num_pages);
+
+	/* allocate temp pages to hold data */
+	for (i = 0; i < req->r_num_pages; i++) {
+		req->r_pages[i] = alloc_page(GFP_NOFS);
+		if (req->r_pages[i] == NULL) {
+			req->r_num_pages = i+1;
+			ceph_osdc_put_request(req);
+			return -ENOMEM;
+		}
+	}
+
+	rc = do_sync_request(osdc, req);
+	if (rc > 0) {
+		/* copy into user buffer */
+		po = off & ~PAGE_CACHE_MASK;
+		left = rc;
+		i = 0;
+		while (left > 0) {
+			int bad;
+			l = min_t(int, left, PAGE_CACHE_SIZE-po);
+			bad = copy_to_user(data,
+					   page_address(req->r_pages[i]) + po,
+					   l);
+			if (bad == l) {
+				rc = -EFAULT;
+				goto out;
+			}
+			data += l - bad;
+			left -= l - bad;
+			if (po) {
+				po += l - bad;
+				if (po == PAGE_CACHE_SIZE)
+					po = 0;
+			}
+			i++;
+		}
+	}
+out:
+	ceph_osdc_put_request(req);
+	if (rc > 0) {
+		finalrc += rc;
+		off += rc;
+		len -= rc;
+		if (len > 0)
+			goto more;
+	} else {
+		finalrc = rc;
+	}
+	dout(10, "sync_read result %d\n", finalrc);
+	return finalrc;
+}
+
+/*
+ * read a single page.
+ */
+int ceph_osdc_readpage(struct ceph_osd_client *osdc, struct ceph_vino vino,
+		       struct ceph_file_layout *layout,
+		       u64 off, u64 len,
+		       struct page *page)
+{
+	struct ceph_osd_request *req;
+	int rc;
+
+	dout(10, "readpage on ino %llx.%llx at %lld~%lld\n", vino.ino,
+	     vino.snap, off, len);
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_READ, NULL);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	BUG_ON(len != PAGE_CACHE_SIZE);
+
+	req->r_pages[0] = page;
+	rc = do_sync_request(osdc, req);
+	ceph_osdc_put_request(req);
+
+	dout(10, "readpage result %d\n", rc);
+	if (rc == -ENOENT)
+		rc = 0;		/* object page dne; caller will zero it */
+	return rc;
+}
+
+/*
+ * read some contiguous pages from page_list.
+ *  - we stop if pages aren't contiguous, or when we hit an object boundary
+ */
+int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			struct address_space *mapping,
+			struct ceph_vino vino, struct ceph_file_layout *layout,
+			u64 off, u64 len,
+			struct list_head *page_list, int num_pages)
+{
+	struct ceph_osd_request *req;
+	struct ceph_osd_request_head *reqhead;
+	struct ceph_osd_op *op;
+	struct page *page;
+	pgoff_t next_index;
+	int contig_pages;
+	int rc = 0;
+
+	/*
+	 * for now, our strategy is simple: start with the
+	 * initial page, and fetch as much of that object as
+	 * we can that falls within the range specified by
+	 * num_pages.
+	 */
+	dout(10, "readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
+	     vino.snap, off, len);
+
+	/* alloc request, w/ optimistically-sized page vector */
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_READ, NULL);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* find adjacent pages */
+	next_index = list_entry(page_list->prev, struct page, lru)->index;
+	contig_pages = 0;
+	list_for_each_entry_reverse(page, page_list, lru) {
+		if (page->index == next_index) {
+			req->r_pages[contig_pages] = page;
+			contig_pages++;
+			next_index++;
+		} else {
+			break;
+		}
+	}
+	dout(10, "readpages found %d/%d contig\n", contig_pages, num_pages);
+	if (contig_pages == 0)
+		goto out;
+	len = min((contig_pages << PAGE_CACHE_SHIFT) - (off & ~PAGE_CACHE_MASK),
+		  len);
+	req->r_num_pages = contig_pages;
+	reqhead = req->r_request->front.iov_base;
+	op = (void *)(reqhead + 1);
+	op->length = cpu_to_le64(len);
+	dout(10, "readpages final extent is %llu~%llu -> %d pages\n",
+	     off, len, req->r_num_pages);
+	rc = do_sync_request(osdc, req);
+
+	if (rc == 0) {
+		/* on success, return bytes read */
+		struct ceph_osd_reply_head *head = req->r_reply->front.iov_base;
+		struct ceph_osd_op *rop = (void *)(head + 1);
+		rc = le64_to_cpu(rop->length);
+	}
+out:
+	ceph_osdc_put_request(req);
+	dout(10, "readpages result %d\n", rc);
+	return rc;
+}
+
+
+/*
+ * synchronous write.  from userspace.
+ *
+ * FIXME: if write spans object boundary, just do two separate write.
+ * for a correct atomic write, we should take write locks on all
+ * objects, rollback on failure, etc.
+ */
+int ceph_osdc_sync_write(struct ceph_osd_client *osdc, struct ceph_vino vino,
+			 struct ceph_file_layout *layout,
+			 struct ceph_snap_context *snapc,
+			 u64 off, u64 len, const char __user *data)
+{
+	struct ceph_msg *reqm;
+	struct ceph_osd_request_head *reqhead;
+	struct ceph_osd_request *req;
+	int i, po, l, left;
+	int rc;
+	int finalrc = 0;
+
+	dout(10, "sync_write on ino %llx.%llx at %llu~%llu\n", vino.ino,
+	     vino.snap, off, len);
+
+more:
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_WRITE, snapc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	reqm = req->r_request;
+	reqhead = reqm->front.iov_base;
+	reqhead->flags =
+		cpu_to_le32(CEPH_OSD_OP_ACK |           /* ack for now, FIXME */
+			    CEPH_OSD_OP_ORDERSNAP |     /* EOLDSNAPC if ooo */
+			    CEPH_OSD_OP_MODIFY);
+
+	dout(10, "sync_write %llu~%llu -> %d pages\n", off, len,
+	     req->r_num_pages);
+
+	/* copy data into a set of pages */
+	left = len;
+	po = off & ~PAGE_MASK;
+	for (i = 0; i < req->r_num_pages; i++) {
+		int bad;
+		req->r_pages[i] = alloc_page(GFP_NOFS);
+		if (req->r_pages[i] == NULL) {
+			req->r_num_pages = i+1;
+			rc = -ENOMEM;
+			goto out;
+		}
+		l = min_t(int, PAGE_SIZE-po, left);
+		bad = copy_from_user(page_address(req->r_pages[i]) + po, data,
+				     l);
+		if (bad == l) {
+			req->r_num_pages = i+1;
+			rc = -EFAULT;
+			goto out;
+		}
+		data += l - bad;
+		left -= l - bad;
+		if (po) {
+			po += l - bad;
+			if (po == PAGE_CACHE_SIZE)
+				po = 0;
+		}
+	}
+	reqm->pages = req->r_pages;
+	reqm->nr_pages = req->r_num_pages;
+	reqm->hdr.data_len = cpu_to_le32(len);
+	reqm->hdr.data_off = cpu_to_le32(off);
+
+	rc = do_sync_request(osdc, req);
+out:
+	for (i = 0; i < req->r_num_pages; i++)
+		__free_pages(req->r_pages[i], 0);
+	ceph_osdc_put_request(req);
+	if (rc == 0) {
+		finalrc += len;
+		off += len;
+		len -= len;
+		if (len > 0)
+			goto more;
+	} else {
+		finalrc = rc;
+	}
+	dout(10, "sync_write result %d\n", finalrc);
+	return finalrc;
+}
+
+/*
+ * do a sync write for N pages
+ */
+int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
+			 struct ceph_file_layout *layout,
+			 struct ceph_snap_context *snapc,
+			 u64 off, u64 len,
+			 struct page **pages, int num_pages)
+{
+	struct ceph_msg *reqm;
+	struct ceph_osd_request_head *reqhead;
+	struct ceph_osd_op *op;
+	struct ceph_osd_request *req;
+	int rc = 0;
+	int flags;
+
+	BUG_ON(vino.snap != CEPH_NOSNAP);
+
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_WRITE, snapc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	reqm = req->r_request;
+	reqhead = reqm->front.iov_base;
+	op = (void *)(reqhead + 1);
+
+	flags = CEPH_OSD_OP_MODIFY;
+	if (osdc->client->mount_args.flags & CEPH_MOUNT_UNSAFE_WRITEBACK)
+		flags |= CEPH_OSD_OP_ACK;
+	else
+		flags |= CEPH_OSD_OP_SAFE;
+	reqhead->flags = cpu_to_le32(flags);
+
+	len = le64_to_cpu(op->length);
+	dout(10, "writepages %llu~%llu -> %d pages\n", off, len,
+	     req->r_num_pages);
+
+	/* copy page vector */
+	memcpy(req->r_pages, pages, req->r_num_pages * sizeof(struct page *));
+	reqm->pages = req->r_pages;
+	reqm->nr_pages = req->r_num_pages;
+	reqm->hdr.data_len = cpu_to_le32(len);
+	reqm->hdr.data_off = cpu_to_le32(off);
+
+	rc = do_sync_request(osdc, req);
+	ceph_osdc_put_request(req);
+	if (rc == 0)
+		rc = len;
+	dout(10, "writepages result %d\n", rc);
+	return rc;
+}
+
+/*
+ * start an async multipage write
+ */
+int ceph_osdc_writepages_start(struct ceph_osd_client *osdc,
+			       struct ceph_osd_request *req,
+			       u64 len, int num_pages)
+{
+	struct ceph_msg *reqm = req->r_request;
+	struct ceph_osd_request_head *reqhead = reqm->front.iov_base;
+	struct ceph_osd_op *op = (void *)(reqhead + 1);
+	u64 off = le64_to_cpu(op->offset);
+	int rc;
+	int flags;
+
+	dout(10, "writepages_start %llu~%llu, %d pages\n", off, len, num_pages);
+
+	flags = CEPH_OSD_OP_MODIFY;
+	if (osdc->client->mount_args.flags & CEPH_MOUNT_UNSAFE_WRITEBACK)
+		flags |= CEPH_OSD_OP_ACK;
+	else
+		flags |= CEPH_OSD_OP_SAFE;
+	reqhead->flags = cpu_to_le32(flags);
+	op->length = cpu_to_le64(len);
+
+	/* reference pages in message */
+	reqm->pages = req->r_pages;
+	reqm->nr_pages = req->r_num_pages = num_pages;
+	reqm->hdr.data_len = cpu_to_le32(len);
+	reqm->hdr.data_off = cpu_to_le32(off);
+
+	rc = start_request(osdc, req);
+	return rc;
+}
+
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
new file mode 100644
index 0000000..a01de8e
--- /dev/null
+++ b/fs/ceph/osd_client.h
@@ -0,0 +1,135 @@
+#ifndef _FS_CEPH_OSD_CLIENT_H
+#define _FS_CEPH_OSD_CLIENT_H
+
+#include <linux/radix-tree.h>
+#include <linux/completion.h>
+
+#include "types.h"
+#include "osdmap.h"
+
+/*
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
+struct ceph_msg;
+struct ceph_snap_context;
+struct ceph_osd_request;
+
+/*
+ * completion callback for async writepages
+ */
+typedef void (*ceph_osdc_callback_t)(struct ceph_osd_request *);
+
+/* an in-flight request */
+struct ceph_osd_request {
+	u64             r_tid;              /* unique for this client */
+	struct ceph_msg  *r_request;
+	struct ceph_msg  *r_reply;
+	int               r_result;
+	int               r_flags;     /* any additional flags for the osd */
+	int               r_aborted;   /* set if we cancel this request */
+
+	atomic_t          r_ref;
+	struct completion r_completion;       /* on completion, or... */
+	ceph_osdc_callback_t r_callback;      /* ...async callback. */
+	struct inode *r_inode;                /* needed for async write */
+	struct writeback_control *r_wbc;
+
+	int               r_last_osd;         /* last osd we sent request to */
+	struct ceph_entity_addr r_last_osd_addr;
+	unsigned long     r_last_stamp;
+
+	union ceph_pg     r_pgid;             /* placement group */
+	struct ceph_snap_context *r_snapc;    /* snap context for writes */
+	unsigned          r_num_pages;        /* size of page array (follows) */
+	struct page      *r_pages[0];         /* pages for data payload */
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
+	u64                    timeout_tid;   /* tid of timeout triggering rq */
+	u64                    last_tid;      /* tid of last request */
+	struct radix_tree_root request_tree;  /* pending requests, by tid */
+	int                    num_requests;
+	struct delayed_work    timeout_work;
+};
+
+extern void ceph_osdc_init(struct ceph_osd_client *osdc,
+			   struct ceph_client *client);
+extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
+
+extern void ceph_osdc_handle_reset(struct ceph_osd_client *osdc,
+				   struct ceph_entity_addr *addr);
+
+extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
+				   struct ceph_msg *msg);
+extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
+				 struct ceph_msg *msg);
+
+/* incoming read messages use this to discover which pages to read
+ * the data payload into. */
+extern int ceph_osdc_prepare_pages(void *p, struct ceph_msg *m, int want);
+
+extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
+				      struct ceph_file_layout *layout,
+				      struct ceph_vino vino,
+				      u64 offset, u64 *len, int op,
+				      struct ceph_snap_context *snapc);
+extern void ceph_osdc_put_request(struct ceph_osd_request *req);
+
+extern int ceph_osdc_readpage(struct ceph_osd_client *osdc,
+			      struct ceph_vino vino,
+			      struct ceph_file_layout *layout,
+			      u64 off, u64 len,
+			      struct page *page);
+extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			       struct address_space *mapping,
+			       struct ceph_vino vino,
+			       struct ceph_file_layout *layout,
+			       u64 off, u64 len,
+			       struct list_head *page_list, int nr_pages);
+
+extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
+				struct ceph_vino vino,
+				struct ceph_file_layout *layout,
+				struct ceph_snap_context *sc,
+				u64 off, u64 len,
+				struct page **pagevec, int nr_pages);
+extern int ceph_osdc_writepages_start(struct ceph_osd_client *osdc,
+				      struct ceph_osd_request *req,
+				      u64 len,
+				      int nr_pages);
+
+extern int ceph_osdc_sync_read(struct ceph_osd_client *osdc,
+			       struct ceph_vino vino,
+			       struct ceph_file_layout *layout,
+			       u64 off, u64 len,
+			       char __user *data);
+extern int ceph_osdc_sync_write(struct ceph_osd_client *osdc,
+				struct ceph_vino vino,
+				struct ceph_file_layout *layout,
+				struct ceph_snap_context *sc,
+				u64 off, u64 len,
+				const char __user *data);
+
+#endif
+
diff --git a/fs/ceph/osdmap.c b/fs/ceph/osdmap.c
new file mode 100644
index 0000000..e61f4ce
--- /dev/null
+++ b/fs/ceph/osdmap.c
@@ -0,0 +1,664 @@
+
+#include <asm/div64.h>
+
+#include "super.h"
+#include "osdmap.h"
+#include "crush/hash.h"
+#include "decode.h"
+
+#include "ceph_debug.h"
+
+int ceph_debug_osdmap = -1;
+#define DOUT_MASK DOUT_MASK_OSDMAP
+#define DOUT_VAR ceph_debug_osdmap
+#define DOUT_PREFIX "osdmap: "
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
+static void calc_pg_masks(struct ceph_osdmap *map)
+{
+	map->pg_num_mask = (1 << calc_bits_of(map->pg_num-1)) - 1;
+	map->pgp_num_mask = (1 << calc_bits_of(map->pgp_num-1)) - 1;
+	map->lpg_num_mask = (1 << calc_bits_of(map->lpg_num-1)) - 1;
+	map->lpgp_num_mask = (1 << calc_bits_of(map->lpgp_num-1)) - 1;
+}
+
+/*
+ * decode crush map
+ */
+static int crush_decode_uniform_bucket(void **p, void *end,
+				       struct crush_bucket_uniform *b)
+{
+	int j;
+	dout(30, "crush_decode_uniform_bucket %p to %p\n", *p, end);
+	b->primes = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	if (b->primes == NULL)
+		return -ENOMEM;
+	ceph_decode_need(p, end, (1+b->h.size) * sizeof(u32), bad);
+	for (j = 0; j < b->h.size; j++)
+		ceph_decode_32(p, b->primes[j]);
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
+	dout(30, "crush_decode_list_bucket %p to %p\n", *p, end);
+	b->item_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	if (b->item_weights == NULL)
+		return -ENOMEM;
+	b->sum_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
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
+	dout(30, "crush_decode_tree_bucket %p to %p\n", *p, end);
+	b->node_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	if (b->node_weights == NULL)
+		return -ENOMEM;
+	ceph_decode_need(p, end, b->h.size * sizeof(u32), bad);
+	for (j = 0; j < b->h.size; j++)
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
+	dout(30, "crush_decode_straw_bucket %p to %p\n", *p, end);
+	b->straws = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
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
+
+	dout(30, "crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	c = kzalloc(sizeof(*c), GFP_NOFS);
+	if (c == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(p, end, 3*sizeof(u32), bad);
+	ceph_decode_32(p, c->max_buckets);
+	ceph_decode_32(p, c->max_rules);
+	ceph_decode_32(p, c->max_devices);
+
+	c->device_parents = kmalloc(c->max_devices * sizeof(u32), GFP_NOFS);
+	if (c->device_parents == NULL)
+		goto badmem;
+	c->bucket_parents = kmalloc(c->max_buckets * sizeof(u32), GFP_NOFS);
+	if (c->bucket_parents == NULL)
+		goto badmem;
+
+	c->buckets = kmalloc(c->max_buckets * sizeof(*c->buckets), GFP_NOFS);
+	if (c->buckets == NULL)
+		goto badmem;
+	c->rules = kmalloc(c->max_rules * sizeof(*c->rules), GFP_NOFS);
+	if (c->rules == NULL)
+		goto badmem;
+
+	/* buckets */
+	for (i = 0; i < c->max_buckets; i++) {
+		int size = 0;
+		u32 type;
+		struct crush_bucket *b;
+
+		dout(30, "crush_decode bucket %d off %x %p to %p\n",
+		     i, (int)(*p-start), *p, end);
+
+		ceph_decode_32_safe(p, end, type, bad);
+		if (type == 0) {
+			c->buckets[i] = NULL;
+			continue;
+		}
+
+		switch (type) {
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
+		dout(30, "crush_decode bucket size %d off %x %p to %p\n",
+		     b->size, (int)(*p-start), *p, end);
+
+		b->items = kmalloc(b->size * sizeof(__s32), GFP_NOFS);
+		if (b->items == NULL)
+			goto badmem;
+
+		ceph_decode_need(p, end, b->size*sizeof(u32), bad);
+		for (j = 0; j < b->size; j++)
+			ceph_decode_32(p, b->items[j]);
+
+		switch (b->type) {
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
+	dout(30, "rule vec is %p\n", c->rules);
+	for (i = 0; i < c->max_rules; i++) {
+		u32 yes;
+		struct crush_rule *r;
+
+		ceph_decode_32_safe(p, end, yes, bad);
+		if (!yes) {
+			dout(30, "crush_decode NO rule %d off %x %p to %p\n",
+			     i, (int)(*p-start), *p, end);
+			c->rules[i] = NULL;
+			continue;
+		}
+
+		dout(30, "crush_decode rule %d off %x %p to %p\n",
+		     i, (int)(*p-start), *p, end);
+
+		/* len */
+		ceph_decode_32_safe(p, end, yes, bad);
+
+		r = c->rules[i] = kmalloc(sizeof(*r) +
+					  yes*sizeof(struct crush_rule_step),
+					  GFP_NOFS);
+		if (r == NULL)
+			goto badmem;
+		dout(30, " rule %d is at %p\n", i, r);
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
+	dout(30, "crush_decode success\n");
+	return c;
+
+badmem:
+	err = -ENOMEM;
+bad:
+	dout(30, "crush_decode fail %d\n", err);
+	crush_destroy(c);
+	return ERR_PTR(err);
+}
+
+
+/*
+ * osd map
+ */
+void osdmap_destroy(struct ceph_osdmap *map)
+{
+	dout(10, "osdmap_destroy %p\n", map);
+	if (map->crush)
+		crush_destroy(map->crush);
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
+	state = kzalloc(max * sizeof(*state), GFP_NOFS);
+	addr = kzalloc(max * sizeof(*addr), GFP_NOFS);
+	weight = kzalloc(max * sizeof(*weight), GFP_NOFS);
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
+ * decode a full map.
+ */
+struct ceph_osdmap *osdmap_decode(void **p, void *end)
+{
+	struct ceph_osdmap *map;
+	u32 len, max, i;
+	int err = -EINVAL;
+	void *start = *p;
+
+	dout(30, "osdmap_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	map = kzalloc(sizeof(*map), GFP_NOFS);
+	if (map == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(p, end, 2*sizeof(u64)+11*sizeof(u32), bad);
+	ceph_decode_64_le(p, map->fsid.major);
+	ceph_decode_64_le(p, map->fsid.minor);
+	ceph_decode_32(p, map->epoch);
+	ceph_decode_32_le(p, map->ctime.tv_sec);
+	ceph_decode_32_le(p, map->ctime.tv_nsec);
+	ceph_decode_32_le(p, map->mtime.tv_sec);
+	ceph_decode_32_le(p, map->mtime.tv_nsec);
+	ceph_decode_32(p, map->pg_num);
+	ceph_decode_32(p, map->pgp_num);
+	ceph_decode_32(p, map->lpg_num);
+	ceph_decode_32(p, map->lpgp_num);
+	ceph_decode_32(p, map->last_pg_change);
+	ceph_decode_32(p, map->flags);
+
+	calc_pg_masks(map);
+
+	ceph_decode_32(p, max);
+
+	/* (re)alloc osd arrays */
+	err = osdmap_set_max_osd(map, max);
+	if (err < 0)
+		goto bad;
+	dout(30, "osdmap_decode max_osd = %d\n", map->max_osd);
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
+	*p += sizeof(u32) + map->max_osd * sizeof(u32); /* osd_up_from */
+	*p += sizeof(u32) + map->max_osd * sizeof(u32); /* osd_up_thru */
+
+	/* ignore pg primary swapping */
+	ceph_decode_32_safe(p, end, len, bad);
+	p += len * (sizeof(u64) + sizeof(u32));
+	if (len)
+		derr(0, "WARNING: pg primary swaps in osdmap e%d unsupported\n",
+		     map->epoch);
+
+	/* ignore max_snap, removed_snaps */
+	*p += sizeof(u64);
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * 2 * sizeof(u64);
+
+	/* crush */
+	ceph_decode_32_safe(p, end, len, bad);
+	dout(30, "osdmap_decode crush len %d from off 0x%x\n", len,
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
+	dout(30, "osdmap_decode done %p %p\n", *p, end);
+	if (*p != end)
+		goto bad;
+	return map;
+
+bad:
+	dout(30, "osdmap_decode fail\n");
+	osdmap_destroy(map);
+	return ERR_PTR(err);
+}
+
+/*
+ * decode and apply an incremental map update.
+ */
+struct ceph_osdmap *apply_incremental(void **p, void *end,
+				      struct ceph_osdmap *map,
+				      struct ceph_messenger *msgr)
+{
+	struct ceph_osdmap *newmap = map;
+	struct crush_map *newcrush = NULL;
+	struct ceph_fsid fsid;
+	u32 epoch = 0;
+	struct ceph_timespec ctime;
+	u32 len, x;
+	__s32 new_flags, max;
+	void *start = *p;
+	int err = -EINVAL;
+
+	ceph_decode_need(p, end, sizeof(fsid)+sizeof(ctime)+2*sizeof(u32),
+			 bad);
+	ceph_decode_64_le(p, fsid.major);
+	ceph_decode_64_le(p, fsid.minor);
+	ceph_decode_32(p, epoch);
+	BUG_ON(epoch != map->epoch+1);
+	ceph_decode_32_le(p, ctime.tv_sec);
+	ceph_decode_32_le(p, ctime.tv_nsec);
+	ceph_decode_32(p, new_flags);
+
+	/* full map? */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len > 0) {
+		dout(20, "apply_incremental full map len %d, %p to %p\n",
+		     len, *p, end);
+		newmap = osdmap_decode(p, min(*p+len, end));
+		return newmap;  /* error or not */
+	}
+
+	/* new crush? */
+	ceph_decode_32_safe(p, end, len, bad);
+	if (len > 0) {
+		dout(20, "apply_incremental new crush map len %d, %p to %p\n",
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
+	ceph_decode_32(p, x);
+	if (x)
+		map->pg_num = x;
+	ceph_decode_32(p, x);
+	if (x)
+		map->pgp_num = x;
+	ceph_decode_32(p, x);
+	if (x)
+		map->lpg_num = x;
+	ceph_decode_32(p, x);
+	if (x)
+		map->lpgp_num = x;
+
+	map->epoch++;
+	map->ctime = map->ctime;
+	if (newcrush) {
+		if (map->crush)
+			crush_destroy(map->crush);
+		map->crush = newcrush;
+		newcrush = NULL;
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
+		dout(1, "osd%d up\n", osd);
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
+		dout(1, "osd%d down\n", osd);
+		if (osd < map->max_osd) {
+			map->osd_state[osd] &= ~CEPH_OSD_UP;
+			ceph_messenger_mark_down(msgr, &map->osd_addr[osd]);
+		}
+	}
+
+	/* new_weight */
+	ceph_decode_32_safe(p, end, len, bad);
+	while (len--) {
+		u32 osd, off;
+		ceph_decode_need(p, end, sizeof(u32)*2, bad);
+		ceph_decode_32(p, osd);
+		ceph_decode_32(p, off);
+		dout(1, "osd%d weight 0x%x %s\n", osd, off,
+		     off == CEPH_OSD_IN ? "(in)" :
+		     (off == CEPH_OSD_OUT ? "(out)" : ""));
+		if (osd < map->max_osd)
+			map->osd_weight[osd] = off;
+	}
+
+	/* skip new_up_thru */
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * 2 * sizeof(u32);
+
+	/* skip old/new pg_swap stuff */
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * (sizeof(u64) + sizeof(u32));
+	if (len)
+		derr(0, "WARNING: pg primary swaps in osdmap e%d unsupported\n",
+		     epoch);
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * sizeof(u64);
+	if (len)
+		derr(0, "WARNING: pg primary swaps in osdmap e%d unsupported\n",
+		     epoch);
+
+	/* skip new_max_snap, removed_snaps */
+	*p += sizeof(u64);
+	ceph_decode_32_safe(p, end, len, bad);
+	*p += len * 2 * sizeof(u64);
+
+	if (*p != end) {
+		derr(10, "osdmap incremental has trailing gunk?\n");
+		goto bad;
+	}
+	return map;
+
+bad:
+	derr(10, "corrupt incremental osdmap epoch %d off %d (%p of %p-%p)\n",
+	     epoch, (int)(*p - start), *p, start, end);
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
+void calc_file_object_mapping(struct ceph_file_layout *layout,
+			      u64 off, u64 *plen,
+			      struct ceph_object *oid,
+			      u64 *oxoff, u64 *oxlen)
+{
+	u32 osize = le32_to_cpu(layout->fl_object_size);
+	u32 su = le32_to_cpu(layout->fl_stripe_unit);
+	u32 sc = le32_to_cpu(layout->fl_stripe_count);
+	u32 bl, stripeno, stripepos, objsetno;
+	u32 su_per_object;
+	u64 t;
+
+	dout(80, "mapping %llu~%llu  osize %u fl_su %u\n", off, *plen,
+	     osize, su);
+	su_per_object = osize / le32_to_cpu(layout->fl_stripe_unit);
+	dout(80, "osize %u / su %u = su_per_object %u\n", osize, su,
+	     su_per_object);
+
+	BUG_ON((su & ~PAGE_MASK) != 0);
+	/* bl = *off / su; */
+	t = off;
+	do_div(t, su);
+	bl = t;
+	dout(80, "off %llu / su %u = bl %u\n", off, su, bl);
+
+	stripeno = bl / sc;
+	stripepos = bl % sc;
+	objsetno = stripeno / su_per_object;
+
+	oid->bno = cpu_to_le32(objsetno * sc + stripepos);
+	dout(80, "objset %u * sc %u = bno %u\n", objsetno, sc, oid->bno);
+	/* *oxoff = *off / layout->fl_stripe_unit; */
+	t = off;
+	*oxoff = do_div(t, su);
+	*oxlen = min_t(u64, *plen, su - *oxoff);
+	*plen = *oxlen;
+
+	dout(80, " obj extent %llu~%llu\n", *oxoff, *oxlen);
+}
+
+/*
+ * calculate an object layout (i.e. pgid) from an oid,
+ * file_layout, and osdmap
+ */
+void calc_object_layout(struct ceph_object_layout *ol,
+			struct ceph_object *oid,
+			struct ceph_file_layout *fl,
+			struct ceph_osdmap *osdmap)
+{
+	unsigned num, num_mask;
+	union ceph_pg pgid;
+	u64 ino = le64_to_cpu(oid->ino);
+	unsigned bno = le32_to_cpu(oid->bno);
+	s32 preferred = (s32)le32_to_cpu(fl->fl_pg_preferred);
+
+	if (preferred >= 0) {
+		num = osdmap->lpg_num;
+		num_mask = osdmap->lpg_num_mask;
+	} else {
+		num = osdmap->pg_num;
+		num_mask = osdmap->pg_num_mask;
+	}
+
+	pgid.pg64 = 0;   /* start with it zeroed out */
+	pgid.pg.ps = bno + crush_hash32_2(ino, ino>>32);
+	pgid.pg.preferred = preferred;
+	pgid.pg.type = fl->fl_pg_type;
+	pgid.pg.size = fl->fl_pg_size;
+	pgid.pg.pool = fl->fl_pg_pool;
+
+	ol->ol_pgid = cpu_to_le64(pgid.pg64);
+	ol->ol_stripe_unit = fl->fl_object_stripe_unit;
+}
diff --git a/fs/ceph/osdmap.h b/fs/ceph/osdmap.h
new file mode 100644
index 0000000..000550b
--- /dev/null
+++ b/fs/ceph/osdmap.h
@@ -0,0 +1,82 @@
+#ifndef _FS_CEPH_OSDMAP_H
+#define _FS_CEPH_OSDMAP_H
+
+#include "types.h"
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
+struct ceph_osdmap {
+	struct ceph_fsid fsid;
+	u32 epoch;
+	u32 mkfs_epoch;
+	struct ceph_timespec ctime, mtime;
+
+	/* these parameters describe the number of placement groups
+	 * in the system.  foo_mask is the smallest value (2**n-1) >= foo. */
+	u32 pg_num, pg_num_mask;
+	u32 pgp_num, pgp_num_mask;
+	u32 lpg_num, lpg_num_mask;
+	u32 lpgp_num, lpgp_num_mask;
+	u32 last_pg_change;   /* epoch of last pg count change */
+
+	u32 flags;         /* CEPH_OSDMAP_* */
+
+	u32 max_osd;       /* size of osd_state, _offload, _addr arrays */
+	u8 *osd_state;     /* CEPH_OSD_* */
+	u32 *osd_offload;  /* 0 = normal, 0x10000 = 100% offload (failed) */
+	u32 *osd_weight;
+	struct ceph_entity_addr *osd_addr;
+
+	/* the CRUSH map specifies the mapping of placement groups to
+	 * the list of osds that store+replicate them. */
+	struct crush_map *crush;
+};
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
+static inline struct ceph_entity_addr *ceph_osd_addr(struct ceph_osdmap *map,
+						     int osd)
+{
+	if (osd >= map->max_osd)
+		return 0;
+	return &map->osd_addr[osd];
+}
+
+extern struct ceph_osdmap *osdmap_decode(void **p, void *end);
+extern struct ceph_osdmap *apply_incremental(void **p, void *end,
+					     struct ceph_osdmap *map,
+					     struct ceph_messenger *msgr);
+extern void osdmap_destroy(struct ceph_osdmap *map);
+
+/* calculate mapping of a file extent to an object */
+extern void calc_file_object_mapping(struct ceph_file_layout *layout,
+				     u64 off, u64 *plen,
+				     struct ceph_object *oid,
+				     u64 *oxoff, u64 *oxlen);
+
+/* calculate mapping of object to a placement group */
+extern void calc_object_layout(struct ceph_object_layout *ol,
+			       struct ceph_object *oid,
+			       struct ceph_file_layout *fl,
+			       struct ceph_osdmap *osdmap);
+
+#endif
-- 
1.5.6.5

