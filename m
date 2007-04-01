Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbXDAERJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbXDAERJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 00:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXDAERJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 00:17:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXDAERH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 00:17:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:references;
	b=GMoQkDKNQK8x6bTbG+yB1IpNv1Q9wZEjjCvkfZd168G/c13lv/Mn+aYaUQXgCNM8O
	bquC6rKqajw7J82A1XNaA==
Message-ID: <b040c32a0703312116y56bad12h9d370a8a2c99b245@mail.gmail.com>
Date: Sat, 31 Mar 2007 21:16:53 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] remove artificial software max_loop limit
Cc: "Greg KH" <greg@kroah.com>, "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070331104144.46c85f27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_82688_23044893.1175401013085"
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	 <20070330141524.5f6cff29.akpm@linux-foundation.org>
	 <20070331170743.GB14596@kroah.com>
	 <20070331104144.46c85f27.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_82688_23044893.1175401013085
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 3/31/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Yes, the distros do, and they recommend it to their users a lot.
>
> Thanks.  In that case I think we should retain the max_loop module parameter
> for now.
>
> Ken, when you respin that patch could you restore max_loop, and make its
> use trigger a warning along the lines of "loop: the max_loop option is obsolete
> and will be removed in March 2008"?

OK, here is a re-spin patch that I tested as module or
link-in-vmlinux.  Both produce satisfactory result for me.  I also
enclosed the patch as an attachment just in case my email client
decide to eat away white spaces for the in-line text.

------------------------------------------------------
Subject: remove artificial software max_loop limit
From: "Ken Chen" <kenchen@google.com>

Remove artificial maximum 256 loop device that can be created due to a
legacy device number limit.  Searching through lkml archive, there are
several instances where users complained about the artificial limit
that the loop driver impose.  There is no reason to have such limit.

This patch rid the limit entirely and make loop device and associated
block queue instantiation on demand.  With on-demand instantiation, it
also gives the benefit of not wasting memory if these devices are not
in use (compare to current implementation that always create 8 loop
devices), a net improvement in both areas.  This version is both
tested with creation of large number of loop devices and is compatible
with existing losetup/mount user land tools.

There are a number of people who worked on this and provided valuable
suggestions, in no particular order, by:

Jens Axboe
Jan Engelhardt
Christoph Hellwig
Thomas M

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6b5b642..605c1d3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -77,9 +77,8 @@

 #include <asm/uaccess.h>

-static int max_loop = 8;
-static struct loop_device *loop_dev;
-static struct gendisk **disks;
+static LIST_HEAD(loop_devices);
+static DEFINE_MUTEX(loop_devices_mutex);

 /*
  * Transfer functions
@@ -183,7 +182,7 @@ figure_loop_size(struct loop_device *lo)
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;

-	set_capacity(disks[lo->lo_number], x);
+	set_capacity(lo->lo_disk, x);
 	return 0;					
 }

@@ -812,7 +811,7 @@ static int loop_set_fd
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;

-	set_capacity(disks[lo->lo_number], size);
+	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);

 	set_blocksize(bdev, lo_blocksize);
@@ -832,7 +831,7 @@ out_clr:
 	lo->lo_device = NULL;
 	lo->lo_backing_file = NULL;
 	lo->lo_flags = 0;
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	invalidate_bdev(bdev, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
@@ -918,7 +917,7 @@ static int loop_clr_fd
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 	invalidate_bdev(bdev, 0);
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
@@ -1322,6 +1321,18 @@ static long lo_compat_ioctl
 }
 #endif

+static struct loop_device *loop_find_dev(int number)
+{
+	struct loop_device *lo;
+
+	list_for_each_entry(lo, &loop_devices, lo_list) {
+		if (lo->lo_number == number)
+			return lo;
+	}
+	return NULL;
+}
+
+static struct loop_device *loop_init_one(int i);
 static int lo_open(struct inode *inode, struct file *file)
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
@@ -1330,6 +1341,11 @@ static int lo_open
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);

+	mutex_lock(&loop_devices_mutex);
+	if (!loop_find_dev(lo->lo_number + 1))
+		loop_init_one(lo->lo_number + 1);
+	mutex_unlock(&loop_devices_mutex);
+
 	return 0;
 }

@@ -1357,8 +1373,9 @@ static struct block_device_operations lo_fops = {
 /*
  * And now the modules code and kernel interface.
  */
+static int max_loop;
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
+MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);

@@ -1383,7 +1400,7 @@ int loop_unregister_transfer(int number)

 	xfer_funcs[n] = NULL;

-	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
+	list_for_each_entry(lo, &loop_devices, lo_list) {
 		mutex_lock(&lo->lo_ctl_mutex);

 		if (lo->lo_encryption == xfer)
@@ -1398,91 +1415,110 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);

-static int __init loop_init(void)
+static struct loop_device *loop_init_one(int i)
+{
+	struct loop_device *lo;
+	struct gendisk *disk;
+
+	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
+	if (!lo)
+		goto out;
+
+	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!lo->lo_queue)
+		goto out_free_dev;
+
+	disk = lo->lo_disk = alloc_disk(1);
+	if (!disk)
+		goto out_free_queue;
+
+	mutex_init(&lo->lo_ctl_mutex);
+	lo->lo_number		= i;
+	lo->lo_thread		= NULL;
+	init_waitqueue_head(&lo->lo_event);
+	spin_lock_init(&lo->lo_lock);
+	disk->major		= LOOP_MAJOR;
+	disk->first_minor	= i;
+	disk->fops		= &lo_fops;
+	disk->private_data	= lo;
+	disk->queue		= lo->lo_queue;
+	sprintf(disk->disk_name, "loop%d", i);
+	add_disk(disk);
+	list_add_tail(&lo->lo_list, &loop_devices);
+	return lo;
+
+out_free_queue:
+	blk_cleanup_queue(lo->lo_queue);
+out_free_dev:
+	kfree(lo);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+static void loop_del_one(struct loop_device *lo)
 {
-	int	i;
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	put_disk(lo->lo_disk);
+	list_del(&lo->lo_list);
+	kfree(lo);
+}

-	if (max_loop < 1 || max_loop > 256) {
-		printk(KERN_WARNING "loop: invalid max_loop (must be between"
-				    " 1 and 256), using default (8)\n");
-		max_loop = 8;
-	}
+static struct kobject *loop_probe(dev_t dev, int *part, void *data)
+{
+	unsigned int number = dev & MINORMASK;
+	struct loop_device *lo;
+
+	mutex_lock(&loop_devices_mutex);
+	lo = loop_find_dev(number);
+	if (lo == NULL)
+		lo = loop_init_one(number);
+	mutex_unlock(&loop_devices_mutex);
+
+	*part = 0;
+	if (IS_ERR(lo))
+		return (void *)lo;
+	else
+		return &lo->lo_disk->kobj;
+}
+
+static int __init loop_init(void)
+{
+	struct loop_device *lo;

 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
+				  THIS_MODULE, loop_probe, NULL, NULL);

-	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
-	if (!loop_dev)
-		goto out_mem1;
-	memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
+	lo = loop_init_one(0);
+	if (IS_ERR(lo))
+		goto out;

-	disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
-	if (!disks)
-		goto out_mem2;
+	if (max_loop) {
+		printk(KERN_INFO "loop: the max_loop option is obsolete "
+				 "and will be removed in March 2008\n");

-	for (i = 0; i < max_loop; i++) {
-		disks[i] = alloc_disk(1);
-		if (!disks[i])
-			goto out_mem3;
 	}
-
-	for (i = 0; i < max_loop; i++) {
-		struct loop_device *lo = &loop_dev[i];
-		struct gendisk *disk = disks[i];
-
-		memset(lo, 0, sizeof(*lo));
-		lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-		if (!lo->lo_queue)
-			goto out_mem4;
-		mutex_init(&lo->lo_ctl_mutex);
-		lo->lo_number = i;
-		lo->lo_thread = NULL;
-		init_waitqueue_head(&lo->lo_event);
-		spin_lock_init(&lo->lo_lock);
-		disk->major = LOOP_MAJOR;
-		disk->first_minor = i;
-		disk->fops = &lo_fops;
-		sprintf(disk->disk_name, "loop%d", i);
-		disk->private_data = lo;
-		disk->queue = lo->lo_queue;
-	}
-
-	/* We cannot fail after we call this, so another loop!*/
-	for (i = 0; i < max_loop; i++)
-		add_disk(disks[i]);
-	printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
+	printk(KERN_INFO "loop: module loaded\n");
 	return 0;

-out_mem4:
-	while (i--)
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-	i = max_loop;
-out_mem3:
-	while (i--)
-		put_disk(disks[i]);
-	kfree(disks);
-out_mem2:
-	kfree(loop_dev);
-out_mem1:
+out:
 	unregister_blkdev(LOOP_MAJOR, "loop");
 	printk(KERN_ERR "loop: ran out of memory\n");
 	return -ENOMEM;
 }

-static void loop_exit(void)
+static void __exit loop_exit(void)
 {
-	int i;
+	struct loop_device *lo, *next;

-	for (i = 0; i < max_loop; i++) {
-		del_gendisk(disks[i]);
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-		put_disk(disks[i]);
-	}
+	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
+		loop_del_one(lo);
+
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
-
-	kfree(disks);
-	kfree(loop_dev);
 }

 module_init(loop_init);
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 191a595..0b99b31 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -64,6 +64,8 @@ struct loop_device {
 	wait_queue_head_t	lo_event;

 	request_queue_t		*lo_queue;
+	struct gendisk		*lo_disk;
+	struct list_head	lo_list;
 };

 #endif /* __KERNEL__ */

------=_Part_82688_23044893.1175401013085
Content-Type: text/x-patch; name=loop-0331.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ezyzahkj
Content-Disposition: attachment; filename="loop-0331.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbG9vcC5jIGIvZHJpdmVycy9ibG9jay9sb29wLmMK
aW5kZXggNmI1YjY0Mi4uNjA1YzFkMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9sb29wLmMK
KysrIGIvZHJpdmVycy9ibG9jay9sb29wLmMKQEAgLTc3LDkgKzc3LDggQEAKIAogI2luY2x1ZGUg
PGFzbS91YWNjZXNzLmg+CiAKLXN0YXRpYyBpbnQgbWF4X2xvb3AgPSA4Owotc3RhdGljIHN0cnVj
dCBsb29wX2RldmljZSAqbG9vcF9kZXY7Ci1zdGF0aWMgc3RydWN0IGdlbmRpc2sgKipkaXNrczsK
K3N0YXRpYyBMSVNUX0hFQUQobG9vcF9kZXZpY2VzKTsKK3N0YXRpYyBERUZJTkVfTVVURVgobG9v
cF9kZXZpY2VzX211dGV4KTsKIAogLyoKICAqIFRyYW5zZmVyIGZ1bmN0aW9ucwpAQCAtMTgzLDcg
KzE4Miw3IEBAIGZpZ3VyZV9sb29wX3NpemUoc3RydWN0IGxvb3BfZGV2aWNlICpsbykKIAlpZiAo
dW5saWtlbHkoKGxvZmZfdCl4ICE9IHNpemUpKQogCQlyZXR1cm4gLUVGQklHOwogCi0Jc2V0X2Nh
cGFjaXR5KGRpc2tzW2xvLT5sb19udW1iZXJdLCB4KTsKKwlzZXRfY2FwYWNpdHkobG8tPmxvX2Rp
c2ssIHgpOwogCXJldHVybiAwOwkJCQkJCiB9CiAKQEAgLTgxMiw3ICs4MTEsNyBAQCBzdGF0aWMg
aW50IGxvb3Bfc2V0X2ZkCiAJbG8tPmxvX3F1ZXVlLT5xdWV1ZWRhdGEgPSBsbzsKIAlsby0+bG9f
cXVldWUtPnVucGx1Z19mbiA9IGxvb3BfdW5wbHVnOwogCi0Jc2V0X2NhcGFjaXR5KGRpc2tzW2xv
LT5sb19udW1iZXJdLCBzaXplKTsKKwlzZXRfY2FwYWNpdHkobG8tPmxvX2Rpc2ssIHNpemUpOwog
CWJkX3NldF9zaXplKGJkZXYsIHNpemUgPDwgOSk7CiAKIAlzZXRfYmxvY2tzaXplKGJkZXYsIGxv
X2Jsb2Nrc2l6ZSk7CkBAIC04MzIsNyArODMxLDcgQEAgb3V0X2NscjoKIAlsby0+bG9fZGV2aWNl
ID0gTlVMTDsKIAlsby0+bG9fYmFja2luZ19maWxlID0gTlVMTDsKIAlsby0+bG9fZmxhZ3MgPSAw
OwotCXNldF9jYXBhY2l0eShkaXNrc1tsby0+bG9fbnVtYmVyXSwgMCk7CisJc2V0X2NhcGFjaXR5
KGxvLT5sb19kaXNrLCAwKTsKIAlpbnZhbGlkYXRlX2JkZXYoYmRldiwgMCk7CiAJYmRfc2V0X3Np
emUoYmRldiwgMCk7CiAJbWFwcGluZ19zZXRfZ2ZwX21hc2sobWFwcGluZywgbG8tPm9sZF9nZnBf
bWFzayk7CkBAIC05MTgsNyArOTE3LDcgQEAgc3RhdGljIGludCBsb29wX2Nscl9mZAogCW1lbXNl
dChsby0+bG9fY3J5cHRfbmFtZSwgMCwgTE9fTkFNRV9TSVpFKTsKIAltZW1zZXQobG8tPmxvX2Zp
bGVfbmFtZSwgMCwgTE9fTkFNRV9TSVpFKTsKIAlpbnZhbGlkYXRlX2JkZXYoYmRldiwgMCk7Ci0J
c2V0X2NhcGFjaXR5KGRpc2tzW2xvLT5sb19udW1iZXJdLCAwKTsKKwlzZXRfY2FwYWNpdHkobG8t
PmxvX2Rpc2ssIDApOwogCWJkX3NldF9zaXplKGJkZXYsIDApOwogCW1hcHBpbmdfc2V0X2dmcF9t
YXNrKGZpbHAtPmZfbWFwcGluZywgZ2ZwKTsKIAlsby0+bG9fc3RhdGUgPSBMb191bmJvdW5kOwpA
QCAtMTMyMiw2ICsxMzIxLDE4IEBAIHN0YXRpYyBsb25nIGxvX2NvbXBhdF9pb2N0bAogfQogI2Vu
ZGlmCiAKK3N0YXRpYyBzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvb3BfZmluZF9kZXYoaW50IG51bWJl
cikKK3sKKwlzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShs
bywgJmxvb3BfZGV2aWNlcywgbG9fbGlzdCkgeworCQlpZiAobG8tPmxvX251bWJlciA9PSBudW1i
ZXIpCisJCQlyZXR1cm4gbG87CisJfQorCXJldHVybiBOVUxMOworfQorCitzdGF0aWMgc3RydWN0
IGxvb3BfZGV2aWNlICpsb29wX2luaXRfb25lKGludCBpKTsKIHN0YXRpYyBpbnQgbG9fb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIHsKIAlzdHJ1Y3QgbG9vcF9k
ZXZpY2UgKmxvID0gaW5vZGUtPmlfYmRldi0+YmRfZGlzay0+cHJpdmF0ZV9kYXRhOwpAQCAtMTMz
MCw2ICsxMzQxLDExIEBAIHN0YXRpYyBpbnQgbG9fb3BlbgogCWxvLT5sb19yZWZjbnQrKzsKIAlt
dXRleF91bmxvY2soJmxvLT5sb19jdGxfbXV0ZXgpOwogCisJbXV0ZXhfbG9jaygmbG9vcF9kZXZp
Y2VzX211dGV4KTsKKwlpZiAoIWxvb3BfZmluZF9kZXYobG8tPmxvX251bWJlciArIDEpKQorCQls
b29wX2luaXRfb25lKGxvLT5sb19udW1iZXIgKyAxKTsKKwltdXRleF91bmxvY2soJmxvb3BfZGV2
aWNlc19tdXRleCk7CisKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTM1Nyw4ICsxMzczLDkgQEAgc3Rh
dGljIHN0cnVjdCBibG9ja19kZXZpY2Vfb3BlcmF0aW9ucyBsb19mb3BzID0gewogLyoKICAqIEFu
ZCBub3cgdGhlIG1vZHVsZXMgY29kZSBhbmQga2VybmVsIGludGVyZmFjZS4KICAqLworc3RhdGlj
IGludCBtYXhfbG9vcDsKIG1vZHVsZV9wYXJhbShtYXhfbG9vcCwgaW50LCAwKTsKLU1PRFVMRV9Q
QVJNX0RFU0MobWF4X2xvb3AsICJNYXhpbXVtIG51bWJlciBvZiBsb29wIGRldmljZXMgKDEtMjU2
KSIpOworTU9EVUxFX1BBUk1fREVTQyhtYXhfbG9vcCwgIm9ic29sZXRlLCBsb29wIGRldmljZSBp
cyBjcmVhdGVkIG9uLWRlbWFuZCIpOwogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogTU9EVUxFX0FM
SUFTX0JMT0NLREVWX01BSk9SKExPT1BfTUFKT1IpOwogCkBAIC0xMzgzLDcgKzE0MDAsNyBAQCBp
bnQgbG9vcF91bnJlZ2lzdGVyX3RyYW5zZmVyKGludCBudW1iZXIpCiAKIAl4ZmVyX2Z1bmNzW25d
ID0gTlVMTDsKIAotCWZvciAobG8gPSAmbG9vcF9kZXZbMF07IGxvIDwgJmxvb3BfZGV2W21heF9s
b29wXTsgbG8rKykgeworCWxpc3RfZm9yX2VhY2hfZW50cnkobG8sICZsb29wX2RldmljZXMsIGxv
X2xpc3QpIHsKIAkJbXV0ZXhfbG9jaygmbG8tPmxvX2N0bF9tdXRleCk7CiAKIAkJaWYgKGxvLT5s
b19lbmNyeXB0aW9uID09IHhmZXIpCkBAIC0xMzk4LDkxICsxNDE1LDExMCBAQCBpbnQgbG9vcF91
bnJlZ2lzdGVyX3RyYW5zZmVyKGludCBudW1iZXIpCiBFWFBPUlRfU1lNQk9MKGxvb3BfcmVnaXN0
ZXJfdHJhbnNmZXIpOwogRVhQT1JUX1NZTUJPTChsb29wX3VucmVnaXN0ZXJfdHJhbnNmZXIpOwog
Ci1zdGF0aWMgaW50IF9faW5pdCBsb29wX2luaXQodm9pZCkKK3N0YXRpYyBzdHJ1Y3QgbG9vcF9k
ZXZpY2UgKmxvb3BfaW5pdF9vbmUoaW50IGkpCit7CisJc3RydWN0IGxvb3BfZGV2aWNlICpsbzsK
KwlzdHJ1Y3QgZ2VuZGlzayAqZGlzazsKKworCWxvID0ga3phbGxvYyhzaXplb2YoKmxvKSwgR0ZQ
X0tFUk5FTCk7CisJaWYgKCFsbykKKwkJZ290byBvdXQ7CisKKwlsby0+bG9fcXVldWUgPSBibGtf
YWxsb2NfcXVldWUoR0ZQX0tFUk5FTCk7CisJaWYgKCFsby0+bG9fcXVldWUpCisJCWdvdG8gb3V0
X2ZyZWVfZGV2OworCisJZGlzayA9IGxvLT5sb19kaXNrID0gYWxsb2NfZGlzaygxKTsKKwlpZiAo
IWRpc2spCisJCWdvdG8gb3V0X2ZyZWVfcXVldWU7CisKKwltdXRleF9pbml0KCZsby0+bG9fY3Rs
X211dGV4KTsKKwlsby0+bG9fbnVtYmVyCQk9IGk7CisJbG8tPmxvX3RocmVhZAkJPSBOVUxMOwor
CWluaXRfd2FpdHF1ZXVlX2hlYWQoJmxvLT5sb19ldmVudCk7CisJc3Bpbl9sb2NrX2luaXQoJmxv
LT5sb19sb2NrKTsKKwlkaXNrLT5tYWpvcgkJPSBMT09QX01BSk9SOworCWRpc2stPmZpcnN0X21p
bm9yCT0gaTsKKwlkaXNrLT5mb3BzCQk9ICZsb19mb3BzOworCWRpc2stPnByaXZhdGVfZGF0YQk9
IGxvOworCWRpc2stPnF1ZXVlCQk9IGxvLT5sb19xdWV1ZTsKKwlzcHJpbnRmKGRpc2stPmRpc2tf
bmFtZSwgImxvb3AlZCIsIGkpOworCWFkZF9kaXNrKGRpc2spOworCWxpc3RfYWRkX3RhaWwoJmxv
LT5sb19saXN0LCAmbG9vcF9kZXZpY2VzKTsKKwlyZXR1cm4gbG87CisKK291dF9mcmVlX3F1ZXVl
OgorCWJsa19jbGVhbnVwX3F1ZXVlKGxvLT5sb19xdWV1ZSk7CitvdXRfZnJlZV9kZXY6CisJa2Zy
ZWUobG8pOworb3V0OgorCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOworfQorCitzdGF0aWMgdm9p
ZCBsb29wX2RlbF9vbmUoc3RydWN0IGxvb3BfZGV2aWNlICpsbykKIHsKLQlpbnQJaTsKKwlkZWxf
Z2VuZGlzayhsby0+bG9fZGlzayk7CisJYmxrX2NsZWFudXBfcXVldWUobG8tPmxvX3F1ZXVlKTsK
KwlwdXRfZGlzayhsby0+bG9fZGlzayk7CisJbGlzdF9kZWwoJmxvLT5sb19saXN0KTsKKwlrZnJl
ZShsbyk7Cit9CiAKLQlpZiAobWF4X2xvb3AgPCAxIHx8IG1heF9sb29wID4gMjU2KSB7Ci0JCXBy
aW50ayhLRVJOX1dBUk5JTkcgImxvb3A6IGludmFsaWQgbWF4X2xvb3AgKG11c3QgYmUgYmV0d2Vl
biIKLQkJCQkgICAgIiAxIGFuZCAyNTYpLCB1c2luZyBkZWZhdWx0ICg4KVxuIik7Ci0JCW1heF9s
b29wID0gODsKLQl9CitzdGF0aWMgc3RydWN0IGtvYmplY3QgKmxvb3BfcHJvYmUoZGV2X3QgZGV2
LCBpbnQgKnBhcnQsIHZvaWQgKmRhdGEpCit7CisJdW5zaWduZWQgaW50IG51bWJlciA9IGRldiAm
IE1JTk9STUFTSzsKKwlzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvOworCisJbXV0ZXhfbG9jaygmbG9v
cF9kZXZpY2VzX211dGV4KTsKKwlsbyA9IGxvb3BfZmluZF9kZXYobnVtYmVyKTsKKwlpZiAobG8g
PT0gTlVMTCkKKwkJbG8gPSBsb29wX2luaXRfb25lKG51bWJlcik7CisJbXV0ZXhfdW5sb2NrKCZs
b29wX2RldmljZXNfbXV0ZXgpOworCisJKnBhcnQgPSAwOworCWlmIChJU19FUlIobG8pKQorCQly
ZXR1cm4gKHZvaWQgKilsbzsKKwllbHNlCisJCXJldHVybiAmbG8tPmxvX2Rpc2stPmtvYmo7Cit9
CisKK3N0YXRpYyBpbnQgX19pbml0IGxvb3BfaW5pdCh2b2lkKQoreworCXN0cnVjdCBsb29wX2Rl
dmljZSAqbG87CiAKIAlpZiAocmVnaXN0ZXJfYmxrZGV2KExPT1BfTUFKT1IsICJsb29wIikpCiAJ
CXJldHVybiAtRUlPOworCWJsa19yZWdpc3Rlcl9yZWdpb24oTUtERVYoTE9PUF9NQUpPUiwgMCks
IDFVTCA8PCBNSU5PUkJJVFMsCisJCQkJICBUSElTX01PRFVMRSwgbG9vcF9wcm9iZSwgTlVMTCwg
TlVMTCk7CiAKLQlsb29wX2RldiA9IGttYWxsb2MobWF4X2xvb3AgKiBzaXplb2Yoc3RydWN0IGxv
b3BfZGV2aWNlKSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFsb29wX2RldikKLQkJZ290byBvdXRfbWVt
MTsKLQltZW1zZXQobG9vcF9kZXYsIDAsIG1heF9sb29wICogc2l6ZW9mKHN0cnVjdCBsb29wX2Rl
dmljZSkpOworCWxvID0gbG9vcF9pbml0X29uZSgwKTsKKwlpZiAoSVNfRVJSKGxvKSkKKwkJZ290
byBvdXQ7CiAKLQlkaXNrcyA9IGttYWxsb2MobWF4X2xvb3AgKiBzaXplb2Yoc3RydWN0IGdlbmRp
c2sgKiksIEdGUF9LRVJORUwpOwotCWlmICghZGlza3MpCi0JCWdvdG8gb3V0X21lbTI7CisJaWYg
KG1heF9sb29wKSB7CisJCXByaW50ayhLRVJOX0lORk8gImxvb3A6IHRoZSBtYXhfbG9vcCBvcHRp
b24gaXMgb2Jzb2xldGUgIgorCQkJCSAiYW5kIHdpbGwgYmUgcmVtb3ZlZCBpbiBNYXJjaCAyMDA4
XG4iKTsKIAotCWZvciAoaSA9IDA7IGkgPCBtYXhfbG9vcDsgaSsrKSB7Ci0JCWRpc2tzW2ldID0g
YWxsb2NfZGlzaygxKTsKLQkJaWYgKCFkaXNrc1tpXSkKLQkJCWdvdG8gb3V0X21lbTM7CiAJfQot
Ci0JZm9yIChpID0gMDsgaSA8IG1heF9sb29wOyBpKyspIHsKLQkJc3RydWN0IGxvb3BfZGV2aWNl
ICpsbyA9ICZsb29wX2RldltpXTsKLQkJc3RydWN0IGdlbmRpc2sgKmRpc2sgPSBkaXNrc1tpXTsK
LQotCQltZW1zZXQobG8sIDAsIHNpemVvZigqbG8pKTsKLQkJbG8tPmxvX3F1ZXVlID0gYmxrX2Fs
bG9jX3F1ZXVlKEdGUF9LRVJORUwpOwotCQlpZiAoIWxvLT5sb19xdWV1ZSkKLQkJCWdvdG8gb3V0
X21lbTQ7Ci0JCW11dGV4X2luaXQoJmxvLT5sb19jdGxfbXV0ZXgpOwotCQlsby0+bG9fbnVtYmVy
ID0gaTsKLQkJbG8tPmxvX3RocmVhZCA9IE5VTEw7Ci0JCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmxv
LT5sb19ldmVudCk7Ci0JCXNwaW5fbG9ja19pbml0KCZsby0+bG9fbG9jayk7Ci0JCWRpc2stPm1h
am9yID0gTE9PUF9NQUpPUjsKLQkJZGlzay0+Zmlyc3RfbWlub3IgPSBpOwotCQlkaXNrLT5mb3Bz
ID0gJmxvX2ZvcHM7Ci0JCXNwcmludGYoZGlzay0+ZGlza19uYW1lLCAibG9vcCVkIiwgaSk7Ci0J
CWRpc2stPnByaXZhdGVfZGF0YSA9IGxvOwotCQlkaXNrLT5xdWV1ZSA9IGxvLT5sb19xdWV1ZTsK
LQl9Ci0KLQkvKiBXZSBjYW5ub3QgZmFpbCBhZnRlciB3ZSBjYWxsIHRoaXMsIHNvIGFub3RoZXIg
bG9vcCEqLwotCWZvciAoaSA9IDA7IGkgPCBtYXhfbG9vcDsgaSsrKQotCQlhZGRfZGlzayhkaXNr
c1tpXSk7Ci0JcHJpbnRrKEtFUk5fSU5GTyAibG9vcDogbG9hZGVkIChtYXggJWQgZGV2aWNlcylc
biIsIG1heF9sb29wKTsKKwlwcmludGsoS0VSTl9JTkZPICJsb29wOiBtb2R1bGUgbG9hZGVkXG4i
KTsKIAlyZXR1cm4gMDsKIAotb3V0X21lbTQ6Ci0Jd2hpbGUgKGktLSkKLQkJYmxrX2NsZWFudXBf
cXVldWUobG9vcF9kZXZbaV0ubG9fcXVldWUpOwotCWkgPSBtYXhfbG9vcDsKLW91dF9tZW0zOgot
CXdoaWxlIChpLS0pCi0JCXB1dF9kaXNrKGRpc2tzW2ldKTsKLQlrZnJlZShkaXNrcyk7Ci1vdXRf
bWVtMjoKLQlrZnJlZShsb29wX2Rldik7Ci1vdXRfbWVtMToKK291dDoKIAl1bnJlZ2lzdGVyX2Js
a2RldihMT09QX01BSk9SLCAibG9vcCIpOwogCXByaW50ayhLRVJOX0VSUiAibG9vcDogcmFuIG91
dCBvZiBtZW1vcnlcbiIpOwogCXJldHVybiAtRU5PTUVNOwogfQogCi1zdGF0aWMgdm9pZCBsb29w
X2V4aXQodm9pZCkKK3N0YXRpYyB2b2lkIF9fZXhpdCBsb29wX2V4aXQodm9pZCkKIHsKLQlpbnQg
aTsKKwlzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvLCAqbmV4dDsKIAotCWZvciAoaSA9IDA7IGkgPCBt
YXhfbG9vcDsgaSsrKSB7Ci0JCWRlbF9nZW5kaXNrKGRpc2tzW2ldKTsKLQkJYmxrX2NsZWFudXBf
cXVldWUobG9vcF9kZXZbaV0ubG9fcXVldWUpOwotCQlwdXRfZGlzayhkaXNrc1tpXSk7Ci0JfQor
CWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShsbywgbmV4dCwgJmxvb3BfZGV2aWNlcywgbG9fbGlz
dCkKKwkJbG9vcF9kZWxfb25lKGxvKTsKKworCWJsa191bnJlZ2lzdGVyX3JlZ2lvbihNS0RFVihM
T09QX01BSk9SLCAwKSwgMVVMIDw8IE1JTk9SQklUUyk7CiAJaWYgKHVucmVnaXN0ZXJfYmxrZGV2
KExPT1BfTUFKT1IsICJsb29wIikpCiAJCXByaW50ayhLRVJOX1dBUk5JTkcgImxvb3A6IGNhbm5v
dCB1bnJlZ2lzdGVyIGJsa2RldlxuIik7Ci0KLQlrZnJlZShkaXNrcyk7Ci0Ja2ZyZWUobG9vcF9k
ZXYpOwogfQogCiBtb2R1bGVfaW5pdChsb29wX2luaXQpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aW51eC9sb29wLmggYi9pbmNsdWRlL2xpbnV4L2xvb3AuaAppbmRleCAxOTFhNTk1Li4wYjk5YjMx
IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2xvb3AuaAorKysgYi9pbmNsdWRlL2xpbnV4L2xv
b3AuaApAQCAtNjQsNiArNjQsOCBAQCBzdHJ1Y3QgbG9vcF9kZXZpY2UgewogCXdhaXRfcXVldWVf
aGVhZF90CWxvX2V2ZW50OwogCiAJcmVxdWVzdF9xdWV1ZV90CQkqbG9fcXVldWU7CisJc3RydWN0
IGdlbmRpc2sJCSpsb19kaXNrOworCXN0cnVjdCBsaXN0X2hlYWQJbG9fbGlzdDsKIH07CiAKICNl
bmRpZiAvKiBfX0tFUk5FTF9fICovCg==
------=_Part_82688_23044893.1175401013085--
