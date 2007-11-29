Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXLFMpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXLFMpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXLFMmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:43 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53706 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbXLFMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:12 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <d7bc4025253f0f2df8f6ad0554e2340b9cc53197.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:58:06 +0100
Subject: [PATCH 10/47] Merge axisflashmap.h with Axis internal changes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add partition table struct to be used to parse partition table in flash.
- Add JFFS2 as a type, and add readoly flag.
- Improve some comments.
- Lindent has been run, fixing whitespace and formatting issues.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/axisflashmap.h |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/asm-cris/axisflashmap.h b/include/asm-cris/axisflashmap.h
index 7a8d311..015ca54 100644
--- a/include/asm-cris/axisflashmap.h
+++ b/include/asm-cris/axisflashmap.h
@@ -10,23 +10,23 @@
  */
 
 #define PARTITION_TABLE_OFFSET 10
-#define PARTITION_TABLE_MAGIC 0xbeef /* Not a good magic */
+#define PARTITION_TABLE_MAGIC 0xbeef	/* Not a good magic */
 
 /* The partitiontable_head is located at offset +10: */
 struct partitiontable_head {
-	__u16 magic; /* PARTITION_TABLE_MAGIC */ 
-	__u16 size;  /* Length of ptable block (not header) */
-	__u32 checksum; /* simple longword sum */
+	__u16 magic;	/* PARTITION_TABLE_MAGIC */
+	__u16 size;	/* Length of ptable block (entries + end marker) */
+	__u32 checksum;	/* simple longword sum, over entries + end marker  */
 };
 
 /* And followed by partition table entries */
 struct partitiontable_entry {
-	__u32 offset;   /* Offset is relative to the sector the ptable is in */
-	__u32 size;
-	__u32 checksum; /* simple longword sum */
-	__u16 type;
-	__u16 flags;   /* bit 0: ro/rw = 1/0 */
-	__u32 future0; /* 16 bytes reserved for future use */
+	__u32 offset;		/* relative to the sector the ptable is in */
+	__u32 size;		/* in bytes */
+	__u32 checksum;		/* simple longword sum */
+	__u16 type;		/* see type codes below */
+	__u16 flags;		/* bit 0: ro/rw = 1/0 */
+	__u32 future0;		/* 16 bytes reserved for future use */
 	__u32 future1;
 	__u32 future2;
 	__u32 future3;
@@ -35,12 +35,27 @@ struct partitiontable_entry {
 #define PARTITIONTABLE_END_MARKER 0xFFFFFFFF
 #define PARTITIONTABLE_END_MARKER_SIZE 4
 
-/*#define PARTITION_TYPE_RESCUE 0x0000?*/  /* Not used, maybe it should? */
+#define PARTITIONTABLE_END_PAD	10
+
+/* Complete structure for whole partition table */
+/* note that table may end before CONFIG_ETRAX_PTABLE_ENTRIES by setting
+ * offset of the last entry + 1 to PARTITIONTABLE_END_MARKER.
+ */
+struct partitiontable {
+	__u8 skip[PARTITION_TABLE_OFFSET];
+	struct partitiontable_head head;
+	struct partitiontable_entry entries[];
+};
+
 #define PARTITION_TYPE_PARAM  0x0001
 #define PARTITION_TYPE_KERNEL 0x0002
 #define PARTITION_TYPE_JFFS   0x0003
+#define PARTITION_TYPE_JFFS2  0x0000
+
+#define	PARTITION_FLAGS_READONLY_MASK	0x0001
+#define	PARTITION_FLAGS_READONLY	0x0001
 
 /* The master mtd for the entire flash. */
-extern struct mtd_info* axisflash_mtd;
+extern struct mtd_info *axisflash_mtd;
 
 #endif
-- 
1.5.3.6.970.gd25430

