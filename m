Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYDLXBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYDLXBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 19:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbYDLW6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:58:55 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35384 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYDLW6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/7] omfs: add checksumming routines
Date: Sat, 12 Apr 2008 18:58:40 -0400
Message-Id: <1208041121-26787-7-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    OMFS checksums the metadata of all filesystem objects.  This change adds
    the necessary functions to do so.

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/checksum.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/checksum.c

diff --git a/fs/omfs/checksum.c b/fs/omfs/checksum.c
new file mode 100644
index 0000000..cbd0471
--- /dev/null
+++ b/fs/omfs/checksum.c
@@ -0,0 +1,31 @@
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/crc-itu-t.h>
+#include "omfs.h"
+
+/*
+ * Update the header checksums for a dirty inode based on its contents.
+ * Caller is expected to hold the buffer head underlying oi and mark it
+ * dirty.
+ */
+int omfs_update_checksums(struct omfs_inode *oi)
+{
+	int ret = 0;
+	int xor, i, ofs = 0, count;
+	u16 crc = 0;
+	unsigned char *ptr = (unsigned char *) oi;
+
+	count = be32_to_cpu(oi->i_head.h_body_size);
+	ofs = sizeof(struct omfs_header);
+
+	crc = crc_itu_t(crc, ptr + ofs, count);
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
1.5.4.2


