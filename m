Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZLZGYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZLZGYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 01:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZLZGYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 01:24:44 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:54757 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZLZGYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 01:24:43 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [patch 4/4] nfs: clean up sillyrenaming in nfs_rename() 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond.Myklebust@netapp.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091202150516.256915252@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu> <20091202150516.256915252@szeredi.hu>
Date: Sat, 26 Dec 2009 15:24:11 +0900
Message-ID: <8054.1261808651@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos,

Don't we need to make the 'dentry' hashed, in sillyrename case?
The d_alloc()ed dentry is unhashed, and it was d_rehash()ed later
(before the patch).

	new_dentry = rehash = dentry;
	:::
out:
	if (rehash)
		d_rehash(rehash);

Applying your patch, the 'rehash' is not re-assigned and the 'dentry'
left unhashed. Such dentry which is visible by readdir but its d_hash is
empty, will be a problem in nfs readdir (which calls d_lookup()), I am
afraid.


J. R. Okajima


Miklos Szeredi:
> The d_instantiate(new_dentry, NULL) is superfluous, the dentry is
> already negative.  Rehashing this dummy dentry isn't needed either,
> d_move() works fine on an unhashed target.
> 
> The re-checking for busy after a failed nfs_sillyrename() is bogus
> too: new_dentry->d_count < 2 would be a bug here.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/nfs/dir.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/fs/nfs/dir.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/dir.c 2009-12-02 15:11:19.000000000 +0100
> +++ linux-2.6/fs/nfs/dir.c      2009-12-02 15:11:30.000000000 +0100
> @@ -1611,14 +1611,11 @@  static int nfs_rename(struct inode *old_
> 
>                         /* silly-rename the existing target ... */
>                         err = nfs_sillyrename(new_dir, new_dentry);
> -                       if (!err) {
> -                               new_dentry = rehash = dentry;
> -                               new_inode = NULL;
> -                               /* instantiate the replacement target */
> -                               d_instantiate(new_dentry, NULL);
> -                       } else if (atomic_read(&new_dentry->d_count) > 1)
> -                               /* dentry still busy? */
> +                       if (err)
>                                 goto out;
> +
> +                       new_dentry = dentry;
> +                       new_inode = NULL;
>                 }
>         }
