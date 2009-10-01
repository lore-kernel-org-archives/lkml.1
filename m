Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZJAVyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZJAVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZJAVyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:54:53 -0400
Received: from thunk.org ([69.25.196.29]:59623 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZJAVyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:54:53 -0400
Date: Thu, 1 Oct 2009 17:54:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20091001215438.GY24383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090928140756.GC17514@mit.edu> <20090930052657.GA17268@localhost> <20090930141158.GG24383@mit.edu> <20091001151429.GB9469@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001151429.GB9469@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 11:14:29PM +0800, Wu Fengguang wrote:
> Yes and no. Yes if the queue was empty for the slow device. No if the
> queue was full, in which case IO submission speed = IO complete speed
> for previously queued requests.
> 
> So wbc.timeout will be accurate for IO submission time, and mostly
> accurate for IO completion time. The transient queue fill up phase
> shall not be a big problem?

So the problem is if we have a mixed workload where there are lots
large contiguous writes, and lots of small writes which are fsync'ed()
--- for example, consider the workload of copying lots of big DVD
images combined with the infamous firefox-we-must-write-out-300-megs-of-
small-random-writes-and-then-fsync-them-on-every-single-url-click-so-
that-every-last-visited-page-is-preserved-for-history-bar-autocompletion
workload.    The big writes, if the are contiguous, could take 1-2 seconds
on a very slow, ancient laptop disk, and that will hold up any kind of 
small synchornous activities --- such as either a disk read or a firefox-
triggered fsync().

That's why the IO completion time matters; it causes latency problems
for slow disks and mixed large and small write workloads.  It was the
original reason for the 1024 MAX_WRITEBACK_PAGES, which might have
made sense 10 years ago back when disks were a lot slower.  One of the
advantages of an auto-tuning algorithm, beyond auto-adjusting for
different types of hardware, is that we don't need to worry about
arbitrary and magic caps beocoming obsolete due to technological
changes.  :-)

							- Ted

