Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZCQRDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZCQRDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbZCQRDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:03:38 -0400
Received: from cobra.newdream.net ([66.33.216.30]:58787 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCQRDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:03:37 -0400
Date: Tue, 17 Mar 2009 10:03:35 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com
Subject: Re: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex
 held
In-Reply-To: <20090317081730.GA20213@infradead.org>
Message-ID: <Pine.LNX.4.64.0903170957560.18956@cobra.newdream.net>
References: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
 <20090317081730.GA20213@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Christoph Hellwig wrote:
> Keeping i_mutes over do_revalidate seem fine from a first glance, but
> can you please do it without rearranging the whole code?

Yeah, but not without an extra goto.  Holding i_mutex over revalidate is 
only half of it... we also want to go ahead with the ->lookup if the 
revalidate fails (instead of returning -ENOENT).  I make the patch easier 
to read (with a goto), but I assumed we'd want the resulting code to be 
more clear?

FWIW, here's the patched result:

	result = d_lookup(parent, name);
	if (result) {
		/*
		 * The cache was re-populated while we waited on the
		 * mutex.  We need to revalidate, this time while
		 * holding i_mutex (to avoid another race).
		 */
		if (result->d_op && result->d_op->d_revalidate) {
			result = do_revalidate(result, nd);
			if (result)
				goto out_unlock;
			/*
			 * The dentry was left behind invalid.  Just
			 * do the lookup.
			 */
		} else {
			goto out_unlock;
		}
	}

	/* Don't create child dentry for a dead directory. */
	result = ERR_PTR(-ENOENT);
	if (IS_DEADDIR(dir))
		goto out_unlock;

	dentry = d_alloc(parent, name);
	result = ERR_PTR(-ENOMEM);
	if (dentry) {
		result = dir->i_op->lookup(dir, dentry, nd);
		if (result)
			dput(dentry);
		else
			result = dentry;
	}
out_unlock:

Let me know!
sage


> Something like the tiny untested patch below should archive the same
> thing:
> 
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2009-03-17 09:15:53.430978739 +0100
> +++ linux-2.6/fs/namei.c	2009-03-17 09:16:19.553981306 +0100
> @@ -512,12 +512,12 @@ out_unlock:
>  	 * Uhhuh! Nasty case: the cache was re-populated while
>  	 * we waited on the semaphore. Need to revalidate.
>  	 */
> -	mutex_unlock(&dir->i_mutex);
>  	if (result->d_op && result->d_op->d_revalidate) {
>  		result = do_revalidate(result, nd);
>  		if (!result)
>  			result = ERR_PTR(-ENOENT);
>  	}
> +	mutex_unlock(&dir->i_mutex);
>  	return result;
>  }
>  
> 
> 
