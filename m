Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbZIVNjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbZIVNjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZIVNjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:39:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:53474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbZIVNjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:39:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190307773"
Date: Tue, 22 Sep 2009 21:39:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090922133904.GA9967@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <20090922104915.GA1649@localhost> <20090922115015.GB6175@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922115015.GB6175@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 07:50:15PM +0800, Li, Shaohua wrote:
> On Tue, Sep 22, 2009 at 06:49:15PM +0800, Wu, Fengguang wrote:
> > Shaohua,
> > 
> > On Tue, Sep 22, 2009 at 01:49:13PM +0800, Li, Shaohua wrote:
> > > Hi,
> > > Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
> > > in my test.
> > > My system has 12 disks, each disk has two partitions. System runs fio sequence
> > > write on all partitions, each partion has 8 jobs.
> > > 2.6.31-rc1, fio gives 460m/s disk io
> > > 2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
> > > 460m/s
> > > 
> > > Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
> > > is 484m/s.
> > > 
> > > With the patch, fio reports less io merge and more interrupts. My naive
> > > analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
> > > write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
> > > because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
> > > the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
> > > thread can write 8 pages and then move some pages to writeback, and then
> > > continue doing write. The patch seems to break this.
> > 
> > Do you have trace/numbers for above descriptions?
> No. Just guess, because there is less io merge. And watch each bdi's states,
> bdi_nr_reclaimable < bdi_thresh seems always true.

Ah OK.

> > > Unfortunatelly I can't figure out a fix for this issue, hopefully
> > > you have more ideas.
> > 
> > Attached is a very verbose writeback debug patch, hope it helps and
> > won't disturb the workload a lot :)
> Hmm, the log buf will get overflowed soon, there is > 400m/s io. I tried
> to produce this issue in a system with two disks, but fail. Anyway, I'll try
> it out tomorrow.

Thank you~  I'd recommend to use netconsole or serial line, and stop
local klogd because the write of log messages could add noises. 

Thanks,
Fengguang

