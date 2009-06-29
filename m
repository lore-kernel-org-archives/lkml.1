Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZF2RsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZF2RsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZF2RsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:48:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51053 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbZF2RsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:48:07 -0400
Date: Mon, 29 Jun 2009 19:48:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] cfq-iosched: get rid of the need for __GFP_FAIL in
	cfq_find_alloc_queue()
Message-ID: <20090629174809.GO23611@kernel.dk>
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com> <1246007120-24034-3-git-send-email-jens.axboe@oracle.com> <x497hyz9d2g.fsf@segfault.boston.devel.redhat.com> <20090627182617.GX23611@kernel.dk> <x494otzxid3.fsf@segfault.boston.devel.redhat.com> <20090629173418.GN23611@kernel.dk> <x494otzvst4.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494otzvst4.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Mon, Jun 29 2009, Jeff Moyer wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >> 
> >> > On Fri, Jun 26 2009, Jeff Moyer wrote:
> >> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >> >> 
> >> >> > Setup an emergency fallback cfqq that we allocate at IO scheduler init
> >> >> > time. If the slab allocation fails in cfq_find_alloc_queue(), we'll just
> >> >> > punt IO to that cfqq instead. This ensures that cfq_find_alloc_queue()
> >> >> > never fails without having to ensure free memory.
> >> >> >
> >> >> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >> >> > ---
> >> >> >  block/cfq-iosched.c |  124 +++++++++++++++++++++++++++-----------------------
> >> >> >  1 files changed, 67 insertions(+), 57 deletions(-)
> >> >> >
> >> >> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> >> > index c760ae7..91e7e0b 100644
> >> >> > --- a/block/cfq-iosched.c
> >> >> > +++ b/block/cfq-iosched.c
> >> >> > +	/*
> >> >> > +	 * Fallback dummy cfqq for extreme OOM conditions
> >> >> > +	 */
> >> >> > +	struct cfq_queue oom_cfqq;
> >> >> 
> >> >> OK, so you're embedding a cfqq into the cfqd.  That's 136 bytes, so I
> >> >> guess that's not too bad.
> >> >> 
> >> >> > +	/*
> >> >> > +	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
> >> >> > +	 * Grab a permanent reference to it, so that the normal code flow
> >> >> > +	 * will not attempt to free it.
> >> >> > +	 */
> >> >> > +	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
> >> >> > +	atomic_inc(&cfqd->oom_cfqq.ref);
> >> >> > +
> >> >> 
> >> >> I guess this is so we never try to free it, good.  ;)
> >> >> 
> >> >> One issue I have with this patch is that, if a task happens to run into
> >> >> this condition, there is no way out.  It will always have the oom_cfqq
> >> >> as it's cfqq.  Can't we fix that if we recover from the OOM condition?
> >> >
> >> > Yeah, I fixed that about an hour after posting the patches. See:
> >> >
> >> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=0370bc158cb1d5faa4b8a38c0de3211f0fd5bd64
> >> >
> >> > I didn't post the 3/2 patch though.
> >> 
> >> OK, that looks better.  Are you reposting the series, then?
> >
> > Yeah, I'll fold the last two patches together and repost.
> 
> When you do, you can add my:
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Will do, thanks!

-- 
Jens Axboe

