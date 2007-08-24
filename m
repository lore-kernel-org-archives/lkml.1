Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbXHXRHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbXHXRHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbXHXRGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:06:42 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:45425 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758173AbXHXRGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:06:41 -0400
Message-ID: <46CF101F.4050603@steeleye.com>
Date: Fri, 24 Aug 2007 13:06:39 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
CC: david@dgreaves.com, Wouter Verhelst <w@uter.be>,
       Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/2] NBD: set uninitialized devices to size 0
Content-Type: multipart/mixed;
 boundary="------------090901030004050107020007"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090901030004050107020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This fixes errors with utilities (such as LVM's vgscan) that try to scan 
all devices. Previously this would generate read errors when 
uninitialized nbd devices were scanned:

# vgscan
   Reading all physical volumes.  This may take a while...
   /dev/nbd0: read failed after 0 of 1024 at 0: Input/output error
   /dev/nbd0: read failed after 0 of 1024 at 509804544: Input/output error
   /dev/nbd0: read failed after 0 of 2048 at 0: Input/output error
   /dev/nbd1: read failed after 0 of 1024 at 509804544: Input/output error
   /dev/nbd1: read failed after 0 of 2048 at 0: Input/output error


 From now on, uninitialized nbd devices will have size zero, which 
prevents these errors.

Patch applies and was tested against 2.6.23-rc2-mm2.

Thanks,
Paul

--------------090901030004050107020007
Content-Type: text/x-patch;
 name="nbd_size_zero.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_size_zero.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./drivers/block/nbd.c.ERROR_RETURNS	2007-08-15 15:41:19.000000000 -0400
+++ ./drivers/block/nbd.c	2007-08-16 13:08:06.000000000 -0400
@@ -589,6 +589,9 @@ static int nbd_ioctl(struct inode *inode
 		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
 		if (file)
 			fput(file);
+		lo->bytesize = 0;
+		inode->i_bdev->bd_inode->i_size = 0;
+		set_capacity(lo->disk, 0);
 		return lo->harderror;
 	case NBD_CLEAR_QUE:
 		/*
@@ -666,14 +669,14 @@ static int __init nbd_init(void)
 		mutex_init(&nbd_dev[i].tx_lock);
 		init_waitqueue_head(&nbd_dev[i].active_wq);
 		nbd_dev[i].blksize = 1024;
-		nbd_dev[i].bytesize = 0x7ffffc00ULL << 10; /* 2TB */
+		nbd_dev[i].bytesize = 0;
 		disk->major = NBD_MAJOR;
 		disk->first_minor = i;
 		disk->fops = &nbd_fops;
 		disk->private_data = &nbd_dev[i];
 		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 		sprintf(disk->disk_name, "nbd%d", i);
-		set_capacity(disk, 0x7ffffc00ULL << 1); /* 2 TB */
+		set_capacity(disk, 0);
 		add_disk(disk);
 	}
 

--------------090901030004050107020007--
