Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXF3DZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXF3DZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXF3DYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:24:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:18448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbXF3DYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pXSpHcLwohR+iJbGSBm1qRYHMVVYtA0Bm90Wteiyxr5wv2SfUnceXCnCl6lt8u3KVnrkC2e9Zj4PgL/CZBv9Yr0xcZuL/tQysdJ/VdJs9lGqb17v9KjqW0djS4eLz/5yyCXSbj59F40/iUe3ctmp4G1iH4x4q53IdrFYp0pz3Is=
Date: Sat, 30 Jun 2007 12:15:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Cc: Eberhard Moenkeberg <emoenke@gwdg.de>,
       Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>
Subject: [PATCH 3/4] void unregister_blkdev - ignore the return value
Message-ID: <20070630031538.GA4131@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	Eberhard Moenkeberg <emoenke@gwdg.de>,
	Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>
References: <20070630031013.GC4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630031013.GC4045@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some cdrom drivers stop destruct operations in module_exit() when
unregister_blkdev() failure happens.

But it can't help to stop unloading module. So it will not be good
error handling. Furthermore any other block drivers don't have such
handling and there is no special reason that only those cdrom drivers
have to do.

This patch removes the return value checks for unregister_blkdev().

This change will not hide the bugs. Because unregister_blkdev() prints
error message on failures by the previous patch.

Cc: Eberhard Moenkeberg <emoenke@gwdg.de>
Cc: Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/cdrom/aztcd.c  |    5 +----
 drivers/cdrom/cdu31a.c |    6 +-----
 drivers/cdrom/cm206.c  |    5 +----
 drivers/cdrom/gscd.c   |    5 +----
 drivers/cdrom/optcd.c  |    5 +----
 drivers/cdrom/sbpcd.c  |    8 ++------
 6 files changed, 7 insertions(+), 27 deletions(-)

Index: 2.6-mm/drivers/cdrom/optcd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/optcd.c
+++ 2.6-mm/drivers/cdrom/optcd.c
@@ -2089,10 +2089,7 @@ static void __exit optcd_exit(void)
 {
 	del_gendisk(optcd_disk);
 	put_disk(optcd_disk);
-	if (unregister_blkdev(MAJOR_NR, "optcd") == -EINVAL) {
-		printk(KERN_ERR "optcd: what's that: can't unregister\n");
-		return;
-	}
+	unregister_blkdev(MAJOR_NR, "optcd");
 	blk_cleanup_queue(opt_queue);
 	release_region(optcd_port, 4);
 	printk(KERN_INFO "optcd: module released.\n");
Index: 2.6-mm/drivers/cdrom/sbpcd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/sbpcd.c
+++ 2.6-mm/drivers/cdrom/sbpcd.c
@@ -5885,12 +5885,8 @@ int __init sbpcd_init(void)
 static void sbpcd_exit(void)
 {
 	int j;
-	
-	if ((unregister_blkdev(MAJOR_NR, major_name) == -EINVAL))
-	{
-		msg(DBG_INF, "What's that: can't unregister %s.\n", major_name);
-		return;
-	}
+
+	unregister_blkdev(MAJOR_NR, major_name);
 	release_region(CDo_command,4);
 	blk_cleanup_queue(sbpcd_queue);
 	for (j=0;j<NR_SBPCD;j++)
Index: 2.6-mm/drivers/cdrom/cdu31a.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/cdu31a.c
+++ 2.6-mm/drivers/cdrom/cdu31a.c
@@ -3227,11 +3227,7 @@ static void __exit cdu31a_exit(void)
 				"cdrom driver\n");
 		return;
 	}
-	if ((unregister_blkdev(MAJOR_NR, "cdu31a") == -EINVAL)) {
-		printk(KERN_WARNING PFX "Can't unregister\n");
-		return;
-	}
-
+	unregister_blkdev(MAJOR_NR, "cdu31a");
 	blk_cleanup_queue(cdu31a_queue);
 
 	if (cdu31a_irq > 0)
Index: 2.6-mm/drivers/cdrom/gscd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/gscd.c
+++ 2.6-mm/drivers/cdrom/gscd.c
@@ -882,10 +882,7 @@ static void __exit gscd_exit(void)
 
 	del_gendisk(gscd_disk);
 	put_disk(gscd_disk);
-	if ((unregister_blkdev(MAJOR_NR, "gscd") == -EINVAL)) {
-		printk("What's that: can't unregister GoldStar-module\n");
-		return;
-	}
+	unregister_blkdev(MAJOR_NR, "gscd");
 	blk_cleanup_queue(gscd_queue);
 	release_region(gscd_port, GSCD_IO_EXTENT);
 	printk(KERN_INFO "GoldStar-module released.\n");
Index: 2.6-mm/drivers/cdrom/aztcd.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/aztcd.c
+++ 2.6-mm/drivers/cdrom/aztcd.c
@@ -1941,10 +1941,7 @@ static void __exit aztcd_exit(void)
 {
 	del_gendisk(azt_disk);
 	put_disk(azt_disk);
-	if ((unregister_blkdev(MAJOR_NR, "aztcd") == -EINVAL)) {
-		printk("What's that: can't unregister aztcd\n");
-		return;
-	}
+	unregister_blkdev(MAJOR_NR, "aztcd");
 	blk_cleanup_queue(azt_queue);
 	if ((azt_port == 0x1f0) || (azt_port == 0x170)) {
 		SWITCH_IDE_MASTER;
Index: 2.6-mm/drivers/cdrom/cm206.c
===================================================================
--- 2.6-mm.orig/drivers/cdrom/cm206.c
+++ 2.6-mm/drivers/cdrom/cm206.c
@@ -1548,10 +1548,7 @@ static void __exit cm206_exit(void)
 		printk("Can't unregister cdrom cm206\n");
 		return;
 	}
-	if (unregister_blkdev(MAJOR_NR, "cm206")) {
-		printk("Can't unregister major cm206\n");
-		return;
-	}
+	unregister_blkdev(MAJOR_NR, "cm206");
 	blk_cleanup_queue(cm206_queue);
 	free_irq(cm206_irq, NULL);
 	kfree(cd);
