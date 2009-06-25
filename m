Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZFYSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZFYSXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFYSXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:23:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZFYSXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:23:06 -0400
Date: Thu, 25 Jun 2009 14:23:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       martin.petersen@oracle.com
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Message-ID: <20090625182302.GA23113@redhat.com>
References: <200906250904.57149.elendil@planet.nl> <200906251840.07617.elendil@planet.nl> <20090625172041.GA22891@redhat.com> <200906251953.34253.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906251953.34253.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009 at  1:53pm -0400,
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 25 June 2009, Mike Snitzer wrote:
> > > I'm afraid those files don't exist on my systems (none of them: arm,
> > > s390 and x86_64 notebook). Some kernel config option I'm missing
> > > maybe?
> >
> > You should definitely have the topology attributes in the associated
> > device's sysfs tree.
> 
> Ah, sorry. I'd switched back to .30 for the arm system because of this.
> (And on the s390 box I looked for sda instead of dasdb; duh!)
> 
> Here are the values for arm:
> 
> $ cat /sys/block/sda/sda6/alignment_offset
> 0
> $ cat /sys/block/sda/queue/physical_block_size
> 512
> $ cat /sys/block/sda/queue/logical_block_size
> 512
> 
> And here's the lot for the s390 emulator:
> 
> # grep . /sys/block/dasdb/dasdb*/alignment_offset
> /sys/block/dasdb/dasdb1/alignment_offset:0
> /sys/block/dasdb/dasdb2/alignment_offset:0
> # grep . /sys/block/dasdb/queue/physical_block_size
> 4096
> # grep . /sys/block/dasdb/queue/logical_block_size
> 4096
> 
> # pvs -o +pe_start
>   PV          VG     Fmt  Attr PSize   PFree 1st PE
>   /dev/dasdb1 mordor lvm2 a-   388.00M    0  192.00K
>   /dev/dasdb2 mordor lvm2 a-   388.00M    0  192.00K
> # dmsetup ls
> mordor-home     (254, 0)
> # dmsetup table
> mordor-home: 0 794624 linear 94:5 384
> mordor-home: 794624 794624 linear 94:6 384


OK, I found a really stupid bug.  I was passing the data start offset
(pe_start) through to blk_stack_limits() in terms of sectors rather than
bytes.  The following should silence your warnings:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4899ebe..2cba557 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start) < 0)
+	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
 		DMWARN("%s: target device %s is misaligned",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 
