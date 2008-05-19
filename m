Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYESBMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYESBMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYESBLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:50277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121AbYESBKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:38 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:31 +1000
Message-Id: <1080519011031.7672@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bernd Schubert <bernd-schubert@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 004 of 10] md: md: raid5 rate limit error printk
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bernd Schubert <bernd-schubert@gmx.de>

last night we had scsi problems and a hardware raid
unit was offlined during heavy i/o. While this happened we got for
about 3 minutes a huge number messages like these

Apr 12 03:36:07 pfs1n14 kernel: [197510.696595] raid5:md7: read error not correctable (sector 2993096568 on sdj2).

I guess the high error rate is responsible for not scheduling other
events - during this time the system was not pingable and in the end
also other devices run into scsi command timeouts causing problems on
these unrelated devices as well.

Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-05-19 11:02:09.000000000 +1000
+++ ./drivers/md/raid5.c	2008-05-19 11:02:44.000000000 +1000
@@ -94,6 +94,8 @@
 #define __inline__
 #endif
 
+#define printk_rl(args...) ((void) (printk_ratelimit() && printk(args)))
+
 #if !RAID6_USE_EMPTY_ZERO_PAGE
 /* In .bss so it's zeroed */
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(256)));
@@ -1143,10 +1145,12 @@ static void raid5_end_read_request(struc
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
-			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
-			       mdname(conf->mddev), STRIPE_SECTORS,
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdevname(rdev->bdev, b));
+			printk_rl(KERN_INFO "raid5:%s: read error corrected"
+				  " (%lu sectors at %llu on %s)\n",
+				  mdname(conf->mddev), STRIPE_SECTORS,
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdevname(rdev->bdev, b));
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
@@ -1160,16 +1164,22 @@ static void raid5_end_read_request(struc
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
-			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING
+				  "raid5:%s: read error not correctable "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdn);
 		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
-			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
-			       mdname(conf->mddev),
-			       (unsigned long long)(sh->sector + rdev->data_offset),
-			       bdn);
+			printk_rl(KERN_WARNING
+				  "raid5:%s: read error NOT corrected!! "
+				  "(sector %llu on %s).\n",
+				  mdname(conf->mddev),
+				  (unsigned long long)(sh->sector
+						       + rdev->data_offset),
+				  bdn);
 		else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
