Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYHSWW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYHSWW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYHSWW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:22:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431AbYHSWW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:22:28 -0400
Date: Tue, 19 Aug 2008 15:21:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Trojanowski <bart@jukie.net>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] make lock_super recursive to simulate BKL
In-Reply-To: <1219183590-19529-1-git-send-email-bart@jukie.net>
Message-ID: <alpine.LFD.1.10.0808191517591.3324@nehalem.linux-foundation.org>
References: <20080819220311.GA28029@jukie.net> <1219183590-19529-1-git-send-email-bart@jukie.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Bart Trojanowski wrote:
>
> This fixes a regression introduced when BKL was removed from the
> vfat driver in commit 8f5934278d1d86590244c2791b28f77d67466007.

I agree that it's going to almost certainly fix the regression, but could 
you test the following patch instead as an alternative? I'd rather remove 
the broken recursive lockign than introduce it as an acceptable concept.

		Linus
---
 fs/fat/inode.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 6d266d7..80ff338 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -562,26 +562,23 @@ static int fat_write_inode(struct inode *inode, int wait)
 	struct buffer_head *bh;
 	struct msdos_dir_entry *raw_entry;
 	loff_t i_pos;
-	int err = 0;
+	int err;
 
 retry:
 	i_pos = MSDOS_I(inode)->i_pos;
 	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
 		return 0;
 
-	lock_super(sb);
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
 		printk(KERN_ERR "FAT: unable to read inode block "
 		       "for updating (i_pos %lld)\n", i_pos);
-		err = -EIO;
-		goto out;
+		return -EIO;
 	}
 	spin_lock(&sbi->inode_hash_lock);
 	if (i_pos != MSDOS_I(inode)->i_pos) {
 		spin_unlock(&sbi->inode_hash_lock);
 		brelse(bh);
-		unlock_super(sb);
 		goto retry;
 	}
 
@@ -607,11 +604,10 @@ retry:
 	}
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
+	err = 0;
 	if (wait)
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
-out:
-	unlock_super(sb);
 	return err;
 }
 
