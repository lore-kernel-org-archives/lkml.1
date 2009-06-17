Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZFQKfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZFQKfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZFQKfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:35:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZFQKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:35:41 -0400
Date: Wed, 17 Jun 2009 12:35:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/11] vfs: Unmap underlying metadata of new data buffers only when buffer is mapped
Message-ID: <20090617103543.GB29931@wotan.suse.de>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245088797-29533-8-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:59:54PM +0200, Jan Kara wrote:
> When we do delayed allocation of some buffer, we want to signal to VFS that
> the buffer is new (set buffer_new) so that it properly zeros out everything.
> But we don't have the buffer mapped yet so we cannot really unmap underlying
> metadata in this state. Make VFS avoid doing unmapping of metadata when the
> buffer is not yet mapped.

Is this a seperate bugfix for delalloc filesystems? What is the error
case of attempting to unmap underlying metadata of non mapped buffer?
Won't translate to a serious bug will it?

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 80e2630..7eb1710 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1683,8 +1683,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  			if (buffer_new(bh)) {
>  				/* blockdev mappings never come here */
>  				clear_buffer_new(bh);
> -				unmap_underlying_metadata(bh->b_bdev,
> -							bh->b_blocknr);
> +				if (buffer_mapped(bh))
> +					unmap_underlying_metadata(bh->b_bdev,
> +						bh->b_blocknr);
>  			}
>  		}
>  		bh = bh->b_this_page;
> @@ -1869,8 +1870,9 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
>  			if (err)
>  				break;
>  			if (buffer_new(bh)) {
> -				unmap_underlying_metadata(bh->b_bdev,
> -							bh->b_blocknr);
> +				if (buffer_mapped(bh))
> +					unmap_underlying_metadata(bh->b_bdev,
> +						bh->b_blocknr);
>  				if (PageUptodate(page)) {
>  					clear_buffer_new(bh);
>  					set_buffer_uptodate(bh);
> @@ -2683,7 +2685,7 @@ int nobh_write_begin(struct file *file, struct address_space *mapping,
>  			goto failed;
>  		if (!buffer_mapped(bh))
>  			is_mapped_to_disk = 0;
> -		if (buffer_new(bh))
> +		if (buffer_new(bh) && buffer_mapped(bh))
>  			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>  		if (PageUptodate(page)) {
>  			set_buffer_uptodate(bh);
> -- 
> 1.6.0.2
