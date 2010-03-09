Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab0CIKQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:16:08 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:55158 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab0CIKQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:16:05 -0500
Message-ID: <4B961FE1.5040105@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 13:16:01 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Mike Snitzer <snitzer@redhat.com>,
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
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru> <20100309100153.GD18077@nb.net.home>
In-Reply-To: <20100309100153.GD18077@nb.net.home>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Tue, Mar 09, 2010 at 09:53:37AM +0300, Michael Tokarev wrote:
[]
>> Think of a raid5 array - with all the mentioned good stuff in place
>> fdisk should figure out to align partitions on the array stripe
>> boundary, and should do that automatically.  And this should be
> 
> Yes. For userspace there is not a difference between RAID and non-RAID
> device -- the topology support in kernel provides unified API to all
> devices. It means we needn't any extra support for RAIDs in
> fdisk/parted. The userspace tools follow topology data from kernel.
> 
> The good thing with 1MiB default alignment is that it is usable for
> usual stripe sizes (for sizes greater than 1MiB we use optimal I/O
> size).

No, it's not that simple.  For raid5 (and I especially mentioned raid5
above), raid4 and raid6, 1MiB is only good when the number of devices
is 2^N+1 (for raid[45]) or 2^N+2 (for raid6).  For raid5 that means
3, 5, 9, 17, .. disks.  In all other cases the alignment (which should
match stripe size) will not be power of two.  For example, for a 4-disk
raid5 array with 1MiB chunk size the partitions should be aligned at
3MiB boundaries.  For 6-disk raid5 with 256KiB chunk size it is
5x256=1280 Kib.  And so on.

Yes it has little to do with the $subject (4KiB sectors), but it is
closely related still.

>> most easy to debug/test, since the whole thing is controllable
>> by kernel.
> 
> I did almost all my tests with scsi_debug or MD RAID0 on scsi_debug.
> It works as expected.

Actually, for raid0, the alignment is questionable.  Should it be a
multiple of chunk size or whole stripe size?  I'm not sure, both ways
has bad and good sides..  But if it is the latter, the same issues
pops up again: do a 3-disk raid0 and you'll have to align to 3*2^N.

[]
>  Disk /dev/sdb: 2621 MB, 2621440000 bytes
>  255 heads, 63 sectors/track, 318 cylinders, total 5120000 sectors
>  Units = sectors of 1 * 512 = 512 bytes
>  Sector size (logical/physical): 512 bytes / 4096 bytes
>  I/O size (minimum/optimal): 4096 bytes / 32768 bytes

Good.

>  # mdadm --create /dev/md8 --level=5 --raid-devices=4 /dev/sdb{1,2,3,4}

That's 3-disk stripe size with default 64Kb chunk size, which makes
3x64=320KiB - the number to which everything should be aligned.

>  # fdisk -lcu /dev/md8
> 
>  Disk /dev/md8: 1572 MB, 1572667392 bytes
>  2 heads, 4 sectors/track, 383952 cylinders, total 3071616 sectors
>  Units = sectors of 1 * 512 = 512 bytes
>  Sector size (logical/physical): 512 bytes / 4096 bytes
>  I/O size (minimum/optimal): 65536 bytes / 65536 bytes

And here we go: fdisk does not see the right number: nothing
is dividable by 3.

[]
>  # cat /sys/block/md8/md8p{1,2}/alignment_offset
>  0
>  0

And that's where the issue is.  md does not {sup,re}port all
this stuff yet.

This is what I'm talking about.

Thanks!

/mjt
