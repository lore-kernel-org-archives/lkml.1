Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZFXH0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZFXH0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZFXH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:26:17 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:4566 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZFXH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:26:16 -0400
Date: Wed, 24 Jun 2009 09:25:55 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
To: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090624072554.GA16642@p15145560.pureserver.info>
References: <4A37CB2A.6010209@davidnewall.com> <20090616184027.GB7043@p15145560.pureserver.info> <4A37E7DB.7030100@redhat.com> <20090616185600.GC7043@p15145560.pureserver.info> <x49d494c4u0.fsf@segfault.boston.devel.redhat.com> <x49fxdsl46y.fsf@segfault.boston.devel.redhat.com> <20090622163113.GD12483@p15145560.pureserver.info> <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com> <20090623072418.GE12483@p15145560.pureserver.info> <x49iqinys2k.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49iqinys2k.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer schrieb:
> Ralf Gross <Ralf-Lists@ralfgross.de> writes:
> 
> > Jeff Moyer schrieb:
> >> Ralf Gross <rg@STZ-Softwaretechnik.com> writes:
> >> 
> >> > Jeff Moyer schrieb:
> >> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >> >> 
> >> >> > Ralf Gross <rg@stz-softwaretechnik.com> writes:
> >> >> >
> >> >> >> Casey Dahlin schrieb:
> >> >> >>> On 06/16/2009 02:40 PM, Ralf Gross wrote:
> >> >> >>> > David Newall schrieb:
> >> >> >>> >> Ralf Gross wrote:
> >> >> >>> >>> write throughput is much higher than the read throughput (40 MB/s
> >> >> >>> >>> read, 90 MB/s write).
> >> >> >>> > 
> >> >> >>> > Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> >> >> >>> > to the device at the same time.
> >> >> >>> > 
> >> >> >>> > Ralf
> >> >> >>> 
> >> >> >>> How specifically are you testing? It could depend a lot on the
> >> >> >>> particular access patterns you're using to test.
> >> >> >>
> >> >> >> I did the basic tests with tiobench. The real test is a test backup
> >> >> >> (bacula) with 2 jobs that create 2 30 GB spool files on that device.
> >> >> >> The jobs partially write to the device in parallel. Depending which
> >> >> >> spool file reaches the 30 GB first, one starts reading from that file
> >> >> >> and writing to tape, while to other is still spooling.
> >> >> >
> >> >> > We are missing a lot of details, here.  I guess the first thing I'd try
> >> >> > would be bumping up the max_readahead_kb parameter, since I'm guessing
> >> >> > that your backup application isn't driving very deep queue depths.  If
> >> >> > that doesn't work, then please provide exact invocations of tiobench
> >> >> > that reprduce the problem or some blktrace output for your real test.
> >> >> 
> >> >> Any news, Ralf?
> >> >
> >> > sorry for the delay. atm there are large backups running and using the
> >> > raid device for spooling. So I can't do any tests.
> >> >
> >> > Re. read ahead: I tested different settings from 8Kb to 65Kb, this
> >> > didn't help.
> >> >
> >> > I'll do some more tests when the backups are done (3-4 more days).
> >> 
> >> The default is 128KB, I believe, so it's strange that you would test
> >> smaller values.  ;)  I would try something along the lines of 1 or 2 MB.
> >
> > Err, yes this should have been MB not KB.
> >
> >
> > $cat /sys/block/sdc/queue/read_ahead_kb 
> > 16384
> > $cat /sys/block/sdd/queue/read_ahead_kb 
> > 16384
> >
> > I also tried different values for max_sectors_kb, nr_requests. But the
> > trend that writes were much faster than reads while there was read and
> > write load on the device didn't change.
> >
> > Changing the deadline parameter writes_starved, write_expire,
> > read_expire, front_merges or fifo_batch didn't change this behavoir.
> 
> OK, bumping up readahead and changing the deadline parameters listed
> should have give some better results, I would think.  Can you give the
> invocation of tiobench you used so I can try to reproduce this?

The main problem is with bacula. It reads/writes from/to two
spoolfiles on the same device.

I get the same behavior with 2 dd processes, one reading from disk, one writing
to it.

Here's the output from dstat (5 sec intervall).

--dsk/md1--
_read _writ
  26M   95M
  31M   96M
  20M   85M
  31M  108M
  28M   89M
  24M   95M
  26M   79M
  32M  115M
  50M   74M
 129M   15k
 147M 1638B
 147M    0 
 147M    0 
 113M    0


At the end I stopped the dd process that is writing to the device, so you can
see that the md device is capable of reading with >120 MB/s.

I did this with these two commands.

dd if=/dev/zero of=test bs=1MB
dd if=/dev/md1 of=/dev/null bs=1M


Maybe this is too simple, but with a real world application I see the same
behavior. md1 is a md raid 0 device with 2 disks.


md1 : active raid0 sdc[0] sdd[1]
      781422592 blocks 64k chunks

sdc:

/sys/block/sdc/queue/hw_sector_size
512
/sys/block/sdc/queue/max_hw_sectors_kb
32767
/sys/block/sdc/queue/max_sectors_kb
512
/sys/block/sdc/queue/nomerges
0
/sys/block/sdc/queue/nr_requests
128
/sys/block/sdc/queue/read_ahead_kb
16384
/sys/block/sdc/queue/scheduler
noop anticipatory [deadline] cfq

/sys/block/sdc/queue/iosched/fifo_batch
16
/sys/block/sdc/queue/iosched/front_merges
1
/sys/block/sdc/queue/iosched/read_expire
500
/sys/block/sdc/queue/iosched/write_expire
5000
/sys/block/sdc/queue/iosched/writes_starved
2


sdd:

/sys/block/sdd/queue/hw_sector_size
512
/sys/block/sdd/queue/max_hw_sectors_kb
32767
/sys/block/sdd/queue/max_sectors_kb
512
/sys/block/sdd/queue/nomerges
0
/sys/block/sdd/queue/nr_requests
128
/sys/block/sdd/queue/read_ahead_kb
16384
/sys/block/sdd/queue/scheduler
noop anticipatory [deadline] cfq 


/sys/block/sdd/queue/iosched/fifo_batch
16
/sys/block/sdd/queue/iosched/front_merges
1
/sys/block/sdd/queue/iosched/read_expire
500
/sys/block/sdd/queue/iosched/write_expire
5000
/sys/block/sdd/queue/iosched/writes_starved
2


The deadline parameters are the default ones. Setting writes_starved much
higher I expected a change in the read/write ratio, but didn't see any change.



Ralf
