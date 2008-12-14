Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYLNXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYLNXCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLNXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:01:52 -0500
Received: from mx28.mail.ru ([194.67.23.67]:10752 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYLNXBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:01:52 -0500
Date: Mon, 15 Dec 2008 00:12:47 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, v2] ufs: ensure link targets are NUL-terminated
Message-ID: <20081214211246.GA7743@rain>
Mail-Followup-To: Duane Griffin <duaneg@dghda.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>
References: <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com> <1229022995-9898-7-git-send-email-duaneg@dghda.com> <1229022995-9898-8-git-send-email-duaneg@dghda.com> <1229022995-9898-9-git-send-email-duaneg@dghda.com> <1229022995-9898-10-git-send-email-duaneg@dghda.com> <1229022995-9898-11-git-send-email-duaneg@dghda.com> <1229022995-9898-12-git-send-email-duaneg@dghda.com> <20081211223608.GE18665@dastardly.home.dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211223608.GE18665@dastardly.home.dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 10:36:08PM +0000, Duane Griffin wrote:
> Ensure link targets are NUL-terminated, even if corrupted on-disk.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
> 
> V2: terminate when the link is read instead of every time it is
> followed, as suggested by Dave Kleikamp.
> 
> diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
> index 39f8778..a22f64d 100644
> --- a/fs/ufs/inode.c
> +++ b/fs/ufs/inode.c
> @@ -606,9 +606,11 @@ static void ufs_set_inode_ops(struct inode *inode)
>  		inode->i_fop = &ufs_dir_operations;
>  		inode->i_mapping->a_ops = &ufs_aops;
>  	} else if (S_ISLNK(inode->i_mode)) {
> -		if (!inode->i_blocks)
> +		if (!inode->i_blocks) {
> +			char *link = UFS_I(inode)->i_u1.i_symlink;
>  			inode->i_op = &ufs_fast_symlink_inode_operations;
> -		else {
> +			link[inode->i_size] = '\0';
> +		} else {
>  			inode->i_op = &page_symlink_inode_operations;
>  			inode->i_mapping->a_ops = &ufs_aops;
>  		}

if we talk about corrupted file system, may be also ensure
that inode->i_size <= sizeof(i_u1)-1 before write '\0' to it.

-- 
/Evgeniy

