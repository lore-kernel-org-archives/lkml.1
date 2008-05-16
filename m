Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYEPHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYEPHtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYEPHtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:49:23 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYEPHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:49:18 -0400
Date: Fri, 16 May 2008 09:49:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Matthew <jackdachef@gmail.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Message-ID: <20080516074913.GW16217@kernel.dk>
References: <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk> <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com> <20080514082622.GA16217@kernel.dk> <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com> <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com> <20080515070127.GH16217@kernel.dk> <20080515122156.GA11600@gandalf.sssup.it> <20080516064002.GL16217@kernel.dk> <20080516074628.GA17802@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516074628.GA17802@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16 2008, Fabio Checconi wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Fri, May 16, 2008 08:40:03AM +0200
> >
> ...
> > I think we can improve this further without getting too involved. If a
> > 2nd request is seen in cfq_rq_enqueued(), then DO schedule a dispatch
> > since this likely means that we wont be doing more merges on the first
> > one.
> > 
> 
> But isn't there the risk that even the second request would be
> dispatched, while it still could have grown?

Certainly, you'd only want to dispatch the first request. Ideally we'd
just get rid of this logic of 'did empty dispatch round' and only
dispatch requests once merging is done, it's basically the wrong thing
to do to make it visible to the io scheduler so soon. Well of course
even more ideally we'd always get big requests submitted, but
unfortunately many producers aren't that nice.

The per-process plugging actually solves this nicely, since we do the
merging outside of the io scheduler. Perhaps just not dispatch on a
plugged queue would help a bit. I'm somewhat against this principle of
messing too much with dispatch logic in the schedulers, it'd be nicer to
solve this higher up.

-- 
Jens Axboe

