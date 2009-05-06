Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbZEFOux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbZEFOux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbZEFOtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:05 -0400
Received: from mail.crca.org.au ([67.207.131.56]:55049 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZEFOs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:57 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 10:48:57 EDT
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 12/19] TuxOnIce: Compression support.
Date: Thu,  7 May 2009 00:39:08 +1000
Message-Id: <1241620755-22133-13-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multithreaded support for compressing pages using cryptoapi algorithms
and passing them to whatever code is writing the image.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/Kconfig             |   15 ++
 kernel/power/Makefile            |    1 +
 kernel/power/tuxonice_compress.c |  434 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 450 insertions(+), 0 deletions(-)
 create mode 100644 kernel/power/tuxonice_compress.c

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 498b5c2..1b474a6 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -195,6 +195,21 @@ menuconfig TOI_CORE
 	comment "General Options"
 		depends on TOI_CORE
 
+	config TOI_CRYPTO
+		bool "Compression support"
+		depends on TOI_CORE && CRYPTO
+		default y
+		---help---
+		  This option adds support for using cryptoapi compression
+		  algorithms. Compression is particularly useful as it can
+		  more than double your suspend and resume speed (depending
+		  upon how well your image compresses).
+
+		  You probably want this, so say Y here.
+
+	comment "No compression support available without Cryptoapi support."
+		depends on TOI_CORE && !CRYPTO
+
 	config TOI_KEEP_IMAGE
 		bool "Allow Keep Image Mode"
 		depends on TOI_CORE
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 9ad139e..3803866 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -15,6 +15,7 @@ tuxonice_core-objs		+= tuxonice_storage.o tuxonice_netlink.o
 endif
 
 obj-$(CONFIG_TOI_CORE)		+= tuxonice_core.o
+obj-$(CONFIG_TOI_CRYPTO)	+= tuxonice_compress.o
 
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
diff --git a/kernel/power/tuxonice_compress.c b/kernel/power/tuxonice_compress.c
new file mode 100644
index 0000000..1ce3d02
--- /dev/null
+++ b/kernel/power/tuxonice_compress.c
@@ -0,0 +1,434 @@
+/*
+ * kernel/power/compression.c
+ *
+ * Copyright (C) 2003-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * This file contains data compression routines for TuxOnIce,
+ * using cryptoapi.
+ */
+
+#include <linux/suspend.h>
+#include <linux/highmem.h>
+#include <linux/vmalloc.h>
+#include <linux/crypto.h>
+
+#include "tuxonice_builtin.h"
+#include "tuxonice.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_io.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_alloc.h"
+
+static int toi_expected_compression;
+
+static struct toi_module_ops toi_compression_ops;
+static struct toi_module_ops *next_driver;
+
+static char toi_compressor_name[32] = "lzo";
+
+static DEFINE_MUTEX(stats_lock);
+
+struct cpu_context {
+	u8 *page_buffer;
+	struct crypto_comp *transform;
+	unsigned int len;
+	char *buffer_start;
+	char *output_buffer;
+};
+
+static DEFINE_PER_CPU(struct cpu_context, contexts);
+
+static int toi_compress_prepare_result;
+
+/*
+ * toi_compress_cleanup
+ *
+ * Frees memory allocated for our labours.
+ */
+static void toi_compress_cleanup(int toi_or_resume)
+{
+	int cpu;
+
+	if (!toi_or_resume)
+		return;
+
+	for_each_online_cpu(cpu) {
+		struct cpu_context *this = &per_cpu(contexts, cpu);
+		if (this->transform) {
+			crypto_free_comp(this->transform);
+			this->transform = NULL;
+		}
+
+		if (this->page_buffer)
+			toi_free_page(16, (unsigned long) this->page_buffer);
+
+		this->page_buffer = NULL;
+
+		if (this->output_buffer)
+			vfree(this->output_buffer);
+
+		this->output_buffer = NULL;
+	}
+}
+
+/*
+ * toi_crypto_prepare
+ *
+ * Prepare to do some work by allocating buffers and transforms.
+ */
+static int toi_compress_crypto_prepare(void)
+{
+	int cpu;
+
+	if (!*toi_compressor_name) {
+		printk(KERN_INFO "TuxOnIce: Compression enabled but no "
+				"compressor name set.\n");
+		return 1;
+	}
+
+	for_each_online_cpu(cpu) {
+		struct cpu_context *this = &per_cpu(contexts, cpu);
+		this->transform = crypto_alloc_comp(toi_compressor_name, 0, 0);
+		if (IS_ERR(this->transform)) {
+			printk(KERN_INFO "TuxOnIce: Failed to initialise the "
+					"%s compression transform.\n",
+					toi_compressor_name);
+			this->transform = NULL;
+			return 1;
+		}
+
+		this->page_buffer =
+			(char *) toi_get_zeroed_page(16, TOI_ATOMIC_GFP);
+
+		if (!this->page_buffer) {
+			printk(KERN_ERR
+			  "Failed to allocate a page buffer for TuxOnIce "
+			  "compression driver.\n");
+			return -ENOMEM;
+		}
+
+		this->output_buffer =
+			(char *) vmalloc_32(2 * PAGE_SIZE);
+
+		if (!this->output_buffer) {
+			printk(KERN_ERR
+			  "Failed to allocate a output buffer for TuxOnIce "
+			  "compression driver.\n");
+			return -ENOMEM;
+		}
+
+	}
+
+	return 0;
+}
+
+/*
+ * toi_compress_init
+ */
+
+static int toi_compress_init(int toi_or_resume)
+{
+	if (!toi_or_resume)
+		return 0;
+
+	toi_compress_bytes_in = 0;
+	toi_compress_bytes_out = 0;
+
+	next_driver = toi_get_next_filter(&toi_compression_ops);
+
+	if (!next_driver)
+		return -ECHILD;
+
+	toi_compress_prepare_result = toi_compress_crypto_prepare();
+
+	return 0;
+}
+
+/*
+ * toi_compress_rw_init()
+ */
+
+static int toi_compress_rw_init(int rw, int stream_number)
+{
+	if (toi_compress_prepare_result) {
+		printk(KERN_ERR "Failed to initialise compression "
+				"algorithm.\n");
+		if (rw == READ) {
+			printk(KERN_INFO "Unable to read the image.\n");
+			return -ENODEV;
+		} else {
+			printk(KERN_INFO "Continuing without "
+				"compressing the image.\n");
+			toi_compression_ops.enabled = 0;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * toi_compress_write_page()
+ *
+ * Compress a page of data, buffering output and passing on filled
+ * pages to the next module in the pipeline.
+ *
+ * Buffer_page:	Pointer to a buffer of size PAGE_SIZE, containing
+ * data to be compressed.
+ *
+ * Returns:	0 on success. Otherwise the error is that returned by later
+ * 		modules, -ECHILD if we have a broken pipeline or -EIO if
+ * 		zlib errs.
+ */
+static int toi_compress_write_page(unsigned long index,
+		struct page *buffer_page, unsigned int buf_size)
+{
+	int ret, cpu = smp_processor_id();
+	struct cpu_context *ctx = &per_cpu(contexts, cpu);
+
+	if (!ctx->transform)
+		return next_driver->write_page(index, buffer_page, buf_size);
+
+	ctx->buffer_start = kmap(buffer_page);
+
+	ctx->len = buf_size;
+
+	ret = crypto_comp_compress(ctx->transform,
+			ctx->buffer_start, buf_size,
+			ctx->output_buffer, &ctx->len);
+
+	kunmap(buffer_page);
+
+	mutex_lock(&stats_lock);
+	toi_compress_bytes_in += buf_size;
+	toi_compress_bytes_out += ctx->len;
+	mutex_unlock(&stats_lock);
+
+	if (!ret && ctx->len < buf_size) { /* some compression */
+		memcpy(ctx->page_buffer, ctx->output_buffer, ctx->len);
+		return next_driver->write_page(index,
+				virt_to_page(ctx->page_buffer),
+				ctx->len);
+	} else
+		return next_driver->write_page(index, buffer_page, buf_size);
+}
+
+/*
+ * toi_compress_read_page()
+ * @buffer_page: struct page *. Pointer to a buffer of size PAGE_SIZE.
+ *
+ * Retrieve data from later modules and decompress it until the input buffer
+ * is filled.
+ * Zero if successful. Error condition from me or from downstream on failure.
+ */
+static int toi_compress_read_page(unsigned long *index,
+		struct page *buffer_page, unsigned int *buf_size)
+{
+	int ret, cpu = smp_processor_id();
+	unsigned int len;
+	unsigned int outlen = PAGE_SIZE;
+	char *buffer_start;
+	struct cpu_context *ctx = &per_cpu(contexts, cpu);
+
+	if (!ctx->transform)
+		return next_driver->read_page(index, buffer_page, buf_size);
+
+	/*
+	 * All our reads must be synchronous - we can't decompress
+	 * data that hasn't been read yet.
+	 */
+
+	*buf_size = PAGE_SIZE;
+
+	ret = next_driver->read_page(index, buffer_page, &len);
+
+	/* Error or uncompressed data */
+	if (ret || len == PAGE_SIZE)
+		return ret;
+
+	buffer_start = kmap(buffer_page);
+	memcpy(ctx->page_buffer, buffer_start, len);
+	ret = crypto_comp_decompress(
+			ctx->transform,
+			ctx->page_buffer,
+			len, buffer_start, &outlen);
+	if (ret)
+		abort_hibernate(TOI_FAILED_IO,
+			"Compress_read returned %d.\n", ret);
+	else if (outlen != PAGE_SIZE) {
+		abort_hibernate(TOI_FAILED_IO,
+			"Decompression yielded %d bytes instead of %ld.\n",
+			outlen, PAGE_SIZE);
+		printk(KERN_ERR "Decompression yielded %d bytes instead of "
+				"%ld.\n", outlen, PAGE_SIZE);
+		ret = -EIO;
+		*buf_size = outlen;
+	}
+	kunmap(buffer_page);
+	return ret;
+}
+
+/*
+ * toi_compress_print_debug_stats
+ * @buffer: Pointer to a buffer into which the debug info will be printed.
+ * @size: Size of the buffer.
+ *
+ * Print information to be recorded for debugging purposes into a buffer.
+ * Returns: Number of characters written to the buffer.
+ */
+
+static int toi_compress_print_debug_stats(char *buffer, int size)
+{
+	unsigned long pages_in = toi_compress_bytes_in >> PAGE_SHIFT,
+		      pages_out = toi_compress_bytes_out >> PAGE_SHIFT;
+	int len;
+
+	/* Output the compression ratio achieved. */
+	if (*toi_compressor_name)
+		len = scnprintf(buffer, size, "- Compressor is '%s'.\n",
+				toi_compressor_name);
+	else
+		len = scnprintf(buffer, size, "- Compressor is not set.\n");
+
+	if (pages_in)
+		len += scnprintf(buffer+len, size - len, "  Compressed "
+			"%lu bytes into %lu (%ld percent compression).\n",
+		  toi_compress_bytes_in,
+		  toi_compress_bytes_out,
+		  (pages_in - pages_out) * 100 / pages_in);
+	return len;
+}
+
+/*
+ * toi_compress_compression_memory_needed
+ *
+ * Tell the caller how much memory we need to operate during hibernate/resume.
+ * Returns: Unsigned long. Maximum number of bytes of memory required for
+ * operation.
+ */
+static int toi_compress_memory_needed(void)
+{
+	return 2 * PAGE_SIZE;
+}
+
+static int toi_compress_storage_needed(void)
+{
+	return 4 * sizeof(unsigned long) + strlen(toi_compressor_name) + 1;
+}
+
+/*
+ * toi_compress_save_config_info
+ * @buffer: Pointer to a buffer of size PAGE_SIZE.
+ *
+ * Save informaton needed when reloading the image at resume time.
+ * Returns: Number of bytes used for saving our data.
+ */
+static int toi_compress_save_config_info(char *buffer)
+{
+	int namelen = strlen(toi_compressor_name) + 1;
+	int total_len;
+
+	*((unsigned long *) buffer) = toi_compress_bytes_in;
+	*((unsigned long *) (buffer + 1 * sizeof(unsigned long))) =
+		toi_compress_bytes_out;
+	*((unsigned long *) (buffer + 2 * sizeof(unsigned long))) =
+		toi_expected_compression;
+	*((unsigned long *) (buffer + 3 * sizeof(unsigned long))) = namelen;
+	strncpy(buffer + 4 * sizeof(unsigned long), toi_compressor_name,
+								namelen);
+	total_len = 4 * sizeof(unsigned long) + namelen;
+	return total_len;
+}
+
+/* toi_compress_load_config_info
+ * @buffer: Pointer to the start of the data.
+ * @size: Number of bytes that were saved.
+ *
+ * Description:	Reload information needed for decompressing the image at
+ * resume time.
+ */
+static void toi_compress_load_config_info(char *buffer, int size)
+{
+	int namelen;
+
+	toi_compress_bytes_in = *((unsigned long *) buffer);
+	toi_compress_bytes_out = *((unsigned long *) (buffer + 1 *
+				sizeof(unsigned long)));
+	toi_expected_compression = *((unsigned long *) (buffer + 2 *
+				sizeof(unsigned long)));
+	namelen = *((unsigned long *) (buffer + 3 * sizeof(unsigned long)));
+	if (strncmp(toi_compressor_name, buffer + 4 * sizeof(unsigned long),
+				namelen)) {
+		toi_compress_cleanup(1);
+		strncpy(toi_compressor_name, buffer + 4 * sizeof(unsigned long),
+			namelen);
+		toi_compress_crypto_prepare();
+	}
+	return;
+}
+
+/*
+ * toi_expected_compression_ratio
+ *
+ * Description:	Returns the expected ratio between data passed into this module
+ * 		and the amount of data output when writing.
+ * Returns:	100 if the module is disabled. Otherwise the value set by the
+ * 		user via our sysfs entry.
+ */
+
+static int toi_compress_expected_ratio(void)
+{
+	if (!toi_compression_ops.enabled)
+		return 100;
+	else
+		return 100 - toi_expected_compression;
+}
+
+/*
+ * data for our sysfs entries.
+ */
+static struct toi_sysfs_data sysfs_params[] = {
+	SYSFS_INT("expected_compression", SYSFS_RW, &toi_expected_compression,
+			0, 99, 0, NULL),
+	SYSFS_INT("enabled", SYSFS_RW, &toi_compression_ops.enabled, 0, 1, 0,
+			NULL),
+	SYSFS_STRING("algorithm", SYSFS_RW, toi_compressor_name, 31, 0, NULL),
+};
+
+/*
+ * Ops structure.
+ */
+static struct toi_module_ops toi_compression_ops = {
+	.type			= FILTER_MODULE,
+	.name			= "compression",
+	.directory		= "compression",
+	.module			= THIS_MODULE,
+	.initialise		= toi_compress_init,
+	.cleanup		= toi_compress_cleanup,
+	.memory_needed 		= toi_compress_memory_needed,
+	.print_debug_info	= toi_compress_print_debug_stats,
+	.save_config_info	= toi_compress_save_config_info,
+	.load_config_info	= toi_compress_load_config_info,
+	.storage_needed		= toi_compress_storage_needed,
+	.expected_compression	= toi_compress_expected_ratio,
+
+	.rw_init		= toi_compress_rw_init,
+
+	.write_page		= toi_compress_write_page,
+	.read_page		= toi_compress_read_page,
+
+	.sysfs_data		= sysfs_params,
+	.num_sysfs_entries	= sizeof(sysfs_params) /
+		sizeof(struct toi_sysfs_data),
+};
+
+/* ---- Registration ---- */
+
+static __init int toi_compress_load(void)
+{
+	return toi_register_module(&toi_compression_ops);
+}
+
+late_initcall(toi_compress_load);
-- 
1.5.6.3

