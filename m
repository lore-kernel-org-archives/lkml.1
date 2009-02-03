Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZBCOfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZBCOfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZBCOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:34:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:45497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZBCOez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:34:55 -0500
Subject: [git pull -tip] headers_check fix cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 20:03:37 +0530
Message-Id: <1233671617.27322.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patchset is based on Arnd Bergmann suggestions:

The following changes since commit 87fe85133fa7f33c2bc9882826666a7f117c62bd:
  Ingo Molnar (1):
        Merge branch 'core/header-fixes' of git://git.kernel.org/.../jaswinder/linux-2.6-tipclean into core/header-fixes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git core/header-fixes

Jaswinder Singh Rajput (3):
      headers_check fix cleanup: linux/coda_psdev.h
      headers_check fix cleanup: linux/nubus.h
      headers_check fix cleanup: linux/reiserfs_fs.h

 include/linux/coda_psdev.h  |    2 +-
 include/linux/nubus.h       |    2 +-
 include/linux/reiserfs_fs.h |   62 +++++++++++++++++++-----------------------
 3 files changed, 30 insertions(+), 36 deletions(-)

Complete diff:
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 6f06352..5b5d473 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -6,6 +6,7 @@
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
 
+#ifdef __KERNEL__
 struct kstatfs;
 
 /* communication pending/processing queues */
@@ -24,7 +25,6 @@ static inline struct venus_comm *coda_vcp(struct super_block *sb)
 	return (struct venus_comm *)((sb)->s_fs_info);
 }
 
-#ifdef __KERNEL__
 /* upcalls */
 int venus_rootfid(struct super_block *sb, struct CodaFid *fidp);
 int venus_getattr(struct super_block *sb, struct CodaFid *fid,
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index 9be57d9..e137b3c 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -237,6 +237,7 @@ struct nubus_dirent
 	int mask;
 };
 
+#ifdef __KERNEL__
 struct nubus_board {
 	struct nubus_board* next;
 	struct nubus_dev* first_dev;
@@ -296,7 +297,6 @@ struct nubus_dev {
 	struct nubus_board* board;
 };
 
-#ifdef __KERNEL__
 /* This is all NuBus devices (used to find devices later on) */
 extern struct nubus_dev* nubus_devices;
 /* This is all NuBus cards */
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index a4db55f..e356c99 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -28,8 +28,6 @@
 #include <linux/reiserfs_fs_sb.h>
 #endif
 
-struct fid;
-
 /*
  *  include/linux/reiser_fs.h
  *
@@ -37,6 +35,33 @@ struct fid;
  *
  */
 
+/* ioctl's command */
+#define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
+/* define following flags to be the same as in ext2, so that chattr(1),
+   lsattr(1) will work with us. */
+#define REISERFS_IOC_GETFLAGS		FS_IOC_GETFLAGS
+#define REISERFS_IOC_SETFLAGS		FS_IOC_SETFLAGS
+#define REISERFS_IOC_GETVERSION		FS_IOC_GETVERSION
+#define REISERFS_IOC_SETVERSION		FS_IOC_SETVERSION
+
+#ifdef __KERNEL__
+/* the 32 bit compat definitions with int argument */
+#define REISERFS_IOC32_UNPACK		_IOW(0xCD, 1, int)
+#define REISERFS_IOC32_GETFLAGS		FS_IOC32_GETFLAGS
+#define REISERFS_IOC32_SETFLAGS		FS_IOC32_SETFLAGS
+#define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
+#define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
+
+/* Locking primitives */
+/* Right now we are still falling back to (un)lock_kernel, but eventually that
+   would evolve into real per-fs locks */
+#define reiserfs_write_lock( sb ) lock_kernel()
+#define reiserfs_write_unlock( sb ) unlock_kernel()
+
+/* xattr stuff */
+#define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
+struct fid;
+
 /* in reading the #defines, it may help to understand that they employ
    the following abbreviations:
 
@@ -698,9 +723,8 @@ static inline void cpu_key_k_offset_dec(struct cpu_key *key)
 /* object identifier for root dir */
 #define REISERFS_ROOT_OBJECTID 2
 #define REISERFS_ROOT_PARENT_OBJECTID 1
-#ifdef __KERNEL__
+
 extern struct reiserfs_key root_key;
-#endif /* __KERNEL__ */
 
 /* 
  * Picture represents a leaf of the S+tree
@@ -1008,12 +1032,10 @@ struct reiserfs_de_head {
 #define de_visible(deh)	    	    test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 #define de_hidden(deh)	    	    !test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 
-#ifdef __KERNEL__
 extern void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
 				   __le32 par_dirid, __le32 par_objid);
 extern void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
 				__le32 par_dirid, __le32 par_objid);
-#endif /* __KERNEL__ */
 
 /* array of the entry headers */
  /* get item body */
@@ -1482,9 +1504,7 @@ struct item_operations {
 	void (*print_vi) (struct virtual_item * vi);
 };
 
-#ifdef __KERNEL__
 extern struct item_operations *item_ops[TYPE_ANY + 1];
-#endif /* __KERNEL__ */
 
 #define op_bytes_number(ih,bsize)                    item_ops[le_ih_k_type (ih)]->bytes_number (ih, bsize)
 #define op_is_left_mergeable(key,bsize)              item_ops[le_key_k_type (le_key_version (key), key)]->is_left_mergeable (key, bsize)
@@ -1546,7 +1566,6 @@ struct reiserfs_iget_args {
 /*                    FUNCTION DECLARATIONS                                */
 /***************************************************************************/
 
-/*#ifdef __KERNEL__*/
 #define get_journal_desc_magic(bh) (bh->b_data + bh->b_size - 12)
 
 #define journal_trans_half(blocksize) \
@@ -1685,7 +1704,6 @@ struct reiserfs_transaction_handle {
 	struct list_head t_list;
 };
 
-#ifdef __KERNEL__
 /* used to keep track of ordered and tail writes, attached to the buffer
  * head through b_journal_head.
  */
@@ -2185,30 +2203,6 @@ long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 int reiserfs_unpack(struct inode *inode, struct file *filp);
 
-/* ioctl's command */
-#define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
-/* define following flags to be the same as in ext2, so that chattr(1),
-   lsattr(1) will work with us. */
-#define REISERFS_IOC_GETFLAGS		FS_IOC_GETFLAGS
-#define REISERFS_IOC_SETFLAGS		FS_IOC_SETFLAGS
-#define REISERFS_IOC_GETVERSION		FS_IOC_GETVERSION
-#define REISERFS_IOC_SETVERSION		FS_IOC_SETVERSION
-
-/* the 32 bit compat definitions with int argument */
-#define REISERFS_IOC32_UNPACK		_IOW(0xCD, 1, int)
-#define REISERFS_IOC32_GETFLAGS		FS_IOC32_GETFLAGS
-#define REISERFS_IOC32_SETFLAGS		FS_IOC32_SETFLAGS
-#define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
-#define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
-
-/* Locking primitives */
-/* Right now we are still falling back to (un)lock_kernel, but eventually that
-   would evolve into real per-fs locks */
-#define reiserfs_write_lock( sb ) lock_kernel()
-#define reiserfs_write_unlock( sb ) unlock_kernel()
-
-/* xattr stuff */
-#define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
 
 #endif /* __KERNEL__ */
 #endif				/* _LINUX_REISER_FS_H */


