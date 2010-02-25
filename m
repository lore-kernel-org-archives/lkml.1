Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab0BYD1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:27:16 -0500
Received: from wdscspam1.wdc.com ([129.253.170.130]:50072 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0BYD1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:27:15 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 22:27:15 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] msdos: add support for large disks
Date: Wed, 24 Feb 2010 19:17:47 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msdos: add support for large disks
Thread-Index: Acq1yRuJtBa22zd8SqGnR4Rivps+RA==
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Feb 2010 03:17:48.0170 (UTC) FILETIME=[1B2146A0:01CAB5C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use disks larger than 2TiB on Windows XP, it is necessary to use
4096-byte logical sectors in an MBR.

Although the kernel storage and functions called from msdos.c used
"sector_t" internally, msdos.c still used u32 variables, which results in
the ability to handle XP-compatible large disks.

This patch changes the internal variables to "sector_t".

Signed-off-by: Daniel Taylor <daniel.taylor@wdc.com>
---
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 0028d2e..fa9c77d 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -104,12 +104,12 @@ static int aix_magic_present(unsigned char *p, struct
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
+	sector_t this_sector, this_size;
 	int sector_size = bdev_logical_block_size(bdev) / 512;
 	int loopct = 0;		/* number of links followed
 				   without finding a data partition */
@@ -145,15 +145,16 @@ parse_extended(struct parsed_partitions *state, struct
block_device *bdev,
 		 * First process the data partition(s)
 		 */
 		for (i=0; i<4; i++, p++) {
-			u32 offs, size, next;
+			sector_t offs, size, next;
 			if (!NR_SECTS(p) || is_extended_partition(p))
 				continue;
 
 			/* Check the 3rd and 4th entries -
 			   these sometimes contain random garbage */
-			offs = START_SECT(p)*sector_size;
-			size = NR_SECTS(p)*sector_size;
+			offs =
(sector_t)(START_SECT(p))*(sector_t)(sector_size);
+			size =
(sector_t)(NR_SECTS(p))*(sector_t)(sector_size);
 			next = this_sector + offs;
+
 			if (i >= 2) {
 				if (offs + size > this_size)
 					continue;
@@ -184,8 +185,8 @@ parse_extended(struct parsed_partitions *state, struct
block_device *bdev,
 		if (i == 4)
 			goto done;	 /* nothing left to do */
 
-		this_sector = first_sector + START_SECT(p) * sector_size;
-		this_size = NR_SECTS(p) * sector_size;
+		this_sector = first_sector + (sector_t)(START_SECT(p)) *
sector_size;
+		this_size = (sector_t)(NR_SECTS(p)) *
(sector_t)(sector_size);
 		put_dev_sector(sect);
 	}
 done:
@@ -197,7 +198,7 @@ done:
 
 static void
 parse_solaris_x86(struct parsed_partitions *state, struct block_device
*bdev,
-			u32 offset, u32 size, int origin)
+			sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 	Sector sect;
@@ -244,7 +245,7 @@ parse_solaris_x86(struct parsed_partitions *state,
struct block_device *bdev,
  */
 static void
 parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin, char *flavour,
+		sector_t offset, sector_t size, int origin, char *flavour,
 		int max_partitions)
 {
 	Sector sect;
@@ -263,14 +264,14 @@ parse_bsd(struct parsed_partitions *state, struct
block_device *bdev,
 	if (le16_to_cpu(l->d_npartitions) < max_partitions)
 		max_partitions = le16_to_cpu(l->d_npartitions);
 	for (p = l->d_partitions; p - l->d_partitions < max_partitions; p++)
{
-		u32 bsd_start, bsd_size;
+		sector_t bsd_start, bsd_size;
 
 		if (state->next == state->limit)
 			break;
 		if (p->p_fstype == BSD_FS_UNUSED) 
 			continue;
-		bsd_start = le32_to_cpu(p->p_offset);
-		bsd_size = le32_to_cpu(p->p_size);
+		bsd_start = (sector_t)(le32_to_cpu(p->p_offset));
+		bsd_size = (sector_t)(le32_to_cpu(p->p_size));
 		if (offset == bsd_start && size == bsd_size)
 			/* full parent partition, we have it already */
 			continue;
@@ -290,7 +291,7 @@ parse_bsd(struct parsed_partitions *state, struct
block_device *bdev,
 
 static void
 parse_freebsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin,
@@ -300,7 +301,7 @@ parse_freebsd(struct parsed_partitions *state, struct
block_device *bdev,
 
 static void
 parse_netbsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin,
@@ -310,7 +311,7 @@ parse_netbsd(struct parsed_partitions *state, struct
block_device *bdev,
 
 static void
 parse_openbsd(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_BSD_DISKLABEL
 	parse_bsd(state, bdev, offset, size, origin,
@@ -324,7 +325,7 @@ parse_openbsd(struct parsed_partitions *state, struct
block_device *bdev,
  */
 static void
 parse_unixware(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_UNIXWARE_DISKLABEL
 	Sector sect;
@@ -363,7 +364,7 @@ parse_unixware(struct parsed_partitions *state, struct
block_device *bdev,
  */
 static void
 parse_minix(struct parsed_partitions *state, struct block_device *bdev,
-		u32 offset, u32 size, int origin)
+		sector_t offset, sector_t size, int origin)
 {
 #ifdef CONFIG_MINIX_SUBPARTITION
 	Sector sect;
@@ -401,7 +402,7 @@ parse_minix(struct parsed_partitions *state, struct
block_device *bdev,
 static struct {
 	unsigned char id;
 	void (*parse)(struct parsed_partitions *, struct block_device *,
-			u32, u32, int);
+			sector_t, sector_t, int);
 } subtypes[] = {
 	{FREEBSD_PARTITION, parse_freebsd},
 	{NETBSD_PARTITION, parse_netbsd},
@@ -483,8 +484,8 @@ int msdos_partition(struct parsed_partitions *state,
struct block_device *bdev)
 
 	state->next = 5;
 	for (slot = 1 ; slot <= 4 ; slot++, p++) {
-		u32 start = START_SECT(p)*sector_size;
-		u32 size = NR_SECTS(p)*sector_size;
+		sector_t start =
(sector_t)(START_SECT(p))*(sector_t)(sector_size);
+		sector_t size =
(sector_t)(NR_SECTS(p))*(sector_t)(sector_size);
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
@@ -521,8 +522,8 @@ int msdos_partition(struct parsed_partitions *state,
struct block_device *bdev)
 
 		if (!subtypes[n].parse)
 			continue;
-		subtypes[n].parse(state, bdev, START_SECT(p)*sector_size,
-						NR_SECTS(p)*sector_size,
slot);
+		subtypes[n].parse(state, bdev,
(sector_t)(START_SECT(p))*(sector_t)(sector_size),
+
(sector_t)(NR_SECTS(p))*(sector_t)(sector_size), slot);
 	}
 	put_dev_sector(sect);
 	return 1;

