Return-Path: <linux-kernel-owner+w=401wt.eu-S934585AbXHXAoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585AbXHXAoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934034AbXHXAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:44:16 -0400
Received: from mail.spacing-guild.net ([72.29.67.242]:37131 "EHLO
	mail.spacing-guild.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857AbXHXAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:44:15 -0400
Message-ID: <46CE29DA.60409@fuster.org>
Date: Thu, 23 Aug 2007 20:44:10 -0400
From: Joel Fuster <j@fuster.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sysfs_dir_cache growing out of control
References: <46CCD3DF.4080303@fuster.org> <46CD057C.3080106@fuster.org> <20070823095933.GA6742@kroah.com>
In-Reply-To: <20070823095933.GA6742@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 22, 2007 at 11:56:44PM -0400, Joel Fuster wrote:
>> Joel Fuster wrote:
>>> Hi,
>>> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
>>> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
>>> consume all the memory on my system, requiring a reboot.
> 
> Hm, those items should consume all the memory, but it should be freed if
> you have memory pressure from other places.  Does it cause the machine
> to lock up, or you just got scared when seeing them?
> 
Right.  The problem is that the memory never seems to get freed no 
matter what I do.  I've tried setting /proc/sys/vm/vfs_cache_pressure to 
10000, but after a few days all my programs are running out of swap and 
I have to reboot to get things back to a usable state.

> Oh, and does the same thing happen if you do not use SLUB, but rather
> the older SLAB?

OK I just rebuilt 2.6.22.3 with SLAB and I seem to be getting the same 
result..obviously I haven't waited several days, but 
sysfs_dir_cache/dentry/inode_cache grow continuously when scanbuttond is 
running, and stop growing when it isn't.


>>
>> An strace of one poll loop for scanbuttond follows:
>>
>>
>> nanosleep({0, 333000000}, NULL)         = 0
>> open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
>> fstat(1, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
>> fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
>> getdents(1, /* 4 entries */, 4096)      = 96
>> getdents(1, /* 0 entries */, 4096)      = 0
>> close(1)                                = 0
>> open("/dev/bus/usb/002", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
>> fstat(1, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
>> fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
>> getdents(1, /* 3 entries */, 4096)      = 72
>> open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
>> open("/dev/bus/usb/002/001", O_RDONLY)  = 2
>> ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
>> permitted)
> 
> <snip>
> 
> I don't see any sysfs accesses there, only usbfs accesses.

Yes, I don't know enough to understand why this would affect 
sysfs_dir_cache, but there definitely seems to be a connection.

Thanks for the help,

Joel

