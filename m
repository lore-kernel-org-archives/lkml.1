Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYAFSXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYAFSXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYAFSWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:22:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbYAFSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:22:51 -0500
Date: Sun, 6 Jan 2008 10:14:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Peter Osterlund <petero2@telia.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <1199630574.5205.14.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0801060954010.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>  <1199292381.3258.32.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>  <20080102194030.GC11638@parisc-linux.org>  <1199304735.3258.53.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>  <1199316785.3258.85.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>  <m3ir27oe7f.fsf@telia.com>  <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
 <1199630574.5205.14.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jan 2008, James Bottomley wrote:
> > index 993f78c..6a20da9 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -1191,6 +1191,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
> >  			}
> >  			if (bdev->bd_invalidated)
> >  				rescan_partitions(bdev->bd_disk, bdev);
> > +			bd_inode->i_size = (loff_t)get_capacity(disk)<<9;
> >  		}
> >  	}
> >  	bdev->bd_openers++;
> 
> Actually, I think that code is fine ... the block size shouldn't change
> across positive values of bd_openers.

The block size should indeed not change, and that's why we must *not* do 
bd_set_size() there (because that changes the block size too, not just the 
size of the device).

But I would argue that if we have had a device invalidation event (ie 
media change), then we should indeed change the actual *size* of the block 
device as seen by anybody who opens the file again.

And yes, it will affect old openers of the same inode too (since the size 
is in the inode, not the file descriptor), but considering that this 
really should only happen for media change events, I think that's better 
than what we used to have.

Now, we could have made it even more clear by moving the "i_size" setting 
into the same "if (dbev->bd_invalidated)" conditional, but the thing is, 
we only set bd_invalidated for devices that have minors, so things like 
floppies etc that don't have partition support also don't have 
bd_invalidated set (in effect, bd_invalidated really *is* just a flag for 
the partitioning code, not for disk change in general).

That said:

> pktcdvd shouldn't be mucking with the size of the underlying CD/DVD ...

I'm not sure if it should be mucking with the size or not, but it 
definitely shouldn't be mucking with the block-size, because that can 
indeed cause huge problems. 

So removing the  bd_set_size() is almost certainly the right thing to do 
(because it's always incorrect to do at an "inner" open), and the real 
size should have already been set by the regular open.

But this should be tested by somebody who uses the dang thing. My personal 
favourite for a real fix would actually be to always make the capacity of 
the pktcdvd device match the capacity of the underlying device, ie the 
diff would look something like the appended (untested as usual), but that 
may be a bit too extensive a change.

But regardless, I think the i_size change makes sense - at least in some 
form. It doesn't necessarily have to be the explicit i_size setting: I 
also considered just changing the block_dev.c do_open() make bd_set_size() 
_unconditionally_, and then move the "if (!bdev->bd_openers)" test into 
bd_set_size(), so that people couldn't even change the blocksize by 
mistake!

I'd still like to hear comments from Al in particular, if he has something 
to say. 

			Linus
---
 drivers/block/pktcdvd.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3535ef8..1b23681 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2342,9 +2342,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, int write)
 		goto out_unclaim;
 	}
 
-	set_capacity(pd->disk, lba << 2);
-	set_capacity(pd->bdev->bd_disk, lba << 2);
-	bd_set_size(pd->bdev, (loff_t)lba << 11);
+	set_capacity(pd->disk, get_capacity(pd->bdev->bd_disk));
 
 	q = bdev_get_queue(pd->bdev);
 	if (write) {
