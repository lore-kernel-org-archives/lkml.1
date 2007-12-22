Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbXLVIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbXLVIMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXLVIM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:12:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbXLVIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:12:26 -0500
Date: Sat, 22 Dec 2007 00:12:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] Handle i_size > s_maxbytes correctly
Message-Id: <20071222001206.9d34cc78.akpm@linux-foundation.org>
In-Reply-To: <20071220175104.GA11911@duck.suse.cz>
References: <20071220175104.GA11911@duck.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 18:51:04 +0100 Jan Kara <jack@suse.cz> wrote:

> Although we don't allow writes over s_maxbytes, it can happen that a file's
> size is larger than s_maxbytes. For example we can write the file from a
> computer with a different architecture (which has larger s_maxbytes), boot
> a kernel with a different set of config options (CONFIG_LBD...), or if two
> nodes in a [Ocfs2, and likely Gfs2] cluster have mounted the same file
> system and have different s_maxbytes.  Thus we have to make sure we don't
> crash / corrupt data when seeing such file (page offset of the last page
> needn't fit into pgoff_t). Firstly, we make read() and mmap() return error
> when user tries to access the file above s_maxbytes, secondly we introduce
> a function i_size_read_trunc() which returns min(i_size, s_maxbytes) and
> use it when determining maximal page offset we are interested in.
> 
> ...
>
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1623,7 +1623,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  
>  	BUG_ON(!PageLocked(page));
>  
> -	last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
> +	last_block = (i_size_read_trunc(inode) - 1) >> inode->i_blkbits;
>  
> ...
>
> +/* Truncate i_size at s_maxbytes so that pagecache doesn't have problems */
> +static inline loff_t i_size_read_trunc(const struct inode *inode)
> +{
> +	loff_t i_size = i_size_read(inode);
> +
> +	if (unlikely(inode->i_sb->s_maxbytes < i_size))
> +		return inode->i_sb->s_maxbytes;
> +	return i_size;
> +}
> +

This patch takes the total text size of the affected nine files from 74167
bytes up to 75066 on i386.  This is core, core kernel.  Ouch.

It's also pretty fragile.  We now have i_size_read()s and
i_size_read_trunc()s sprinkled all over the place with no obvious rules to
determine when we should use one versus the other.

uninlining i_size_read_trunc() is obviously the first thing to look at but
the cost is still appreciable and boy the problem which is being fixed here
is rare and obscure.

Can we look at alternatives please?  What about just failing the open
attempt?
