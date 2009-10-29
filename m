Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbZJ2TL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbZJ2TL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZJ2TL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:11:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43645 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbZJ2TL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:11:26 -0400
Date: Thu, 29 Oct 2009 20:11:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: simplify prio-unboost code
Message-ID: <20091029191131.GX10727@kernel.dk>
References: <200910262136.03233.czoccolo@gmail.com> <20091029131944.GN10727@kernel.dk> <4e5e476b0910291012k39c3b69byc84ab0d0b41bd616@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0910291012k39c3b69byc84ab0d0b41bd616@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29 2009, Corrado Zoccolo wrote:
> On Thu, Oct 29, 2009 at 2:19 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Oct 26 2009, Corrado Zoccolo wrote:
> >> Eliminate redundant checks.
> >>
> >> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> >> ---
> >>  block/cfq-iosched.c |    8 +++-----
> >>  1 files changed, 3 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index 6e9b395..244bc8a 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -2611,12 +2611,10 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
> >>                       cfqq->ioprio = IOPRIO_NORM;
> >>       } else {
> >>               /*
> >> -              * check if we need to unboost the queue
> >> +              * unboost the queue (if needed)
> >>                */
> >> -             if (cfqq->ioprio_class != cfqq->org_ioprio_class)
> >> -                     cfqq->ioprio_class = cfqq->org_ioprio_class;
> >> -             if (cfqq->ioprio != cfqq->org_ioprio)
> >> -                     cfqq->ioprio = cfqq->org_ioprio;
> >> +             cfqq->ioprio_class = cfqq->org_ioprio_class;
> >> +             cfqq->ioprio = cfqq->org_ioprio;
> >>       }
> >
> > Not sure I see much gain in that, the previous code makes it explicit
> > that it may not be different and avoid dirtying cfqq if it isn't.
> 
> From readability p.o.v., it is simpler to understand the direct assignment.

Debatable :-)

> The comment says that they might already be equal, but the code states
> clearly what is the final state, i.e. they will surely be equal at the
> end-

Naturally that is true, since we assign if they aren't equal.

> Moreover, using two branches to avoid dirtying a cache line is not a
> win performance-wise, given the penalty on mispredicted branches, and
> the fact that the interval between two executions of this code is
> large, so the branch predictor entries for those would be already
> replaced by userspace ones.
> 
> If on some exotic MP hardware dirtying a cache line could be very
> expensive, a similar check could be done in hardware, and it would be
> more efficient, in fact it could distinguish the 2 cases:
> * we already have the shared cache line locally -> we can compare the
> value and absorb the write if it doesn't change
> * we don't have the cache line locally -> we acquire the cache line in
> exclusive mode, so we can do the write directly (on the contrary, the
> previous code would first acquire the cache line as shared, and if
> necessary, upgrade it to exclusive, possibly increasing the traffic).

If we just improve the comment to state that they may or may not be
equal before assigning them, then I'm fine with changing it. Code
readability to me trumps micro optimizations, because frankly it's not
like either case would make any measurable difference. Comments aren't
quite as good as code, but it's good enough here at least.

-- 
Jens Axboe

