Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbXBODaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbXBODaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXBODaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:30:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964885AbXBODaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:30:55 -0500
Date: Wed, 14 Feb 2007 19:30:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy
Message-Id: <20070214193051.4b008d61.akpm@linux-foundation.org>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC83F228@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC83F228@mssmsx411>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 20:51:33 +0300 "Ananiev, Leonid I" <leonid.i.ananiev@intel.com> wrote:

> Fix kernel bug when IO page is temporally busy:
> invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.
> invalidate_inode_pages2() returns EIO as earlier.
> 
> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
> ---
> --- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20p/mm/truncate.c 2007-02-08 22:56:52.000000000 -0800
> @@ -366,7 +366,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are unmapped prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EIOCBRETRY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>                                   pgoff_t start, pgoff_t end)
> @@ -423,7 +423,7 @@ int invalidate_inode_pages2_range(struct
>                         }
>                         ret = do_launder_page(mapping, page);
>                         if (ret == 0 && !invalidate_complete_page2(mapping, page))
> -                               ret = -EIO;
> +                               ret = -EIOCBRETRY;
>                         unlock_page(page);
>                 }
>                 pagevec_release(&pvec);
> @@ -444,6 +444,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
>   */
>  int invalidate_inode_pages2(struct address_space *mapping)
>  {
> -       return invalidate_inode_pages2_range(mapping, 0, -1);
> +       int ret =  invalidate_inode_pages2_range(mapping, 0, -1);
> +       return (ret < 0)?-EIO:ret;
>  }
>  EXPORT_SYMBOL_GPL(invalidate_inode_pages2);

If someone later uses invalidate_inode_pages2_range() elsewhere, they're
going to need to know to convert -EIOCBRETRY into -EIO, if they weren't
called by aio.  Or something.

Please, tell us what problem this is fixing so that we can look into
alternative solutions.

For example, one acceptable-but-ugly solution might be to do:

static inline int invalidate_inode_pages2_range(struct address_space *mapping,
				pgoff_t start, pgoff_t end)
{
	return __invalidate_inode_pages2_range(mapping, start, end, 0);
}

static inline int invalidate_inode_pages2_range_for_aio(struct address_space *mapping,
				pgoff_t start, pgoff_t end)
{
	return __invalidate_inode_pages2_range(mapping, start, end, 1);
}

and to then use invalidate_inode_pages2_range_for_aio() from the
appropriate callsite.

But without a complete description of the bug which this is fixing, it's
hard to say how practical such an approach would be.

