Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbXJARZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbXJARZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXJARZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:25:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41474 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXJARZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:25:20 -0400
Date: Mon, 1 Oct 2007 19:25:19 +0200
From: Jan Kara <jack@suse.cz>
To: Denis Cheng <crquan@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: Re: [PATCH] fs/dcache.c: revamped to use a more straightforward and efficient way to operate
Message-ID: <20071001172519.GC4178@atrey.karlin.mff.cuni.cz>
References: <1190546051-15590-1-git-send-email-crquan@gmail.com> <1190750670-8264-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190750670-8264-1-git-send-email-crquan@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  thanks for the patch. I have a few comments to it:
1) the patch should have a description in it, not only an email subject
2) usually, if an 'if' branch ends with return, as is the case in your
   patch, we don't use 'else' for the other branch...

BTW: I'm not convinced your code would be faster (or slower) than the
original one but you're right it will be easier to read...

								Honza

> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  fs/dcache.c |   39 ++++++++++++++++++---------------------
>  1 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 678d39d..05ed44a 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1138,29 +1138,26 @@ struct dentry * d_alloc_anon(struct inode *inode)
>  	
>  	spin_lock(&dcache_lock);
>  	res = __d_find_alias(inode, 0);
> -	if (!res) {
> -		/* attach a disconnected dentry */
> -		res = tmp;
> -		tmp = NULL;
> -		spin_lock(&res->d_lock);
> -		res->d_sb = inode->i_sb;
> -		res->d_parent = res;
> -		res->d_inode = inode;
> -		res->d_flags |= DCACHE_DISCONNECTED;
> -		res->d_flags &= ~DCACHE_UNHASHED;
> -		list_add(&res->d_alias, &inode->i_dentry);
> -		hlist_add_head(&res->d_hash, &inode->i_sb->s_anon);
> -		spin_unlock(&res->d_lock);
> -
> -		inode = NULL; /* don't drop reference */
> -	}
> -	spin_unlock(&dcache_lock);
> -
> -	if (inode)
> +	if (unlikely(res)) {
> +		spin_unlock(&dcache_lock);
>  		iput(inode);
> -	if (tmp)
>  		dput(tmp);
> -	return res;
> +		return res;
> +	} else {
> +		/* attach a disconnected dentry */
> +		spin_lock(&tmp->d_lock);
> +		tmp->d_sb = inode->i_sb;
> +		tmp->d_parent = tmp;
> +		tmp->d_inode = inode;
> +		tmp->d_flags |= DCACHE_DISCONNECTED;
> +		tmp->d_flags &= ~DCACHE_UNHASHED;
> +		list_add(&tmp->d_alias, &inode->i_dentry);
> +		hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
> +		spin_unlock(&tmp->d_lock);
> +
> +		spin_unlock(&dcache_lock);
> +		return tmp;
> +	}
>  }
>  
>  
> -- 
> 1.5.3.2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
