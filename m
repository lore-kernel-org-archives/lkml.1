Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbZKBRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbZKBRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZKBRLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:11:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbZKBRLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:11:44 -0500
Date: Mon, 2 Nov 2009 18:11:47 +0100
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 01/27] BKL: Push down BKL from do_new_mount() to the filesystems get_sb/fill_super operation
Message-ID: <20091102171147.GG21750@bolzano.suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-2-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <1257156307-24175-2-git-send-email-jblunck@suse.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 02, Jan Blunck wrote:

> I've read through all the code formerly covered by the BKL inside
> do_kern_mount() and have satisfied myself that it doesn't need the BKL
> any more.
> 
> do_kern_mount() is already called without the BKL when mounting the rootfs
> and in nfsctl. do_kern_mount() calls vfs_kern_mount(), which is called
> from various places without BKL: simple_pin_fs(), nfs_do_clone_mount()
> through nfs_follow_mountpoint(), afs_mntpt_do_automount() through
> afs_mntpt_follow_link(). Both later functions are actually the filesystems
> follow_link inode operation. vfs_kern_mount() is calling the specified
> get_sb function and lets the filesystem do its job by calling the given
> fill_super function.
> 
> Therefore I think it is safe to push down the BKL from the VFS to the
> low-level filesystems get_sb/fill_super operation.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Matthew Wilcox <matthew@wil.cx>

Attached is a new version of the patch that includes the changes for
filesystems outside of fs/ directory as well. Besides that I trimmed the CC
list this time.

Cheers,
Jan

--ogUXNSQj4OI1q3LQ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-BKL-Push-down-BKL-from-do_new_mount-to-the-filesyste.patch"

>From 211bc31463c06e125c084ca72aaa06c7e3ebb0a2 Mon Sep 17 00:00:00 2001
From: Jan Blunck <jblunck@suse.de>
Date: Mon, 2 Nov 2009 16:30:27 +0100
Subject: [PATCH 01/28] BKL: Push down BKL from do_new_mount() to the filesystems get_sb/fill_super operation

I've read through all the code formerly covered by the BKL inside
do_kern_mount() and have satisfied myself that it doesn't need the BKL
any more.

do_kern_mount() is already called without the BKL when mounting the rootfs
and in nfsctl. do_kern_mount() calls vfs_kern_mount(), which is called
from various places without BKL: simple_pin_fs(), nfs_do_clone_mount()
through nfs_follow_mountpoint(), afs_mntpt_do_automount() through
afs_mntpt_follow_link(). Both later functions are actually the filesystems
follow_link inode operation. vfs_kern_mount() is calling the specified
get_sb function and lets the filesystem do its job by calling the given
fill_super function.

Therefore I think it is safe to push down the BKL from the VFS to the
low-level filesystems get_sb/fill_super operation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    8 +++++++-
 arch/s390/hypfs/inode.c                   |    9 ++++++++-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    8 ++++++--
 drivers/isdn/capi/capifs.c                |   10 ++++++++--
 drivers/misc/ibmasm/ibmasmfs.c            |    9 ++++++++-
 drivers/oprofile/oprofilefs.c             |    9 ++++++++-
 drivers/staging/pohmelfs/inode.c          |    5 +++++
 drivers/usb/core/inode.c                  |    5 +++++
 drivers/usb/gadget/inode.c                |   12 ++++++++++--
 drivers/xen/xenfs/super.c                 |    7 ++++++-
 fs/9p/vfs_super.c                         |    9 ++++++++-
 fs/adfs/super.c                           |    8 +++++++-
 fs/affs/super.c                           |    9 ++++++++-
 fs/afs/super.c                            |    5 +++++
 fs/autofs4/inode.c                        |    4 ++++
 fs/befs/linuxvfs.c                        |    4 ++++
 fs/bfs/inode.c                            |    9 ++++++++-
 fs/binfmt_misc.c                          |    7 ++++++-
 fs/btrfs/super.c                          |    8 +++++++-
 fs/cifs/cifsfs.c                          |   12 ++++++++++--
 fs/coda/inode.c                           |    8 +++++++-
 fs/configfs/mount.c                       |    5 +++++
 fs/cramfs/inode.c                         |    8 +++++++-
 fs/devpts/inode.c                         |   13 +++++++++++--
 fs/ecryptfs/main.c                        |    4 ++++
 fs/efs/super.c                            |   10 ++++++++--
 fs/exofs/super.c                          |    7 ++++++-
 fs/ext2/super.c                           |   10 ++++++++--
 fs/ext3/super.c                           |    9 ++++++++-
 fs/ext4/super.c                           |    9 ++++++---
 fs/fat/namei_msdos.c                      |    7 ++++++-
 fs/fat/namei_vfat.c                       |    7 ++++++-
 fs/freevxfs/vxfs_super.c                  |    7 ++++++-
 fs/fuse/control.c                         |    9 ++++++++-
 fs/fuse/inode.c                           |    5 +++++
 fs/gfs2/ops_fstype.c                      |   10 ++++++++++
 fs/hfs/super.c                            |    8 +++++++-
 fs/hfsplus/super.c                        |    8 +++++++-
 fs/hostfs/hostfs_kern.c                   |    4 ++++
 fs/hpfs/super.c                           |    8 +++++++-
 fs/hppfs/hppfs.c                          |    4 ++++
 fs/hugetlbfs/inode.c                      |   12 ++++++++++--
 fs/isofs/inode.c                          |    8 +++++++-
 fs/jffs2/super.c                          |   11 +++++++++--
 fs/jfs/super.c                            |   14 ++++++++++++--
 fs/libfs.c                                |   10 +++++++++-
 fs/minix/inode.c                          |    8 +++++++-
 fs/namespace.c                            |    2 --
 fs/ncpfs/inode.c                          |    8 +++++++-
 fs/nfs/super.c                            |   24 ++++++++++++++++++++++++
 fs/nfsd/nfsctl.c                          |    8 +++++++-
 fs/nilfs2/super.c                         |    9 ++++++++-
 fs/ntfs/super.c                           |    5 +++++
 fs/ocfs2/dlm/dlmfs.c                      |    9 ++++++++-
 fs/ocfs2/super.c                          |    5 +++++
 fs/omfs/inode.c                           |    7 ++++++-
 fs/openpromfs/inode.c                     |    4 ++++
 fs/proc/root.c                            |    9 ++++++++-
 fs/qnx4/inode.c                           |    8 +++++++-
 fs/ramfs/inode.c                          |    5 +++++
 fs/reiserfs/super.c                       |    4 ++++
 fs/romfs/super.c                          |    9 ++++++++-
 fs/smbfs/inode.c                          |    5 +++++
 fs/squashfs/super.c                       |    6 ++++++
 fs/sysfs/mount.c                          |    6 ++++++
 fs/sysv/super.c                           |   25 ++++++++++++++++++++-----
 fs/ubifs/super.c                          |    5 +++++
 fs/udf/super.c                            |    8 +++++++-
 fs/ufs/super.c                            |    5 +++++
 fs/xfs/linux-2.6/xfs_super.c              |    4 ++++
 ipc/mqueue.c                              |    4 ++++
 kernel/cgroup.c                           |    4 ++++
 kernel/cpuset.c                           |    4 ++++
 mm/shmem.c                                |    9 ++++++++-
 net/sunrpc/rpc_pipe.c                     |   10 +++++++++-
 security/inode.c                          |    7 ++++++-
 security/selinux/selinuxfs.c              |    5 +++++
 security/smack/smackfs.c                  |    4 ++++
 78 files changed, 540 insertions(+), 67 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index fc1b1c4..a68ea02 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -34,6 +34,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/parser.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include <asm/prom.h>
 #include <asm/spu.h>
@@ -781,6 +782,9 @@ spufs_fill_super(struct super_block *sb, void *data, int silent)
 		.drop_inode = generic_delete_inode,
 		.show_options = generic_show_options,
 	};
+	int res;
+
+	lock_kernel();
 
 	save_mount_options(sb, data);
 
@@ -795,7 +799,9 @@ spufs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &s_ops;
 	sb->s_fs_info = info;
 
-	return spufs_create_root(sb, data);
+	res = spufs_create_root(sb, data);
+	unlock_kernel();
+	return res;
 }
 
 static int
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 341aff2..75538cd 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 #include <asm/ebcdic.h>
 #include "hypfs.h"
 
@@ -277,9 +278,13 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 	int rc = 0;
 	struct hypfs_sb_info *sbi;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(struct hypfs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	mutex_init(&sbi->lock);
 	sbi->uid = current_uid();
 	sbi->gid = current_gid();
@@ -319,6 +324,7 @@ static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 	hypfs_update_update(sb);
 	sb->s_root = root_dentry;
 	pr_info("Hypervisor filesystem mounted\n");
+	unlock_kernel();
 	return 0;
 
 err_tree:
@@ -327,6 +333,7 @@ err_tree:
 	dput(root_dentry);
 err_alloc:
 	kfree(sbi);
+	unlock_kernel();
 	return rc;
 }
 
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index b368406..d5723c6 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -37,6 +37,7 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include "ipath_kernel.h"
 
@@ -362,10 +363,13 @@ bail:
 static int ipathfs_get_sb(struct file_system_type *fs_type, int flags,
 			const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	int ret = get_sb_single(fs_type, flags, data,
-				    ipathfs_fill_super, mnt);
+	int ret;
+
+	lock_kernel();
+	ret = get_sb_single(fs_type, flags, data, ipathfs_fill_super, mnt);
 	if (ret >= 0)
 		ipath_super = mnt->mnt_sb;
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 9f8f67b..a408f72 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>	/* current */
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include "capifs.h"
 
@@ -102,6 +103,8 @@ capifs_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * inode;
 
+	lock_kernel();
+
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = CAPIFS_SUPER_MAGIC;
@@ -119,12 +122,15 @@ capifs_fill_super(struct super_block *s, void *data, int silent)
 	inode->i_nlink = 2;
 
 	capifs_root = s->s_root = d_alloc_root(inode);
-	if (s->s_root)
+	if (s->s_root) {
+		unlock_kernel();
 		return 0;
-	
+	}
+
 	printk("capifs: get root dentry failed\n");
 	iput(inode);
 fail:
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index aecf40e..83ef0f7 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -75,6 +75,7 @@
 
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include "ibmasm.h"
@@ -116,6 +117,8 @@ static int ibmasmfs_fill_super (struct super_block *sb, void *data, int silent)
 	struct inode *root;
 	struct dentry *root_dentry;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = IBMASMFS_MAGIC;
@@ -123,8 +126,10 @@ static int ibmasmfs_fill_super (struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 
 	root = ibmasmfs_make_inode (sb, S_IFDIR | 0500);
-	if (!root)
+	if (!root) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	root->i_op = &simple_dir_inode_operations;
 	root->i_fop = ibmasmfs_dir_ops;
@@ -132,11 +137,13 @@ static int ibmasmfs_fill_super (struct super_block *sb, void *data, int silent)
 	root_dentry = d_alloc_root(root);
 	if (!root_dentry) {
 		iput(root);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_root = root_dentry;
 
 	ibmasmfs_create_files(sb, root_dentry);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 2766a6d..6d4df37 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -15,6 +15,7 @@
 #include <linux/oprofile.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 #include <asm/uaccess.h>
 
 #include "oprof.h"
@@ -243,6 +244,8 @@ static int oprofilefs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *root_inode;
 	struct dentry *root_dentry;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = OPROFILEFS_MAGIC;
@@ -250,13 +253,16 @@ static int oprofilefs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 
 	root_inode = oprofilefs_get_inode(sb, S_IFDIR | 0755);
-	if (!root_inode)
+	if (!root_inode) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	root_inode->i_op = &simple_dir_inode_operations;
 	root_inode->i_fop = &simple_dir_operations;
 	root_dentry = d_alloc_root(root_inode);
 	if (!root_dentry) {
 		iput(root_inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -265,6 +271,7 @@ static int oprofilefs_fill_super(struct super_block *sb, void *data, int silent)
 	oprofile_create_files(sb, root_dentry);
 
 	// FIXME: verify kill_litter_super removes our dentries
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index c94de31..20a63d8 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -30,6 +30,7 @@
 #include <linux/statfs.h>
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include "netfs.h"
 
@@ -1821,6 +1822,8 @@ static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct pohmelfs_inode *npi;
 	struct qstr str;
 
+	lock_kernel();
+
 	psb = kzalloc(sizeof(struct pohmelfs_sb), GFP_KERNEL);
 	if (!psb)
 		goto err_out_exit;
@@ -1915,6 +1918,7 @@ static int pohmelfs_fill_super(struct super_block *sb, void *data, int silent)
 	INIT_DELAYED_WORK(&psb->dwork, pohmelfs_trans_scan);
 	schedule_delayed_work(&psb->dwork, psb->trans_scan_timeout);
 
+	unlock_kernel();
 	return 0;
 
 err_out_put_root:
@@ -1931,6 +1935,7 @@ err_out_free_sb:
 err_out_exit:
 
 	dprintk("%s: err: %d.\n", __func__, err);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 97b40ce..5c5bf37 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -460,6 +460,8 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = USBDEVICE_SUPER_MAGIC;
@@ -469,6 +471,7 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!inode) {
 		dbg("%s: could not get inode!",__func__);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -476,9 +479,11 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		dbg("%s: could not get root dentry!",__func__);
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index bf0f652..8762dad 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -2046,13 +2046,19 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 	struct dentry	*d;
 	struct dev_data	*dev;
 
-	if (the_device)
+	lock_kernel();
+
+	if (the_device) {
+		unlock_kernel();
 		return -ESRCH;
+	}
 
 	/* fake probe to determine $CHIP */
 	(void) usb_gadget_register_driver (&probe_driver);
-	if (!CHIP)
+	if (!CHIP) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 
 	/* superblock */
 	sb->s_blocksize = PAGE_CACHE_SIZE;
@@ -2089,6 +2095,7 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 	 * from binding to a controller.
 	 */
 	the_device = dev;
+	unlock_kernel();
 	return 0;
 
 enomem3:
@@ -2098,6 +2105,7 @@ enomem2:
 enomem1:
 	iput (inode);
 enomem0:
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 6559e0c..46d34ea 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 #include "xenfs.h"
 
@@ -43,8 +44,12 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 		{ "capabilities", &capabilities_file_ops, S_IRUGO },
 		{""},
 	};
+	int res;
 
-	return simple_fill_super(sb, XENFS_SUPER_MAGIC, xenfs_files);
+	lock_kernel();
+	res = simple_fill_super(sb, XENFS_SUPER_MAGIC, xenfs_files);
+	unlock_kernel();
+	return res;
 }
 
 static int xenfs_get_sb(struct file_system_type *fs_type,
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 14a8644..4156a0c 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -106,11 +106,15 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct p9_fid *fid;
 	int retval = 0;
 
+	lock_kernel();
+
 	P9_DPRINTK(P9_DEBUG_VFS, " \n");
 
 	v9ses = kzalloc(sizeof(struct v9fs_session_info), GFP_KERNEL);
-	if (!v9ses)
+	if (!v9ses) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	fid = v9fs_session_init(v9ses, dev_name, data);
 	if (IS_ERR(fid)) {
@@ -155,6 +159,7 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 
 P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
 	simple_set_mnt(mnt, sb);
+	unlock_kernel();
 	return 0;
 
 free_stat:
@@ -167,12 +172,14 @@ clunk_fid:
 close_session:
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
+	unlock_kernel();
 	return retval;
 
 release_sb:
 	p9stat_free(st);
 	kfree(st);
 	deactivate_locked_super(sb);
+	unlock_kernel();
 	return retval;
 }
 
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 6910a98..e94f111 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -351,11 +351,15 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct adfs_sb_info *asb;
 	struct inode *root;
 
+	lock_kernel();
+
 	sb->s_flags |= MS_NODIRATIME;
 
 	asb = kzalloc(sizeof(*asb), GFP_KERNEL);
-	if (!asb)
+	if (!asb) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = asb;
 
 	/* set default options */
@@ -473,6 +477,7 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto error;
 	} else
 		sb->s_root->d_op = &adfs_dentry_operations;
+	unlock_kernel();
 	return 0;
 
 error_free_bh:
@@ -480,6 +485,7 @@ error_free_bh:
 error:
 	sb->s_fs_info = NULL;
 	kfree(asb);
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 104fdcb..135f0d3 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -298,6 +298,8 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	u8			 sig[4];
 	int			 ret = -EINVAL;
 
+	lock_kernel();
+
 	save_mount_options(sb, data);
 
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
@@ -307,8 +309,10 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags |= MS_NODIRATIME;
 
 	sbi = kzalloc(sizeof(struct affs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 	mutex_init(&sbi->s_bmlock);
 
@@ -316,6 +320,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 	/* N.B. after this point s_prefix must be released */
@@ -486,6 +491,7 @@ got_root:
 	sb->s_root->d_op = &affs_dentry_operations;
 
 	pr_debug("AFFS: s_flags=%lX\n",sb->s_flags);
+	unlock_kernel();
 	return 0;
 
 	/*
@@ -500,6 +506,7 @@ out_error_noinode:
 	kfree(sbi->s_prefix);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/afs/super.c b/fs/afs/super.c
index e1ea1c2..108fb3e 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -294,12 +294,15 @@ static int afs_fill_super(struct super_block *sb, void *data)
 	struct inode *inode = NULL;
 	int ret;
 
+	lock_kernel();
+
 	_enter("");
 
 	/* allocate a superblock info record */
 	as = kzalloc(sizeof(struct afs_super_info), GFP_KERNEL);
 	if (!as) {
 		_leave(" = -ENOMEM");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -329,6 +332,7 @@ static int afs_fill_super(struct super_block *sb, void *data)
 	sb->s_root = root;
 
 	_leave(" = 0");
+	unlock_kernel();
 	return 0;
 
 error_inode:
@@ -342,6 +346,7 @@ error:
 	sb->s_fs_info = NULL;
 
 	_leave(" = %d", ret);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 69c8142..3adaba9 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -323,6 +323,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
@@ -418,6 +420,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 * Success! Install the root dentry now to indicate completion.
 	 */
 	s->s_root = root;
+	unlock_kernel();
 	return 0;
 	
 	/*
@@ -439,6 +442,7 @@ fail_free:
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 33baf27..f2aa193 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -759,6 +759,8 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
 
+	lock_kernel();
+
 	save_mount_options(sb, data);
 
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
@@ -867,6 +869,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		befs_sb->nls = load_nls_default();
 	}
 
+	unlock_kernel();
 	return 0;
 /*****************/
       unacquire_bh:
@@ -877,6 +880,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
       unacquire_none:
 	sb->s_fs_info = NULL;
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 6f60336..4bff506 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -356,9 +356,13 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	long ret = -EINVAL;
 	unsigned long i_sblock, i_eblock, i_eoff, s_size;
 
+	lock_kernel();
+
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
+	if (!info) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = info;
 
 	sb_set_blocksize(s, BFS_BSIZE);
@@ -463,6 +467,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 			kfree(info->si_imap);
 			kfree(info);
 			s->s_fs_info = NULL;
+			unlock_kernel();
 			return -EIO;
 		}
 
@@ -484,12 +489,14 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	} 
 	dump_imap("read_super", s);
 	mutex_init(&info->bfs_lock);
+	unlock_kernel();
 	return 0;
 
 out:
 	brelse(bh);
 	kfree(info);
 	s->s_fs_info = NULL;
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c4e8353..c8b4f45 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -695,9 +696,13 @@ static int bm_fill_super(struct super_block * sb, void * data, int silent)
 		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err = simple_fill_super(sb, 0x42494e4d, bm_files);
+	int err;
+
+	lock_kernel();
+	err = simple_fill_super(sb, 0x42494e4d, bm_files);
 	if (!err)
 		sb->s_op = &s_ops;
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 752a546..e5cd2cf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -480,13 +480,17 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 	fmode_t mode = FMODE_READ;
 	int error = 0;
 
+	lock_kernel();
+
 	if (!(flags & MS_RDONLY))
 		mode |= FMODE_WRITE;
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
 					  &subvol_name, &fs_devices);
-	if (error)
+	if (error) {
+		unlock_kernel();
 		return error;
+	}
 
 	error = btrfs_scan_one_device(dev_name, mode, fs_type, &fs_devices);
 	if (error)
@@ -555,6 +559,7 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
 	mnt->mnt_root = root;
 
 	kfree(subvol_name);
+	unlock_kernel();
 	return 0;
 
 error_s:
@@ -563,6 +568,7 @@ error_close_devices:
 	btrfs_close_devices(fs_devices);
 error_free_subvol_name:
 	kfree(subvol_name);
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9a5e4f5..09ccb9d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -596,22 +596,30 @@ cifs_get_sb(struct file_system_type *fs_type,
 	    int flags, const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	int rc;
-	struct super_block *sb = sget(fs_type, NULL, set_anon_super, NULL);
+	struct super_block *sb;
+
+	lock_kernel();
+
+	sb = sget(fs_type, NULL, set_anon_super, NULL);
 
 	cFYI(1, ("Devname: %s flags: %d ", dev_name, flags));
 
-	if (IS_ERR(sb))
+	if (IS_ERR(sb)) {
+		unlock_kernel();
 		return PTR_ERR(sb);
+	}
 
 	sb->s_flags = flags;
 
 	rc = cifs_read_super(sb, data, dev_name, flags & MS_SILENT ? 1 : 0);
 	if (rc) {
 		deactivate_locked_super(sb);
+		unlock_kernel();
 		return rc;
 	}
 	sb->s_flags |= MS_ACTIVE;
 	simple_set_mnt(mnt, sb);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 830f51a..d081fc5 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -147,6 +147,8 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	int error;
 	int idx;
 
+	lock_kernel();
+
 	idx = get_device_index((struct coda_mount_data *) data);
 
 	/* Ignore errors in data, for backward compatibility */
@@ -158,11 +160,13 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	vc = &coda_comms[idx];
 	if (!vc->vc_inuse) {
 		printk("coda_read_super: No pseudo device\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 
         if ( vc->vc_sb ) {
 		printk("coda_read_super: Device already mounted\n");
+		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -196,7 +200,8 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root)
 		goto error;
-        return 0;
+	unlock_kernel();
+	return 0;
 
  error:
 	if (root)
@@ -204,6 +209,7 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	if (vc)
 		vc->vc_sb = NULL;
 
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 8421cea..5b2e06e 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -71,6 +71,8 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = CONFIGFS_MAGIC;
@@ -87,6 +89,7 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 		inc_nlink(inode);
 	} else {
 		pr_debug("configfs: could not get root inode\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -94,12 +97,14 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	config_group_init(&configfs_root_group);
 	configfs_root_group.cg_item.ci_dentry = root;
 	root->d_fsdata = &configfs_root;
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index dd3634e..13e696a 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -227,11 +227,15 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct cramfs_sb_info *sbi;
 	struct inode *root;
 
+	lock_kernel();
+
 	sb->s_flags |= MS_RDONLY;
 
 	sbi = kzalloc(sizeof(struct cramfs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 
 	/* Invalidate the read buffers on mount: think disk change.. */
@@ -308,10 +312,12 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		goto out;
 	}
+	unlock_kernel();
 	return 0;
 out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index d5f8c96..e206eef 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -24,6 +24,7 @@
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h> /* just for lock_kernel() */
 
 #define DEVPTS_DEFAULT_MODE 0600
 /*
@@ -363,17 +364,23 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	struct pts_mount_opts opts;
 	struct super_block *s;
 
+	lock_kernel();
+
 	error = parse_mount_options(data, PARSE_MOUNT, &opts);
-	if (error)
+	if (error) {
+		unlock_kernel();
 		return error;
+	}
 
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, NULL);
 	else
 		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
 
-	if (IS_ERR(s))
+	if (IS_ERR(s)) {
+		unlock_kernel();
 		return PTR_ERR(s);
+	}
 
 	if (!s->s_root) {
 		s->s_flags = flags;
@@ -391,6 +398,7 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	if (error)
 		goto out_dput;
 
+	unlock_kernel();
 	return 0;
 
 out_dput:
@@ -398,6 +406,7 @@ out_dput:
 
 out_undo_sget:
 	deactivate_locked_super(s);
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index c6ac85d..01c355e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -36,6 +36,7 @@
 #include <linux/parser.h>
 #include <linux/fs_stack.h>
 #include <linux/ima.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "ecryptfs_kernel.h"
 
 /**
@@ -600,6 +601,8 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
 	int rc;
 	struct super_block *sb;
 
+	lock_kernel();
+
 	rc = get_sb_nodev(fs_type, flags, raw_data, ecryptfs_fill_super, mnt);
 	if (rc < 0) {
 		printk(KERN_ERR "Getting sb failed; rc = [%d]\n", rc);
@@ -621,6 +624,7 @@ out_abort:
 	dput(sb->s_root); /* aka mnt->mnt_root, as set by get_sb_nodev() */
 	deactivate_locked_super(sb);
 out:
+	unlock_kernel();
 	return rc;
 }
 
diff --git a/fs/efs/super.c b/fs/efs/super.c
index f049428..0981141 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -249,9 +249,13 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	struct inode *root;
 	int ret = -EINVAL;
 
- 	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
-	if (!sb)
+	lock_kernel();
+
+	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
+	if (!sb) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = sb;
  
 	s->s_magic		= EFS_SUPER_MAGIC;
@@ -319,12 +323,14 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 		goto out_no_fs;
 	}
 
+	unlock_kernel();
 	return 0;
 
 out_no_fs_ul:
 out_no_fs:
 	s->s_fs_info = NULL;
 	kfree(sb);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 9f500de..ea045b8 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -297,9 +297,13 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	struct osd_obj_id obj;
 	int ret;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 
 	/* use mount options to fill superblock */
@@ -399,6 +403,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 out:
 	if (or)
 		osd_end_request(or);
+	unlock_kernel();
 	return ret;
 
 free_sbi:
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..5af1775 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -745,15 +745,18 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
+	lock_kernel();
+
+	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		return -ENOMEM;
+		goto failed_unlock;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		return -ENOMEM;
+		goto failed_unlock;
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
@@ -1063,6 +1066,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+	unlock_kernel();
 	return 0;
 
 cantfind_ext2:
@@ -1086,6 +1090,8 @@ failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+failed_unlock:
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7a520a8..38261a5 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1568,14 +1568,19 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -1992,6 +1997,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		"writeback");
 
 	lock_kernel();
+	unlock_kernel();
 	return 0;
 
 cantfind_ext3:
@@ -2022,6 +2028,7 @@ out_fail:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	lock_kernel();
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 312211e..9db81d2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2328,14 +2328,19 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -2913,7 +2918,6 @@ no_journal:
 
 	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s", descr);
 
-	lock_kernel();
 	return 0;
 
 cantfind_ext4:
@@ -2959,7 +2963,6 @@ out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-	lock_kernel();
 	return ret;
 }
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index bbc94ae..e2b0b97 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/buffer_head.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "fat.h"
 
 /* Characters that are undesirable in an MS-DOS file name */
@@ -662,12 +663,16 @@ static int msdos_fill_super(struct super_block *sb, void *data, int silent)
 {
 	int res;
 
+	lock_kernel();
 	res = fat_fill_super(sb, data, silent, &msdos_dir_inode_operations, 0);
-	if (res)
+	if (res) {
+		unlock_kernel();
 		return res;
+	}
 
 	sb->s_flags |= MS_NOATIME;
 	sb->s_root->d_op = &msdos_dentry_operations;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index f565f24..365e2d5 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "fat.h"
 
 /*
@@ -1044,15 +1045,19 @@ static int vfat_fill_super(struct super_block *sb, void *data, int silent)
 {
 	int res;
 
+	lock_kernel();
 	res = fat_fill_super(sb, data, silent, &vfat_dir_inode_operations, 1);
-	if (res)
+	if (res) {
+		unlock_kernel();
 		return res;
+	}
 
 	if (MSDOS_SB(sb)->options.name_check != 's')
 		sb->s_root->d_op = &vfat_ci_dentry_ops;
 	else
 		sb->s_root->d_op = &vfat_dentry_ops;
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 1e8af93..b8b7821 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -148,7 +148,7 @@ static int vxfs_remount(struct super_block *sb, int *flags, char *data)
  *   The superblock on success, else %NULL.
  *
  * Locking:
- *   We are under the bkl and @sbp->s_lock.
+ *   We are under @sbp->s_lock.
  */
 static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 {
@@ -159,11 +159,14 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 	struct inode *root;
 	int ret = -EINVAL;
 
+	lock_kernel();
+
 	sbp->s_flags |= MS_RDONLY;
 
 	infp = kzalloc(sizeof(*infp), GFP_KERNEL);
 	if (!infp) {
 		printk(KERN_WARNING "vxfs: unable to allocate incore superblock\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -236,6 +239,7 @@ static int vxfs_fill_super(struct super_block *sbp, void *dp, int silent)
 		goto out_free_ilist;
 	}
 
+	unlock_kernel();
 	return 0;
 	
 out_free_ilist:
@@ -245,6 +249,7 @@ out_free_ilist:
 out:
 	brelse(bp);
 	kfree(infp);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 3773fd6..8d769f7 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h> /* just for lock_kernel() */
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
 
@@ -297,9 +298,13 @@ static int fuse_ctl_fill_super(struct super_block *sb, void *data, int silent)
 	struct fuse_conn *fc;
 	int err;
 
+	lock_kernel();
+
 	err = simple_fill_super(sb, FUSE_CTL_SUPER_MAGIC, &empty_descr);
-	if (err)
+	if (err) {
+		unlock_kernel();
 		return err;
+	}
 
 	mutex_lock(&fuse_mutex);
 	BUG_ON(fuse_control_sb);
@@ -309,10 +314,12 @@ static int fuse_ctl_fill_super(struct super_block *sb, void *data, int silent)
 		if (err) {
 			fuse_control_sb = NULL;
 			mutex_unlock(&fuse_mutex);
+			unlock_kernel();
 			return err;
 		}
 	}
 	mutex_unlock(&fuse_mutex);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a822ce..5690279 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/exportfs.h>
+#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
@@ -919,6 +920,8 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	int is_bdev = sb->s_bdev != NULL;
 
+	lock_kernel();
+
 	err = -EINVAL;
 	if (sb->s_flags & MS_MANDLOCK)
 		goto err;
@@ -1022,6 +1025,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 
 	fuse_send_init(fc, init_req);
 
+	unlock_kernel();
 	return 0;
 
  err_unlock:
@@ -1036,6 +1040,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
  err_fput:
 	fput(file);
  err:
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 52fb6c0..96c58ad 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -18,6 +18,7 @@
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/slow-work.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 #include "gfs2.h"
 #include "incore.h"
@@ -1120,9 +1121,12 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 	struct gfs2_holder mount_gh;
 	int error;
 
+	lock_kernel();
+
 	sdp = init_sbd(sb);
 	if (!sdp) {
 		printk(KERN_WARNING "GFS2: can't alloc struct gfs2_sbd\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -1211,6 +1215,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 
 	gfs2_glock_dq_uninit(&mount_gh);
 	gfs2_online_uevent(sdp);
+	unlock_kernel();
 	return 0;
 
 fail_threads:
@@ -1240,6 +1245,7 @@ fail:
 	gfs2_delete_debugfs_file(sdp);
 	kfree(sdp);
 	sb->s_fs_info = NULL;
+	unlock_kernel();
 	return error;
 }
 
@@ -1268,10 +1274,12 @@ static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 	struct path path;
 	int error;
 
+	lock_kernel();
 	error = kern_path(dev_name, LOOKUP_FOLLOW, &path);
 	if (error) {
 		printk(KERN_WARNING "GFS2: path_lookup on %s returned error %d\n",
 		       dev_name, error);
+		unlock_kernel();
 		return error;
 	}
 	s = sget(&gfs2_fs_type, test_meta_super, set_meta_super,
@@ -1279,11 +1287,13 @@ static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 	path_put(&path);
 	if (IS_ERR(s)) {
 		printk(KERN_WARNING "GFS2: gfs2 mount does not exist\n");
+		unlock_kernel();
 		return PTR_ERR(s);
 	}
 	sdp = s->s_fs_info;
 	mnt->mnt_sb = s;
 	mnt->mnt_root = dget(sdp->sd_master_dir);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index f7fcbe4..a2e19ff 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -381,9 +381,13 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *root_inode;
 	int res;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(struct hfs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
 
@@ -429,6 +433,7 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root->d_op = &hfs_dentry_operations;
 
 	/* everything's okay */
+	unlock_kernel();
 	return 0;
 
 bail_iput:
@@ -437,6 +442,7 @@ bail_no_root:
 	printk(KERN_ERR "hfs: get root inode failed.\n");
 bail:
 	hfs_mdb_put(sb);
+	unlock_kernel();
 	return res;
 }
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 43022f3..824f57a 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -312,9 +312,13 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	struct nls_table *nls = NULL;
 	int err = -EINVAL;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sb->s_fs_info = sbi;
 	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
@@ -459,11 +463,13 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 out:
 	unload_nls(sbi->nls);
 	sbi->nls = nls;
+	unlock_kernel();
 	return 0;
 
 cleanup:
 	hfsplus_put_super(sb);
 	unload_nls(nls);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 032604e..5eb2c26 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -968,6 +968,8 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	char *host_root_path, *req_root = d;
 	int err;
 
+	lock_kernel();
+
 	sb->s_blocksize = 1024;
 	sb->s_blocksize_bits = 10;
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
@@ -1016,6 +1018,7 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 		goto out;
 	}
 
+	unlock_kernel();
 	return 0;
 
 out_put:
@@ -1023,6 +1026,7 @@ out_put:
 out_free:
 	kfree(host_root_path);
 out:
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index f2feaa0..a7b348a 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -477,11 +477,15 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	int o;
 
+	lock_kernel();
+
 	save_mount_options(s, options);
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = sbi;
 
 	sbi->sb_bmp_dir = NULL;
@@ -666,6 +670,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 			root->i_blocks = 5;
 		hpfs_brelse4(&qbh);
 	}
+	unlock_kernel();
 	return 0;
 
 bail4:	brelse(bh2);
@@ -677,6 +682,7 @@ bail0:
 	kfree(sbi->sb_cp_table);
 	s->s_fs_info = NULL;
 	kfree(sbi);
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index a5089a6..6263973 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -712,6 +712,8 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
 	struct vfsmount *proc_mnt;
 	int err = -ENOENT;
 
+	lock_kernel();
+
 	proc_mnt = do_kern_mount("proc", 0, "proc", NULL);
 	if (IS_ERR(proc_mnt))
 		goto out;
@@ -731,6 +733,7 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
 	if (!sb->s_root)
 		goto out_iput;
 
+	unlock_kernel();
 	return 0;
 
  out_iput:
@@ -738,6 +741,7 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
  out_mntput:
 	mntput(proc_mnt);
  out:
+	unlock_kernel();
 	return(err);
 }
 
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 87a1258..53be2b9 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/ima.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -824,6 +825,7 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct hugetlbfs_config config;
 	struct hugetlbfs_sb_info *sbinfo;
 
+	lock_kernel();
 	save_mount_options(sb, data);
 
 	config.nr_blocks = -1; /* No limit on size by default */
@@ -833,12 +835,16 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 	config.mode = 0755;
 	config.hstate = &default_hstate;
 	ret = hugetlbfs_parse_options(data, &config);
-	if (ret)
+	if (ret) {
+		unlock_kernel();
 		return ret;
+	}
 
 	sbinfo = kmalloc(sizeof(struct hugetlbfs_sb_info), GFP_KERNEL);
-	if (!sbinfo)
+	if (!sbinfo) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbinfo;
 	sbinfo->hstate = config.hstate;
 	spin_lock_init(&sbinfo->stat_lock);
@@ -863,9 +869,11 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free;
 	}
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 out_free:
 	kfree(sbinfo);
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6b4dcd4..7c501d5 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -571,11 +571,15 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
+	lock_kernel();
+
 	save_mount_options(s, data);
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = sbi;
 
 	if (!parse_options((char *)data, &opt))
@@ -895,6 +899,7 @@ root_found:
 
 	kfree(opt.iocharset);
 
+	unlock_kernel();
 	return 0;
 
 	/*
@@ -934,6 +939,7 @@ out_freesbi:
 	kfree(opt.iocharset);
 	kfree(sbi);
 	s->s_fs_info = NULL;
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 9a80e8e..622bd51 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -148,14 +148,19 @@ static const struct super_operations jffs2_super_operations =
 static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct jffs2_sb_info *c;
+	int ret;
+
+	lock_kernel();
 
 	D1(printk(KERN_DEBUG "jffs2_get_sb_mtd():"
 		  " New superblock for device %d (\"%s\")\n",
 		  sb->s_mtd->index, sb->s_mtd->name));
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
-	if (!c)
+	if (!c) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	c->mtd = sb->s_mtd;
 	c->os_priv = sb;
@@ -177,7 +182,9 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_JFFS2_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
-	return jffs2_do_fill_super(sb, data, silent);
+	ret = jffs2_do_fill_super(sb, data, silent);
+	unlock_kernel();
+	return ret;
 }
 
 static int jffs2_get_sb(struct file_system_type *fs_type,
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 2234c73..329d7b6 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -425,14 +425,20 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	s64 newLVSize = 0;
 	int flag, ret = -EINVAL;
 
+	lock_kernel();
+
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
-	if (!new_valid_dev(sb->s_bdev->bd_dev))
+	if (!new_valid_dev(sb->s_bdev->bd_dev)) {
+		unlock_kernel();
 		return -EOVERFLOW;
+	}
 
 	sbi = kzalloc(sizeof (struct jfs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = sbi;
 	sbi->sb = sb;
 	sbi->uid = sbi->gid = sbi->umask = -1;
@@ -442,6 +448,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
 		kfree(sbi);
+		unlock_kernel();
 		return -EINVAL;
 	}
 	sbi->flag = flag;
@@ -452,6 +459,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -527,6 +535,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_maxbytes = min(((u64) PAGE_CACHE_SIZE << 32) - 1, sb->s_maxbytes);
 #endif
 	sb->s_time_gran = 1;
+	unlock_kernel();
 	return 0;
 
 out_no_root:
@@ -548,6 +557,7 @@ out_kfree:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
 	kfree(sbi);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 219576c..3484040 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -11,6 +11,7 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -422,6 +423,8 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	struct dentry *dentry;
 	int i;
 
+	lock_kernel();
+
 	s->s_blocksize = PAGE_CACHE_SIZE;
 	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	s->s_magic = magic;
@@ -429,8 +432,10 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	s->s_time_gran = 1;
 
 	inode = new_inode(s);
-	if (!inode)
+	if (!inode) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	/*
 	 * because the root inode is 1, the files array must not contain an
 	 * entry at index 1
@@ -444,6 +449,7 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	for (i = 0; !files->name || files->name[0]; i++, files++) {
@@ -469,10 +475,12 @@ int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files
 		d_add(dentry, inode);
 	}
 	s->s_root = root;
+	unlock_kernel();
 	return 0;
 out:
 	d_genocide(root);
 	dput(root);
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 74ea82d..b8aa0a6 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -147,9 +147,13 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	struct minix_sb_info *sbi;
 	int ret = -EINVAL;
 
+	lock_kernel();
+
 	sbi = kzalloc(sizeof(struct minix_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = sbi;
 
 	BUILD_BUG_ON(32 != sizeof (struct minix_inode));
@@ -265,6 +269,7 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
  	else if (sbi->s_mount_state & MINIX_ERROR_FS)
 		printk("MINIX-fs: mounting file system with errors, "
 			"running fsck is recommended\n");
+	unlock_kernel();
 	return 0;
 
 out_iput:
@@ -314,6 +319,7 @@ out_bad_sb:
 out:
 	s->s_fs_info = NULL;
 	kfree(sbi);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index bdc3cb4..3f95497 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1647,9 +1647,7 @@ static int do_new_mount(struct path *path, char *type, int flags,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	lock_kernel();
 	mnt = do_kern_mount(type, flags, name, data);
-	unlock_kernel();
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index cf98da1..a020d86 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -445,10 +445,14 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 #endif
 	struct ncp_entry_info finfo;
 
+	lock_kernel();
+
 	data.wdog_pid = NULL;
 	server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
-	if (!server)
+	if (!server) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	sb->s_fs_info = server;
 
 	error = -EFAULT;
@@ -695,6 +699,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
         if (!sb->s_root)
 		goto out_no_root;
 	sb->s_root->d_op = &ncp_root_dentry_operations;
+	unlock_kernel();
 	return 0;
 
 out_no_root:
@@ -729,6 +734,7 @@ out:
 	put_pid(data.wdog_pid);
 	sb->s_fs_info = NULL;
 	kfree(server);
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 90be551..65812a9 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2107,6 +2107,7 @@ static int nfs_get_sb(struct file_system_type *fs_type,
 	};
 	int error = -ENOMEM;
 
+	lock_kernel();
 	data = nfs_alloc_parsed_mount_data(3);
 	mntfh = kzalloc(sizeof(*mntfh), GFP_KERNEL);
 	if (data == NULL || mntfh == NULL)
@@ -2184,6 +2185,7 @@ out:
 out_free_fh:
 	kfree(mntfh);
 	kfree(data);
+	unlock_kernel();
 	return error;
 
 out_err_nosb:
@@ -2227,6 +2229,8 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	};
 	int error;
 
+	lock_kernel();
+
 	dprintk("--> nfs_xdev_get_sb()\n");
 
 	/* create a new volume representation */
@@ -2281,17 +2285,20 @@ static int nfs_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	security_sb_clone_mnt_opts(data->sb, s);
 
 	dprintk("<-- nfs_xdev_get_sb() = 0\n");
+	unlock_kernel();
 	return 0;
 
 out_err_nosb:
 	nfs_free_server(server);
 out_err_noserver:
 	dprintk("<-- nfs_xdev_get_sb() = %d [error]\n", error);
+	unlock_kernel();
 	return error;
 
 error_splat_super:
 	deactivate_locked_super(s);
 	dprintk("<-- nfs_xdev_get_sb() = %d [splat]\n", error);
+	unlock_kernel();
 	return error;
 }
 
@@ -2475,6 +2482,7 @@ static int nfs4_remote_get_sb(struct file_system_type *fs_type,
 	};
 	int error = -ENOMEM;
 
+	lock_kernel();
 	mntfh = kzalloc(sizeof(*mntfh), GFP_KERNEL);
 	if (data == NULL || mntfh == NULL)
 		goto out_free_fh;
@@ -2534,6 +2542,7 @@ out:
 	security_free_mnt_opts(&data->lsm_opts);
 out_free_fh:
 	kfree(mntfh);
+	unlock_kernel();
 	return error;
 
 out_free:
@@ -2660,6 +2669,7 @@ static int nfs4_get_sb(struct file_system_type *fs_type,
 	struct nfs_parsed_mount_data *data;
 	int error = -ENOMEM;
 
+	lock_kernel();
 	data = nfs_alloc_parsed_mount_data(4);
 	if (data == NULL)
 		goto out_free_data;
@@ -2680,6 +2690,7 @@ out_free_data:
 	kfree(data);
 	dprintk("<-- nfs4_get_sb() = %d%s\n", error,
 			error != 0 ? " [error]" : "");
+	unlock_kernel();
 	return error;
 }
 
@@ -2712,6 +2723,8 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	};
 	int error;
 
+	lock_kernel();
+
 	dprintk("--> nfs4_xdev_get_sb()\n");
 
 	/* create a new volume representation */
@@ -2765,17 +2778,20 @@ static int nfs4_xdev_get_sb(struct file_system_type *fs_type, int flags,
 	security_sb_clone_mnt_opts(data->sb, s);
 
 	dprintk("<-- nfs4_xdev_get_sb() = 0\n");
+	unlock_kernel();
 	return 0;
 
 out_err_nosb:
 	nfs_free_server(server);
 out_err_noserver:
 	dprintk("<-- nfs4_xdev_get_sb() = %d [error]\n", error);
+	unlock_kernel();
 	return error;
 
 error_splat_super:
 	deactivate_locked_super(s);
 	dprintk("<-- nfs4_xdev_get_sb() = %d [splat]\n", error);
+	unlock_kernel();
 	return error;
 }
 
@@ -2794,6 +2810,8 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	};
 	int error;
 
+	lock_kernel();
+
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	/* create a new volume representation */
@@ -2847,17 +2865,20 @@ static int nfs4_remote_referral_get_sb(struct file_system_type *fs_type,
 	security_sb_clone_mnt_opts(data->sb, s);
 
 	dprintk("<-- nfs4_referral_get_sb() = 0\n");
+	unlock_kernel();
 	return 0;
 
 out_err_nosb:
 	nfs_free_server(server);
 out_err_noserver:
 	dprintk("<-- nfs4_referral_get_sb() = %d [error]\n", error);
+	unlock_kernel();
 	return error;
 
 error_splat_super:
 	deactivate_locked_super(s);
 	dprintk("<-- nfs4_referral_get_sb() = %d [splat]\n", error);
+	unlock_kernel();
 	return error;
 }
 
@@ -2873,6 +2894,8 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type,
 	struct vfsmount *root_mnt;
 	int error;
 
+	lock_kernel();
+
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	export_path = data->mnt_path;
@@ -2890,6 +2913,7 @@ static int nfs4_referral_get_sb(struct file_system_type *fs_type,
 out:
 	dprintk("<-- nfs4_referral_get_sb() = %d%s\n", error,
 			error != 0 ? " [error]" : "");
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 5c01fc1..9c6917d 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -26,6 +26,7 @@
 #include <linux/inet.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 #include <linux/nfs.h>
 #include <linux/nfsd_idmap.h>
@@ -1347,7 +1348,12 @@ static int nfsd_fill_super(struct super_block * sb, void * data, int silent)
 #endif
 		/* last one */ {""}
 	};
-	return simple_fill_super(sb, 0x6e667364, nfsd_files);
+	int ret;
+
+	lock_kernel();
+	ret = simple_fill_super(sb, 0x6e667364, nfsd_files);
+	unlock_kernel();
+	return ret;
 }
 
 static int nfsd_get_sb(struct file_system_type *fs_type,
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 644e667..3448ec3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1059,9 +1059,13 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	struct the_nilfs *nilfs;
 	int err, need_to_close = 1;
 
+	lock_kernel();
+
 	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
-	if (IS_ERR(sd.bdev))
+	if (IS_ERR(sd.bdev)) {
+		unlock_kernel();
 		return PTR_ERR(sd.bdev);
+	}
 
 	/*
 	 * To get mount instance using sget() vfs-routine, NILFS needs
@@ -1142,6 +1146,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	if (need_to_close)
 		close_bdev_exclusive(sd.bdev, flags);
 	simple_set_mnt(mnt, s);
+	unlock_kernel();
 	return 0;
 
  failed_unlock:
@@ -1150,6 +1155,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
  failed:
 	close_bdev_exclusive(sd.bdev, flags);
 
+	unlock_kernel();
 	return err;
 
  cancel_new:
@@ -1163,6 +1169,7 @@ nilfs_get_sb(struct file_system_type *fs_type, int flags,
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() needs the block device.
 	 */
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 80b0477..ab09c02 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2723,6 +2723,8 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 	struct inode *tmp_ino;
 	int blocksize, result;
 
+	lock_kernel();
+
 	/*
 	 * We do a pretty difficult piece of bootstrap by reading the
 	 * MFT (and other metadata) from disk into memory. We'll only
@@ -2746,6 +2748,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 			ntfs_error(sb, "Allocation of NTFS volume structure "
 					"failed. Aborting mount...");
 		lockdep_on();
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	/* Initialize ntfs_volume structure. */
@@ -2933,6 +2936,7 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 		sb->s_export_op = &ntfs_export_ops;
 		lock_kernel();
 		lockdep_on();
+		unlock_kernel();
 		return 0;
 	}
 	ntfs_error(sb, "Failed to allocate root directory.");
@@ -3053,6 +3057,7 @@ err_out_now:
 	kfree(vol);
 	ntfs_debug("Failed, returning -EINVAL.");
 	lockdep_on();
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 02bf178..670f0fd 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 #include <asm/uaccess.h>
 
@@ -528,21 +529,27 @@ static int dlmfs_fill_super(struct super_block * sb,
 	struct inode * inode;
 	struct dentry * root;
 
+	lock_kernel();
+
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = DLMFS_MAGIC;
 	sb->s_op = &dlmfs_ops;
 	inode = dlmfs_get_root_inode(sb);
-	if (!inode)
+	if (!inode) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c0e48ae..fab815f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -986,6 +986,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	char nodestr[8];
 	struct ocfs2_blockcheck_stats stats;
 
+	lock_kernel();
+
 	mlog_entry("%p, %p, %i", sb, data, silent);
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
@@ -1172,6 +1174,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			atomic_set(&osb->vol_state, VOLUME_DISABLED);
 			wake_up(&osb->osb_mount_event);
 			mlog_exit(status);
+			unlock_kernel();
 			return status;
 		}
 	}
@@ -1186,6 +1189,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	ocfs2_orphan_scan_start(osb);
 
 	mlog_exit(status);
+	unlock_kernel();
 	return status;
 
 read_super_error:
@@ -1201,6 +1205,7 @@ read_super_error:
 	}
 
 	mlog_exit(status);
+	unlock_kernel();
 	return status;
 }
 
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index f3b7c15..ddfbb22 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -416,11 +416,15 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	sector_t start;
 	int ret = -EINVAL;
 
+	lock_kernel();
+
 	save_mount_options(sb, (char *) data);
 
 	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sb->s_fs_info = sbi;
 
@@ -525,6 +529,7 @@ out_brelse_bh2:
 out_brelse_bh:
 	brelse(bh);
 end:
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index ffcd04f..50dc4be 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -386,6 +386,8 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 	struct op_inode_info *oi;
 	int ret;
 
+	lock_kernel();
+
 	s->s_flags |= MS_NOATIME;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -405,6 +407,7 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
 		goto out_no_root_dentry;
+	unlock_kernel();
 	return 0;
 
 out_no_root_dentry:
@@ -412,6 +415,7 @@ out_no_root_dentry:
 	ret = -ENOMEM;
 out_no_root:
 	printk("openprom_fill_super: get root inode failed\n");
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index b080b79..6384680 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/smp_lock.h> /* For lock_kernel() only */
 
 #include "internal.h"
 
@@ -43,6 +44,8 @@ static int proc_get_sb(struct file_system_type *fs_type,
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
 
+	lock_kernel();
+
 	if (proc_mnt) {
 		/* Seed the root directory with a pid so it doesn't need
 		 * to be special in base.c.  I would do this earlier but
@@ -60,14 +63,17 @@ static int proc_get_sb(struct file_system_type *fs_type,
 		ns = current->nsproxy->pid_ns;
 
 	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
-	if (IS_ERR(sb))
+	if (IS_ERR(sb)) {
+		unlock_kernel();
 		return PTR_ERR(sb);
+	}
 
 	if (!sb->s_root) {
 		sb->s_flags = flags;
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
+			unlock_kernel();
 			return err;
 		}
 
@@ -83,6 +89,7 @@ static int proc_get_sb(struct file_system_type *fs_type,
 	}
 
 	simple_set_mnt(mnt, sb);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index d2cd179..18640ce 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -253,9 +253,13 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	struct qnx4_sb_info *qs;
 	int ret = -EINVAL;
 
+	lock_kernel();
+
 	qs = kzalloc(sizeof(struct qnx4_sb_info), GFP_KERNEL);
-	if (!qs)
+	if (!qs) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	s->s_fs_info = qs;
 
 	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
@@ -303,6 +307,7 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 
 	brelse(bh);
 
+	unlock_kernel();
 	return 0;
 
       outi:
@@ -312,6 +317,7 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
       outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a6090aa..9b3983f 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -35,6 +35,7 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h> /* Only for lock_kernel() */
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -220,6 +221,8 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 	struct dentry *root;
 	int err;
 
+	lock_kernel();
+
 	save_mount_options(sb, data);
 
 	fsi = kzalloc(sizeof(struct ramfs_fs_info), GFP_KERNEL);
@@ -253,11 +256,13 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 		goto fail;
 	}
 
+	unlock_kernel();
 	return 0;
 fail:
 	kfree(fsi);
 	sb->s_fs_info = NULL;
 	iput(inode);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index f0ad05f..f32bf62 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1608,6 +1608,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	char *qf_names[MAXQUOTAS] = {};
 	unsigned int qfmt = 0;
 
+	lock_kernel();
+
 	save_mount_options(s, data);
 
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
@@ -1852,6 +1854,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	init_waitqueue_head(&(sbi->s_wait));
 	spin_lock_init(&sbi->bitmap_lock);
 
+	unlock_kernel();
 	return (0);
 
 error:
@@ -1872,6 +1875,7 @@ error:
 	kfree(sbi);
 
 	s->s_fs_info = NULL;
+	unlock_kernel();
 	return errval;
 }
 
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index c117fa8..7342617 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -468,6 +468,8 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	size_t len;
 	int ret;
 
+	lock_kernel();
+
 #ifdef CONFIG_BLOCK
 	if (!sb->s_mtd) {
 		sb_set_blocksize(sb, ROMBSIZE);
@@ -484,8 +486,10 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* read the image superblock and check it */
 	rsb = kmalloc(512, GFP_KERNEL);
-	if (!rsb)
+	if (!rsb) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sb->s_fs_info = (void *) 512;
 	ret = romfs_dev_read(sb, 0, rsb, 512);
@@ -535,15 +539,18 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sb->s_root)
 		goto error_i;
 
+	unlock_kernel();
 	return 0;
 
 error_i:
 	iput(root);
 error:
+	unlock_kernel();
 	return -EINVAL;
 error_rsb_inval:
 	ret = -EINVAL;
 error_rsb:
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 1c4c8f0..c3c9044 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -500,6 +500,8 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 	void *mem;
 	static int warn_count;
 
+	lock_kernel();
+
 	if (warn_count < 5) {
 		warn_count++;
 		printk(KERN_EMERG "smbfs is deprecated and will be removed"
@@ -615,6 +617,7 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 
 	smb_new_dentry(sb->s_root);
 
+	unlock_kernel();
 	return 0;
 
 out_no_root:
@@ -635,9 +638,11 @@ out_wrong_data:
 out_no_data:
 	printk(KERN_ERR "smb_fill_super: missing data argument\n");
 out_fail:
+	unlock_kernel();
 	return -EINVAL;
 out_no_server:
 	printk(KERN_ERR "smb_fill_super: cannot allocate struct smb_sb_info\n");
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 6c197ef..23cea83 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -78,11 +78,14 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	u64 lookup_table_start;
 	int err;
 
+	lock_kernel();
+
 	TRACE("Entered squashfs_fill_superblock\n");
 
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	msblk = sb->s_fs_info;
@@ -286,6 +289,7 @@ allocate_root:
 
 	TRACE("Leaving squashfs_fill_super\n");
 	kfree(sblk);
+	unlock_kernel();
 	return 0;
 
 failed_mount:
@@ -299,12 +303,14 @@ failed_mount:
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 	kfree(sblk);
+	unlock_kernel();
 	return err;
 
 failure:
 	kfree(msblk->stream.workspace);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..2e5a870 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h> /* Only for lock_kernel() */
 
 #include "sysfs.h"
 
@@ -45,6 +46,8 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = SYSFS_MAGIC;
@@ -58,6 +61,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
+		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -66,10 +70,12 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__func__);
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..29cdd3f 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "sysv.h"
 
 /*
@@ -357,7 +358,9 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	struct sysv_sb_info *sbi;
 	unsigned long blocknr;
 	int size = 0, i;
-	
+
+	lock_kernel();
+
 	BUILD_BUG_ON(1024 != sizeof (struct xenix_super_block));
 	BUILD_BUG_ON(512 != sizeof (struct sysv4_super_block));
 	BUILD_BUG_ON(512 != sizeof (struct sysv2_super_block));
@@ -365,8 +368,10 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	BUILD_BUG_ON(64 != sizeof (struct sysv_inode));
 
 	sbi = kzalloc(sizeof(struct sysv_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
@@ -409,8 +414,10 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	if (bh && bh1) {
 		sbi->s_bh1 = bh1;
 		sbi->s_bh2 = bh;
-		if (complete_read_super(sb, silent, size))
+		if (complete_read_super(sb, silent, size)) {
+			unlock_kernel();
 			return 0;
+		}
 	}
 
 	brelse(bh1);
@@ -419,6 +426,7 @@ static int sysv_fill_super(struct super_block *sb, void *data, int silent)
 	printk("oldfs: cannot read superblock\n");
 failed:
 	kfree(sbi);
+	unlock_kernel();
 	return -EINVAL;
 
 Eunknown:
@@ -442,14 +450,18 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	struct v7_super_block *v7sb;
 	struct sysv_inode *v7i;
 
+	lock_kernel();
+
 	if (440 != sizeof (struct v7_super_block))
 		panic("V7 FS: bad super-block size");
 	if (64 != sizeof (struct sysv_inode))
 		panic("sysv fs: bad i-node size");
 
 	sbi = kzalloc(sizeof(struct sysv_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
@@ -487,13 +499,16 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_bh1 = bh;
 	sbi->s_bh2 = bh;
-	if (complete_read_super(sb, silent, 1))
+	if (complete_read_super(sb, silent, 1)) {
+		unlock_kernel();
 		return 0;
+	}
 
 failed:
 	brelse(bh2);
 	brelse(bh);
 	kfree(sbi);
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 333e181..04a0fc9 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2029,6 +2029,8 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	struct super_block *sb;
 	int err;
 
+	lock_kernel();
+
 	dbg_gen("name %s, flags %#x", name, flags);
 
 	/*
@@ -2040,6 +2042,7 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(ubi)) {
 		ubifs_err("cannot open \"%s\", error %d",
 			  name, (int)PTR_ERR(ubi));
+		unlock_kernel();
 		return PTR_ERR(ubi);
 	}
 	ubi_get_volume_info(ubi, &vi);
@@ -2077,12 +2080,14 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	ubi_close_volume(ubi);
 
 	simple_set_mnt(mnt, sb);
+	unlock_kernel();
 	return 0;
 
 out_deact:
 	deactivate_locked_super(sb);
 out_close:
 	ubi_close_volume(ubi);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 9d1b8c2..fa6f8db 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1866,6 +1866,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	struct kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
 
+	lock_kernel();
+
 	uopt.flags = (1 << UDF_FLAG_USE_AD_IN_ICB) | (1 << UDF_FLAG_STRICT);
 	uopt.uid = -1;
 	uopt.gid = -1;
@@ -1874,8 +1876,10 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	uopt.dmode = UDF_INVALID_MODE;
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sb->s_fs_info = sbi;
 
@@ -2021,6 +2025,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	unlock_kernel();
 	return 0;
 
 error_out:
@@ -2041,6 +2046,7 @@ error_out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5faed79..31ad198 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -646,6 +646,8 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned maxsymlen;
 	int ret = -EINVAL;
 
+	lock_kernel();
+
 	uspi = NULL;
 	ubh = NULL;
 	flags = 0;
@@ -1107,6 +1109,7 @@ magic_found:
 			goto failed;
 
 	UFSD("EXIT\n");
+	unlock_kernel();
 	return 0;
 
 dalloc_failed:
@@ -1118,10 +1121,12 @@ failed:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
+	unlock_kernel();
 	return ret;
 
 failed_nomem:
 	UFSD("EXIT (NOMEM)\n");
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 18a4b8e..7426166 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1412,6 +1412,8 @@ xfs_fs_fill_super(
 	int			flags = 0, error = ENOMEM;
 	char			*mtpt = NULL;
 
+	lock_kernel();
+
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		goto out;
@@ -1506,6 +1508,7 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
+	unlock_kernel();
 	return 0;
 
  out_filestream_unmount:
@@ -1522,6 +1525,7 @@ xfs_fs_fill_super(
 	kfree(mtpt);
 	kfree(mp);
  out:
+	unlock_kernel();
 	return -error;
 
  fail_vnrele:
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ee9d697..fb9d70d 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -33,6 +33,7 @@
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
 #include <linux/ima.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include <net/sock.h>
 #include "util.h"
@@ -190,6 +191,8 @@ static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 	struct ipc_namespace *ns = data;
 	int error = 0;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = MQUEUE_MAGIC;
@@ -209,6 +212,7 @@ static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 out:
+	unlock_kernel();
 	return error;
 }
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ca83b73..d3ee2ac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1290,6 +1290,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct cgroupfs_root *new_root;
 
+	lock_kernel();
+
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
@@ -1410,6 +1412,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	simple_set_mnt(mnt, sb);
 	kfree(opts.release_agent);
 	kfree(opts.name);
+	unlock_kernel();
 	return 0;
 
  drop_new_super:
@@ -1417,6 +1420,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
  out_err:
 	kfree(opts.release_agent);
 	kfree(opts.name);
+	unlock_kernel();
 
 	return ret;
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b5cb469..f1f0599 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -53,6 +53,7 @@
 #include <linux/time.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -237,6 +238,8 @@ static int cpuset_get_sb(struct file_system_type *fs_type,
 {
 	struct file_system_type *cgroup_fs = get_fs_type("cgroup");
 	int ret = -ENODEV;
+
+	lock_kernel();
 	if (cgroup_fs) {
 		char mountopts[] =
 			"cpuset,noprefix,"
@@ -245,6 +248,7 @@ static int cpuset_get_sb(struct file_system_type *fs_type,
 					   unused_dev_name, mountopts, mnt);
 		put_filesystem(cgroup_fs);
 	}
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 356dd99..98f744b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/ima.h>
+#include <linux/smp_lock.h>     /* For lock_kernel() */
 
 static struct vfsmount *shm_mnt;
 
@@ -2309,11 +2310,15 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	struct shmem_sb_info *sbinfo;
 	int err = -ENOMEM;
 
+	lock_kernel();
+
 	/* Round up to L1_CACHE_BYTES to resist false sharing */
 	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
 				L1_CACHE_BYTES), GFP_KERNEL);
-	if (!sbinfo)
+	if (!sbinfo) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	sbinfo->mode = S_IRWXUGO | S_ISVTX;
 	sbinfo->uid = current_fsuid();
@@ -2363,12 +2368,14 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root)
 		goto failed_iput;
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 
 failed_iput:
 	iput(inode);
 failed:
 	shmem_put_super(sb);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 49278f8..1f0f730 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include <asm/ioctls.h>
 #include <linux/fs.h>
@@ -990,6 +991,8 @@ rpc_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
+	lock_kernel();
+
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = RPCAUTH_GSSMAGIC;
@@ -997,20 +1000,25 @@ rpc_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 
 	inode = rpc_get_inode(sb, S_IFDIR | 0755);
-	if (!inode)
+	if (!inode) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
+		unlock_kernel();
 		return -ENOMEM;
 	}
 	if (rpc_populate(root, files, RPCAUTH_lockd, RPCAUTH_RootEOF, NULL))
 		goto out;
 	sb->s_root = root;
+	unlock_kernel();
 	return 0;
 out:
 	d_genocide(root);
 	dput(root);
+	unlock_kernel();
 	return -ENOMEM;
 }
 
diff --git a/security/inode.c b/security/inode.c
index f7496c6..f2d02a5 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -21,6 +21,7 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 static struct vfsmount *mount;
 static int mount_count;
@@ -125,8 +126,12 @@ static inline int positive(struct dentry *dentry)
 static int fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr files[] = {{""}};
+	int res;
 
-	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
+	lock_kernel();
+	res = simple_fill_super(sb, SECURITYFS_MAGIC, files);
+	unlock_kernel();
+	return res;
 }
 
 static int get_sb(struct file_system_type *fs_type,
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index b4fc506..1c16ea6 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -28,6 +28,7 @@
 #include <linux/percpu.h>
 #include <linux/audit.h>
 #include <linux/uaccess.h>
+#include <linux/smp_lock.h>
 
 /* selinuxfs pseudo filesystem for exporting the security policy API.
    Based on the proc code and the fs/nfsd/nfsctl.c code. */
@@ -1598,6 +1599,9 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 		[SEL_DENY_UNKNOWN] = {"deny_unknown", &sel_handle_unknown_ops, S_IRUGO},
 		/* last one */ {""}
 	};
+
+	lock_kernel();
+
 	ret = simple_fill_super(sb, SELINUX_MAGIC, selinux_files);
 	if (ret)
 		goto err;
@@ -1690,6 +1694,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 	policycap_dir = dentry;
 
 out:
+	unlock_kernel();
 	return ret;
 err:
 	printk(KERN_ERR "SELinux: %s:  failed while creating inodes\n",
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index aeead75..ceebf2a 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -26,6 +26,7 @@
 #include <linux/seq_file.h>
 #include <linux/ctype.h>
 #include <linux/audit.h>
+#include <linux/smp_lock.h>	/* For lock_kernel() */
 #include "smack.h"
 
 /*
@@ -1290,16 +1291,19 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 		/* last one */ {""}
 	};
 
+	lock_kernel();
 	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
 	if (rc != 0) {
 		printk(KERN_ERR "%s failed %d while creating inodes\n",
 			__func__, rc);
+		unlock_kernel();
 		return rc;
 	}
 
 	root_inode = sb->s_root->d_inode;
 	root_inode->i_security = new_inode_smack(smack_known_floor.smk_known);
 
+	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.4.2


--ogUXNSQj4OI1q3LQ--
