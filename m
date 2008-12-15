Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYLOKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYLOKMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYLOKMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:12:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYLOKMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:12:35 -0500
Date: Mon, 15 Dec 2008 10:12:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, hch@infradead.org
Subject: Re: [PATCH, v2] sysv: ensure link targets are NUL-terminated
Message-ID: <20081215101233.GS28946@ZenIV.linux.org.uk>
References: <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com> <1229022995-9898-7-git-send-email-duaneg@dghda.com> <1229022995-9898-8-git-send-email-duaneg@dghda.com> <1229022995-9898-9-git-send-email-duaneg@dghda.com> <1229022995-9898-10-git-send-email-duaneg@dghda.com> <1229022995-9898-11-git-send-email-duaneg@dghda.com> <20081211223532.GD18665@dastardly.home.dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211223532.GD18665@dastardly.home.dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 10:35:32PM +0000, Duane Griffin wrote:
> Ensure link targets are NUL-terminated, even if corrupted on-disk.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
> 
> V2: terminate when the link is read instead of every time it is
> followed, as suggested by Dave Kleikamp.
> 
> diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
> index df0d435..1511228 100644
> --- a/fs/sysv/inode.c
> +++ b/fs/sysv/inode.c
> @@ -163,8 +163,10 @@ void sysv_set_inode(struct inode *inode, dev_t rdev)
>  		if (inode->i_blocks) {
>  			inode->i_op = &sysv_symlink_inode_operations;
>  			inode->i_mapping->a_ops = &sysv_aops;
> -		} else
> +		} else {
>  			inode->i_op = &sysv_fast_symlink_inode_operations;
> +			((char *) SYSV_I(inode)->i_data)[inode->i_size] = '\0';

If you do it that way, you want to verify that i_size is bounded.  Better yet,
add a helper for that (taking void *, len, max_len)
