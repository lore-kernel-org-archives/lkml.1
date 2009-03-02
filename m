Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbZCBDVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbZCBDVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZCBDVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:21:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:41787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZCBDVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:21:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,287,1233561600"; 
   d="scan'208";a="494068601"
Subject: Re: iozone regression with 2.6.29-rc6
From: Lin Ming <ming.m.lin@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "npiggin@suse.de" <npiggin@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <20090302031227.GA6686@localhost>
References: <1235726039.11610.243.camel@minggr>
	 <1235728154.24401.55.camel@laptop> <1235960344.11610.246.camel@minggr>
	 <20090302031227.GA6686@localhost>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 11:16:41 +0800
Message-Id: <1235963801.11610.251.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 11:12 +0800, Wu, Fengguang wrote:
> On Mon, Mar 02, 2009 at 10:19:04AM +0800, Lin, Ming wrote:
> > On Fri, 2009-02-27 at 17:49 +0800, Peter Zijlstra wrote:
> > > On Fri, 2009-02-27 at 17:13 +0800, Lin Ming wrote:
> > > > bisect locates below commits,
> > > > 
> > > > commit 1cf6e7d83bf334cc5916137862c920a97aabc018
> > > > Author: Nick Piggin <npiggin@suse.de>
> > > > Date:   Wed Feb 18 14:48:18 2009 -0800
> > > > 
> > > >     mm: task dirty accounting fix
> > > > 
> > > >     YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
> > > >     cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).
> > > > 
> > > >     Additionally, there is some inconsistency about when task_dirty_inc is
> > > >     called.  It is used for dirty balancing, however it even gets called for
> > > >     __set_page_dirty_no_writeback.
> > > > 
> > > >     So rather than increment it in a set_page_dirty wrapper, move it down to
> > > >     exactly where the dirty page accounting stats are incremented.
> > > > 
> > > >     Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> > > >     Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > >     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > 
> > > > 
> > > > below data in parenthesis is the result after above commit reverted, for example,
> > > > -10% (+2%) means,
> > > > iozone has ~10% regression with 2.6.29-rc6 compared with 2.6.29-rc5.
> > > > and
> > > > iozone has ~2% improvement with 2.6.29-rc6-revert-1cf6e7d compared with 2.6.29-rc5.
> > > > 
> > > > 
> > > > 			4P dual-core HT	 	2P qual-core  	2P qual-core HT
> > > > 			tulsa		   	stockley	Nehalem
> > > > 			--------------------------------------------------------
> > > > iozone-rewrite		-10% (+2%)		-8% (0%)	-10% (-7%)
> > > > iozone-rand-write	-50% (0%)		-20% (+10%)
> > > > iozone-read					-13% (0%)
> > > > iozone-write					-28% (-1%)
> > > > iozone-reread							-5% (-1%)
> > > > iozone-mmap-read						-7% (+2%)
> > > > iozone-mmap-reread						-7% (+2%)
> > > > iozone-mmap-rand-read						-7% (+3%)
> > > > iozone-mmap-rand-write						-5% (0%)
> > > 
> > > Ugh, that's unexpected..
> > > 
> > > So 'better' accounting leads to worse performance, which would indicate
> > > we throttle more.
> > > 
> > > I take it you machine has gobs of memory.
> > > 
> > > Does something like the below help any?
> > 
> > It helps some as below test result,
> > The data in second parenthesis means 2.6.29-rc6-with-peter's-patch
> > compared with 2.6.29-rc5.
> > 
> > 			4P dual-core HT	 	2P qual-core  	2P qual-core HT
> > 			tulsa		   	stockley	Nehalem
> > 			--------------------------------------------------------
> > iozone-rewrite		-10% (+2%)(-3%)		-8% (0%)(0%)	-10% (-7%)(-2%)
> > iozone-rand-write	-50% (0%)(-10%)		-20% (+10%)(+3%)
> > iozone-read					-13% (0%)(-8%)
> > iozone-write					-28% (-1%)(+35%)
> > iozone-reread							-5% (-1%)(-1%)
> > iozone-mmap-read						-7% (+2%)(-7%)
> > iozone-mmap-reread						-7% (+2%)(-7%)
> > iozone-mmap-rand-read						-7% (+3%)(-7%)
> > iozone-mmap-rand-write						-5% (0%)(+27%)
> 
> Thanks, Lin Ming. To better understand the situation, would you please
> provide the iozone command and memory info about the servers?

iozone -i 0 -i 1 -i 2 -i 3 -i 4 -r 4k -s 64k -s 512m -s 1200m -b tmp.xls
iozone -B -r 4k -s 64k -s 512m -s 1200m -b tmp.xls

4P dual-core HT tulsa /proc/meminfo
------------------------------------
MemTotal:        8189476 kB
MemFree:         7915884 kB
Buffers:           32676 kB
Cached:           139784 kB
SwapCached:            0 kB
Active:            35852 kB
Inactive:         145564 kB
Active(anon):       9048 kB
Inactive(anon):        0 kB
Active(file):      26804 kB
Inactive(file):   145564 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               140 kB
Writeback:             0 kB
AnonPages:          9068 kB
Mapped:             4084 kB
Slab:              31180 kB
SReclaimable:      14800 kB
SUnreclaim:        16380 kB
PageTables:         1236 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4094736 kB
Committed_AS:   18446744073709545248 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      286416 kB
VmallocChunk:   34359449467 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        4096 kB
DirectMap2M:     8380416 

2P qual-core stockley /proc/meminfo
-----------------------------------
MemTotal:        8167260 kB
MemFree:         7951068 kB
Buffers:           30988 kB
Cached:           123772 kB
SwapCached:            0 kB
Active:            34744 kB
Inactive:         129296 kB
Active(anon):       9412 kB
Inactive(anon):        0 kB
Active(file):      25332 kB
Inactive(file):   129296 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               272 kB
Writeback:             0 kB
AnonPages:          9408 kB
Mapped:             4072 kB
Slab:              21760 kB
SReclaimable:      10612 kB
SUnreclaim:        11148 kB
PageTables:         1260 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4083628 kB
Committed_AS:   18446744073709540996 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       11216 kB
VmallocChunk:   34359726459 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7168 kB
DirectMap2M:     8380416 kB


2P qual-core HT Nehalem /proc/meminfo
-------------------------------------
MemTotal:        6113044 kB
MemFree:         5947476 kB
Buffers:           17056 kB
Cached:            44280 kB
SwapCached:            0 kB
Active:            31268 kB
Inactive:          40300 kB
Active(anon):      10308 kB
Inactive(anon):        0 kB
Active(file):      20960 kB
Inactive(file):    40300 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:               280 kB
Writeback:             0 kB
AnonPages:         10328 kB
Mapped:             5096 kB
Slab:              27844 kB
SReclaimable:      10988 kB
SUnreclaim:        16856 kB
PageTables:         2204 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3056520 kB
Committed_AS:   18446744073709542732 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      286428 kB
VmallocChunk:   34359451259 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8192 kB
DirectMap2M:     6275072 kB

Lin Ming

> 
> Thanks,
> Fengguang

