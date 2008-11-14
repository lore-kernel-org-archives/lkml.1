Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYKNBaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYKNBaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYKNBXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:23:36 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38152 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbYKNBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:31 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 12/19] ceph: monitor client
Date: Thu, 13 Nov 2008 16:56:11 -0800
Message-Id: <1226624178-3761-13-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226624178-3761-12-git-send-email-sage@newdream.net>
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
 <1226624178-3761-11-git-send-email-sage@newdream.net>
 <1226624178-3761-12-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The monitor cluster is responsible for managing cluster membership
and state.  The monitor client handles what minimal interaction
the Ceph client has with it.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/mon_client.c |  385 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mon_client.h |  100 +++++++++++++
 2 files changed, 485 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/mon_client.c
 create mode 100644 fs/ceph/mon_client.h

diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
new file mode 100644
index 0000000..ea4a5b2
--- /dev/null
+++ b/fs/ceph/mon_client.c
@@ -0,0 +1,385 @@
+
+#include <linux/types.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include "mon_client.h"
+
+#include "ceph_debug.h"
+
+int ceph_debug_mon = -1;
+#define DOUT_MASK DOUT_MASK_MON
+#define DOUT_VAR ceph_debug_mon
+#define DOUT_PREFIX "mon: "
+#include "super.h"
+#include "decode.h"
+
+/*
+ * Decode a monmap blob (e.g., during mount).
+ */
+struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
+{
+	struct ceph_monmap *m;
+	int i, err = -EINVAL;
+
+	dout(30, "monmap_decode %p %p len %d\n", p, end, (int)(end-p));
+
+	/* The encoded and decoded sizes match. */
+	m = kmalloc(end-p, GFP_NOFS);
+	if (m == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(&p, end, 2*sizeof(u32) + 2*sizeof(u64), bad);
+	ceph_decode_64_le(&p, m->fsid.major);
+	ceph_decode_64_le(&p, m->fsid.minor);
+	ceph_decode_32(&p, m->epoch);
+	ceph_decode_32(&p, m->num_mon);
+	ceph_decode_need(&p, end, m->num_mon*sizeof(m->mon_inst[0]), bad);
+	ceph_decode_copy(&p, m->mon_inst, m->num_mon*sizeof(m->mon_inst[0]));
+	if (p != end)
+		goto bad;
+
+	dout(30, "monmap_decode epoch %d, num_mon %d\n", m->epoch,
+	     m->num_mon);
+	for (i = 0; i < m->num_mon; i++)
+		dout(30, "monmap_decode  mon%d is %u.%u.%u.%u:%u\n", i,
+		     IPQUADPORT(m->mon_inst[i].addr.ipaddr));
+	return m;
+
+bad:
+	dout(30, "monmap_decode failed with %d\n", err);
+	kfree(m);
+	return ERR_PTR(err);
+}
+
+/*
+ * return true if *addr is included in the monmap.
+ */
+int ceph_monmap_contains(struct ceph_monmap *m, struct ceph_entity_addr *addr)
+{
+	int i;
+
+	for (i = 0; i < m->num_mon; i++)
+		if (ceph_entity_addr_equal(addr, &m->mon_inst[i].addr))
+			return 1;
+	return 0;
+}
+
+/*
+ * Choose a monitor.  If @notmon >= 0, choose a different monitor than
+ * last time.
+ */
+static int pick_mon(struct ceph_mon_client *monc, int notmon)
+{
+	char r;
+
+	if (notmon < 0 && monc->last_mon >= 0)
+		return monc->last_mon;
+	get_random_bytes(&r, 1);
+	monc->last_mon = r % monc->monmap->num_mon;
+	return monc->last_mon;
+}
+
+/*
+ * Delay work with exponential backoff.
+ */
+static void delayed_work(struct delayed_work *dwork, unsigned long *delay)
+{
+	schedule_delayed_work(dwork, *delay);
+	if (*delay < MAX_DELAY_INTERVAL)
+		*delay *= 2;
+	else
+		*delay = MAX_DELAY_INTERVAL;
+}
+
+
+/*
+ * mds map
+ */
+static void do_request_mdsmap(struct work_struct *work)
+{
+	struct ceph_msg *msg;
+	struct ceph_mds_getmap *h;
+	struct ceph_mon_client *monc =
+		container_of(work, struct ceph_mon_client,
+			     mds_delayed_work.work);
+	int mon = pick_mon(monc, -1);
+
+	dout(5, "request_mdsmap from mon%d want %u\n", mon, monc->want_mdsmap);
+	msg = ceph_msg_new(CEPH_MSG_MDS_GETMAP, sizeof(*h), 0, 0, NULL);
+	if (IS_ERR(msg))
+		return;
+	h = msg->front.iov_base;
+	h->fsid = monc->monmap->fsid;
+	h->want = cpu_to_le32(monc->want_mdsmap);
+	msg->hdr.dst = monc->monmap->mon_inst[mon];
+	ceph_msg_send(monc->client->msgr, msg, 0);
+
+	/* keep sending request until we receive mds map */
+	if (monc->want_mdsmap)
+		delayed_work(&monc->mds_delayed_work, &monc->mds_delay);
+}
+
+/*
+ * Register our desire for an mdsmap >= epoch @want.
+ */
+void ceph_monc_request_mdsmap(struct ceph_mon_client *monc, u32 want)
+{
+	dout(5, "request_mdsmap want %u\n", want);
+	mutex_lock(&monc->req_mutex);
+	if (want > monc->want_mdsmap) {
+		monc->mds_delay = BASE_DELAY_INTERVAL;
+		monc->want_mdsmap = want;
+		do_request_mdsmap(&monc->mds_delayed_work.work);
+	}
+	mutex_unlock(&monc->req_mutex);
+}
+
+/*
+ * Called when we receive an mds map.
+ */
+int ceph_monc_got_mdsmap(struct ceph_mon_client *monc, u32 got)
+{
+	int ret = 0;
+
+	mutex_lock(&monc->req_mutex);
+	if (got < monc->want_mdsmap) {
+		dout(5, "got_mdsmap %u < wanted %u\n", got, monc->want_mdsmap);
+		ret = -EAGAIN;
+	} else {
+		dout(5, "got_mdsmap %u >= wanted %u\n", got, monc->want_mdsmap);
+		monc->want_mdsmap = 0;
+		cancel_delayed_work_sync(&monc->mds_delayed_work);
+		monc->mds_delay = BASE_DELAY_INTERVAL;
+	}
+	mutex_unlock(&monc->req_mutex);
+	return ret;
+}
+
+
+/*
+ * osd map
+ */
+static void do_request_osdmap(struct work_struct *work)
+{
+	struct ceph_msg *msg;
+	struct ceph_osd_getmap *h;
+	struct ceph_mon_client *monc =
+		container_of(work, struct ceph_mon_client,
+			     osd_delayed_work.work);
+	int mon = pick_mon(monc, -1);
+
+	dout(5, "request_osdmap from mon%d want %u\n", mon, monc->want_osdmap);
+	msg = ceph_msg_new(CEPH_MSG_OSD_GETMAP, sizeof(*h), 0, 0, NULL);
+	if (IS_ERR(msg))
+		return;
+	h = msg->front.iov_base;
+	h->fsid = monc->monmap->fsid;
+	h->start = cpu_to_le32(monc->want_osdmap);
+	msg->hdr.dst = monc->monmap->mon_inst[mon];
+	ceph_msg_send(monc->client->msgr, msg, 0);
+
+	/* keep sending request until we receive osd map */
+	if (monc->want_osdmap)
+		delayed_work(&monc->osd_delayed_work, &monc->osd_delay);
+}
+
+void ceph_monc_request_osdmap(struct ceph_mon_client *monc, u32 want)
+{
+	dout(5, "request_osdmap want %u\n", want);
+	mutex_lock(&monc->req_mutex);
+	monc->osd_delay = BASE_DELAY_INTERVAL;
+	monc->want_osdmap = want;
+	do_request_osdmap(&monc->osd_delayed_work.work);
+	mutex_unlock(&monc->req_mutex);
+}
+
+int ceph_monc_got_osdmap(struct ceph_mon_client *monc, u32 got)
+{
+	int ret = 0;
+
+	mutex_lock(&monc->req_mutex);
+	if (got < monc->want_osdmap) {
+		dout(5, "got_osdmap %u < wanted %u\n", got, monc->want_osdmap);
+		ret = -EAGAIN;
+	} else {
+		dout(5, "got_osdmap %u >= wanted %u\n", got, monc->want_osdmap);
+		monc->want_osdmap = 0;
+		cancel_delayed_work_sync(&monc->osd_delayed_work);
+		monc->osd_delay = BASE_DELAY_INTERVAL;
+	}
+	mutex_unlock(&monc->req_mutex);
+	return ret;
+}
+
+
+/*
+ * umount
+ */
+static void do_request_umount(struct work_struct *work)
+{
+	struct ceph_msg *msg;
+	struct ceph_mon_client *monc =
+		container_of(work, struct ceph_mon_client,
+			     umount_delayed_work.work);
+	int mon = pick_mon(monc, -1);
+
+	dout(5, "do_request_umount from mon%d\n", mon);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_UNMOUNT, 0, 0, 0, NULL);
+	if (IS_ERR(msg))
+		return;
+	msg->hdr.dst = monc->monmap->mon_inst[mon];
+	ceph_msg_send(monc->client->msgr, msg, 0);
+
+	delayed_work(&monc->umount_delayed_work, &monc->umount_delay);
+}
+
+void ceph_monc_request_umount(struct ceph_mon_client *monc)
+{
+	struct ceph_client *client = monc->client;
+
+	/* don't bother if forced unmount */
+	if (client->mount_state == CEPH_MOUNT_SHUTDOWN)
+		return;
+
+	mutex_lock(&monc->req_mutex);
+	monc->umount_delay = BASE_DELAY_INTERVAL;
+	do_request_umount(&monc->umount_delayed_work.work);
+	mutex_unlock(&monc->req_mutex);
+}
+
+/*
+ * Handle monitor umount ack.
+ */
+void ceph_monc_handle_umount(struct ceph_mon_client *monc,
+			     struct ceph_msg *msg)
+{
+	dout(5, "handle_umount\n");
+	mutex_lock(&monc->req_mutex);
+	cancel_delayed_work_sync(&monc->umount_delayed_work);
+	monc->client->mount_state = CEPH_MOUNT_UNMOUNTED;
+	mutex_unlock(&monc->req_mutex);
+	wake_up(&monc->client->mount_wq);
+}
+
+
+/*
+ * statfs
+ */
+void ceph_monc_handle_statfs_reply(struct ceph_mon_client *monc,
+				   struct ceph_msg *msg)
+{
+	struct ceph_mon_statfs_request *req;
+	struct ceph_mon_statfs_reply *reply = msg->front.iov_base;
+	u64 tid;
+
+	if (msg->front.iov_len != sizeof(*reply))
+		goto bad;
+	tid = le64_to_cpu(reply->tid);
+	dout(10, "handle_statfs_reply %p tid %llu\n", msg, tid);
+
+	spin_lock(&monc->statfs_lock);
+	req = radix_tree_lookup(&monc->statfs_request_tree, tid);
+	if (req) {
+		radix_tree_delete(&monc->statfs_request_tree, tid);
+		req->buf->f_total = reply->st.f_total;
+		req->buf->f_free = reply->st.f_free;
+		req->buf->f_avail = reply->st.f_avail;
+		req->buf->f_objects = reply->st.f_objects;
+		req->result = 0;
+	}
+	spin_unlock(&monc->statfs_lock);
+	if (req)
+		complete(&req->completion);
+	return;
+
+bad:
+	derr(10, "corrupt statfs reply, no tid\n");
+}
+
+/*
+ * (re)send a statfs request
+ */
+static int send_statfs(struct ceph_mon_client *monc, u64 tid)
+{
+	struct ceph_msg *msg;
+	struct ceph_mon_statfs *h;
+	int mon = pick_mon(monc, -1);
+
+	dout(10, "send_statfs to mon%d tid %llu\n", mon, tid);
+	msg = ceph_msg_new(CEPH_MSG_STATFS, sizeof(*h), 0, 0, NULL);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+	h = msg->front.iov_base;
+	h->fsid = monc->monmap->fsid;
+	h->tid = cpu_to_le64(tid);
+	msg->hdr.dst = monc->monmap->mon_inst[mon];
+	ceph_msg_send(monc->client->msgr, msg, 0);
+	return 0;
+}
+
+/*
+ * Do a synchronous statfs().
+ */
+int ceph_monc_do_statfs(struct ceph_mon_client *monc, struct ceph_statfs *buf)
+{
+	struct ceph_mon_statfs_request req;
+	int err;
+
+	req.buf = buf;
+	init_completion(&req.completion);
+
+	/* register request */
+	err = radix_tree_preload(GFP_NOFS);
+	if (err < 0) {
+		derr(10, "ENOMEM in do_statfs\n");
+		return err;
+	}
+	spin_lock(&monc->statfs_lock);
+	req.tid = ++monc->last_tid;
+	req.last_attempt = jiffies;
+	radix_tree_insert(&monc->statfs_request_tree, req.tid, &req);
+	spin_unlock(&monc->statfs_lock);
+	radix_tree_preload_end();
+
+	/* send request and wait */
+	err = send_statfs(monc, req.tid);
+	if (err)
+		return err;
+	err = wait_for_completion_interruptible(&req.completion);
+	if (err == -EINTR)
+		return err;
+	return req.result;
+}
+
+
+int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
+{
+	dout(5, "init\n");
+	memset(monc, 0, sizeof(*monc));
+	monc->client = cl;
+	monc->monmap = kzalloc(sizeof(struct ceph_monmap) +
+		       sizeof(struct ceph_entity_addr) * MAX_MON_MOUNT_ADDR,
+		       GFP_KERNEL);
+	if (monc->monmap == NULL)
+		return -ENOMEM;
+	spin_lock_init(&monc->statfs_lock);
+	INIT_RADIX_TREE(&monc->statfs_request_tree, GFP_ATOMIC);
+	monc->last_tid = 0;
+	INIT_DELAYED_WORK(&monc->mds_delayed_work, do_request_mdsmap);
+	INIT_DELAYED_WORK(&monc->osd_delayed_work, do_request_osdmap);
+	INIT_DELAYED_WORK(&monc->umount_delayed_work, do_request_umount);
+	monc->mds_delay = monc->osd_delay = monc->umount_delay = 0;
+	mutex_init(&monc->req_mutex);
+	monc->want_mdsmap = 0;
+	monc->want_osdmap = 0;
+	return 0;
+}
+
+void ceph_monc_stop(struct ceph_mon_client *monc)
+{
+	dout(5, "stop\n");
+	cancel_delayed_work_sync(&monc->mds_delayed_work);
+	cancel_delayed_work_sync(&monc->osd_delayed_work);
+	cancel_delayed_work_sync(&monc->umount_delayed_work);
+	kfree(monc->monmap);
+}
diff --git a/fs/ceph/mon_client.h b/fs/ceph/mon_client.h
new file mode 100644
index 0000000..920cda8
--- /dev/null
+++ b/fs/ceph/mon_client.h
@@ -0,0 +1,100 @@
+#ifndef _FS_CEPH_MON_CLIENT_H
+#define _FS_CEPH_MON_CLIENT_H
+
+#include "messenger.h"
+#include <linux/completion.h>
+#include <linux/radix-tree.h>
+
+/*
+ * A small cluster of Ceph "monitors" are responsible for managing critical
+ * cluster configuration and state information.  An odd number (e.g., 3, 5)
+ * of cmon daemons use a modified version of the Paxos part-time parliament
+ * algorithm to manage the MDS map (mds cluster membership), OSD map, and
+ * list of clients who have mounted the file system.
+ *
+ * Communication with the monitor cluster is lossy, so requests for
+ * information may have to be resent if we time out waiting for a response.
+ * As long as we do not time out, we continue to send all requests to the
+ * same monitor.  If there is a problem, we randomly pick a new monitor form
+ * the cluster to try.
+ */
+
+struct ceph_client;
+struct ceph_mount_args;
+
+/*
+ * The monitor map enumerates the set of all monitors.
+ *
+ * Make sure this structure size matches the encoded map size, or change
+ * ceph_monmap_decode().
+ */
+struct ceph_monmap {
+	struct ceph_fsid fsid;
+	u32 epoch;
+	u32 num_mon;
+	struct ceph_entity_inst mon_inst[0];
+};
+
+/*
+ * a pending statfs() request.
+ */
+struct ceph_mon_statfs_request {
+	u64 tid;
+	int result;
+	struct ceph_statfs *buf;
+	struct completion completion;
+	unsigned long last_attempt; /* jiffies */
+};
+
+struct ceph_mon_client {
+	struct ceph_client *client;
+	int last_mon;                       /* last monitor i contacted */
+	struct ceph_monmap *monmap;
+
+	/* pending statfs requests */
+	spinlock_t statfs_lock;
+	struct radix_tree_root statfs_request_tree;
+	u64 last_tid;
+
+	/* mds/osd map or umount requests */
+	struct delayed_work mds_delayed_work;
+	struct delayed_work osd_delayed_work;
+	struct delayed_work umount_delayed_work;
+	unsigned long mds_delay;
+	unsigned long osd_delay;
+	unsigned long umount_delay;
+	struct mutex req_mutex;
+	u32 want_mdsmap;
+	u32 want_osdmap;
+};
+
+extern struct ceph_monmap *ceph_monmap_decode(void *p, void *end);
+extern int ceph_monmap_contains(struct ceph_monmap *m,
+				struct ceph_entity_addr *addr);
+
+extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
+extern void ceph_monc_stop(struct ceph_mon_client *monc);
+
+/*
+ * The model here is to indicate that we need a new map of at least epoch
+ * @want, and to indicate which maps receive.  Periodically rerequest the map
+ * from the monitor cluster until we get what we want.
+ */
+extern void ceph_monc_request_mdsmap(struct ceph_mon_client *monc, u32 want);
+extern int ceph_monc_got_mdsmap(struct ceph_mon_client *monc, u32 have);
+
+extern void ceph_monc_request_osdmap(struct ceph_mon_client *monc, u32 want);
+extern int ceph_monc_got_osdmap(struct ceph_mon_client *monc, u32 have);
+
+extern void ceph_monc_request_umount(struct ceph_mon_client *monc);
+
+extern int ceph_monc_do_statfs(struct ceph_mon_client *monc,
+			       struct ceph_statfs *buf);
+extern void ceph_monc_handle_statfs_reply(struct ceph_mon_client *monc,
+					  struct ceph_msg *msg);
+
+extern void ceph_monc_request_umount(struct ceph_mon_client *monc);
+extern void ceph_monc_handle_umount(struct ceph_mon_client *monc,
+				    struct ceph_msg *msg);
+
+#endif
-- 
1.5.6.5

