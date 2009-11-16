Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZKPM05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZKPM05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZKPM04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:26:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZKPMUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:20:04 -0500
Date: Mon, 16 Nov 2009 13:19:57 +0100
From: Karel Zak <kzak@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mmotm-1113: efi.c:  __divdi3 undefined (i386)
Message-ID: <20091116121957.GF10245@nb.net.home>
References: <4B004C87.7010406@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B004C87.7010406@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 10:46:31AM -0800, Randy Dunlap wrote:
> on i386 builds:
> 
> fs/built-in.o: In function `last_lba':
> efi.c:(.text+0x9d9fe): undefined reference to `__divdi3'
> 
> 
> -       return (bdev->bd_inode->i_size >> 9) - 1ULL;
> +       return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;

 Ah.. I guess that div_u64() is more portable. Updated
 partitions-use-sector-size-for-efi-gpt.patch is below.

    Karel


>From fbb0c11cf349545f2499d382469749543fdc03d0 Mon Sep 17 00:00:00 2001
From: Karel Zak <kzak@redhat.com>
Date: Mon, 16 Nov 2009 12:19:25 +0100
Subject: [PATCH] partitions: use sector size for EFI GPT

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
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/partitions/efi.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 038a602..80eeff5 100644
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
@@ -92,6 +94,7 @@
  *
  ************************************************************/
 #include <linux/crc32.h>
+#include <linux/math64.h>
 #include "check.h"
 #include "efi.h"
 
@@ -141,7 +144,8 @@ last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return (bdev->bd_inode->i_size >> 9) - 1ULL;
+	return div_u64(bdev->bd_inode->i_size,
+		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
 static inline int
@@ -188,6 +192,7 @@ static size_t
 read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 {
 	size_t totalreadcount = 0;
+	sector_t n = lba * (bdev_logical_block_size(bdev) / 512);
 
 	if (!bdev || !buffer || lba > last_lba(bdev))
                 return 0;
@@ -195,7 +200,7 @@ read_lba(struct block_device *bdev, u64 lba, u8 * buffer, size_t count)
 	while (count) {
 		int copied = 512;
 		Sector sect;
-		unsigned char *data = read_dev_sector(bdev, lba++, &sect);
+		unsigned char *data = read_dev_sector(bdev, n++, &sect);
 		if (!data)
 			break;
 		if (copied > count)
@@ -601,6 +606,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
 	u32 i;
+	unsigned ssz = bdev_logical_block_size(bdev) / 512;
 
 	if (!find_valid_gpt(bdev, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -611,13 +617,14 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
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
1.6.5.1


