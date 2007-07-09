Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXGIQat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXGIQat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXGIQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbXGIQXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:50 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] dumping master locks
Date: Mon,  9 Jul 2007 17:02:28 +0100
Message-Id: <1183997034982-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970324005-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Add a new debugfs file that dumps a compact list of mastered locks.
This will be used by a userland daemon to collect state for deadlock
detection.

Also, for the existing function that prints all lock state, lock the rsb
before going through the lock lists since they can be changing in the
course of normal dlm activity.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 9e27a16..184be98 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -27,6 +27,8 @@ static struct dentry *dlm_root;
 
 struct rsb_iter {
 	int entry;
+	int master;
+	int header;
 	struct dlm_ls *ls;
 	struct list_head *next;
 	struct dlm_rsb *rsb;
@@ -86,6 +88,8 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 	struct dlm_lkb *lkb;
 	int i, lvblen = res->res_ls->ls_lvblen, recover_list, root_list;
 
+	lock_rsb(res);
+
 	seq_printf(s, "\nResource %p Name (len=%d) \"", res, res->res_length);
 	for (i = 0; i < res->res_length; i++) {
 		if (isprint(res->res_name[i]))
@@ -152,6 +156,59 @@ static int print_resource(struct dlm_rsb *res, struct seq_file *s)
 		seq_printf(s, "\n");
 	}
  out:
+	unlock_rsb(res);
+	return 0;
+}
+
+static void print_master_lock(struct seq_file *s, struct dlm_lkb *lkb,
+			      struct dlm_rsb *r)
+{
+	struct dlm_user_args *ua;
+	unsigned int waiting = 0;
+	uint64_t xid = 0;
+
+	if (lkb->lkb_flags & DLM_IFL_USER) {
+		ua = (struct dlm_user_args *) lkb->lkb_astparam;
+		if (ua)
+			xid = ua->xid;
+	}
+
+	if (lkb->lkb_timestamp)
+		waiting = jiffies_to_msecs(jiffies - lkb->lkb_timestamp);
+
+	/* id nodeid remid pid xid flags sts grmode rqmode time_ms len name */
+
+	seq_printf(s, "%x %d %x %u %llu %x %d %d %d %u %d \"%s\"\n",
+		   lkb->lkb_id,
+		   lkb->lkb_nodeid,
+		   lkb->lkb_remid,
+		   lkb->lkb_ownpid,
+		   (unsigned long long)xid,
+		   lkb->lkb_exflags,
+		   lkb->lkb_status,
+		   lkb->lkb_grmode,
+		   lkb->lkb_rqmode,
+		   waiting,
+		   r->res_length,
+		   r->res_name);
+}
+
+static int print_master_resource(struct dlm_rsb *r, struct seq_file *s)
+{
+	struct dlm_lkb *lkb;
+
+	lock_rsb(r);
+
+	list_for_each_entry(lkb, &r->res_grantqueue, lkb_statequeue)
+		print_master_lock(s, lkb, r);
+
+	list_for_each_entry(lkb, &r->res_convertqueue, lkb_statequeue)
+		print_master_lock(s, lkb, r);
+
+	list_for_each_entry(lkb, &r->res_waitqueue, lkb_statequeue)
+		print_master_lock(s, lkb, r);
+
+	unlock_rsb(r);
 	return 0;
 }
 
@@ -209,7 +266,7 @@ static struct rsb_iter *rsb_iter_init(struct dlm_ls *ls)
 {
 	struct rsb_iter *ri;
 
-	ri = kmalloc(sizeof *ri, GFP_KERNEL);
+	ri = kzalloc(sizeof *ri, GFP_KERNEL);
 	if (!ri)
 		return NULL;
 
@@ -267,7 +324,17 @@ static int rsb_seq_show(struct seq_file *file, void *iter_ptr)
 {
 	struct rsb_iter *ri = iter_ptr;
 
-	print_resource(ri->rsb, file);
+	if (ri->master) {
+		if (ri->header) {
+			seq_printf(file, "id nodeid remid pid xid flags sts "
+					 "grmode rqmode time_ms len name\n");
+			ri->header = 0;
+		}
+		if (is_master(ri->rsb))
+			print_master_resource(ri->rsb, file);
+	} else {
+		print_resource(ri->rsb, file);
+	}
 
 	return 0;
 }
@@ -303,6 +370,83 @@ static const struct file_operations rsb_fops = {
 };
 
 /*
+ * Dump master lock state
+ */
+
+static struct rsb_iter *master_iter_init(struct dlm_ls *ls, loff_t *pos)
+{
+	struct rsb_iter *ri;
+
+	ri = kzalloc(sizeof *ri, GFP_KERNEL);
+	if (!ri)
+		return NULL;
+
+	ri->ls = ls;
+	ri->entry = 0;
+	ri->next = NULL;
+	ri->master = 1;
+
+	if (*pos == 0)
+		ri->header = 1;
+
+	if (rsb_iter_next(ri)) {
+		rsb_iter_free(ri);
+		return NULL;
+	}
+
+	return ri;
+}
+
+static void *master_seq_start(struct seq_file *file, loff_t *pos)
+{
+	struct rsb_iter *ri;
+	loff_t n = *pos;
+
+	ri = master_iter_init(file->private, pos);
+	if (!ri)
+		return NULL;
+
+	while (n--) {
+		if (rsb_iter_next(ri)) {
+			rsb_iter_free(ri);
+			return NULL;
+		}
+	}
+
+	return ri;
+}
+
+static struct seq_operations master_seq_ops = {
+	.start = master_seq_start,
+	.next  = rsb_seq_next,
+	.stop  = rsb_seq_stop,
+	.show  = rsb_seq_show,
+};
+
+static int master_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq;
+	int ret;
+
+	ret = seq_open(file, &master_seq_ops);
+	if (ret)
+		return ret;
+
+	seq = file->private_data;
+	seq->private = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations master_fops = {
+	.owner   = THIS_MODULE,
+	.open    = master_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release
+};
+
+/*
  * dump lkb's on the ls_waiters list
  */
 
@@ -369,6 +513,20 @@ int dlm_create_debug_file(struct dlm_ls *ls)
 		return -ENOMEM;
 	}
 
+	memset(name, 0, sizeof(name));
+	snprintf(name, DLM_LOCKSPACE_LEN+8, "%s_master", ls->ls_name);
+
+	ls->ls_debug_master_dentry = debugfs_create_file(name,
+							 S_IFREG | S_IRUGO,
+							 dlm_root,
+							 ls,
+							 &master_fops);
+	if (!ls->ls_debug_master_dentry) {
+		debugfs_remove(ls->ls_debug_waiters_dentry);
+		debugfs_remove(ls->ls_debug_rsb_dentry);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -378,6 +536,8 @@ void dlm_delete_debug_file(struct dlm_ls *ls)
 		debugfs_remove(ls->ls_debug_rsb_dentry);
 	if (ls->ls_debug_waiters_dentry)
 		debugfs_remove(ls->ls_debug_waiters_dentry);
+	if (ls->ls_debug_master_dentry)
+		debugfs_remove(ls->ls_debug_master_dentry);
 }
 
 int dlm_register_debugfs(void)
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index a006fa5..f2c8549 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -470,6 +470,7 @@ struct dlm_ls {
 
 	struct dentry		*ls_debug_rsb_dentry; /* debugfs */
 	struct dentry		*ls_debug_waiters_dentry; /* debugfs */
+	struct dentry		*ls_debug_master_dentry; /* debugfs */
 
 	wait_queue_head_t	ls_uevent_wait;	/* user part of join/leave */
 	int			ls_uevent_result;
-- 
1.5.1.2

