Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYBASRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYBASRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYBASQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:16:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbYBASQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:16:15 -0500
Message-ID: <47A36180.9000302@redhat.com>
Date: Fri, 01 Feb 2008 19:14:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 5/6] Enhanced partition statistics: procfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reports enhanced partition statistics in /proc/diskstats.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/genhd.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/block/genhd.c linux-2.6/block/genhd.c
--- linux-2.6.orig/block/genhd.c	2008-01-31 16:44:09.000000000 +0100
+++ linux-2.6/block/genhd.c	2008-01-31 17:59:28.000000000 +0100
@@ -584,12 +584,28 @@ static int diskstats_show(struct seq_fil
 	for (n = 0; n < gp->minors - 1; n++) {
 		struct hd_struct *hd = gp->part[n];
 
-		if (hd && hd->nr_sects)
-			seq_printf(s, "%4d %4d %s %u %u %u %u\n",
-				gp->major, n + gp->first_minor + 1,
-				disk_name(gp, n + 1, buf),
-				hd->ios[0], hd->sectors[0],
-				hd->ios[1], hd->sectors[1]);
+		if (!hd || !hd->nr_sects)
+			continue;
+
+		preempt_disable();
+		part_round_stats(hd);
+		preempt_enable();
+		seq_printf(s, "%4d %4d %s %lu %lu %llu "
+			   "%u %lu %lu %llu %u %u %u %u\n",
+			   gp->major, n + gp->first_minor + 1,
+			   disk_name(gp, n + 1, buf),
+			   part_stat_read(hd, ios[0]),
+			   part_stat_read(hd, merges[0]),
+			   (unsigned long long)part_stat_read(hd, sectors[0]),
+			   jiffies_to_msecs(part_stat_read(hd, ticks[0])),
+			   part_stat_read(hd, ios[1]),
+			   part_stat_read(hd, merges[1]),
+			   (unsigned long long)part_stat_read(hd, sectors[1]),
+			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
+			   hd->in_flight,
+			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
+			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
+			);
 	}
  
 	return 0;

