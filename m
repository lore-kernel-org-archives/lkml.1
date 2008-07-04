Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYGDBMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYGDBMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYGDBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:11:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38463 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYGDBLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:11:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, <netdev@vger.kernel.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com> <m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com> <m14p77m9uy.fsf@frodo.ebiederm.org>
	<486CF71F.5090405@gmail.com> <m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>
Date: Thu, 03 Jul 2008 18:07:04 -0700
In-Reply-To: <m1tzf6ihlz.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 03 Jul 2008 18:05:28 -0700")
Message-ID: <m1prpuihjb.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 02/15] sysfs: Support for preventing unmounts.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To support mounting multiple instances of sysfs occassionally I
need to walk through all of the currently present sysfs super blocks.

To allow this iteration this patch adds sysfs_grab_supers
and sysfs_release_supers.  While a piece of code is in
a section surrounded by these no more sysfs super blocks
will be either created or destroyed.

So the fundamentals.
- The data in sysfs fundamentally changes behind the back of the
  VFS and we need to keep the VFS in sync.  Essentially this is the
  distributed filesystem problem.

- In particular for sysfs_rename and sysfs_move_dir we need to support finding
  the dcache entries and calling d_move.  So that the dcache does not
  get into an inconsistent state.  Timeouts and invalidates like NFS
  uses are to be  avoided if at all possible.

- Coming through the vfs we are guaranteed that the filesystem will
  not be unmounted while we have a reference on a dentry, and with
  multiple mounts we do not get that guarantee.  Therefore to get that
  guarantee for all of the superblocks we need the blunt instrument.

- Since mount/unmount are rare blocking them is no big deal.

I believe any distributed filesystem that is together enough to tell
us about renames (so we can update the dcache) instead of doing the
NFS timeout will need the ability to block mount/unmount while it is
executing d_move.

Currently sysfs does not need to block mounts only because we perform
an internal mount and then never unmount sysfs.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
Signed-off-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/mount.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/sysfs/sysfs.h |   10 +++++++
 2 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 9f328d2..c812cc4 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -41,47 +41,110 @@ struct sysfs_dirent sysfs_root = {
 
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct inode *inode;
-	struct dentry *root;
+	struct sysfs_super_info *info = NULL;
+	struct inode *inode = NULL;
+	struct dentry *root = NULL;
+	int error;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = SYSFS_MAGIC;
 	sb->s_op = &sysfs_ops;
 	sb->s_time_gran = 1;
-	sysfs_sb = sb;
+	if (!sysfs_sb)
+		sysfs_sb = sb;
+
+	error = -ENOMEM;
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		goto out_err;
 
 	/* get root inode, initialize and unlock it */
+	error = -ENOMEM;
 	inode = sysfs_get_inode(&sysfs_root);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
-		return -ENOMEM;
+		goto out_err;
 	}
 
 	/* instantiate and link root dentry */
+	error = -ENOMEM;
 	root = d_alloc_root(inode);
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
-		iput(inode);
-		return -ENOMEM;
+		goto out_err;
 	}
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
+	sb->s_fs_info = info;
 	return 0;
+
+out_err:
+	dput(root);
+	iput(inode);
+	kfree(info);
+	if (sysfs_sb == sb)
+		sysfs_sb = NULL;
+	return error;
 }
 
 static int sysfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_single(fs_type, flags, data, sysfs_fill_super, mnt);
+	int rc;
+	mutex_lock(&sysfs_rename_mutex);
+	rc = get_sb_single(fs_type, flags, data, sysfs_fill_super, mnt);
+	mutex_unlock(&sysfs_rename_mutex);
+	return rc;
 }
 
-static struct file_system_type sysfs_fs_type = {
+struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.get_sb		= sysfs_get_sb,
 	.kill_sb	= kill_anon_super,
 };
 
+void sysfs_grab_supers(void)
+{
+	/* must hold sysfs_rename_mutex */
+	struct super_block *sb;
+	/* Loop until I have taken s_umount on all sysfs superblocks */
+restart:
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		if (sysfs_info(sb)->grabbed)
+			continue;
+		/* Wait for unmount activity to complete. */
+		if (sb->s_count < S_BIAS) {
+			sb->s_count += 1;
+			spin_unlock(&sb_lock);
+			down_read(&sb->s_umount);
+			drop_super(sb);
+			goto restart;
+		}
+		atomic_inc(&sb->s_active);
+		sysfs_info(sb)->grabbed = 1;
+	}
+	spin_unlock(&sb_lock);
+}
+
+void sysfs_release_supers(void)
+{
+	/* must hold sysfs_rename_mutex */
+	struct super_block *sb;
+restart:
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+		if (!sysfs_info(sb)->grabbed)
+			continue;
+		sysfs_info(sb)->grabbed = 0;
+		spin_unlock(&sb_lock);
+		deactivate_super(sb);
+		goto restart;
+	}
+	spin_unlock(&sb_lock);
+}
+
 int __init sysfs_init(void)
 {
 	int err = -ENOMEM;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2915959..0fdc3de 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -85,6 +85,12 @@ struct sysfs_addrm_cxt {
 	int			cnt;
 };
 
+struct sysfs_super_info {
+	int	grabbed;
+};
+
+#define sysfs_info(SB) ((struct sysfs_super_info *)(SB)->s_fs_info)
+
 /*
  * mount.c
  */
@@ -92,6 +98,10 @@ extern struct sysfs_dirent sysfs_root;
 extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 extern struct vfsmount *sysfs_mount;
+extern struct file_system_type sysfs_fs_type;
+
+void sysfs_grab_supers(void);
+void sysfs_release_supers(void);
 
 /*
  * dir.c
-- 
1.5.3.rc6.17.g1911

