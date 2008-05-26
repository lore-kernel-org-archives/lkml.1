Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYEZM0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYEZM0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYEZMXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:23:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49579 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbYEZMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:43 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 11/29] UBIFS: add compression support
Date: Mon, 26 May 2008 17:05:25 +0300
Message-Id: <1211810743-18936-12-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:35.0901 (UTC) FILETIME=[51EC78D0:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBIFS supports on-the-flight compression, and this patch adds a
compression helper functions which make it possible to use the
same API irrespectively of the compression type. At the moment
UBIFS supports only LZO and zlib. It uses cryptoapi to access
the compressors.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/compress.c |  253 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 253 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
new file mode 100644
index 0000000..5bb51da
--- /dev/null
+++ b/fs/ubifs/compress.c
@@ -0,0 +1,253 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ * Copyright (C) 2006, 2007 University of Szeged, Hungary
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Adrian Hunter
+ *          Artem Bityutskiy (Битюцкий Артём)
+ *          Zoltan Sogor
+ */
+
+/*
+ * This file provides a single place to access to compression and
+ * decompression.
+ */
+
+#include <linux/crypto.h>
+#include "ubifs.h"
+
+/* Fake description object for the "none" compressor */
+static struct ubifs_compressor none_compr = {
+	.compr_type = UBIFS_COMPR_NONE,
+	.name = "no compression",
+	.capi_name = "",
+};
+
+#ifdef CONFIG_UBIFS_FS_LZO
+static DEFINE_MUTEX(lzo_mutex);
+
+static struct ubifs_compressor lzo_compr = {
+	.compr_type = UBIFS_COMPR_LZO,
+	.comp_mutex = &lzo_mutex,
+	.name = "LZO",
+	.capi_name = "lzo",
+};
+#else
+static struct ubifs_compressor lzo_compr = {
+	.compr_type = UBIFS_COMPR_LZO,
+	.name = "LZO",
+};
+#endif
+
+#ifdef CONFIG_UBIFS_FS_ZLIB
+static DEFINE_MUTEX(deflate_mutex);
+static DEFINE_MUTEX(inflate_mutex);
+
+static struct ubifs_compressor zlib_compr = {
+	.compr_type = UBIFS_COMPR_ZLIB,
+	.comp_mutex = &deflate_mutex,
+	.decomp_mutex = &inflate_mutex,
+	.name = "zlib",
+	.capi_name = "deflate",
+};
+#else
+static struct ubifs_compressor zlib_compr = {
+	.compr_type = UBIFS_COMPR_ZLIB,
+	.name = "zlib",
+};
+#endif
+
+/* All UBIFS compressors */
+struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
+
+/**
+ * ubifs_compress - compress data.
+ * @in_buf: data to compress
+ * @in_len: length of the data to compress
+ * @out_buf: output buffer where compressed data should be stored
+ * @out_len: output buffer length is returned here
+ * @compr_type: type of compression to use on enter, actually used compression
+ *              type on exit
+ *
+ * This function compresses input buffer @in_buf of length @in_len and stores
+ * the result in the output buffer @out_buf and the resulting length in
+ * @out_len. If the input buffer does not compress, it is just copied to the
+ * @out_buf. The same happens if @compr_type is %UBIFS_COMPR_NONE or if
+ * compression error occurred.
+ *
+ * Note, if the input buffer was not compressed, it is copied to the output
+ * buffer and %UBIFS_COMPR_NONE is returned in @compr_type.
+ *
+ * This functions returns %0 on success or a negative error code on failure.
+ */
+void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
+		    int *compr_type)
+{
+	int err;
+	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
+
+	if (*compr_type == UBIFS_COMPR_NONE)
+		goto no_compr;
+
+	/* If the input data is small, do not even try to compress it */
+	if (in_len < UBIFS_MIN_COMPR_LEN)
+		goto no_compr;
+
+	if (compr->comp_mutex)
+		mutex_lock(compr->comp_mutex);
+	err = crypto_comp_compress(compr->cc, in_buf, in_len, out_buf,
+				   out_len);
+	if (compr->comp_mutex)
+		mutex_unlock(compr->comp_mutex);
+	if (unlikely(err)) {
+		ubifs_warn("cannot compress %d bytes, compressor %s, "
+			   "error %d, leave data uncompressed",
+			   in_len, compr->name, err);
+		 goto no_compr;
+	}
+
+	/*
+	 * Presently, we just require that compression results in less data,
+	 * rather than any defined minimum compression ratio or amount.
+	 */
+	if (ALIGN(*out_len, 8) >= ALIGN(in_len, 8))
+		goto no_compr;
+
+	return;
+
+no_compr:
+	memcpy(out_buf, in_buf, in_len);
+	*out_len = in_len;
+	*compr_type = UBIFS_COMPR_NONE;
+}
+
+/**
+ * ubifs_decompress - decompress data.
+ * @in_buf: data to decompress
+ * @in_len: length of the data to decompress
+ * @out_buf: output buffer where decompressed data should
+ * @out_len: output length is returned here
+ * @compr_type: type of compression
+ *
+ * This function decompresses data from buffer @in_buf into buffer @out_buf.
+ * The length of the uncompressed data is returned in @out_len. This functions
+ * returns %0 on success or a negative error code on failure.
+ */
+int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
+		     int *out_len, int compr_type)
+{
+	int err;
+	struct ubifs_compressor *compr;
+
+	if (unlikely(compr_type < 0 || compr_type >= UBIFS_COMPR_TYPES_CNT)) {
+		ubifs_err("invalid compression type %d", compr_type);
+		return -EINVAL;
+	}
+
+	compr = ubifs_compressors[compr_type];
+
+	if (unlikely(!compr->capi_name)) {
+		ubifs_err("%s compression is not compiled in", compr->name);
+		return -EINVAL;
+	}
+
+	if (compr_type == UBIFS_COMPR_NONE) {
+		memcpy(out_buf, in_buf, in_len);
+		*out_len = in_len;
+		return 0;
+	}
+
+	if (compr->decomp_mutex)
+		mutex_lock(compr->decomp_mutex);
+	err = crypto_comp_decompress(compr->cc, in_buf, in_len, out_buf,
+				     out_len);
+	if (compr->decomp_mutex)
+		mutex_unlock(compr->decomp_mutex);
+	if (err)
+		ubifs_err("cannot decompress %d bytes, compressor %s, "
+			  "error %d", in_len, compr->name, err);
+
+	return err;
+}
+
+/**
+ * compr_init - initialize a compressor.
+ * @compr: compressor description object
+ *
+ * This function initializes the requested compressor and returns zero in case
+ * of success or a negative error code in case of failure.
+ */
+static int __init compr_init(struct ubifs_compressor *compr)
+{
+	if (compr->capi_name) {
+		compr->cc = crypto_alloc_comp(compr->capi_name, 0, 0);
+		if (IS_ERR(compr->cc)) {
+			ubifs_err("cannot initialize compressor %s, error %ld",
+				  compr->name, PTR_ERR(compr->cc));
+			return PTR_ERR(compr->cc);
+		}
+	}
+
+	ubifs_compressors[compr->compr_type] = compr;
+	return 0;
+}
+
+/**
+ * compr_exit - de-initialize a compressor.
+ * @compr: compressor description object
+ */
+static void compr_exit(struct ubifs_compressor *compr)
+{
+	if (compr->capi_name)
+		crypto_free_comp(compr->cc);
+	return;
+}
+
+/**
+ * ubifs_compressors_init - initialize UBIFS compressors.
+ *
+ * This function initializes the compressor which were compiled in. Returns
+ * zero in case of success and a negative error code in case of failure.
+ */
+int __init ubifs_compressors_init(void)
+{
+	int err;
+
+	err = compr_init(&lzo_compr);
+	if (err)
+		return err;
+
+	err = compr_init(&zlib_compr);
+	if (err)
+		goto out_lzo;
+
+	ubifs_compressors[UBIFS_COMPR_NONE] = &none_compr;
+	return 0;
+
+out_lzo:
+	compr_exit(&lzo_compr);
+	return err;
+}
+
+/**
+ * ubifs_compressors_exit - de-initialize UBIFS compressors.
+ */
+void __exit ubifs_compressors_exit(void)
+{
+	compr_exit(&lzo_compr);
+	compr_exit(&zlib_compr);
+}
-- 
1.5.4.1

