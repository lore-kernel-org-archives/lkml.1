Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0CBWti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:49:38 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:45667 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0CBWth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:49:37 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2010 17:49:36 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RESUBMIT PATCH] msdos: add support for large disks
Date: Tue, 2 Mar 2010 14:40:06 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD49@wdscexbe01.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RESUBMIT PATCH] msdos: add support for large disks
Thread-Index: Acq6WU8K1eKWRb4+Sem08zoa/CBLdQ==
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
Cc: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
X-OriginalArrivalTime: 02 Mar 2010 22:40:07.0154 (UTC) FILETIME=[4EDE7D20:01CABA59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use disks larger than 2TiB on Windows XP, it is necessary to use
4096-byte logical sectors in an MBR.

Although the kernel storage and functions called from msdos.c used
"sector_t" internally, msdos.c still used u32 variables, which results in
the ability to handle XP-compatible large disks.

This patch changes the internal variables to "sector_t".

Signed-off-by: Daniel Taylor <daniel.taylor@wdc.com> diff --git
a/fs/partitions/msdos.c b/fs/partitions/msdos.c index 0028d2e..039bb61
100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -32,13 +32,20 @@
 #include <asm/unaligned.h>
 
 #define SYS_IND(p)	(get_unaligned(&p->sys_ind))
-#define NR_SECTS(p)	({ __le32 __a =	get_unaligned(&p->nr_sects);	\
-				le32_to_cpu(__a); \
-			})
 
-#define START_SECT(p)	({ __le32 __a =	get_unaligned(&p->start_sect);	\
-				le32_to_cpu(__a); \
-			})
+static inline sector_t nr_sects(struct partition *p) {
+	u32 number_of_sectors = le32_to_cpu(get_unaligned(&p->nr_sects));
+
+	return (sector_t)number_of_sectors;
+}
+
+static inline sector_t start_sect(struct partition *p) {
+	u32 start_sector = le32_to_cpu(get_unaligned(&p->start_sect));
+
+	return (sector_t)start_sector;
+}
 
 static inline int is_extended_partition(struct partition *p)  { @@ -104,13
+111,13 @@ static int aix_magic_present(unsigned char *p, struct
block_device *bdev)
 
 static void
 parse_extended(struct parsed_partitions *state, struct block_device *bdev,
-			u32 first_sector, u32 first_size)
+			sector_t first_sector, sector_t first_size)
 {
 	struct partition *p;
 	Sector sect;
 	unsigned char *data;
-	u32 this_sector, this_size;
-	int sector_size = bdev_logical_block_size(bdev) / 512;
+	sector_t this_sector, this_size;
+	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
 	int loopct = 0;		/* number of links followed
 				   without finding a data partition */
 	int i;
@@ -145,14 +152,14 @@ parse_extended(struct parsed_partitions *state, struct
block_device *bdev,
 		 * First process the data partition(s)
 		 */
 		for (i=0; i<4; i++, p++) {
-			u32 offs, size, next;
-			if (!NR_SECTS(p) || is_extended_partition(p))
+			sector_t offs, size, next;
+			if (!nr_sects(p) || is_extended_partition(p))
 				continue;
 
 			/* Check the 3rd and 4th entries -
 			   these sometimes contain random garbage */
-			offs = START_SECT(p)*sector_size;
-			size = NR_SECTS(p)*sector_size;
+			offs = start_sect(p)*sector_size;
+			size = nr_sects(p)*sector_size;
 			next = this_sector + offs;
 			if (i >= 2) {
 				if (offs + size > this_size)
@@ -179,13 +186,13 @@ parse_extended(struct parsed_partitions *state, struct
block_device *bdev,
 		 */
 		p -= 4;
 		for (i=0; i<4; i++, p++)
-			if (NR_SECTS(p) && is_extended_partition(p))
+			if (nr_sects(p) && is_extended_partition(p))
 				break;
 		if (i == 4)
 			goto done;	 /* nothing left to do */
 
-		this_sector = first_sector + START_SECT(p) * sector_size;
-		this_size = NR_SECTS(p) * sector_size;
+		this_sector = first_sector + start_sect(p) * sector_size;
+		this_size = nr_sects(p) * sector_size;
 		put_dev_sector(sect);
 	}
 done:
@@ -197,7 +204,7 @@ done:
 
 static void
 parse_solaris_x86(struct parsed_partitions *state, struct block_device
*bdev,
-			u32 offset, u32 size, int origin)
+			sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 	Sector sect;
@@ -244,7 +251,7 @@ parse_solaris_x86(struct parsed_partitions *state,
struct block_device *bdev,
  */
 static void
 parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin, char *flavour,
+		sector_t offset, sector_t size, int origin, char *flavour,
 		int max_partitions)
 {
 	Sector sect;
@@ -263,7 +270,7 @@ parse_bsd(struct parsed_partitions *state, struct
block_device *bdev,
 	if (le16_to_cpu(l->d_npartitions) < max_partitions)
 		max_partitions = le16_to_cpu(l->d_npartitions);
 	for (p = l->d_partitions; p - l->d_partitions < max_partitions; p++)
{
-		u32 bsd_start, bsd_size;
+		sector_t bsd_start, bsd_size;
 
 		if (state->next == state->limit)
 			break;
@@ -290,7 +297,7 @@ parse_bsd(struct parsed_partitions *state, struct
block_device *bdev,
 
 static void
 parse_freebsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin, @@ -300,7 +307,7 @@
parse_freebsd(struct parsed_partitions *state, struct block_device *bdev,
 
 static void
 parse_netbsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin, @@ -310,7 +317,7 @@
parse_netbsd(struct parsed_partitions *state, struct block_device *bdev,
 
 static void
 parse_openbsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin, @@ -324,7 +331,7 @@
parse_openbsd(struct parsed_partitions *state, struct block_device *bdev,
  */
 static void
 parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_UNIXWARE_DISKLABEL
 	Sector sect;
@@ -348,7 +355,8 @@ parse_unixware(struct parsed_partitions *state, struct
block_device *bdev,
 
 		if (p->s_label != UNIXWARE_FS_UNUSED)
 			put_partition(state, state->next++,
-						START_SECT(p), NR_SECTS(p));
+				      start_sect((struct partition *)p),
+				      nr_sects((struct partition *)p));
 		p++;
 	}
 	put_dev_sector(sect);
@@ -363,7 +371,7 @@ parse_unixware(struct parsed_partitions *state, struct
block_device *bdev,
  */
 static void
 parse_minix(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_MINIX_SUBPARTITION
 	Sector sect;
@@ -390,7 +398,7 @@ parse_minix(struct parsed_partitions *state, struct
block_device *bdev,
 			/* add each partition in use */
 			if (SYS_IND(p) == MINIX_PARTITION)
 				put_partition(state, state->next++,
-					      START_SECT(p), NR_SECTS(p));
+					      start_sect(p), nr_sects(p));
 		}
 		printk(" >\n");
 	}
@@ -401,7 +409,7 @@ parse_minix(struct parsed_partitions *state, struct
block_device *bdev,  static struct {
 	unsigned char id;
 	void (*parse)(struct parsed_partitions *, struct block_device *,
-			u32, u32, int);
+			sector_t, sector_t, int);
 } subtypes[] = {
 	{FREEBSD_PARTITION, parse_freebsd},
 	{NETBSD_PARTITION, parse_netbsd},
@@ -415,7 +423,7 @@ static struct {
  
 int msdos_partition(struct parsed_partitions *state, struct block_device
*bdev)  {
-	int sector_size = bdev_logical_block_size(bdev) / 512;
+	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
 	Sector sect;
 	unsigned char *data;
 	struct partition *p;
@@ -483,8 +491,8 @@ int msdos_partition(struct parsed_partitions *state,
struct block_device *bdev)
 
 	state->next = 5;
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
-		u32 start = START_SECT(p)*sector_size;
-		u32 size = NR_SECTS(p)*sector_size;
+		sector_t start = start_sect(p)*sector_size;
+		sector_t size = nr_sects(p)*sector_size;
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
@@ -513,7 +521,7 @@ int msdos_partition(struct parsed_partitions *state,
struct block_device *bdev)
 		unsigned char id = SYS_IND(p);
 		int n;
 
-		if (!NR_SECTS(p))
+		if (!nr_sects(p))
 			continue;
 
 		for (n = 0; subtypes[n].parse && id != subtypes[n].id; n++)
@@ -521,8 +529,8 @@ int msdos_partition(struct parsed_partitions *state,
struct block_device *bdev)
 
 		if (!subtypes[n].parse)
 			continue;
-		subtypes[n].parse(state, bdev, START_SECT(p)*sector_size,
-						NR_SECTS(p)*sector_size,
slot);
+		subtypes[n].parse(state, bdev, start_sect(p)*sector_size,
+						nr_sects(p)*sector_size,
slot);
 	}
 	put_dev_sector(sect);
 	return 1;
