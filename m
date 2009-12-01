Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLAEOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLAEOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZLAEOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:14:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51124 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZLAEOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:14:41 -0500
Date: Mon, 30 Nov 2009 23:14:16 -0500
Message-Id: <200912010414.nB14EGxG030387@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 29/41] union-mount: Always create topmost directory on open 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:27 PDT."
             <1256152779-10054-30-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-30-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> When we open a directory, always create a matching directory on the
> top-level.  This way we don't have to go back and create all the
> directories on the path to an element when we want to copy it up.
> 
> XXX - Turn into #ifdef'able function
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c |   34 ++++++++++++++++++++++++++++++----
>  1 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1f2a214..8d95eb1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1284,8 +1284,31 @@ static int __link_path_walk(const char *name, struct nameidata *nd)
>  		if (err)
>  			break;
>  
> -		if ((nd->flags & LOOKUP_TOPMOST) &&
> -		    (nd->um_flags & LAST_LOWLEVEL)) {
> +		/*
> +		 * We want to create this element on the top level
> +		 * file system in two cases:
> +		 *
> +		 * - We are specifically told to - LOOKUP_TOPMOST.
> +		 * - This is a directory, and it does not yet exist on
> +		 *   the top level.  Various tricks only work if
> +		 *   directories always exist on the top level.
> +		 *
> +		 * In either case, only create this element on the top
> +		 * level if the last element is located on the lower
> +		 * level.  If the last element is located on the top
> +		 * level, then every single element in the path
> +		 * already exists on the top level.
> +		 *
> +		 * Note that we can assume that the parent is on the
> +		 * top level since we always create the directory on
> +		 * the top level.
> +		 */

OK, yes: a number of things (not "tricks" as you call them) become easier if
you always copyup directories upon path traversal.  It's esp. nice wrt
locking semantics to know that the parent dir must always exist.

But, what you're trading off is that you'll be consuming many inodes and
directories on the topmost layer; worse, this policy turns an innocent
readonly "find . -print" into a massive meta-data write operation.  If
that's an acceptable compromise, then fine: but you should document this
carefully under a section named "limitations" in your design doc.

> +		if ((nd->um_flags & LAST_LOWLEVEL) &&
> +		    ((next.dentry->d_inode &&
> +		      S_ISDIR(next.dentry->d_inode->i_mode) &&
> +		      (nd->path.mnt != next.mnt)) ||
> +		     (nd->flags & LOOKUP_TOPMOST))) {
>  			struct dentry *dentry;
>  
>  			dentry = union_create_topmost(nd, &this, &next);
> @@ -1349,8 +1372,11 @@ last_component:
>  		if (err)
>  			break;
>  
> -		if ((nd->flags & LOOKUP_TOPMOST) &&
> -		    (nd->um_flags & LAST_LOWLEVEL)) {
> +		if ((nd->um_flags & LAST_LOWLEVEL) &&
> +		    ((next.dentry->d_inode &&
> +		      S_ISDIR(next.dentry->d_inode->i_mode) &&
> +		      (nd->path.mnt != next.mnt)) ||
> +		     (nd->flags & LOOKUP_TOPMOST))) {
>  			struct dentry *dentry;
>  
>  			dentry = union_create_topmost(nd, &this, &next);
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
