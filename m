Return-Path: <linux-kernel-owner+w=401wt.eu-S934424AbZKXXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbZKXXZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934394AbZKXXZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934387AbZKXXZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:25:19 -0500
Message-ID: <4B0C6B5A.6080702@sandeen.net>
Date: Tue, 24 Nov 2009 17:25:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH XFS] Fix error return for fallocate() on XFS
References: <20091124215253.GA10693@obsidianresearch.com>
In-Reply-To: <20091124215253.GA10693@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gunthorpe wrote:
> Noticed that through glibc fallocate would return 28 rather than -1
> and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
> positive return error codes while the syscalls use negative return codes.
> Fixup the two cases in xfs_vn_fallocate syscall to convert to negative.

grumblegrumble xfs error signs grumble...

> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index cd42ef7..1f3b4b8 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -573,8 +573,8 @@ xfs_vn_fallocate(
>  	bf.l_len = len;
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> -	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
> -				      0, XFS_ATTR_NOLOCK);
> +	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
> +				       0, XFS_ATTR_NOLOCK);
>  	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
>  	    offset + len > i_size_read(inode))
>  		new_size = offset + len;
> @@ -585,7 +585,7 @@ xfs_vn_fallocate(
>  
>  		iattr.ia_valid = ATTR_SIZE;
>  		iattr.ia_size = new_size;
> -		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
> +		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
>  	}
>  
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);

