Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZK3CIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZK3CIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZK3CIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:08:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56691 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZK3CII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:08:08 -0500
Date: Sun, 29 Nov 2009 21:07:39 -0500
Message-Id: <200911300207.nAU27duL007220@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 04/41] VFS: Remove unnecessary micro-optimization in cached_lookup() 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:02 PDT."
             <1256152779-10054-5-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-5-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> d_lookup() takes rename_lock which is a seq_lock.  This is so cheap
> it's not worth calling lockless __d_lookup() first from
> cache_lookup().  Rename cached_lookup() to cache_lookup() while we're
> there.

Val, this is another patch unrelated to union mounts, an
optimization/simplification of the VFS code.  I think you need to try and
push such VFS patches upstream more quickly, so as to reduce the set of UM
patches you have to maintain.

> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index e334f25..9c9ecfa 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -404,15 +404,10 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
>   * Internal lookup() using the new generic dcache.
>   * SMP-safe
>   */
> -static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
> +static struct dentry *cache_lookup(struct dentry *parent, struct qstr *name,
> +				   struct nameidata *nd)
>  {
> -	struct dentry * dentry = __d_lookup(parent, name);
> -
> -	/* lockess __d_lookup may fail due to concurrent d_move() 
> -	 * in some unrelated directory, so try with d_lookup
> -	 */
> -	if (!dentry)
> -		dentry = d_lookup(parent, name);
> +	struct dentry *dentry = d_lookup(parent, name);
>  
>  	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
>  		dentry = do_revalidate(dentry, nd);
> @@ -1191,7 +1186,7 @@ static struct dentry *__lookup_hash(struct qstr *name,
>  			goto out;
>  	}
>  
> -	dentry = cached_lookup(base, name, nd);
> +	dentry = cache_lookup(base, name, nd);
>  	if (!dentry) {
>  		struct dentry *new;
>  
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
