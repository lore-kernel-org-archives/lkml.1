Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXJ3W5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXJ3W5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJ3W5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:57:06 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:40434 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbXJ3W5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:57:05 -0400
Date: Tue, 30 Oct 2007 15:56:35 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071030225635.GA3401@linux.intel.com>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org> <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com> <20071030165608.GA2601@linux.intel.com> <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 06:31:12PM +0100, Cornelia Huck wrote:
> On Tue, 30 Oct 2007 09:56:08 -0700,
> Dirk Hohndel <hohndel@linux.intel.com> wrote:
> 
> > > > IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> > > > the correct return values, the patch then looks fine to me.

So Al, are you ok with this one?

> > > We need some kind of check concerning the kobject to avoid mysterious
> > > errors (especially checking for the failed kobject_add() is needed).
> > > Whether we want just to inform the user of the failure instead of
> > > failing the function is another question.
> > 
> > What are you suggesting? I'd love to make the behaviour consistent everywhere
> > (and am willing to go through things in order to make that happen), but what is
> > the consistent behaviour that we'd want?
> 
> I'd be fine with just propagating the error after cleanup (that is what
> for example the driver core usually does), but I don't know the
> surrounding code well enough for a definitive answer.

Ok, I think I have it consistent now. I also ran it through checkpatch.pl :-)

/D


[FILESYSTEM] add_partition ignores errors

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 block/ioctl.c         |    9 +++++++--
 fs/partitions/check.c |   36 +++++++++++++++++++++++++++++-------
 include/linux/genhd.h |    2 +-
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..662ec18 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -16,7 +16,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	struct blkpg_partition p;
 	long long start, length;
 	int part;
-	int i;
+	int i, err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -61,7 +61,12 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 				}
 			}
 			/* all seems OK */
-			add_partition(disk, part, start, length, ADDPART_FLAG_NONE);
+			err = add_partition(disk, part, start, length,
+						ADDPART_FLAG_NONE)
+			if (err) {
+				mutex_unlock(&bdev->bd_mutex);
+				return err;
+			}
 			mutex_unlock(&bdev->bd_mutex);
 			return 0;
 		case BLKPG_DEL_PARTITION:
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..dea79bd 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -368,13 +368,14 @@ void delete_partition(struct gendisk *disk, int part)
 	kobject_put(&p->kobj);
 }
 
-void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
+int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err = 0;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
-		return;
+		return -ENOMEM;
 	
 	p->start_sect = start;
 	p->nr_sects = len;
@@ -390,20 +391,38 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	err = kobject_add(&p->kobj);
+	if (err)
+		goto out_put;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	err = sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	if (err)
+		goto out_cleanup;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		err = sysfs_create_file(&p->kobj, &addpartattr);
+		if (err) {
+			sysfs_remove_link(&p->kobj, "subsystem");
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
+out_put:
+	kobject_put(&p->kobj);
+	return err;
 }
 
 static char *make_block_name(struct gendisk *disk)
@@ -530,7 +549,7 @@ exit:
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
-	int p, res;
+	int p, res, err;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
@@ -554,8 +573,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		if (from + size > get_capacity(disk)) {
 			printk(" %s: p%d exceeds device capacity\n",
 				disk->disk_name, p);
+			return -EBUSY;
 		}
-		add_partition(disk, p, from, size, state->parts[p].flags);
+		err = add_partition(disk, p, from, size, state->parts[p].flags);
+		if (err)
+			return err;
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

