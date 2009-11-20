Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZKTUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZKTUW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZKTUW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:22:26 -0500
Received: from lazybastard.de ([212.112.238.170]:48496 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZKTUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:22:22 -0500
X-Greylist: delayed 2707 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 15:22:22 EST
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
From: Joern Engel <joern@logfs.org>
Subject: [PATCH 2/17] [LogFS] compr.c
References: <20091120181113.GA2159@logfs.org>
Message-Id: <E1NBZID-0003fS-OP@longford.logfs.org>
Date: Fri, 20 Nov 2009 20:37:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/logfs/compr.c                    |   95 ++

diff --git a/fs/logfs/compr.c b/fs/logfs/compr.c
new file mode 100644
index 0000000..44bbfd2
--- /dev/null
+++ b/fs/logfs/compr.c
@@ -0,0 +1,95 @@
+/*
+ * fs/logfs/compr.c	- compression routines
+ *
+ * As should be obvious for Linux kernel code, license is GPLv2
+ *
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
+ */
+#include "logfs.h"
+#include <linux/vmalloc.h>
+#include <linux/zlib.h>
+
+#define COMPR_LEVEL 3
+
+static DEFINE_MUTEX(compr_mutex);
+static struct z_stream_s stream;
+
+int logfs_compress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	mutex_lock(&compr_mutex);
+	err = zlib_deflateInit(&stream, COMPR_LEVEL);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_deflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_deflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	if (stream.total_out >= stream.total_in)
+		goto error;
+
+	ret = stream.total_out;
+error:
+	mutex_unlock(&compr_mutex);
+	return ret;
+}
+
+int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int err, ret;
+
+	ret = -EIO;
+	mutex_lock(&compr_mutex);
+	err = zlib_inflateInit(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	stream.next_in = in;
+	stream.avail_in = inlen;
+	stream.total_in = 0;
+	stream.next_out = out;
+	stream.avail_out = outlen;
+	stream.total_out = 0;
+
+	err = zlib_inflate(&stream, Z_FINISH);
+	if (err != Z_STREAM_END)
+		goto error;
+
+	err = zlib_inflateEnd(&stream);
+	if (err != Z_OK)
+		goto error;
+
+	ret = 0;
+error:
+	mutex_unlock(&compr_mutex);
+	return ret;
+}
+
+int __init logfs_compr_init(void)
+{
+	size_t size = max(zlib_deflate_workspacesize(),
+			zlib_inflate_workspacesize());
+	stream.workspace = vmalloc(size);
+	if (!stream.workspace)
+		return -ENOMEM;
+	return 0;
+}
+
+void logfs_compr_exit(void)
+{
+	vfree(stream.workspace);
+}
