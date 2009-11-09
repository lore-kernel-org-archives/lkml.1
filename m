Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZKIVhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZKIVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZKIVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:37:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZKIVhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:37:34 -0500
From: Karel Zak <kzak@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: [PATCH 1/2] partitions: use sector size for EFI GPT
Date: Mon,  9 Nov 2009 22:36:50 +0100
Message-Id: <1257802611-9889-1-git-send-email-kzak@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
That's wrong.

UEFI standard (version 2.3, May 2009, 5.3.1 GUID Format overview, page
95) defines that LBA is always based on the logical block size. It
means bdev_logical_block_size() (aka BLKSSZGET) for Linux.

This patch removes static sector size from EFI GPT parser.

The problem is reproducible with the latest GNU Parted:

 # modprobe scsi_debug dev_size_mb=50 sector_size=4096

  # ./parted /dev/sdb print
  Model: Linux scsi_debug (scsi)
  Disk /dev/sdb: 52.4MB
  Sector size (logical/physical): 4096B/4096B
  Partition Table: gpt

  Number  Start   End     Size    File system  Name     Flags
   1      24.6kB  3002kB  2978kB               primary
   2      3002kB  6001kB  2998kB               primary
   3      6001kB  9003kB  3002kB               primary

  # blockdev --rereadpt /dev/sdb
  # dmesg | tail -1
   sdb: unknown partition table      <---- !!!

with this patch:

  # blockdev --rereadpt /dev/sdb
  # dmesg | tail -1
   sdb: sdb1 sdb2 sdb3

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 fs/partitions/efi.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 038a602..da3f576 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -1,7 +1,9 @@
 /************************************************************
  * EFI GUID Partition Table handling
- * Per Intel EFI Specification v1.02
- * http://developer.intel.com/technology/efi/efi.htm
+ *
+ * http://www.uefi.org/specs/
+ * http://www.intel.com/technology/efi/
+ *
  * efi.[ch] by Matt Domsch <Matt_Domsch@dell.com>
  *   Copyright 2000,2001,2002,2004 Dell Inc.
  *
@@ -141,7 +143,7 @@ last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return (bdev->bd_inode->i_size >> 9) - 1ULL;
+	return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;
 }
 
 static inline int
@@ -188,6 +190,7 @@ static size_t
 read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 {
 	size_t totalreadcount = 0;
+	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
 
 	if (!bdev || !buffer || lba > last_lba(bdev))
                 return 0;
@@ -195,7 +198,7 @@ read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 	while (count) {
 		int copied = 512;
 		Sector sect;
-		unsigned char *data = read_dev_sector(bdev, lba++, &sect);
+		unsigned char *data = read_dev_sector(bdev, n++, &sect);
 		if (!data)
 			break;
 		if (copied > count)
@@ -601,6 +604,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
 	u32 i;
+	unsigned ssz = bdev_logical_block_size(bdev) / 512;
 
 	if (!find_valid_gpt(bdev, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -611,13 +615,14 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+		u64 start = le64_to_cpu(ptes[i].starting_lba);
+		u64 size = le64_to_cpu(ptes[i].ending_lba) -
+			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
+
 		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
 			continue;
 
-		put_partition(state, i+1, le64_to_cpu(ptes[i].starting_lba),
-				 (le64_to_cpu(ptes[i].ending_lba) -
-                                  le64_to_cpu(ptes[i].starting_lba) +
-				  1ULL));
+		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
-- 
1.6.2.5

