Return-Path: <linux-kernel-owner+w=401wt.eu-S1765918AbXGKS1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765918AbXGKS1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbXGKS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:26:58 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1380 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbXGKS05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:26:57 -0400
Date: Wed, 11 Jul 2007 20:26:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       olaf.kirch@oracle.com, johnpol@2ka.mipt.ru
Subject: Re: [PATCH][RFC] network splice receive v3
Message-ID: <20070711182659.GD4587@kernel.dk>
References: <20070711091927.GQ4587@kernel.dk> <20070711181758.GX1011@tasint.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711181758.GX1011@tasint.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11 2007, Joel Becker wrote:
> On Wed, Jul 11, 2007 at 11:19:27AM +0200, Jens Axboe wrote:
> > Subject: [PATCH] splice: don't assume regular pages in splice_to_pipe()
> > 
> > Allow caller to pass in a release function, there might be
> > other resources that need releasing as well. Needed for
> > network receive.
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 3160951..4b4b501 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -254,11 +254,16 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  	}
> >  
> >  	while (page_nr < spd_pages)
> > -		page_cache_release(spd->pages[page_nr++]);
> > +		spd->spd_release(spd, page_nr++);
> 
> 	Rather than requiring the caller set this, shouldn't we just
> allow it?  Especially given there is only one non-page user?
> 
>   	while (page_nr < spd_pages)
>  -		page_cache_release(spd->pages[page_nr++]);
>  +		if (spd->spd_release)
>  +			spd->spd_release(spd, page_nr++);
>  +		else
>  +			page_cache_release(spd->pages[page_nr++]);

Certainly possible, I think it's cleaner with it always being set
though. If it grows other out-of-splice.c users, then your change may be
a good idea though.

-- 
Jens Axboe

