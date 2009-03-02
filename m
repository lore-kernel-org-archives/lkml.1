Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZCBDNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZCBDNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZCBDNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:13:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:44228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZCBDNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:13:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,286,1233561600"; 
   d="scan'208";a="115620330"
Date: Mon, 2 Mar 2009 11:12:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "npiggin@suse.de" <npiggin@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: iozone regression with 2.6.29-rc6
Message-ID: <20090302031227.GA6686@localhost>
References: <1235726039.11610.243.camel@minggr> <1235728154.24401.55.camel@laptop> <1235960344.11610.246.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235960344.11610.246.camel@minggr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 10:19:04AM +0800, Lin, Ming wrote:
> On Fri, 2009-02-27 at 17:49 +0800, Peter Zijlstra wrote:
> > On Fri, 2009-02-27 at 17:13 +0800, Lin Ming wrote:
> > > bisect locates below commits,
> > > 
> > > commit 1cf6e7d83bf334cc5916137862c920a97aabc018
> > > Author: Nick Piggin <npiggin@suse.de>
> > > Date:   Wed Feb 18 14:48:18 2009 -0800
> > > 
> > >     mm: task dirty accounting fix
> > > 
> > >     YAMAMOTO-san noticed that task_dirty_inc doesn't seem to be called properly for
> > >     cases where set_page_dirty is not used to dirty a page (eg. mark_buffer_dirty).
> > > 
> > >     Additionally, there is some inconsistency about when task_dirty_inc is
> > >     called.  It is used for dirty balancing, however it even gets called for
> > >     __set_page_dirty_no_writeback.
> > > 
> > >     So rather than increment it in a set_page_dirty wrapper, move it down to
> > >     exactly where the dirty page accounting stats are incremented.
> > > 
> > >     Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
> > >     Signed-off-by: Nick Piggin <npiggin@suse.de>
> > >     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > 
> > > 
> > > below data in parenthesis is the result after above commit reverted, for example,
> > > -10% (+2%) means,
> > > iozone has ~10% regression with 2.6.29-rc6 compared with 2.6.29-rc5.
> > > and
> > > iozone has ~2% improvement with 2.6.29-rc6-revert-1cf6e7d compared with 2.6.29-rc5.
> > > 
> > > 
> > > 			4P dual-core HT	 	2P qual-core  	2P qual-core HT
> > > 			tulsa		   	stockley	Nehalem
> > > 			--------------------------------------------------------
> > > iozone-rewrite		-10% (+2%)		-8% (0%)	-10% (-7%)
> > > iozone-rand-write	-50% (0%)		-20% (+10%)
> > > iozone-read					-13% (0%)
> > > iozone-write					-28% (-1%)
> > > iozone-reread							-5% (-1%)
> > > iozone-mmap-read						-7% (+2%)
> > > iozone-mmap-reread						-7% (+2%)
> > > iozone-mmap-rand-read						-7% (+3%)
> > > iozone-mmap-rand-write						-5% (0%)
> > 
> > Ugh, that's unexpected..
> > 
> > So 'better' accounting leads to worse performance, which would indicate
> > we throttle more.
> > 
> > I take it you machine has gobs of memory.
> > 
> > Does something like the below help any?
> 
> It helps some as below test result,
> The data in second parenthesis means 2.6.29-rc6-with-peter's-patch
> compared with 2.6.29-rc5.
> 
> 			4P dual-core HT	 	2P qual-core  	2P qual-core HT
> 			tulsa		   	stockley	Nehalem
> 			--------------------------------------------------------
> iozone-rewrite		-10% (+2%)(-3%)		-8% (0%)(0%)	-10% (-7%)(-2%)
> iozone-rand-write	-50% (0%)(-10%)		-20% (+10%)(+3%)
> iozone-read					-13% (0%)(-8%)
> iozone-write					-28% (-1%)(+35%)
> iozone-reread							-5% (-1%)(-1%)
> iozone-mmap-read						-7% (+2%)(-7%)
> iozone-mmap-reread						-7% (+2%)(-7%)
> iozone-mmap-rand-read						-7% (+3%)(-7%)
> iozone-mmap-rand-write						-5% (0%)(+27%)

Thanks, Lin Ming. To better understand the situation, would you please
provide the iozone command and memory info about the servers?

Thanks,
Fengguang
