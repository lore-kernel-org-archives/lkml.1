Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYAJIfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYAJIfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbYAJIeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:34:50 -0500
Received: from brick.kernel.dk ([87.55.233.238]:2386 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbYAJIes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:34:48 -0500
Date: Thu, 10 Jan 2008 09:34:46 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110083446.GQ6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801101242.25671.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Nick Piggin wrote:
> On Wednesday 09 January 2008 19:52, Jens Axboe wrote:
> 
> > So how does it work? Instead of punting IO to a thread and passing it
> > through the page cache, we instead attempt to send the IO directly to the
> > filesystem block that it maps to.
> 
> You told Christoph that just using direct-IO from kernel still doesn't
> give you the required behaviour... What about queueing the IO directly
> *and* using direct-IO? I guess it still has to go through the underlying
> filesystem, but that's probably a good thing.

If it was O_DIRECT and aio, then we would be close.

> > loop maintains a prio tree of known 
> > extents in the file (populated lazily on demand, as needed).
> 
> Just a quick question (I haven't looked closely at the code): how come
> you are using a prio tree for extents? I don't think they could be
> overlapping?

Because I'm really lazy - the core of this was basically first written
as a quick hack and then I always go shopping for reusable data
structures. prio trees fit the bill nicely, they described extents and
allowed loopup with a key anywhere in that extent. You are right in that
I don't need the overlap handling at all, and Chris already tried to
talk me into reusing his btrfs extent code :-)

So I may just do the latter, turning it into a lib/extent-map.c in the
longer run. My first priority was just having something that worked so I
could test it. At the end of the day, not a single soul would ever
notice if the prio tree ended up being slightly slower than a custom
solution.

-- 
Jens Axboe

