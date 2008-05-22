Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYEVP56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYEVP56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYEVP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:57:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:25822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYEVP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jVi/PoCbOlMlU5jiEQFO6Oi7jQ0mkw5hRe9uXGPnStxuw13CupbLPG7yGHbPX/TARl69hQ/wzGXDx2cbe8TzxVBD5/5FpBZ15m0fddC9hgqQskqDQyeRuXBj/XQXk5HKh7Lsspt9lTxPt4cuu4s5t5lUbIuemgrK3WS95Ud6W6s=
Date: Thu, 22 May 2008 17:57:05 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 3/6] vfs: open_exec cleanup
Message-ID: <20080522155645.GA8447@joi>
References: <20080513201813.GA5869@joi> <1211148109-16149-1-git-send-email-marcin.slusarz@gmail.com> <20080519055334.GA14902@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519055334.GA14902@lst.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 07:53:34AM +0200, Christoph Hellwig wrote:
> On Mon, May 19, 2008 at 12:01:49AM +0200, Marcin Slusarz wrote:
> > open_exec is needlessly indented, calls ERR_PTR with 0 argument
> > (which is not valid errno) and jumps into middle of function
> > just to return value.
> > So clean it up a bit.
> 
> Still looks rather messy.  See below for a better version.

looks much better, thanks
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/exec.c
> ===================================================================
> --- linux-2.6.orig/fs/exec.c	2008-05-19 07:45:18.000000000 +0200
> +++ linux-2.6/fs/exec.c	2008-05-19 07:53:17.000000000 +0200
> @@ -654,38 +654,40 @@ EXPORT_SYMBOL(setup_arg_pages);
>  struct file *open_exec(const char *name)
>  {
>  	struct nameidata nd;
> -	int err;
>  	struct file *file;
> +	int err;
>  
> -	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd, FMODE_READ|FMODE_EXEC);
> -	file = ERR_PTR(err);
> +	err = path_lookup_open(AT_FDCWD, name, LOOKUP_FOLLOW, &nd,
> +				FMODE_READ|FMODE_EXEC);
> +	if (err)
> +		goto out;
>  
> -	if (!err) {
> -		struct inode *inode = nd.path.dentry->d_inode;
> -		file = ERR_PTR(-EACCES);
> -		if (S_ISREG(inode->i_mode)) {
> -			int err = vfs_permission(&nd, MAY_EXEC);
> -			file = ERR_PTR(err);
> -			if (!err) {
> -				file = nameidata_to_filp(&nd,
> -							O_RDONLY|O_LARGEFILE);
> -				if (!IS_ERR(file)) {
> -					err = deny_write_access(file);
> -					if (err) {
> -						fput(file);
> -						file = ERR_PTR(err);
> -					}
> -				}
> -out:
> -				return file;
> -			}
> -		}
> -		release_open_intent(&nd);
> -		path_put(&nd.path);
> +	err = -EACCES;
> +	if (!S_ISREG(nd.path.dentry->d_inode->i_mode))
> +		goto out_path_put;
> +
> +	err = vfs_permission(&nd, MAY_EXEC);
> +	if (err)
> +		goto out_path_put;
> +
> +	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
> +	if (IS_ERR(file))
> +		return file;
> +
> +	err = deny_write_access(file);
> +	if (err) {
> +		fput(file);
> +		goto out;
>  	}
> -	goto out;
> -}
>  
> +	return file;
> +
> + out_path_put:
> +	release_open_intent(&nd);
> +	path_put(&nd.path);
> + out:
> +	return ERR_PTR(err);
> +}
>  EXPORT_SYMBOL(open_exec);
>  
>  int kernel_read(struct file *file, unsigned long offset,
> 
