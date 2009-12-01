Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZLAEMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZLAEMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZLAEMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:12:10 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50742 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZLAEMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:12:09 -0500
Date: Mon, 30 Nov 2009 23:11:43 -0500
Message-Id: <200912010411.nB14Bhvw030326@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 26/41] union-mount: stop lookup when finding a whiteout 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:24 PDT."
             <1256152779-10054-27-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-27-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Stop the lookup if we find a whiteout during union path lookup.

Was it intentional to have a separate patch which adds opaque directories
support, or should it be part of the larger patch #24?

> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c |   30 ++++++++++++++++++++++--------
>  1 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 8ebbf4f..fb463ac 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -442,10 +442,10 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	path->dentry = dentry;
>  	path->mnt = dentry ? nd->path.mnt : NULL;
>  
> -	if (!dentry || dentry->d_inode)
> +	if (!dentry || (dentry->d_inode || d_is_whiteout(dentry)))
>  		return !dentry;

Unnecessary set of () around second and third || clauses above.

>  
> -	/* look for the first non-negative dentry */
> +	/* look for the first non-negative or whiteout dentry */
>  
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
>  		dentry = d_hash_and_lookup(nd->path.dentry, name);
> @@ -467,7 +467,7 @@ static int __cache_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  				goto out_dput;
>  		}
>  
> -		if (dentry->d_inode)
> +		if (dentry->d_inode || d_is_whiteout(dentry))
>  			goto out_dput;
>  
>  		dput(dentry);
> @@ -505,6 +505,11 @@ static int __cache_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  				return 1;
>  		}
>  
> +		if (d_is_whiteout(dentry)) {
> +			dput(dentry);
> +			break;
> +		}
> +
>  		if (!dentry->d_inode) {
>  			dput(dentry);
>  			continue;
> @@ -716,7 +721,6 @@ out_unlock:
>   * type mismatch and whiteouts.
>   *
>   * FIXME:
> - * - handle DT_WHT

Ah, ok: so this patch adds DT_WHT support.  Still, I don't see why it can't
just be folded into the already pretty large patch #24; and maybe patch 24
could be split a different way to facilitated easier reviewing?

>   * - handle union stacks in use
>   * - handle union stacks mounted upon union stacks
>   * - avoid unnecessary allocations of union locks
> @@ -731,7 +735,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	if (err)
>  		return err;
>  
> -	if (path->dentry->d_inode)
> +	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
>  		return 0;
>  
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
> @@ -747,7 +751,7 @@ static int __real_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  		if (err)
>  			goto out;
>  
> -		if (next.dentry->d_inode) {
> +		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
>  			dput(path->dentry);
>  			mntget(next.mnt);
>  			*path = next;
> @@ -790,6 +794,11 @@ static int __real_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  		if (err)
>  			goto out;
>  
> +		if (d_is_whiteout(next.dentry)) {
> +			dput(next.dentry);
> +			break;
> +		}
> +
>  		if (!next.dentry->d_inode) {
>  			dput(next.dentry);
>  			continue;
> @@ -1610,7 +1619,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  	if (err)
>  		return err;
>  
> -	if (path->dentry->d_inode)
> +	if (path->dentry->d_inode || d_is_whiteout(path->dentry))
>  		return 0;
>  
>  	while (follow_union_down(&nd->path.mnt, &nd->path.dentry)) {
> @@ -1628,7 +1637,7 @@ static int __hash_lookup_topmost(struct nameidata *nd, struct qstr *name,
>  		if (err)
>  			goto out;
>  
> -		if (next.dentry->d_inode) {
> +		if (next.dentry->d_inode || d_is_whiteout(next.dentry)) {
>  			dput(path->dentry);
>  			mntget(next.mnt);
>  			*path = next;
> @@ -1666,6 +1675,11 @@ static int __hash_lookup_build_union(struct nameidata *nd, struct qstr *name,
>  		if (err)
>  			goto out;
>  
> +		if (d_is_whiteout(next.dentry)) {
> +			dput(next.dentry);
> +			break;
> +		}
> +
>  		if (!next.dentry->d_inode) {
>  			dput(next.dentry);
>  			continue;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
