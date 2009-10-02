Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZJBCzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZJBCzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZJBCzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:55:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:45714 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZJBCzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 22:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="194253048"
Date: Fri, 2 Oct 2009 10:55:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20091002025502.GA14246@localhost>
References: <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930141158.GG24383@mit.edu> <20091001151429.GB9469@localhost> <20091001215438.GY24383@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001215438.GY24383@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:54:38AM +0800, Theodore Ts'o wrote:
> On Thu, Oct 01, 2009 at 11:14:29PM +0800, Wu Fengguang wrote:
> > Yes and no. Yes if the queue was empty for the slow device. No if the
> > queue was full, in which case IO submission speed = IO complete speed
> > for previously queued requests.
> > 
> > So wbc.timeout will be accurate for IO submission time, and mostly
> > accurate for IO completion time. The transient queue fill up phase
> > shall not be a big problem?
> 
> So the problem is if we have a mixed workload where there are lots
> large contiguous writes, and lots of small writes which are fsync'ed()
> --- for example, consider the workload of copying lots of big DVD
> images combined with the infamous firefox-we-must-write-out-300-megs-of-
> small-random-writes-and-then-fsync-them-on-every-single-url-click-so-
> that-every-last-visited-page-is-preserved-for-history-bar-autocompletion
> workload.    The big writes, if the are contiguous, could take 1-2 seconds
> on a very slow, ancient laptop disk, and that will hold up any kind of 
> small synchornous activities --- such as either a disk read or a firefox-
> triggered fsync().

Yes, that's a problem. The SYNC/ASYNC elevator queues can help here.

In IO submission paths, fsync writes will not be blocked by non-sync
writes because __filemap_fdatawrite_range() starts foreground sync
for the inode. Without the congestion backoff, it will now have to
compete queue with bdi-flush. Should not be a big problem though.

There's still the problem of IO submission time != IO completion time,
due to fluctuations of randomness and more. However that's a general
and unavoidable problem.  Both the wbc.timeout scheme and the
"wbc.nr_to_write based on estimated throughput" scheme are based on
_past_ requests and it's simply impossible to have a 100% accurate
scheme. In principle, wbc.timeout will only be inferior at IO startup
time. In the steady state of 100% full queue, it is actually estimating
the IO throughput implicitly :)

> That's why the IO completion time matters; it causes latency problems
> for slow disks and mixed large and small write workloads.  It was the
> original reason for the 1024 MAX_WRITEBACK_PAGES, which might have
> made sense 10 years ago back when disks were a lot slower.  One of the
> advantages of an auto-tuning algorithm, beyond auto-adjusting for
> different types of hardware, is that we don't need to worry about
> arbitrary and magic caps beocoming obsolete due to technological
> changes.  :-)

Yeah, I'm a big fan of auto-tuning :)

Thanks,
Fengguang
