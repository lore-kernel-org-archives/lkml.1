Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYJOTxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYJOTxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYJOTxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:53:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbYJOTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:53:22 -0400
Date: Wed, 15 Oct 2008 15:53:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] vfs: add d_ancestor()
Message-ID: <20081015195318.GA28349@infradead.org>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp> <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:58:10PM +0900, OGAWA Hirofumi wrote:
> 
> 
> This adds d_ancestor() instead of d_isparent(), then use it.
> 
> If new_dentry == old_dentry, is_subdir() returns 1, looks strange. But
> I'm not checking callers for now, so this keeps current behavior.

This change looks good, but a slightly more detailed changelog would be
good.

>  
>  /*
> - * Helper that returns 1 if p1 is a parent of p2, else 0
> + * Helper that returns the ancestor dentry of p2 which is a child of
> + * p1, if p1 is an ancestor of p2, else NULL.
>   */
> -static int d_isparent(struct dentry *p1, struct dentry *p2)
> +struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)

Given that d_ancestor is non-static a kerneldoc comment describing it
instead of a plain one would be good.

>  int is_subdir(struct dentry * new_dentry, struct dentry * old_dentry)
>  {
>  	int result;
> -	struct dentry * saved = new_dentry;
>  	unsigned long seq;
>  
> +	if (new_dentry == old_dentry)
> +		return 1;

Maybe a comment like in your commit description here would be good?

> +
>  	/* need rcu_readlock to protect against the d_parent trashing due to
>  	 * d_move
>  	 */
>  	rcu_read_lock();
>          do {
>  		/* for restarting inner loop in case of seq retry */
> -		new_dentry = saved;
> -		result = 0;
>  		seq = read_seqbegin(&rename_lock);
> -		for (;;) {
> -			if (new_dentry != old_dentry) {
> -				if (IS_ROOT(new_dentry))
> -					break;
> -				new_dentry = new_dentry->d_parent;
> -				continue;
> -			}
> -			result = 1;
> -			break;
> -		}
> +		result = (d_ancestor(old_dentry, new_dentry) != NULL);
>  	} while (read_seqretry(&rename_lock, seq));

That's a big improvement, but with a better loop and fixing all the
formatting mess in the old code it could become even better:

	/*
	 * Need rcu_readlock to protect against the d_parent trashing due to
	 * d_move.
	 */
	rcu_read_lock();
	do {
		/* for restarting inner loop in case of seq retry */
 		seq = read_seqbegin(&rename_lock);
		if (d_ancestor(old_dentry, new_dentry))
			result = 1;
		else
			result = 0;
	} while (read_seqretry(&rename_lock, seq));
 	rcu_read_unlock();


Nice set of patches!
