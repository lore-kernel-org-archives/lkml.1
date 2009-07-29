Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZG2KFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZG2KFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZG2KFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:05:13 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:37259 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbZG2KFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:05:12 -0400
Subject: Re: [RFC][PATCH] mm: reorder balance_dirty_pages to improve (some)
 write performance
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090727155739.0e96b9e3.akpm@linux-foundation.org>
References: <1248445717.19856.63.camel@localhost.localdomain>
	 <20090727155739.0e96b9e3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 11:05:08 +0100
Message-Id: <1248861908.3280.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 15:57 -0700, Andrew Morton wrote:
> On Fri, 24 Jul 2009 15:28:37 +0100
> Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> 
> > Reorder balance_dirty_pages to do less work in the default case &
> > improve write performance in some cases.
> > 
> > Running simple fio mmap write tests on x86_64 with 3gb of memory on
> > 2.6.31-rc3 where each test was run 10 times, dropping the slowest &
> > fastest results the average write speeds are
> > 
> > size rc3 | +patch  difference
> >      MiB/s (s.d.)
> > 
> > 400m 374.75  ( 8.15) | 382.575 ( 8.24)  + 7.825
> > 500m 363.625 (10.91) | 378.375 (10.86)  +14.75
> > 600m 308.875 (10.86) | 374.25  ( 7.91)  +65.375
> > 700m 188     ( 4.75) | 209     ( 7.23)  +21
> > 800m 140.375 ( 2.56) | 154.5   ( 2.98)  +14.275
> > 900m 124.875 ( 0.99) | 125.5   ( 9.62)  +0.625
> > 
> > 
> > This patch helps write performance when the test size is close to the
> > allowed number of dirty pages (approx 600m on this machine). Once the
> > test size becomes larger than 900m there is no significant difference.
> > 
> > 
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > ----
> > 
> > This change only make a difference to workloads where the number of
> > dirty pages is close to (dirty_ratio * memory size). Once a test writes
> > more than that the speed of the disk is the most important factor so any
> > effect of this patch is lost.
> > I've only tried this on my desktop, so it really needs testing on
> > different hardware.
> > Does anyone feel like trying it ? 
> 
> So what does the patch actually do?
> 
> AFACIT the main change is to move this:
> 
> 			if (bdi->dirty_exceeded)
> 				bdi->dirty_exceeded = 0;
> 
> from after the loop and into the body of the loop.
> 
> So that we no longer clear dirty_exceeded in the three other places
> where we break out of the loop.
> 
> IOW, dirty_exceeded can be left true (even if it shouldn't be?) on exit
> from balance_dirty_pages().
> 
> What was the rationale for leaving dirty_exceeded true in those cases,
> and why did it speed up that workload?
> 
> Thanks.

Hi Andrew,

The main intent was to reduce the number of times that global_page_state
gets called as the counters are in a v. hot cacheline, see the perf
stats below.
I added the changes to the dirty_exceeded as a bit of an afterthought, I
guess I should drop them.
 
But to answer your question, in general calling writeback_inodes will
just move some pages from dirty to writeback so the total will stay
about the same, so we exit with the same dirty_exceeded state without
having to check it again. 
However, it could get dirty_exceed wrong if it gets pre-empted or
stalled and enough pages get removed from writeback, but
balance_dirty_limits_ratelimited will call it again after 8 new pages
are dirtied and we'll get another chance to get it right!       

I'll drop the dirty_exceed change & re-test just the global_page_state
stuff.

regards
Richard


typical numbers from `perf stat`
2.6.31-rc4
 Performance counter stats for 'fio ./mm-sz2/t2.fio':

    2387.447419  task-clock-msecs         #      0.480 CPUs 
            498  context-switches         #      0.000 M/sec
              1  CPU-migrations           #      0.000 M/sec
         155070  page-faults              #      0.065 M/sec
     4703977113  cycles                   #   1970.296 M/sec
      971788179  instructions             #      0.207 IPC  
      509718907  cache-references         #    213.500 M/sec
        8928883  cache-misses             #      3.740 M/sec

    4.971956711  seconds time elapsed
2.6.31-rc4 + patch
 Performance counter stats for 'fio ./mm-sz2/t2.fio':

    2116.794967  task-clock-msecs         #      0.648 CPUs 
            383  context-switches         #      0.000 M/sec
              1  CPU-migrations           #      0.000 M/sec
         155048  page-faults              #      0.073 M/sec
     4792565245  cycles                   #   2264.067 M/sec
      967653864  instructions             #      0.202 IPC  
      473096290  cache-references         #    223.497 M/sec
        8723087  cache-misses             #      4.121 M/sec

    3.269128919  seconds time elapsed



