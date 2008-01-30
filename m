Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYA3CES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYA3CES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYA3CEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:04:08 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:34632 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbYA3CEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:04:06 -0500
Message-ID: <479FDB15.4090104@steeleye.com>
Date: Tue, 29 Jan 2008 21:04:05 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: raise max number of nbd devices to 1024
References: <479F9B12.8010207@steeleye.com> <20080129135417.e20b8107.akpm@linux-foundation.org>
In-Reply-To: <20080129135417.e20b8107.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020205070006080800090505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020205070006080800090505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:

<snip>

> much nicer?

OK, yes, I was going for quick and easy, but you've got a point...

We do need to move the kcalloc into nbd_init instead of nbd_cleanup, 
though -- that works a little better. Patch is attached. Thanks for the 
suggestion.

--
Paul

--------------020205070006080800090505
Content-Type: text/x-patch;
 name="nbd_max_nbd_killed.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nbd_max_nbd_killed.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

--- ./include/linux/nbd.h.TIMEOUT	2007-08-22 13:18:12.000000000 -0400
+++ ./include/linux/nbd.h	2008-01-29 20:01:33.000000000 -0500
@@ -35,7 +35,6 @@ enum {
 };
 
 #define nbd_cmd(req) ((req)->cmd[0])
-#define MAX_NBD 128
 
 /* userspace doesn't need the nbd_device structure */
 #ifdef __KERNEL__
--- ./drivers/block/nbd.c.ORIG	2008-01-29 20:01:12.000000000 -0500
+++ ./drivers/block/nbd.c	2008-01-29 20:08:30.000000000 -0500
@@ -53,7 +53,7 @@ static unsigned int debugflags;
 #endif /* NDEBUG */
 
 static unsigned int nbds_max = 16;
-static struct nbd_device nbd_dev[MAX_NBD];
+static struct nbd_device *nbd_dev;
 
 /*
  * Use just one lock (or at most 1 per NIC). Two arguments for this:
@@ -659,11 +659,9 @@ static int __init nbd_init(void)
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
-	if (nbds_max > MAX_NBD) {
-		printk(KERN_CRIT "nbd: cannot allocate more than %u nbds; %u requested.\n", MAX_NBD,
-				nbds_max);
-		return -EINVAL;
-	}
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1);

--------------020205070006080800090505--
