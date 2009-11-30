Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZK3CC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZK3CC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZK3CC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:02:58 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52029 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbZK3CC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:02:57 -0500
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2009 21:02:57 EST
Date: Sun, 29 Nov 2009 21:02:31 -0500
Message-Id: <200911300202.nAU22VGU007154@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 03/41] VFS: Make lookup_hash() return a struct path 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:01 PDT."
             <1256152779-10054-4-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-4-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> This patch changes lookup_hash() into returning a struct path.

Actually, lookup_hash now also takes a qstr.

This is a somewhat involved patch.  I think more documentation is needed to
list all the places it touches and changes, b/c now struct path has to
propagate in various other places.  (In general, passing struct path instead
of struct dentry is going in the right direction: eventually we could get rid
of lookup_one_len.)

> @@ -1219,14 +1219,22 @@ out:
>   * needs parent already locked. Doesn't follow mounts.
>   * SMP-safe.
>   */
> -static struct dentry *lookup_hash(struct nameidata *nd)
> +static int lookup_hash(struct nameidata *nd, struct qstr *name,
> +		       struct path *path)
>  {

I suggest you document above this function what the @name and @path are for,
who is supposed to allocate and free them, caller/callee's responsibilities,
side effects (if any), new return status upon success/failure, etc.

>  
>  	err = inode_permission(nd->path.dentry->d_inode, MAY_EXEC);
>  	if (err)
> -		return ERR_PTR(err);
> -	return __lookup_hash(&nd->last, nd->path.dentry, nd);
> +		return err;

At least initially, while all this code is being developed, it might also be
a good idea to add

   BUG_ON(!name);
   BUG_ON(!path);

here and possibly in other places which are now taking new pointers.

Erez.
