Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbZC3TUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbZC3TUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZC3TU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:20:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759248AbZC3TU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:20:27 -0400
Date: Mon, 30 Mar 2009 15:20:24 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: viro@zeniv.linux.org.uk
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix bmap-vs-truncate race
Message-ID: <Pine.LNX.4.64.0903301518120.23576@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm submitting this patch for 2.6.30 merge window.


FAT filesystem used down_read(&mapping->host->i_alloc_sem) to prevent 
a race between bmap and truncate. However, such race is present in all the
other filesystems --- it is generally assumed that blocks queried with
get_block won't disappear while get_block is in progress.

The race can be only triggered by root, non-privileged users can't use
bmap, so it is not a security issue (unless there is some program run
by root that bmaps users' files).

This patch fixes the race in a generic way, in all the filesystems. If some
filesystem employs its own locking and doesn't want to take i_alloc_sem
(I don't know about any, where taking i_alloc_sem could be problem),
let it use its own function and not generic_block_bmap.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/buffer.c    |    8 ++++++++
 fs/fat/inode.c |    2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.29-devel/fs/buffer.c
===================================================================
--- linux-2.6.29-devel.orig/fs/buffer.c	2009-03-29 04:48:38.000000000 +0200
+++ linux-2.6.29-devel/fs/buffer.c	2009-03-29 05:26:53.000000000 +0200
@@ -2963,7 +2963,15 @@ sector_t generic_block_bmap(struct addre
 	tmp.b_state = 0;
 	tmp.b_blocknr = 0;
 	tmp.b_size = 1 << inode->i_blkbits;
+
+	/*
+	 * Protect the inode from being truncated while get_block is
+	 * in progress.
+	 */
+	down_read(&mapping->host->i_alloc_sem);
 	get_block(inode, block, &tmp, 0);
+	up_read(&mapping->host->i_alloc_sem);
+
 	return tmp.b_blocknr;
 }
 
Index: linux-2.6.29-devel/fs/fat/inode.c
===================================================================
--- linux-2.6.29-devel.orig/fs/fat/inode.c	2009-03-29 04:46:35.000000000 +0200
+++ linux-2.6.29-devel/fs/fat/inode.c	2009-03-29 05:26:53.000000000 +0200
@@ -202,9 +202,7 @@ static sector_t _fat_bmap(struct address
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	down_read(&mapping->host->i_alloc_sem);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	up_read(&mapping->host->i_alloc_sem);
 
 	return blocknr;
 }
