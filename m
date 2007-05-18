Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXERJ2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXERJ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXERJ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:28:37 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15192 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbXERJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:28:36 -0400
Message-ID: <464D729C.6080603@sw.ru>
Date: Fri, 18 May 2007 13:32:12 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       devel@openvz.org
Subject: [PATCH 4/15] Make block layer /proc files use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/partitions .show callback checked the *v to be 
the first element in list to show the header. Now *v is the 
struct list_head pointer and it is checked for the head of 
the list.

The comment in /proc/diskstats .show handler is also updated
not to forget it in the future.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/block/genhd.c b/block/genhd.c
index 863a8c0..8813c14 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -270,22 +270,13 @@ void __init printk_all_partitions(void)
 /* iterator */
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
-	struct list_head *p;
-	loff_t l = *pos;
-
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
-		if (!l--)
-			return list_entry(p, struct gendisk, kobj.entry);
-	return NULL;
+	return seq_list_start_head(&block_subsys.list, *pos);
 }
 
 static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
-	++*pos;
-	return p==&block_subsys.list ? NULL :
-		list_entry(p, struct gendisk, kobj.entry);
+	return seq_list_next(v, &block_subsys.list, pos);
 }
 
 static void part_stop(struct seq_file *part, void *v)
@@ -295,13 +286,16 @@ static void part_stop(struct seq_file *p
 
 static int show_partition(struct seq_file *part, void *v)
 {
-	struct gendisk *sgp = v;
+	struct gendisk *sgp;
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->kobj.entry == block_subsys.list.next)
+	if (v == &block_subsys.list) {
 		seq_puts(part, "major minor  #blocks  name\n\n");
+		return 0;
+	}
 
+	sgp = list_entry(v, struct gendisk, kobj.entry);
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) ||
 			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
@@ -622,22 +616,13 @@ decl_subsys(block, &ktype_block, &block_
 /* iterator */
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
-	loff_t k = *pos;
-	struct list_head *p;
-
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
-		if (!k--)
-			return list_entry(p, struct gendisk, kobj.entry);
-	return NULL;
+	return seq_list_start(&block_subsys.list, *pos);
 }
 
 static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
-	++*pos;
-	return p==&block_subsys.list ? NULL :
-		list_entry(p, struct gendisk, kobj.entry);
+	return seq_list_next(v, &block_subsys.list, pos);
 }
 
 static void diskstats_stop(struct seq_file *part, void *v)
@@ -647,18 +632,21 @@ static void diskstats_stop(struct seq_fi
 
 static int diskstats_show(struct seq_file *s, void *v)
 {
-	struct gendisk *gp = v;
+	struct gendisk *gp;
 	char buf[BDEVNAME_SIZE];
 	int n = 0;
 
 	/*
-	if (&sgp->kobj.entry == block_subsys.kset.list.next)
+	if (v == &block_subsys.list) {
 		seq_puts(s,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
 				"\n\n");
+		return 0;
+	}
 	*/
  
+	gp = list_entry(v, struct gendisk, kobj.entry);
 	preempt_disable();
 	disk_round_stats(gp);
 	preempt_enable();

