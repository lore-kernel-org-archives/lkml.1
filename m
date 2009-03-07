Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZCGSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZCGSOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZCGSOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:14:00 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51770 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZCGSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:13:59 -0500
Date: Sat, 7 Mar 2009 10:12:32 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: serue@us.ibm.com, hpa@zytor.com, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [v3][PATCH 5/5] Merge code for single and multiple-instance mounts
Message-ID: <20090307181232.GF30072@us.ibm.com>
References: <20090307180816.GA30072@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307180816.GA30072@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v3][PATCH 5/5] Merge code for single and multiple-instance mounts

new_pts_mount() (including the get_sb_nodev()), shares a lot of code
with init_pts_mount(). The only difference between them is the 'test-super'
function passed into sget().

Move all common code into devpts_get_sb() and remove the new_pts_mount() and
init_pts_mount() functions,

Changelog[v3]:
	[Serge Hallyn]: Remove unnecessary printk()s
Changelog[v2]:
	(Christoph Hellwig): Merge code in 'do_pts_mount()' into devpts_get_sb()

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/devpts/inode.c |  115 ++++++++++++++++++----------------------------------
 1 files changed, 40 insertions(+), 75 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index c821c9a..c25fb34 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -325,87 +325,38 @@ static int compare_init_pts_sb(struct super_block *s, void *p)
 }
 
 /*
- * Mount a new (private) instance of devpts.  PTYs created in this
- * instance are independent of the PTYs in other devpts instances.
- */
-static int new_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	int err;
-	struct pts_fs_info *fsi;
-
-	printk(KERN_NOTICE "devpts: newinstance mount\n");
-
-	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
-	if (err)
-		return err;
-
-	fsi = DEVPTS_SB(mnt->mnt_sb);
-	memcpy(&fsi->mount_opts, opts, sizeof(opts));
-
-	return 0;
-}
-
-/*
- * init_pts_mount()
+ * devpts_get_sb()
+ *
+ *     If the '-o newinstance' mount option was specified, mount a new
+ *     (private) instance of devpts.  PTYs created in this instance are
+ *     independent of the PTYs in other devpts instances.
  *
- *     Mount or remount the initial kernel mount of devpts. This type of
- *     mount maintains the legacy, single-instance semantics, while the
- *     kernel still allows multiple-instances.
+ *     If the '-o newinstance' option was not specified, mount/remount the
+ *     initial kernel mount of devpts.  This type of mount gives the
+ *     legacy, single-instance semantics.
  *
- *     This interface is needed to support multiple namespace semantics in
- *     devpts while preserving backward compatibility of the current 'single-
- *     namespace' semantics. i.e all mounts of devpts without the 'newinstance'
- *     mount option should bind to the initial kernel mount, like
- *     get_sb_single().
+ *     The 'newinstance' option is needed to support multiple namespace
+ *     semantics in devpts while preserving backward compatibility of the
+ *     current 'single-namespace' semantics. i.e all mounts of devpts
+ *     without the 'newinstance' mount option should bind to the initial
+ *     kernel mount, like get_sb_single().
  *
- *     Mounts with 'newinstance' option create a new private namespace.
+ *     Mounts with 'newinstance' option create a new, private namespace.
  *
- *     But for single-mount semantics, devpts cannot use get_sb_single(),
+ *     NOTE:
+ *
+ *     For single-mount semantics, devpts cannot use get_sb_single(),
  *     because get_sb_single()/sget() find and use the super-block from
  *     the most recent mount of devpts. But that recent mount may be a
  *     'newinstance' mount and get_sb_single() would pick the newinstance
  *     super-block instead of the initial super-block.
- *
- *     This interface is identical to get_sb_single() except that it
- *     consistently selects the 'single-namespace' superblock even in the
- *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
-static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct pts_mount_opts *opts, struct vfsmount *mnt)
-{
-	struct super_block *s;
-	struct pts_fs_info *fsi;
-	int error;
-
-	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
-	if (IS_ERR(s))
-		return PTR_ERR(s);
-
-	if (!s->s_root) {
-		s->s_flags = flags;
-		error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
-		if (error) {
-			up_write(&s->s_umount);
-			deactivate_super(s);
-			return error;
-		}
-		s->s_flags |= MS_ACTIVE;
-	}
-
-	simple_set_mnt(mnt, s);
-
-	fsi = DEVPTS_SB(mnt->mnt_sb);
-	memcpy(&fsi->mount_opts, opts, sizeof(opts));
-
-	return 0;
-}
-
 static int devpts_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	int error;
 	struct pts_mount_opts opts;
+	struct super_block *s;
 
 	memset(&opts, 0, sizeof(opts)); 
 	if (data) {
@@ -415,23 +366,37 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	}
 
 	if (opts.newinstance)
-		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
+		s = sget(fs_type, NULL, set_anon_super, NULL);
 	else
-		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
+		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
 
-	if (error)
-		return error;
+	if (IS_ERR(s))
+		return PTR_ERR(s);
 
-	error = mknod_ptmx(mnt->mnt_sb);
+	if (!s->s_root) {
+		s->s_flags = flags;
+		error = devpts_fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		if (error)
+			goto out_undo_sget;
+		s->s_flags |= MS_ACTIVE;
+	}
+
+	simple_set_mnt(mnt, s);
+
+	memcpy(&(DEVPTS_SB(s))->mount_opts, &opts, sizeof(opts));
+
+	error = mknod_ptmx(s);
 	if (error)
 		goto out_dput;
 
 	return 0;
 
 out_dput:
-	dput(mnt->mnt_sb->s_root);
-	up_write(&mnt->mnt_sb->s_umount);
-	deactivate_super(mnt->mnt_sb);
+	dput(s->s_root);
+
+out_undo_sget:
+	up_write(&s->s_umount);
+	deactivate_super(s);
 	return error;
 }
 
-- 
1.5.2.5

