Return-Path: <linux-kernel-owner+w=401wt.eu-S939154AbZDJHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939154AbZDJHf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938546AbZDJH0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:26:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60195 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938543AbZDJH0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:26:03 -0400
Date: Fri, 10 Apr 2009 09:26:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tiobench read 50% regression with 2.6.30-rc1
Message-ID: <20090410072600.GP5178@kernel.dk>
References: <1239265763.2567.769.camel@ymzhang> <20090409095706.GD5178@kernel.dk> <1239330541.2567.779.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239330541.2567.779.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> On Thu, 2009-04-09 at 11:57 +0200, Jens Axboe wrote:
> > On Thu, Apr 09 2009, Zhang, Yanmin wrote:
> > > Comparing with 2.6.29's result, tiobench (read) has about 50% regression
> > > with 2.6.30-rc1 on all my machines. Bisect down to below patch.
> > > 
> > > b029195dda0129b427c6e579a3bb3ae752da3a93 is first bad commit
> > > commit b029195dda0129b427c6e579a3bb3ae752da3a93
> > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > Date:   Tue Apr 7 11:38:31 2009 +0200
> > > 
> > >     cfq-iosched: don't let idling interfere with plugging
> > >     
> > >     When CFQ is waiting for a new request from a process, currently it'll
> > >     immediately restart queuing when it sees such a request. This doesn't
> > >     work very well with streamed IO, since we then end up splitting IO
> > >     that would otherwise have been merged nicely. For a simple dd test,
> > >     this causes 10x as many requests to be issued as we should have.
> > >     Normally this goes unnoticed due to the low overhead of requests
> > >     at the device side, but some hardware is very sensitive to request
> > >     sizes and there it can cause big slow downs.
> > > 
> > > 
> > > 
> > > Command to start the testing:
> > > #tiotest -k0 -k1 -k3 -f 80 -t 32
> > > 
> > > It's a multi-threaded program and starts 32 threads. Every thread does I/O
> > > on its own 80MB file.
> The files should be created before the testing and pls. drop page caches
> by "echo 3 >/proc/sys/vm/drop_caches" before testing.
> 
> > 
> > It's not a huge surprise that we regressed there. I'll get this fixed up
> > next week. Can you I talk you into trying to change the 'quantum' sysfs
> > variable for the drive? It's in /sys/block/xxx/queue/iosched where xxx
> > is your drive(s). It's set to 4, if you could try progressively larger
> > settings and retest, that would help get things started.
> I tried 4,8,16,64,128 and didn't find result difference.

OK, that's good. I'm away from the source atm, but I think I know what
is going on. We need to kick the queue for anything but the first queued
request. I'll get it fixed up next week.

-- 
Jens Axboe

