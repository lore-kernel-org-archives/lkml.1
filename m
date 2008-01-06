Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYAFCzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYAFCzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 21:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAFCzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 21:55:39 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:33056 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYAFCzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 21:55:38 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <20080102162534.GA4041@elte.hu>
	<1199292381.3258.32.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	<20080102194030.GC11638@parisc-linux.org>
	<1199304735.3258.53.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	<1199316785.3258.85.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
From: Peter Osterlund <petero2@telia.com>
Date: 06 Jan 2008 03:55:16 +0100
In-Reply-To: <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
Message-ID: <m3ir27oe7f.fsf@telia.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 2 Jan 2008, James Bottomley wrote:
> 
> > Look at the taxonomy of the bug.  This is the form of the error:
> > 
> > buffer I/O error on device sr0, logical block 20304
> > attempt to access beyond end of device
> > sr0: rw=0, want=81224, limit=40944
> > 
> > The last limit is the most suggestive, that comes straight from
> > bdev->bd_inode->i_size>>9 and is supposed to be the size of the block
> > device in 512 byte blocks. For a 4.7GB DVD, it's a little small.
> > Nothing in the sr code sets this directly (although it does come from
> > get_blkdev() for the first opener).  pktcdvd does set it, though ... and
> > probably wrongly if the drive in question isn't UDF formatted.

pktcdvd sets it when opening the /dev/pktcdvd device, but when the
drive is later opened as /dev/scd0, there is nothing that sets it
back. (Btw, 40944 is possible if the disk is a CDRW that was formatted
with "cdrwtool -m 10236".)

The problem is that pktcdvd opens the cd device in non-blocking mode
when pktsetup is run, and doesn't close it again until pktsetup -d
is run. The effect is that if you meanwhile open the cd device,
blkdev.c:do_open() doesn't call bd_set_size() because bdev->bd_openers
is non-zero.

I don't know the correct way to fix this. Maybe adding bd_set_size()
to sr.c:get_sectorsize() which already does set_capacity() would
work.

> .. but you're ignoring the fact that if pktcdvd sets it wrong, then it 
> should be visible with the pre-commit kernel *also*.

I can repeat this bug, both with and without the scsi patch that is
claimed to make a difference, both with an external USB drive and an
internal IDE drive.

To repeat:

  1. Start with an empty drive.
  2. pktsetup 0 /dev/scd0 
  3. Insert a CD containing an isofs filesystem.
  4. mount /dev/pktcdvd/0 /mnt/tmp
  5. umount /mnt/tmp
  6. Press the eject button.
  7. Insert a DVD containing a non-writable filesystem.
  8. mount /dev/scd0 /mnt/tmp
  9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
  10. If the DVD contains data beyond the physical size of a CD, you
      get I/O errors in the terminal, and dmesg reports lots of
      "attempt to access beyond end of device" errors.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
