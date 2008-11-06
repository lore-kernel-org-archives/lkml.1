Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYKFLFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYKFLFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYKFLFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:05:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38856 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYKFLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:05:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<m163n12ko9.fsf_-_@frodo.ebiederm.org>
	<m1y6zx15yj.fsf_-_@frodo.ebiederm.org>
Date: Thu, 06 Nov 2008 02:56:09 -0800
In-Reply-To: <m1y6zx15yj.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 06 Nov 2008 02:53:08 -0800")
Message-ID: <m1skq515ti.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 5/7] proc_net: Don't show the wrong /proc/net after unshare.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is accomplished by dropping the /proc/<pid>/net
dentry when we discover an older version of /proc/net
is mounted upon it.  This prevents new lookups from
using the mount and ultimately proc_shrink_automounts
will catch up with it and remove the old mount point.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c     |   11 +++++++----
 fs/proc/internal.h |   11 +++++++++++
 fs/proc/proc_net.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9a68fa4..8b0d066 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1487,6 +1487,7 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
+	int ret = 0;
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
 		    task_dumpable(task)) {
@@ -1497,12 +1498,14 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 			inode->i_gid = 0;
 		}
 		inode->i_mode &= ~(S_ISUID | S_ISGID);
-		security_task_to_inode(task, inode);
+		ret = proc_net_revalidate(task, dentry, nd);
+		if (ret == 1)
+			security_task_to_inode(task, inode);
 		put_task_struct(task);
-		return 1;
 	}
-	d_drop(dentry);
-	return 0;
+	if (ret == 0)
+		d_drop(dentry);
+	return ret;
 }
 
 static int pid_delete_dentry(struct dentry * dentry)
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ffa285e..f9f8de6 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -64,6 +64,17 @@ extern const struct file_operations proc_kmsg_operations;
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
+#ifdef CONFIG_NET
+extern int proc_net_revalidate(struct task_struct *task, struct dentry *dentry,
+				struct nameidata *nd);
+#else
+static inline int proc_net_revalidate(struct task_struct *t, struct dentry *d,
+					struct nameidata *nd)
+{
+	return 1;
+}
+#endif
+
 void free_proc_entry(struct proc_dir_entry *de);
 
 void proc_init_inodecache(void);
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 57e0f22..4a7551a 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -174,6 +174,39 @@ const struct inode_operations proc_net_inode_operations = {
 	.follow_link	= proc_net_follow_link,
 };
 
+int proc_net_revalidate(struct task_struct *task, struct dentry *dentry,
+			struct nameidata *nd)
+{
+	struct inode *inode = dentry->d_inode;
+	struct dentry *tdentry;
+	struct vfsmount *tmnt;
+	int ret = 1;
+
+	/* Are we talking about a proc/net mount point? */
+	if (!nd || (inode->i_op != &proc_net_inode_operations))
+		goto out;
+
+	/* If the wrong filesystem is mounted on
+	 * /proc/<pid>/net report the dentry is invalid.
+	 */
+	tdentry = dget(dentry);
+	tmnt = mntget(nd->path.mnt);
+	if (follow_down(&tmnt, &tdentry)) {
+		struct nsproxy *ns;
+		rcu_read_lock();
+		ns = task_nsproxy(task);
+		if ((ns == NULL) ||
+		     (tmnt->mnt_sb->s_magic != PROC_NET_SUPER_MAGIC) ||
+		     (tmnt->mnt_sb->s_fs_info != ns->net_ns))
+			ret = 0;
+		rcu_read_unlock();
+	}
+	mntput(tmnt);
+	dput(tdentry);
+out:
+	return ret;
+}
+
 struct proc_dir_entry *proc_net_fops_create(struct net *net,
 	const char *name, mode_t mode, const struct file_operations *fops)
 {
-- 
1.5.3.rc6.17.g1911

