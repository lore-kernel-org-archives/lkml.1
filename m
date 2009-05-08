Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZEHDEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZEHDEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762607AbZEHC5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:22 -0400
Received: from sandeen.net ([209.173.210.139]:23819 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761996AbZEHC5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:57:09 -0400
Message-ID: <4A039F85.8010506@sandeen.net>
Date: Thu, 07 May 2009 21:57:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.beregalov@gmail.com
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
References: <1241745202-7452-1-git-send-email-felixb@sgi.com>
In-Reply-To: <1241745202-7452-1-git-send-email-felixb@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Blyakher wrote:
> Regreesion from commit ef8f7fc, which rearranged the code in
> xfs_swap_extents() leading to double unlock of xfs inode iolock.
> That resulted in xfs_fsr deadlocking itself on platforms, which
> don't handle double unlock of rw_semaphore nicely. It caused the
> count go negative, which represents the write holder, without
> really having one. ia64 is one of the platforms where deadlock
> was easily reproduced and the fix was tested.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>

Also-written-by: Eric Sandeen <sandeen@sandeen.net>
Independently-arrived-at-by: Eric Sandeen <sandeen@sandeen.net>

;)

But seriously ...

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/xfs_dfrag.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index e6d839b..7465f9e 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -347,13 +347,15 @@ xfs_swap_extents(
>  
>  	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
>  
> -out_unlock:
> -	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> -	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>  out:
>  	kmem_free(tempifp);
>  	return error;
>  
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	goto out;
> +
>  out_trans_cancel:
>  	xfs_trans_cancel(tp, 0);
>  	goto out_unlock;

