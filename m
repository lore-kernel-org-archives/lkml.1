Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZHXIAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZHXIAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZHXIAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:00:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45725 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZHXIAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:00:49 -0400
Date: Mon, 24 Aug 2009 10:00:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] direct-io: make O_DIRECT IO path be page based
Message-ID: <20090824080051.GZ12579@kernel.dk>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com> <1250763466-24282-2-git-send-email-jens.axboe@oracle.com> <1250763466-24282-3-git-send-email-jens.axboe@oracle.com> <1250763466-24282-4-git-send-email-jens.axboe@oracle.com> <20090820171204.93c3fdb4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820171204.93c3fdb4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20 2009, Andrew Morton wrote:
> On Thu, 20 Aug 2009 12:17:38 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Currently we pass in the iovec array and let the O_DIRECT core
> > handle the get_user_pages() business. This work, but it means that
> > we can ever only use user pages for O_DIRECT.
> > 
> > Switch the aops->direct_IO() and below code to use page arrays
> > instead, so that it doesn't make any assumptions about who the pages
> > belong to. This works directly for all users but NFS, which just
> > uses the same helper that the generic mapping read/write functions
> > also call.
> >
> 
> This:
> 
> > +	struct page **pages;		/* page buffer */
> > +	unsigned int head_page;		/* next page to process */
> > +	unsigned int total_pages;	/* last valid page + 1 */
> > +	unsigned int first_page_off;	/* offset into first page in map */
> 
> Is a disaster waiting to happen.

It was a disaster already, there's actually not a lot of change. So I do
agree that that the hole page/cur_page/head_page needs cleaning up.

> >  static struct page *dio_get_page(struct dio *dio)
> >  {
> > -	if (dio_pages_present(dio) == 0) {
> > -		int ret;
> > +	if (dio->head_page < dio->total_pages)
> > +		return dio->pages[dio->head_page++];
> >  
> > -		ret = dio_refill_pages(dio);
> > -		if (ret)
> > -			return ERR_PTR(ret);
> > -		BUG_ON(dio_pages_present(dio) == 0);
> > -	}
> > -	return dio->pages[dio->head++];
> > +	return NULL;
> >  }
> >
> > ...
> >
> > @@ -351,8 +280,10 @@ static void dio_bio_submit(struct dio *dio)
> >   */
> >  static void dio_cleanup(struct dio *dio)
> >  {
> > -	while (dio_pages_present(dio))
> > -		page_cache_release(dio_get_page(dio));
> > +	struct page *page;
> > +
> > +	while ((page = dio_get_page(dio)) != NULL)
> > +		page_cache_release(page);
> >  }
> 
> What is the value of dio->head_page here?
> 
> How are callers to use this function at the start of the operation, at
> the end and partway through is IO error, EFAULT etc is detected?
> 
> There's good potential for double-releases, leaks etc here.  We need to
> be very careful and explicit in documenting the usage and state and
> meaning of head_page, and the protocol around managing it.
> 
> It's just like that ghastly bio.bi_idx thing - how many bugs did we add
> and have to fix due to that thing?
> 
> Really I think it'd be better to just nuke .head_page altogether and get
> callers to manage their index openly.

Completely agree, I'll attempt to sanitize it. Was postponed due to the
messy nature of it, but with that done it should be easier to verify
that it does the right thing.

-- 
Jens Axboe

