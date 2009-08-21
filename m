Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZHUANO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZHUANO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZHUANN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:13:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117AbZHUANN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:13:13 -0400
Date: Thu, 20 Aug 2009 17:12:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/4] direct-io: make O_DIRECT IO path be page based
Message-Id: <20090820171204.93c3fdb4.akpm@linux-foundation.org>
In-Reply-To: <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 12:17:38 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> Currently we pass in the iovec array and let the O_DIRECT core
> handle the get_user_pages() business. This work, but it means that
> we can ever only use user pages for O_DIRECT.
> 
> Switch the aops->direct_IO() and below code to use page arrays
> instead, so that it doesn't make any assumptions about who the pages
> belong to. This works directly for all users but NFS, which just
> uses the same helper that the generic mapping read/write functions
> also call.
>

This:

> +	struct page **pages;		/* page buffer */
> +	unsigned int head_page;		/* next page to process */
> +	unsigned int total_pages;	/* last valid page + 1 */
> +	unsigned int first_page_off;	/* offset into first page in map */

Is a disaster waiting to happen.

>  static struct page *dio_get_page(struct dio *dio)
>  {
> -	if (dio_pages_present(dio) == 0) {
> -		int ret;
> +	if (dio->head_page < dio->total_pages)
> +		return dio->pages[dio->head_page++];
>  
> -		ret = dio_refill_pages(dio);
> -		if (ret)
> -			return ERR_PTR(ret);
> -		BUG_ON(dio_pages_present(dio) == 0);
> -	}
> -	return dio->pages[dio->head++];
> +	return NULL;
>  }
>
> ...
>
> @@ -351,8 +280,10 @@ static void dio_bio_submit(struct dio *dio)
>   */
>  static void dio_cleanup(struct dio *dio)
>  {
> -	while (dio_pages_present(dio))
> -		page_cache_release(dio_get_page(dio));
> +	struct page *page;
> +
> +	while ((page = dio_get_page(dio)) != NULL)
> +		page_cache_release(page);
>  }

What is the value of dio->head_page here?

How are callers to use this function at the start of the operation, at
the end and partway through is IO error, EFAULT etc is detected?

There's good potential for double-releases, leaks etc here.  We need to
be very careful and explicit in documenting the usage and state and
meaning of head_page, and the protocol around managing it.

It's just like that ghastly bio.bi_idx thing - how many bugs did we add
and have to fix due to that thing?

Really I think it'd be better to just nuke .head_page altogether and get
callers to manage their index openly.

