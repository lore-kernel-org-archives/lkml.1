Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYLDNJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYLDNJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYLDNI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:08:58 -0500
Received: from brick.kernel.dk ([93.163.65.50]:2550 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYLDNI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:08:57 -0500
Date: Thu, 4 Dec 2008 14:08:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] cdrom weirdness
Message-ID: <20081204130851.GV18255@kernel.dk>
References: <20081204041450.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204041450.GH28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2008, Al Viro wrote:
> 1) CDROM_LOCKDOOR sets a global variable (keeplocked) that affects all
> cdroms.  Intentional?

It's always been so, predates me. Pretty ugly, I don't think anyone
would mind if that was changed to be per-device when the ioctl is ussed
:-)

> 2) cdrom_dvd_rw_close_write() call can be delayed indefinitely by keeping
> an ioctl-only (opened with O_NDELAY) descriptor.

Yep, not sure what you want me to say here...

> 3) open cdrom for data, have the door locked, keep fd opened.
>    open it again for write, have the open fail and cleanup in cdrom_open()
>    will happily unlock the door for you.  I'd change that to "lock if we
>    had no lockers, unlock on failure exit if we did lock", but there's
>    an interesting comment:
>         /* Something failed.  Try to unlock the drive, because some drivers
>         (notably ide-cd) lock the drive after every command.
> 	...
>    What the hell is that about?  It's not "some drivers", AFAICT - it's
>    been done explicitly in open_for_data().  Or is there something
>    really driver-specific in it?
> 
> 4) while we are at it, if you clear lockdoor via sysctl while something has
>    cdrom opened - no unlock on close for you.
> 
> 5) autoeject happens on the last close *IF* the last file happens to be
>    opened for data.  IOW, if some crap has opened it ioctl-only and kept
>    that opened after everyone else has closed - no autoeject for you.

Most of the above are long known issues with not counting
write/non-write/ioctls opens, since it was tricky/impossible to do
because of fcntl().

> 6)	/*
> 	 * flush cache on last write release
> 	 */
> 	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
> 		cdrom_close_write(cdi);
>    is interesting, seeing that nothing has ever touched ->for_data, for
>    values of "ever" including "since the code in question had been merged
>    into the tree"...

Hmm weird, you are right. The member was added in 2.6.2, but never used
except here. I guess this just needs to use opened_for_data.

-- 
Jens Axboe

