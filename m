Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbZLGTJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbZLGTJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZLGTJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:09:46 -0500
Received: from thunk.org ([69.25.196.29]:42913 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZLGTJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:09:45 -0500
Date: Mon, 7 Dec 2009 14:09:47 -0500
From: tytso@mit.edu
To: Philip Wernersbach <philip.wernersbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2/3 as ext4
Message-ID: <20091207190947.GF27692@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Philip Wernersbach <philip.wernersbach@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 08:30:36PM -0500, Philip Wernersbach wrote:
> Hello Everyone,
>      Below is a small patch I wrote for kernel version 2.6.31.6. It
> causes ext2/3 filesystems to be mounted using the ext4 driver, in a
> way that is transparent to the userspace (and kernelspace for that
> matter, as long as the code uses the kernel's mounting API) and
> requires no change to the userspace (/kernelspace). This patch is
> useful because: 1) It allows minimalist kernel fanatics, like myself,
> to drop 2 drivers from their builds without any loss in functionality.
> 2) It allows the ext2/3 filesystems to take advantage of the
> performance/general improvements in the ext4 driver. 3) In the future,
> with this patch, the ext2/3 driver code could be dropped from the
> kernel without any loss in functionality.

Here's a much cleaner patch which achieves the same goal...

       	      	      	    	  	   - Ted

commit 46b5cb9a4a4c7cf8735ab0f7ae0c876664e750cb
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 7 14:08:51 2009 -0500

    ext4: Use ext4 file system driver for ext2/ext3 file system mounts
    
    Add a new config option, CONFIG_EXT4_USE_FOR_EXT23 which if enabled,
    will cause ext4 to be used for either ext2 or ext3 file system mounts
    when ext2 or ext3 is not enabled in the configuration.
    
    This allows minimalist kernel fanatics to drop to file system drivers
    from their compiled kernel with out losing functionality.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9f2d45d..a6b4e93 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -26,6 +26,16 @@ config EXT4_FS
 
 	  If unsure, say N.
 
+config EXT4_USE_FOR_EXT23
+	bool "Use ext4 for ext2/ext3 file systems"
+	depends on !EXT3_FS || !EXT2_FS
+	default y
+	help
+	  Allow the ext4 file system driver code to be used for ext2 or
+	  ext3 file system mounts.  This allows users to reduce their
+	  compiled kernel size by using one file system driver for
+	  ext2, ext3, and ext4 file systems.
+
 config EXT4_FS_XATTR
 	bool "Ext4 extended attributes"
 	depends on EXT4_FS
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5a2db61..30476da 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3960,6 +3960,58 @@ static int ext4_get_sb(struct file_system_type *fs_type, int flags,
 	return get_sb_bdev(fs_type, flags, dev_name, data, ext4_fill_super,mnt);
 }
 
+#if !defined(CONTIG_EXT2_FS) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+static struct file_system_type ext2_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "ext2",
+	.get_sb		= ext4_get_sb,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+static inline void register_as_ext2(void)
+{
+	int err = register_filesystem(&ext2_fs_type);
+	if (err)
+		printk(KERN_WARNING
+		       "EXT4-fs: Unable to register as ext2 (%d)\n", err);
+}
+
+static inline void unregister_as_ext2(void)
+{
+	unregister_filesystem(&ext2_fs_type);
+}
+#else
+static inline void register_as_ext2(void) { }
+static inline void unregister_as_ext2(void) { }
+#endif
+
+#if !defined(CONTIG_EXT3_FS) && defined(CONFIG_EXT4_USE_FOR_EXT23)
+static struct file_system_type ext3_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "ext3",
+	.get_sb		= ext4_get_sb,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+static inline void register_as_ext3(void)
+{
+	int err = register_filesystem(&ext3_fs_type);
+	if (err)
+		printk(KERN_WARNING
+		       "EXT4-fs: Unable to register as ext3 (%d)\n", err);
+}
+
+static inline void unregister_as_ext3(void)
+{
+	unregister_filesystem(&ext3_fs_type);
+}
+#else
+static inline void register_as_ext3(void) { }
+static inline void unregister_as_ext3(void) { }
+#endif
+
 static struct file_system_type ext4_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ext4",
@@ -3989,11 +4041,15 @@ static int __init init_ext4_fs(void)
 	err = init_inodecache();
 	if (err)
 		goto out1;
+	register_as_ext2();
+	register_as_ext3();
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
 	return 0;
 out:
+	unregister_as_ext2();
+	unregister_as_ext3();
 	destroy_inodecache();
 out1:
 	exit_ext4_xattr();
@@ -4009,6 +4065,8 @@ out4:
 
 static void __exit exit_ext4_fs(void)
 {
+	unregister_as_ext2();
+	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
 	destroy_inodecache();
 	exit_ext4_xattr();
