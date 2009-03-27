Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbZC0Uz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbZC0Uz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761008AbZC0Uzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:55:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbZC0Uzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:55:44 -0400
Date: Fri, 27 Mar 2009 21:55:41 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Message-ID: <20090327205541.GD31071@duck.suse.cz>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238185471-31152-2-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 27-03-09 16:24:29, Theodore Ts'o wrote:
> When doing synchronous writes because wbc->sync_mode is set to
> WBC_SYNC_ALL, send the write request using WRITE_SYNC, so that we
> don't unduly block system calls such as fsync().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
  Looks sane. You can add "Acked-by: Jan Kara <jack@suse.cz>"

									Honza
> ---
>  fs/buffer.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 891e1c7..e7ebd95 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1714,6 +1714,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	struct buffer_head *bh, *head;
>  	const unsigned blocksize = 1 << inode->i_blkbits;
>  	int nr_underway = 0;
> +	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
>  
>  	BUG_ON(!PageLocked(page));
>  
> @@ -1805,7 +1806,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  	do {
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
> -			submit_bh(WRITE, bh);
> +			submit_bh(write_op, bh);
>  			nr_underway++;
>  		}
>  		bh = next;
> @@ -1859,7 +1860,7 @@ recover:
>  		struct buffer_head *next = bh->b_this_page;
>  		if (buffer_async_write(bh)) {
>  			clear_buffer_dirty(bh);
> -			submit_bh(WRITE, bh);
> +			submit_bh(write_op, bh);
>  			nr_underway++;
>  		}
>  		bh = next;
> -- 
> 1.5.6.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
