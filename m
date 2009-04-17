Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZDQGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZDQGhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZDQGhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:37:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020AbZDQGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:37:03 -0400
Date: Fri, 17 Apr 2009 02:37:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] loop: use BIO list management functions
Message-ID: <20090417063702.GA16744@infradead.org>
References: <20090417063217.GA3515@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417063217.GA3515@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 03:32:17PM +0900, Akinobu Mita wrote:
> Impact: cleanup

I though we had pretty broad agreement that these lines are utter crap?
:)

>  static void loop_add_bio(struct loop_device *lo, struct bio *bio)
>  {
> -	if (lo->lo_biotail) {
> -		lo->lo_biotail->bi_next = bio;
> -		lo->lo_biotail = bio;
> -	} else
> -		lo->lo_bio = lo->lo_biotail = bio;
> +	bio_list_add(&lo->lo_bio_list, bio);
>  }

This function only has one caller, no need to keep it.

>  static struct bio *loop_get_bio(struct loop_device *lo)
>  {
> -	struct bio *bio;
> -
> -	if ((bio = lo->lo_bio)) {
> -		if (bio == lo->lo_biotail)
> -			lo->lo_biotail = NULL;
> -		lo->lo_bio = bio->bi_next;
> -		bio->bi_next = NULL;
> -	}
> -
> -	return bio;
> +	return bio_list_pop(&lo->lo_bio_list);
>  }

Same here.

> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -505,7 +505,7 @@ static inline int bio_has_data(struct bio *bio)
>  }
>  
>  /*
> - * BIO list managment for use by remapping drivers (e.g. DM or MD).
> + * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
>   *


I don't think this needs changing, that was just examples.


