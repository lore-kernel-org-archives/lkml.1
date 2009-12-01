Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZLAEPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZLAEPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZLAEPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:15:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51149 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbZLAEPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:15:49 -0500
Date: Mon, 30 Nov 2009 23:15:23 -0500
Message-Id: <200912010415.nB14FNBV030439@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/41] fallthru: Support for fallthru entries in union mount lookup 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:29 PDT."
             <1256152779-10054-32-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-32-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> A fallthru directory entry overrides the opaque flag for its parent
> directory (for this directory entry only).  Before, we stopped
> building the union stack when we encountered an opaque directory; now
> we include directories below opaque directories in the union stack and
> check for opacity during lookup.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c |    7 +++----
>  fs/namei.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++--------------
>  2 files changed, 48 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index d80a3bb..ca8a661 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1086,7 +1086,7 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
>  static void __d_instantiate(struct dentry *dentry, struct inode *inode)
>  {
>  	if (inode) {
> -		dentry->d_flags &= ~DCACHE_WHITEOUT;
> +		dentry->d_flags &= ~(DCACHE_WHITEOUT|DCACHE_FALLTHRU);
>  		list_add(&dentry->d_alias, &inode->i_dentry);
>  	}
>  	dentry->d_inode = inode;
> @@ -1638,9 +1638,8 @@ void d_delete(struct dentry * dentry)
>  
>  static void __d_rehash(struct dentry * entry, struct hlist_head *list)
>  {
> -
> - 	entry->d_flags &= ~DCACHE_UNHASHED;
> - 	hlist_add_head_rcu(&entry->d_hash, list);
> +	entry->d_flags &= ~DCACHE_UNHASHED;
> +	hlist_add_head_rcu(&entry->d_hash, list);
>  }
>  
>  static void _d_rehash(struct dentry * entry)
> diff --git a/fs/namei.c b/fs/namei.c
> index 8d95eb1..61e94aa 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -416,6 +416,28 @@ static struct dentry *cache_lookup(struct dentry *parent, struct qstr *name,
>  	return dentry;
>  }
>  
> +/*
> + * Theory of operation for opaque, whiteout, and fallthru:
> + *
> + * whiteout: Unconditionally stop lookup here - ENOENT
> + *
> + * opaque: Don't lookup in directories lower in the union stack
> + *
> + * fallthru: While looking up an entry, ignore the opaque flag for the
> + * current directory only.
> + *
> + * A union stack is a linked list of directory dentries which appear
> + * in the same place in the namespace.  When constructing the union
> + * stack, we include directories below opaque directories so that we
> + * can properly handle fallthrus.  All non-fallthru lookups have to
> + * check for the opaque flag on the parent directory and obey it.
> + *
> + * In general, the code pattern is to lookup the the topmost entry
> + * first (either the first visible non-negative dentry or a negative
> + * dentry in the topmost layer of the union), then build the union
> + * stack for the newly looked-up entry (if it is a directory).
> + */

Excellent comment; even better said and clearer that the UM design doc.
It's almost a pity such excellent description is buried in the middle of
namei.c.

> +
>  /**
>   * __cache_lookup_topmost - lookup the topmost (non-)negative dentry
>   *
> @@ -445,6 +467,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	if (!dentry || (dentry->d_inode || d_is_whiteout(dentry)))
>  		return !dentry;
>  
> +	/* Keep going through opaque directories if we found a fallthru */
> +	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(dentry))
> +		return !dentry;
> +
>  	/* look for the first non-negative or whiteout dentry */
>  
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
> @@ -470,6 +496,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  		if (dentry->d_inode || d_is_whiteout(dentry))
>  			goto out_dput;
>  
> +		/* Stop the lookup on opaque parent and non-fallthru child */
> +		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(dentry))

There's a lot of repetition of this condition:

	IS_OPAQUE(dentry->d_inode) && !d_is_fallthru(dentry)

in this patch.  Perhaps this should be macro'ized?

#define CANT_GO_ON(d)	(IS_OPAQUE((d)->d_inode) && !d_is_fallthru((d))) // :-)

> +			goto out_dput;
> +
>  		dput(dentry);
>  	}
>  
> @@ -528,9 +558,6 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = dentry;
>  		last.mnt = mntget(nd->path.mnt);
> -
> -		if (IS_OPAQUE(last.dentry->d_inode))
> -			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> @@ -570,8 +597,7 @@ static int cache_lookup_union(struct nameidata *nd, struct qstr *name,
>  
>  		/* only directories can be part of a union stack */
>  		if (!path->dentry->d_inode ||
> -		    !S_ISDIR(path->dentry->d_inode->i_mode) ||
> -		    IS_OPAQUE(path->dentry->d_inode))
> +		    !S_ISDIR(path->dentry->d_inode->i_mode))
>  			goto out;
>  
>  		/* Build the union stack for this part */
> @@ -738,6 +764,9 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
>  		return 0;
>  
> +	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(path->dentry))
> +		return 0;
> +
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
>  		name->hash = full_name_hash(name->name, name->len);
>  		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
> @@ -758,6 +787,9 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  			goto out;
>  		}
>  
> +		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(next.dentry))
> +			goto out;
> +
>  		dput(next.dentry);
>  	}
>  out:
> @@ -817,9 +849,6 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = next.dentry;
>  		last.mnt = mntget(next.mnt);
> -
> -		if (IS_OPAQUE(last.dentry->d_inode))
> -			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> @@ -841,8 +870,7 @@ static int real_lookup_union(struct nameidata *nd, struct qstr *name,
>  
>  	/* only directories can be part of a union stack */
>  	if (!path->dentry->d_inode ||
> -	    !S_ISDIR(path->dentry->d_inode->i_mode) ||
> -	    IS_OPAQUE(path->dentry->d_inode))
> +	    !S_ISDIR(path->dentry->d_inode->i_mode))
>  		goto out;
>  
>  	/* Build the union stack for this part */
> @@ -1128,7 +1156,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
>  {
>  	int err;
>  
> -	if (IS_MNT_UNION(nd->path.mnt) && !IS_OPAQUE(nd->path.dentry->d_inode))
> +	if (IS_MNT_UNION(nd->path.mnt))
>  		goto need_union_lookup;
>  
>  	path->dentry = __d_lookup(nd->path.dentry, name);
> @@ -1679,6 +1707,9 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
>  		return 0;
>  
> +	if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(path->dentry))
> +		return 0;
> +
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
>  		name->hash = full_name_hash(name->name, name->len);
>  		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash) {
> @@ -1701,6 +1732,9 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  			goto out;
>  		}
>  
> +		if (IS_OPAQUE(nd->path.dentry->d_inode) && !d_is_fallthru(next.dentry))
> +			goto out;
> +
>  		dput(next.dentry);
>  	}
>  out:
> @@ -1755,9 +1789,6 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  			path_put(&last);
>  		last.dentry = next.dentry;
>  		last.mnt = mntget(next.mnt);
> -
> -		if (IS_OPAQUE(last.dentry->d_inode))
> -			break;
>  	}
>  
>  	if (last.dentry != path->dentry)
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
