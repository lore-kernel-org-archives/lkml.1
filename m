Return-Path: <linux-kernel-owner+w=401wt.eu-S1765297AbXGQHEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765297AbXGQHEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXGQHEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:04:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921AbXGQHE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:04:29 -0400
Date: Tue, 17 Jul 2007 00:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kirill Kuvaldin <kuvkir@epsmu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] isofs: mounting to regular file may succeed
Message-Id: <20070717000407.4c854ec8.akpm@linux-foundation.org>
In-Reply-To: <20070713234721.GG4536@zetta.epsmu.com>
References: <20070713234721.GG4536@zetta.epsmu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 03:47:21 +0400 Kirill Kuvaldin <kuvkir@epsmu.com> wrote:

> It turned out that mounting a corrupted ISO image to a regular file may
> succeed, e.g. if an image was prepared as follows:
> 
> $ dd if=correct.iso of=bad.iso bs=4k count=8
> 
> We then can mount it to a regular file:
> 
> # mount -o loop -t iso9660 bad.iso /tmp/file
> 
> But mounting it to a directory fails with -ENOTDIR, simply because 
> the root directory inode doesn't have S_IFDIR set and the condition
> in graft_tree() is met:
> 
> 	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
> 	      S_ISDIR(mnt->mnt_root->d_inode->i_mode))
> 		return -ENOTDIR
> 
> This is because the root directory inode was read from an incorrect
> block. It's supposed to be read from sbi->s_firstdatazone, which is
> an absolute value and gets messed up in the case of an incorrect image.
> 
> In order to somehow circumvent this we have to check that the root
> directory inode is actually a directory after all.
> 
> 
> Signed-off-by: Kirill Kuvaldin <kuvkir@epsmu.com>
> 
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 5c3eecf..ce5062a 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -840,6 +840,15 @@ root_found:
>  		goto out_no_root;
>  	if (!inode->i_op)
>  		goto out_bad_root;
> +
> +	/* Make sure the root inode is a directory */
> +	if (!S_ISDIR(inode->i_mode)) {
> +		printk(KERN_WARNING
> +			"isofs_fill_super: root inode is not a directory. "
> +			"Corrupted media?\n");
> +		goto out_iput;
> +	}
> +
>  	/* get the root dentry */
>  	s->s_root = d_alloc_root(inode);
>  	if (!(s->s_root))

I don't think any (all?) other filesystems perform checks like this.
Is this something which can/should be performed at the VFS level?
