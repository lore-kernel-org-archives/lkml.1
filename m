Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbZK3I6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbZK3I6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZK3I6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:58:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52775 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZK3I6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:58:14 -0500
Date: Mon, 30 Nov 2009 03:57:46 -0500
Message-Id: <200911300857.nAU8vkSp024531@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 21/41] union-mount: Drive the union cache via dcache 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:19 PDT."
             <1256152779-10054-22-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-22-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> If a dentry is removed from dentry cache because its usage count drops to
> zero, the references to the underlying layer of the unions the dentry is in
> are droped too. Therefore the union cache is driven by the dentry cache.

Hmm, in my review for patch 20, I suggested a way to simplify is_unionized()
by marking relevant dentries with a flag whether they are in a union or
not.  If you're driving the entire union cache from the dcache, can't this
be done easily then?

> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c            |   10 ++++++-
>  fs/union.c             |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |    8 +++++
>  include/linux/union.h  |    6 ++++
>  4 files changed, 97 insertions(+), 1 deletions(-)

> diff --git a/fs/union.c b/fs/union.c
> index d1950c2..6b99393 100644
> --- a/fs/union.c
> +++ b/fs/union.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/bootmem.h>
>  #include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/hash.h>
>  #include <linux/fs.h>
> @@ -255,6 +256,8 @@ int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
>  		union_put(this);
>  		return 0;
>  	}
> +	list_add(&this->u_unions, &dentry->d_unions);
> +	dest_dentry->d_unionized++;
>  	__union_hash(this);
>  	spin_unlock(&union_lock);
>  	return 0;
> @@ -330,3 +333,74 @@ int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
>  
>  	return res;
>  }
> +
> +/*
> + * This must be called when unhashing a dentry. This is called with dcache_lock
> + * and unhashes all unions this dentry is in.
> + */
> +void __d_drop_unions(struct dentry *dentry)
> +{
> +	struct union_mount *this, *next;
> +
> +	spin_lock(&union_lock);
> +	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions)
> +		__union_unhash(this);
> +	spin_unlock(&union_lock);
> +}
> +EXPORT_SYMBOL_GPL(__d_drop_unions);

I thought the convention was that internal functions prefixed with __ are
.. internal, not to be extern'ed and exported.

Besides, why export this symbol?  Which modules need it in your patchset?

> +/*
> + * This must be called after __d_drop_unions() without holding any locks.
> + * Note: The dentry might still be reachable via a lookup but at that time it
> + * already a negative dentry. Otherwise it would be unhashed. The union_mount
> + * structure itself is still reachable through mnt->mnt_unions (which we
> + * protect against with union_lock).
> + */
> +void shrink_d_unions(struct dentry *dentry)
> +{
> +	struct union_mount *this, *next;

See my comments about this/that vs. upper/lower in my review for patch #20.

> +repeat:
> +	spin_lock(&union_lock);
> +	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
> +		BUG_ON(!hlist_unhashed(&this->u_hash));
> +		BUG_ON(!hlist_unhashed(&this->u_rhash));
> +		list_del(&this->u_unions);
> +		this->u_next.dentry->d_unionized--;
> +		spin_unlock(&union_lock);
> +		union_put(this);
> +		goto repeat;
> +	}
> +	spin_unlock(&union_lock);
> +}
> +
> +extern void __dput(struct dentry *, struct list_head *, int);

Why this extern here?  Isn't there some header file you can #include more
cleanly at the top of this .c file?

>  static inline void d_drop(struct dentry *dentry)
> diff --git a/include/linux/union.h b/include/linux/union.h
> index 0c85312..b035a82 100644
> --- a/include/linux/union.h
> +++ b/include/linux/union.h
> @@ -46,6 +46,9 @@ extern int append_to_union(struct vfsmount *, struct dentry *,
>  			   struct vfsmount *, struct dentry *);
>  extern int follow_union_down(struct vfsmount **, struct dentry **);
>  extern int follow_union_mount(struct vfsmount **, struct dentry **);
> +extern void __d_drop_unions(struct dentry *);
> +extern void shrink_d_unions(struct dentry *);
> +extern void __shrink_d_unions(struct dentry *, struct list_head *);

Again, I don't understand why the two out of three functions above are
prefixed with __ while one of them isn't.  I always prefer to name things
for what they actually do, not rely on magic prefixes and conventions to
guess what it means.  I suggest trying to find better names to avoid having
so many FOO and __FOO names in this entire series of patchset.

Erez.
