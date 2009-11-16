Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZKPWRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZKPWRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZKPWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:17:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbZKPWRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:17:15 -0500
Date: Mon, 16 Nov 2009 23:17:17 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091116221717.GA8819@duck.suse.cz>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <20091111141031.GA21511@duck.suse.cz> <x493a4lot31.fsf@segfault.boston.devel.redhat.com> <20091112172941.GK14528@duck.suse.cz> <x49pr7npj71.fsf@segfault.boston.devel.redhat.com> <20091116104744.GC23231@duck.suse.cz> <20091116165804.GA19230@duck.suse.cz> <x49iqdaz9kr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iqdaz9kr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-11-09 12:03:00, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Mon 16-11-09 11:47:44, Jan Kara wrote:
> >> On Thu 12-11-09 15:44:02, Jeff Moyer wrote:
> >> > Jan Kara <jack@suse.cz> writes:
> >> > 
> >> > > On Wed 11-11-09 12:43:30, Jeff Moyer wrote:
> >> > >> Jan Kara <jack@suse.cz> writes:
> >> > >> 
> >> > >> >   Sadly, I don't see the improvement you can see :(. The numbers are the
> >> > >> > same regardless low_latency set to 0:
> >> > >> > 2.6.32-rc5 low_latency = 0:
> >> > >> > 37.39 36.43 36.51 -> 36.776667 0.434920
> >> > >> >   But my testing environment is a plain SATA drive so that probably
> >> > >> > explains the difference...
> >> > >> 
> >> > >> I just retested (10 runs for each kernel) on a SATA disk with no NCQ
> >> > >> support and I could not see a difference.  I'll try to dig up a disk
> >> > >> that support NCQ.  Is that what you're using for testing?
> >> > >   I don't think I am. How do I find out?
> >> > 
> >> > Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
> >> > greater than 0/32.  There may be a better way, though.
> >>   Message in the logs:
> >> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >> ata1.00: ATA-8: Hitachi HTS722016K9SA00, DCDOC54P, max UDMA/133
> >> ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> >> ata1.00: configured for UDMA/133
> >>   So apparently no NCQ. /sys/block/sda/device/queue_depth shows 1 but I
> >> guess that's just it's way of saying "no NCQ".
> >> 
> >>   What I thought might make a difference why I'm seeing the drop and you
> >> are not is size of RAM or number of CPUs vs the tiobench file size or
> >> number of threads. I'm running on a machine with 2 GB of RAM, using 4 GB
> >> filesize. The machine has 2 cores and I'm using 16 tiobench threads. I'm
> >> now rerunning tests with various numbers of threads to see how big
> >> difference it makes.
> >   OK, here are the numbers (3 runs of each test):
> > 2.6.29:
> > Threads	Avg		Stddev
> > 1	42.043333	0.860439
> > 2	40.836667	0.322938
> > 4	41.810000	0.114310
> > 8	40.190000	0.419603
> > 16	39.950000	0.403072
> > 32	39.373333	0.766913
> >
> > 2.6.32-rc7:
> > Threads	Avg		Stddev
> > 1	41.580000	0.403072
> > 2	39.163333	0.374641
> > 4	39.483333	0.400111
> > 8	38.560000	0.106145
> > 16	37.966667	0.098770
> > 32	36.476667	0.032998
> >
> >   So apparently the difference between 2.6.29 and 2.6.32-rc7 increases as
> > the number of threads rises. With how many threads have you been running
> > when using SATA drive and what machine is it?
> >   I'm now running a test with larger file size (8GB instead of 4) to see
> > what difference it makes.
> 
> I've been running with both 8 and 16 threads.  The machine has 4 CPUs
> and 4GB of RAM.  I've been testing with an 8GB file size.
  OK, I see a similar regression also with 8GB file size:
2.6.29:
1 41.556667 0.787415
2 40.866667 0.714112
4 40.726667 0.228376
8 38.596667 0.344706
16 39.076667 0.180801
32 37.743333 0.147271

2.6.32-rc7:
1 41.860000 0.063770
2 39.196667 0.012472
4 39.426667 0.162138
8 37.550000 0.040825
16 37.710000 0.096264
32 35.680000 0.109848

  BTW: I'm running the test always on a fresh ext3 in data=ordered mode
with barrier=1.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
