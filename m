Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbYAFOvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbYAFOvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbYAFOnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:43:03 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40698 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759372AbYAFOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:43:00 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Osterlund <petero2@telia.com>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com>
	 <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 08:42:54 -0600
Message-Id: <1199630574.5205.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-01-05 at 19:43 -0800, Linus Torvalds wrote:
>  fs/block_dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 993f78c..6a20da9 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1191,6 +1191,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
>  			}
>  			if (bdev->bd_invalidated)
>  				rescan_partitions(bdev->bd_disk, bdev);
> +			bd_inode->i_size = (loff_t)get_capacity(disk)<<9;
>  		}
>  	}
>  	bdev->bd_openers++;

Actually, I think that code is fine ... the block size shouldn't change
across positive values of bd_openers.  I think the true fix is below:
pktcdvd shouldn't be mucking with the size of the underlying CD/DVD ...
it can change its own layered device capacity, certainly, but it
shouldn't be mucking with the capacity that was already set in the
sr_probe routine.  I'm in two minds as to whether the set capacity on
the underlying device should be removed as well ... I think it should,
but it is harmless as the sr_probe will also reset it.

However, I'll defer to what Al wants to do.

James

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3535ef8..10f3692 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2344,7 +2344,6 @@ static int pkt_open_dev(struct pktcdvd_device *pd, int write)
 
 	set_capacity(pd->disk, lba << 2);
 	set_capacity(pd->bdev->bd_disk, lba << 2);
-	bd_set_size(pd->bdev, (loff_t)lba << 11);
 
 	q = bdev_get_queue(pd->bdev);
 	if (write) {


