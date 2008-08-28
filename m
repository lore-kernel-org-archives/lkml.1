Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYH1QFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYH1QFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYH1QFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:05:00 -0400
Received: from mx2.netapp.com ([216.240.18.37]:57112 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYH1QE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:04:59 -0400
X-IronPort-AV: E=Sophos;i="4.32,287,1217833200"; 
   d="scan'208";a="41142859"
References: <20080827142820.GA22661@tsunami.ccur.com>
thread-topic: [PATCH] NFSv3: cached permissions subset enhancement
thread-index: AckJJ8TEx2hjNcNiTmOypCbt9CxVgQ==
Message-ID: <2BBFD074-16C3-4640-8F3D-DF604F4146A7@netapp.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Joe Korty" <joe.korty@ccur.com>
In-Reply-To: <20080827142820.GA22661@tsunami.ccur.com>
Content-Type: text/plain;
	delsp=yes;
	format=flowed;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (iPhone Mail 5C1)
Subject: Re: [PATCH] NFSv3: cached permissions subset enhancement
Date: Thu, 28 Aug 2008 09:03:47 -0700
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Aug 2008 16:04:57.0252 (UTC) FILETIME=[D10E4E40:01C90927]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 27, 2008, at 7:28, "Joe Korty" <joe.korty@ccur.com> wrote:

> [NFSv3] cached permissions subset enhancement.
>
> NFSv3 allows file permissions to be cached on the client
> side.  The Linux client, when fetching these permissions,
> makes the request for all permissions (rwx) in a single
> operation.  However, for some NFSv3 server implementations
> (the only one currently known is PowerMAX OS), an incoming
> request for all rwx permissions in a single request,
> when all are not actually set in the file, returns an
> NFSERR_ACCES failure code to the client, rather than
> the subset of permissions actually available for that file.
>
> This patch modifies the Linux client side code to
> individually fetch the r, w, and x permissions (combining
> these for storage into the cache), if the original
> single-request method fails.
>
> This slower method will not affect performance of those
> client/server pairs for which the original single-request
> method works.  In particular there is no performance
> penalty for linux/linux NFSv3 connections.
>
> Author: Linda Dunaphant <ldunaphant@comcast.net>
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
>
> Index: 2.6.27-rc4-git4/fs/nfs/dir.c
> ===================================================================
> --- 2.6.27-rc4-git4.orig/fs/nfs/dir.c    2008-08-26 17:44:34.000000000 -0400
> +++ 2.6.27-rc4-git4/fs/nfs/dir.c    2008-08-26 18:21:27.000000000  
> -0400
> @@ -1870,6 +1870,8 @@
> {
>    struct nfs_access_entry cache;
>    int status;
> +    int i;
> +    int cmask = 0;
>
>    status = nfs_access_get_cached(inode, cred, &cache);
>    if (status == 0)
> @@ -1880,8 +1882,27 @@
>    cache.cred = cred;
>    cache.jiffies = jiffies;
>    status = NFS_PROTO(inode)->access(inode, &cache);
> -    if (status != 0)
> +    if (status == -NFSERR_ACCES) {
> +        //
> +        // Try again - one mode at a time & combine at the end
> +        //
> +        for (i = 0; i <= MAY_READ; i++) {
> +            cache.mask = 1 << i;
> +            status = NFS_PROTO(inode)->access(inode, &cache);
> +            if (status == 0)
> +                cmask |= cache.mask;
> +            else if (status != -NFSERR_ACCES) {
> +                return status;
> +            }
> +        }
> +
> +        if (!cmask)
> +            return -NFSERR_ACCES;
> +
> +        cache.mask = cmask;
> +    } else if (status)
>        return status;
> +
>    nfs_access_add_cache(inode, &cache);
> out:
>    if ((mask & ~cache.mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)

This isn't a good solution. The correct thing to do here is to resend  
the request for just those permissions that the VFS requested.

Cheers
   Trond
