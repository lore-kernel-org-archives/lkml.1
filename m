Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbXEVBse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbXEVBse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXEVBs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:48:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbXEVBs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:48:26 -0400
Date: Tue, 22 May 2007 02:48:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ken Chen <kenchen@google.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: + loop-preallocate-eight-loop-devices.patch added to -mm tree
Message-ID: <20070522014822.GF4095@ftp.linux.org.uk>
References: <200705212200.l4LM0tYK021050@shell0.pdx.osdl.net> <20070522001851.GE4095@ftp.linux.org.uk> <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0705211830h127dfd8dk8930de6655d37d90@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 06:30:15PM -0700, Ken Chen wrote:
> On 5/21/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> >On Mon, May 21, 2007 at 03:00:55PM -0700, akpm@linux-foundation.org wrote:
> >> +     if (register_blkdev(LOOP_MAJOR, "loop"))
> >> +             return -EIO;
> >> +     blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
> >> +                               THIS_MODULE, loop_probe, NULL, NULL);
> >> +
> >> +     for (i = 0; i < nr; i++) {
> >> +             if (!loop_init_one(i))
> >> +                     goto err;
> >> +     }
> >> +
> >> +     printk(KERN_INFO "loop: module loaded\n");
> >> +     return 0;
> >> +err:
> >> +     loop_exit();
> >
> >This isn't good.  You *can't* fail once a single disk has been registered.
> >Anyone could've opened it by now.
> >
> >IOW, you need to
> >        * register region *after* you are past the point of no return
> 
> That option is a lot harder than I thought.  This requires an array to
> keep intermediate result of preallocated "lo" device, blk_queue, and
> disk structure before calling add_disk() or register region.  And this
> array could be potentially 1 million entries.  Maybe I will use
> vmalloc for it, but seems rather sick.

No, it doesn't.  Really.  It's easy to split; untested incremental to your
patch follows:

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0aae8d8..2300490 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1394,16 +1394,11 @@ int loop_unregister_transfer(int number)
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
@@ -1427,8 +1422,6 @@ static struct loop_device *loop_init_one(int i)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
-	add_disk(disk);
-	list_add_tail(&lo->lo_list, &loop_devices);
 	return lo;
 
 out_free_queue:
@@ -1439,6 +1432,23 @@ out:
 	return NULL;
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
 static void loop_del_one(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
@@ -1481,6 +1491,7 @@ static int __init loop_init(void)
 {
 	int i, nr;
 	unsigned long range;
+	struct loop_device *lo;
 
 	/*
 	 * loop module now has a feature to instantiate underlying device
@@ -1506,19 +1517,34 @@ static int __init loop_init(void)
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
-				  THIS_MODULE, loop_probe, NULL, NULL);
 
 	for (i = 0; i < nr; i++) {
-		if (!loop_init_one(i))
-			goto err;
+		lo = loop_alloc(i);
+		if (!lo)
+			goto Enomem;
+		list_add_tail(&lo->lo_list, &loop_devices);
 	}
 
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
-err:
-	loop_exit();
+
+Enomem:
 	printk(KERN_INFO "loop: out of memory\n");
+
+	while(!list_empty(&loop_devices)) {
+		lo = list_entry(loop_devices.next, struct loop_device, lo_list);
+		loop_del_one(lo);
+	}
+
+	unregister_blkdev(LOOP_MAJOR, "loop");
 	return -ENOMEM;
 }
 
