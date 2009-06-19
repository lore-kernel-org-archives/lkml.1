Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbZFSWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbZFSWex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbZFSWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:01 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44724 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbZFSWbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:00 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 11/21] ceph: OSD client
Date: Fri, 19 Jun 2009 15:31:32 -0700
Message-Id: <1245450702-31343-12-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245450702-31343-11-git-send-email-sage@newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <1245450702-31343-2-git-send-email-sage@newdream.net>
 <1245450702-31343-3-git-send-email-sage@newdream.net>
 <1245450702-31343-4-git-send-email-sage@newdream.net>
 <1245450702-31343-5-git-send-email-sage@newdream.net>
 <1245450702-31343-6-git-send-email-sage@newdream.net>
 <1245450702-31343-7-git-send-email-sage@newdream.net>
 <1245450702-31343-8-git-send-email-sage@newdream.net>
 <1245450702-31343-9-git-send-email-sage@newdream.net>
 <1245450702-31343-10-git-send-email-sage@newdream.net>
 <1245450702-31343-11-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OSD client is responsible for reading and writing data from/to the
object storage pool.  This includes determining where objects are
stored in the cluster, and ensuring that requests are retried or
redirected in the event of a node failure or data migration.

If an OSD does not respond before a timeout expires, 'ping' messages
are sent across the lossless, ordered communications channel to
ensure that any break in the TCP is discovered.  If the session does
reset, a reconnection is attempted and affected requests are resent
(by the message transport layer).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/staging/ceph/osd_client.c |  987 ++++++++++++++++++++++++++++++++++++++++++
 fs/staging/ceph/osd_client.h |  151 +++++++
 fs/staging/ceph/osdmap.c     |  703 ++++++++++++++++++++++++++++++
 fs/staging/ceph/osdmap.h     |   83 ++++
 4 files changed, 1924 insertions(+), 0 deletions(-)
 create mode 100644 fs/staging/ceph/osd_client.c
 create mode 100644 fs/staging/ceph/osd_client.h
 create mode 100644 fs/staging/ceph/osdmap.c
 create mode 100644 fs/staging/ceph/osdmap.h

diff --git a/fs/staging/ceph/osd_client.c b/fs/staging/ceph/osd_client.c
new file mode 100644
index 0000000..ddad5c1
--- /dev/null
+++ b/fs/staging/ceph/osd_client.c
@@ -0,0 +1,987 @@
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "ceph_debug.h"
+
+int ceph_debug_osdc __read_mostly = -1;
+#define DOUT_MASK DOUT_MASK_OSDC
+#define DOUT_VAR ceph_debug_osdc
+#include "super.h"
+
+#include "osd_client.h"
+#include "messenger.h"
+#include "crush/mapper.h"
+#include "decode.h"
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
+	u64 bno;
+
+	reqhead->snapid = cpu_to_le64(vino.snap);
+
+	/* object extent? */
+	ceph_calc_file_object_mapping(layout, off, plen, &bno,
+				      &objoff, &objlen);
+	if (*plen < orig_len)
+		dout(10, " skipping last %llu, final file extent %llu~%llu\n",
+		     orig_len - *plen, off, *plen);
+
+	sprintf(req->r_oid, "%llx.%08llx", vino.ino, bno);
+	req->r_oid_len = strlen(req->r_oid);
+
+
+	op->offset = cpu_to_le64(objoff);
+	op->length = cpu_to_le64(objlen);
+	req->r_num_pages = calc_pages_for(off, *plen);
+
+	dout(10, "calc_layout %s (%d) %llu~%llu (%d pages)\n",
+	     req->r_oid, req->r_oid_len, objoff, objlen, req->r_num_pages);
+}
+
+
+/*
+ * requests
+ */
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
+		if (req->r_own_pages)
+			ceph_release_page_vector(req->r_pages,
+						 req->r_num_pages);
+		ceph_put_snap_context(req->r_snapc);
+		kfree(req);
+	}
+}
+
+/*
+ * build new request AND message, calculate layout, and adjust file
+ * extent as needed.  include addition truncate or sync osd ops.
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
+					       struct timespec *mtime)
+{
+	struct ceph_osd_request *req;
+	struct ceph_msg *msg;
+	struct ceph_osd_request_head *head;
+	struct ceph_osd_op *op;
+	void *p;
+	int do_trunc = truncate_seq && (off + *plen > truncate_size);
+	int num_op = 1 + do_sync + do_trunc;
+	size_t msg_size = sizeof(*head) + num_op*sizeof(*op);
+	int i;
+	u64 prevofs;
+
+	/* we may overallocate here, if our write extent is shortened below */
+	req = kzalloc(sizeof(*req), GFP_NOFS);
+	if (req == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&req->r_ref, 1);
+	init_completion(&req->r_completion);
+	init_completion(&req->r_safe_completion);
+	INIT_LIST_HEAD(&req->r_unsafe_item);
+	req->r_flags = flags;
+	req->r_last_osd = -1;
+
+	WARN_ON((flags & (CEPH_OSD_FLAG_READ|CEPH_OSD_FLAG_WRITE)) == 0);
+
+	/* create message; allow space for oid */
+	msg_size += 40 + osdc->client->signed_ticket_len;
+	if (snapc)
+		msg_size += sizeof(u64) * snapc->num_snaps;
+	msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, 0, 0, NULL);
+	if (IS_ERR(msg)) {
+		kfree(req);
+		return ERR_PTR(PTR_ERR(msg));
+	}
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
+	        op->payload_len = cpu_to_le32(*plen);
+	}
+
+
+	/* fill in oid, ticket */
+	head->object_len = cpu_to_le32(req->r_oid_len);
+	memcpy(p, req->r_oid, req->r_oid_len);
+	p += req->r_oid_len;
+
+	head->ticket_len = cpu_to_le32(osdc->client->signed_ticket_len);
+	memcpy(p, osdc->client->signed_ticket,
+	       osdc->client->signed_ticket_len);
+	p += osdc->client->signed_ticket_len;
+
+
+	/* additional ops */
+	if (do_trunc) {
+		op++;
+		op->op = cpu_to_le16(opcode == CEPH_OSD_OP_READ ?
+			     CEPH_OSD_OP_MASKTRUNC : CEPH_OSD_OP_SETTRUNC);
+		op->truncate_seq = cpu_to_le32(truncate_seq);
+		prevofs =  le64_to_cpu((op-1)->offset);
+		op->truncate_size = cpu_to_le64(truncate_size - (off-prevofs));
+	}
+	if (do_sync) {
+		op++;
+		op->op = cpu_to_le16(CEPH_OSD_OP_STARTSYNC);
+	}
+	if (snapc) {
+		head->snap_seq = cpu_to_le64(snapc->seq);
+		head->num_snaps = cpu_to_le32(snapc->num_snaps);
+		for (i = 0; i < snapc->num_snaps; i++) {
+			*(__le64 *)p = cpu_to_le64(snapc->snaps[i]);
+			p += sizeof(u64);
+		}
+	}
+
+	BUG_ON(p > msg->front.iov_base + msg->front.iov_len);
+	return req;
+}
+
+/*
+ * Register request, assign tid.  If this is the first request, set up
+ * the timeout event.
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
+	ceph_osdc_get_request(req);
+	osdc->num_requests++;
+
+	req->r_timeout_stamp =
+		jiffies + osdc->client->mount_args.osd_timeout*HZ;
+
+	if (osdc->num_requests == 1) {
+		osdc->timeout_tid = req->r_tid;
+		dout(30, "  timeout on tid %llu at %lu\n", req->r_tid,
+		     req->r_timeout_stamp);
+		schedule_delayed_work(&osdc->timeout_work,
+		      round_jiffies_relative(req->r_timeout_stamp - jiffies));
+	}
+out:
+	mutex_unlock(&osdc->request_mutex);
+	return rc;
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
+	unsigned long timeout = osdc->client->mount_args.osd_timeout * HZ;
+	unsigned long next_timeout = timeout + jiffies;
+	RADIX_TREE(pings, GFP_NOFS);  /* only send 1 ping per osd */
+	u64 next_tid = 0;
+	int got;
+
+	dout(10, "timeout\n");
+	down_read(&osdc->map_sem);
+
+	ceph_monc_request_osdmap(&osdc->client->monc, osdc->osdmap->epoch+1);
+
+	mutex_lock(&osdc->request_mutex);
+	while (1) {
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+		if (got == 0)
+			break;
+		next_tid = req->r_tid + 1;
+		if (time_before(jiffies, req->r_timeout_stamp))
+			goto next;
+
+		req->r_timeout_stamp = next_timeout;
+		if (req->r_last_osd >= 0 &&
+		    radix_tree_lookup(&pings, req->r_last_osd) == NULL) {
+			struct ceph_entity_name n = {
+				.type = cpu_to_le32(CEPH_ENTITY_TYPE_OSD),
+				.num = cpu_to_le32(req->r_last_osd)
+			};
+			dout(20, " tid %llu (at least) timed out on osd%d\n",
+			     req->r_tid, req->r_last_osd);
+			radix_tree_insert(&pings, req->r_last_osd, req);
+			ceph_ping(osdc->client->msgr, n, &req->r_last_osd_addr);
+		}
+
+	next:
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+	}
+
+	while (radix_tree_gang_lookup(&pings, (void **)&req, 0, 1))
+		radix_tree_delete(&pings, req->r_last_osd);
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
+ * called under osdc->request_mutex
+ */
+static void __unregister_request(struct ceph_osd_client *osdc,
+				 struct ceph_osd_request *req)
+{
+	dout(30, "__unregister_request %p tid %lld\n", req, req->r_tid);
+	radix_tree_delete(&osdc->request_tree, req->r_tid);
+
+	osdc->num_requests--;
+	ceph_osdc_put_request(req);
+
+	if (req->r_tid == osdc->timeout_tid) {
+		if (osdc->num_requests == 0) {
+			dout(30, "no requests, canceling timeout\n");
+			osdc->timeout_tid = 0;
+			cancel_delayed_work(&osdc->timeout_work);
+		} else {
+			int ret;
+
+			ret = radix_tree_gang_lookup(&osdc->request_tree,
+						     (void **)&req, 0, 1);
+			BUG_ON(ret != 1);
+			osdc->timeout_tid = req->r_tid;
+			dout(30, "rescheduled timeout on tid %llu at %lu\n",
+			     req->r_tid, req->r_timeout_stamp);
+			schedule_delayed_work(&osdc->timeout_work,
+			      round_jiffies_relative(req->r_timeout_stamp -
+						     jiffies));
+		}
+	}
+}
+
+/*
+ * Pick an osd, and put result in req->r_last_osd[_addr].  The first
+ * up osd in the pg.  or -1.
+ *
+ * Caller should hold map_sem for read.
+ *
+ * return 0 if unchanged, 1 if changed.
+ */
+static int map_osds(struct ceph_osd_client *osdc,
+		    struct ceph_osd_request *req)
+{
+	struct ceph_osd_request_head *reqhead = req->r_request->front.iov_base;
+	union ceph_pg pgid;
+	struct ceph_pg_pool_info *pool;
+	int ruleno;
+	unsigned pps; /* placement ps */
+	int osds[10], osd = -1;
+	int i, num;
+	int err;
+
+	err = ceph_calc_object_layout(&reqhead->layout, req->r_oid,
+				      &req->r_file_layout, osdc->osdmap);
+	if (err)
+		return err;
+	pgid.pg64 = le64_to_cpu(reqhead->layout.ol_pgid);
+	if (pgid.pg.pool >= osdc->osdmap->num_pools)
+		return -1;
+	pool = &osdc->osdmap->pg_pool[pgid.pg.pool];
+	ruleno = crush_find_rule(osdc->osdmap->crush, pool->v.crush_ruleset,
+				 pool->v.type, pool->v.size);
+	if (ruleno < 0) {
+		derr(0, "map_osds no crush rule for pool %d type %d size %d\n",
+		     pgid.pg.pool, pool->v.type, pool->v.size);
+		return -1;
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
+	num = crush_do_rule(osdc->osdmap->crush, ruleno, pps, osds,
+			    min_t(int, pool->v.size, ARRAY_SIZE(osds)),
+			    pgid.pg.preferred, osdc->osdmap->osd_weight);
+
+	/* primary is first up osd */
+	for (i = 0; i < num; i++)
+		if (ceph_osd_is_up(osdc->osdmap, osds[i])) {
+			osd = osds[i];
+			break;
+		}
+	dout(20, "map_osds tid %llu pgid %llx pool %d osd%d (was osd%d)\n",
+	     req->r_tid, pgid.pg64, pgid.pg.pool, osd, req->r_last_osd);
+	if (req->r_last_osd == osd &&
+	    (osd < 0 || ceph_entity_addr_equal(&osdc->osdmap->osd_addr[osd],
+					       &req->r_last_osd_addr)))
+		return 0;
+	req->r_last_osd = osd;
+	if (osd >= 0)
+		req->r_last_osd_addr = osdc->osdmap->osd_addr[osd];
+	return 1;
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
+	map_osds(osdc, req);
+	if (req->r_last_osd < 0) {
+		dout(10, "send_request %p no up osds in pg\n", req);
+		ceph_monc_request_osdmap(&osdc->client->monc,
+					 osdc->osdmap->epoch+1);
+		return 0;
+	}
+	osd = req->r_last_osd;
+
+	dout(10, "send_request %p tid %llu to osd%d flags %d\n",
+	     req, req->r_tid, osd, req->r_flags);
+
+	reqhead = req->r_request->front.iov_base;
+	reqhead->osdmap_epoch = cpu_to_le32(osdc->osdmap->epoch);
+	reqhead->flags |= cpu_to_le32(req->r_flags);  /* e.g., RETRY */
+	reqhead->reassert_version = req->r_reassert_version;
+
+	req->r_request->hdr.dst.name.type =
+		cpu_to_le32(CEPH_ENTITY_TYPE_OSD);
+	req->r_request->hdr.dst.name.num = cpu_to_le32(osd);
+	req->r_request->hdr.dst.addr = req->r_last_osd_addr;
+
+	req->r_timeout_stamp = jiffies+osdc->client->mount_args.osd_timeout*HZ;
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
+	ceph_osdc_get_request(req);
+	flags = le32_to_cpu(rhead->flags);
+
+	if (req->r_aborted) {
+		dout(10, "handle_reply tid %llu aborted\n", tid);
+		goto done;
+	}
+
+	if (req->r_reassert_version.epoch == 0) {
+		/* first ack */
+		if (req->r_reply == NULL) {
+			/* no data payload, or r_reply would have been set by
+			   prepare_pages. */
+			ceph_msg_get(msg);
+			req->r_reply = msg;
+		} else {
+			/* r_reply was set by prepare_pages */
+			BUG_ON(req->r_reply != msg);
+		}
+
+		/* in case we need to replay this op, */
+		req->r_reassert_version = rhead->reassert_version;
+	} else if ((flags & CEPH_OSD_FLAG_ONDISK) == 0) {
+		dout(10, "handle_reply tid %llu dup ack\n", tid);
+		goto done;
+	}
+
+	dout(10, "handle_reply tid %llu flags %d\n", tid, flags);
+
+	/* either this is a read, or we got the safe response */
+	if ((flags & CEPH_OSD_FLAG_ONDISK) ||
+	    ((flags & CEPH_OSD_FLAG_WRITE) == 0))
+		__unregister_request(osdc, req);
+
+	mutex_unlock(&osdc->request_mutex);
+
+	if (req->r_callback)
+		req->r_callback(req);
+	else
+		complete(&req->r_completion);
+
+	if (flags & CEPH_OSD_FLAG_ONDISK) {
+		if (req->r_safe_callback)
+			req->r_safe_callback(req);
+		complete(&req->r_safe_completion);  /* fsync waiter */
+	}
+
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
+	int needmap = 0;
+
+	mutex_lock(&osdc->request_mutex);
+	while (1) {
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+		if (got == 0)
+			break;
+		next_tid = req->r_tid + 1;
+
+		if (who && ceph_entity_addr_equal(who, &req->r_last_osd_addr))
+			goto kick;
+
+		if (map_osds(osdc, req) == 0)
+			continue;  /* no change */
+
+		if (req->r_last_osd < 0) {
+			dout(20, "tid %llu maps to no valid osd\n", req->r_tid);
+			needmap++;  /* request a newer map */
+			memset(&req->r_last_osd_addr, 0,
+			       sizeof(req->r_last_osd_addr));
+			continue;
+		}
+
+	kick:
+		dout(20, "kicking tid %llu osd%d\n", req->r_tid,
+		     req->r_last_osd);
+		ceph_osdc_get_request(req);
+		mutex_unlock(&osdc->request_mutex);
+		req->r_request = ceph_msg_maybe_dup(req->r_request);
+		if (!req->r_aborted) {
+			req->r_flags |= CEPH_OSD_FLAG_RETRY;
+			send_request(osdc, req);
+		}
+		ceph_osdc_put_request(req);
+		mutex_lock(&osdc->request_mutex);
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
+	ceph_fsid_t fsid;
+	__le64 major, minor;
+
+	dout(2, "handle_map have %u\n", osdc->osdmap ? osdc->osdmap->epoch : 0);
+	p = msg->front.iov_base;
+	end = p + msg->front.iov_len;
+
+	/* verify fsid */
+	ceph_decode_need(&p, end, sizeof(fsid), bad);
+	ceph_decode_64_le(&p, major);
+	__ceph_fsid_set_major(&fsid, major);
+	ceph_decode_64_le(&p, minor);
+	__ceph_fsid_set_minor(&fsid, minor);
+	if (ceph_fsid_compare(&fsid, &osdc->client->monc.monmap->fsid)) {
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
+				ceph_osdmap_destroy(osdc->osdmap);
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
+	if (likely(req->r_num_pages >= want && req->r_reply == NULL &&
+		    !req->r_aborted)) {
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
+int ceph_osdc_start_request(struct ceph_osd_client *osdc,
+			    struct ceph_osd_request *req)
+{
+	int rc;
+
+	req->r_request->pages = req->r_pages;
+	req->r_request->nr_pages = req->r_num_pages;
+
+	rc = register_request(osdc, req);
+	if (rc < 0)
+		return rc;
+
+	down_read(&osdc->map_sem);
+	rc = send_request(osdc, req);
+	up_read(&osdc->map_sem);
+	return rc;
+}
+
+int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
+			   struct ceph_osd_request *req)
+{
+	struct ceph_osd_reply_head *replyhead;
+	__s32 rc;
+	int bytes;
+
+	rc = wait_for_completion_interruptible(&req->r_completion);
+	if (rc < 0) {
+		ceph_osdc_abort_request(osdc, req);
+		return rc;
+	}
+
+	/* parse reply */
+	replyhead = req->r_reply->front.iov_base;
+	rc = le32_to_cpu(replyhead->result);
+	bytes = le32_to_cpu(req->r_reply->hdr.data_len);
+	dout(10, "wait_request tid %llu result %d, %d bytes\n",
+	     req->r_tid, rc, bytes);
+	if (rc < 0)
+		return rc;
+	return bytes;
+}
+
+/*
+ * To abort an in-progress request, take pages away from outgoing or
+ * incoming message.
+ */
+void ceph_osdc_abort_request(struct ceph_osd_client *osdc,
+			     struct ceph_osd_request *req)
+{
+	struct ceph_msg *msg;
+
+	dout(0, "abort_request tid %llu, revoking %p pages\n", req->r_tid,
+	     req->r_request);
+	/*
+	 * mark req aborted _before_ revoking pages, so that
+	 * if a racing kick_request _does_ dup the page vec
+	 * pointer, it will definitely then see the aborted
+	 * flag and not send the request.
+	 */
+	req->r_aborted = 1;
+	msg = req->r_request;
+	mutex_lock(&msg->page_mutex);
+	msg->pages = NULL;
+	mutex_unlock(&msg->page_mutex);
+	if (req->r_reply) {
+		mutex_lock(&req->r_reply->page_mutex);
+		req->r_reply->pages = NULL;
+		mutex_unlock(&req->r_reply->page_mutex);
+	}
+}
+
+void ceph_osdc_sync(struct ceph_osd_client *osdc)
+{
+	struct ceph_osd_request *req;
+	u64 last_tid, next_tid = 0;
+	int got;
+
+	mutex_lock(&osdc->request_mutex);
+	last_tid = osdc->last_tid;
+	while (1) {
+		got = radix_tree_gang_lookup(&osdc->request_tree, (void **)&req,
+					     next_tid, 1);
+		if (!got)
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
+		dout(10, "sync waiting on tid %llu (last is %llu)\n",
+		     req->r_tid, last_tid);
+		wait_for_completion(&req->r_safe_completion);
+		mutex_lock(&osdc->request_mutex);
+		ceph_osdc_put_request(req);
+	}
+	mutex_unlock(&osdc->request_mutex);
+	dout(10, "sync done (thru tid %llu)\n", last_tid);
+}
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
+	osdc->timeout_tid = 0;
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
+		ceph_osdmap_destroy(osdc->osdmap);
+		osdc->osdmap = NULL;
+	}
+}
+
+/*
+ * Read some contiguous pages.  Return number of bytes read (or
+ * zeroed).
+ */
+int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			struct ceph_vino vino, struct ceph_file_layout *layout,
+			u64 off, u64 len,
+			u32 truncate_seq, u64 truncate_size,
+			struct page **pages, int num_pages)
+{
+	struct ceph_osd_request *req;
+	int i;
+	struct page *page;
+	int rc = 0, read = 0;
+
+	dout(10, "readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
+	     vino.snap, off, len);
+	req = ceph_osdc_new_request(osdc, layout, vino, off, &len,
+				    CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+				    NULL, 0, truncate_seq, truncate_size, NULL);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short read due to an object boundary */
+	req->r_pages = pages;
+	num_pages = calc_pages_for(off, len);
+	req->r_num_pages = num_pages;
+
+	dout(10, "readpages final extent is %llu~%llu (%d pages)\n",
+	     off, len, req->r_num_pages);
+
+	rc = ceph_osdc_start_request(osdc, req);
+	if (!rc)
+		rc = ceph_osdc_wait_request(osdc, req);
+
+	if (rc >= 0) {
+		read = rc;
+		rc = len;
+	} else if (rc == -ENOENT) {
+		rc = len;
+	}
+
+	/* zero trailing pages on success */
+	if (read < (num_pages << PAGE_CACHE_SHIFT)) {
+		if (read & ~PAGE_CACHE_MASK) {
+			i = read >> PAGE_CACHE_SHIFT;
+			page = pages[i];
+			dout(20, "readpages zeroing %d %p from %d\n", i, page,
+			     (int)(read & ~PAGE_CACHE_MASK));
+			zero_user_segment(page, read & ~PAGE_CACHE_MASK,
+					  PAGE_CACHE_SIZE);
+			read += PAGE_CACHE_SIZE;
+		}
+		for (i = read >> PAGE_CACHE_SHIFT; i < num_pages; i++) {
+			page = req->r_pages[i];
+			dout(20, "readpages zeroing %d %p\n", i, page);
+			zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		}
+	}
+
+	ceph_osdc_put_request(req);
+	dout(10, "readpages result %d\n", rc);
+	return rc;
+}
+
+/*
+ * do a sync write on N pages
+ */
+int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
+			 struct ceph_file_layout *layout,
+			 struct ceph_snap_context *snapc,
+			 u64 off, u64 len,
+			 u32 truncate_seq, u64 truncate_size,
+			 struct timespec *mtime,
+			 struct page **pages, int num_pages,
+			 int flags, int do_sync)
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
+				    truncate_seq, truncate_size, mtime);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* it may be a short write due to an object boundary */
+	req->r_pages = pages;
+	req->r_num_pages = calc_pages_for(off, len);
+	dout(10, "writepages %llu~%llu (%d pages)\n", off, len,
+	     req->r_num_pages);
+
+	rc = ceph_osdc_start_request(osdc, req);
+	if (!rc)
+		rc = ceph_osdc_wait_request(osdc, req);
+
+	ceph_osdc_put_request(req);
+	if (rc == 0)
+		rc = len;
+	dout(10, "writepages result %d\n", rc);
+	return rc;
+}
+
diff --git a/fs/staging/ceph/osd_client.h b/fs/staging/ceph/osd_client.h
new file mode 100644
index 0000000..9ad2559
--- /dev/null
+++ b/fs/staging/ceph/osd_client.h
@@ -0,0 +1,151 @@
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
+struct ceph_osd_request_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct ceph_osd_request *,
+			struct ceph_osd_request_attr *,
+			char *);
+	ssize_t (*store)(struct ceph_osd_request *,
+			 struct ceph_osd_request_attr *,
+			 const char *, size_t);
+};
+
+/* an in-flight request */
+struct ceph_osd_request {
+	u64             r_tid;              /* unique for this client */
+
+	struct ceph_msg  *r_request;
+	struct ceph_msg  *r_reply;
+	int               r_result;
+	int               r_flags;     /* any additional flags for the osd */
+	int               r_aborted;   /* set if we cancel this request */
+
+	atomic_t          r_ref;
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
+	int               r_last_osd;         /* pg osds */
+	struct ceph_entity_addr r_last_osd_addr;
+	unsigned long     r_timeout_stamp;
+
+	struct ceph_file_layout r_file_layout;
+	struct ceph_snap_context *r_snapc;    /* snap context for writes */
+	unsigned          r_num_pages;        /* size of page array (follows) */
+	struct page     **r_pages;            /* pages for data payload */
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
+	u64                    timeout_tid;   /* tid of timeout triggering rq */
+	u64                    last_tid;      /* tid of last request */
+	struct radix_tree_root request_tree;  /* pending requests, by tid */
+	int                    num_requests;
+	struct delayed_work    timeout_work;
+	struct dentry 	       *debugfs_file;
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
+				      u64 offset, u64 *len, int op, int flags,
+				      struct ceph_snap_context *snapc,
+				      int do_sync, u32 truncate_seq,
+				      u64 truncate_size,
+				      struct timespec *mtime);
+
+static inline void ceph_osdc_get_request(struct ceph_osd_request *req)
+{
+	atomic_inc(&req->r_ref);
+}
+extern void ceph_osdc_put_request(struct ceph_osd_request *req);
+
+extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
+				   struct ceph_osd_request *req);
+extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
+				  struct ceph_osd_request *req);
+extern void ceph_osdc_abort_request(struct ceph_osd_client *osdc,
+				    struct ceph_osd_request *req);
+extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
+
+extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
+			       struct ceph_vino vino,
+			       struct ceph_file_layout *layout,
+			       u64 off, u64 len,
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
+				int flags, int do_sync);
+
+#endif
+
diff --git a/fs/staging/ceph/osdmap.c b/fs/staging/ceph/osdmap.c
new file mode 100644
index 0000000..1e4f832
--- /dev/null
+++ b/fs/staging/ceph/osdmap.c
@@ -0,0 +1,703 @@
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
+int ceph_debug_osdmap __read_mostly = -1;
+#define DOUT_MASK DOUT_MASK_OSDMAP
+#define DOUT_VAR ceph_debug_osdmap
+
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
+	dout(30, "crush_decode_uniform_bucket %p to %p\n", *p, end);
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
+	ceph_decode_32_safe(p, end, b->num_nodes, bad);
+	b->node_weights = kmalloc(b->num_nodes * sizeof(u32), GFP_NOFS);
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
+	dout(30, "crush_decode_straw_bucket %p to %p\n", *p, end);
+	b->item_weights = kmalloc(b->h.size * sizeof(u32), GFP_NOFS);
+	if (b->item_weights == NULL)
+		return -ENOMEM;
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
+	u32 magic;
+
+	dout(30, "crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	c = kzalloc(sizeof(*c), GFP_NOFS);
+	if (c == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(p, end, 4*sizeof(u32), bad);
+	ceph_decode_32(p, magic);
+	if (magic != CRUSH_MAGIC) {
+		derr(0, "crush_decode magic %x != current %x\n",
+		     (unsigned)magic, (unsigned)CRUSH_MAGIC);
+		goto bad;
+	}
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
+		u32 alg;
+		struct crush_bucket *b;
+
+		ceph_decode_32_safe(p, end, alg, bad);
+		if (alg == 0) {
+			c->buckets[i] = NULL;
+			continue;
+		}
+		dout(30, "crush_decode bucket %d off %x %p to %p\n",
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
+		dout(30, "crush_decode bucket size %d off %x %p to %p\n",
+		     b->size, (int)(*p-start), *p, end);
+
+		b->items = kmalloc(b->size * sizeof(__s32), GFP_NOFS);
+		if (b->items == NULL)
+			goto badmem;
+		b->perm = kmalloc(b->size * sizeof(u32), GFP_NOFS);
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
+void ceph_osdmap_destroy(struct ceph_osdmap *map)
+{
+	dout(10, "osdmap_destroy %p\n", map);
+	if (map->crush)
+		crush_destroy(map->crush);
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
+	__le64 major, minor;
+
+	dout(30, "osdmap_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+
+	map = kzalloc(sizeof(*map), GFP_NOFS);
+	if (map == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(p, end, 2*sizeof(u64)+6*sizeof(u32), bad);
+	ceph_decode_64_le(p, major);
+	__ceph_fsid_set_major(&map->fsid, major);
+	ceph_decode_64_le(p, minor);
+	__ceph_fsid_set_minor(&map->fsid, minor);
+	ceph_decode_32(p, map->epoch);
+	ceph_decode_32_le(p, map->created.tv_sec);
+	ceph_decode_32_le(p, map->created.tv_nsec);
+	ceph_decode_32_le(p, map->modified.tv_sec);
+	ceph_decode_32_le(p, map->modified.tv_nsec);
+
+	ceph_decode_32(p, map->num_pools);
+	map->pg_pool = kmalloc(map->num_pools * sizeof(*map->pg_pool),
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
+	/* ignore the rest of the map */
+	*p = end;
+
+	dout(30, "osdmap_decode done %p %p\n", *p, end);
+	return map;
+
+bad:
+	dout(30, "osdmap_decode fail\n");
+	ceph_osdmap_destroy(map);
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
+	ceph_fsid_t fsid;
+	u32 epoch = 0;
+	struct ceph_timespec modified;
+	u32 len, pool;
+	__s32 new_flags, max;
+	void *start = *p;
+	int err = -EINVAL;
+	__le64 major, minor;
+
+	ceph_decode_need(p, end, sizeof(fsid)+sizeof(modified)+2*sizeof(u32),
+			 bad);
+	ceph_decode_64_le(p, major);
+	__ceph_fsid_set_major(&fsid, major);
+	ceph_decode_64_le(p, minor);
+	__ceph_fsid_set_minor(&fsid, minor);
+	ceph_decode_32(p, epoch);
+	BUG_ON(epoch != map->epoch+1);
+	ceph_decode_32_le(p, modified.tv_sec);
+	ceph_decode_32_le(p, modified.tv_nsec);
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
+			void *pg_pool = kzalloc((pool+1)*sizeof(*map->pg_pool),
+					  GFP_NOFS);
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
+	/* ignore the rest */
+	*p = end;
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
+	*bno = cpu_to_le32(objsetno * sc + stripepos);
+	dout(80, "objset %u * sc %u = bno %u\n", objsetno, sc, (unsigned)*bno);
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
+
+	ol->ol_pgid = cpu_to_le64(pgid.pg64);
+	ol->ol_stripe_unit = fl->fl_object_stripe_unit;
+
+	return 0;
+}
diff --git a/fs/staging/ceph/osdmap.h b/fs/staging/ceph/osdmap.h
new file mode 100644
index 0000000..757aaf5
--- /dev/null
+++ b/fs/staging/ceph/osdmap.h
@@ -0,0 +1,83 @@
+#ifndef _FS_CEPH_OSDMAP_H
+#define _FS_CEPH_OSDMAP_H
+
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
+struct ceph_osdmap {
+	ceph_fsid_t fsid;
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
+	u32 num_pools;
+	struct ceph_pg_pool_info *pg_pool;
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
+extern char *ceph_osdmap_state_str(char *str, int len, int state);
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
+
+#endif
-- 
1.5.6.5

