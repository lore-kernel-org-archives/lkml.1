Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZDNJB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZDNJB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZDNJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:54585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZDNJBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:01:16 -0400
Message-ID: <49E45079.8070508@kernel.org>
Date: Tue, 14 Apr 2009 17:59:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] block: include empty disks in /proc/diskstats
References: <49E13D18.2090805@solemnwarning.net> <49E440D9.4020803@kernel.org>
In-Reply-To: <49E440D9.4020803@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 08:59:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/diskstats used to show stats for all disks whether they're
zero-sized or not and their non-zero partitions.  Commit
074a7aca7afa6f230104e8e65eba3420263714a5 accidentally changed the
behavior such that it doesn't print out zero sized disks.  This patch
implements DISK_PITER_INCL_EMPTY_PART0 flag to partition iterator and
uses it in diskstats_show() such that empty part0 is shown in
/proc/diskstats.

Reported and bisectd by Dianel Collins.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
---
It was my bad.  I missed that diskstats showed empty disks too.  This
fixes the problem.

(Oops, forgot to write SUBJECT, resending...)

 block/genhd.c         |   12 ++++++++----
 include/linux/genhd.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..1a4916e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -98,7 +98,7 @@ void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 
 	if (flags & DISK_PITER_REVERSE)
 		piter->idx = ptbl->len - 1;
-	else if (flags & DISK_PITER_INCL_PART0)
+	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
@@ -134,7 +134,8 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
 		inc = -1;
-		if (piter->flags & DISK_PITER_INCL_PART0)
+		if (piter->flags & (DISK_PITER_INCL_PART0 |
+				    DISK_PITER_INCL_EMPTY_PART0))
 			end = -1;
 		else
 			end = 0;
@@ -150,7 +151,10 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
-		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
+		if (!part->nr_sects &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
+		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
+		      piter->idx == 0))
 			continue;
 
 		get_device(part_to_dev(part));
@@ -1011,7 +1015,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"\n\n");
 	*/
  
-	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
+	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 634c530..a1a28ca 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -214,6 +214,7 @@ static inline void disk_put_part(struct hd_struct *part)
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
+#define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
 
 struct disk_part_iter {
 	struct gendisk		*disk;
