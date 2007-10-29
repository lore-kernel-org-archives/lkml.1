Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXJ2OZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXJ2OZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXJ2OZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:25:19 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:36030 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXJ2OZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:25:18 -0400
Date: Mon, 29 Oct 2007 07:24:27 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Andries Brouwer <aeb@cwi.nl>, Al Viro <viro@ftp.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071029142427.GA21930@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029140657.09d3a343@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 02:06:57PM +0100, Cornelia Huck wrote:
> On Mon, 29 Oct 2007 05:22:11 -0700,
> Dirk Hohndel <hohndel@linux.intel.com> wrote:
> 
> <only commenting on the kobject part...>
> 
> > @@ -390,20 +390,31 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
> >  	p->kobj.parent = &disk->kobj;
> >  	p->kobj.ktype = &ktype_part;
> >  	kobject_init(&p->kobj);
> > -	kobject_add(&p->kobj);
> > +	if (kobject_add(&p->kobj)) 
> > +		return -1;
> >  	if (!disk->part_uevent_suppress)
> >  		kobject_uevent(&p->kobj, KOBJ_ADD);
> > -	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
> > +	if(sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem")) {
> > +		kobject_del(&p->kobj);
> > +		kfree(p);
> > +		return -1;
> > +	}
> 
> 
> - This is missing a KOBJ_DEL uevent if you did a KOBJ_ADD uevent.

Completely missed that one.

> - Calling kfree() after you already registered the kobject via
>   kobject_add() is wrong, since someone else might already have obtained
>   a reference. You must drop your reference after kobject_del() and let
>   the release mechanism take care of it.

Good point. 

> <I think I'm having some kind of deja vu, since it seems I've already
> pointed that out a couple of times to different people :) >
> 
> >  	if (flags & ADDPART_FLAG_WHOLEDISK) {
> >  		static struct attribute addpartattr = {
> >  			.name = "whole_disk",
> >  			.mode = S_IRUSR | S_IRGRP | S_IROTH,
> >  		};
> > 
> > -		sysfs_create_file(&p->kobj, &addpartattr);
> > +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
> > +			kobject_del(&p->kobj);
> > +			kfree(p);
> > +			return -1;
> > +		}
> 
> Same here. You should probably also delete the link you created above.

Yep, fixed that as well.

How about the new patch below?

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 block/ioctl.c         |    5 ++++-
 fs/partitions/check.c |   28 ++++++++++++++++++++++------
 include/linux/genhd.h |    2 +-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..bb3933e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -61,7 +61,10 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				}
 			}
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			if (add_partition(disk, part, start, length, ADDPART_FLAG_NONE)) {
+				mutex_unlock(&bdev->bd_mutex);
+				return -EBUSY;
+			}
 			mutex_unlock(&bdev->bd_mutex);
 			return 0;
 		case BLKPG_DEL_PARTITION:
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..6bdf855 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -368,13 +368,13 @@ void delete_partition(struct gendisk *disk, int part)
 	kobject_put(&p->kobj);
 }
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		return -1;
 	
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -390,20 +390,33 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	if (kobject_add(&p->kobj)) 
+		return -1;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	if(sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem")) 
+		goto out_cleanup;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		if (sysfs_create_file(&p->kobj, &addpartattr)) {
+			sysfs_remove_link (&p->kobj, "subsystem");
+			goto out_cleanup;
+		}
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
+	
+	return 0;
+
+out_cleanup:
+	if (!disk->part_uevent_suppress)
+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
+	kobject_del(&p->kobj);
+	return -1;
 }
 
 static char *make_block_name(struct gendisk *disk)
@@ -554,8 +567,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		if (from + size > get_capacity(disk)) {
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
+			return -EBUSY;
+		}
+		if(add_partition(disk, p, from, size, state->parts[p].flags)) {
+			return -EBUSY;
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
 #ifdef CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags & ADDPART_FLAG_RAID)
 			md_autodetect_dev(bdev->bd_dev+p);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a47b802..ae6af2c 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -414,7 +414,7 @@ struct unixware_disklabel {
 char *disk_name (struct gendisk *hd, int part, char *buf);
 
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
-extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
+extern int add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
-- 
gitgui.0.8.4.g8d863

