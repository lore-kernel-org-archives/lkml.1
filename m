Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZFXGtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZFXGtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZFXGs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:48:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:40003 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZFXGs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:48:58 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix error handling in add_disk
Date: Wed, 24 Jun 2009 12:18:13 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <200906171231.10438.knikanth@suse.de> <20090623142357.b2050c14.akpm@linux-foundation.org>
In-Reply-To: <20090623142357.b2050c14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906241218.13538.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 02:53:57 Andrew Morton wrote:
> On Wed, 17 Jun 2009 12:31:10 +0530
>
> Nikanth Karthikesan <knikanth@suse.de> wrote:
> > Fix error handling in add_disk. Also add WARN_ON()'s in case
> > of error, which can be removed once the callers handle the error.
>
> I have a vague ancestral memory that some of the unchecked errors which
> you're now checking for actually do happen in practice, and that this
> "fix" will end up breaking currently-working setups.
>
> Or maybe I'm thinking of a similar but different piece of code (maybe
> it was the partition code?).
>
> Still, I think it would be prudent to initially make this patch
> continue to ignore the errors.  So add the warnings, but don't change
> the response to errors.  Then we can get the change distributed for a
> bit of testing and if that all looks good then we can add the control
> flow changes later.
>

add_disk and blk_register_region are functions returning void masking the
error, which this patch changes. So no caller check for it's return value! And
hence errors are ignored, and nothing breaks.

> >  	retval = blk_alloc_devt(&disk->part0, &devt);
> >  	if (retval) {
> >  		WARN_ON(1);
> > -		return;
> > +		goto err_out;
> >  	}
> > ...
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto err_free_devt;
> > +	}
> > ...
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto err_free_region;
> > +	}
> > ...
> > -	WARN_ON(retval);
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto err_free_queue;
> > +	}
>
> These all can be coded as
>
> 	if (WARN_ON(retval))
> 		goto foo;

done.

Thanks
Nikanth


Fix error handling in add_disk. Also add WARN_ON()'s in case
of error, which can be removed once the callers handle the error.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/genhd.c b/block/genhd.c
index fe7ccc0..ae48a89 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -472,11 +472,11 @@ static char *bdevt_str(dev_t devt, char *buf)
  * range must be nonzero
  * The hash chain is sorted on range, so that subranges can override.
  */
-void blk_register_region(dev_t devt, unsigned long range, struct module *module,
+int blk_register_region(dev_t devt, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
+	return kobj_map(bdev_map, devt, range, module, probe, lock, data);
 }
 
 EXPORT_SYMBOL(blk_register_region);
@@ -511,9 +511,9 @@ static int exact_lock(dev_t devt, void *data)
  * This function registers the partitioning information in @disk
  * with the kernel.
  *
- * FIXME: error handling
+ * TODO: Remove WARN_ON()'s when all the callers handle the error.
  */
-void add_disk(struct gendisk *disk)
+int add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
 	dev_t devt;
@@ -529,10 +529,9 @@ void add_disk(struct gendisk *disk)
 	disk->flags |= GENHD_FL_UP;
 
 	retval = blk_alloc_devt(&disk->part0, &devt);
-	if (retval) {
-		WARN_ON(1);
-		return;
-	}
+	if (WARN_ON(retval))
+		goto err_out;
+
 	disk_to_dev(disk)->devt = devt;
 
 	/* ->major and ->first_minor aren't supposed to be
@@ -541,16 +540,34 @@ void add_disk(struct gendisk *disk)
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
 
-	blk_register_region(disk_devt(disk), disk->minors, NULL,
+	retval = blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
+	if (WARN_ON(retval))
+		goto err_free_devt;
+
 	register_disk(disk);
-	blk_register_queue(disk);
+
+	retval = blk_register_queue(disk);
+	if (WARN_ON(retval))
+		goto err_free_region;
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
-	WARN_ON(retval);
+	if (WARN_ON(retval))
+		goto err_free_queue;
+
+	return 0;
+
+err_free_queue:
+	blk_unregister_queue(disk);
+err_free_region:
+	blk_unregister_region(disk_devt(disk), disk->minors);
+err_free_devt:
+	blk_free_devt(disk_devt(disk));
+err_out:
+	return retval;
 }
 
 EXPORT_SYMBOL(add_disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 149fda2..df3344a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -339,7 +339,7 @@ static inline void part_dec_in_flight(struct hd_struct *part)
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void add_disk(struct gendisk *disk);
+extern int add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
@@ -534,7 +534,7 @@ extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-extern void blk_register_region(dev_t devt, unsigned long range,
+extern int blk_register_region(dev_t devt, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),
 			int (*lock)(dev_t, void *),

