Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0CIKC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:02:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab0CIKC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:02:57 -0500
Date: Tue, 9 Mar 2010 11:01:53 +0100
From: Karel Zak <kzak@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100309100153.GD18077@nb.net.home>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B95F071.3070400@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 09:53:37AM +0300, Michael Tokarev wrote:
> Mike Snitzer wrote:
> []
> > I've been keeping track of all the pieces in play, have coordinated
> > with kzak and jim, and have a summary that offers some amount of macro
> > detail (at the end I touch on parted and fdisk):
> > 
> > http://people.redhat.com/msnitzer/docs/io-limits.txt
> 
> What I don't see in this thread and in this document is - any mention
> of linux md layer.  I think it is the first candidate to test the whole
> thing, the easiest and most important one.  I mean the alignment and
> "recommended I/O size" and all this similar stuff.
> 
> Think of a raid5 array - with all the mentioned good stuff in place
> fdisk should figure out to align partitions on the array stripe
> boundary, and should do that automatically.  And this should be

Yes. For userspace there is not a difference between RAID and non-RAID
device -- the topology support in kernel provides unified API to all
devices. It means we needn't any extra support for RAIDs in
fdisk/parted. The userspace tools follow topology data from kernel.

The good thing with 1MiB default alignment is that it is usable for
usual stripe sizes (for sizes greater than 1MiB we use optimal I/O
size).

> most easy to debug/test, since the whole thing is controllable
> by kernel.

I did almost all my tests with scsi_debug or MD RAID0 on scsi_debug.
It works as expected. (Note that kernel 2.6.31 has a problem with
alignment_offset calculation on stacked devices, so use the latest
kernel where the bug is already fixed.)

But I didn't tried to use unpartitioned (whole) 4K disks for RAIDs,
because scsi_debug does not allow to create more devices (and I don't
have a real HW).

Some tests are available in util-linux-ng sources:
http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=tree;f=tests/ts/fdisk

    Karel


 # modprobe scsi_debug dev_size_mb=2500 sector_size=512 physblk_exp=3

    [..create partitions...]

 # fdisk -lcu /dev/sdb 

 Disk /dev/sdb: 2621 MB, 2621440000 bytes
 255 heads, 63 sectors/track, 318 cylinders, total 5120000 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 4096 bytes
 I/O size (minimum/optimal): 4096 bytes / 32768 bytes
 Disk identifier: 0xb585b0be

 Device Boot         Start         End      Blocks   Id  System
 /dev/sdb1            2048     1026047      512000   83  Linux
 /dev/sdb2         1026048     2050047      512000   83  Linux
 /dev/sdb3         2050048     3074047      512000   83  Linux
 /dev/sdb4         3074048     4098047      512000   83  Linux


 # mdadm --create /dev/md8 --level=5 --raid-devices=4 /dev/sdb{1,2,3,4}

     [...create partitions on the raid...]

 # fdisk -lcu /dev/md8

 Disk /dev/md8: 1572 MB, 1572667392 bytes
 2 heads, 4 sectors/track, 383952 cylinders, total 3071616 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 4096 bytes
 I/O size (minimum/optimal): 65536 bytes / 65536 bytes
 Disk identifier: 0x1bb6fd8d

 Device Boot          Start         End      Blocks   Id  System
 /dev/md8p1            2048     1435647      716800   83  Linux
 /dev/md8p2         1435648     2869247      716800   83  Linux


 Check offsets (alignment):

 # cat /sys/block/sdb/sdb{1,2,3,4}/alignment_offset
 0
 0
 0
 0

 # cat /sys/block/md8/md8p{1,2}/alignment_offset
 0
 0

-- 
 Karel Zak  <kzak@redhat.com>
