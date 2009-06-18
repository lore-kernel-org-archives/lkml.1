Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbZFRLvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbZFRLvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762319AbZFRLvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:51:20 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:59503 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762136AbZFRLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:51:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 07/11] vfs: Unmap underlying metadata of new data buffers only when buffer is mapped
References: <1245088797-29533-1-git-send-email-jack@suse.cz>
	<1245088797-29533-8-git-send-email-jack@suse.cz>
Date: Thu, 18 Jun 2009 20:51:13 +0900
In-Reply-To: <1245088797-29533-8-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Mon, 15 Jun 2009 19:59:54 +0200")
Message-ID: <87hbydkbf2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> When we do delayed allocation of some buffer, we want to signal to VFS that
> the buffer is new (set buffer_new) so that it properly zeros out everything.
> But we don't have the buffer mapped yet so we cannot really unmap underlying
> metadata in this state. Make VFS avoid doing unmapping of metadata when the
> buffer is not yet mapped.

I may be missing something. However, isn't the delalloc buffer ==
(buffer_mapped() | buffer_delay())? Well, anyway, if buffer is not
buffer_mapped(), e.g. truncate() works properly?

Thanks.

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

Is this needed for writepage?

>  			}
>  		}
>  		bh = bh->b_this_page;
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
