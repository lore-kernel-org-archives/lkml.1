Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZACQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZACQQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbZACQPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:15:51 -0500
Received: from verein.lst.de ([213.95.11.210]:45838 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759004AbZACQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:15:51 -0500
Date: Sat, 3 Jan 2009 17:15:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: devpts multiple instances feedback
Message-ID: <20090103161544.GA18976@lst.de>
References: <20090103155209.GA17988@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103155209.GA17988@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a little untested patch to massage the mount code into about
how it should look like:


Index: linux-2.6/fs/devpts/inode.c
===================================================================
--- linux-2.6.orig/fs/devpts/inode.c	2009-01-03 16:52:22.823672077 +0100
+++ linux-2.6/fs/devpts/inode.c	2009-01-03 17:14:24.153711598 +0100
@@ -329,106 +329,6 @@ static int compare_init_pts_sb(struct su
 }
 
 /*
- * Safely parse the mount options in @data and update @opts.
- *
- * devpts ends up parsing options two times during mount, due to the
- * two modes of operation it supports. The first parse occurs in
- * devpts_get_sb() when determining the mode (single-instance or
- * multi-instance mode). The second parse happens in devpts_remount()
- * or new_pts_mount() depending on the mode.
- *
- * Parsing of options modifies the @data making subsequent parsing
- * incorrect. So make a local copy of @data and parse it.
- *
- * Return: 0 On success, -errno on error
- */
-static int safe_parse_mount_options(void *data, struct pts_mount_opts *opts)
-{
-	int rc;
-	void *datacp;
-
-	if (!data)
-		return 0;
-
-	/* Use kstrdup() ?  */
-	datacp = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!datacp)
-		return -ENOMEM;
-
-	memcpy(datacp, data, PAGE_SIZE);
-	rc = parse_mount_options((char *)datacp, PARSE_MOUNT, opts);
-	kfree(datacp);
-
-	return rc;
-}
-
-/*
- * Mount a new (private) instance of devpts.  PTYs created in this
- * instance are independent of the PTYs in other devpts instances.
- */
-static int new_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
-{
-	int err;
-	struct pts_fs_info *fsi;
-	struct pts_mount_opts *opts;
-
-	printk(KERN_NOTICE "devpts: newinstance mount\n");
-
-	err = get_sb_nodev(fs_type, flags, data, devpts_fill_super, mnt);
-	if (err)
-		return err;
-
-	fsi = DEVPTS_SB(mnt->mnt_sb);
-	opts = &fsi->mount_opts;
-
-	err = parse_mount_options(data, PARSE_MOUNT, opts);
-	if (err)
-		goto fail;
-
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err)
-		goto fail;
-
-	return 0;
-
-fail:
-	dput(mnt->mnt_sb->s_root);
-	deactivate_super(mnt->mnt_sb);
-	return err;
-}
-
-/*
- * Check if 'newinstance' mount option was specified in @data.
- *
- * Return: -errno  	on error (eg: invalid mount options specified)
- * 	 : 1 		if 'newinstance' mount option was specified
- * 	 : 0 		if 'newinstance' mount option was NOT specified
- */
-static int is_new_instance_mount(void *data)
-{
-	int rc;
-	struct pts_mount_opts opts;
-
-	if (!data)
-		return 0;
-
-	rc = safe_parse_mount_options(data, &opts);
-	if (!rc)
-		rc = opts.newinstance;
-
-	return rc;
-}
-
-/*
- * get_init_pts_sb()
- *
- *     This interface is needed to support multiple namespace semantics in
- *     devpts while preserving backward compatibility of the current 'single-
- *     namespace' semantics. i.e all mounts of devpts without the 'newinstance'
- *     mount option should bind to the initial kernel mount, like
- *     get_sb_single().
- *
  *     Mounts with 'newinstance' option create a new private namespace.
  *
  *     But for single-mount semantics, devpts cannot use get_sb_single(),
@@ -436,20 +336,43 @@ static int is_new_instance_mount(void *d
  *     the most recent mount of devpts. But that recent mount may be a
  *     'newinstance' mount and get_sb_single() would pick the newinstance
  *     super-block instead of the initial super-block.
- *
- *     This interface is identical to get_sb_single() except that it
- *     consistently selects the 'single-namespace' superblock even in the
- *     presence of the private namespace (i.e 'newinstance') super-blocks.
  */
-static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
+static int devpts_get_sb(struct file_system_type *fs_type, int flags,
+		const char *dev_name, void *data, struct vfsmount *mnt)
 {
+	struct pts_mount_opts opts = { 0, };
 	struct super_block *s;
 	int error;
 
-	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
-	if (IS_ERR(s))
-		return PTR_ERR(s);
+	if (data) {
+		error = parse_mount_options(data, PARSE_MOUNT, &opts);
+		if (error)
+			return error;
+	}
+
+	if (opts.newinstance) {
+		/*
+		 * Mount a new (private) instance of devpts.  PTYs created
+		 * in this instance are independent of the PTYs in other devpts
+		 * instances.
+		 */
+
+		printk(KERN_NOTICE "devpts: creating new instance\n");
+
+		s = sget(fs_type, NULL, set_anon_super, NULL);
+		if (IS_ERR(s))
+			return PTR_ERR(s);
+	} else {
+		/*
+		 * Mount or remount the initial kernel mount of devpts.
+		 *
+		 * This type of mount maintains the legacy, single-instance
+		 * semantics, while the kernel still allows multiple-instances.
+		 */
+		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
+		if (IS_ERR(s))
+			return PTR_ERR(s);
+	}
 
 	if (!s->s_root) {
 		s->s_flags = flags;
@@ -461,46 +384,26 @@ static int get_init_pts_sb(struct file_s
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	do_remount_sb(s, flags, data, 0);
-	return simple_set_mnt(mnt, s);
-}
-
-/*
- * Mount or remount the initial kernel mount of devpts. This type of
- * mount maintains the legacy, single-instance semantics, while the
- * kernel still allows multiple-instances.
- */
-static int init_pts_mount(struct file_system_type *fs_type, int flags,
-		void *data, struct vfsmount *mnt)
-{
-	int err;
-
-	err = get_init_pts_sb(fs_type, flags, data, mnt);
-	if (err)
-		return err;
-
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err) {
-		dput(mnt->mnt_sb->s_root);
-		deactivate_super(mnt->mnt_sb);
-	}
-
-	return err;
-}
-
-static int devpts_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	int new;
 
-	new = is_new_instance_mount(data);
-	if (new < 0)
-		return new;
+	/*
+	 * Copy over mount options structure into the superblock.
+	 */
+	memcpy(&DEVPTS_SB(mnt->mnt_sb)->mount_opts, &opts, sizeof(opts));
+
+	error = simple_set_mnt(mnt, s);
+	if (error)
+		return error;
+
+	error = mknod_ptmx(mnt->mnt_sb);
+	if (error)
+		goto out_dput;
 
-	if (new)
-		return new_pts_mount(fs_type, flags, data, mnt);
+	return 0;
 
-	return init_pts_mount(fs_type, flags, data, mnt);
+ out_dput:
+	dput(mnt->mnt_sb->s_root);
+	deactivate_super(mnt->mnt_sb);
+	return error;
 }
 #else
 /*
