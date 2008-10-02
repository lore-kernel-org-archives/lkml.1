Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYJBHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYJBHqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYJBHpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:45:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbYJBHpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:45:44 -0400
Date: Thu, 2 Oct 2008 09:45:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002074523.GW19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001235501.2b7f50fe.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01 2008, Andrew Morton wrote:
> On Thu, 2 Oct 2008 08:27:37 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 01 2008, Andrew Morton wrote:
> > > On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > > 
> > > > Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> > > 
> > > You proposed this a while back and it didn't happen and I forget
> > > why and the changelog doesn't mention any of that?
> > 
> > I think you called for benchmark results, which I don't think happened.
> > The patch definitely makes sense, so we should just make sure that we
> > don't regress elsewhere. Honestly, I'd be surprised if we did...
> 
> Now I think about it, didn't the earlier patch tweak CPU priority and
> not IO priority?  I forget.  <kicks the changelog again>
> 
> > How about I just toss it into the 2.6.28 testing mix, plenty of time for
> > testing and such?
> 
> Many performance regressions don't get noticed for six or twelve
> months, by which time everyone is suffering from them (see
> kernel/sched.c).
> 
> kjournald does huge amounts of not-terribly-important writeback.  One
> obvious risk is that by making all that bulk writeback high-priority,
> read-latency-sensitive applications might suffer latency spikes.
> 
> 
> 
> Now, kjournald is _supposed_ to be mostly asynchronous wrt foreground
> operations.  And once upon a time (seven years ago) it mostly was.  But
> there was some horrid race which I ended up fixing by introducing one
> point where synchronous userspace actions had to block behind kjournald
> activity.  I spent quite some time on it but couldn't come up with
> anything better.  It had fairly bad effects on some workloads.
> 
> I've forgotten where that code is now, but I don't think it was ever
> revisited.  It should be.
> 
> So.  Where are these atime updaters getting blocked?

Behind other IO activity I suppose, since it's marked async. A more
appropriate fix may be to mark atime updates as sync IO.

Once upon a time I actually did start xxxing meta data IO from the file
system, in ext3. That was mainly for blktrace so we could inspect what
data was what at the trace end, but if we had full coverage (or better,
at least), we could use that to bump priority as well. Probably the
priority should be left at the default, but the IO should be upgraded to
SYNC instead. That'll ensure that it goes out fairly quickly (like other
IO at the same class), but not get preferential treatment apart from
that. Seems like the right thing to do.

-- 
Jens Axboe

