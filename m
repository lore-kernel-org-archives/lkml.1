Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYAFDoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYAFDoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYAFDny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:43:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbYAFDnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:43:53 -0500
Date: Sat, 5 Jan 2008 19:43:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Osterlund <petero2@telia.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <m3ir27oe7f.fsf@telia.com>
Message-ID: <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain>
 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Jan 2008, Peter Osterlund wrote:
> 
> The problem is that pktcdvd opens the cd device in non-blocking mode
> when pktsetup is run, and doesn't close it again until pktsetup -d
> is run. The effect is that if you meanwhile open the cd device,
> blkdev.c:do_open() doesn't call bd_set_size() because bdev->bd_openers
> is non-zero.
> 
> I don't know the correct way to fix this. Maybe adding bd_set_size()
> to sr.c:get_sectorsize() which already does set_capacity() would
> work.

Hmm.. I wouldn't say that's the correct way to fix it. The thing is, if 
somebody has explicitly set the size of the device, than that *is* the 
size.

The kernel should do what it is told, and it very much on purpose does the 
size probing only on the first open: exactly because other open fd's in 
progress may be there explicitly to fix up something, or may simply depend 
on some size it already knew about (ie we don't want to change the size 
behind its back).

And in particular, setting the size with bd_set_size also sets the 
block-size, and while most things migt react fairly well to the pure 
*size* changing, they will react very badly indeed to the blocksize 
changing!

So no, doing a "bd_set_size()" in any but the outermost opener simply 
isn't acceptable. It would cause serious problems and total chaos for the 
block cache (we do not handle aliasing of multiple different blocksizes). 
So we are very careful indeed to only call bd_set_size() when bd_openers 
is zero.

That said, at least in your scenario:

>   1. Start with an empty drive.
>   2. pktsetup 0 /dev/scd0 
>   3. Insert a CD containing an isofs filesystem.
>   4. mount /dev/pktcdvd/0 /mnt/tmp
>   5. umount /mnt/tmp
>   6. Press the eject button.
>   7. Insert a DVD containing a non-writable filesystem.
>   8. mount /dev/scd0 /mnt/tmp
>   9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
>   10. If the DVD contains data beyond the physical size of a CD, you
>       get I/O errors in the terminal, and dmesg reports lots of
>       "attempt to access beyond end of device" errors.

part of the problem here seems to be that the "media change" notification 
that /dev/scd0 hopefully handled correctly and caused the "set_capacity()" 
hass not made it to the i_size thing (that the block device layer checks).

So the way things are *supposed* to work is that the media-change function 
("revalidate_disk()") should have triggered as part of the media change, 
and that *should* have already done the set_capacity(), and that in turn 
is the thing that should do it all (sets the disk capacity *without* 
changing the blocksize!)

But since "set_capacity()" doesn't actually change "i_size", only 
dev->capacity (which is correct - there may be many inodes associated with 
one device), we actually ended up having this subtle dependency on 
calling bd_set_size() (which we can *only* do on the first open, due to 
the blocksize issues).

Which means that media-change won't fix these things like it is supposed 
to. And I suspect we've had this bug (well, it *appears* to be a bug) for 
a while, simply because all *normal* uses will open and close the device 
properly.

Maybe a patch something like this might work out. I haven't really thought 
it through entirely - but it basically just sets the size, without doing 
the whole blocksize thing.

Jens? Al? Comments? 

Does a patch like this change the behaviour you see at all?

This all still leaves the question unanswered why that commit 
6f5391c283d7fdcf24bf40786ea79061919d1e1d changed any behaviour at all. 
Because the thing that Peter is describing has nothing to do with any 
low-level drivers what-so-ever.

		Linus

---
 fs/block_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 993f78c..6a20da9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1191,6 +1191,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
+			bd_inode->i_size = (loff_t)get_capacity(disk)<<9;
 		}
 	}
 	bdev->bd_openers++;
