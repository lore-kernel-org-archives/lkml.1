Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYBEIZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYBEIZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYBEIYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:24:54 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5078 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbYBEIYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:24:53 -0500
Date: Tue, 5 Feb 2008 09:24:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Zach Brown <zach.brown@oracle.com>, David Chinner <dgc@sgi.com>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       James.Bottomley@SteelEye.com, andrea@suse.de, clameter@sgi.com,
       akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080205082450.GO15220@kernel.dk>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A7579F.2050809@oracle.com> <20080204201027.GJ15220@kernel.dk> <47A78797.8060601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A78797.8060601@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04 2008, Arjan van de Ven wrote:
> Jens Axboe wrote:
> >>I was imagining the patch a little bit differently (per-cpu tasks, do a
> >>wake_up from the driver instead of cpu nr testing up in blk, work
> >>queues, whatever), but we know how to iron out these kinds of details ;).
> >
> >per-cpu tasks/wq's might be better, it's a little awkward to jump
> >through hoops
> >
> 
> one caveat btw; when the multiqueue storage hw becomes available for Linux,
> we need to figure out how to deal with the preference thing; since there
> honoring a "non-logical" preference would be quite expensive (it means

non-local?

> you can't make the local submit queues lockless etc etc), so before we
> go down the road of having widespread APIs for this stuff.. we need to
> make sure we're not going to do something that's going to be really
> stupid 6 to 18 months down the road.

As far as I'm concerned, so far this is just playing around with
affinity (and to some extents taking it too far, on purpose). For
instance, my current patch can move submissions and completions
independently, with a set mask or by 'binding' a request to a CPU. Most
of that doesn't make sense. 'complete on the same CPU, if possible'
makes sense and would fit fine with multi-queue hw.

Moving submissions at the block layer to a defined set of CPUs is a bit
silly imho, it's pretty costly and it's a lot more sane simply bind the
submitters instead. So if you can set irq affinity, then just make the
submitters follow that.

-- 
Jens Axboe

