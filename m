Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZLKEgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZLKEgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZLKEgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:11 -0500
Received: from kroah.org ([198.145.64.141]:52895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360AbZLKEfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:42 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:31 2009
Message-Id: <20091211042730.719283784@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [11/90] ext4: Add feature set check helper for mount & remount paths
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0011-ext4-Add-feature-set-check-helper-for-mount-remount-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit a13fb1a4533f26c1e2b0204d5283b696689645af)

A user reported that although his root ext4 filesystem was mounting
fine, other filesystems would not mount, with the:

"Filesystem with huge files cannot be mounted RDWR without CONFIG_LBDAF"

error on his 32-bit box built without CONFIG_LBDAF.  This is because
the test at mount time for this situation was not being re-checked
on remount, and the normal boot process makes an ro->rw transition,
so this was being missed.

Refactor to make a common helper function to test the filesystem
features against the type of mount request (RO vs. RW) so that we
stay consistent.

Addresses Red-Hat-Bugzilla: #517650

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   91 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 42 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2254,6 +2254,49 @@ static struct kobj_type ext4_ktype = {
 	.release	= ext4_sb_release,
 };
 
+/*
+ * Check whether this filesystem can be mounted based on
+ * the features present and the RDONLY/RDWR mount requested.
+ * Returns 1 if this filesystem can be mounted as requested,
+ * 0 if it cannot be.
+ */
+static int ext4_feature_set_ok(struct super_block *sb, int readonly)
+{
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP)) {
+		ext4_msg(sb, KERN_ERR,
+			"Couldn't mount because of "
+			"unsupported optional features (%x)",
+			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
+			~EXT4_FEATURE_INCOMPAT_SUPP));
+		return 0;
+	}
+
+	if (readonly)
+		return 1;
+
+	/* Check that feature set is OK for a read-write mount */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP)) {
+		ext4_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
+			 "unsupported optional features (%x)",
+			 (le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
+				~EXT4_FEATURE_RO_COMPAT_SUPP));
+		return 0;
+	}
+	/*
+	 * Large file size enabled file system can only be mounted
+	 * read-write on 32-bit systems if kernel is built with CONFIG_LBDAF
+	 */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
+		if (sizeof(blkcnt_t) < sizeof(u64)) {
+			ext4_msg(sb, KERN_ERR, "Filesystem with huge files "
+				 "cannot be mounted RDWR without "
+				 "CONFIG_LBDAF");
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
@@ -2275,7 +2318,6 @@ static int ext4_fill_super(struct super_
 	unsigned int db_count;
 	unsigned int i;
 	int needs_recovery, has_huge_files;
-	int features;
 	__u64 blocks_count;
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
@@ -2402,39 +2444,9 @@ static int ext4_fill_super(struct super_
 	 * previously didn't change the revision level when setting the flags,
 	 * so there is a chance incompat flags are set on a rev 0 filesystem.
 	 */
-	features = EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP);
-	if (features) {
-		ext4_msg(sb, KERN_ERR,
-			"Couldn't mount because of "
-			"unsupported optional features (%x)",
-			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
-			~EXT4_FEATURE_INCOMPAT_SUPP));
+	if (!ext4_feature_set_ok(sb, (sb->s_flags & MS_RDONLY)))
 		goto failed_mount;
-	}
-	features = EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP);
-	if (!(sb->s_flags & MS_RDONLY) && features) {
-		ext4_msg(sb, KERN_ERR,
-			"Couldn't mount RDWR because of "
-			"unsupported optional features (%x)",
-			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
-			~EXT4_FEATURE_RO_COMPAT_SUPP));
-		goto failed_mount;
-	}
-	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
-	if (has_huge_files) {
-		/*
-		 * Large file size enabled file system can only be
-		 * mount if kernel is build with CONFIG_LBDAF
-		 */
-		if (sizeof(root->i_blocks) < sizeof(u64) &&
-				!(sb->s_flags & MS_RDONLY)) {
-			ext4_msg(sb, KERN_ERR, "Filesystem with huge "
-					"files cannot be mounted read-write "
-					"without CONFIG_LBDAF");
-			goto failed_mount;
-		}
-	}
+
 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
@@ -2470,6 +2482,8 @@ static int ext4_fill_super(struct super_
 		}
 	}
 
+	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
 	sbi->s_bitmap_maxbytes = ext4_max_bitmap_size(sb->s_blocksize_bits,
 						      has_huge_files);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
@@ -3485,18 +3499,11 @@ static int ext4_remount(struct super_blo
 			if (sbi->s_journal)
 				ext4_mark_recovery_complete(sb, es);
 		} else {
-			int ret;
-			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					~EXT4_FEATURE_RO_COMPAT_SUPP))) {
-				ext4_msg(sb, KERN_WARNING, "couldn't "
-				       "remount RDWR because of unsupported "
-				       "optional features (%x)",
-				(le32_to_cpu(sbi->s_es->s_feature_ro_compat) &
-					~EXT4_FEATURE_RO_COMPAT_SUPP));
+			/* Make sure we can mount this feature set readwrite */
+			if (!ext4_feature_set_ok(sb, 0)) {
 				err = -EROFS;
 				goto restore_opts;
 			}
-
 			/*
 			 * Make sure the group descriptor checksums
 			 * are sane.  If they aren't, refuse to remount r/w.


