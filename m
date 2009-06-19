Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZFSWf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZFSWf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZFSWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:24 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44750 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255AbZFSWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:01 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 13/21] ceph: monitor client
Date: Fri, 19 Jun 2009 15:31:34 -0700
Message-Id: <1245450702-31343-14-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245450702-31343-13-git-send-email-sage@newdream.net>
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
 <1245450702-31343-12-git-send-email-sage@newdream.net>
 <1245450702-31343-13-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The monitor cluster is responsible for managing cluster membership
and state.  The monitor client handles what minimal interaction
the Ceph client has with it: checking for updated versions of the
MDS and OSD maps, and getting statfs() information.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/staging/ceph/mon_client.c |  451 ++++++++++++++++++++++++++++++++++++++++++
 fs/staging/ceph/mon_client.h |  135 +++++++++++++
 2 files changed, 586 insertions(+), 0 deletions(-)
 create mode 100644 fs/staging/ceph/mon_client.c
 create mode 100644 fs/staging/ceph/mon_client.h

diff --git a/fs/staging/ceph/mon_client.c b/fs/staging/ceph/mon_client.c
new file mode 100644
index 0000000..5551787
--- /dev/null
+++ b/fs/staging/ceph/mon_client.c
@@ -0,0 +1,451 @@
+
+#include <linux/types.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include "mon_client.h"
+
+#include "ceph_debug.h"
+
+int ceph_debug_mon __read_mostly = -1;
+#define DOUT_MASK DOUT_MASK_MON
+#define DOUT_VAR ceph_debug_mon
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
+	__le64 major, minor;
+
+	dout(30, "monmap_decode %p %p len %d\n", p, end, (int)(end-p));
+
+	/* The encoded and decoded sizes match. */
+	m = kmalloc(end-p, GFP_NOFS);
+	if (m == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	ceph_decode_need(&p, end, 2*sizeof(u32) + 2*sizeof(u64), bad);
+	ceph_decode_64_le(&p, major);
+	__ceph_fsid_set_major(&m->fsid, major);
+	ceph_decode_64_le(&p, minor);
+	__ceph_fsid_set_minor(&m->fsid, minor);
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
+static int pick_mon(struct ceph_mon_client *monc, int newmon)
+{
+	char r;
+
+	if (!newmon && monc->last_mon >= 0)
+		return monc->last_mon;
+	get_random_bytes(&r, 1);
+	monc->last_mon = r % monc->monmap->num_mon;
+	return monc->last_mon;
+}
+
+/*
+ * Generic timeout mechanism for monitor requests
+ */
+static void reschedule_timeout(struct ceph_mon_request *req)
+{
+	schedule_delayed_work(&req->delayed_work, req->delay);
+	if (req->delay < MAX_DELAY_INTERVAL)
+		req->delay *= 2;
+	else
+		req->delay = MAX_DELAY_INTERVAL;
+}
+
+static void retry_request(struct work_struct *work)
+{
+	struct ceph_mon_request *req =
+		container_of(work, struct ceph_mon_request,
+			     delayed_work.work);
+
+	/*
+	 * if lock is contended, reschedule sooner.  we can't wait for
+	 * mutex because we cancel the timeout sync with lock held.
+	 */
+	if (mutex_trylock(&req->monc->req_mutex)) {
+		req->do_request(req->monc, 1);
+		reschedule_timeout(req);
+		mutex_unlock(&req->monc->req_mutex);
+	} else
+		schedule_delayed_work(&req->delayed_work, BASE_DELAY_INTERVAL);
+}
+
+static void cancel_timeout(struct ceph_mon_request *req)
+{
+	cancel_delayed_work_sync(&req->delayed_work);
+	req->delay = BASE_DELAY_INTERVAL;
+}
+
+static void init_request_type(struct ceph_mon_client *monc,
+			      struct ceph_mon_request *req,
+			      ceph_monc_request_func_t func)
+{
+	req->monc = monc;
+	INIT_DELAYED_WORK(&req->delayed_work, retry_request);
+	req->delay = 0;
+	req->do_request = func;
+}
+
+
+/*
+ * mds map
+ */
+static void request_mdsmap(struct ceph_mon_client *monc, int newmon)
+{
+	struct ceph_msg *msg;
+	struct ceph_mds_getmap *h;
+	int mon = pick_mon(monc, newmon);
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
+		monc->want_mdsmap = want;
+		monc->mdsreq.delay = BASE_DELAY_INTERVAL;
+		request_mdsmap(monc, 0);
+		reschedule_timeout(&monc->mdsreq);
+	}
+	mutex_unlock(&monc->req_mutex);
+}
+
+/*
+ * Possibly cancel our desire for a new map
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
+		cancel_timeout(&monc->mdsreq);
+	}
+	mutex_unlock(&monc->req_mutex);
+	return ret;
+}
+
+
+/*
+ * osd map
+ */
+static void request_osdmap(struct ceph_mon_client *monc, int newmon)
+{
+	struct ceph_msg *msg;
+	struct ceph_osd_getmap *h;
+	int mon = pick_mon(monc, newmon);
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
+}
+
+void ceph_monc_request_osdmap(struct ceph_mon_client *monc, u32 want)
+{
+	dout(5, "request_osdmap want %u\n", want);
+	mutex_lock(&monc->req_mutex);
+	monc->osdreq.delay = BASE_DELAY_INTERVAL;
+	monc->want_osdmap = want;
+	request_osdmap(monc, 0);
+	reschedule_timeout(&monc->osdreq);
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
+		cancel_timeout(&monc->osdreq);
+	}
+	mutex_unlock(&monc->req_mutex);
+	return ret;
+}
+
+
+/*
+ * umount
+ */
+static void request_umount(struct ceph_mon_client *monc, int newmon)
+{
+	struct ceph_msg *msg;
+	int mon = pick_mon(monc, newmon);
+
+	dout(5, "request_umount from mon%d\n", mon);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_UNMOUNT, 0, 0, 0, NULL);
+	if (IS_ERR(msg))
+		return;
+	msg->hdr.dst = monc->monmap->mon_inst[mon];
+	ceph_msg_send(monc->client->msgr, msg, 0);
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
+	monc->umountreq.delay = BASE_DELAY_INTERVAL;
+	request_umount(monc, 0);
+	reschedule_timeout(&monc->umountreq);
+	mutex_unlock(&monc->req_mutex);
+}
+
+void ceph_monc_handle_umount(struct ceph_mon_client *monc,
+			     struct ceph_msg *msg)
+{
+	dout(5, "handle_umount\n");
+	mutex_lock(&monc->req_mutex);
+	cancel_timeout(&monc->umountreq);
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
+	mutex_lock(&monc->statfs_mutex);
+	req = radix_tree_lookup(&monc->statfs_request_tree, tid);
+	if (req) {
+		*req->buf = reply->st;
+		req->result = 0;
+	}
+	mutex_unlock(&monc->statfs_mutex);
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
+static int send_statfs(struct ceph_mon_client *monc,
+		       struct ceph_mon_statfs_request *req,
+		       int newmon)
+{
+	struct ceph_msg *msg;
+	struct ceph_mon_statfs *h;
+	int mon = pick_mon(monc, newmon ? 1 : -1);
+
+	dout(10, "send_statfs to mon%d tid %llu\n", mon, req->tid);
+	msg = ceph_msg_new(CEPH_MSG_STATFS, sizeof(*h), 0, 0, NULL);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+	req->request = msg;
+	h = msg->front.iov_base;
+	h->fsid = monc->monmap->fsid;
+	h->tid = cpu_to_le64(req->tid);
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
+	mutex_lock(&monc->statfs_mutex);
+	req.tid = ++monc->last_tid;
+	req.last_attempt = jiffies;
+	req.delay = BASE_DELAY_INTERVAL;
+	memset(&req.kobj, 0, sizeof(req.kobj));
+	if (radix_tree_insert(&monc->statfs_request_tree, req.tid, &req) < 0) {
+		mutex_unlock(&monc->statfs_mutex);
+		derr(10, "ENOMEM in do_statfs\n");
+		return -ENOMEM;
+	}
+	if (monc->num_statfs_requests == 0)
+		schedule_delayed_work(&monc->statfs_delayed_work,
+				      round_jiffies_relative(1*HZ));
+	monc->num_statfs_requests++;
+	mutex_unlock(&monc->statfs_mutex);
+
+	/* send request and wait */
+	err = send_statfs(monc, &req, 0);
+	if (!err)
+		err = wait_for_completion_interruptible(&req.completion);
+
+	mutex_lock(&monc->statfs_mutex);
+	radix_tree_delete(&monc->statfs_request_tree, req.tid);
+	monc->num_statfs_requests--;
+	if (monc->num_statfs_requests == 0)
+		cancel_delayed_work(&monc->statfs_delayed_work);
+	mutex_unlock(&monc->statfs_mutex);
+
+	if (!err)
+		err = req.result;
+	return err;
+}
+
+/*
+ * Resend any statfs requests that have timed out.
+ */
+static void do_statfs_check(struct work_struct *work)
+{
+	struct ceph_mon_client *monc =
+		container_of(work, struct ceph_mon_client,
+			     statfs_delayed_work.work);
+	u64 next_tid = 0;
+	int got;
+	int did = 0;
+	int newmon = 1;
+	struct ceph_mon_statfs_request *req;
+
+	dout(10, "do_statfs_check\n");
+	mutex_lock(&monc->statfs_mutex);
+	while (1) {
+		got = radix_tree_gang_lookup(&monc->statfs_request_tree,
+					     (void **)&req,
+					     next_tid, 1);
+		if (got == 0)
+			break;
+		did++;
+		next_tid = req->tid + 1;
+		if (time_after(jiffies, req->last_attempt + req->delay)) {
+			req->last_attempt = jiffies;
+			if (req->delay < MAX_DELAY_INTERVAL)
+				req->delay *= 2;
+			send_statfs(monc, req, newmon);
+			newmon = 0;
+		}
+	}
+	mutex_unlock(&monc->statfs_mutex);
+
+	if (did)
+		schedule_delayed_work(&monc->statfs_delayed_work,
+				      round_jiffies_relative(1*HZ));
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
+	mutex_init(&monc->statfs_mutex);
+	INIT_RADIX_TREE(&monc->statfs_request_tree, GFP_NOFS);
+	monc->num_statfs_requests = 0;
+	monc->last_tid = 0;
+	INIT_DELAYED_WORK(&monc->statfs_delayed_work, do_statfs_check);
+	init_request_type(monc, &monc->mdsreq, request_mdsmap);
+	init_request_type(monc, &monc->osdreq, request_osdmap);
+	init_request_type(monc, &monc->umountreq, request_umount);
+	mutex_init(&monc->req_mutex);
+	monc->want_mdsmap = 0;
+	monc->want_osdmap = 0;
+	return 0;
+}
+
+void ceph_monc_stop(struct ceph_mon_client *monc)
+{
+	dout(5, "stop\n");
+	cancel_timeout(&monc->mdsreq);
+	cancel_timeout(&monc->osdreq);
+	cancel_timeout(&monc->umountreq);
+	cancel_delayed_work_sync(&monc->statfs_delayed_work);
+	kfree(monc->monmap);
+}
diff --git a/fs/staging/ceph/mon_client.h b/fs/staging/ceph/mon_client.h
new file mode 100644
index 0000000..77f44b8
--- /dev/null
+++ b/fs/staging/ceph/mon_client.h
@@ -0,0 +1,135 @@
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
+ * same monitor.  If there is a problem, we randomly pick a new monitor from
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
+	ceph_fsid_t fsid;
+	u32 epoch;
+	u32 num_mon;
+	struct ceph_entity_inst mon_inst[0];
+};
+
+struct ceph_mon_client;
+struct ceph_mon_statfs_request;
+
+struct ceph_mon_client_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct ceph_mon_client *, struct ceph_mon_client_attr *,
+			char *);
+	ssize_t (*store)(struct ceph_mon_client *,
+			 struct ceph_mon_client_attr *,
+			 const char *, size_t);
+};
+
+struct ceph_mon_statfs_request_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct ceph_mon_statfs_request *,
+			struct ceph_mon_statfs_request_attr *,
+			char *);
+	ssize_t (*store)(struct ceph_mon_statfs_request *,
+			 struct ceph_mon_statfs_request_attr *,
+			const char *, size_t);
+	struct ceph_entity_inst dst;
+};
+
+/*
+ * Generic mechanism for resending monitor requests.
+ */
+typedef void (*ceph_monc_request_func_t)(struct ceph_mon_client *monc,
+					 int newmon);
+struct ceph_mon_request {
+	struct ceph_mon_client *monc;
+	struct delayed_work delayed_work;
+	unsigned long delay;
+	ceph_monc_request_func_t do_request;
+};
+
+/* statfs() is done a bit differently */
+struct ceph_mon_statfs_request {
+	u64 tid;
+	struct kobject kobj;
+	struct ceph_mon_statfs_request_attr k_op, k_mon;
+	int result;
+	struct ceph_statfs *buf;
+	struct completion completion;
+	unsigned long last_attempt, delay; /* jiffies */
+	struct ceph_msg  *request;  /* original request */
+};
+
+struct ceph_mon_client {
+	struct ceph_client *client;
+	int last_mon;                       /* last monitor i contacted */
+	struct ceph_monmap *monmap;
+
+	/* pending statfs requests */
+	struct mutex statfs_mutex;
+	struct radix_tree_root statfs_request_tree;
+	int num_statfs_requests;
+	u64 last_tid;
+	struct delayed_work statfs_delayed_work;
+
+	/* mds/osd map or umount requests */
+	struct mutex req_mutex;
+	struct ceph_mon_request mdsreq, osdreq, umountreq;
+	u32 want_mdsmap;
+	u32 want_osdmap;
+
+	struct dentry *debugfs_file;
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

