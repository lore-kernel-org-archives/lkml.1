Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYC0BT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYC0BT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 21:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYC0BTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 21:19:16 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:48660 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbYC0BTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 21:19:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/7] omfs: add checksumming routines
Date: Wed, 26 Mar 2008 20:45:59 -0400
Message-Id: <1206578760-9050-6-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMFS checksums the metadata of all filesystem objects.  This change adds
the necessary functions to do so.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/checksum.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/checksum.c

diff --git a/fs/omfs/checksum.c b/fs/omfs/checksum.c
new file mode 100644
index 0000000..d6f1023
--- /dev/null
+++ b/fs/omfs/checksum.c
@@ -0,0 +1,48 @@
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include "omfs.h"
+
+#define POLY 0x1021
+
+/*
+ * crc-ccitt with MSB first (i.e., backwards), so we can't use the
+ * kernel table as-is.
+ */
+static u16 omfs_crc(u16 crc, unsigned char *buf, int count)
+{
+	int i, j;
+	for (i = 0; i < count; i++) {
+		crc ^= buf[i] << 8;
+		for (j = 0; j < 8; j++)
+			crc = (crc << 1) ^ ((crc & 0x8000) ? POLY : 0);
+	}
+	return crc;
+}
+
+/*
+ * Update the header checksums for a dirty inode based on its contents.
+ * Caller is expected to hold the buffer head underlying oi and mark it
+ * dirty.
+ */
+int omfs_update_checksums(struct omfs_inode *oi, struct super_block *sb,
+		ino_t ino)
+{
+	int ret = 0;
+	int xor, i, ofs = 0, count;
+	u16 crc = 0;
+	unsigned char *ptr = (unsigned char *) oi;
+
+	count = be32_to_cpu(oi->i_head.h_body_size);
+	ofs = sizeof(struct omfs_header);
+
+	crc = omfs_crc(crc, ptr + ofs, count);
+	oi->i_head.h_crc = cpu_to_be16(crc);
+
+	xor = ptr[0];
+	for (i = 1; i < OMFS_XOR_COUNT; i++)
+		xor ^= ptr[i];
+
+	oi->i_head.h_check_xor = xor;
+
+	return ret;
+}
-- 
1.5.4.2.182.gb3092


