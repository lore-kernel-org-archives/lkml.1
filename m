Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYBINaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYBINaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYBINam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:30:42 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:49913 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754525AbYBINam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:30:42 -0500
Message-ID: <47ADAB00.90306@steeleye.com>
Date: Sat, 09 Feb 2008 08:30:40 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jens.axboe@oracle.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
References: <47AC87AE.9040408@steeleye.com>	<20080208093341.b4d02e22.randy.dunlap@oracle.com>	<20080208101151.935b575c.akpm@linux-foundation.org>	<47ACA250.1010404@steeleye.com>	<20080208204510.GD23197@kernel.dk>	<20080208204713.GF23197@kernel.dk>	<47ACC835.4070102@steeleye.com> <20080208140244.c850a5d3.akpm@linux-foundation.org>
In-Reply-To: <20080208140244.c850a5d3.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------070604040406000902050409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070604040406000902050409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Take 3...this should address all the issues.





--------------070604040406000902050409
Content-Type: text/x-patch;
 name="nbd_default_to_deadline_then_noop.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_default_to_deadline_then_noop.diff"

NBD doesn't work well with CFQ (or AS) schedulers, so let's default to something
else.

The two problems I have experienced with nbd and cfq are:
 
1) nbd hangs with cfq on RHEL 5 (2.6.18) -- this may well have been fixed
 
There's a similar debian bug that has been filed as well:
 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=447638

There have been posts to nbd-general mailing list about problems with 
cfq and nbd also.
 
2) nbd performs about 10% better (the last time I tested) with deadline 
vs. cfq (the overhead of cfq doesn't provide much advantage to nbd [not 
being a real disk], and you end up going through the I/O scheduler on 
the nbd server anyway, so it makes sense that deadline is better with nbd)
 

Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./drivers/block/nbd.c.max_nbd_killed	2008-02-07 16:46:24.000000000 -0500
+++ ./drivers/block/nbd.c	2008-02-09 08:14:18.000000000 -0500
@@ -654,6 +654,7 @@ static int __init nbd_init(void)
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1);
+		elevator_t *old_e;
 		if (!disk)
 			goto out;
 		nbd_dev[i].disk = disk;
@@ -667,6 +668,11 @@ static int __init nbd_init(void)
 			put_disk(disk);
 			goto out;
 		}
+		old_e = disk->queue->elevator;
+		if (elevator_init(disk->queue, "deadline") == 0 ||
+			elevator_init(disk->queue, "noop") == 0) {
+				elevator_exit(old_e);
+		}
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {

--------------070604040406000902050409--
