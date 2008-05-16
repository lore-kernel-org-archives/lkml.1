Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYEPGkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYEPGkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYEPGkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:40:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25810 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYEPGkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:40:06 -0400
Date: Fri, 16 May 2008 08:40:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Matthew <jackdachef@gmail.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080516064002.GL16217@kernel.dk>
References: <20080513130508.GQ16217@kernel.dk> <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com> <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk> <20080515122156.GA11600@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515122156.GA11600@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15 2008, Fabio Checconi wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Thu, May 15, 2008 09:01:28AM +0200
> >
> > I don't think it's 2.6.25 vs 2.6.26-rc2, I can still reproduce some
> > request size offsets with the patch. So still fumbling around with this,
> > I'll be sending out another test patch when I'm confident it's solved
> > the size issue.
> > 
> 
> IMO an interesting thing is how/why anticipatory doesn't show the
> issue.  The device is not put into ANTIC_WAIT_NEXT if there is no
> dispatch returning no requests while the queue is not empty.  This
> seems to be enough in the reported workloads.
> 
> I don't think this behavior is the correct one (it is still racy
> WRT merges after breaking anticipation) anyway it should make things
> a little bit better.  I fear that a complete solution would not
> involve only the scheduler.
> 
> Introducing the very same behavior in cfq seems to be not so easy
> (i.e., start idling only if there was a dispatch round while the
> last request was being served) but an approximated version can be
> introduced quite easily.  The patch below should do that, rescheduling
> the dispatch only if necessary; it is not tested at all, just posted
> for discussion.

Daniel (and others in this thread), can you give this a shot as well? It
looks promising, it'll allow greater buildup of the request. From my
testing, instead of getting nicely aligned 128k or 256k requests, we'd
end up in a nasty 4k+124k stream. Delaying the first queue kick should
fix that, since we wont dispatch that first 4k request until it has been
merged.

I think we can improve this further without getting too involved. If a
2nd request is seen in cfq_rq_enqueued(), then DO schedule a dispatch
since this likely means that we wont be doing more merges on the first
one.

-- 
Jens Axboe

