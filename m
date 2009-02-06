Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZBFUo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZBFUo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZBFUoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:44:20 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:50751 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbZBFUoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:44:19 -0500
Date: Fri, 6 Feb 2009 21:44:17 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jens Axboe <axboe@kernel.dk>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/02] Wrappers for 32-bit PIO to/from scatterlist
Message-ID: <20090206204417.GB13217@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement helpers for doing PIO transfers to/from scatter-gather buffers
using 32-bit accesses. Includes kernel-doc for public interface.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN a/include/linux/scatterlist.h b/include/linux/scatterlist.h
--- a/include/linux/scatterlist.h	2008-12-25 00:26:37.000000000 +0100
+++ b/include/linux/scatterlist.h	2009-02-03 00:01:09.000000000 +0100
@@ -4,6 +4,7 @@
 #include <asm/types.h>
 #include <asm/scatterlist.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/string.h>
 #include <asm/io.h>
 
@@ -262,4 +263,92 @@
 bool sg_miter_next(struct sg_mapping_iter *miter);
 void sg_miter_stop(struct sg_mapping_iter *miter);
 
+/**
+ * sg_miter_stop_writing - stop mapping iteration after writing
+ * @miter: sg mapping iter to be stopped
+ *
+ * Description:
+ *   Stops mapping iterator @miter.  @miter should have been started
+ *   started using sg_miter_start().  A stopped iteration can be
+ *   resumed by calling sg_miter_next() on it.  This is useful when
+ *   resources (kmap) need to be released during iteration.
+ *
+ *   This is a convenience wrapper that will be optimized out for arches
+ *   that don't need flush_kernel_dcache_page().
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_miter_stop_writing(struct sg_mapping_iter *miter)
+{
+	if (miter->page)
+		flush_kernel_dcache_page(miter->page);
+	sg_miter_stop(miter);
+}
+
+/*
+ * 32-bit PIO mapping sg iterator
+ *
+ * Hides scatterlist access issues - fragment boundaries, alignment, page
+ * mapping - for drivers using 32-bit-word-at-a-time-PIO (ie. PCI devices
+ * without DMA support).
+ *
+ * Best-case reading (transfer from device):
+ *   sg_miter_start();
+ *   sg_dwiter_write_from_io();
+ *   sg_miter_stop_writing();
+ *
+ * Best-case writing (transfer to device):
+ *   sg_miter_start();
+ *   sg_dwiter_read_to_io();
+ *   sg_miter_stop();
+ */
+
+uint32_t sg_dwiter_read_next_block(struct sg_mapping_iter *miter);
+void sg_dwiter_write_next_block(struct sg_mapping_iter *miter, uint32_t data);
+
+/**
+ * sg_dwiter_write_from_io - transfer data to mapped buffer from 32-bit IO port
+ * @miter: sg mapping iter
+ * @port: PIO port - IO or MMIO address
+ * @count: number of 32-bit words to transfer
+ *
+ * Description:
+ *   Reads @count 32-bit words from register @port and stores it in
+ *   buffer iterated by @miter.  Data that would overflow the buffer
+ *   is silently ignored.  Iterator is advanced by 4*@count bytes
+ *   or to the buffer's end whichever is closer.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_dwiter_write_from_io(struct sg_mapping_iter *miter,
+	void __iomem *port, size_t count)
+{
+	while (count-- > 0)
+		sg_dwiter_write_next_block(miter, ioread32(port));
+}
+
+/**
+ * sg_dwiter_read_to_io - transfer data to 32-bit IO port from mapped buffer
+ * @miter: sg mapping iter
+ * @port: PIO port - IO or MMIO address
+ * @count: number of 32-bit words to transfer
+ *
+ * Description:
+ *   Writes @count 32-bit words to register @port from buffer iterated
+ *   through @miter.  If buffer ends before @count words are written
+ *   missing data is replaced by zeroes. @miter is advanced by 4*@count
+ *   bytes or to the buffer's end whichever is closer.
+ *
+ * Context:
+ *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ */
+static inline void sg_dwiter_read_to_io(struct sg_mapping_iter *miter,
+	void __iomem *port, size_t count)
+{
+	while (count-- > 0)
+		iowrite32(sg_dwiter_read_next_block(miter), port);
+}
+
 #endif /* _LINUX_SCATTERLIST_H */
diff -urN a/lib/scatterlist.c b/lib/scatterlist.c
--- a/lib/scatterlist.c	2008-12-25 00:26:37.000000000 +0100
+++ b/lib/scatterlist.c	2009-02-02 23:59:42.000000000 +0100
@@ -482,3 +482,146 @@
 	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
+
+/*
+ * 32-bit PIO helpers
+ */
+
+static bool sg_dwiter_next(struct sg_mapping_iter *miter)
+{
+	if (sg_miter_next(miter)) {
+		miter->consumed = 0;
+		return true;
+	} else
+		return false;
+}
+
+static bool sg_dwiter_is_at_end(struct sg_mapping_iter *miter)
+{
+	return miter->length == miter->consumed && !sg_dwiter_next(miter);
+}
+
+static uint32_t sg_dwiter_read_buffer(struct sg_mapping_iter *miter)
+{
+	size_t len, left = 4;
+	uint32_t data;
+	void *addr = &data;
+
+	do {
+		len = min(miter->length - miter->consumed, left);
+		memcpy(addr, miter->addr + miter->consumed, len);
+		miter->consumed += len;
+		left -= len;
+		if (!left)
+			return data;
+		addr += len;
+	} while (sg_dwiter_next(miter));
+
+	memset(addr, 0, left);
+	return data;
+}
+
+static inline bool sg_dw_needs_unaligned_copy(const void *ptr)
+{
+#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
+	return false;
+#else
+	return ((ptr - NULL) & 3) != 0;
+#endif
+}
+
+static bool sg_dwiter_get_next_block(struct sg_mapping_iter *miter,
+	uint32_t **ptr)
+{
+	size_t len;
+
+	if (sg_dwiter_is_at_end(miter))
+		return true;
+
+	len = miter->length - miter->consumed;
+
+	if (likely(len >= 4 && !sg_dw_needs_unaligned_copy(
+			miter->addr + miter->consumed))) {
+		*ptr = miter->addr + miter->consumed;
+		miter->consumed += 4;
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * sg_dwiter_read_next_block() - get next 32-bit word from sg buffer
+ * @miter: sg mapping iterator used for reading
+ *
+ * Description:
+ *   Returns 32-bit word starting at byte pointed to by @miter@
+ *   handling any alignment issues.  Bytes past the buffer's end
+ *   are not accessed (read) but are returned as zeroes.  @miter@
+ *   is advanced by 4 bytes or to the end of buffer whichever is
+ *   closer.
+ *
+ * Context:
+ *   Same requirements as in sg_miter_next().
+ *
+ * Returns:
+ *   32-bit word just read.
+ */
+uint32_t sg_dwiter_read_next_block(struct sg_mapping_iter *miter)
+{
+	uint32_t *ptr = NULL;
+
+	if (likely(sg_dwiter_get_next_block(miter, &ptr)))
+		return ptr ? *ptr : 0;
+
+	return sg_dwiter_read_buffer(miter);
+}
+EXPORT_SYMBOL_GPL(sg_dwiter_read_next_block);
+
+static void sg_dwiter_write_slow(struct sg_mapping_iter *miter, uint32_t data)
+{
+	size_t len, left = 4;
+	void *addr = &data;
+
+	do {
+		len = min(miter->length - miter->consumed, left);
+		memcpy(miter->addr, addr, len);
+		miter->consumed += len;
+		left -= len;
+		if (!left)
+			return;
+		addr += len;
+		flush_kernel_dcache_page(miter->page);
+	} while (sg_dwiter_next(miter));
+}
+
+/**
+ * sg_dwiter_write_next_block() - write next 32-bit word to sg buffer
+ * @miter: sg mapping iterator used for writing
+ *
+ * Description:
+ *   Writes 32-bit word starting at byte pointed to by @miter@
+ *   handling any alignment issues.  Bytes which would be written
+ *   past the buffer's end are silently discarded. @miter@ is
+ *   advanced by 4 bytes or to the end of buffer whichever is closer.
+ *
+ * Context:
+ *   Same requirements as in sg_miter_next().
+ */
+void sg_dwiter_write_next_block(struct sg_mapping_iter *miter, uint32_t data)
+{
+	uint32_t *ptr = NULL;
+
+	if (likely(sg_dwiter_get_next_block(miter, &ptr))) {
+		if (ptr)
+			*ptr = data;
+		else
+			return;
+	} else
+		sg_dwiter_write_slow(miter, data);
+
+	if (miter->length == miter->consumed)
+		flush_kernel_dcache_page(miter->page);
+}
+EXPORT_SYMBOL_GPL(sg_dwiter_write_next_block);
+
