Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbXHFJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbXHFJBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbXHFJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:01:05 -0400
Received: from mail.daysofwonder.com ([213.186.49.53]:54399 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXHFJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:01:03 -0400
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 05:01:02 EDT
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: Brice Figureau <brice+lklm@daysofwonder.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p734pjdmxsz.fsf@bingen.suse.de>
References: <20070803123712.987126000@chello.nl>
	 <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	 <20070804063217.GA25069@elte.hu> <loom.20070805T190600-28@post.gmane.org>
	 <p734pjdmxsz.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 10:40:38 +0200
Message-Id: <1186389638.30448.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 2007-08-06 at 00:17 +0200, Andi Kleen wrote:
> Brice Figureau <brice+lklm@daysofwonder.com> writes:
> > 
> >  2) I _still_ don't get the "performances" of 2.6.17, but since that's the
> > better combination I could get, I think there is IMHO progress in the right
> > direction (to be compared to no progress since 2.6.18, that's better :-)).
> 
> If you could characterize your workload well (e.g. how many disks,
> what file systems, what load on mysql) perhaps it would be possible
> to reproduce the problem with a test program or a mysql driver.
> Then it could be bisected.

My server is a Dell Poweredge 2850 (bi-Xeon EM64T 3GHz running without
HT, 4GB of RAM), with a Perc 4/Di (a LSI megaraid with a BBU of 256MB). 
The hardware RAID card has 2 channels, one is connected to 2 10k RPM
146GB SCSI disk that are mirrored in a RAID 1 array on which the system
resides (/dev/sda). The second channel is connected to 4 10k RPM 146GB
disks, on a RAID 10 array which contains the database files and database
logs (/dev/sdb).

The kernel and userspace are 64bits.
Above the hardware RAID arrays there is LVM2 with two physical groups
(one per array). The RAID10 has only one logical volume.

The database volume (the RAID10) is an ext3 volume mounted with
rw,noexec,nosuid,nodev,noatime,data=writeback.

The I/O scheduler on all arrays is deadline.

/proc knobs with values other than defaults are:
/proc/sys/vm/swappiness = 2
/proc/sys/vm/dirty_background_ratio = 1
/proc/sys/vm/dirty_ratio = 2
/proc/sys/vm/vfs_cache_pressure = 1

The only thing running on the server is mysql. 
Mysql memory footprint is about 90% of physical RAM. Mysql is configured
to use exclusively InnoDB.

Mysql accesses its database files in O_DIRECT mode.
Since the database fits in RAM, the only kind of access Mysql is doing
is writing to the innodb log, the mysql binlog and finally to the innodb
database files.
There are certainly a whole lot of fsync'ing happening.
All the database reads are done from the innodb in-RAM cache.

During all my kernel tests (see the original bug report) the machine was
not swapping (so that's not the reason of the stuttering).

If that helps:
db1:~# cat /proc/meminfo 
MemTotal:      4052420 kB
MemFree:         23972 kB
Buffers:         54420 kB
Cached:         168096 kB
SwapCached:    1541744 kB
Active:        3723468 kB
Inactive:       157180 kB
SwapTotal:    11863960 kB
SwapFree:     10193064 kB
Dirty:             320 kB
Writeback:           0 kB
AnonPages:     3657744 kB
Mapped:          20508 kB
Slab:           119964 kB
SReclaimable:   103564 kB
SUnreclaim:      16400 kB
PageTables:       9408 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  13890168 kB
Committed_AS:  3826764 kB
VmallocTotal: 34359738367 kB
VmallocUsed:    268604 kB
VmallocChunk: 34359469435 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
Hugepagesize:     2048 kB

An typical iostat (taken every 2s under light load):
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     2.00    0.00    3.50     0.00    44.00    12.57     0.00    0.00   0.00   0.00
sdb               0.00     9.00    0.50   27.00     4.00   288.00    10.62     0.01    0.36   0.36   1.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00   223.50    7.50  185.50    60.00  5964.00    31.21     0.15    0.78   0.56  10.80

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     1.00    0.00    1.00     0.00    15.92    16.00     0.00    0.00   0.00   0.00
sdb               0.00   198.01   19.90  156.22   159.20  2833.83    16.99     0.04    0.24   0.20   3.58

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb               0.00     5.00    0.50   17.00     4.00   176.00    10.29     0.01    0.69   0.69   1.20

Would it help if I try blktrace on this server to capture the I/O ?
I enabled it while compiling the kernel, but I don't know yet how to use
it:
any pointer on how to activate it and capture useful information?

Many thanks,
-- 
Brice Figureau <brice+lklm@daysofwonder.com>

