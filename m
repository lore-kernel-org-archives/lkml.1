Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZDJC2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZDJC2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZDJC2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:28:25 -0400
Received: from mga06.intel.com ([134.134.136.21]:39866 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbZDJC2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="scan'208";a="505206829"
Subject: Re: tiobench read 50% regression with 2.6.30-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090409095706.GD5178@kernel.dk>
References: <1239265763.2567.769.camel@ymzhang>
	 <20090409095706.GD5178@kernel.dk>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 10:29:01 +0800
Message-Id: <1239330541.2567.779.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 11:57 +0200, Jens Axboe wrote:
> On Thu, Apr 09 2009, Zhang, Yanmin wrote:
> > Comparing with 2.6.29's result, tiobench (read) has about 50% regression
> > with 2.6.30-rc1 on all my machines. Bisect down to below patch.
> > 
> > b029195dda0129b427c6e579a3bb3ae752da3a93 is first bad commit
> > commit b029195dda0129b427c6e579a3bb3ae752da3a93
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Tue Apr 7 11:38:31 2009 +0200
> > 
> >     cfq-iosched: don't let idling interfere with plugging
> >     
> >     When CFQ is waiting for a new request from a process, currently it'll
> >     immediately restart queuing when it sees such a request. This doesn't
> >     work very well with streamed IO, since we then end up splitting IO
> >     that would otherwise have been merged nicely. For a simple dd test,
> >     this causes 10x as many requests to be issued as we should have.
> >     Normally this goes unnoticed due to the low overhead of requests
> >     at the device side, but some hardware is very sensitive to request
> >     sizes and there it can cause big slow downs.
> > 
> > 
> > 
> > Command to start the testing:
> > #tiotest -k0 -k1 -k3 -f 80 -t 32
> > 
> > It's a multi-threaded program and starts 32 threads. Every thread does I/O
> > on its own 80MB file.
The files should be created before the testing and pls. drop page caches
by "echo 3 >/proc/sys/vm/drop_caches" before testing.

> 
> It's not a huge surprise that we regressed there. I'll get this fixed up
> next week. Can you I talk you into trying to change the 'quantum' sysfs
> variable for the drive? It's in /sys/block/xxx/queue/iosched where xxx
> is your drive(s). It's set to 4, if you could try progressively larger
> settings and retest, that would help get things started.
I tried 4,8,16,64,128 and didn't find result difference.


