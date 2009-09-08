Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZIHENw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZIHENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 00:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZIHENv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:13:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:4304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZIHENv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185057930"
Date: Tue, 8 Sep 2009 12:13:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] trace bio queueing trial only when it occurs
Message-ID: <20090908041345.GA16315@localhost>
References: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop> <20090908005520.GA7967@localhost> <4AA5BB3E.4050808@cn.fujitsu.com> <28c262360909072110j8ef5962h7231be5c03d68da3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360909072110j8ef5962h7231be5c03d68da3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:10:55PM +0800, Minchan Kim wrote:
> On Tue, Sep 8, 2009 at 11:02 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> > Wu Fengguang wrote:
> >> Minchan,
> >>
> >> I tend to agree with the change, but somehow confused by blkparse(1):
> >>
> >>         Q -- queued   This notes *intent* to queue i/o at the given location.  No real requests exists yet.
> >>
> >> Li Zefan has been working on blktrace and he can tell more.
> >>
> >
> > I work on ftrace-plugin blktrace and blk TRACE_EVENT, but don't know
> > much about the old blktrace history. ;)
> >
> > I think the manpage says it's called before ->make_request_fn(), so
> > "No real requests exist yet".
> >
> > Actually the trace was called just before make_request at first:
> >        2056a782f8e7e65fd4bfd027506b4ce1c5e9ccd4
> >
> > And then 2 patches added some checks between them:
> >        5ddfe9691c91a244e8d1be597b6428fcefd58103
> >        51fd77bd9f512ab6cc9df0733ba1caaab89eb957
> >
> > It seems to me it makes sense to have this patch.
> 
> Thanks for good information.
> Yes. It seems above 2 patches seem to break the rule.
> Could I add your ACK?

Sure, thanks!

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

> >> Thanks,
> >> Fengguang
> >>
> >> On Tue, Sep 08, 2009 at 08:34:16AM +0800, Minchan Kim wrote:
> >>> It got lost in LKML mail storm.
> >>> I resend this.
> >>> Wu, Could you review this patch, please?
> >>>
> >>> == CUT_HERE ==
> >>>
> >>> If BIO is discarded or cross over end of device,
> >>> BIO queueing trial doesn't occur.
> >>>
> >>> Let's trace it only when it happens.
> >>>
> >>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >>> ---
> >>>  block/blk-core.c |    4 ++--
> >>>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>> index 5b59592..1a0cfd5 100644
> >>> --- a/block/blk-core.c
> >>> +++ b/block/blk-core.c
> >>> @@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
> >>>              if (old_sector != -1)
> >>>                      trace_block_remap(q, bio, old_dev, old_sector);
> >>>
> >>> -            trace_block_bio_queue(q, bio);
> >>> -
> >>>              old_sector = bio->bi_sector;
> >>>              old_dev = bio->bi_bdev->bd_dev;
> >>>
> >>> @@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
> >>>                      goto end_io;
> >>>              }
> >>>
> >>> +            trace_block_bio_queue(q, bio);
> >>> +
> >>>              ret = q->make_request_fn(q, bio);
> >>>      } while (ret);
> >>>
> >>> --
> >>> 1.6.4
> >>>
> >>>
> >>>
> >
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
