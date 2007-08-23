Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXHWD46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXHWD46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbXHWD4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:56:50 -0400
Received: from mail.spacing-guild.net ([72.29.67.242]:60608 "EHLO
	mail.spacing-guild.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbXHWD4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:56:49 -0400
Message-ID: <46CD057C.3080106@fuster.org>
Date: Wed, 22 Aug 2007 23:56:44 -0400
From: Joel Fuster <j@fuster.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Joel Fuster <j@fuster.org>
Subject: Re: sysfs_dir_cache growing out of control
References: <46CCD3DF.4080303@fuster.org>
In-Reply-To: <46CCD3DF.4080303@fuster.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Fuster wrote:
> Hi,
> 
> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
> consume all the memory on my system, requiring a reboot.
> 
> Although I did not record objective evidence of this at the time, I 
> suspect I had the same problem with 2.6.18 and 2.6.20...I certainly had 
> the same symptoms.

An update to this...it seems to be related to "scanbuttond" which is an 
app that uses libusb to poll a scanner for button presses on the scanner 
itself.  The number of objects in sysfs_dir_cache stops growing when I 
kill the scanbuttond process.

An strace of one poll loop for scanbuttond follows:


nanosleep({0, 333000000}, NULL)         = 0
open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 4 entries */, 4096)      = 96
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 3 entries */, 4096)      = 72
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\0\2\t\0\1@\0\0\0\0\6\2\3\2\1\1", 18) = 18
read(2, "\t\2\31\0\1\1\0\340", 8)       = 8
read(2, "\0\t\4\0\0\1\t\0\0\0\7\5\201\3\4\0\f", 17) = 17
close(2)                                = 0
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=100, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 4 entries */, 4096)      = 96
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 3 entries */, 4096)      = 72
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\0\2\t\0\1@\0\0\0\0\6\2\3\2\1\1", 18) = 18
read(2, "\t\2\31\0\1\1\0\340", 8)       = 8
read(2, "\0\t\4\0\0\1\t\0\0\0\7\5\201\3\4\0\f", 17) = 17
close(2)                                = 0
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=100, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 5 entries */, 4096)      = 120
open("/dev/bus/usb/001/004", O_RDWR)    = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = 0
read(2, "\22\1\20\1\0\0\0@\330\5\3@\0\1\0\0\0\1", 18) = 18
read(2, "\t\2 \0\1\1\0\240", 8)         = 8
read(2, "\372\t\4\0\0\2\377\377\377\0\7\5\201\2@\0\0\7\5\2\2@\0"..., 24) 
= 24
close(2)                                = 0
open("/dev/bus/usb/001/003", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/003", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\20\1\0\0\0@{\6\3#\0\3\1\2\0\1", 18) = 18
read(2, "\t\2\'\0\1\1\0\200", 8)        = 8
read(2, "2\t\4\0\0\3\377\0\0\0\7\5\201\3\n\0\1\7\5\2\2@\0\0\7\5"..., 31) 
= 31
close(2)                                = 0
open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/001", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\20\1\t\0\0@\0\0\0\0\6\2\3\2\1\1", 18) = 18
read(2, "\t\2\31\0\1\1\0\340", 8)       = 8
read(2, "\0\t\4\0\0\1\t\0\0\0\7\5\201\3\2\0\377", 17) = 17
close(2)                                = 0
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/001/004", O_RDWR)    = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 ENOTTY (Inappropriate 
ioctl for device)
close(1)                                = 0
open("/dev/bus/usb/001/003", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/003", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/001", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=80, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 4 entries */, 4096)      = 96
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=60, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 3 entries */, 4096)      = 72
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\0\2\t\0\1@\0\0\0\0\6\2\3\2\1\1", 18) = 18
read(2, "\t\2\31\0\1\1\0\340", 8)       = 8
read(2, "\0\t\4\0\0\1\t\0\0\0\7\5\201\3\4\0\f", 17) = 17
close(2)                                = 0
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/002/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/002/001", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 1
fstat(1, {st_mode=S_IFDIR|0755, st_size=100, ...}) = 0
fcntl(1, F_SETFD, FD_CLOEXEC)           = 0
getdents(1, /* 5 entries */, 4096)      = 120
open("/dev/bus/usb/001/004", O_RDWR)    = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = 0
read(2, "\22\1\20\1\0\0\0@\330\5\3@\0\1\0\0\0\1", 18) = 18
read(2, "\t\2 \0\1\1\0\240", 8)         = 8
read(2, "\372\t\4\0\0\2\377\377\377\0\7\5\201\2@\0\0\7\5\2\2@\0"..., 24) 
= 24
close(2)                                = 0
open("/dev/bus/usb/001/003", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/003", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\20\1\0\0\0@{\6\3#\0\3\1\2\0\1", 18) = 18
read(2, "\t\2\'\0\1\1\0\200", 8)        = 8
read(2, "2\t\4\0\0\3\377\0\0\0\7\5\201\3\n\0\1\7\5\2\2@\0\0\7\5"..., 31) 
= 31
close(2)                                = 0
open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/001", O_RDONLY)  = 2
ioctl(2, USBDEVFS_CONNECTINFO, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
read(2, "\22\1\20\1\t\0\0@\0\0\0\0\6\2\3\2\1\1", 18) = 18
read(2, "\t\2\31\0\1\1\0\340", 8)       = 8
read(2, "\0\t\4\0\0\1\t\0\0\0\7\5\201\3\2\0\377", 17) = 17
close(2)                                = 0
getdents(1, /* 0 entries */, 4096)      = 0
close(1)                                = 0
open("/dev/bus/usb/001/004", O_RDWR)    = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 ENOTTY (Inappropriate 
ioctl for device)
close(1)                                = 0
open("/dev/bus/usb/001/003", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/003", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001/001", O_RDWR)    = -1 EACCES (Permission denied)
open("/dev/bus/usb/001/001", O_RDONLY)  = 1
ioctl(1, USBDEVFS_IOCTL, 0x7fffb3a08420) = -1 EPERM (Operation not 
permitted)
close(1)                                = 0
open("/dev/bus/usb/001/004", O_RDWR)    = 1
ioctl(1, USBDEVFS_CLAIMINTERFACE, 0x7fffb3a0848c) = 0
ioctl(1, USBDEVFS_CONTROL, 0x7fffb3a08420) = 64
ioctl(1, USBDEVFS_CONTROL, 0x7fffb3a08420) = 8
ioctl(1, USBDEVFS_RELEASEINTERFACE, 0x7fffb3a08494) = 0
close(1)                                = 0
nanosleep({0, 333000000},  <unfinished ...>


