Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZAXGf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZAXGf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 01:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZAXGfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 01:35:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:35466 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbZAXGft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 01:35:49 -0500
Subject: Re: usr/include/linux/reiserfs_fs.h is having lot of KERNEL data
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: reiserfs-devel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232465242.3088.25.camel@localhost.localdomain>
References: <1232465242.3088.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 12:05:34 +0530
Message-Id: <1232778934.10414.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 20:57 +0530, Jaswinder Singh Rajput wrote:
> usr/include/linux/reiserfs_fs.h is giving 21 'make headers_clean' warnings:
>  usr/include/linux/reiserfs_fs.h:64: leaks CONFIG_REISERFS to userspace where it is not valid
>  usr/include/linux/reiserfs_fs.h:81: leaks CONFIG_REISERFS to userspace where it is not valid
>  usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1587: leaks CONFIG_QUOTA to userspace where it is not valid
>  usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace 
>  usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1908: leaks CONFIG_PROC to userspace where it is not valid
>  usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
>  usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace
> 
> This file is huge and need lot of cleanup.
> 


If no one have any objections can I forward this patch to fix above
warnings:

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index bc5114d..4dae991 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -74,9 +74,7 @@ struct fid;
 // FIXME: do not change 4 by anything else: there is code which relies on that
 #define ROUND_UP(x) _ROUND_UP(x,8LL)
 
-/* debug levels.  Right now, CONFIG_REISERFS_CHECK means print all debug
-** messages.
-*/
+/* debug levels.  Right now, REISERFS_CHECK means print all debug messages */
 #define REISERFS_DEBUG_CODE 5	/* extra messages to help find/debug errors */
 
 void reiserfs_warning(struct super_block *s, const char *fmt, ...);
@@ -91,11 +89,13 @@ if( !( cond ) ) 								\
 
 #define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
 
+#ifdef __KERNEL__
 #if defined( CONFIG_REISERFS_CHECK )
 #define RFALSE(cond, format, args...) __RASSERT(!(cond), "!(" #cond ")", format, ##args)
 #else
 #define RFALSE( cond, format, args... ) do {;} while( 0 )
 #endif
+#endif
 
 #define CONSTF __attribute_const__
 /*
@@ -698,7 +698,9 @@ static inline void cpu_key_k_offset_dec(struct cpu_key *key)
 /* object identifier for root dir */
 #define REISERFS_ROOT_OBJECTID 2
 #define REISERFS_ROOT_PARENT_OBJECTID 1
+#ifdef __KERNEL__
 extern struct reiserfs_key root_key;
+#endif /* __KERNEL__ */
 
 /* 
  * Picture represents a leaf of the S+tree
@@ -1006,10 +1008,12 @@ struct reiserfs_de_head {
 #define de_visible(deh)	    	    test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 #define de_hidden(deh)	    	    !test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 
+#ifdef __KERNEL__
 extern void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
 				   __le32 par_dirid, __le32 par_objid);
 extern void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
 				__le32 par_dirid, __le32 par_objid);
+#endif /* __KERNEL__ */
 
 /* array of the entry headers */
  /* get item body */
@@ -1478,7 +1482,9 @@ struct item_operations {
 	void (*print_vi) (struct virtual_item * vi);
 };
 
+#ifdef __KERNEL__
 extern struct item_operations *item_ops[TYPE_ANY + 1];
+#endif /* __KERNEL__ */
 
 #define op_bytes_number(ih,bsize)                    item_ops[le_ih_k_type (ih)]->bytes_number (ih, bsize)
 #define op_is_left_mergeable(key,bsize)              item_ops[le_key_k_type (le_key_version (key), key)]->is_left_mergeable (key, bsize)
@@ -1598,6 +1604,7 @@ struct reiserfs_journal_header {
 #define JOURNAL_MAX_COMMIT_AGE 30
 #define JOURNAL_MAX_TRANS_AGE 30
 #define JOURNAL_PER_BALANCE_CNT (3 * (MAX_HEIGHT-2) + 9)
+#ifdef __KERNEL__
 #ifdef CONFIG_QUOTA
 /* We need to update data and inode (atime) */
 #define REISERFS_QUOTA_TRANS_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & (1<<REISERFS_QUOTA) ? 2 : 0)
@@ -1612,6 +1619,7 @@ struct reiserfs_journal_header {
 #define REISERFS_QUOTA_INIT_BLOCKS(s) 0
 #define REISERFS_QUOTA_DEL_BLOCKS(s) 0
 #endif
+#endif /* __KERNEL__ */
 
 /* both of these can be as low as 1, or as high as you want.  The min is the
 ** number of 4k bitmap nodes preallocated on mount. New nodes are allocated
@@ -1688,6 +1696,7 @@ struct reiserfs_jh {
 	struct list_head list;
 };
 
+#ifdef __KERNEL__
 void reiserfs_free_jh(struct buffer_head *bh);
 int reiserfs_add_tail_list(struct inode *inode, struct buffer_head *bh);
 int reiserfs_add_ordered_list(struct inode *inode, struct buffer_head *bh);
@@ -2203,4 +2212,5 @@ int reiserfs_unpack(struct inode *inode, struct file *filp);
 /* xattr stuff */
 #define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
 
+#endif /* __KERNEL__ */
 #endif				/* _LINUX_REISER_FS_H */

--
JSR

