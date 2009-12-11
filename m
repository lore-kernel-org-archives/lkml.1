Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbZLKEf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbZLKEf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760465AbZLKEfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:35:54 -0500
Received: from kroah.org ([198.145.64.141]:52868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935AbZLKEfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:37 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:28 2009
Message-Id: <20091211042727.486958503@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [06/90] ext4: Fix bugs in mballocs stream allocation mode
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0006-ext4-Fix-bugs-in-mballoc-s-stream-allocation-mode.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 4ba74d00a20256e22f159cb288ff34b587608917)

The logic around sbi->s_mb_last_group and sbi->s_mb_last_start was all
screwed up.  These fields were getting unconditionally all the time,
set even when stream allocation had not taken place, and if they were
being used when the file was smaller than s_mb_stream_request, which
is when the allocation should _not_ be doing stream allocation.

Fix this by determining whether or not we stream allocation should
take place once, in ext4_mb_group_or_file(), and setting a flag which
gets used in ext4_mb_regular_allocator() and ext4_mb_use_best_found().
This simplifies the code and assures that we are consistently using
(or not using) the stream allocation logic.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/mballoc.c |   23 ++++++++++-------------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -88,6 +88,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_HINT_TRY_GOAL		512
 /* blocks already pre-reserved by delayed allocation */
 #define EXT4_MB_DELALLOC_RESERVED      1024
+/* We are doing stream allocation */
+#define EXT4_MB_STREAM_ALLOC		2048
 
 
 struct ext4_allocation_request {
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1360,7 +1360,7 @@ static void ext4_mb_use_best_found(struc
 	ac->alloc_semp =  e4b->alloc_semp;
 	e4b->alloc_semp = NULL;
 	/* store last allocated for subsequent stream allocation */
-	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
+	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
 		spin_lock(&sbi->s_md_lock);
 		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
 		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
@@ -1938,7 +1938,6 @@ ext4_mb_regular_allocator(struct ext4_al
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
-	loff_t size, isize;
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
@@ -1974,20 +1973,16 @@ ext4_mb_regular_allocator(struct ext4_al
 	}
 
 	bsbits = ac->ac_sb->s_blocksize_bits;
-	/* if stream allocation is enabled, use global goal */
-	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
-	isize = i_size_read(ac->ac_inode) >> bsbits;
-	if (size < isize)
-		size = isize;
 
-	if (size < sbi->s_mb_stream_request &&
-			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
+	/* if stream allocation is enabled, use global goal */
+	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
 		/* TBD: may be hot point */
 		spin_lock(&sbi->s_md_lock);
 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
+
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
 	/*
@@ -4155,16 +4150,18 @@ static void ext4_mb_group_or_file(struct
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
 
+	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
+		return;
+
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = i_size_read(ac->ac_inode) >> bsbits;
 	size = max(size, isize);
 
 	/* don't use group allocation for large files */
-	if (size >= sbi->s_mb_stream_request)
-		return;
-
-	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
+	if (size >= sbi->s_mb_stream_request) {
+		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
 		return;
+	}
 
 	BUG_ON(ac->ac_lg != NULL);
 	/*


