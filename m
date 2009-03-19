Return-Path: <linux-kernel-owner+w=401wt.eu-S1760373AbZCSTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373AbZCSTeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZCSTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:34:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZCSTeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:34:07 -0400
Date: Thu, 19 Mar 2009 15:34:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadlock when swapping to FAT
In-Reply-To: <87prgg6sj2.fsf@devron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0903191052180.14051@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903120819010.26206@hs20-bc2-1.build.redhat.com>
 <87zlfqohfn.fsf@devron.myhome.or.jp> <Pine.LNX.4.64.0903142153330.23664@hs20-bc2-1.build.redhat.com>
 <878wn7h3la.fsf@devron.myhome.or.jp> <Pine.LNX.4.64.0903170815110.26754@hs20-bc2-1.build.redhat.com>
 <87prgg6sj2.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, OGAWA Hirofumi wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > On Sun, 15 Mar 2009, OGAWA Hirofumi wrote:
> >
> >> Mikulas Patocka <mpatocka@redhat.com> writes:
> >> 
> >> > Note that the same race condition is happening in all the other 
> >> > filesystems. Maybe move that i_alloc_sem up to ->bmap method caller?
> >> 
> >> It can be. However, I guess locking strategy would be per
> >> filesystems. Because the fs may be using i_alloc_sem in get_block
> >> already.
> >
> > Which ones take it in get_block? I grepped for i_alloc_sem and don't see 
> > them. Besides, it is mostly taken only for read and recursive taking of 
> > read-lock for read is allowed. It is taken for writes only in truncate.
> 
> I don't know which fs take it, and whether i_alloc_sem is enough for
> which fs. It was just guess. And important one is locking strategy of
> that would be per filesystems. E.g. it seems XFS is taking own lock.
> 
> Well, personally, I don't have objection to add i_alloc_sem, however I'm
> not sure, what does i_alloc_sem guarantee for other fs.

It should prevent truncation under bmap. It is used by direct-io code to 
protect the file from being truncated while there's direct-io being 
processed on it.

But some filesystems do their own direct-io locking (for example XFS). So 
I think it would be best to place the lock to generic_block_bmap, so that 
filesystem that doesn't want the lock can easily avoid it.

You can submit this patch after 2.6.29 is released.

Mikulas

> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


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

Index: linux-2.6.29-rc8-devel/fs/buffer.c
===================================================================
--- linux-2.6.29-rc8-devel.orig/fs/buffer.c	2009-03-19 15:57:03.000000000 +0100
+++ linux-2.6.29-rc8-devel/fs/buffer.c	2009-03-19 15:58:00.000000000 +0100
@@ -2964,7 +2964,15 @@ sector_t generic_block_bmap(struct addre
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
 
Index: linux-2.6.29-rc8-devel/fs/fat/inode.c
===================================================================
--- linux-2.6.29-rc8-devel.orig/fs/fat/inode.c	2009-03-19 15:56:50.000000000 +0100
+++ linux-2.6.29-rc8-devel/fs/fat/inode.c	2009-03-19 15:56:58.000000000 +0100
@@ -202,9 +202,7 @@ static sector_t _fat_bmap(struct address
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	down_read(&mapping->host->i_alloc_sem);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	up_read(&mapping->host->i_alloc_sem);
 
 	return blocknr;
 }
