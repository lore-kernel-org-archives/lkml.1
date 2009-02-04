Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZBDEnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZBDEnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZBDEmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:42:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:50553 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZBDEmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:42:44 -0500
Date: Tue, 3 Feb 2009 20:38:13 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de
Cc: serue@us.ibm.com, sukadev@us.ibm.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [v2][PATCH 5/5] Merge code for single and multiple-instance mounts
Message-ID: <20090204043813.GE26202@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043516.GB25963@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 28 Jan 2009 19:11:15 -0800
Subject: [v2][PATCH 5/5] Merge code for single and multiple-instance mounts

new_pts_mount() (including the get_sb_nodev()), shares a lot of code
with init_pts_mount(). The only difference between them is the 'test-super'
function passed into sget().

Move all common code into devpts_get_sb() and remove the new_pts_mount() and
init_pts_mount() functions,

Changelog[v2]:
	(Christoph Hellwig): Merge code in 'do_pts_mount()' into devpts_get_sb()

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 fs/devpts/inode.c |  122 +++++++++++++++++++---------------------------------
 1 files changed, 45 insertions(+), 77 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index c821c9a..6438782 100644
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
+ *
+ *     If the '-o newinstance' option was not specified, mount/remount the
+ *     initial kernel mount of devpts.  This type of mount gives the
+ *     legacy, single-instance semantics.
  *
- *     Mount or remount the initial kernel mount of devpts. This type of
- *     mount maintains the legacy, single-instance semantics, while the
- *     kernel still allows multiple-instances.
+ *     The 'newinstance' option is needed to support multiple namespace
+ *     semantics in devpts while preserving backward compatibility of the
+ *     current 'single-namespace' semantics. i.e all mounts of devpts
+ *     without the 'newinstance' mount option should bind to the initial
+ *     kernel mount, like get_sb_single().
  *
- *     This interface is needed to support multiple namespace semantics in
- *     devpts while preserving backward compatibility of the current 'single-
- *     namespace' semantics. i.e all mounts of devpts without the 'newinstance'
- *     mount option should bind to the initial kernel mount, like
- *     get_sb_single().
+ *     Mounts with 'newinstance' option create a new, private namespace.
  *
- *     Mounts with 'newinstance' option create a new private namespace.
+ *     NOTE:
  *
- *     But for single-mount semantics, devpts cannot use get_sb_single(),
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
@@ -414,24 +365,41 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 			return error;
 	}
 
-	if (opts.newinstance)
-		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
-	else
-		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
+	if (opts.newinstance) {
+		printk(KERN_NOTICE "devpts: newinstance mount\n");
+		s = sget(fs_type, NULL, set_anon_super, NULL);
+	} else {
+		printk(KERN_NOTICE "devpts: single-instance mount\n");
+		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
+	}
 
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

