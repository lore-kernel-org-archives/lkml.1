Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXFMDIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXFMDIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXFMDIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:08:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33614 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbXFMDId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:08:33 -0400
Date: Wed, 13 Jun 2007 04:08:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613030829.GA15724@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Mike Snitzer <snitzer@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070612161029.GB28279@think.oraclecorp.com> <170fa0d20706121253v62d13f70p3694eeab1852092a@mail.gmail.com> <20070612201439.GI28279@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612201439.GI28279@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 04:14:39PM -0400, Chris Mason wrote:
> > Aside from folding snapshot history into the origin's namespace... It
> > could be possible to have a mount.btrfs that allows subvolumes and/or
> > snapshot volumes to be mounted as unique roots?  I'd imagine a bind
> > mount _could_ provide this too?  Anyway, I'm just interested in
> > understanding the vision for managing the potentially complex nature
> > of a Btrfs namespace.
> 
> One option is to put the real btrfs root into some directory in
> (/sys/fs/btrfs/$device?) and then use tools in userland to mount -o bind
> outside of that.  I wanted to wait to get fancy until I had a better
> idea of how people would use the feature.

We already support mounting into subdirectories of a filesystem for
nfs connection sharing.  The patch below makes use of this to allow
mounting any subdirectory of a btrfs filesystem by specifying it in
the form of /dev/somedevice:directory and when no subdirectory
is specified uses 'default'.  To make this more useful btrfs directories
should grow some way to be marked head of a subvolume, and we'd need
a more useful way to actually create subvolumes and snapshots without
fugly ioctls.

Btw, do create a subvolume with my patch you need to escape back to
the global root which is done by specifing /dev/somedevice:. as the
device on the mount command line.


Index: btrfs-0.2/super.c
===================================================================
--- btrfs-0.2.orig/super.c	2007-06-13 03:44:38.000000000 +0200
+++ btrfs-0.2/super.c	2007-06-13 03:48:35.000000000 +0200
@@ -17,6 +17,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
@@ -26,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
+#include <linux/mount.h>
 #include <linux/mpage.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
@@ -135,11 +137,114 @@ static void btrfs_write_super(struct sup
 	sb->s_dirt = 0;
 }
 
+/*
+ * This is almost a copy of get_sb_bdev in fs/super.c.
+ * We need the local copy to allow direct mounting of
+ * subvolumes, but this could be easily integrated back
+ * into the generic version.  --hch
+ */
+
+/* start copy & paste */
+static int set_bdev_super(struct super_block *s, void *data)
+{
+	s->s_bdev = data;
+	s->s_dev = s->s_bdev->bd_dev;
+	return 0;
+}
+
+static int test_bdev_super(struct super_block *s, void *data)
+{
+	return (void *)s->s_bdev == data;
+}
+
+int btrfs_get_sb_bdev(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data,
+	int (*fill_super)(struct super_block *, void *, int),
+	struct vfsmount *mnt, const char *subvol)
+{
+	struct block_device *bdev = NULL;
+	struct super_block *s;
+	struct dentry *root;
+	int error = 0;
+
+	bdev = open_bdev_excl(dev_name, flags, fs_type);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	/*
+	 * once the super is inserted into the list by sget, s_umount
+	 * will protect the lockfs code from trying to start a snapshot
+	 * while we are mounting
+	 */
+	down(&bdev->bd_mount_sem);
+	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
+	up(&bdev->bd_mount_sem);
+	if (IS_ERR(s))
+		goto error_s;
+
+	if (s->s_root) {
+		if ((flags ^ s->s_flags) & MS_RDONLY) {
+			up_write(&s->s_umount);
+			deactivate_super(s);
+			error = -EBUSY;
+			goto error_bdev;
+		}
+
+		close_bdev_excl(bdev);
+		bdev = NULL;
+	} else {
+		char b[BDEVNAME_SIZE];
+
+		s->s_flags = flags;
+		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		sb_set_blocksize(s, block_size(bdev));
+		error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
+		if (error) {
+			up_write(&s->s_umount);
+			deactivate_super(s);
+			goto error;
+		}
+
+		s->s_flags |= MS_ACTIVE;
+	}
+
+	if (subvol) {
+		root = lookup_one_len(subvol, s->s_root, strlen(subvol));
+		if (!root) {
+			error = -ENXIO;
+			goto error_bdev;
+		}
+	} else {
+		root = dget(s->s_root);
+	}
+
+	mnt->mnt_sb = s;
+	mnt->mnt_root = root;
+	return 0;
+
+error_s:
+	error = PTR_ERR(s);
+error_bdev:
+	if (bdev)
+		close_bdev_excl(bdev);
+error:
+	return error;
+}
+/* end copy & paste */
+
 static int btrfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+	int flags, const char *identifier, void *data, struct vfsmount *mnt)
 {
-	return get_sb_bdev(fs_type, flags, dev_name, data,
-			   btrfs_fill_super, mnt);
+	char *_identifier = kstrdup(identifier, GFP_KERNEL);
+	const char *dev_name;
+
+	dev_name = strsep(&_identifier, ":");
+	if (!dev_name)
+		return -ENOMEM;
+
+	return btrfs_get_sb_bdev(fs_type, flags, dev_name, data,
+			   btrfs_fill_super, mnt,
+			   _identifier ? _identifier : "default");
 }
 
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
