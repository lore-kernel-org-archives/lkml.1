Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbXJXUAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbXJXUAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXJXUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:00:06 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:41400 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbXJXT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:59:59 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/4] partitions: Fix non-atomic printk
Date: Wed, 24 Oct 2007 15:59:52 -0400
Message-Id: <1193255992-14385-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193255992-14385-3-git-send-email-matthew@wil.cx>
References: <20071024195847.GE27248@parisc-linux.org>
 <1193255992-14385-1-git-send-email-matthew@wil.cx>
 <1193255992-14385-2-git-send-email-matthew@wil.cx>
 <1193255992-14385-3-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With asynchronous disk scanning, it's quite common for the partition
report to be interrupted by reports of other discs being discovered.
Use a new function, print_partition, to accumulate the partitions into
a stringbuf.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/partitions/acorn.c  |   24 ++++++++++--------------
 fs/partitions/amiga.c  |    9 ++++-----
 fs/partitions/atari.c  |   20 +++++++++-----------
 fs/partitions/check.c  |   19 ++++++++++++++-----
 fs/partitions/check.h  |    7 ++++++-
 fs/partitions/efi.c    |    1 -
 fs/partitions/ibm.c    |   11 +++++------
 fs/partitions/karma.c  |    1 -
 fs/partitions/ldm.c    |   11 +++++------
 fs/partitions/mac.c    |    3 +--
 fs/partitions/msdos.c  |   36 +++++++++++++++++-------------------
 fs/partitions/osf.c    |    1 -
 fs/partitions/sgi.c    |    1 -
 fs/partitions/sun.c    |    1 -
 fs/partitions/sysv68.c |    5 ++---
 fs/partitions/ultrix.c |    1 -
 16 files changed, 73 insertions(+), 78 deletions(-)

diff --git a/fs/partitions/acorn.c b/fs/partitions/acorn.c
index 3d3e166..7ece065 100644
--- a/fs/partitions/acorn.c
+++ b/fs/partitions/acorn.c
@@ -46,7 +46,7 @@ adfs_partition(struct parsed_partitions *state, char *name, char *data,
 		   (le32_to_cpu(dr->disc_size) >> 9);
 
 	if (name)
-		printk(" [%s]", name);
+		print_partition(state, " [%s]", name);
 	put_partition(state, slot, first_sector, nr_sects);
 	return dr;
 }
@@ -81,14 +81,14 @@ riscix_partition(struct parsed_partitions *state, struct block_device *bdev,
 	if (!rr)
 		return -1;
 
-	printk(" [RISCiX]");
+	print_partition(state, " [RISCiX]");
 
 
 	if (rr->magic == RISCIX_MAGIC) {
 		unsigned long size = nr_sects > 2 ? 2 : nr_sects;
 		int part;
 
-		printk(" <");
+		print_partition(state, " <");
 
 		put_partition(state, slot++, first_sect, size);
 		for (part = 0; part < 8; part++) {
@@ -97,11 +97,11 @@ riscix_partition(struct parsed_partitions *state, struct block_device *bdev,
 				put_partition(state, slot++,
 					le32_to_cpu(rr->part[part].start),
 					le32_to_cpu(rr->part[part].length));
-				printk("(%s)", rr->part[part].name);
+				print_partition(state, "(%s)", rr->part[part].name);
 			}
 		}
 
-		printk(" >\n");
+		print_partition(state, " >");
 	} else {
 		put_partition(state, slot++, first_sect, nr_sects);
 	}
@@ -131,7 +131,7 @@ linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 	struct linux_part *linuxp;
 	unsigned long size = nr_sects > 2 ? 2 : nr_sects;
 
-	printk(" [Linux]");
+	print_partition(state, " [Linux]");
 
 	put_partition(state, slot++, first_sect, size);
 
@@ -139,7 +139,7 @@ linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 	if (!linuxp)
 		return -1;
 
-	printk(" <");
+	print_partition(state, " <");
 	while (linuxp->magic == cpu_to_le32(LINUX_NATIVE_MAGIC) ||
 	       linuxp->magic == cpu_to_le32(LINUX_SWAP_MAGIC)) {
 		if (slot == state->limit)
@@ -149,7 +149,7 @@ linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 				 le32_to_cpu(linuxp->nr_sects));
 		linuxp ++;
 	}
-	printk(" >");
+	print_partition(state, " >");
 
 	put_dev_sector(sect);
 	return slot;
@@ -306,7 +306,6 @@ adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
 			break;
 		}
 	}
-	printk("\n");
 	return 1;
 }
 #endif
@@ -379,7 +378,7 @@ adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
 		return 0;
 	}
 
-	printk(" [ICS]");
+	print_partition(state, " [ICS]");
 
 	for (slot = 1, p = (const struct ics_part *)data; p->size; p++) {
 		u32 start = le32_to_cpu(p->start);
@@ -413,7 +412,6 @@ adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
 	}
 
 	put_dev_sector(sect);
-	printk("\n");
 	return 1;
 }
 #endif
@@ -474,7 +472,7 @@ adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bd
 		return 0;
 	}
 
-	printk(" [POWERTEC]");
+	print_partition(state, " [POWERTEC]");
 
 	for (i = 0, p = (const struct ptec_part *)data; i < 12; i++, p++) {
 		u32 start = le32_to_cpu(p->start);
@@ -485,7 +483,6 @@ adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bd
 	}
 
 	put_dev_sector(sect);
-	printk("\n");
 	return 1;
 }
 #endif
@@ -557,7 +554,6 @@ adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev)
 
 		size = get_capacity(bdev->bd_disk);
 		put_partition(state, slot++, start, size - start);
-		printk("\n");
 	}
 
 	return i ? 1 : 0;
diff --git a/fs/partitions/amiga.c b/fs/partitions/amiga.c
index 9917a8c..9853dee 100644
--- a/fs/partitions/amiga.c
+++ b/fs/partitions/amiga.c
@@ -70,7 +70,7 @@ amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
 	/* blksize is blocks per 512 byte standard block */
 	blksize = be32_to_cpu( rdb->rdb_BlockBytes ) / 512;
 
-	printk(" RDSK (%d)", blksize * 512);	/* Be more informative */
+	print_partition(state, " RDSK (%d)", blksize * 512);	/* Be more informative */
 	blk = be32_to_cpu(rdb->rdb_PartitionList);
 	put_dev_sector(sect);
 	for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
@@ -110,20 +110,19 @@ amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
 			__be32 *dt = (__be32 *)dostype;
 			*dt = pb->pb_Environment[16];
 			if (dostype[3] < ' ')
-				printk(" (%c%c%c^%c)",
+				print_partition(state, " (%c%c%c^%c)",
 					dostype[0], dostype[1],
 					dostype[2], dostype[3] + '@' );
 			else
-				printk(" (%c%c%c%c)",
+				print_partition(state, " (%c%c%c%c)",
 					dostype[0], dostype[1],
 					dostype[2], dostype[3]);
-			printk("(res %d spb %d)",
+			print_partition(state, "(res %d spb %d)",
 				be32_to_cpu(pb->pb_Environment[6]),
 				be32_to_cpu(pb->pb_Environment[4]));
 		}
 		res = 1;
 	}
-	printk("\n");
 
 rdb_done:
 	return res;
diff --git a/fs/partitions/atari.c b/fs/partitions/atari.c
index 1f3572d..b696b52 100644
--- a/fs/partitions/atari.c
+++ b/fs/partitions/atari.c
@@ -62,7 +62,7 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 	}
 
 	pi = &rs->part[0];
-	printk (" AHDI");
+	print_partition(state, " AHDI");
 	for (slot = 1; pi < &rs->part[4] && slot < state->limit; slot++, pi++) {
 		struct rootsector *xrs;
 		Sector sect2;
@@ -81,19 +81,19 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 #ifdef ICD_PARTS
 		part_fmt = 1;
 #endif
-		printk(" XGM<");
+		print_partition(state, " XGM<");
 		partsect = extensect = be32_to_cpu(pi->st);
 		while (1) {
 			xrs = (struct rootsector *)read_dev_sector(bdev, partsect, &sect2);
 			if (!xrs) {
-				printk (" block %ld read failed\n", partsect);
+				print_partition(state, " block %ld read failed\n", partsect);
 				put_dev_sector(sect);
 				return -1;
 			}
 
 			/* ++roman: sanity check: bit 0 of flg field must be set */
 			if (!(xrs->part[0].flg & 1)) {
-				printk( "\nFirst sub-partition in extended partition is not valid!\n" );
+				printk("First sub-partition in extended partition is not valid!\n");
 				put_dev_sector(sect2);
 				break;
 			}
@@ -108,7 +108,7 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 				break;
 			}
 			if (memcmp( xrs->part[1].id, "XGM", 3 ) != 0) {
-				printk("\nID of extended partition is not XGM!\n");
+				printk("ID of extended partition is not XGM!\n");
 				put_dev_sector(sect2);
 				break;
 			}
@@ -116,18 +116,18 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 			partsect = be32_to_cpu(xrs->part[1].st) + extensect;
 			put_dev_sector(sect2);
 			if (++slot == state->limit) {
-				printk( "\nMaximum number of partitions reached!\n" );
+				printk("Maximum number of partitions reached!\n");
 				break;
 			}
 		}
-		printk(" >");
+		print_partition(state, " >");
 	}
 #ifdef ICD_PARTS
 	if ( part_fmt!=1 ) { /* no extended partitions -> test ICD-format */
 		pi = &rs->icdpart[0];
 		/* sanity check: no ICD format if first partition invalid */
 		if (OK_id(pi->id)) {
-			printk(" ICD<");
+			print_partition(state, " ICD<");
 			for (; pi < &rs->icdpart[8] && slot < state->limit; slot++, pi++) {
 				/* accept only GEM,BGM,RAW,LNX,SWP partitions */
 				if (!((pi->flg & 1) && OK_id(pi->id)))
@@ -137,13 +137,11 @@ int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
 						be32_to_cpu(pi->st),
 						be32_to_cpu(pi->siz));
 			}
-			printk(" >");
+			print_partition(state, " >");
 		}
 	}
 #endif
 	put_dev_sector(sect);
 
-	printk ("\n");
-
 	return 1;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..9de2422 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -162,9 +162,10 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	state = kmalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
 	if (!state)
 		return NULL;
+	sb_init(&state->sb);
 
 	disk_name(hd, 0, state->name);
-	printk(KERN_INFO " %s:", state->name);
+	print_partition(state, "%s:", state->name);
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
@@ -182,15 +183,23 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 		}
 
 	}
-	if (res > 0)
+
+	if (res > 0) {
+		printk(KERN_INFO " %s\n", state->sb.buf);
+		sb_free(&state->sb);
 		return state;
-	if (err)
+	}
+
 	/* The partition is unrecognized. So report I/O errors if there were any */
+	if (err)
 		res = err;
 	if (!res)
-		printk(" unknown partition table\n");
+		print_partition(state, " unknown partition table");
 	else if (warn_no_part)
-		printk(" unable to read partition table\n");
+		print_partition(state, " unable to read partition table");
+
+	printk(KERN_INFO " %s\n", state->sb.buf);
+	sb_free(&state->sb);
 	kfree(state);
 	return ERR_PTR(res);
 }
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index 17ae8ec..8f6dcb7 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -1,5 +1,6 @@
 #include <linux/pagemap.h>
 #include <linux/blkdev.h>
+#include <linux/stringbuf.h>
 
 /*
  * add_gd_partition adds a partitions details to the devices partition
@@ -16,15 +17,19 @@ struct parsed_partitions {
 	} parts[MAX_PART];
 	int next;
 	int limit;
+	struct stringbuf sb;
 };
 
+#define print_partition(p, fmt, args...) \
+				sb_printf(&p->sb, GFP_KERNEL, fmt , ## args)
+
 static inline void
 put_partition(struct parsed_partitions *p, int n, sector_t from, sector_t size)
 {
 	if (n < p->limit) {
 		p->parts[n].from = from;
 		p->parts[n].size = size;
-		printk(" %s%d", p->name, n);
+		sb_printf(&p->sb, GFP_KERNEL, " %s%d", p->name, n);
 	}
 }
 
diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index e7b0700..9631304 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -634,6 +634,5 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	}
 	kfree(ptes);
 	kfree(gpt);
-	printk("\n");
 	return 1;
 }
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index 1e064c4..53766a7 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -111,14 +111,14 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 			 * VM style CMS1 labeled disk
 			 */
 			if (label->cms.disk_offset != 0) {
-				printk("CMS1/%8s(MDSK):", name);
+				print_partition(state, "CMS1/%8s(MDSK):", name);
 				/* disk is reserved minidisk */
 				blocksize = label->cms.block_size;
 				offset = label->cms.disk_offset;
 				size = (label->cms.block_count - 1)
 					* (blocksize >> 9);
 			} else {
-				printk("CMS1/%8s:", name);
+				print_partition(state, "CMS1/%8s:", name);
 				offset = (info->label_block + 1);
 				size = i_size >> 9;
 			}
@@ -127,9 +127,9 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 			 * Old style LNX1 or unlabeled disk
 			 */
 			if (strncmp(type, "LNX1", 4) == 0)
-				printk ("LNX1/%8s:", name);
+				print_partition(state, "LNX1/%8s:", name);
 			else
-				printk("(nonl)");
+				print_partition(state, "(nonl)");
 			offset = (info->label_block + 1);
 			size = i_size >> 9;
 		}
@@ -147,7 +147,7 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 		 * if not, something is wrong, skipping partition detection
 		 */
 		if (strncmp(type, "VOL1",  4) == 0) {
-			printk("VOL1/%8s:", name);
+			print_partition(state, "VOL1/%8s:", name);
 			/*
 			 * get block number and read then go through format1
 			 * labels
@@ -203,7 +203,6 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 
 	}
 
-	printk("\n");
 	goto out_freeall;
 
 
diff --git a/fs/partitions/karma.c b/fs/partitions/karma.c
index 176d89b..e85c430 100644
--- a/fs/partitions/karma.c
+++ b/fs/partitions/karma.c
@@ -50,7 +50,6 @@ int karma_partition(struct parsed_partitions *state, struct block_device *bdev)
 		}
 		slot++;
 	}
-	printk("\n");
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index e7dd1d4..ae057d0 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -611,7 +611,7 @@ static struct vblk * ldm_get_disk_objid (const struct ldmdb *ldb)
 
 /**
  * ldm_create_data_partitions - Create data partitions for this device
- * @pp:   List of the partitions parsed so far
+ * @state:   List of the partitions parsed so far
  * @ldb:  Cache of the database structures
  *
  * The database contains ALL the partitions for ALL disk groups, so we need to
@@ -626,7 +626,7 @@ static struct vblk * ldm_get_disk_objid (const struct ldmdb *ldb)
  * Return:  'true'   Partition created
  *          'false'  Error, probably a range checking problem
  */
-static bool ldm_create_data_partitions (struct parsed_partitions *pp,
+static bool ldm_create_data_partitions (struct parsed_partitions *state,
 					const struct ldmdb *ldb)
 {
 	struct list_head *item;
@@ -635,7 +635,7 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
 	struct vblk_part *part;
 	int part_num = 1;
 
-	BUG_ON (!pp || !ldb);
+	BUG_ON (!state || !ldb);
 
 	disk = ldm_get_disk_objid (ldb);
 	if (!disk) {
@@ -643,7 +643,7 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
 		return false;
 	}
 
-	printk (" [LDM]");
+	print_partition(state, " [LDM]");
 
 	/* Create the data partitions */
 	list_for_each (item, &ldb->v_part) {
@@ -653,12 +653,11 @@ static bool ldm_create_data_partitions (struct parsed_partitions *pp,
 		if (part->disk_id != disk->obj_id)
 			continue;
 
-		put_partition (pp, part_num, ldb->ph.logical_disk_start +
+		put_partition(state, part_num, ldb->ph.logical_disk_start +
 				part->start, part->size);
 		part_num++;
 	}
 
-	printk ("\n");
 	return true;
 }
 
diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..44fee83 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -59,7 +59,7 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 		put_dev_sector(sect);
 		return 0;		/* not a MacOS disk */
 	}
-	printk(" [mac]");
+	print_partition(state, " [mac]");
 	blocks_in_map = be32_to_cpu(part->map_count);
 	for (blk = 1; blk <= blocks_in_map; ++blk) {
 		int pos = blk * secsize;
@@ -127,6 +127,5 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 #endif
 
 	put_dev_sector(sect);
-	printk("\n");
 	return 1;
 }
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 5567ec0..63a0085 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -212,9 +212,9 @@ parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <solaris:", state->name, origin);
+	print_partition(state, " %s%d: <solaris:", state->name, origin);
 	if (le32_to_cpu(v->v_version) != 1) {
-		printk("  cannot handle version %d vtoc>\n",
+		print_partition(state, "  cannot handle version %d vtoc>\n",
 			le32_to_cpu(v->v_version));
 		put_dev_sector(sect);
 		return;
@@ -225,7 +225,7 @@ parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
 		struct solaris_x86_slice *s = &v->v_slice[i];
 		if (s->s_size == 0)
 			continue;
-		printk(" [s%d]", i);
+		print_partition(state, " [s%d]", i);
 		/* solaris partitions are relative to current MS-DOS
 		 * one; must add the offset of the current partition */
 		put_partition(state, state->next++,
@@ -233,7 +233,7 @@ parse_solaris_x86(struct parsed_partitions *state, struct block_device *bdev,
 				 le32_to_cpu(s->s_size));
 	}
 	put_dev_sector(sect);
-	printk(" >\n");
+	print_partition(state, " >");
 #endif
 }
 
@@ -258,7 +258,7 @@ parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <%s:", state->name, origin, flavour);
+	print_partition(state, " %s%d: <%s:", state->name, origin, flavour);
 
 	if (le16_to_cpu(l->d_npartitions) < max_partitions)
 		max_partitions = le16_to_cpu(l->d_npartitions);
@@ -275,16 +275,16 @@ parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
 			/* full parent partition, we have it already */
 			continue;
 		if (offset > bsd_start || offset+size < bsd_start+bsd_size) {
-			printk("bad subpartition - ignored\n");
+			printk("bad subpartition %d - ignored\n", p - l->d_partitions);
 			continue;
 		}
 		put_partition(state, state->next++, bsd_start, bsd_size);
 	}
 	put_dev_sector(sect);
 	if (le16_to_cpu(l->d_npartitions) > max_partitions)
-		printk(" (ignored %d more)",
+		print_partition(state, " (ignored %d more)",
 		       le16_to_cpu(l->d_npartitions) - max_partitions);
-	printk(" >\n");
+	print_partition(state, " >");
 }
 #endif
 
@@ -339,7 +339,7 @@ parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
 		put_dev_sector(sect);
 		return;
 	}
-	printk(" %s%d: <unixware:", state->name, origin);
+	print_partition(state, " %s%d: <unixware:", state->name, origin);
 	p = &l->vtoc.v_slice[1];
 	/* I omit the 0th slice as it is the same as whole disk. */
 	while (p - &l->vtoc.v_slice[0] < UNIXWARE_NUMSLICE) {
@@ -352,7 +352,7 @@ parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
 		p++;
 	}
 	put_dev_sector(sect);
-	printk(" >\n");
+	print_partition(state, " >");
 #endif
 }
 
@@ -383,7 +383,7 @@ parse_minix(struct parsed_partitions *state, struct block_device *bdev,
 	if (msdos_magic_present (data + 510) &&
 	    SYS_IND(p) == MINIX_PARTITION) { /* subpartition table present */
 
-		printk(" %s%d: <minix:", state->name, origin);
+		print_partition(state, " %s%d: <minix:", state->name, origin);
 		for (i = 0; i < MINIX_NR_SUBPARTITIONS; i++, p++) {
 			if (state->next == state->limit)
 				break;
@@ -392,7 +392,7 @@ parse_minix(struct parsed_partitions *state, struct block_device *bdev,
 				put_partition(state, state->next++,
 					      START_SECT(p), NR_SECTS(p));
 		}
-		printk(" >\n");
+		print_partition(state, " >");
 	}
 	put_dev_sector(sect);
 #endif /* CONFIG_MINIX_SUBPARTITION */
@@ -431,7 +431,7 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 
 	if (aix_magic_present(data, bdev)) {
 		put_dev_sector(sect);
-		printk( " [AIX]");
+		print_partition(state,  " [AIX]");
 		return 0;
 	}
 
@@ -477,22 +477,20 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 			/* prevent someone doing mkfs or mkswap on an
 			   extended partition, but leave room for LILO */
 			put_partition(state, slot, start, size == 1 ? 1 : 2);
-			printk(" <");
+			print_partition(state, " <");
 			parse_extended(state, bdev, start, size);
-			printk(" >");
+			print_partition(state, " >");
 			continue;
 		}
 		put_partition(state, slot, start, size);
 		if (SYS_IND(p) == LINUX_RAID_PARTITION)
 			state->parts[slot].flags = 1;
 		if (SYS_IND(p) == DM6_PARTITION)
-			printk("[DM]");
+			print_partition(state, "[DM]");
 		if (SYS_IND(p) == EZD_PARTITION)
-			printk("[EZD]");
+			print_partition(state, "[EZD]");
 	}
 
-	printk("\n");
-
 	/* second pass - output for each on a separate line */
 	p = (struct partition *) (0x1be + data);
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
diff --git a/fs/partitions/osf.c b/fs/partitions/osf.c
index c05c17b..634229d 100644
--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
@@ -72,7 +72,6 @@ int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 				le32_to_cpu(partition->p_size));
 		slot++;
 	}
-	printk("\n");
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/fs/partitions/sgi.c b/fs/partitions/sgi.c
index ed5ac83..54b9850 100644
--- a/fs/partitions/sgi.c
+++ b/fs/partitions/sgi.c
@@ -76,7 +76,6 @@ int sgi_partition(struct parsed_partitions *state, struct block_device *bdev)
 		}
 		slot++;
 	}
-	printk("\n");
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/fs/partitions/sun.c b/fs/partitions/sun.c
index c95e6a6..dafe00d 100644
--- a/fs/partitions/sun.c
+++ b/fs/partitions/sun.c
@@ -116,7 +116,6 @@ int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
 		}
 		slot++;
 	}
-	printk("\n");
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/fs/partitions/sysv68.c b/fs/partitions/sysv68.c
index 4eba27b..5ab913b 100644
--- a/fs/partitions/sysv68.c
+++ b/fs/partitions/sysv68.c
@@ -73,7 +73,7 @@ int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
 		return -1;
 
 	slices -= 1; /* last slice is the whole disk */
-	printk("sysV68: %s(s%u)", state->name, slices);
+	print_partition(state, "sysV68: %s(s%u)", state->name, slices);
 	slice = (struct slice *)data;
 	for (i = 0; i < slices; i++, slice++) {
 		if (slot == state->limit)
@@ -82,11 +82,10 @@ int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
 			put_partition(state, slot,
 				be32_to_cpu(slice->blkoff),
 				be32_to_cpu(slice->nblocks));
-			printk("(s%u)", i);
+			print_partition(state, "(s%u)", i);
 		}
 		slot++;
 	}
-	printk("\n");
 	put_dev_sector(sect);
 	return 1;
 }
diff --git a/fs/partitions/ultrix.c b/fs/partitions/ultrix.c
index ec852c1..5b01971 100644
--- a/fs/partitions/ultrix.c
+++ b/fs/partitions/ultrix.c
@@ -39,7 +39,6 @@ int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev)
 					      label->pt_part[i].pi_blkoff,
 					      label->pt_part[i].pi_nblocks);
 		put_dev_sector(sect);
-		printk ("\n");
 		return 1;
 	} else {
 		put_dev_sector(sect);
-- 
1.5.3.4

