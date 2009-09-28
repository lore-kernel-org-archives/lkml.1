Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbZI1NdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbZI1NdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZI1NdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:33:01 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19733 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZI1NdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:33:00 -0400
Date: Mon, 28 Sep 2009 09:32:19 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-ID: <20090928133219.GA6405@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
References: <20090925141014.GB15853@think>
 <20090927013458.53e43459.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927013458.53e43459.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AC0BAE5.0094:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 01:34:58AM -0700, Andrew Morton wrote:
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
> 

In this case, we should be called from unmount.  But, Jens tells me my
patch isn't quite right because even without my patch, the WB_SYNC_ALL
run is queued onto the tail of the list after the WB_SYNC_NONE run.

So, I need to trace it a little better.   My initial theory was that the
nr_dirty number done by the first WB_SYNC_NONE run wasn't big enough.
Once btrfs writepage kicks in, it can make more dirty metadata pages to
close out the delalloc, and if those get written first things could exit
before all the data pages are on disk.

Its a theory anyway, I'll dig in more.

-chris
