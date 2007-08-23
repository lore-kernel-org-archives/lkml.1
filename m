Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbXHWKFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbXHWKFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbXHWKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:05:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53505 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbXHWKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:05:45 -0400
Date: Thu, 23 Aug 2007 02:59:33 -0700
From: Greg KH <greg@kroah.com>
To: Joel Fuster <j@fuster.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs_dir_cache growing out of control
Message-ID: <20070823095933.GA6742@kroah.com>
References: <46CCD3DF.4080303@fuster.org> <46CD057C.3080106@fuster.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD057C.3080106@fuster.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:56:44PM -0400, Joel Fuster wrote:
> Joel Fuster wrote:
>> Hi,
>> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
>> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
>> consume all the memory on my system, requiring a reboot.

Hm, those items should consume all the memory, but it should be freed if
you have memory pressure from other places.  Does it cause the machine
to lock up, or you just got scared when seeing them?

Oh, and does the same thing happen if you do not use SLUB, but rather
the older SLAB?

>> Although I did not record objective evidence of this at the time, I 
>> suspect I had the same problem with 2.6.18 and 2.6.20...I certainly had 
>> the same symptoms.
>
> An update to this...it seems to be related to "scanbuttond" which is an app 
> that uses libusb to poll a scanner for button presses on the scanner 
> itself.  The number of objects in sysfs_dir_cache stops growing when I kill 
> the scanbuttond process.
>
> An strace of one poll loop for scanbuttond follows:
>
>
> nanosleep({0, 333000000}, NULL)         = 0
> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
> fstat(1, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
> fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
> getdents(1, /* 4 entries */, 4096)      = 96
> getdents(1, /* 0 entries */, 4096)      = 0
> close(1)                                = 0
> open("/dev/bus/usb/002", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
> fstat(1, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
> fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
> getdents(1, /* 3 entries */, 4096)      = 72
> open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
> open("/dev/bus/usb/002/001", O_RDONLY)  = 2
> ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
> permitted)

<snip>

I don't see any sysfs accesses there, only usbfs accesses.

And it looks like a very dumb program, iterating over all usb devices
all the time?  You would think that it would not do that, otherwise your
power consumption is going to be very high, and the odds that a new usb
device is going to show up that quickly is pretty low.

thanks,

greg k-h
