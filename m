Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZFCPiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZFCPiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZFCPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:37:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbZFCPhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:37:42 -0400
Message-ID: <4A26989A.3030300@redhat.com>
Date: Wed, 03 Jun 2009 10:36:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
CC: axboe@kernel.dk, akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
       artem.bityutskiy@nokia.com
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
In-Reply-To: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Karpov wrote:
> Hello, 
> 
> these patches are resent (a bit re-worked and separated from other stuff).
> The issue was discussed here:
> http://marc.info/?l=linux-fsdevel&m=124402900920380&w=2
> 
> Summary:
> 
> 1. Generic mechanism for notifications of user space about file system's
>    errors/inconsistency on a particular partition using:
> 
>      - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
>      - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]

My first thought here, just at a very high level, is that fs_errors
rather than fs_unclean may be more accurate; at least in my filesystem
developer world, an "unclean" filesystem is one that was not unmounted
cleanly, not one with ... errors.  "fs_errors"  (or fs_has_errors?)
would also be more in sync with ext3's "errors=" mount options...

>    Userspace might want to monitor these notifications (poll2() on sysfs 
>    file or udevd's rule for uevent) and fix the fs damage.
>    Filesystem can be marked clean again by writing '0' to the 
>    corresponding 'fs_unclean' sysfs file.

It seems a little odd to me that you can just clear this error condition
without necessarily fixing the actual error, but I don't know how else
it should be done....

For ext2/3/4, the fs is -marked- with errors in the superblock, so when
it mounts with that error flag cleared (by fsck), the mount itself could
clear this error condition perhaps?  Maybe it could be the filesystem's
choice whether the error condition is clearable from userspace?

It's also possible that the error was encountered in memory rather than
from on-disk, so it might be nice to differentiate somehow, at least for
filesystems which can do this.  I'm thinking here of "I read something
from disk that was supposed to be an inode but it had the wrong magic
number" vs. "I hit a programming error that caused the transaction
subsystem to get into a state where the filesystem had to shut down" -
in the latter case, fsck is not going to resolve it...

Thanks,
-Eric

>    Currently some file systems remount themselves r/o on critical errors
>    (*FAT; EXT2 depending on 'errors' mount option), userspace is generally
>    unaware of such events. This feature will allow user space to become 
>    aware of possible file system problems and do something about them 
>    (e.g. run fsck automatically or with user's consent).
>    [PATCH 1]
> 
> 2. Make FAT and EXT2 file systems use the above mechanism to optionally
>    notify user space about errors. Implemented as 'notify' mount option
>    (PATCH 3,4).
>    FAT error reporting facilities had to be re-factored (PATCH 2) in 
>    order to simplify sending error notifications.
> 
> Adrian Hunter and Artem Bityutskiy provided input and ideas on implementing
> these features.
> 
> Denis Karpov.
