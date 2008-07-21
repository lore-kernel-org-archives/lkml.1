Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYGUUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYGUUv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGUUvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:51:20 -0400
Received: from www.tglx.de ([62.245.132.106]:41786 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYGUUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:51:19 -0400
Date: Mon, 21 Jul 2008 22:50:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, mdomsch@dell.com
Subject: [PATCH] fs/partitions/efi: convert to pr_debug
Message-ID: <alpine.LFD.1.10.0807212242010.4316@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert the local Dprintk() compile time debug printk wrappers to the
generic pr_debug() wrapper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index e7b0700..038a602 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -95,13 +95,6 @@
 #include "check.h"
 #include "efi.h"
 
-#undef EFI_DEBUG
-#ifdef EFI_DEBUG
-#define Dprintk(x...) printk(KERN_DEBUG x)
-#else
-#define Dprintk(x...)
-#endif
-
 /* This allows a kernel command line option 'gpt' to override
  * the test for invalid PMBR.  Not __initdata because reloading
  * the partition tables happens after init too.
@@ -305,10 +298,10 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 
 	/* Check the GUID Partition Table signature */
 	if (le64_to_cpu((*gpt)->signature) != GPT_HEADER_SIGNATURE) {
-		Dprintk("GUID Partition Table Header signature is wrong:"
-			"%lld != %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->signature),
-			(unsigned long long)GPT_HEADER_SIGNATURE);
+		pr_debug("GUID Partition Table Header signature is wrong:"
+			 "%lld != %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->signature),
+			 (unsigned long long)GPT_HEADER_SIGNATURE);
 		goto fail;
 	}
 
@@ -318,9 +311,8 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 	crc = efi_crc32((const unsigned char *) (*gpt), le32_to_cpu((*gpt)->header_size));
 
 	if (crc != origcrc) {
-		Dprintk
-		    ("GUID Partition Table Header CRC is wrong: %x != %x\n",
-		     crc, origcrc);
+		pr_debug("GUID Partition Table Header CRC is wrong: %x != %x\n",
+			 crc, origcrc);
 		goto fail;
 	}
 	(*gpt)->header_crc32 = cpu_to_le32(origcrc);
@@ -328,9 +320,9 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 	/* Check that the my_lba entry points to the LBA that contains
 	 * the GUID Partition Table */
 	if (le64_to_cpu((*gpt)->my_lba) != lba) {
-		Dprintk("GPT my_lba incorrect: %lld != %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->my_lba),
-			(unsigned long long)lba);
+		pr_debug("GPT my_lba incorrect: %lld != %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->my_lba),
+			 (unsigned long long)lba);
 		goto fail;
 	}
 
@@ -339,15 +331,15 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 	 */
 	lastlba = last_lba(bdev);
 	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
-		Dprintk("GPT: first_usable_lba incorrect: %lld > %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
-			(unsigned long long)lastlba);
+		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
+			 (unsigned long long)lastlba);
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) > lastlba) {
-		Dprintk("GPT: last_usable_lba incorrect: %lld > %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
-			(unsigned long long)lastlba);
+		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
+			 (unsigned long long)lastlba);
 		goto fail;
 	}
 
@@ -360,7 +352,7 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 			le32_to_cpu((*gpt)->sizeof_partition_entry));
 
 	if (crc != le32_to_cpu((*gpt)->partition_entry_array_crc32)) {
-		Dprintk("GUID Partitition Entry Array CRC check failed.\n");
+		pr_debug("GUID Partitition Entry Array CRC check failed.\n");
 		goto fail_ptes;
 	}
 
@@ -616,7 +608,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 		return 0;
 	}
 
-	Dprintk("GUID Partition Table is valid!  Yea!\n");
+	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
 		if (!is_pte_valid(&ptes[i], last_lba(bdev)))

