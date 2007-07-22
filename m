Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXGVXxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXGVXxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXGVXxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:53:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXGVXxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:53:40 -0400
Message-ID: <46A3EDD9.2090707@redhat.com>
Date: Sun, 22 Jul 2007 19:52:57 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
 memory size
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk> <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk>
In-Reply-To: <20070722085041.GS11657@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:

> I just wish you had a rationale behind them, I don't think it's that
> great of a series. I agree with the low point of 128k. Then it'd be sane
> to try and determine what the upper limit of ra window size goodness is,
> which is probably impossible since it depends on the hardware a lot. But
> lets just say the upper value is 2mb, then I think it's pretty silly
> _not_ to use 2mb on a 1g machine for instance. So more aggressive
> scaling.

1 or 2 MB is a nice number.

Seek time (plus rotational latency) on disks still takes
on the order of 10 ms, while disks commonly transfer data
on the order of 50MB/second.

That means one disk seek (10ms) takes as long as it takes
to read around 512kB of data.

The current 128kB means that if you have lots of streaming
IO going on, you spend only 20% of the time transferring
data and get roughly 10MB/s.  Seek 10ms, read 2.5ms worth
of data.

OTOH, if you do 2MB per request for the same heavy streaming
workload (say, an ftp or nfs server doing media files), you
can get 80% of the disk throughput, or 40MB/s.  This is because
you spend 40ms transferring data for every 10ms seek time.

Yes, filesystem metadata will reduce this "occasionally",
but the general idea holds.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
