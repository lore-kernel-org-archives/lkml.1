Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbXEILXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbXEILXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXEILXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:23:14 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:34937 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXEILXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:23:12 -0400
Date: Wed, 9 May 2007 13:23:15 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] small cleanup in gpt partition handling
Message-ID: <20070509112315.GA14803@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove unused argument in is_pmbr_valid()
Remove unneeded initialization of local variable legacy_mbr

Compile-tested.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 fs/partitions/efi.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -152,7 +152,7 @@ last_lba(struct block_device *bdev)
 }
 
 static inline int
-pmbr_part_valid(struct partition *part, u64 lastlba)
+pmbr_part_valid(struct partition *part)
 {
         if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
             le32_to_cpu(part->start_sect) == 1UL)
@@ -163,7 +163,6 @@ pmbr_part_valid(struct partition *part, 
 /**
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
- * @lastlba: last_lba for the whole device
  *
  * Description: Returns 1 if PMBR is valid, 0 otherwise.
  * Validity depends on two things:
@@ -171,13 +170,13 @@ pmbr_part_valid(struct partition *part, 
  *  2) One partition of type 0xEE is found
  */
 static int
-is_pmbr_valid(legacy_mbr *mbr, u64 lastlba)
+is_pmbr_valid(legacy_mbr *mbr)
 {
 	int i;
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
                 return 0;
 	for (i = 0; i < 4; i++)
-		if (pmbr_part_valid(&mbr->partition_record[i], lastlba))
+		if (pmbr_part_valid(&mbr->partition_record[i]))
                         return 1;
 	return 0;
 }
@@ -516,7 +515,7 @@ find_valid_gpt(struct block_device *bdev
 	int good_pgpt = 0, good_agpt = 0, good_pmbr = 0;
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
-	legacy_mbr *legacymbr = NULL;
+	legacy_mbr *legacymbr;
 	u64 lastlba;
 	if (!bdev || !gpt || !ptes)
 		return 0;
@@ -528,9 +527,8 @@ find_valid_gpt(struct block_device *bdev
                 if (legacymbr) {
                         read_lba(bdev, 0, (u8 *) legacymbr,
                                  sizeof (*legacymbr));
-                        good_pmbr = is_pmbr_valid(legacymbr, lastlba);
+                        good_pmbr = is_pmbr_valid(legacymbr);
                         kfree(legacymbr);
-                        legacymbr=NULL;
                 }
                 if (!good_pmbr)
                         goto fail;
