Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZEYV5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZEYV5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZEYV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:57:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZEYV5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:57:00 -0400
Date: Tue, 26 May 2009 00:47:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       aeb@cwi.nl
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090525214755.GE6856@redhat.com>
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:08:12PM -0400, Alan Stern wrote:
> On Mon, 25 May 2009, Michael S. Tsirkin wrote:
> 
> > > So apparently this is a bug in the device; it doesn't respond correctly
> > > to the first READ command.  But since it does respond correctly to 
> > > later commands, everything works okay thereafter.  You ought to be able 
> > > to recover from the error by running
> > > 
> > > 	blockdev --rereadpt /dev/sdb
> > > 
> > > manually.
> > 
> > Yes, this helps.
> > Would it make sense for kernel to retry automatically?
> > Why doesn't it?
> 
> I don't know the details in this case.  Most likely the error code 
> (Logical Block Address Out of Range) is interpreted as a fatal 
> non-retryable error.  For other sorts of errors, the kernel does retry.
> 
> > > As far as I can tell, this has nothing to do with any user programs in 
> > > the distribution.  It appears to be entirely the device's fault.
> > > 
> > > Alan Stern
> > 
> > BTW, any idea how come I later get errors apparently from amiga fs?
> 
> Not a clue.  Unless it was some odd side effect of the partition code 
> trying to interpret an uninitialized buffer.
> 
> Alan Stern


So, the following works for me as a work-around.  But it's probably not
the appropriate way to solve the problem. Or is it? Can someone who
understands partitions and filesystems tell?



block: retry on I/O error when reading partition table

Retry once on an I/O error when reading the partition table:
there's no much to loose, and this helps with some disk on
key devices I have.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..28b857a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -510,25 +510,34 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	struct hd_struct *part;
 	struct parsed_partitions *state;
 	int p, highest, res;
+	int i;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
-	res = invalidate_partition(disk, 0);
-	if (res)
-		return res;
-
-	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
-	while ((part = disk_part_iter_next(&piter)))
-		delete_partition(disk, part->partno);
-	disk_part_iter_exit(&piter);
 
-	if (disk->fops->revalidate_disk)
-		disk->fops->revalidate_disk(disk);
-	check_disk_size_change(disk, bdev);
-	bdev->bd_invalidated = 0;
-	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
-		return 0;
-	if (IS_ERR(state))	/* I/O error reading the partition table */
+	/* Michael S. Tsirkin has a disk on key where rescanning helps. */
+#define RESCAN_RETRY_CNT 2
+	for (i = 0; i < RESCAN_RETRY_CNT; ++i) {
+		res = invalidate_partition(disk, 0);
+		if (res)
+			return res;
+
+		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter)))
+			delete_partition(disk, part->partno);
+		disk_part_iter_exit(&piter);
+
+		if (disk->fops->revalidate_disk)
+			disk->fops->revalidate_disk(disk);
+		check_disk_size_change(disk, bdev);
+		bdev->bd_invalidated = 0;
+		if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
+			return 0;
+		if (!IS_ERR(state))
+			break;
+		/* I/O error reading the partition table. Retry. */
+	}
+	if (IS_ERR(state)) /* I/O error reading the partition table */
 		return -EIO;
 
 	/* tell userspace that the media / partition table may have changed */

-- 
MST
