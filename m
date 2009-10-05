Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZJEWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZJEWyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZJEWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:53:35 -0400
Received: from cobra.newdream.net ([66.33.216.30]:49339 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZJEWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:53:33 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 20/21] ceph: debugfs
Date: Mon,  5 Oct 2009 15:50:50 -0700
Message-Id: <1254783051-26217-21-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1254783051-26217-20-git-send-email-sage@newdream.net>
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
 <1254783051-26217-12-git-send-email-sage@newdream.net>
 <1254783051-26217-13-git-send-email-sage@newdream.net>
 <1254783051-26217-14-git-send-email-sage@newdream.net>
 <1254783051-26217-15-git-send-email-sage@newdream.net>
 <1254783051-26217-16-git-send-email-sage@newdream.net>
 <1254783051-26217-17-git-send-email-sage@newdream.net>
 <1254783051-26217-18-git-send-email-sage@newdream.net>
 <1254783051-26217-19-git-send-email-sage@newdream.net>
 <1254783051-26217-20-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic state information is available via /sys/kernel/debug/ceph,
including instances of the client, fsids, current monitor, mds and osd
maps, outstanding server requests, and hooks to adjust debug levels.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/debugfs.c |  425 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 425 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/debugfs.c

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
new file mode 100644
index 0000000..9edbad3
--- /dev/null
+++ b/fs/ceph/debugfs.c
@@ -0,0 +1,425 @@
+#include "ceph_debug.h"
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "super.h"
+#include "mds_client.h"
+
+/*
+ * Implement /sys/kernel/debug/ceph fun
+ *
+ * /sys/kernel/debug/ceph/client*  - an instance of the ceph client
+ *      .../osdmap      - current osdmap
+ *      .../mdsmap      - current mdsmap
+ *      .../monmap      - current monmap
+ *      .../osdc        - active osd requests
+ *      .../mdsc        - active mds requests
+ *      .../monc        - mon client state
+ *      .../dentry_lru  - dump contents of dentry lru
+ *      .../caps        - expose cap (reservation) stats
+ */
+
+static struct dentry *ceph_debugfs_dir;
+
+static int monmap_show(struct seq_file *s, void *p)
+{
+	int i;
+	struct ceph_client *client = s->private;
+
+	if (client->monc.monmap == NULL)
+		return 0;
+
+	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
+	for (i = 0; i < client->monc.monmap->num_mon; i++) {
+		struct ceph_entity_inst *inst =
+			&client->monc.monmap->mon_inst[i];
+
+		seq_printf(s, "\t%s%lld\t%s\n",
+			   ENTITY_NAME(inst->name),
+			   pr_addr(&inst->addr.in_addr));
+	}
+	return 0;
+}
+
+static int mdsmap_show(struct seq_file *s, void *p)
+{
+	int i;
+	struct ceph_client *client = s->private;
+
+	if (client->mdsc.mdsmap == NULL)
+		return 0;
+	seq_printf(s, "epoch %d\n", client->mdsc.mdsmap->m_epoch);
+	seq_printf(s, "root %d\n", client->mdsc.mdsmap->m_root);
+	seq_printf(s, "session_timeout %d\n",
+		       client->mdsc.mdsmap->m_session_timeout);
+	seq_printf(s, "session_autoclose %d\n",
+		       client->mdsc.mdsmap->m_session_autoclose);
+	for (i = 0; i < client->mdsc.mdsmap->m_max_mds; i++) {
+		struct ceph_entity_addr *addr =
+			&client->mdsc.mdsmap->m_info[i].addr;
+		int state = client->mdsc.mdsmap->m_info[i].state;
+
+		seq_printf(s, "\tmds%d\t%s\t(%s)\n", i, pr_addr(&addr->in_addr),
+			       ceph_mds_state_name(state));
+	}
+	return 0;
+}
+
+static int osdmap_show(struct seq_file *s, void *p)
+{
+	int i;
+	struct ceph_client *client = s->private;
+
+	if (client->osdc.osdmap == NULL)
+		return 0;
+	seq_printf(s, "epoch %d\n", client->osdc.osdmap->epoch);
+	seq_printf(s, "flags%s%s\n",
+		   (client->osdc.osdmap->flags & CEPH_OSDMAP_NEARFULL) ?
+		   " NEARFULL" : "",
+		   (client->osdc.osdmap->flags & CEPH_OSDMAP_FULL) ?
+		   " FULL" : "");
+	for (i = 0; i < client->osdc.osdmap->num_pools; i++) {
+		struct ceph_pg_pool_info *pool =
+			&client->osdc.osdmap->pg_pool[i];
+		seq_printf(s, "pg_pool %d pg_num %d / %d, lpg_num %d / %d\n",
+			   i, pool->v.pg_num, pool->pg_num_mask,
+			   pool->v.lpg_num, pool->lpg_num_mask);
+	}
+	for (i = 0; i < client->osdc.osdmap->max_osd; i++) {
+		struct ceph_entity_addr *addr =
+			&client->osdc.osdmap->osd_addr[i];
+		int state = client->osdc.osdmap->osd_state[i];
+		char sb[64];
+
+		seq_printf(s, "\tosd%d\t%s\t%3d%%\t(%s)\n",
+			   i, pr_addr(&addr->in_addr),
+			   ((client->osdc.osdmap->osd_weight[i]*100) >> 16),
+			   ceph_osdmap_state_str(sb, sizeof(sb), state));
+	}
+	return 0;
+}
+
+static int monc_show(struct seq_file *s, void *p)
+{
+	struct ceph_client *client = s->private;
+	struct ceph_mon_statfs_request *req;
+	u64 nexttid = 0;
+	int got;
+	struct ceph_mon_client *monc = &client->monc;
+
+	mutex_lock(&monc->mutex);
+
+	if (monc->have_mdsmap)
+		seq_printf(s, "have mdsmap %u\n", (unsigned)monc->have_mdsmap);
+	if (monc->have_osdmap)
+		seq_printf(s, "have osdmap %u\n", (unsigned)monc->have_osdmap);
+	if (monc->want_next_osdmap)
+		seq_printf(s, "want next osdmap\n");
+
+	while (nexttid < monc->last_tid) {
+		got = radix_tree_gang_lookup(&monc->statfs_request_tree,
+					     (void **)&req, nexttid, 1);
+		if (got == 0)
+			break;
+		nexttid = req->tid + 1;
+
+		seq_printf(s, "%lld statfs\n", req->tid);
+	}
+	mutex_unlock(&monc->mutex);
+
+	return 0;
+}
+
+static int mdsc_show(struct seq_file *s, void *p)
+{
+	struct ceph_client *client = s->private;
+	struct ceph_mds_request *req;
+	u64 nexttid = 0;
+	int got;
+	struct ceph_mds_client *mdsc = &client->mdsc;
+	int pathlen;
+	u64 pathbase;
+	char *path;
+
+	mutex_lock(&mdsc->mutex);
+	while (nexttid < mdsc->last_tid) {
+		got = radix_tree_gang_lookup(&mdsc->request_tree,
+					     (void **)&req, nexttid, 1);
+		if (got == 0)
+			break;
+		nexttid = req->r_tid + 1;
+
+		if (req->r_request)
+			seq_printf(s, "%lld\tmds%d\t", req->r_tid, req->r_mds);
+		else
+			seq_printf(s, "%lld\t(no request)\t", req->r_tid);
+
+		seq_printf(s, "%s", ceph_mds_op_name(req->r_op));
+
+		if (req->r_got_unsafe)
+			seq_printf(s, "\t(unsafe)");
+		else
+			seq_printf(s, "\t");
+
+		if (req->r_inode) {
+			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
+		} else if (req->r_dentry) {
+			path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
+						    &pathbase, 0);
+			spin_lock(&req->r_dentry->d_lock);
+			seq_printf(s, " #%llx/%.*s (%s)",
+				   ceph_ino(req->r_dentry->d_parent->d_inode),
+				   req->r_dentry->d_name.len,
+				   req->r_dentry->d_name.name,
+				   path ? path : "");
+			spin_unlock(&req->r_dentry->d_lock);
+			kfree(path);
+		} else if (req->r_path1) {
+			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
+				   req->r_path1);
+		}
+
+		if (req->r_old_dentry) {
+			path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
+						    &pathbase, 0);
+			spin_lock(&req->r_old_dentry->d_lock);
+			seq_printf(s, " #%llx/%.*s (%s)",
+			   ceph_ino(req->r_old_dentry->d_parent->d_inode),
+				   req->r_old_dentry->d_name.len,
+				   req->r_old_dentry->d_name.name,
+				   path ? path : "");
+			spin_unlock(&req->r_old_dentry->d_lock);
+			kfree(path);
+		} else if (req->r_path2) {
+			if (req->r_ino2.ino)
+				seq_printf(s, " #%llx/%s", req->r_ino2.ino,
+					   req->r_path2);
+			else
+				seq_printf(s, " %s", req->r_path2);
+		}
+
+		seq_printf(s, "\n");
+	}
+	mutex_unlock(&mdsc->mutex);
+
+	return 0;
+}
+
+static int osdc_show(struct seq_file *s, void *pp)
+{
+	struct ceph_client *client = s->private;
+	struct ceph_osd_client *osdc = &client->osdc;
+	struct rb_node *p;
+
+	mutex_lock(&osdc->request_mutex);
+	for (p = rb_first(&osdc->requests); p; p = rb_next(p)) {
+		struct ceph_osd_request *req;
+		struct ceph_osd_request_head *head;
+		struct ceph_osd_op *op;
+		int num_ops;
+		int opcode, olen;
+		int i;
+
+		req = rb_entry(p, struct ceph_osd_request, r_node);
+
+		seq_printf(s, "%lld\tosd%d\t", req->r_tid,
+			   req->r_osd ? req->r_osd->o_osd : -1);
+
+		head = req->r_request->front.iov_base;
+		op = (void *)(head + 1);
+
+		num_ops = le16_to_cpu(head->num_ops);
+		olen = le32_to_cpu(head->object_len);
+		seq_printf(s, "%.*s", olen,
+			   (const char *)(head->ops + num_ops));
+
+		if (req->r_reassert_version.epoch)
+			seq_printf(s, "\t%u'%llu",
+			   (unsigned)le32_to_cpu(req->r_reassert_version.epoch),
+			   le64_to_cpu(req->r_reassert_version.version));
+		else
+			seq_printf(s, "\t");
+
+		for (i = 0; i < num_ops; i++) {
+			opcode = le16_to_cpu(op->op);
+			seq_printf(s, "\t%s", ceph_osd_op_name(opcode));
+			op++;
+		}
+
+		seq_printf(s, "\n");
+	}
+	mutex_unlock(&osdc->request_mutex);
+	return 0;
+}
+
+static int caps_show(struct seq_file *s, void *p)
+{
+	struct ceph_client *client = p;
+	int total, avail, used, reserved;
+
+	ceph_reservation_status(client, &total, &avail, &used, &reserved);
+	seq_printf(s, "total\t\t%d\n"
+		      "avail\t\t%d\n"
+		      "used\t\t%d\n"
+		      "reserved\t%d\n",
+		   total, avail, used, reserved);
+	return 0;
+}
+
+static int dentry_lru_show(struct seq_file *s, void *ptr)
+{
+	struct ceph_client *client = s->private;
+	struct ceph_mds_client *mdsc = &client->mdsc;
+	struct ceph_dentry_info *di;
+
+	spin_lock(&mdsc->dentry_lru_lock);
+	list_for_each_entry(di, &mdsc->dentry_lru, lru) {
+		struct dentry *dentry = di->dentry;
+		seq_printf(s, "%p %p\t%.*s\n",
+			   di, dentry, dentry->d_name.len, dentry->d_name.name);
+	}
+	spin_unlock(&mdsc->dentry_lru_lock);
+
+	return 0;
+}
+
+#define DEFINE_SHOW_FUNC(name) 						\
+static int name##_open(struct inode *inode, struct file *file)		\
+{									\
+	struct seq_file *sf;						\
+	int ret;							\
+									\
+	ret = single_open(file, name, NULL);				\
+	sf = file->private_data;					\
+	sf->private = inode->i_private;					\
+	return ret;							\
+}									\
+									\
+static const struct file_operations name##_fops = {			\
+	.open		= name##_open,					\
+	.read		= seq_read,					\
+	.llseek		= seq_lseek,					\
+	.release	= single_release,				\
+};
+
+DEFINE_SHOW_FUNC(monmap_show)
+DEFINE_SHOW_FUNC(mdsmap_show)
+DEFINE_SHOW_FUNC(osdmap_show)
+DEFINE_SHOW_FUNC(monc_show)
+DEFINE_SHOW_FUNC(mdsc_show)
+DEFINE_SHOW_FUNC(osdc_show)
+DEFINE_SHOW_FUNC(dentry_lru_show)
+DEFINE_SHOW_FUNC(caps_show)
+
+int __init ceph_debugfs_init(void)
+{
+	ceph_debugfs_dir = debugfs_create_dir("ceph", NULL);
+	if (!ceph_debugfs_dir)
+		return -ENOMEM;
+	return 0;
+}
+
+void ceph_debugfs_cleanup(void)
+{
+	debugfs_remove(ceph_debugfs_dir);
+}
+
+int ceph_debugfs_client_init(struct ceph_client *client)
+{
+	int ret = 0;
+	char name[80];
+
+	snprintf(name, sizeof(name), FSID_FORMAT ".client%lld",
+		 PR_FSID(&client->monc.monmap->fsid), client->whoami);
+
+	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
+	if (!client->debugfs_dir)
+		goto out;
+
+	client->monc.debugfs_file = debugfs_create_file("monc",
+						      0600,
+						      client->debugfs_dir,
+						      client,
+						      &monc_show_fops);
+	if (!client->monc.debugfs_file)
+		goto out;
+
+	client->mdsc.debugfs_file = debugfs_create_file("mdsc",
+						      0600,
+						      client->debugfs_dir,
+						      client,
+						      &mdsc_show_fops);
+	if (!client->mdsc.debugfs_file)
+		goto out;
+
+	client->osdc.debugfs_file = debugfs_create_file("osdc",
+						      0600,
+						      client->debugfs_dir,
+						      client,
+						      &osdc_show_fops);
+	if (!client->osdc.debugfs_file)
+		goto out;
+
+	client->debugfs_monmap = debugfs_create_file("monmap",
+					0600,
+					client->debugfs_dir,
+					client,
+					&monmap_show_fops);
+	if (!client->debugfs_monmap)
+		goto out;
+
+	client->debugfs_mdsmap = debugfs_create_file("mdsmap",
+					0600,
+					client->debugfs_dir,
+					client,
+					&mdsmap_show_fops);
+	if (!client->debugfs_mdsmap)
+		goto out;
+
+	client->debugfs_osdmap = debugfs_create_file("osdmap",
+					0600,
+					client->debugfs_dir,
+					client,
+					&osdmap_show_fops);
+	if (!client->debugfs_osdmap)
+		goto out;
+
+	client->debugfs_dentry_lru = debugfs_create_file("dentry_lru",
+					0600,
+					client->debugfs_dir,
+					client,
+					&dentry_lru_show_fops);
+	if (!client->debugfs_dentry_lru)
+		goto out;
+
+	client->debugfs_caps = debugfs_create_file("caps",
+						   0400,
+						   client->debugfs_dir,
+						   client,
+						   &caps_show_fops);
+	if (!client->debugfs_caps)
+		goto out;
+
+	return 0;
+
+out:
+	ceph_debugfs_client_cleanup(client);
+	return ret;
+}
+
+void ceph_debugfs_client_cleanup(struct ceph_client *client)
+{
+	debugfs_remove(client->debugfs_caps);
+	debugfs_remove(client->debugfs_dentry_lru);
+	debugfs_remove(client->debugfs_osdmap);
+	debugfs_remove(client->debugfs_mdsmap);
+	debugfs_remove(client->debugfs_monmap);
+	debugfs_remove(client->osdc.debugfs_file);
+	debugfs_remove(client->mdsc.debugfs_file);
+	debugfs_remove(client->monc.debugfs_file);
+	debugfs_remove(client->debugfs_dir);
+}
+
-- 
1.5.6.5

