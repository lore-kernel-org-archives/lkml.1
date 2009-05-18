Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZERUlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZERUlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZERUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:40:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZERUku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:40:50 -0400
Date: Mon, 18 May 2009 16:40:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
Subject: [PATCH] Userland for VFS based Union Mount (V3)
Message-ID: <20090518204019.GC15754@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFS union mount patches require some changes to util-linux and
e2fsprogs to support the union mount option and the ext2 whiteout
feature flag.  We are not submitting them for formal review at this
time, but the patches are below for quick reference.  They are also
available in git repos linked to from the Union Mount HOWTO page:

http://valerieaurora.org/union/

-VAL

>From f24983a535b99a9f764b01855c2e51fc32984195 Mon Sep 17 00:00:00 2001
From: Valerie Aurora Henson <vaurora@redhat.com>
Date: Sat, 21 Mar 2009 20:56:57 -0700
Subject: [PATCH 1/1] union mount patches from:

ftp://ftp.suse.com/pub/people/jblunck/union-mount/util-linux-2.13-union_mount.diff
---
 mount/mount.c           |    5 +++++
 mount/mount_constants.h |    3 +++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mount/mount.c b/mount/mount.c
index 9cbc466..9bf766b 100644
--- a/mount/mount.c
+++ b/mount/mount.c
@@ -138,6 +138,7 @@ static const struct opt_map opt_map[] = {
   { "sync",	0, 0, MS_SYNCHRONOUS},	/* synchronous I/O */
   { "async",	0, 1, MS_SYNCHRONOUS},	/* asynchronous I/O */
   { "dirsync",	0, 0, MS_DIRSYNC},	/* synchronous directory modifications */
+  { "union",	0, 0, MS_UNION  },	/* Union mount */
   { "remount",  0, 0, MS_REMOUNT},      /* Alter flags of mounted FS */
   { "bind",	0, 0, MS_BIND   },	/* Remount part of tree elsewhere */
   { "rbind",	0, 0, MS_BIND|MS_REC }, /* Idem, plus mounted subtrees */
@@ -1638,6 +1639,7 @@ static struct option longopts[] = {
 	{ "make-rslave", 0, 0, 141 },
 	{ "make-rprivate", 0, 0, 142 },
 	{ "make-runbindable", 0, 0, 143 },
+	{ "union", 0, 0, 144 },
 	{ "internal-only", 0, 0, 'i' },
 	{ NULL, 0, 0, 0 }
 };
@@ -1929,6 +1931,9 @@ main(int argc, char *argv[]) {
 		case 143:
 			mounttype = (MS_UNBINDABLE | MS_REC);
 			break;
+		case 144: /* union */
+			mounttype = MS_UNION;
+			break;
 
 		case '?':
 		default:
diff --git a/mount/mount_constants.h b/mount/mount_constants.h
index dc3ca27..fb4c663 100644
--- a/mount/mount_constants.h
+++ b/mount/mount_constants.h
@@ -39,6 +39,9 @@ flags had been set; if we have a union with more than one element - fail;
 if we have a stack or plain mount - mount atop of it, forming a stack. */
 #define	MS_OVER		0x200	/* 512 */
 #endif
+#ifndef MS_UNION
+#define MS_UNION	0x100	/* 256: Mount on top of a union */
+#endif
 #ifndef MS_NOATIME
 #define MS_NOATIME	0x400	/* 1024: Do not update access times. */
 #endif
-- 
1.6.0.6

>From 548331c4129420bf61b67b8019e99e4799b0c421 Mon Sep 17 00:00:00 2001
From: Valerie Aurora Henson <vaurora@redhat.com>
Date: Sat, 21 Mar 2009 12:51:33 -0700
Subject: [PATCH 1/1] union mount patches from:

ftp://ftp.suse.com/pub/people/jblunck/union-mount/e2fsprogs-1.40.2-whiteout.diff
---
 e2fsck/e2fsck.c      |    1 +
 e2fsck/e2fsck.h      |    1 +
 e2fsck/pass1.c       |    7 +++++++
 e2fsck/pass2.c       |    4 +++-
 e2fsck/util.c        |    3 +++
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    7 +++++--
 lib/ext2fs/ext2fs.h  |    6 +++++-
 misc/tune2fs.8.in    |   13 ++++++++++++-
 misc/tune2fs.c       |   26 +++++++++++++++++++++++++-
 10 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 2ba72c8..c1835ab 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -145,6 +145,7 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 	ctx->fs_total_count = 0;
 	ctx->fs_badblocks_count = 0;
 	ctx->fs_sockets_count = 0;
+	ctx->fs_whiteouts_count = 0;
 	ctx->fs_ind_count = 0;
 	ctx->fs_dind_count = 0;
 	ctx->fs_tind_count = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 96b83da..9cd017f 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -319,6 +319,7 @@ struct e2fsck_struct {
 	__u32 fs_total_count;
 	__u32 fs_badblocks_count;
 	__u32 fs_sockets_count;
+	__u32 fs_whiteouts_count;
 	__u32 fs_ind_count;
 	__u32 fs_dind_count;
 	__u32 fs_tind_count;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index bed1ec8..6fbf60f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -905,6 +905,13 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_sockets_count++;
+		} else if ((ctx->fs->super->s_feature_incompat &
+			    EXT2_FEATURE_INCOMPAT_WHITEOUT) &&
+			   LINUX_S_ISWHT (inode->i_mode) &&
+			   e2fsck_pass1_check_device_inode(fs, inode)) {
+			check_immutable(ctx, &pctx);
+			check_size(ctx, &pctx);
+			ctx->fs_whiteouts_count++;
 		} else
 			mark_inode_bad(ctx, ino);
 		if (inode->i_block[EXT2_IND_BLOCK])
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 5e088e2..3a6a996 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1210,7 +1210,9 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	if (!LINUX_S_ISDIR(inode.i_mode) && !LINUX_S_ISREG(inode.i_mode) &&
 	    !LINUX_S_ISCHR(inode.i_mode) && !LINUX_S_ISBLK(inode.i_mode) &&
 	    !LINUX_S_ISLNK(inode.i_mode) && !LINUX_S_ISFIFO(inode.i_mode) &&
-	    !(LINUX_S_ISSOCK(inode.i_mode)))
+	    !LINUX_S_ISSOCK(inode.i_mode) &&
+	    !((ctx->fs->super->s_feature_incompat &
+	       EXT2_FEATURE_INCOMPAT_WHITEOUT) && LINUX_S_ISWHT(inode.i_mode)))
 		problem = PR_2_BAD_MODE;
 	else if (LINUX_S_ISCHR(inode.i_mode)
 		 && !e2fsck_pass1_check_device_inode(fs, &inode))
diff --git a/e2fsck/util.c b/e2fsck/util.c
index f761ebb..5e431f8 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -500,5 +500,8 @@ int ext2_file_type(unsigned int mode)
 	if (LINUX_S_ISSOCK(mode))
 		return EXT2_FT_SOCK;
 	
+	if (LINUX_S_ISWHT(mode))
+		return EXT2_FT_WHT;
+
 	return 0;
 }
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index fe7e65a..c6780d5 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -63,6 +63,8 @@ static struct feature feature_list[] = {
 			"extents" },
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_META_BG,
 			"meta_bg" },
+	{       E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_WHITEOUT,
+			"whiteout" },
 	{	E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..3275c39 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -637,13 +637,15 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004 /* Needs recovery */
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
#define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
@@ -705,8 +707,9 @@ struct ext2_dir_entry_2 {
 #define EXT2_FT_FIFO		5
 #define EXT2_FT_SOCK		6
 #define EXT2_FT_SYMLINK		7
+#define EXT2_FT_WHT		8
 
-#define EXT2_FT_MAX		8
+#define EXT2_FT_MAX		9
 
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7645210..82094d3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -357,8 +357,9 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
  * non-Linux system.
  */
 #define LINUX_S_IFMT  00170000
+#define LINUX_S_IFWHT  0160000
 #define LINUX_S_IFSOCK 0140000
-#define LINUX_S_IFLNK	 0120000
+#define LINUX_S_IFLNK  0120000
 #define LINUX_S_IFREG  0100000
 #define LINUX_S_IFBLK  0060000
 #define LINUX_S_IFDIR  0040000
@@ -390,6 +391,7 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
 #define LINUX_S_ISBLK(m)	(((m) & LINUX_S_IFMT) == LINUX_S_IFBLK)
 #define LINUX_S_ISFIFO(m)	(((m) & LINUX_S_IFMT) == LINUX_S_IFIFO)
 #define LINUX_S_ISSOCK(m)	(((m) & LINUX_S_IFMT) == LINUX_S_IFSOCK)
+#define LINUX_S_ISWHT(m)	(((m) & LINUX_S_IFMT) == LINUX_S_IFWHT)
 
 /*
  * ext2 size of an inode
@@ -449,12 +451,14 @@ typedef struct ext2_icount *ext2_icount_t;
  #warning "Compression suFEATURE_INCOMPAT_WHITEOUT|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER)
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 2e617db..b2542a9 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -392,12 +392,18 @@ option.
 .TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
+.TP
+.B whiteout
+For union mounted filesystems support the whiteout filetype to store metadata
+about removed files in a union.
 .RE
 .IP
 After setting or clearing 
 .B sparse_super
-and 
+,
 .B filetype 
+or
+.B whiteout
 filesystem features,
 .BR e2fsck (8)
 must be run on the filesystem to return the filesystem to a consistent state.
@@ -415,6 +421,11 @@ Linux kernels before 2.0.39 and many 2.1 series kernels do not support
 the filesystems that use any of these features.
 Enabling certain filesystem features may prevent the filesystem from
 being mounted by kernels which do not support those features.
+.IP
+.B Warning:
+Linux kernels without union mount patches do not support the whiteout
+filesystem feature. Enabling this feature prevents the filesystem from
+being mounted by kernels without union mount support.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 833b994..bad9736 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -97,7 +97,8 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
-	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
+	EXT2_FEATURE_INCOMPAT_FILETYPE |
+		EXT2_FEATURE_INCOMPAT_WHITEOUT,	/* Incompat */
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
 };
 
@@ -283,6 +284,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 {
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir;
+	int whiteout, old_whiteout;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
 
@@ -298,6 +300,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	old_dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	old_whiteout = sb->s_feature_incompat &
+		EXT2_FEATURE_INCOMPAT_WHITEOUT;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -312,6 +316,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	dxdir = sb->s_feature_compat &
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
+	whiteout = sb->s_feature_incompat &
+		EXT2_FEATURE_INCOMPAT_WHITEOUT;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -352,6 +358,24 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		if (uuid_is_null((unsigned char *) sb->s_hash_seed))
 			uuid_generate((unsigned char *) sb->s_hash_seed);
 	}
+	if (old_whiteout && !whiteout) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The whiteout flag may only be "
+				"cleared when the filesystem is\n"
+				"unmounted.\n"), stderr);
+			exit(1);
+		}
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nWhiteout superblock flag cleared.  %s"),
+		       _(please_fsck));
+	}
+	if (whiteout && !old_whiteout) {
+		//sb->s_feature_incompat |=
+		//	EXT2_FEATURE_INCOMPAT_WHITEOUT;
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nWhiteout superblock flag set.  %s"),
+		       _(please_fsck));
+	}
 
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
-- 
1.6.0.6


