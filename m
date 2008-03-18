Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYCRFJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYCRFJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYCRFJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:09:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYCRFJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:09:02 -0400
Date: Mon, 17 Mar 2008 22:08:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 6/8] fuse: clean up setting i_size in write
Message-Id: <20080317220821.d0adb692.akpm@linux-foundation.org>
In-Reply-To: <20080317191947.989369784@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	<20080317191947.989369784@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008 20:19:14 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Extract common code for setting i_size in write functions into a
> common helper.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/fuse/file.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> Index: linux/fs/fuse/file.c
> ===================================================================
> --- linux.orig/fs/fuse/file.c	2008-03-17 18:26:04.000000000 +0100
> +++ linux/fs/fuse/file.c	2008-03-17 18:26:28.000000000 +0100
> @@ -610,13 +610,24 @@ static int fuse_write_begin(struct file 
>  	return 0;
>  }
>  
> +static void fuse_write_update_size(struct inode *inode, loff_t pos)
> +{
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +	struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +	spin_lock(&fc->lock);
> +	fi->attr_version = ++fc->attr_version;
> +	if (pos > inode->i_size)
> +		i_size_write(inode, pos);
> +	spin_unlock(&fc->lock);
> +}
>
> ...
>
> @@ -766,12 +772,8 @@ static ssize_t fuse_direct_io(struct fil
>  	}
>  	fuse_put_request(fc, req);
>  	if (res > 0) {
> -		if (write) {
> -			spin_lock(&fc->lock);
> -			if (pos > inode->i_size)
> -				i_size_write(inode, pos);
> -			spin_unlock(&fc->lock);
> -		}
> +		if (write)
> +			fuse_write_update_size(inode, pos);

We require that i_mutex be held here, to prevent i_size_write() deadlocks. 
Is it held?

