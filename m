Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYC3Dac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYC3Dac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 23:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYC3DaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 23:30:23 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:45411 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYC3DaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 23:30:22 -0400
Date: Sat, 29 Mar 2008 23:30:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sergey Vlasov <vsu@altlinux.ru>,
       Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
Message-ID: <20080330033006.GD18825@hash.localnet>
References: <1206578760-9050-6-git-send-email-me@bobcopeland.com> <20080327164114.6c9fc82c.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327164114.6c9fc82c.vsu@altlinux.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of this patch, with changes:
 - use lib/crc-itu-t.c instead of open-coded version

>From 6ce3bb9ce2faaf937df0ec8e64c39e1adc403b2e Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 27 Mar 2008 17:23:12 -0400
Subject: [PATCH] omfs: add checksumming routines

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
1.5.4.2.182.gb3092


-- 
Bob Copeland %% www.bobcopeland.com 

