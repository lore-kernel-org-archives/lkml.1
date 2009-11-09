Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZKIVh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZKIVh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZKIVh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZKIVhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:37:55 -0500
From: Karel Zak <kzak@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: [PATCH 2/2] partitions: read whole sector with EFI GPT header
Date: Mon,  9 Nov 2009 22:36:51 +0100
Message-Id: <1257802611-9889-2-git-send-email-kzak@redhat.com>
In-Reply-To: <1257802611-9889-1-git-send-email-kzak@redhat.com>
References: <1257802611-9889-1-git-send-email-kzak@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of EFI GPT header is not static, but whole sector is
allocated for the header. The HeaderSize field must be greater
than 92 (= sizeof(struct gpt_header) and must be less than or
equal to the logical block size.

It means we have to read whole sector with the header, because the
header crc32 checksum is calculated according to HeaderSize.

For more details see UEFI standard (version 2.3, May 2009):
  - 5.3.1 GUID Format overview, page 93
  - Table 13. GUID Partition Table Header, page 96

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 fs/partitions/efi.c |    7 ++++---
 fs/partitions/efi.h |    8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index da3f576..58eca76 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -260,15 +260,16 @@ static gpt_header *
 alloc_read_gpt_header(struct block_device *bdev, u64 lba)
 {
 	gpt_header *gpt;
+	unsigned ssz = bdev_logical_block_size(bdev);
+
 	if (!bdev)
 		return NULL;
 
-	gpt = kzalloc(sizeof (gpt_header), GFP_KERNEL);
+	gpt = kzalloc(ssz, GFP_KERNEL);
 	if (!gpt)
 		return NULL;
 
-	if (read_lba(bdev, lba, (u8 *) gpt,
-		     sizeof (gpt_header)) < sizeof (gpt_header)) {
+	if (read_lba(bdev, lba, (u8 *) gpt, ssz) < ssz) {
 		kfree(gpt);
                 gpt=NULL;
 		return NULL;
diff --git a/fs/partitions/efi.h b/fs/partitions/efi.h
index 2cc89d0..6998b58 100644
--- a/fs/partitions/efi.h
+++ b/fs/partitions/efi.h
@@ -37,7 +37,6 @@
 #define EFI_PMBR_OSTYPE_EFI 0xEF
 #define EFI_PMBR_OSTYPE_EFI_GPT 0xEE
 
-#define GPT_BLOCK_SIZE 512
 #define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
@@ -79,7 +78,12 @@ typedef struct _gpt_header {
 	__le32 num_partition_entries;
 	__le32 sizeof_partition_entry;
 	__le32 partition_entry_array_crc32;
-	u8 reserved2[GPT_BLOCK_SIZE - 92];
+
+	/* The rest of the logical block is reserved by UEFI and must be zero.
+	 * EFI standard handles this by:
+	 *
+	 * uint8_t		reserved2[ BlockSize - 92 ];
+	 */
 } __attribute__ ((packed)) gpt_header;
 
 typedef struct _gpt_entry_attributes {
-- 
1.6.2.5

