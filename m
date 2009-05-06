Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbZEFWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbZEFWAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761428AbZEFVye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:34 -0400
Received: from kroah.org ([198.145.64.141]:57022 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZEFVya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:57 2009
Message-Id: <20090506214757.329306892@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 15/58] block: include empty disks in /proc/diskstats
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=block-include-empty-disks-in-proc-diskstats.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 71982a409f12c50d011325a4471aa20666bb908d upstream.

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
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/genhd.c         |   12 ++++++++----
 include/linux/genhd.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -98,7 +98,7 @@ void disk_part_iter_init(struct disk_par
 
 	if (flags & DISK_PITER_REVERSE)
 		piter->idx = ptbl->len - 1;
-	else if (flags & DISK_PITER_INCL_PART0)
+	else if (flags & (DISK_PITER_INCL_PART0 | DISK_PITER_INCL_EMPTY_PART0))
 		piter->idx = 0;
 	else
 		piter->idx = 1;
@@ -134,7 +134,8 @@ struct hd_struct *disk_part_iter_next(st
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
 		inc = -1;
-		if (piter->flags & DISK_PITER_INCL_PART0)
+		if (piter->flags & (DISK_PITER_INCL_PART0 |
+				    DISK_PITER_INCL_EMPTY_PART0))
 			end = -1;
 		else
 			end = 0;
@@ -150,7 +151,10 @@ struct hd_struct *disk_part_iter_next(st
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
@@ -1011,7 +1015,7 @@ static int diskstats_show(struct seq_fil
 				"\n\n");
 	*/
  
-	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
+	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -214,6 +214,7 @@ static inline void disk_put_part(struct 
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
+#define DISK_PITER_INCL_EMPTY_PART0 (1 << 3) /* include empty partition 0 */
 
 struct disk_part_iter {
 	struct gendisk		*disk;


