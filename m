Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYDIV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYDIV2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYDIV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:28:41 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58634 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbYDIV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:28:41 -0400
Date: Wed, 9 Apr 2008 17:28:40 -0400
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
Message-ID: <20080409212840.GB2160@csclub.uwaterloo.ca>
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 10:53:36PM +0200, Francis Moreau wrote:
> I'm trying to know the geometry of my hard disk from a bash script
> and that's the reason I'm looking in /sys. The reason is that I'd like
> to figure out the size of a cylinder without doing a
> ioctl(bdev, HDIO_GETGEO, &geo)
> 
> Unfortunately I can't find anything useful and this is certainly a sign
> that I'm doing something wrong.
> 
> Or maybe can I simply assume from my script that the geometry
> is always heads=255 and the number of sectors per track is 63 for all
> disks.

Many compact flash cards will report 16 heads, and 16 or 32 sectors
per track.  Compact flash can of course connect as an IDE drive, so they
are worth supporting (I keep trying to get the grub guys to accept my
patch to fix their code that also assumed all disks have 63 sectors per
track if they use LBA, but which is false since compact flash also
supports LBA even with smaller sizes).

Simplest way to find out what geometry a disk pretents to have is to ask
fdisk, and since the only use for the information is when creating
partitions, then fdisk's opinion is really all that seems to matter.  Of
course partitions can start and end anywhere so the total size is
actually all that really matters.

For example:
# fdisk -l /dev/hda

Disk /dev/hda: 260 MB, 260571136 bytes
16 heads, 32 sectors/track, 994 cylinders
Units = cylinders of 512 * 512 = 262144 bytes

   Device Boot      Start         End      Blocks   Id  System
 /dev/hda1               1          40       10224   83  Linux
 /dev/hda2              41          80       10240   83  Linux
 /dev/hda3              81         994      233984   83  Linux

So no assuming 255 and 63 is not a good idea.  Large disks tend to do it
since 255 heads and 63 sectors per track is the maximum supported, and
hence allowed them to get as much space in each "cylinder".

> Looking at parted(8) source code, I  can find this:
> 
> /* The GETGEO ioctl is no longer useful (as of linux 2.6.x).  We could
>  * still use it in 2.4.x, but this is contentious.  Perhaps we should
>  * move to EDD. */
> 
> Could anybody give me some advices ?

Why do you want to know what cylinder size the hard disk pretents to
have?  What use could it be?  Harddisks have varying numbers of sectors
per cylinder depending on how far out you are from the center of the
disk, but since software used to expect a simple X head, Y tracks, Z
sectors per track, they lie about it and pretend to have some number of
each (usually 255 heads (as if), 63 sectors per track (not likely with
todays densities), and thousands of cylinders), and even with all that
added up it still works out to less than the actual size of a modern
drive.  All that matters on a modern drive is the total number of
sectors since all access is done by requesting a specific sector number
starting from the begining of the drive.  Where it is physically located
is none of software's business, and it may not even be adjacent to the
sector with a number right next to the requested one due to defect
management and various optimizations.

-- 
Len Sorensen
