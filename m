Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZCKRQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZCKRQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZCKRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:15:55 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54396 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZCKRPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:15:54 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 13:15:54 EDT
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laurent GUERBY <laurent@guerby.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
References: <1236779832.11347.2082.camel@localhost>
	<alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
Date: Thu, 12 Mar 2009 02:03:23 +0900
In-Reply-To: <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
	(Linus Torvalds's message of "Wed, 11 Mar 2009 08:53:14 -0700 (PDT)")
Message-ID: <87ocw80z6s.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Yes, clearly there's a deadlock there which was hidden before. And FAT 
> technically does the locking right, so that bmap() doesn't race with 
> somebody changing the file.
>
> That said, other filesystems don't have this problem, simply because they 
> just ignore the race, knowing that bmap is inherently racy in that 
> situation _anyway_ (ie the value we return is clearly going to race 
> _after_ we release the lock even if we do the lookup with the lock held!).
>
> So the right thing to do would appear to be to just remove the silly 
> locking in fat_bmap. It's not helping, and it's clearly hurting your 
> (crazy) case. In the _normal_ paths (ie a regular read/write) we handle 
> locking on a per-page basis anyway.
>
> I dunno. No other filesystem has _any_ locking in their bmap that I can 
> see, so I strongly suspect that fat doesn't need it either. 
>
> IOW, I'm almost 100% sure that the right fix is this trivial one, but I'd 
> like somebody else to double-check my thinking.

I'm sure that path touch the metadata without locking (so, reused entry
can not be for that inode anymore). However, I guess the result doesn't
become any fs corruption, so and other fs is ignoring the possibly wrong
result of bmap().

I'm thinking to use this patch instead of removing.


[PATCH] Fix _fat_bmap() locking

On swapon() path, it has already i_mutex. So, this uses i_alloc_sem
instead of it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat_bmap-locking-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_bmap-locking-fix	2009-03-12 00:47:15.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2009-03-12 00:47:42.000000000 +0900
@@ -202,9 +202,9 @@ static sector_t _fat_bmap(struct address
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	mutex_lock(&mapping->host->i_mutex);
+	down_read(&mapping->host->i_alloc_sem);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	mutex_unlock(&mapping->host->i_mutex);
+	up_read(&mapping->host->i_alloc_sem);
 
 	return blocknr;
 }
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
