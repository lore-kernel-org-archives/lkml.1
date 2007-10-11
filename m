Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXJKAyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXJKAyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXJKAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:54:40 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51379 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbXJKAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:54:39 -0400
Message-ID: <470D7443.6030206@tiscali.nl>
Date: Thu, 11 Oct 2007 02:54:27 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/31] IGET: Stop BFS from using iget() and read_inode()
 [try	#3]
References: <20071010214308.17535.5406.stgit@warthog.procyon.org.uk> <20071010214354.17535.22412.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071010214354.17535.22412.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is very well possible that I misunderstand the locking order here,
but FWIW:

David Howells wrote:
> diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
> index f346eb1..76798c9 100644
> --- a/fs/bfs/inode.c
> +++ b/fs/bfs/inode.c
> @@ -32,25 +32,29 @@ MODULE_LICENSE("GPL");
>  
>  void dump_imap(const char *prefix, struct super_block * s);
>  
> -static void bfs_read_inode(struct inode * inode)
> +struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
>  {
> -	unsigned long ino = inode->i_ino;
>  	struct bfs_inode * di;
>  	struct buffer_head * bh;
> +	struct inode *inode;
>  	int block, off;
>  
> +	inode = iget_locked(sb, ino);

after this

> +	if (IS_ERR(inode))
> +		return ERR_PTR(-ENOMEM);
> +	if (!(inode->i_state & I_NEW))
> +		return inode;

Don't you have to unlock_new_inode(inode) before returning?

> +
>  	if (ino < BFS_ROOT_INO || ino > BFS_SB(inode->i_sb)->si_lasti) {
>  		printf("Bad inode number %s:%08lx\n", inode->i_sb->s_id, ino);
> -		make_bad_inode(inode);
> -		return;
> +		goto error;
>  	}
>  
>  	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
>  	bh = sb_bread(inode->i_sb, block);
>  	if (!bh) {
>  		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id, ino);
> -		make_bad_inode(inode);
> -		return;
> +		goto error;
>  	}
>  
>  	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
> @@ -85,6 +89,12 @@ static void bfs_read_inode(struct inode * inode)
>  	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino); /* can be 0 so we store a copy */
>  
>  	brelse(bh);
> +	unlock_new_inode(inode);
> +	return inode;
> +
> +error:

and also here?

> +	iget_failed(inode);
> +	return ERR_PTR(-EIO);
>  }
