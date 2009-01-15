Return-Path: <linux-kernel-owner+w=401wt.eu-S1765337AbZAON5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765337AbZAON5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZAON5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:57:07 -0500
Received: from thunk.org ([69.25.196.29]:49293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710AbZAON5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:57:06 -0500
Date: Thu, 15 Jan 2009 08:57:02 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27, ext4 and bad USB disks
Message-ID: <20090115135702.GC30522@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alex Buell <alex.buell@munted.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090115110644.377ebc38@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115110644.377ebc38@lithium.local.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:06:44AM +0000, Alex Buell wrote:
> I've got a couple of bad disks here which I just tested with ext4 over
> USB 2.0. Bad disk errors doesn't appear to be handled gracefully at
> all - I had this in the logs:
>  
> Jan 15 10:31:47 lithium end_request: I/O error, dev sda, sector 19626288
> Jan 15 10:31:47 lithium Buffer I/O error on device sda1, logical block 2453282

Warnings in fs/buffer.c

> Jan 15 10:33:59 lithium INFO: task rsync:31719 blocked for more than 120 seconds.
> Jan 15 10:33:59 lithium "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 15 10:33:59 lithium rsync         D f7b9cbb0     0 31719  31718

Softlockup warning....

> Jan 15 10:55:55 lithium JBD2: I/O error detected when updating journal superblock for sda1:8.
> Jan 15 10:55:55 lithium usb 1-3.3: USB disconnect, address 6
> Jan 15 10:55:55 lithium ext4_abort called.
> Jan 15 10:55:55 lithium EXT4-fs error (device sda1): ext4_journal_start_sb: Detected aborted journal
> Jan 15 10:55:55 lithium Remounting filesystem read-only

This is when things went badly enough that we remounted the filesystem
read-only.  An interesting question is whether we could have given up
much earlier.  We are reflecting the I/O errors back up to userspace,
but if we have some way of querying the block layer that the device is
*gone*, or the block layer calls some callback function that the
device is *gone*, maybe we would be better off invalidating all of the
file descriptors and then force-unmounting the filesystem right away.
It would avoid a lot of the noise in the log.


> Jan 15 10:55:55 lithium EXT4-fs error (device sda1) in ext4_da_writepages: IO failure
> Jan 15 10:55:55 lithium ext4_da_writepages: jbd2_start: 63307 pages, ino 86552; err -30
> Jan 15 10:55:55 lithium Pid: 2126, comm: sync Tainted: P          2.6.27-gentoo-r7 #1
> Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7
> Jan 15 10:55:55 lithium [<c011675c>] __wake_up+0x29/0x39
> Jan 15 10:55:55 lithium [<c01cfddd>] ext4_da_writepages+0x118/0x2c7

This error we've already toned down in commit 2a21e37e (merged for
2.6.29).  The problem with the log noise is that it tends to obscure
the original root cause of the filesystem getting remounted read-only.
Furthermore, the stack trace really wasn't useful.  It's not a
*critical* bug fix, per se, but it would make it a lot easier to debug
problem reports from users who are trying out ext4 with 2.6.27 and
2.6.28, so I'll try to get the -stable kernel maintainers to accept
it.

						- Ted
