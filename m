Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYLPTZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYLPTZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYLPTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:25:07 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:11923 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752259AbYLPTZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:25:06 -0500
X-Greylist: delayed 167238 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 14:25:06 EST
Date: Tue, 16 Dec 2008 22:40:55 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ufs: ensure fast symlinks are NUL-terminated
Message-ID: <20081216194053.GA17671@rain>
Mail-Followup-To: Duane Griffin <duaneg@dghda.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com> <1229442720-31056-2-git-send-email-duaneg@dghda.com> <1229442720-31056-3-git-send-email-duaneg@dghda.com> <1229442720-31056-4-git-send-email-duaneg@dghda.com> <1229442720-31056-5-git-send-email-duaneg@dghda.com> <1229442720-31056-6-git-send-email-duaneg@dghda.com> <1229442720-31056-7-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229442720-31056-7-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 03:51:58PM +0000, Duane Griffin wrote:
> Ensure fast symlink targets are NUL-terminated, even if corrupted
> on-disk.
> 
> Cc: Evgeniy Dushistov <dushistov@mail.ru>
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/ufs/inode.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
> index 39f8778..aca4b58 100644
> --- a/fs/ufs/inode.c
> +++ b/fs/ufs/inode.c
> @@ -36,6 +36,7 @@
>  #include <linux/mm.h>
>  #include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/namei.h>
>  
>  #include "ufs_fs.h"
>  #include "ufs.h"
> @@ -606,9 +607,12 @@ static void ufs_set_inode_ops(struct inode *inode)
>  		inode->i_fop = &ufs_dir_operations;
>  		inode->i_mapping->a_ops = &ufs_aops;
>  	} else if (S_ISLNK(inode->i_mode)) {
> -		if (!inode->i_blocks)
> +		if (!inode->i_blocks) {
>  			inode->i_op = &ufs_fast_symlink_inode_operations;
> -		else {
> +			nd_terminate_link(UFS_I(inode)->i_u1.i_symlink,
> +					  inode->i_size,
> +					  sizeof(UFS_I(inode)->i_u1.i_symlink));
> +		} else {
>  			inode->i_op = &page_symlink_inode_operations;
>  			inode->i_mapping->a_ops = &ufs_aops;
>  		}
> -- 
> 1.6.0.4

There is different types of ufs, one used 64 bit for "pointers to
blocks", another 32 bit,
so sizeof(UFS_I(inode)->i_u1.i_symlink))
is not right choice every time,
in ufs2 it should be
sizeof(UFS_I(inode)->i_u1.u2_i_data) which 2 times bigger,

also there is hint for *BSD ufs

fs/ufs/ufs_fs.h:
__fs32	fs_maxsymlinklen;/* max length of an internal symlink */

which may be used if ufs type ufs1 or ufs2

-- 
/Evgeniy

