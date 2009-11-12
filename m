Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZKLNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZKLNQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZKLNQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:16:16 -0500
Received: from [95.166.99.235] ([95.166.99.235]:56479 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZKLNQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:16:16 -0500
Date: Thu, 12 Nov 2009 14:16:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection
	code
Message-ID: <20091112131620.GL8742@kernel.dk>
References: <200911101454.57522.czoccolo@gmail.com> <20091110151431.GI8742@kernel.dk> <4e5e476b0911100956u47bb3111jeba9fbcc3d992960@mail.gmail.com> <20091112121648.GJ8742@kernel.dk> <4e5e476b0911120514t5a1a7256s6c762dd2f8596ab9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911120514t5a1a7256s6c762dd2f8596ab9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12 2009, Corrado Zoccolo wrote:
> On Thu, Nov 12, 2009 at 1:16 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Nov 10 2009, Corrado Zoccolo wrote:
> >> On Tue, Nov 10, 2009 at 4:14 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> >> > On Tue, Nov 10 2009, Corrado Zoccolo wrote:
> >> >> The core block layer already has code to detect presence of command
> >> >> queuing devices. We convert cfq to use that instead of re-doing the
> >> >> computation.
> >> >
> >> > There's is the major difference that the CFQ variant is dynamic and the
> >> > block layer one is not. This change came from Aaron some time ago IIRC,
> >> > see commit 45333d5. It's a bit of a chicken and egg problem.
> >>
> >> The comment by Aaron:
> >>     CFQ's detection of queueing devices assumes a non-queuing device and detects
> >>     if the queue depth reaches a certain threshold.  Under some workloads (e.g.
> >>     synchronous reads), CFQ effectively forces a unit queue depth,
> >> thus defeating
> >>     the detection logic.  This leads to poor performance on queuing hardware,
> >>     since the idle window remains enabled.
> >>
> >> makes me think that the dynamic-off detection in cfq may really be
> >> buggy (BTW this could explain the bad results on SSD Jeff observed
> >> before my patch set).
> >> The problem is, that once the hw_tag is 0, it is difficult for it to
> >> become 1 again, as explained by Aaron, since cfq will hardly send more
> >> than 1 request at a time. My patch set fixes this for SSDs (the seeky
> >> readers will still be sent without idling, and if they are enough, the
> >> logic will see a large enough depth to reconsider the initial
> >> decision).
> >>
> >> So the only sound way to do the detection is to start in an
> >> indeterminate state, in which CFQ behaves as if hw_tag = 1, and then,
> >> if for a long observation period we never saw large depth, we switch
> >> to hw_tag = 0, otherwise we stick to hw_tag = 1, without reconsidering
> >> it.
> >
> > That is probably the better way to do it, as I said earlier it is indeed
> > a chicken and egg problem. Care to patch something like that up?
> Ok.
> 
> >> I think the correct logic could be pushed to the blk-core, by
> >> introducing also an indeterminate bit.
> >
> > And I still don't think that is a good idea. The block layer case cares
> > more about the capability side ("is this a good ssd?") where as the CFQ
> > case incorporates process behaviour as well. I'll gladly take patches to
> > improve the CFQ logic.
> Ok, I'll work on CFQ side then.
> 
> What about other possible measurements (e.g. avg seek time could be
> used to adjust the slice_idle parameter)? Should they go into cfq, or
> in the block layer, or possibly in a separate library that is used by
> cfq?

I'd just stick it in CFQ, since that's where we use it. If there are
other uses for it, we can always migrate it to a common helper.

-- 
Jens Axboe

