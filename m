Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbZIWEAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbZIWEAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZIWEAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:00:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:49295 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZIWEAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:00:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,435,1249282800"; 
   d="scan'208";a="190610413"
Date: Wed, 23 Sep 2009 12:00:24 +0800
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
Message-ID: <20090923040024.GA29340@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <20090922104915.GA1649@localhost> <20090922115015.GB6175@sli10-desk.sh.intel.com> <20090922133904.GA9967@localhost> <1253670775.11656.3.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253670775.11656.3.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:52:55AM +0800, Li, Shaohua wrote:
> On Tue, 2009-09-22 at 21:39 +0800, Wu, Fengguang wrote:
> > On Tue, Sep 22, 2009 at 07:50:15PM +0800, Li, Shaohua wrote:
> > > On Tue, Sep 22, 2009 at 06:49:15PM +0800, Wu, Fengguang wrote:
> > > > Shaohua,
> > > > 
> > > > On Tue, Sep 22, 2009 at 01:49:13PM +0800, Li, Shaohua wrote:
> > > > > Hi,
> > > > > Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
> > > > > in my test.
> > > > > My system has 12 disks, each disk has two partitions. System runs fio sequence
> > > > > write on all partitions, each partion has 8 jobs.
> > > > > 2.6.31-rc1, fio gives 460m/s disk io
> > > > > 2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
> > > > > 460m/s
> > > > > 
> > > > > Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
> > > > > is 484m/s.
> > > > > 
> > > > > With the patch, fio reports less io merge and more interrupts. My naive
> > > > > analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
> > > > > write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
> > > > > because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
> > > > > the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
> > > > > thread can write 8 pages and then move some pages to writeback, and then
> > > > > continue doing write. The patch seems to break this.
> > > > 
> > > > Do you have trace/numbers for above descriptions?
> > > No. Just guess, because there is less io merge. And watch each bdi's states,
> > > bdi_nr_reclaimable < bdi_thresh seems always true.
> > 
> > Ah OK.
> > 
> > > > > Unfortunatelly I can't figure out a fix for this issue, hopefully
> > > > > you have more ideas.
> > > > 
> > > > Attached is a very verbose writeback debug patch, hope it helps and
> > > > won't disturb the workload a lot :)
> > > Hmm, the log buf will get overflowed soon, there is > 400m/s io. I tried
> > > to produce this issue in a system with two disks, but fail. Anyway, I'll try
> > > it out tomorrow.
> > 
> > Thank you~  I'd recommend to use netconsole or serial line, and stop
> > local klogd because the write of log messages could add noises. 
> attached is a short log. I'll try to get a full log after finish latest
> git test.
> bdi_nr_reclaimable is always less than bdi_thresh in the log. because

Yes. Only background_writeout() is working and queue is congested.

> when bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh, background
> writeback is already started, so bdi_nr_writeback should be > 0.

Yes, when process is throttled, bdi_nr_writeback > (bdi_thresh - bdi_nr_reclaimable).

For each background_writeout() loop (each takes about 0.1s), there are
~100 balance_dirty_pages() loops.  The latter makes pretty much loop overheads.

Most importantly, most background_writeout() loops only wrote several pages
(the large towrite values), which is extremely inefficient. I wonder why it
cannot write more?

> global dirty=246756 writeback=43800 nfs=0 flags=C_ towrite=1018 skipped=0
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> global dirty=246847 writeback=43709 nfs=0 flags=C_ towrite=1024 skipped=0
> global dirty=246847 writeback=43709 nfs=0 flags=C_ towrite=1022 skipped=0
> global dirty=247029 writeback=43527 nfs=0 flags=CM towrite=1020 skipped=0
> global dirty=247029 writeback=43527 nfs=0 flags=C_ towrite=1024 skipped=0
> global dirty=246665 writeback=43800 nfs=0 flags=C_ towrite=1022 skipped=0
> global dirty=246301 writeback=44164 nfs=0 flags=C_ towrite=646 skipped=0

Thanks,
Fengguang

Content-Description: msg2
> 0, bdi_thresh=23810, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27860, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145141, dirty_thresh=290283
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=599 n=-6696602
> bdi_nr_reclaimable=21040, bdi_thresh=24479, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23802, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24906, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27862, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23809, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24903, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24907, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145141, dirty_thresh=290283
> global dirty=246756 writeback=43800 nfs=0 flags=C_ towrite=1018 skipped=0
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27850, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24493, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24944, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24940, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24493, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27864, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145141, dirty_thresh=290283
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=21480, bdi_thresh=24894, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24900, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27862, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27855, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24484, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24943, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24907, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23793, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24479, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23802, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27862, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24491, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24942, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27860, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24904, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24946, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24906, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23809, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24907, background_thresh=145141, dirty_thresh=290283
> redirty_tail +435: inode 4784181
> bdi_nr_reclaimable=21480, bdi_thresh=24902, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16826, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24944, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24495, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27863, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24492, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24905, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24903, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24903, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145141, dirty_thresh=290283
> redirty_tail +435: inode 3474323
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24864, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27863, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=20480, bdi_thresh=23811, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21480, bdi_thresh=24864, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15240, bdi_thresh=16826, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21040, bdi_thresh=24496, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=21320, bdi_thresh=24945, background_thresh=145141, dirty_thresh=290283
> requeue_io +527: inode 0
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=24160, bdi_thresh=27861, background_thresh=145141, dirty_thresh=290283
> requeue_io +527: inode 0
> bdi_nr_reclaimable=23920, bdi_thresh=27427, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145141, dirty_thresh=290283
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=22840, bdi_thresh=26424, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=21320, bdi_thresh=24906, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145150, dirty_thresh=290301
> redirty_tail +502: inode 12415
> bdi_nr_reclaimable=24160, bdi_thresh=27861, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=21320, bdi_thresh=24905, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145150, dirty_thresh=290301
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145159, dirty_thresh=290319
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145159, dirty_thresh=290319
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145159, dirty_thresh=290319
> bdi_nr_reclaimable=21640, bdi_thresh=24923, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24921, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24918, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24905, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23812, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24495, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18250, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24496, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27418, background_thresh=145168, dirty_thresh=290337
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=10090 n=-6621688
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 4784181
> redirty_tail +435: inode 3474323
> requeue_io +527: inode 0
> requeue_io +527: inode 0
> redirty_tail +502: inode 12396
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=10090 n=-6621689
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23812, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27427, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16827, background_thresh=145168, dirty_thresh=290337
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24910, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23811, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24904, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24923, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24916, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24495, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23804, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24486, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23795, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24493, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24923, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24483, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24494, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24906, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24922, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24495, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23811, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24904, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16827, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24498, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24902, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24497, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24918, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24921, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23813, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18249, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=599 n=-6696603
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24905, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24918, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26424, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24923, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24906, background_thresh=145168, dirty_thresh=290337
> global dirty=246847 writeback=43800 nfs=0 flags=C_ towrite=1023 skipped=0
> bdi_nr_reclaimable=21040, bdi_thresh=24491, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18250, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24905, background_thresh=145168, dirty_thresh=290337
> requeue_io +527: inode 0
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> requeue_io +527: inode 0
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24495, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24919, background_thresh=145168, dirty_thresh=290337
> redirty_tail +502: inode 12533
> bdi_nr_reclaimable=21040, bdi_thresh=24496, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27418, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 4784181
> redirty_tail +435: inode 3474323
> requeue_io +527: inode 0
> requeue_io +527: inode 0
> redirty_tail +502: inode 13474
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=10090 n=-6621691
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=599 n=-6696603
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145168, dirty_thresh=290337
> global dirty=246847 writeback=43709 nfs=0 flags=C_ towrite=1024 skipped=0
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> global dirty=246847 writeback=43709 nfs=0 flags=C_ towrite=1022 skipped=0
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24926, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24929, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24904, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23811, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24480, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23803, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23794, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24485, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24926, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24932, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24492, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24904, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24920, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24480, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23794, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24485, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23803, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18248, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18247, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24903, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24926, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24900, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24930, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24493, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24930, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24863, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24918, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24924, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24860, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24931, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24478, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23792, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23801, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24491, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23809, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24918, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24863, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24924, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24860, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24483, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24930, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24928, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24480, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24931, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24492, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24492, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24866, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23808, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23791, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23800, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24863, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24160, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24941, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24477, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24927, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23807, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23790, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23799, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24863, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24476, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24927, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24866, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23806, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24940, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24860, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24940, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24478, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24939, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24937, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24935, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24492, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24937, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23808, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24937, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24936, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24938, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24862, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24936, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24935, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18246, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24927, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24863, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24933, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24864, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23799, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> requeue_io +527: inode 0
> bdi_nr_reclaimable=21640, bdi_thresh=24940, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24860, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23807, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24476, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23790, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24478, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> requeue_io +527: inode 0
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24939, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24940, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24937, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24866, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> redirty_tail +502: inode 13925
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24935, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23805, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23798, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24932, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26424, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24938, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24475, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23789, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24479, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24943, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24947, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24947, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24942, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24476, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23805, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24490, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24944, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24943, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24944, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24944, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24945, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23806, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24491, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=20480, bdi_thresh=23804, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27427, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24947, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18245, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 4784181
> bdi_nr_reclaimable=21040, bdi_thresh=24484, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24483, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24823, background_thresh=145168, dirty_thresh=290337
> redirty_tail +442: inode 3474323
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24943, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24820, background_thresh=145168, dirty_thresh=290337
> requeue_io +527: inode 0
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27418, background_thresh=145168, dirty_thresh=290337
> redirty_tail +502: inode 14004
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24934, background_thresh=145168, dirty_thresh=290337
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=599 n=-6696607
> bdi_nr_reclaimable=21320, bdi_thresh=24780, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24481, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27427, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23803, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24489, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24782, background_thresh=145168, dirty_thresh=290337
> global dirty=247029 writeback=43527 nfs=0 flags=CM towrite=1020 skipped=0
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24783, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24940, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24485, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23796, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=19720, bdi_thresh=23425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23803, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24472, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16820, background_thresh=145168, dirty_thresh=290337
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=10090 n=-6621691
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24477, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23787, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26625, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24781, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24947, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24474, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24946, background_thresh=145168, dirty_thresh=290337
> global dirty=247029 writeback=43527 nfs=0 flags=C_ towrite=1024 skipped=0
> bdi_nr_reclaimable=15240, bdi_thresh=16819, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24484, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24942, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24785, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23804, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24944, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18239, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21320, bdi_thresh=24826, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27810, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=15240, bdi_thresh=16819, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24486, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24486, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24943, background_thresh=145168, dirty_thresh=290337
> redirty_tail +435: inode 4784181
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24945, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27815, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24944, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15240, bdi_thresh=16821, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21240, bdi_thresh=24825, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=20480, bdi_thresh=23804, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145168, dirty_thresh=290337
> redirty_tail +442: inode 3474323
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=21640, bdi_thresh=24902, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145168, dirty_thresh=290337
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24907, background_thresh=145177, dirty_thresh=290355
> requeue_io +527: inode 0
> bdi_nr_reclaimable=21040, bdi_thresh=24483, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18244, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24904, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21080, bdi_thresh=24785, background_thresh=145177, dirty_thresh=290355
> redirty_tail +502: inode 14023
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18243, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24786, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26424, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24783, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24903, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24907, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 21
> bdi_nr_reclaimable=21000, bdi_thresh=24823, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24903, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27418, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 4784181
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 3474323
> requeue_io +527: inode 0
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16819, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24904, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24824, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24487, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> redirty_tail +502: inode 14042
> bdi_nr_reclaimable=21640, bdi_thresh=24905, background_thresh=145177, dirty_thresh=290355
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=599 n=-6696985
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24823, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24486, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24867, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19034, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24485, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24860, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26611, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23801, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24480, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24854, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19026, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24823, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26615, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27412, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24488, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24471, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26620, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16818, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24822, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27822, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16819, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23794, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24476, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24487, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23785, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24867, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26424, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27824, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24820, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27427, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27416, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24866, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19031, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16818, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24867, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27425, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23802, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18239, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18238, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24473, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27810, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24864, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24485, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145177, dirty_thresh=290355
> mm/page-writeback.c 762 background_writeout: comm=pdflush pid=10090 n=-6621693
> bdi_nr_reclaimable=21040, bdi_thresh=24482, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24483, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18239, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26418, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24786, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23800, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27823, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24862, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16817, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19027, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18239, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26425, background_thresh=145177, dirty_thresh=290355
> global dirty=246665 writeback=43800 nfs=0 flags=C_ towrite=1022 skipped=0
> bdi_nr_reclaimable=21000, bdi_thresh=24784, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26422, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24785, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26618, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24480, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21040, bdi_thresh=24484, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26621, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24863, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15240, bdi_thresh=16819, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24863, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19033, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21640, bdi_thresh=24864, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27815, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27426, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=24200, bdi_thresh=27821, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26423, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27413, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26420, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24785, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18238, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26626, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27423, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=20480, bdi_thresh=23802, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21440, bdi_thresh=24864, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18239, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27421, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19030, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18241, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18240, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21360, bdi_thresh=24862, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21360, bdi_thresh=24903, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23920, bdi_thresh=27418, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=22840, bdi_thresh=26414, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21320, bdi_thresh=24865, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=23080, bdi_thresh=26624, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15640, bdi_thresh=19032, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=15880, bdi_thresh=18242, background_thresh=145177, dirty_thresh=290355
> global dirty=246301 writeback=44164 nfs=0 flags=C_ towrite=646 skipped=0
> bdi_nr_reclaimable=15240, bdi_thresh=16818, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=19720, bdi_thresh=23385, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24786, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21280, bdi_thresh=24863, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 174623
> bdi_nr_reclaimable=21000, bdi_thresh=24785, background_thresh=145177, dirty_thresh=290355
> bdi_nr_reclaimable=21000, bdi_thresh=24783, background_thresh=145177, dirty_thresh=290355
> redirty_tail +435: inode 4784181
> redirty_tail +435: inode 3474323
> requeue_io +527: inode 0
> redirty_tail +502: inode 14061
> bdi_nr_reclaimable=23080, bdi_thresh=26623, background_thresh=145177, dirty_thresh=290355
> redirty_tail +442: inode 27
> redirty_tail +435: inode 174623
> redirty_tail +435: inode 4784181
> redirty_tail +435: inode 3474323
> requeue_io +527: inode 0
> redirty_tail +502: inode 14096

