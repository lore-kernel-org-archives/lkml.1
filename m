Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZLIPmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZLIPmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZLIPmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:42:08 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57149 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZLIPmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YBnXpU10MxHYcdqt/+98HbARqVQK603JWn4drStAV5EiXHe+OyTl5flI+UX65YvvXP
         pq3OT1yqGZAYyOn/K2CNUFhSVIZ+K14QFEld/25k3RjME0lhH1XnXgFK5pFO/g0Itt6j
         0g907G8KHTjlfIfNVeyOfQBxvhBxHWUeIK8pE=
MIME-Version: 1.0
In-Reply-To: <1259781409-31318-1-git-send-email-jack@suse.cz>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
Date: Wed, 9 Dec 2009 17:42:12 +0200
Message-ID: <c70ff3ad0912090742g3d35f364m11b6ae79e20893be@mail.gmail.com>
Subject: Re: [PATCH 1/3] ext3: Fix data / filesystem corruption when write 
	fails to copy data
From: saeed bishara <saeed.bishara@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I came a cross data corruption bug when using ext3, this patch fixed
it. the bug exists in 2.6.31 and 32.
saeed


On Wed, Dec 2, 2009 at 9:16 PM, Jan Kara <jack@suse.cz> wrote:
> When ext3_write_begin fails after allocating some blocks or
> generic_perform_write fails to copy data to write, we truncate blocks already
> instantiated beyond i_size. Although these blocks were never inside i_size, we
> have to truncate pagecache of these blocks so that corresponding buffers get
> unmapped. Otherwise subsequent __block_prepare_write (called because we are
> retrying the write) will find the buffers mapped, not call ->get_block, and
> thus the page will be backed by already freed blocks leading to filesystem and
> data corruption.
>
> CC: linux-ext4@vger.kernel.org
> Reported-by: James Y Knight <foom@fuhm.net>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/inode.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
>
> I will take care of merging this patch. I'm just sending it for completeness...
>
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 354ed3b..f9d6937 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1151,6 +1151,16 @@ static int do_journal_get_write_access(handle_t *handle,
>        return ext3_journal_get_write_access(handle, bh);
>  }
>
> +/*
> + * Truncate blocks that were not used by write. We have to truncate the
> + * pagecache as well so that corresponding buffers get properly unmapped.
> + */
> +static void ext3_truncate_failed_write(struct inode *inode)
> +{
> +       truncate_inode_pages(inode->i_mapping, inode->i_size);
> +       ext3_truncate(inode);
> +}
> +
>  static int ext3_write_begin(struct file *file, struct address_space *mapping,
>                                loff_t pos, unsigned len, unsigned flags,
>                                struct page **pagep, void **fsdata)
> @@ -1209,7 +1219,7 @@ write_begin_failed:
>                unlock_page(page);
>                page_cache_release(page);
>                if (pos + len > inode->i_size)
> -                       ext3_truncate(inode);
> +                       ext3_truncate_failed_write(inode);
>        }
>        if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
>                goto retry;
> @@ -1304,7 +1314,7 @@ static int ext3_ordered_write_end(struct file *file,
>        page_cache_release(page);
>
>        if (pos + len > inode->i_size)
> -               ext3_truncate(inode);
> +               ext3_truncate_failed_write(inode);
>        return ret ? ret : copied;
>  }
>
> @@ -1330,7 +1340,7 @@ static int ext3_writeback_write_end(struct file *file,
>        page_cache_release(page);
>
>        if (pos + len > inode->i_size)
> -               ext3_truncate(inode);
> +               ext3_truncate_failed_write(inode);
>        return ret ? ret : copied;
>  }
>
> @@ -1383,7 +1393,7 @@ static int ext3_journalled_write_end(struct file *file,
>        page_cache_release(page);
>
>        if (pos + len > inode->i_size)
> -               ext3_truncate(inode);
> +               ext3_truncate_failed_write(inode);
>        return ret ? ret : copied;
>  }
>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
