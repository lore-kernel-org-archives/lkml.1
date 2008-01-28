Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYA1SqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYA1SqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYA1SqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:46:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYA1SqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:46:12 -0500
Message-ID: <479E22D4.6070300@redhat.com>
Date: Mon, 28 Jan 2008 12:45:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@MIT.EDU>
CC: linux-kernel@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
       Andreas Dilger <adilger@clusterfs.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 41/49] ext4: Add multi block allocator for ext4
References: <1200970948-17903-1-git-send-email-tytso@mit.edu> <1200970948-17903-25-git-send-email-tytso@mit.edu> <1200970948-17903-26-git-send-email-tytso@mit.edu> <1200970948-17903-27-git-send-email-tytso@mit.edu> <1200970948-17903-28-git-send-email-tytso@mit.edu> <1200970948-17903-29-git-send-email-tytso@mit.edu> <1200970948-17903-30-git-send-email-tytso@mit.edu> <1200970948-17903-31-git-send-email-tytso@mit.edu> <1200970948-17903-32-git-send-email-tytso@mit.edu> <1200970948-17903-33-git-send-email-tytso@mit.edu> <1200970948-17903-34-git-send-email-tytso@mit.edu> <1200970948-17903-35-git-send-email-tytso@mit.edu> <1200970948-17903-36-git-send-email-tytso@mit.edu> <1200970948-17903-37-git-send-email-tytso@mit.edu> <1200970948-17903-38-git-send-email-tytso@mit.edu> <1200970948-17903-39-git-send-email-tytso@mit.edu> <1200970948-17903-40-git-send-email-tytso@mit.edu> <1200970948-17903-41-git-send-email-tytso@mit.edu> <1200970948-17903-42-git-send-email-tytso@mit.edu>
In-Reply-To: <1200970948-17903-42-git-send-email-tytso@mit.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest version of the mballoc patch in the ext4dev git patch queue
has a potential uninitialized use:  CC [M]  fs/ext4/mballoc.o

fs/ext4/mballoc.c: In function ‘ext4_mb_free_blocks’:
fs/ext4/mballoc.c:4408: warning: ‘bitmap_bh’ may be used uninitialized in this function

There are 2 gotos which will call put_bh on a NULL bitmap_bh.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/fs/ext4/mballoc.c
+++ linux-2.6.24-rc6-mm1/fs/ext4/mballoc.c
@@ -4405,7 +4405,7 @@ void ext4_mb_free_blocks(handle_t *handl
 			unsigned long block, unsigned long count,
 			int metadata, unsigned long *freed)
 {
-	struct buffer_head *bitmap_bh;
+	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
 	struct ext4_allocation_context ac;
 	struct ext4_group_desc *gdp;
@@ -4546,7 +4546,8 @@ do_more:
 	}
 	sb->s_dirt = 1;
 error_return:
-	put_bh(bitmap_bh);
+	if (bitmap_bh)
+		put_bh(bitmap_bh);
 	ext4_std_error(sb, err);
 	return;
 }

