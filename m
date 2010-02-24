Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0BXB7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:59:12 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:50452 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752165Ab0BXB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:59:10 -0500
Date: Wed, 24 Feb 2010 12:58:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the nfsd and xfs trees
Message-ID: <20100224015848.GE16175@discord.disaster>
References: <20100224123646.bb62faea.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100224123646.bb62faea.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 12:36:46PM +1100, Stephen Rothwell wrote:
> Hi Bruce, David,
> 
> After merging the nfsd and xfs trees, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/xfs/linux-2.6/xfs_export.c: In function 'xfs_fs_nfs_commit_metadata':
> fs/xfs/linux-2.6/xfs_export.c:230: error: 'XFS_LOG_FORCE' undeclared (first use in this function)
> fs/xfs/linux-2.6/xfs_export.c:230: error: too many arguments to function '_xfs_log_force'
> 
> Caused by commit 978ebd97d1426d5708d3f353179ab81f191a7eeb
> ("xfs_export_operations.commit_metadata") from the nfsd tree interacting
> with commit a14a348bff2f99471a28e5928eb6801224c053d8 ("xfs: cleanup up
> xfs_log_force calling conventions") from the xfs tree.

I was waiting for this email to come in. ;)

> I applied the following patch (which may not be correct) for today (and
> can keep it as a merge fixup as necessary):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 24 Feb 2010 12:20:01 +1100
> Subject: [PATCH] nfsd: fixup for _xfs_log_force API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/xfs/linux-2.6/xfs_export.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
> index 8f4d707..846b75a 100644
> --- a/fs/xfs/linux-2.6/xfs_export.c
> +++ b/fs/xfs/linux-2.6/xfs_export.c
> @@ -226,8 +226,8 @@ xfs_fs_nfs_commit_metadata(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	if (xfs_ipincount(ip)) {
> -		error = _xfs_log_force(mp, ip->i_itemp->ili_last_lsn,
> -				XFS_LOG_FORCE | XFS_LOG_SYNC, NULL);
> +		error = _xfs_log_force_lsn(mp, ip->i_itemp->ili_last_lsn,
> +				XFS_LOG_SYNC, NULL);
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);

Yes, that is the correct fix. Thanks for that, Stephen. Consider it:

Reviewed-by: Dave Chinner <david@fromorbit.com>

Іt would be good if you could keep it as a merge fixup - we don't
really want to have to pull the -next NFS tree into the XFS tree or vice
versa until one or the other is upstream....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
