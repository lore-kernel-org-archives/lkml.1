Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYDHFtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYDHFtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 01:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYDHFsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 01:48:54 -0400
Received: from mx.ATComputing.nl ([195.108.229.5]:16915 "EHLO
	mx.ATComputing.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYDHFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 01:48:53 -0400
Date: Tue, 8 Apr 2008 07:48:37 +0200
From: Gerlof Langeveld <gerlof@ATComputing.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] accounting: task counters for disk/network
Message-ID: <20080408054837.GA7103@atcmpg.ATComputing.nl>
References: <20080402073037.GA8419@atcmpg.ATComputing.nl> <20080403125416.ead5cd38.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403125416.ead5cd38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.7i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 03-04-2008, 12:54 Andrew Morton wrote:
> On Wed, 2 Apr 2008 09:30:37 +0200
> Gerlof Langeveld <gerlof@ATComputing.nl> wrote:
> 
> > 
> > From: Gerlof Langeveld <gerlof@atcomputing.nl>
> 
> You sent three different patches, all with the same title.  Please don't do
> that - choose unique, suitable and meaningful titles for each patch.

Sorry for that (I assumed the same title would correlate the three patches).

> > Proper performance analysis requires the availability of system level
> > and process level counters for CPU, memory, disk and network utilization.
> > The current kernel offers the system level counters, however process level
> > counters are only (sufficiently) available for CPU and memory utilization.
> > 
> > The kernel feature "task I/O accounting" currently maintains
> > per process counters for the number of bytes transferred to/from disk.
> > These counters are available via /proc/pid/io. It is still not possible
> > to find out which process issues the physical disk transfer. Besides,
> > not *all* disk transfers are accounted to processes (e.g. swap-transfers
> > by kswapd, journaling transfers).
> > 
> > This patch extends "task I/O accounting" by counting real *physical*
> > disk transfers per process and by counting IPv4/IPv6 socket transfers
> > per process.
> > The modified output generated for /proc/pid/io will be as follows:
> > 
> >   $ cat /proc/3179/io
> 
> /proc/pid/io is not the primary interface for this sort of accounting - it
> was just tossed in there as an afterthought because it wasy easy.
> 
> This sort of accounting should be delivered across taskstats and
> Documentation/accounting/getdelays.c should be suitably updated.

I must dive into the taskstats feature first, so I will deliver
a new patch later on.

> > --- linux-2.6.24.4-vanilla/block/ll_rw_blk.c	2008-03-24 19:49:18.000000000 +0100
> > +++ linux-2.6.24.4-modified/block/ll_rw_blk.c	2008-03-25 13:52:14.000000000 +0100
> > @@ -2739,6 +2739,19 @@ static void drive_stat_acct(struct reque
> >  		disk_round_stats(rq->rq_disk);
> >  		rq->rq_disk->in_flight++;
> >  	}
> > +
> > +#ifdef CONFIG_TASK_IO_ACCOUNTING
> > +	switch (rw) {
> > +	case READ:
> > +		current->group_leader->ioac.dsk_rio += new_io;
> > +		current->group_leader->ioac.dsk_rsz += rq->nr_sectors;
> > +		break;
> > +	case WRITE:
> > +		current->group_leader->ioac.dsk_wio += new_io;
> > +		current->group_leader->ioac.dsk_wsz += rq->nr_sectors;
> > +		break;
> > +	}
> > +#endif
> 
> For many workloads, this will cause almost all writeout to be accounted to
> pdflush and perhaps kswapd.  This makes the per-task write accounting
> largely unuseful.

There are several situations that writeouts are accounted to the user-process
itself, e.g. when issueing direct writes (open mode O_DIRECT) or synchronous
writes (open mode O_SYNC, syscall sync/fsync, synchronous file attribute,
synchronous mounted filesystem).

Apart from that, swapping out of process pages by kswapd is currently not
accounted at all as shown by the following snapshot of 'atop' on a heavily
swapping system:

ATOP - atdts              2008/04/07  19:01:24               10 seconds elapsed
......
MEM | tot    1.9G | free   14.1M | cache  11.0M | buff    0.6M | slab   22.4M |
SWP | tot    1.0G | free  513.6M |              | vmcom   2.3G | vmlim   2.0G |
PAG | scan   9865 | stall      0 |              | swin    4337 | swout   4718 |
DSK |         sda | busy    100% | read    1499 | write   1949 | avio    2 ms |

  PID  SYSCPU  USRCPU  VGROW  RGROW  RDDSK  WRDSK  ST EXC S  DSK CMD     1/1
13795   0.04s   0.01s     0K -3504K 12200K     0K  --   - D  71% memeater
27823   0.04s   0.00s     0K  -360K  5080K     0K  --   - D  29% appl
13791   0.00s   0.24s     0K     0K     0K     0K  --   - S   0% memeater
13793   0.00s   0.24s     0K     0K     0K     0K  --   - S   0% memeater
13792   0.00s   0.23s     0K    -4K     0K     0K  --   - S   0% memeater
13851   0.03s   0.00s     0K     0K     0K     0K  --   - S   0% atop
  236   0.03s   0.00s     0K     0K     0K     0K  --   - D   0% kswapd0

The process counters RDDSK and WRDSK are retrieved from the
standard /proc/pid/io.
There are no write-request accounted to any of the processes while 
1949 write requests have been issued on disk (line marked with DSK).
These writes should have been accounted to kswapd (writing to the swap
device).

With the additional counters maintained by this patch, every physical
I/O request is accounted to one of the processes which can be very useful
as an addition to the I/O accounting that is already implemented.
A snapshot of 'atop' on a swapping system that is patched:

ATOP - atdts              2008/04/07  19:01:17               10 seconds elapsed
......
MEM | tot    1.9G | free   13.8M | cache  11.0M | buff    0.6M | slab   22.4M |
SWP | tot    1.0G | free  513.4M |              | vmcom   2.3G | vmlim   2.0G |
PAG | scan   8021 | stall      0 |              | swin    3923 | swout   3367 |
DSK |         sda | busy    100% | read    1578 | write   1304 | avio    3 ms |

  PID  SYSCPU  USRCPU  VGROW  RGROW RDDSK WRDSK RNET SNET S  DSK CMD     1/1
27823   0.05s   0.00s     0K  1796K  1072    55    0    0 D  39% appl
  236   0.02s   0.00s     0K     0K     0   988    0    0 D  34% kswapd0
13795   0.04s   0.00s     0K -3824K   491   258    0    0 D  26% memeater
 2017   0.01s   0.00s     0K     0K     0    28    0    0 S   1% kjournald
 3218   0.00s   0.00s     0K     4K     6     0    0    0 S   0% sendmail

The process counters RDDSK and WRDSK now show the number of read and write
requests issued on disk for each process. The accumulated counters per process
correspond to the total number of requests measured on disk level (line marked
with DSK).

For read accounting it also useful to see the number of I/O requests issued
by a process (currently only the total number of Kbytes is accounted per
process). After all, 64 I/O requests of 4 Kbytes cause a heavier disk load
than 1 I/O request of 256 Kbytes.

So the extra counters can be considered as a useful addition to the I/O 
counters that are currently maintained.
