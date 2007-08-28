Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbXH1Rzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbXH1Rzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXH1RzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:55:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36309 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXH1RzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:55:14 -0400
Date: Tue, 28 Aug 2007 21:54:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [1/1] Block device throttling [Re: Distributed storage.]
Message-ID: <20070828175403.GA28440@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708271457.38100.phillips@phunq.net> <20070828093540.GB20534@2ka.mipt.ru> <200708281027.59528.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708281027.59528.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 10:27:59AM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> > We do not care about one cpu being able to increase its counter
> > higher than the limit, such inaccuracy (maximum bios in flight thus
> > can be more than limit, difference is equal to the number of CPUs -
> > 1) is a price for removing atomic operation. I thought I pointed it
> > in the original description, but might forget, that if it will be an
> > issue, that atomic operations can be introduced there. Any
> > uber-precise measurements in the case when we are close to the edge
> > will not give us any benefit at all, since were are already in the
> > grey area.
> 
> This is not just inaccurate, it is suicide.  Keep leaking throttle 
> counts and eventually all of them will be gone.  No more IO
> on that block device!

First, because number of increased and decreased operations are the
same, so it will dance around limit in both directions. Second, I
wrote about this race and there is number of ways to deal with it, from
atomic operations to separated counters for in-flight and completed
bios (which can be racy too, but in different angle). Third, if people
can not agree even on much higher layer detail about should bio
structure be increased or not, how we can discuss details of
the preliminary implementation with known issues.

So I can not agree with fatality of the issue, but of course it exists,
and was highlighted.

Let's solve problems in order of their appearence. If bio structure will
be allowed to grow, then the whole patches can be done better, if not,
then there are issues with performance (although the more I think, the
more I become sure that since bio itself is very rarely shared, and thus
requires cloning and alocation/freeing, which itself is much more costly
operation than atomic_sub/dec, it can safely host additional operation).

-- 
	Evgeniy Polyakov
