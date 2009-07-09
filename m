Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZGIRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZGIRic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZGIRiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:38:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35692 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbZGIRiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:38:24 -0400
Date: Thu, 9 Jul 2009 19:38:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
	cfq_find_alloc_queue()
Message-ID: <20090709173823.GN23611@kernel.dk>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> <x497hyz9d2g.fsf@segfault.boston.devel.redhat.com> <20090627182617.GX23611@kernel.dk> <20090709154446.GD30832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709154446.GD30832@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09 2009, Vivek Goyal wrote:
> On Sat, Jun 27, 2009 at 08:26:17PM +0200, Jens Axboe wrote:
> > On Fri, Jun 26 2009, Jeff Moyer wrote:
> > > Jens Axboe <jens.axboe@oracle.com> writes:
> > > 
> > > > Setup an emergency fallback cfqq that we allocate at IO scheduler init
> > > > time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> > > > punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> > > > never fails without having to ensure free memory.
> > > >
> > > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > ---
> > > >  block/cfq-iosched.c |  124 +++++++++++++++++++++++++++-----------------------
> > > >  1 files changed, 67 insertions(+), 57 deletions(-)
> > > >
> > > > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > > > index c760ae7..91e7e0b 100644
> > > > --- a/block/cfq-iosched.c
> > > > +++ b/block/cfq-iosched.c
> > > > +	/*
> > > > +	 * Fallback dummy cfqq for extreme OOM conditions
> > > > +	 */
> > > > +	struct cfq_queue oom_cfqq;
> > > 
> > > OK, so you're embedding a cfqq into the cfqd.  That's 136 bytes, so I
> > > guess that's not too bad.
> > > 
> > > > +	/*
> > > > +	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
> > > > +	 * Grab a permanent reference to it, so that the normal code flow
> > > > +	 * will not attempt to free it.
> > > > +	 */
> > > > +	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
> > > > +	atomic_inc(&cfqd->oom_cfqq.ref);
> > > > +
> > > 
> > > I guess this is so we never try to free it, good.  ;)
> > > 
> > > One issue I have with this patch is that, if a task happens to run into
> > > this condition, there is no way out.  It will always have the oom_cfqq
> > > as it's cfqq.  Can't we fix that if we recover from the OOM condition?
> > 
> > Yeah, I fixed that about an hour after posting the patches. See:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0370bc158cb1d5faa4b8a38c0de3211f0fd5bd64
> > 
> 
> Hi Jens,
> 
> I think above patch might not fix the issue of an oom_cfqq getting stuck
> with an io context. The reason being that once we allocate the cfqq, it
> will be cached in cic and once next request comes, we will retrieve it
> from cic and never call cfq_get_queue()/cfq_find_alloc_queue().
> 
> I think we probably need to do cfqq == oom_cfqq check in cfq_set_request()
> also.

Yes good catch, this is needed too!  Can you please send as a "real"
patch with signed-off-by added? Thanks!

-- 
Jens Axboe

