Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbZL0VdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbZL0VdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZL0VdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:33:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:53877 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZL0VdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:33:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Trond.Myklebust@netapp.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] nfs: clean up sillyrenaming in nfs_rename()
References: <20091202150454.616582634@szeredi.hu>
	<20091202150516.256915252@szeredi.hu>
Date: Mon, 28 Dec 2009 06:32:57 +0900
In-Reply-To: <20091202150516.256915252@szeredi.hu> (Miklos Szeredi's message
	of "Wed, 02 Dec 2009 16:04:58 +0100")
Message-ID: <87bphk85me.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> --- linux-2.6.orig/fs/nfs/dir.c	2009-12-02 15:11:19.000000000 +0100
> +++ linux-2.6/fs/nfs/dir.c	2009-12-02 15:11:30.000000000 +0100
> @@ -1611,14 +1611,11 @@ static int nfs_rename(struct inode *old_
>  
>  			/* silly-rename the existing target ... */
>  			err = nfs_sillyrename(new_dir, new_dentry);
> -			if (!err) {
> -				new_dentry = rehash = dentry;
> -				new_inode = NULL;
> -				/* instantiate the replacement target */
> -				d_instantiate(new_dentry, NULL);
> -			} else if (atomic_read(&new_dentry->d_count) > 1)
> -				/* dentry still busy? */
> +			if (err)
>  				goto out;
> +
> +			new_dentry = dentry;
> +			new_inode = NULL;

This needs to update "rehash". Sorry, this patch is still compile test
only, although the patch is clear and simple.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



[PATCH] nfs: Fix d_rehash() for hashed dentry in nfs_rename()

Recent change is missing to update "rehash". With that change, it will
become the cause of adding dentry to hash twice.

This explains the reason of Oops (dereference the freed dentry in
__d_lookup()) on my machine.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/nfs/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nfs/dir.c~nfs-d_rehash-fix fs/nfs/dir.c
--- linux-2.6/fs/nfs/dir.c~nfs-d_rehash-fix	2009-12-28 06:18:09.000000000 +0900
+++ linux-2.6-hirofumi/fs/nfs/dir.c	2009-12-28 06:18:16.000000000 +0900
@@ -1615,6 +1615,7 @@ static int nfs_rename(struct inode *old_
 				goto out;
 
 			new_dentry = dentry;
+			rehash = NULL;
 			new_inode = NULL;
 		}
 	}
_
