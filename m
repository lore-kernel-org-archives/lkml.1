Return-Path: <linux-kernel-owner+w=401wt.eu-S965049AbXG0Oqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049AbXG0Oqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936109AbXG0Oq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:46:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:32992 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932815AbXG0Oq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:46:26 -0400
X-Authenticated: #402683
X-Provags-ID: V01U2FsdGVkX19UAdU3H95UCRHeVHk2PVHNnSoUPVr3Tsg6TUAjJu
	F6AG0sZ8vwZLs7
Subject: md: raid10: fix use-after-free of bio
From: Maik Hampel <m.hampel@gmx.de>
To: Neil Brown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:46:23 +0200
Message-Id: <1185547583.2663.10.camel@c64>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In case of read errors raid10d tries to print a nice error message,
unfortunately using data from an already put bio.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f730a14..ea1b3e3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1557,7 +1557,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1567,6 +1566,7 @@ static void raid10d(mddev_t *mddev)
 				raid_end_bio_io(r10_bio);
 			} else {
 				const int do_sync = bio_sync(r10_bio->master_bio);
+				bio_put(bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"



