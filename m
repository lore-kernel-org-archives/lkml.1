Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZJIKlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZJIKlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbZJIKln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:41:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56493 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760468AbZJIKlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:41:42 -0400
Date: Fri, 9 Oct 2009 12:41:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>, Jan Kara <jack@suse.cz>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: account IO throttling wait as iowait
Message-ID: <20091009104105.GY9228@kernel.dk>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com> <20091008015822.GB14224@localhost> <1254989316.26976.260.camel@twins> <20091008083609.GA9228@kernel.dk> <20091009025235.GA28640@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009025235.GA28640@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Wu Fengguang wrote:
> On Thu, Oct 08, 2009 at 04:36:09PM +0800, Jens Axboe wrote:
> > On Thu, Oct 08 2009, Peter Zijlstra wrote:
> > > On Thu, 2009-10-08 at 09:58 +0800, Wu Fengguang wrote:
> > > > 
> > > > > How this runqueue->nr_iowait is handled now ?
> > > > 
> > > > Good question. io_schedule() has an old comment for throttling IO wait:
> > > > 
> > > >          * But don't do that if it is a deliberate, throttling IO wait (this task
> > > >          * has set its backing_dev_info: the queue against which it should throttle)
> > > >          */
> > > >         void __sched io_schedule(void)
> > > > 
> > > > So it looks both Jens' and this patch behaves right in ignoring the
> > > > iowait accounting for balance_dirty_pages() :)
> > > 
> > > Well it is a change in behaviour, and I think IOWAIT makes sense when
> > > we're blocked due to io throttle..
> > > 
> > > Hmm?
> > 
> > Yep agree, if we're deliberately waiting on IO, it should count as
> > iowait time.
> 
> Then let's revert to the old behavior :)
> 
> For one single cp, it increases iowait from 29% to 56%.
> 
> Before patch:
> 
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>   0   4  64  28   0   3|   0     0 | 272k   10M|   0     0 |1854   863
>   0   6  69  23   0   3|   0     0 | 249k   11M|   0     0 |1709   865
>   0   6  64  27   0   4|   0     0 | 235k   10M|   0     0 |1807   788
>   0   4  61  30   0   4|   0     0 | 271k   12M|   0     0 |1910   898
>   0   4  72  21   0   4|   0     0 | 289k   13M|   0     0 |1832   905
>   0   6  58  35   0   2|   0     0 | 252k   11M|   0     0 |1713   900
>   0   4  54  38   0   4|   0     0 | 257k   11M|   0     0 |1777   841
>   0   5  59  30   0   7|   0     0 | 270k   12M|   0     0 |1758   836
> 
> After patch:
> 
> ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
> usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
>   0   5  35  57   0   4|   0     0 | 255k   11M|   0     0 |1705   879
>   0   4  38  53   0   4|   0     0 | 326k   14M|   0     0 |1940   980
>   0   3  36  59   0   2|   0     0 | 291k   13M|   0     0 |1970   970
>   0   4  28  66   0   2|   0     0 | 290k   13M|   0     0 |1805   928
>   0   6  38  54   0   3|   0     0 | 230k   10M|   0     0 |1866   842
>   0   5  44  49   0   4|   0     0 | 278k   12M|   0     0 |1808   868
> 
> Thanks,
> Fengguang
> ---
> writeback: account IO throttling wait as iowait
> 
> It makes sense to do IOWAIT when someone is blocked
> due to IO throttle, as suggested by Kame and Peter.
> 
> There is an old comment for not doing IOWAIT on throttle,
> however it has been mismatching the code for a long time.
> 
> If we stop accounting IOWAIT for 2.6.32, it could be an
> undesirable behavior change. So restore the io_schedule.

Thanks, queued up.

-- 
Jens Axboe

