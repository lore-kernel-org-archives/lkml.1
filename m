Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbZDBPFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbZDBPFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762251AbZDBO67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:58:59 -0400
Received: from ottawa-hs-64-26-147-143.d-ip.magma.ca ([64.26.147.143]:41822
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762198AbZDBO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:58:56 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Cc: Matthew Wilcox <willy@linux.intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 3/5] ata: Add TRIM infrastructure
Date: Thu,  2 Apr 2009 10:37:25 -0400
Message-Id: <1238683047-13588-3-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238683047-13588-2-git-send-email-willy@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
 <1238683047-13588-2-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is common code shared between the IDE and libata implementations

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/ata.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 6617c9f..cb79b7a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -29,6 +29,8 @@
 #ifndef __LINUX_ATA_H__
 #define __LINUX_ATA_H__
 
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
@@ -91,6 +93,7 @@ enum {
 	ATA_ID_CFA_POWER	= 160,
 	ATA_ID_CFA_KEY_MGMT	= 162,
 	ATA_ID_CFA_MODES	= 163,
+	ATA_ID_DATA_SET_MGMT	= 169,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
 
@@ -248,6 +251,7 @@ enum {
 	ATA_CMD_SMART		= 0xB0,
 	ATA_CMD_MEDIA_LOCK	= 0xDE,
 	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
+	ATA_CMD_DSM		= 0x06,
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
 
@@ -321,6 +325,9 @@ enum {
 	ATA_SMART_READ_VALUES	= 0xD0,
 	ATA_SMART_READ_THRESHOLDS = 0xD1,
 
+	/* feature values for Data Set Management */
+	ATA_DSM_TRIM		= 0x01,
+
 	/* password used in LBA Mid / LBA High for executing SMART commands */
 	ATA_SMART_LBAM_PASS	= 0x4F,
 	ATA_SMART_LBAH_PASS	= 0xC2,
@@ -723,6 +730,14 @@ static inline int ata_id_has_unload(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_trim(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_DATA_SET_MGMT] & 1))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -863,6 +878,32 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 #endif
 }
 
+/*
+ * Write up to 'max' LBA Range Entries to the buffer that will cover the
+ * extent from sector to sector + count.  This is used for TRIM and for
+ * ADD LBA(S) TO NV CACHE PINNED SET.
+ */
+static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
+						u64 sector, unsigned long count)
+{
+	__le64 *buffer = _buffer;
+	unsigned i = 0;
+
+	while (i < max) {
+		u64 entry = sector |
+			((u64)(count > 0xffff ? 0xffff : count) << 48);
+		buffer[i++] = __cpu_to_le64(entry);
+		if (count <= 0xffff)
+			break;
+		count -= 0xffff;
+		sector += 0xffff;
+	}
+
+	max = ALIGN(i * 8, 512);
+	memset(buffer + i, 0, max - i * 8);
+	return max;
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
-- 
1.6.2.1

