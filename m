Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZGBNm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZGBNm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZGBNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:42:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:14301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbZGBNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:42:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,334,1243839600"; 
   d="scan'208";a="160906947"
Date: Thu, 2 Jul 2009 20:37:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: fio sync read 4k block size 35% regression
Message-ID: <20090702123747.GA8503@localhost>
References: <1246418733.2560.468.camel@ymzhang> <20090701041010.GB22364@localhost> <1246424635.2560.470.camel@ymzhang> <20090701125027.GA28347@localhost> <1246505660.2560.482.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246505660.2560.482.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 11:34:20AM +0800, Zhang, Yanmin wrote:
> On Wed, 2009-07-01 at 20:50 +0800, Wu Fengguang wrote:
> > On Wed, Jul 01, 2009 at 01:03:55PM +0800, Zhang, Yanmin wrote:
> > > On Wed, 2009-07-01 at 12:10 +0800, Wu Fengguang wrote:
> > > > On Wed, Jul 01, 2009 at 11:25:33AM +0800, Zhang, Yanmin wrote:
> > > > > Comapraing with 2.6.30, fio sync read (block size 4k) has about 35% regression
> > > > > with kernel 2.6.31-rc1 ﻿on my stoakley machine with a JBOD (13 SCSI disks).
> > > > > 
> > > > > Every disk has 1 partition and 4 1-GB files. Start 10 processes per disk to
> > > > > do sy﻿nc read sequentinally.
> > > > > 
> > > > > Bisected down to below patch.
> > > > > 
> > > > > 51daa88ebd8e0d437289f589af29d4b39379ea76 is first bad commit
> > > > > commit 51daa88ebd8e0d437289f589af29d4b39379ea76
> > > > > Author: Wu Fengguang <fengguang.wu@intel.com>
> > > > > Date:   Tue Jun 16 15:31:24 2009 -0700
> > > > > 
> > > > >     readahead: remove sync/async readahead call dependency
> > > > > 
> > > > >     The readahead call scheme is error-prone in that it expects the call sites
> > > > >     to check for async readahead after doing a sync one.  I.e.
> > > > > 
> > > > >                         if (!page)
> > > > >                                 page_cache_sync_readahead();
> > > > >                         page = find_get_page();
> > > > >                         if (page && PageReadahead(page))
> > > > >                                 page_cache_async_readahead();
> > > > > 
> > > > > 
> > > > > I also test block size 64k and 128k, but they don't have regression. Perhaps
> > > > > the default read_ahead_kb is equal to 128?
> > > > > 
> > > > > Other 2 machines have no such regression. The JBODS of the 2 machines consists
> > > > > of 12 and 7 SATA/SAS disks while every disk has 2 partitions.
> > > > 
> > > > Yanmin, thanks for the tests!
> > > > 
> > > > Maybe the patch posted here can restore the performance:
> > > > 
> > > > http://lkml.org/lkml/2009/5/21/319
> > > I tried it and it doesn't help.
> > 
> > Then let's check what's happening behind the scene :)
> > 
> > Please apply the attached patch and run
> > 
> >         echo 1 > /debug/readahead/trace_enable
> >         # do benchmark
> >         echo 0 > /debug/readahead/trace_enable
> > 
> > and send the dmesg which will contain lots of lines like
> > 
> >         [   54.738105] readahead-initial0(pid=3290(zsh), dev=00:10(0:10), ino=105910(dmesg), req=0+1, ra=0+4-3, async=0) = 2
> >         [   54.751801] readahead-subsequent(pid=3290(dmesg), dev=00:10(0:10), ino=105910(dmesg), req=1+60, ra=4+8-8, async=1, miss=0) = 0
> I enlarged sys log buffer to 2MB and captured below data.

Thank you! Judging from these readahead requests, it's doing perfect
64-page IOs. So the readahead size for sdm1 is 256KB? As long as the
real IO size is 256KB, it should not create that much performance
regression.

However there are some CPU overheads caused by readahead cache hits
(the lines start with ==>). In this case, 4 processes are sequentially
reading the same file, whoever goes first and foremost will trigger
the readahead IO. Or sometimes two processes hit the PG_readahead page
almost at the same time, and submit duplicate readahead requests for
the same page(s). The duplicate efforts will be detected at radix tree
insertion time, so won't lead to duplicate IO.

That is a known issue, and should only cost a little CPU time.

Since I cannot find out the (real) problem by reasoning, can you
provide more data please?
- make sure the regression(s) disappear with 2.6.31-rc1+revert-51daa88ebd8e0
- collect some readahead traces with 2.6.31-rc1+revert-51daa88ebd8e0
- collect some blktrace data on sdm1 with 2.6.31-rc1

        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=143693+1, ra=143757+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=143757+1, ra=143821+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=143821+1, ra=143885+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=143885+1, ra=143949+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=143949+1, ra=144013+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144013+1, ra=144077+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144077+1, ra=144141+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144141+1, ra=144205+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144205+1, ra=144269+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144269+1, ra=144333+64-64, async=1) = 64
        readahead-marker(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=144333+1, ra=144397+64-64, async=1) = 64
        readahead-subsequent(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=144397+1, ra=144461+64-64, async=1) = 64
        readahead-marker(pid=7102(fio), dev=08:c1(sdm1), ino=49156(f4), req=144461+1, ra=144525+64-64, async=1) = 64
        readahead-marker(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144525+1, ra=144589+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144589+1, ra=144653+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144653+1, ra=144717+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144717+1, ra=144781+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144781+1, ra=144845+64-64, async=1) = 64
==>     readahead-marker(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=144845+1, ra=144909+64-64, async=1) = 64
==>     readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144909+1, ra=144909+128-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=144973+1, ra=145037+64-64, async=1) = 64
        readahead-marker(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=145037+1, ra=145101+64-64, async=1) = 64
==>     readahead-subsequent(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=145101+1, ra=145165+64-64, async=1) = 64
==>     readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=145101+1, ra=145101+128-64, async=1) = 64
==>     readahead-subsequent(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=145165+1, ra=145229+64-64, async=1) = 64
==>     readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=145165+1, ra=145229+64-64, async=1) = 64
        readahead-subsequent(pid=7115(fio), dev=08:c1(sdm1), ino=49156(f4), req=145229+1, ra=145293+64-64, async=1) = 64
        readahead-marker(pid=7154(fio), dev=08:c1(sdm1), ino=49156(f4), req=145357+1, ra=145421+64-64, async=1) = 64
        readahead-subsequent(pid=7167(fio), dev=08:c1(sdm1), ino=49156(f4), req=145293+1, ra=145293+128-64, async=1) = 64

> In addition, I added new test cases to use mmap to read the files sequentionally.
> On this machine, there is about 40% regression. reverting your patch fixes it.

Does that also involves multiple processes concurrently reading the same file?
 
> On another machine with another JBOD (7 SAS disks), fio_mmap_sync_read_4k (64k/128k)
> has about 30% regression. But it's not caused by your patch. I am bisecting it on the
> 2nd machine now.

That may well related to my readahead patches.

Thanks,
Fengguang
