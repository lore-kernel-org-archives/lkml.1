Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZJMCLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZJMCLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZJMCLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:11:48 -0400
Received: from thunk.org ([69.25.196.29]:50754 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZJMCLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:11:47 -0400
Date: Mon, 12 Oct 2009 22:11:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Weird ext4 bug: 256P used?
Message-ID: <20091013021108.GB2606@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com> <20091012222910.GB18195@mit.edu> <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com> <20091012231211.GC18195@mit.edu> <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com> <20091013010518.GA2606@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013010518.GA2606@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch to e2fsprogs which will cause e2fsck to find and fix
the filesystem corruption.  I'm not sure how i_blocks_hi was set to
the incorect value in the first place, but this should fix the
filesystem for you (largely a cosmetic issue).

					- Ted

commit 8a8f36540bbf5d4397cf476e216e9a720b5c1d8e
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Oct 12 21:59:37 2009 -0400

    e2fsck: Fix handling of non-zero i_blocks_high field
    
    E2fsck was not properly printing the i_blocks field in filesystem
    corruption messages, and it was not properly checking i_blocks_hi and
    i_blocks_lo, either.  This commit fixes this.
    
    Thanks to Felipe Conteras for pointing this out.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 5e28812..9aaedc5 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -258,7 +258,7 @@ static _INLINE_ void expand_at_expression(e2fsck_t ctx, char ch,
 /*
  * This function expands '%IX' expressions
  */
-static _INLINE_ void expand_inode_expression(char ch,
+static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 					     struct problem_context *ctx)
 {
 	struct ext2_inode	*inode;
@@ -292,7 +292,8 @@ static _INLINE_ void expand_inode_expression(char ch,
 		printf("%u", large_inode->i_extra_isize);
 		break;
 	case 'b':
-		if (inode->i_flags & EXT4_HUGE_FILE_FL)
+		if (fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) 
 			printf("%llu", inode->i_blocks +
 			       (((long long) inode->osd2.linux2.l_i_blocks_hi)
 				<< 32));
@@ -528,7 +529,7 @@ void print_e2fsck_message(e2fsck_t ctx, const char *msg,
 			expand_at_expression(ctx, *cp, pctx, &first, recurse);
 		} else if (cp[0] == '%' && cp[1] == 'I') {
 			cp += 2;
-			expand_inode_expression(*cp, pctx);
+			expand_inode_expression(fs, *cp, pctx);
 		} else if (cp[0] == '%' && cp[1] == 'D') {
 			cp += 2;
 			expand_dirent_expression(fs, *cp, pctx);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 9b12005..2531e57 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1792,6 +1792,15 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	ext2fs_extent_free(ehandle);
 }
 
+static blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
+				     struct ext2_inode *inode)
+{
+	return (inode->i_blocks |
+		(fs->super->s_feature_ro_compat & 
+		 EXT4_FEATURE_RO_COMPAT_HUGE_FILE ?
+		 (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -1972,7 +1981,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (LINUX_S_ISREG(inode->i_mode) &&
 	    (inode->i_size_high || inode->i_size & 0x80000000UL))
 		ctx->large_files++;
-	if ((pb.num_blocks != inode->i_blocks) ||
+	if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
 	    ((fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
 	     (inode->i_flags & EXT4_HUGE_FILE_FL) &&
