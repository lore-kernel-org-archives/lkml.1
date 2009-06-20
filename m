Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZFTA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZFTA3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZFTA3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 20:29:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbZFTA3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 20:29:06 -0400
Date: Fri, 19 Jun 2009 17:29:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: hooanon05@yahoo.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] vfs patches, part 1 
In-Reply-To: <8501.1245335415@jrobl>
Message-ID: <alpine.LFD.2.01.0906191725060.10492@localhost.localdomain>
References: <20090612014507.GA8633@ZenIV.linux.org.uk> <8501.1245335415@jrobl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al? There does seem to be a leak there. 

		Linus

On Thu, 18 Jun 2009, hooanon05@yahoo.co.jp wrote:
> 
> Didn't you forget path_put() for the new member before returning in the
> middle of do_filp_open()?
> 
> 
> J. R. Okajima
> 
> ----------------------------------------------------------------------
> commit ccf163f67e7c4bf3890010a5a593eb62c3004a6a
> Author: J. R. Okajima <hooanon05@yahoo.co.jp>
> Date:   Thu Jun 18 23:26:34 2009 +0900
> 
>     vfs: nd->root in do_filp_open()
>     
>     commit 2a737871108de9ba8930f7650d549f1383767f8b
>     "Cache root in nameidata"
>     introduced a new member nd->root, but forgot to put it in
>     do_filp_open().
>     
>     Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 527119a..5b961eb 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1698,8 +1698,11 @@ struct file *do_filp_open(int dfd, const char *pathname,
>  	if (error)
>  		return ERR_PTR(error);
>  	error = path_walk(pathname, &nd);
> -	if (error)
> +	if (error) {
> +		if (nd.root.mnt)
> +			path_put(&nd.root);
>  		return ERR_PTR(error);
> +	}
>  	if (unlikely(!audit_dummy_context()))
>  		audit_inode(pathname, nd.path.dentry);
>  
> @@ -1759,6 +1762,8 @@ do_last:
>  		}
>  		filp = nameidata_to_filp(&nd, open_flag);
>  		mnt_drop_write(nd.path.mnt);
> +		if (nd.root.mnt)
> +			path_put(&nd.root);
>  		return filp;
>  	}
>  
> @@ -1819,6 +1824,8 @@ ok:
>  	 */
>  	if (will_write)
>  		mnt_drop_write(nd.path.mnt);
> +	if (nd.root.mnt)
> +		path_put(&nd.root);
>  	return filp;
>  
>  exit_mutex_unlock:
> @@ -1859,6 +1866,8 @@ do_link:
>  		 * with "intent.open".
>  		 */
>  		release_open_intent(&nd);
> +		if (nd.root.mnt)
> +			path_put(&nd.root);
>  		return ERR_PTR(error);
>  	}
>  	nd.flags &= ~LOOKUP_PARENT;
> 
