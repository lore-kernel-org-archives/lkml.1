Return-Path: <linux-kernel-owner+w=401wt.eu-S965924AbYEBTJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965924AbYEBTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965182AbYEBTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:38960 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169AbYEBTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nMwSk5e7e4Y7JxKMtAdDOQY9UPAISUl8tqKm+HK1HHcFEIeYkf/ti0WvUch067yZUV5RU3DVaY3sn/awp0C8IqZBeHSK2uFer70kP7BLam6JBMTwb6hrciRPRgth7bCKpi9V2rIoxS38CDseARCPhaGXKo61wz0f7gISyYmnggY=
Subject: [PATCH 07/14] fs: ldm.[ch] use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:57 -0700
Message-Id: <1209755157.26173.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the private BE16/BE32/BE64 macros with direct calls to
get_unaligned_be16/32/64.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/partitions/ldm.c |   70 +++++++++++++++++++++++++-------------------------
 fs/partitions/ldm.h |    5 ---
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 0fdda2e..8652fb9 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -133,17 +133,17 @@ static bool ldm_parse_privhead(const u8 *data, struct privhead *ph)
 	bool is_vista = false;
 
 	BUG_ON(!data || !ph);
-	if (MAGIC_PRIVHEAD != BE64(data)) {
+	if (MAGIC_PRIVHEAD != get_unaligned_be64(data)) {
 		ldm_error("Cannot find PRIVHEAD structure. LDM database is"
 			" corrupt. Aborting.");
 		return false;
 	}
-	ph->ver_major = BE16(data + 0x000C);
-	ph->ver_minor = BE16(data + 0x000E);
-	ph->logical_disk_start = BE64(data + 0x011B);
-	ph->logical_disk_size = BE64(data + 0x0123);
-	ph->config_start = BE64(data + 0x012B);
-	ph->config_size = BE64(data + 0x0133);
+	ph->ver_major = get_unaligned_be16(data + 0x000C);
+	ph->ver_minor = get_unaligned_be16(data + 0x000E);
+	ph->logical_disk_start = get_unaligned_be64(data + 0x011B);
+	ph->logical_disk_size = get_unaligned_be64(data + 0x0123);
+	ph->config_start = get_unaligned_be64(data + 0x012B);
+	ph->config_size = get_unaligned_be64(data + 0x0133);
 	/* Version 2.11 is Win2k/XP and version 2.12 is Vista. */
 	if (ph->ver_major == 2 && ph->ver_minor == 12)
 		is_vista = true;
@@ -191,14 +191,14 @@ static bool ldm_parse_tocblock (const u8 *data, struct tocblock *toc)
 {
 	BUG_ON (!data || !toc);
 
-	if (MAGIC_TOCBLOCK != BE64 (data)) {
+	if (MAGIC_TOCBLOCK != get_unaligned_be64(data)) {
 		ldm_crit ("Cannot find TOCBLOCK, database may be corrupt.");
 		return false;
 	}
 	strncpy (toc->bitmap1_name, data + 0x24, sizeof (toc->bitmap1_name));
 	toc->bitmap1_name[sizeof (toc->bitmap1_name) - 1] = 0;
-	toc->bitmap1_start = BE64 (data + 0x2E);
-	toc->bitmap1_size  = BE64 (data + 0x36);
+	toc->bitmap1_start = get_unaligned_be64(data + 0x2E);
+	toc->bitmap1_size  = get_unaligned_be64(data + 0x36);
 
 	if (strncmp (toc->bitmap1_name, TOC_BITMAP1,
 			sizeof (toc->bitmap1_name)) != 0) {
@@ -208,8 +208,8 @@ static bool ldm_parse_tocblock (const u8 *data, struct tocblock *toc)
 	}
 	strncpy (toc->bitmap2_name, data + 0x46, sizeof (toc->bitmap2_name));
 	toc->bitmap2_name[sizeof (toc->bitmap2_name) - 1] = 0;
-	toc->bitmap2_start = BE64 (data + 0x50);
-	toc->bitmap2_size  = BE64 (data + 0x58);
+	toc->bitmap2_start = get_unaligned_be64(data + 0x50);
+	toc->bitmap2_size  = get_unaligned_be64(data + 0x58);
 	if (strncmp (toc->bitmap2_name, TOC_BITMAP2,
 			sizeof (toc->bitmap2_name)) != 0) {
 		ldm_crit ("TOCBLOCK's second bitmap is '%s', should be '%s'.",
@@ -237,22 +237,22 @@ static bool ldm_parse_vmdb (const u8 *data, struct vmdb *vm)
 {
 	BUG_ON (!data || !vm);
 
-	if (MAGIC_VMDB != BE32 (data)) {
+	if (MAGIC_VMDB != get_unaligned_be32(data)) {
 		ldm_crit ("Cannot find the VMDB, database may be corrupt.");
 		return false;
 	}
 
-	vm->ver_major = BE16 (data + 0x12);
-	vm->ver_minor = BE16 (data + 0x14);
+	vm->ver_major = get_unaligned_be16(data + 0x12);
+	vm->ver_minor = get_unaligned_be16(data + 0x14);
 	if ((vm->ver_major != 4) || (vm->ver_minor != 10)) {
 		ldm_error ("Expected VMDB version %d.%d, got %d.%d. "
 			"Aborting.", 4, 10, vm->ver_major, vm->ver_minor);
 		return false;
 	}
 
-	vm->vblk_size     = BE32 (data + 0x08);
-	vm->vblk_offset   = BE32 (data + 0x0C);
-	vm->last_vblk_seq = BE32 (data + 0x04);
+	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
+	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
 	ldm_debug ("Parsed VMDB successfully.");
 	return true;
@@ -507,7 +507,7 @@ static bool ldm_validate_vmdb (struct block_device *bdev, unsigned long base,
 		goto out;				/* Already logged */
 
 	/* Are there uncommitted transactions? */
-	if (BE16(data + 0x10) != 0x01) {
+	if (get_unaligned_be16(data + 0x10) != 0x01) {
 		ldm_crit ("Database is not in a consistent state.  Aborting.");
 		goto out;
 	}
@@ -802,7 +802,7 @@ static bool ldm_parse_cmp3 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	len += VBLK_SIZE_CMP3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	comp = &vb->vblk.comp;
@@ -851,7 +851,7 @@ static int ldm_parse_dgr3 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	len += VBLK_SIZE_DGR3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	dgrp = &vb->vblk.dgrp;
@@ -895,7 +895,7 @@ static bool ldm_parse_dgr4 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	len += VBLK_SIZE_DGR4;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	dgrp = &vb->vblk.dgrp;
@@ -931,7 +931,7 @@ static bool ldm_parse_dsk3 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	len += VBLK_SIZE_DSK3;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	disk = &vb->vblk.disk;
@@ -968,7 +968,7 @@ static bool ldm_parse_dsk4 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	len += VBLK_SIZE_DSK4;
-	if (len != BE32 (buffer + 0x14))
+	if (len != get_unaligned_be32(buffer + 0x14))
 		return false;
 
 	disk = &vb->vblk.disk;
@@ -1034,14 +1034,14 @@ static bool ldm_parse_prt3(const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 	}
 	len += VBLK_SIZE_PRT3;
-	if (len > BE32(buffer + 0x14)) {
+	if (len > get_unaligned_be32(buffer + 0x14)) {
 		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
-				BE32(buffer + 0x14));
+				get_unaligned_be32(buffer + 0x14));
 		return false;
 	}
 	part = &vb->vblk.part;
-	part->start = BE64(buffer + 0x24 + r_name);
-	part->volume_offset = BE64(buffer + 0x2C + r_name);
+	part->start = get_unaligned_be64(buffer + 0x24 + r_name);
+	part->volume_offset = get_unaligned_be64(buffer + 0x2C + r_name);
 	part->size = ldm_get_vnum(buffer + 0x34 + r_name);
 	part->parent_id = ldm_get_vnum(buffer + 0x34 + r_size);
 	part->disk_id = ldm_get_vnum(buffer + 0x34 + r_parent);
@@ -1139,9 +1139,9 @@ static bool ldm_parse_vol5(const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 	}
 	len += VBLK_SIZE_VOL5;
-	if (len > BE32(buffer + 0x14)) {
+	if (len > get_unaligned_be32(buffer + 0x14)) {
 		ldm_error("len %d > BE32(buffer + 0x14) %d", len,
-				BE32(buffer + 0x14));
+				get_unaligned_be32(buffer + 0x14));
 		return false;
 	}
 	volu = &vb->vblk.volu;
@@ -1294,9 +1294,9 @@ static bool ldm_frag_add (const u8 *data, int size, struct list_head *frags)
 
 	BUG_ON (!data || !frags);
 
-	group = BE32 (data + 0x08);
-	rec   = BE16 (data + 0x0C);
-	num   = BE16 (data + 0x0E);
+	group = get_unaligned_be32(data + 0x08);
+	rec   = get_unaligned_be16(data + 0x0C);
+	num   = get_unaligned_be16(data + 0x0E);
 	if ((num < 1) || (num > 4)) {
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
@@ -1425,12 +1425,12 @@ static bool ldm_get_vblks (struct block_device *bdev, unsigned long base,
 		}
 
 		for (v = 0; v < perbuf; v++, data+=size) {  /* For each vblk */
-			if (MAGIC_VBLK != BE32 (data)) {
+			if (MAGIC_VBLK != get_unaligned_be32(data)) {
 				ldm_error ("Expected to find a VBLK.");
 				goto out;
 			}
 
-			recs = BE16 (data + 0x0E);	/* Number of records */
+			recs = get_unaligned_be16(data + 0x0E);	/* Number of records */
 			if (recs == 1) {
 				if (!ldm_ldmdb_add (data, size, ldb))
 					goto out;	/* Already logged */
diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
index 80f63b5..30e08e8 100644
--- a/fs/partitions/ldm.h
+++ b/fs/partitions/ldm.h
@@ -98,11 +98,6 @@ struct parsed_partitions;
 #define TOC_BITMAP1		"config"	/* Names of the two defined */
 #define TOC_BITMAP2		"log"		/* bitmaps in the TOCBLOCK. */
 
-/* Most numbers we deal with are big-endian and won't be aligned. */
-#define BE16(x)			((u16)be16_to_cpu(get_unaligned((__be16*)(x))))
-#define BE32(x)			((u32)be32_to_cpu(get_unaligned((__be32*)(x))))
-#define BE64(x)			((u64)be64_to_cpu(get_unaligned((__be64*)(x))))
-
 /* Borrowed from msdos.c */
 #define SYS_IND(p)		(get_unaligned(&(p)->sys_ind))
 
-- 
1.5.5.1.350.gbbbf


