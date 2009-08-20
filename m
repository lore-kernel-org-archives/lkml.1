Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbZHTXMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbZHTXMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZHTXMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:12:07 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5934 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZHTXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:12:07 -0400
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
In-Reply-To: <20090820104000.GH12579@kernel.dk>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
	 <1250708742.5589.23.camel@cail> <20090819220640.GW12579@kernel.dk>
	 <1250720604.5589.50.camel@cail>  <20090820104000.GH12579@kernel.dk>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 19:12:07 -0400
Message-Id: <1250809927.5738.77.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 12:40 +0200, Jens Axboe wrote:
> On Wed, Aug 19 2009, Alan D. Brunelle wrote:
> > On Thu, 2009-08-20 at 00:06 +0200, Jens Axboe wrote:
> > 
> > > 
> > > Thanks a lot for the test run, Alan. I wonder why writes are down while
> > > reads are up. One possibility could be a WRITE vs WRITE_ODIRECT
> > > difference, though I think they should be the same. The patches I posted
> > > have not been benchmarked at all, it's still very much a work in
> > > progress. I just wanted to show the general direction that I thought
> > > would be interesting. So I have done absolutely zero performance
> > > testing, it's only been tested for whether it still worked or not (to
> > > some degree :-)...
> > > lib
> > > I'll poke a bit at it here, too. I want to finish the unplug/wait
> > > problem first. Is your test case using read/write or readv/writev?
> > > 
> > 
> > Hi Jens - I just had some extra cycles, so figured what the heck... :-)
> > 
> > Actually, this is using asynchronous direct I/Os (libaio/Linux native
> > AIO). If I get a chance tomorrow, I'll play with read/write (and/or
> > readv/writev). 
> 
> OK, then I wonder what the heck is up... Did you catch any io metrics?
> 

Hi Jens - 

Took a different tack: Using FIO, I put it through its paces using the
following variables:

kernels: 2.6.31-rc6 / 2.6.31-rc6 + loop-direct git branch
I/O direction: read / write
Seek behavior: sequential / random
FIO engines (modes): libaio / posixaio / psync / sync / vsync
I/O size: 4K / 16K / 64K / 256K

Up at http://free.linux.hp.com/~adb/2009-08-20/bench_modes.png I have a
(very large) .png with all the data present - left column shows
throughput (as measured by FIO), right column has %user + %system (as
measured by FIO). To view this, download the .png & run 'eog' (or
whatever your favorite .png viewer is), blow it up and scroll down to
see the 20 pairs of graphs. 

The 2.6.31-rc6 kernel data is in red, the loop-direct results are in
blue.

It's showing some strange things at this point - The most scary thing is
certainly the random & sequential writes using posixaio - HUGE drops in
performance with the loop-direct branch. But, for some reason, random
write's using libaio look better with your loop-direct branch. 

In http://free.linux.hp.com/~adb/2009-08-20/data.tar.bz2 I have /all/
the FIO job-files & FIO output files used to generate these graphs.

I've got some scripts to automate doing these runs & generating the
graphs, so I'm all primed to continue testing this with future versions
of this patch sequence. (I can easily automate it to utilize iostat
and/or blktrace if you'd like (need?) that data as well.) (It only takes
about 4 hours (plus reboot time) to do this, so it's not a big deal.)

Alan D. Brunelle
Hewlett-Packard

