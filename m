Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZI0Qo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZI0Qo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZI0Qo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:44:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57762 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZI0Qo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:44:28 -0400
Date: Sun, 27 Sep 2009 18:44:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       jack@suse.cz
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-ID: <20090927164431.GB23126@kernel.dk>
References: <20090925141014.GB15853@think> <20090927013458.53e43459.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927013458.53e43459.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27 2009, Andrew Morton wrote:
> On Fri, 25 Sep 2009 10:10:14 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 8e1e5e1..27f8e0e 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -225,7 +225,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
> >  {
> >  	struct wb_writeback_args args = {
> >  		.sb		= sb,
> > -		.sync_mode	= WB_SYNC_ALL,
> > +		.sync_mode	= WB_SYNC_NONE,
> >  		.nr_pages	= LONG_MAX,
> >  		.range_cyclic	= 0,
> >  	};
> > @@ -236,6 +236,13 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
> >  
> >  	bdi_queue_work(bdi, &work);
> >  	bdi_wait_on_work_clear(&work);
> > +
> > +	args.sync_mode = WB_SYNC_ALL;
> > +	args.nr_pages = LONG_MAX;
> > +
> > +	work.state = WS_USED | WS_ONSTACK;
> > +	bdi_queue_work(bdi, &work);
> > +	bdi_wait_on_work_clear(&work);
> >  }
> 
> Those LONG_MAX's are a worry.  What prevents a very long
> almost-livelock from occurring if userspace is concurrently dirtying
> pagecache at a high rate?

Not sure whether Chris' system is back up again, but I discussed this
with him on irc. Since the WB_SYNC_ALL writeback should be queued behind
the WB_SYNC_NONE that the non-wait sync already issued, not sure why
this patch makes a difference. It's definitely not the right approach.

I'll debug this when I get back.

-- 
Jens Axboe

