Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZA3Pw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZA3Pw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZA3Pwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:52:51 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:65099 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZA3Pwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:52:51 -0500
Date: Sat, 31 Jan 2009 00:52:50 +0900 (JST)
Message-Id: <20090131.005250.95064457.anemo@mba.ocn.ne.jp>
To: matthias@kaehlcke.net
Cc: akpm@linux-foundation.org, David.Woodhouse@intel.com, vapier.adi@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] physmap_flash_probe() frees memory still in use
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090130134317.GV9390@traven>
References: <20090130134317.GV9390@traven>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 14:43:18 +0100, Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> as i reported earlier in this month
> (http://lkml.org/lkml/2009/1/12/141) MTD partition names are screwed
> up in 2.6.29-rcX.
> 
> commit 176bf2e0f10ecf1d20a97db3bd5bb2e6ba0b5668 deals with a memory
> leak and frees the pointer array of mtd_partition after the call to
> add_mtd_partitions(). the problem is that mtd_table[x]->name still
> points to the freed memory.

Oh Yes, I had missed that point.  And looking at physmap driver again,
I found that del_mtd_partition() and del_mtd_device() are abused.
Though these APIs are robust enough, deleting right things in right
order would be better.

Could you test this patch?  I cannot test it until Monday.


------------------------------------------------------
Subject: [MTD] physmap: Fix wrong free and del_mtd_{partition,device}
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit 176bf2e0f10ecf1d20a97db3bd5bb2e6ba0b5668 deals with a memory
leak and frees the pointer array of mtd_partition after the call to
add_mtd_partitions(). the problem is that mtd_table[x]->name still
points to the freed memory.

Aldo physmap_flash_remove() should call del_mtd_partitions() or
del_mtd_device() only once.

Reported-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 8774366..4b122e7 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -29,6 +29,7 @@ struct physmap_flash_info {
 	struct map_info		map[MAX_RESOURCES];
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
+	struct mtd_partition	*parts;
 #endif
 };
 
@@ -45,25 +46,26 @@ static int physmap_flash_remove(struct platform_device *dev)
 
 	physmap_data = dev->dev.platform_data;
 
-#ifdef CONFIG_MTD_CONCAT
-	if (info->cmtd != info->mtd[0]) {
+#ifdef CONFIG_MTD_PARTITIONS
+	if (info->nr_parts) {
+		del_mtd_partitions(info->cmtd);
+		kfree(info->parts);
+	} else if (physmap_data->nr_parts)
+		del_mtd_partitions(info->cmtd);
+	else
 		del_mtd_device(info->cmtd);
+#else
+	del_mtd_device(info->cmtd);
+#endif
+
+#ifdef CONFIG_MTD_CONCAT
+	if (info->cmtd != info->mtd[0])
 		mtd_concat_destroy(info->cmtd);
-	}
 #endif
 
 	for (i = 0; i < MAX_RESOURCES; i++) {
-		if (info->mtd[i] != NULL) {
-#ifdef CONFIG_MTD_PARTITIONS
-			if (info->nr_parts || physmap_data->nr_parts)
-				del_mtd_partitions(info->mtd[i]);
-			else
-				del_mtd_device(info->mtd[i]);
-#else
-			del_mtd_device(info->mtd[i]);
-#endif
+		if (info->mtd[i] != NULL)
 			map_destroy(info->mtd[i]);
-		}
 	}
 	return 0;
 }
@@ -86,9 +88,6 @@ static int physmap_flash_probe(struct platform_device *dev)
 	int err = 0;
 	int i;
 	int devices_found = 0;
-#ifdef CONFIG_MTD_PARTITIONS
-	struct mtd_partition *parts;
-#endif
 
 	physmap_data = dev->dev.platform_data;
 	if (physmap_data == NULL)
@@ -167,10 +166,11 @@ static int physmap_flash_probe(struct platform_device *dev)
 		goto err_out;
 
 #ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
+	err = parse_mtd_partitions(info->cmtd, part_probe_types,
+				&info->parts, 0);
 	if (err > 0) {
-		add_mtd_partitions(info->cmtd, parts, err);
-		kfree(parts);
+		add_mtd_partitions(info->cmtd, info->parts, err);
+		info->nr_parts = err;
 		return 0;
 	}
 
