Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYHTBOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYHTBOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYHTBO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:14:26 -0400
Received: from tau.jukie.net ([216.239.93.128]:32904 "EHLO tau.jukie.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYHTBO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:14:26 -0400
Date: Tue, 19 Aug 2008 21:14:24 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] make lock_super recursive to simulate BKL
Message-ID: <20080820011424.GE28029@jukie.net>
References: <20080819220311.GA28029@jukie.net> <1219183590-19529-1-git-send-email-bart@jukie.net> <alpine.LFD.1.10.0808191517591.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191517591.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [080819 18:23]:
> 
> 
> On Tue, 19 Aug 2008, Bart Trojanowski wrote:
> >
> > This fixes a regression introduced when BKL was removed from the
> > vfat driver in commit 8f5934278d1d86590244c2791b28f77d67466007.
> 
> I agree that it's going to almost certainly fix the regression, but could 
> you test the following patch instead as an alternative? I'd rather remove 
> the broken recursive lockign than introduce it as an acceptable concept.

Looks good.  I ran 10 parallel processes creating 1M files truncating
them, writing to them again and then deleting them.  This patch fixes
the issue I ran into.

Signed-off-by: Bart Trojanowski <bart@jukie.net>

> ---
>  fs/fat/inode.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 6d266d7..80ff338 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -562,26 +562,23 @@ static int fat_write_inode(struct inode *inode, int wait)
>  	struct buffer_head *bh;
>  	struct msdos_dir_entry *raw_entry;
>  	loff_t i_pos;
> -	int err = 0;
> +	int err;
>  
>  retry:
>  	i_pos = MSDOS_I(inode)->i_pos;
>  	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
>  		return 0;
>  
> -	lock_super(sb);
>  	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
>  	if (!bh) {
>  		printk(KERN_ERR "FAT: unable to read inode block "
>  		       "for updating (i_pos %lld)\n", i_pos);
> -		err = -EIO;
> -		goto out;
> +		return -EIO;
>  	}
>  	spin_lock(&sbi->inode_hash_lock);
>  	if (i_pos != MSDOS_I(inode)->i_pos) {
>  		spin_unlock(&sbi->inode_hash_lock);
>  		brelse(bh);
> -		unlock_super(sb);
>  		goto retry;
>  	}
>  
> @@ -607,11 +604,10 @@ retry:
>  	}
>  	spin_unlock(&sbi->inode_hash_lock);
>  	mark_buffer_dirty(bh);
> +	err = 0;
>  	if (wait)
>  		err = sync_dirty_buffer(bh);
>  	brelse(bh);
> -out:
> -	unlock_super(sb);
>  	return err;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
				WebSig: http://www.jukie.net/~bart/sig/
