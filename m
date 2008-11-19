Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKSHx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKSHx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYKSHxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:53:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYKSHxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:53:34 -0500
Date: Tue, 18 Nov 2008 23:53:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] hostfs: fix a duplicated global function name
Message-Id: <20081118235323.85dd277d.akpm@linux-foundation.org>
In-Reply-To: <20081118180003.GF3185@hack.voiplan.pt>
References: <20081118180003.GF3185@hack.voiplan.pt>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 18:00:03 +0000 Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> 
> fs/hostfs/hostfs_user.c defines do_readlink() as non-static,
> and so does fs/xfs/linux-2.6/xfs_ioctl.c when CONFIG_XFS_DEBUG=y.
> So rename do_readlink() in hostfs to hostfs_do_readlink().

heh, yes, it's not a great choice of identifier.

> I think it's better if XFS guys will also rename their do_readlink(),
> it's not necessary to use such a general name.
> 
> Compile test only.
>
> ...
>
> diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
> index 6ae9011..2f34f8f 100644
> --- a/fs/hostfs/hostfs.h
> +++ b/fs/hostfs/hostfs.h
> @@ -81,7 +81,7 @@ extern int do_rmdir(const char *file);
>  extern int do_mknod(const char *file, int mode, unsigned int major,
>  		    unsigned int minor);
>  extern int link_file(const char *from, const char *to);
> -extern int do_readlink(char *file, char *buf, int size);
> +extern int hostfs_do_readlink(char *file, char *buf, int size);
>  extern int rename_file(char *from, char *to);
>  extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
>  		     long long *bfree_out, long long *bavail_out,
> diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
> index 7f34f43..3a31451 100644
> --- a/fs/hostfs/hostfs_kern.c
> +++ b/fs/hostfs/hostfs_kern.c
> @@ -168,7 +168,7 @@ static char *follow_link(char *link)
>  		if (name == NULL)
>  			goto out;
>  
> -		n = do_readlink(link, name, len);
> +		n = hostfs_do_readlink(link, name, len);
>  		if (n < len)
>  			break;
>  		len *= 2;
> @@ -943,7 +943,7 @@ int hostfs_link_readpage(struct file *file, struct page *page)
>  	name = inode_name(page->mapping->host, 0);
>  	if (name == NULL)
>  		return -ENOMEM;
> -	err = do_readlink(name, buffer, PAGE_CACHE_SIZE);
> +	err = hostfs_do_readlink(name, buffer, PAGE_CACHE_SIZE);
>  	kfree(name);
>  	if (err == PAGE_CACHE_SIZE)
>  		err = -E2BIG;
> diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
> index 53fd0a6..b79424f 100644
> --- a/fs/hostfs/hostfs_user.c
> +++ b/fs/hostfs/hostfs_user.c
> @@ -377,7 +377,7 @@ int link_file(const char *to, const char *from)
>  	return 0;
>  }
>  
> -int do_readlink(char *file, char *buf, int size)
> +int hostfs_do_readlink(char *file, char *buf, int size)
>  {
>  	int n;

Thanks, I'll send this in for 2.6.28 unless someone stops me soon.
