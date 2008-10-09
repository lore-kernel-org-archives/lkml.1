Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYJIOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYJIOEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYJIOEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:04:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:52817 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbYJIOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:04:33 -0400
Subject: Re: Partition check considered as error is breaking mounting in
	2.6.27
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>, me@bobcopeland.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       lcapitulino@mandriva.com.br, draconux@gmail.com,
       dlallement@mandriva.com, pterjan@mandriva.com, axboe@kernel.dk
In-Reply-To: <ac3eb2510810080901g3c3ae2d6l1dd247ed2a1837af@mail.gmail.com>
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	 <200809121714.05443.herton@mandriva.com.br>
	 <b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
	 <200809121807.28345.herton@mandriva.com.br>
	 <20080912163650.0f85a759.akpm@linux-foundation.org>
	 <ac3eb2510810080901g3c3ae2d6l1dd247ed2a1837af@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 16:04:28 +0200
Message-Id: <1223561068.4633.2.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 18:01 +0200, Kay Sievers wrote:
> On Sat, Sep 13, 2008 at 1:36 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 12 Sep 2008 18:07:27 -0300
> > Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> >
> >> Yes, here goes a new version:
> >
> > Well gee.  Given a choice, I went and replied to the wrong thread.
> > Here's what I think:
> >
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > Herton Krzesinski reports that the error-checking changes in
> > 04ebd4aee52b06a2c38127d9208546e5b96f3a19 ("block/ioctl.c and
> > fs/partition/check.c: check value returned by add_partition") cause his
> > buggy USB camera to no longer mount.  "The camera is an Olympus X-840.
> > The original issue comes from the camera itself: its format program
> > creates a partition with an off by one error".
> >
> > Buggy devices happen.  It is better for the kernel to warn and to proceed
> > with the mount.
> >
> > Reported-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Cc: Abdel Benamrouche <draconux@gmail.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  fs/partitions/check.c |    1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff -puN fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal fs/partitions/check.c
> > --- a/fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal
> > +++ a/fs/partitions/check.c
> > @@ -540,7 +540,6 @@ int rescan_partitions(struct gendisk *di
> >                if (from + size > get_capacity(disk)) {
> >                        printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> >                                disk->disk_name, p);
> > -                       continue;
> >                }
> >                res = add_partition(disk, p, from, size, state->parts[p].flags);
> >                if (res) {
> 
> I was happy to see the original fix, as if causes real problems for
> userspace, that the kernel creates invalid block devices with a size
> that exceeds the physical disk. So, if we can not make that partition
> to skip, like original patch did, because of broken hardware we don't
> want to break, can we make it at least do the obvious thing, and limit
> the partition with the broken entry to the size of the underlying
> hardware. So that the kernel does no longer pretend to have devices of
> a size which the hardware does not have.
> 
> It breaks all sort of userspace tools which read the "size" file in
> sysfs, or do BLKGETSIZE and we get, if we are lucky, only:
>   attempt to access beyond end of device
>   sda: rw=0, want=1953535936, limit=976773168
> in other cases it might cause corruption, or lead mkfs to create
> devices which will fail when they get used.


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: sanitize invalid partition table entries

We currently follow blindly what the partition table lies about the
disk, and let the kernel create block devices which can not be accessed.
Trying to identify the device leads to kernel logs full of:
  sdb: rw=0, want=73392, limit=28800
  attempt to access beyond end of device

Here is an example of a broken partition table, where sda2 starts
behind the end of the disk, and sdb3 is larger than the entire disk:
  Disk /dev/sdb: 14 MB, 14745600 bytes
  1 heads, 29 sectors/track, 993 cylinders, total 28800 sectors
     Device Boot      Start         End      Blocks   Id  System
  /dev/sdb1              29        7800        3886   83  Linux
  /dev/sdb2           37801       45601        3900+  83  Linux
  /dev/sdb3           15602       73402       28900+  83  Linux
  /dev/sdb4           23403       28796        2697   83  Linux

The kernel creates these completely invalid devices, which can not be
accessed, or may lead to other unpredictable failures:
  grep . /sys/class/block/sdb*/{start,size}
  /sys/class/block/sdb/size:28800
  /sys/class/block/sdb1/start:29
  /sys/class/block/sdb1/size:7772
  /sys/class/block/sdb2/start:37801
  /sys/class/block/sdb2/size:7801
  /sys/class/block/sdb3/start:15602
  /sys/class/block/sdb3/size:57801
  /sys/class/block/sdb4/start:23403
  /sys/class/block/sdb4/size:5394

With this patch, we ignore partitions which start behind the end of the disk,
and limit partitions to the end of the disk if they pretend to be larger:
  grep . /sys/class/block/sdb*/{start,size}
  /sys/class/block/sdb/size:28800
  /sys/class/block/sdb1/start:29
  /sys/class/block/sdb1/size:7772
  /sys/class/block/sdb3/start:15602
  /sys/class/block/sdb3/size:13198
  /sys/class/block/sdb4/start:23403
  /sys/class/block/sdb4/size:5394

These warnings are printed to the kernel log:
  sdb: p2 ignored, start 37801 is behind the end of the disk
  sdb: p3 size 57801 limited to end of disk

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 check.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ecc3330..9545d8c 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -498,10 +498,23 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		sector_t from = state->parts[p].from;
 		if (!size)
 			continue;
+		if (from >= get_capacity(disk)) {
+			printk(KERN_WARNING
+			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
+			       disk->disk_name, p, (unsigned long long) from);
+			continue;
+		}
 		if (from + size > get_capacity(disk)) {
+			/*
+			 * we can not ignore partitions of broken tables
+			 * created by for example camera firmware, but we
+			 * limit them to the end of the disk to avoid
+			 * creating invalid block devices
+			 */
 			printk(KERN_WARNING
-				"%s: p%d exceeds device capacity\n",
-				disk->disk_name, p);
+			       "%s: p%d size %llu limited to end of disk\n",
+			       disk->disk_name, p, (unsigned long long) size);
+			size = get_capacity(disk) - from;
 		}
 		res = add_partition(disk, p, from, size, state->parts[p].flags);
 		if (res) {


