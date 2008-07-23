Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYGWVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYGWVk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYGWVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:40:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbYGWVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:40:11 -0400
Message-ID: <4887A525.4000202@redhat.com>
Date: Wed, 23 Jul 2008 16:39:49 -0500
From: Clark Williams <williams@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Ryan Hope <rmh3093@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [-rt][patches] fix compilation errors
References: <48f7fe350807201416v55b12dacq99e1922b56f02b37@mail.gmail.com>	 <48f7fe350807221641yf06a102x9cd3a4d51841525f@mail.gmail.com> <48f7fe350807231412v1d655caew74a79f3a4d42ea71@mail.gmail.com>
In-Reply-To: <48f7fe350807231412v1d655caew74a79f3a4d42ea71@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ryan Hope wrote:
> Here is another compile fix:
> 
> diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
> index 1eefe61..097feb0 100644
> --- a/fs/xfs/linux-2.6/xfs_fs_subr.c
> +++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
> @@ -33,7 +33,7 @@ xfs_tosspages(
>  {
>  	struct address_space *mapping = ip->i_vnode->i_mapping;
> 
> -	if (mapping->nrpages)
> +	if (mapping_nrpages(mapping))
>  		truncate_inode_pages(mapping, first);
>  }
> 
> @@ -47,7 +47,7 @@ xfs_flushinval_pages(
>  	struct address_space *mapping = ip->i_vnode->i_mapping;
>  	int		ret = 0;
> 
> -	if (mapping->nrpages) {
> +	if (mapping_nrpages(mapping)) {
>  		xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  		ret = filemap_write_and_wait(mapping);
>  		if (!ret)
> diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
> index 5e3b575..b6b8d39 100644
> --- a/fs/xfs/linux-2.6/xfs_lrw.c
> +++ b/fs/xfs/linux-2.6/xfs_lrw.c
> @@ -242,7 +242,7 @@ xfs_read(
>  	}
> 
>  	if (unlikely(ioflags & IO_ISDIRECT)) {
> -		if (inode->i_mapping->nrpages)
> +		if (mapping_nrpages(inode->i_mapping))
>  			ret = xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
>  						    -1, FI_REMAPF_LOCKED);
>  		mutex_unlock(&inode->i_mutex);
> @@ -654,7 +654,7 @@ start:
>  			return XFS_ERROR(-EINVAL);
>  		}
> 
> -		if (!need_i_mutex && (mapping->nrpages || pos > xip->i_size)) {
> +		if (!need_i_mutex && (mapping_nrpages(mapping) || pos > xip->i_size)) {
>  			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
>  			iolock = XFS_IOLOCK_EXCL;
>  			need_i_mutex = 1;
> @@ -722,7 +722,7 @@ retry:
>  	current->backing_dev_info = mapping->backing_dev_info;
> 
>  	if ((ioflags & IO_ISDIRECT)) {
> -		if (mapping->nrpages) {
> +		if (mapping_nrpages(mapping)) {
>  			WARN_ON(need_i_mutex == 0);
>  			xfs_inval_cached_trace(xip, pos, -1,
>  					(pos & PAGE_CACHE_MASK), -1);
> 
> 

Applied. Make sure you update, since there are a couple of bug fixes up there as
well. Also, I'm focusing on 64-bit atm, so your 32-bit fixes are appreciated.

Clark

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkiHpSUACgkQHyuj/+TTEp0fPQCePSXacZUseSSy8jWgFF0dTWsK
SMwAoJQc4Lfq8nNh0Y/S3sorkgdDqBNk
=NoDF
-----END PGP SIGNATURE-----
