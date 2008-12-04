Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYLDEPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYLDEPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYLDEOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:14:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50189 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYLDEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:14:53 -0500
Date: Thu, 4 Dec 2008 04:14:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] cdrom weirdness
Message-ID: <20081204041450.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) CDROM_LOCKDOOR sets a global variable (keeplocked) that affects all
cdroms.  Intentional?

2) cdrom_dvd_rw_close_write() call can be delayed indefinitely by keeping
an ioctl-only (opened with O_NDELAY) descriptor.

3) open cdrom for data, have the door locked, keep fd opened.
   open it again for write, have the open fail and cleanup in cdrom_open()
   will happily unlock the door for you.  I'd change that to "lock if we
   had no lockers, unlock on failure exit if we did lock", but there's
   an interesting comment:
        /* Something failed.  Try to unlock the drive, because some drivers
        (notably ide-cd) lock the drive after every command.
	...
   What the hell is that about?  It's not "some drivers", AFAICT - it's
   been done explicitly in open_for_data().  Or is there something
   really driver-specific in it?

4) while we are at it, if you clear lockdoor via sysctl while something has
   cdrom opened - no unlock on close for you.

5) autoeject happens on the last close *IF* the last file happens to be
   opened for data.  IOW, if some crap has opened it ioctl-only and kept
   that opened after everyone else has closed - no autoeject for you.

6)	/*
	 * flush cache on last write release
	 */
	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
		cdrom_close_write(cdi);
   is interesting, seeing that nothing has ever touched ->for_data, for
   values of "ever" including "since the code in question had been merged
   into the tree"...
