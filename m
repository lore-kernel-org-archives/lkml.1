Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZCKPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZCKPys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZCKPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:54:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbZCKPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:54:38 -0400
Date: Wed, 11 Mar 2009 08:53:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Laurent GUERBY <laurent@guerby.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
In-Reply-To: <1236779832.11347.2082.camel@localhost>
Message-ID: <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
References: <1236779832.11347.2082.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Laurent GUERBY wrote:
> 
> With 2.6.29-rc5 (on an ARM platform but I don't think it's significant)
> when I try to enable swap on a file which is on an USB mounted vfat
> partition the swapon syscall gets stuck:

Oh wow. Are you _sure_ you want to do that? That's crazy.

But:

> swapon        D c03780d4     0 22361      1
> [<c0377db0>] (schedule+0x0/0x3ac) from [<c0378e50>] (__mutex_lock_slowpath+0x94/0xf4)
> [<c0378dbc>] (__mutex_lock_slowpath+0x0/0xf4) from [<c0378c40>] (mutex_lock+0x20/0x24)  r6:df49e808 r5:00000000 r4:00000000
> [<c0378c20>] (mutex_lock+0x0/0x24) from [<c013bb2c>] (_fat_bmap+0x28/0x68)
> [<c013bb04>] (_fat_bmap+0x0/0x68) from [<c00af910>] (bmap+0x2c/0x40)  r6:0005ffff r5:00000000 r4:00000000
> [<c00af8e4>] (bmap+0x0/0x40) from [<c0094b84>] (sys_swapon+0x630/0xcbc)  r5:c0541510 r4:00300000
> [<c0094554>] (sys_swapon+0x0/0xcbc) from [<c0029960>] (ret_fast_syscall+0x0/0x2c)
> 
> Looking around in the kernel sources it looks like the inode mutex is
> taken both by mm/swapfile.c and by fs/fat/inode.c, the latter one since
> this patch from november 2008:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa93ca18a8b0da4e26bd9491ad144cd14d22f8ec

Yes, clearly there's a deadlock there which was hidden before. And FAT 
technically does the locking right, so that bmap() doesn't race with 
somebody changing the file.

That said, other filesystems don't have this problem, simply because they 
just ignore the race, knowing that bmap is inherently racy in that 
situation _anyway_ (ie the value we return is clearly going to race 
_after_ we release the lock even if we do the lookup with the lock held!).

So the right thing to do would appear to be to just remove the silly 
locking in fat_bmap. It's not helping, and it's clearly hurting your 
(crazy) case. In the _normal_ paths (ie a regular read/write) we handle 
locking on a per-page basis anyway.

I dunno. No other filesystem has _any_ locking in their bmap that I can 
see, so I strongly suspect that fat doesn't need it either. 

IOW, I'm almost 100% sure that the right fix is this trivial one, but I'd 
like somebody else to double-check my thinking.

			Linus

---
 fs/fat/inode.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 6b74d09..2fcb269 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -199,14 +199,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
-	sector_t blocknr;
-
-	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	mutex_lock(&mapping->host->i_mutex);
-	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	mutex_unlock(&mapping->host->i_mutex);
-
-	return blocknr;
+	return generic_block_bmap(mapping, block, fat_get_block);
 }
 
 static const struct address_space_operations fat_aops = {
