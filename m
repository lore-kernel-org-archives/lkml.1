Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbXFAQ3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbXFAQ3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbXFAQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:29:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbXFAQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:29:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lxrPDOPsB0QRNLvc43+vuvKSW00j3V8Pm2kg7iu4X4yalH+gYf+hntD7lNjPT7aBt
	1FgH2vlJIvgtoPh2ZGL4A==
Message-ID: <b040c32a0706010929o6cf3af8ata6afd61ddb6065b@mail.gmail.com>
Date: Fri, 1 Jun 2007 09:29:17 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Cc: walt <wa1ter@myrealbox.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070531113456.baec62c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net>
	 <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
	 <20070522014822.GF4095@ftp.linux.org.uk>
	 <b040c32a0705211914w3843bd46o542476be97e0b6cf@mail.gmail.com>
	 <b040c32a0705211940xe7cdf1cnb2c882edacc17a27@mail.gmail.com>
	 <f3mro0$u8p$1@sea.gmane.org>
	 <b040c32a0705310951t7d9acdf5n34815bc5fc156e26@mail.gmail.com>
	 <20070531111052.534573b8.akpm@linux-foundation.org>
	 <b040c32a0705311123i518ab280j88cb4675ea97b315@mail.gmail.com>
	 <20070531113456.baec62c3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Could you please send a fresh, shiny, new, changelogged patch against mainline?

OK, here it is.  It would be nice to merge this before final 2.6.22
release.  Thank you.


The kernel on-demand loop device instantiation breaks several user space
tools as the tools are not ready to cope with the "on-demand feature".  Fix
it by instantiate default 8 loop devices and also reinstate max_loop module
parameter.


Signed-off-by: Ken Chen <kenchen@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>


diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5526ead..0ed5470 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1354,7 +1354,7 @@ #endif
  */
 static int max_loop;
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);

@@ -1394,16 +1394,11 @@ int loop_unregister_transfer
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);

-static struct loop_device *loop_init_one(int i)
+static struct loop_device *loop_alloc(int i)
 {
 	struct loop_device *lo;
 	struct gendisk *disk;

-	list_for_each_entry(lo, &loop_devices, lo_list) {
-		if (lo->lo_number == i)
-			return lo;
-	}
-
 	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
 	if (!lo)
 		goto out;
@@ -1427,8 +1422,6 @@ static struct loop_device *loop_init_one
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
-	add_disk(disk);
-	list_add_tail(&lo->lo_list, &loop_devices);
 	return lo;

 out_free_queue:
@@ -1439,15 +1432,37 @@ out:
 	return NULL;
 }

-static void loop_del_one(struct loop_device *lo)
+static void loop_free(struct loop_device *lo)
 {
-	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	list_del(&lo->lo_list);
 	kfree(lo);
 }

+static struct loop_device *loop_init_one(int i)
+{
+	struct loop_device *lo;
+
+	list_for_each_entry(lo, &loop_devices, lo_list) {
+		if (lo->lo_number == i)
+			return lo;
+	}
+
+	lo = loop_alloc(i);
+	if (lo) {
+		add_disk(lo->lo_disk);
+		list_add_tail(&lo->lo_list, &loop_devices);
+	}
+	return lo;
+}
+
+static void loop_del_one(struct loop_device *lo)
+{
+	del_gendisk(lo->lo_disk);
+	loop_free(lo);
+}
+
 static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 {
 	struct loop_device *lo;
@@ -1464,28 +1479,77 @@ static struct kobject *loop_probe

 static int __init loop_init(void)
 {
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
-				  THIS_MODULE, loop_probe, NULL, NULL);
+	int i, nr;
+	unsigned long range;
+	struct loop_device *lo, *next;
+
+	/*
+	 * loop module now has a feature to instantiate underlying device
+	 * structure on-demand, provided that there is an access dev node.
+	 * However, this will not work well with user space tool that doesn't
+	 * know about such "feature".  In order to not break any existing
+	 * tool, we do the following:
+	 *
+	 * (1) if max_loop is specified, create that many upfront, and this
+	 *     also becomes a hard limit.
+	 * (2) if max_loop is not specified, create 8 loop device on module
+	 *     load, user can further extend loop device by create dev node
+	 *     themselves and have kernel automatically instantiate actual
+	 *     device on-demand.
+	 */
+	if (max_loop > 1UL << MINORBITS)
+		return -EINVAL;

 	if (max_loop) {
-		printk(KERN_INFO "loop: the max_loop option is obsolete "
-				 "and will be removed in March 2008\n");
+		nr = max_loop;
+		range = max_loop;
+	} else {
+		nr = 8;
+		range = 1UL << MINORBITS;
+	}
+
+	if (register_blkdev(LOOP_MAJOR, "loop"))
+		return -EIO;

+	for (i = 0; i < nr; i++) {
+		lo = loop_alloc(i);
+		if (!lo)
+			goto Enomem;
+		list_add_tail(&lo->lo_list, &loop_devices);
 	}
+
+	/* point of no return */
+
+	list_for_each_entry(lo, &loop_devices, lo_list)
+		add_disk(lo->lo_disk);
+
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
+				  THIS_MODULE, loop_probe, NULL, NULL);
+
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+
+Enomem:
+	printk(KERN_INFO "loop: out of memory\n");
+
+	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
+		loop_free(lo);
+
+	unregister_blkdev(LOOP_MAJOR, "loop");
+	return -ENOMEM;
 }

 static void __exit loop_exit(void)
 {
+	unsigned long range;
 	struct loop_device *lo, *next;

+	range = max_loop ? max_loop :  1UL << MINORBITS;
+
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);

-	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
 }
