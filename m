Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbZAOAC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbZAOAC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZAOACs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:02:48 -0500
Received: from sov-mail-b0012.gradwell.net ([193.84.87.36]:48653 "EHLO
	sov-mail-b0012.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbZAOACr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:02:47 -0500
Date: Thu, 15 Jan 2009 00:02:19 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27 BUG at fs/inode.c:263 with ext4
Message-ID: <20090115000219.3959ea80@lithium.local.net>
In-Reply-To: <20090114215430.GK6222@mit.edu>
References: <20090114210143.39e27168@lithium.local.net>
	<20090114215430.GK6222@mit.edu>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 16:54:30 -0500, I waved a wand and this message
magically appears in front of Theodore Tso:

> On Wed, Jan 14, 2009 at 09:01:43PM +0000, Alex Buell wrote:
> > I've been testing ext4 with some spare disks, tonight I created an
> > ext4fs on a USB 60GB hard disk, and backed up my /home partition
> > onto it with rsync.
> > 
> > After umounting the device, and switching off the USB connection I
> > got the following in my /var/log/messages.
> > 
> > What would this suggest? I'd be happy to supply further information
> > if required.
> 
> Can you reproduce this error?  

I've just tried with another PATA hard disk over USB. Although there wasn't a BUG, I noticed this in the logs: 

Jan 14 23:04:34 lithium usb 1-3.3: USB disconnect, address 14
Jan 14 23:04:34 lithium udevd-event[17345]: unlink_secure: chmod(/dev/bus/usb/001/014, 0000) failed: No such file or directory

Which makes me wonder if you might be right in that it might be a problem with udevd.

> ... and it's apparently coming from udevd when it deletes the device
> node from /dev, which looks like is a tempfs filesystem.  That would
> explain the call stack, which shows that clear_inode() was apparently
> called from shmem_delete_inode():
> 
> > Jan 14 20:50:00 lithium [<c0157c55>] shmem_delete_inode+0x0/0xae
> > Jan 14 20:50:00 lithium [<c016b6e3>] generic_delete_inode+0x91/0xf9
> > Jan 14 20:50:00 lithium [<c016ae1d>] iput+0x48/0x4a
> > Jan 14 20:50:00 lithium [<c0163a44>] do_unlinkat+0xb0/0x11f
> > Jan 14 20:50:00 lithium [<c0112ace>] do_page_fault+0x23c/0x54a
> > Jan 14 20:50:00 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
> 
> That would imply that there were pages from the block device still in
> the page cache, which I suspect means they were left over from mke2fs
> or fsck, or some other program directly accessing the block device
> directly.  I wonder if this BUG can be triggered if a process has an
> open file descriptor on the device at the time when it's powered off,
> or pulled from the system?

After that message in the /var/log/messages file, I tried a couple of times, could not reproduce anything at all. I think that this probably is a udevd problem. But I do add that before I used the disks, I did run mkfs.ext4 to create the filesystem, and also a few fsck.ext4 runs, all of which completed without problems. 

I am currently running another rsync task with the disk at the moment. 
-- 
http://www.munted.org.uk

Fearsome grindings.
