Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZJZN2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZJZN2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZJZN2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:28:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42511 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbZJZN2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:28:12 -0400
Date: Mon, 26 Oct 2009 14:28:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] cfq: implement merging and breaking up of
	cfq_queues
Message-ID: <20091026132816.GE10727@kernel.dk>
References: <1256332492-24566-1-git-send-email-jmoyer@redhat.com> <4e5e476b0910241308s4a14fb69jbc6f8d35eb0ab78@mail.gmail.com> <20091026114011.GD10727@kernel.dk> <4e5e476b0910260620l3eb6c0a4u422cad1e5386bd71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0910260620l3eb6c0a4u422cad1e5386bd71@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26 2009, Corrado Zoccolo wrote:
> Hi Jens
> On Mon, Oct 26, 2009 at 12:40 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Sat, Oct 24 2009, Corrado Zoccolo wrote:
> >> You identified the problem in the idling logic, that reduces the
> >> throughput in this particular scenario, in which various threads or
> >> processes issue (in random order) the I/O requests with different I/O
> >> contexts on behalf of a single entity.
> >> In this case, any idling between those threads is detrimental.
> >> Ideally, such cases should be already spotted, since think time should
> >> be high for such processes, so I wonder if this indicates a problem in
> >> the current think time logic.
> >
> > That isn't necessarily true, it may just as well be that there's very
> > little think time (don't see the connection here). A test case to
> > demonstrate this would be a number of processes/threads splitting a
> > sequential read of a file between them.
> 
> Jeff said that the huge performance drop was not observable with noop
> or any other work conserving scheduler.
> Since noop doesn't enforce any I/O ordering, but just ensures that any
> I/O passes through ASAP,
> this means that the biggest problem is due to idling, while the
> increased seekiness has just a small impact.

Not true, noop still does merging. And even if it didn't, if you have
queuing on the device side things may still work out. The key being that
you actually send those off to the device, which the idling will prevent
for CFQ. The biggest problem is of course due to idling, if we didn't
idle between the cooperating processes then there would not be an issue.
And this is exactly what Jeff has done, merge those.

The test app is of course timing sensitive to some degree, since if the
threads get too far out of sync then things will go down the drain.

You could argue that decreasing the seekiness threshold would "fix"
that, but that would surely not work for other cases where and app is
mostly sequential but has to fetch meta data and such.

> So your test case doesn't actually match the observations: each thread
> will always have new requests to submit (so idling doesn't penalize
> too much here), while the seekiness introduced will be the most
> important factor.
> 
> I think the real test case is something like (single dd through nfs via udp):
> * there is a single thread, that submits a small number of requests
> (e.g. 2) to a work queue, and wait for their completion before
> submitting new requests
> * there is a thread pool that executes those requests (1 thread runs 1
> request), and signals back completion. Threads in the pool are
> selected randomly.

Same thing, you just get rid of the timing constraint. A test case would
ensure that as well.

-- 
Jens Axboe

