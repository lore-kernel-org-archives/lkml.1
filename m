Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZILCFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZILCFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 22:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZILCFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 22:05:10 -0400
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:40034 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757276AbZILCFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 22:05:08 -0400
X-Yahoo-SMTP: RrAacJSswBBjW0Obe5dhTHj7mfiuboERhd4hX4HvWHq2RmBoxiTUVqFaT6p3
X-YMail-OSG: bGiuA64VM1lcEzxG0IkCXn0tHqBBwi7C2ZppfZp20lxcmp.AkI8.sVIDDLeBE.la4.03sJPcB3YC6WY05w_6tKP2sLqU0g9wN3n2i1tAzrWm9lkF5r.EdYmx7vfb2fO8Hn8oCSkOLdYkuJtEE_a3VgYusHs0dTS9Nx6iTnhIRV_KUgVzcJ2vvfyQS2d.xqWIC7rDD7uq1PQK936QIXOkGrksh88DEHpM5iVR4BkYvyY_24NlSvuvRIRobafY2z.SsvXRc3T9KZKCxepxPFrLF84L_ndiiahd4rKYccFhWwEuGlN1xXTeClL2SG.BpSSUHzZmhAcayvfDHd6i0gYfSfiVYNVq1EZLmmQFaRD6qJ3_Tpt76KeSpNJ2FgudUF8-
X-Yahoo-Newman-Property: ymail-3
Subject: [RFC PATCH 12/19] Target_Core_Mod READ/WRITE command descriptor
	block generation code
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Joel Becker <joel.becker@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@lst.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Florian Haas <florian.haas@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 18:57:28 -0700
Message-Id: <1252720648.2067.220.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC PATCH 12/19] Target_Core_Mod READ/WRITE command descriptor block generation code

This patch adds support for the generation of READ_6, READ_10, READ_12, READ_16,
WRITE_6, WRITE_10, WRITE_12 and WRITE_16 command descriptor blocks when handling
incoming fabric module requests that exceed the max_sectors presented for a storage
object through struct se_subsystem_api_t.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
diff --git a/drivers/target/target_core_scdb.c b/drivers/target/target_core_scdb.c
new file mode 100644
index 0000000..ec111d9
--- /dev/null
+++ b/drivers/target/target_core_scdb.c
@@ -0,0 +1,154 @@
+/*******************************************************************************
+ * Filename:  target_core_scdb.c
+ *
+ * This file contains the generic target engine Split CDB related functions.
+ *
+ * Copyright (c) 2004-2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * Copyright (c) 2007-2009 Rising Tide Software, Inc.
+ * Copyright (c) 2008-2009 Linux-iSCSI.org
+ *
+ * Nicholas A. Bellinger <nab@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ ******************************************************************************/
+
+
+#define TARGET_CORE_SCDB_C
+
+#include <linux/net.h>
+#include <linux/string.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_hba.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_scdb.h>
+
+#undef TARGET_CORE_SCDB_C
+
+/*	split_cdb_XX_6():
+ *
+ *      21-bit LBA w/ 8-bit SECTORS
+ */
+void split_cdb_XX_6(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb)
+{
+	cdb[1] = (lba >> 16) & 0x1f;
+	cdb[2] = (lba >> 8) & 0xff;
+	cdb[3] = lba & 0xff;
+	cdb[4] = *sectors & 0xff;
+}
+
+void split_cdb_RW_6(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb,
+	int rw)
+{
+	cdb[0] = (rw) ? 0x0a : 0x08;
+	split_cdb_XX_6(lba, sectors, &cdb[0]);
+}
+
+/*	split_cdb_XX_10():
+ *
+ *	32-bit LBA w/ 16-bit SECTORS
+ */
+void split_cdb_XX_10(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb)
+{
+	cdb[2] = (lba >> 24) & 0xff;
+	cdb[3] = (lba >> 16) & 0xff;
+	cdb[4] = (lba >> 8) & 0xff;
+	cdb[5] = lba & 0xff;
+	cdb[7] = (*sectors >> 8) & 0xff;
+	cdb[8] = *sectors & 0xff;
+}
+
+void split_cdb_RW_10(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb,
+	int rw)
+{
+	cdb[0] = (rw) ? 0x2a : 0x28;
+	split_cdb_XX_10(lba, sectors, &cdb[0]);
+}
+
+/*	split_cdb_XX_12():
+ *
+ *	32-bit LBA w/ 32-bit SECTORS
+ */
+void split_cdb_XX_12(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb)
+{
+	cdb[2] = (lba >> 24) & 0xff;
+	cdb[3] = (lba >> 16) & 0xff;
+	cdb[4] = (lba >> 8) & 0xff;
+	cdb[5] = lba & 0xff;
+	cdb[6] = (*sectors >> 24) & 0xff;
+	cdb[7] = (*sectors >> 16) & 0xff;
+	cdb[8] = (*sectors >> 8) & 0xff;
+	cdb[9] = *sectors & 0xff;
+}
+
+void split_cdb_RW_12(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb,
+	int rw)
+{
+	cdb[0] = (rw) ? 0xaa : 0xa8;
+	split_cdb_XX_12(lba, sectors, &cdb[0]);
+}
+
+/*	split_cdb_XX_16():
+ *
+ *	64-bit LBA w/ 32-bit SECTORS
+ */
+void split_cdb_XX_16(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb)
+{
+	cdb[2] = (lba >> 56) & 0xff;
+	cdb[3] = (lba >> 48) & 0xff;
+	cdb[4] = (lba >> 40) & 0xff;
+	cdb[5] = (lba >> 32) & 0xff;
+	cdb[6] = (lba >> 24) & 0xff;
+	cdb[7] = (lba >> 16) & 0xff;
+	cdb[8] = (lba >> 8) & 0xff;
+	cdb[9] = lba & 0xff;
+	cdb[10] = (*sectors >> 24) & 0xff;
+	cdb[11] = (*sectors >> 16) & 0xff;
+	cdb[12] = (*sectors >> 8) & 0xff;
+	cdb[13] = *sectors & 0xff;
+}
+
+void split_cdb_RW_16(
+	unsigned long long lba,
+	u32 *sectors,
+	unsigned char *cdb,
+	int rw)
+{
+	cdb[0] = (rw) ? 0x8a : 0x88;
+	split_cdb_XX_16(lba, sectors, &cdb[0]);
+}
diff --git a/include/target/target_core_scdb.h b/include/target/target_core_scdb.h
new file mode 100644
index 0000000..1330bc3
--- /dev/null
+++ b/include/target/target_core_scdb.h
@@ -0,0 +1,42 @@
+/*******************************************************************************
+ * Filename:  target_core_scdb.h
+ *
+ * This file contains the iSCSI Transport Split CDB related definitions.
+ *
+ * Copyright (c) 2004-2005 PyX Technologies, Inc.
+ * Copyright (c) 2005, 2006, 2007 SBE, Inc.
+ * Copyright (c) 2007-2009 Rising Tide Software, Inc.
+ * Copyright (c) 2008-2009 Linux-iSCSI.org
+ *
+ * Nicholas A. Bellinger <nab@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ ******************************************************************************/
+
+
+#ifndef TARGET_CORE_SCDB_H
+#define TARGET_CORE_SCDB_H
+
+extern void split_cdb_XX_6(unsigned long long, u32 *, unsigned char *);
+extern void split_cdb_RW_6(unsigned long long, u32 *, unsigned char *, int);
+extern void split_cdb_XX_10(unsigned long long, u32 *, unsigned char *);
+extern void split_cdb_RW_10(unsigned long long, u32 *, unsigned char *, int);
+extern void split_cdb_XX_12(unsigned long long, u32 *, unsigned char *);
+extern void split_cdb_RW_12(unsigned long long, u32 *, unsigned char *, int);
+extern void split_cdb_XX_16(unsigned long long, u32 *, unsigned char *);
+extern void split_cdb_RW_16(unsigned long long, u32 *, unsigned char *, int);
+
+#endif /* TARGET_CORE_SCDB_H */


