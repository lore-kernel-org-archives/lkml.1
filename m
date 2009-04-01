Return-Path: <linux-kernel-owner+w=401wt.eu-S1765429AbZDANl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765429AbZDANl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764699AbZDANlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:41:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41442 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764884AbZDANlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fE9/FT7ki0RBdYgIQGGVrsBvVht1Jtp4sZgsR6E/F3RMdP9yttgXy9wUhV4BPZeLbN
         2iIYPGPOuPiWtLmuTRyS9Zyuu0RQl4ZDTac0OBzkfLPenmH6wuY2+SpnCf5e5oQTQALz
         fO6ExqRfJSFzTLqhKnUHhvfHSsG5KKbBMqEjo=
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] lib, initramfs: add support for LZO-compressed initramfs.
Date: Wed,  1 Apr 2009 15:40:52 +0200
Message-Id: <1238593252-3435-3-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1238593252-3435-1-git-send-email-andr345@gmail.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for loading initial ramdisks packed with lzop
using the lzo1x compression method.

Signed-off-by: Andreas Robinson <andr345@gmail.com>
---
 include/linux/decompress/unlzo.h |   11 ++
 include/linux/lzo.h              |    4 +
 lib/Makefile                     |    1 +
 lib/decompress.c                 |    5 +
 lib/decompress_unlzo.c           |  363 ++++++++++++++++++++++++++++++++++++++
 scripts/gen_initramfs_list.sh    |    1 +
 usr/Kconfig                      |   30 +++-
 usr/Makefile                     |    6 +-
 usr/initramfs_data.lzo.S         |   29 +++
 9 files changed, 443 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/decompress/unlzo.h
 create mode 100644 lib/decompress_unlzo.c
 create mode 100644 usr/initramfs_data.lzo.S

diff --git a/include/linux/decompress/unlzo.h b/include/linux/decompress/unlzo.h
new file mode 100644
index 0000000..b780ce2
--- /dev/null
+++ b/include/linux/decompress/unlzo.h
@@ -0,0 +1,11 @@
+#ifndef DECOMPRESS_UNLZO_H
+#define DECOMPRESS_UNLZO_H
+
+int unlzo(unsigned char *in, int in_len,
+	  int(*fill)(void*, unsigned int),
+	  int(*flush)(void*, unsigned int),
+	  unsigned char *output, int *pos,
+	  void(*error)(char *x)
+	);
+
+#endif
diff --git a/include/linux/lzo.h b/include/linux/lzo.h
index d793497..896f1dc 100644
--- a/include/linux/lzo.h
+++ b/include/linux/lzo.h
@@ -40,5 +40,9 @@ int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
 #define LZO_E_EOF_NOT_FOUND		(-7)
 #define LZO_E_INPUT_NOT_CONSUMED	(-8)
 #define LZO_E_NOT_YET_IMPLEMENTED	(-9)
+/* Used in decompress_unlzo.c */
+#define LZO_E_INVALID_FORMAT		(-10)
+#define LZO_E_INVALID_PARAM		(-11)
+#define LZO_E_CORRUPTED			(-12)
 
 #endif
diff --git a/lib/Makefile b/lib/Makefile
index 051a33a..6a81b0d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
 obj-$(CONFIG_LZO_COMPRESS) += lzo/
 obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 
+lib-$(CONFIG_DECOMPRESS_LZO) += decompress_unlzo.o
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
 lib-$(CONFIG_DECOMPRESS_LZMA) += decompress_unlzma.o
diff --git a/lib/decompress.c b/lib/decompress.c
index d2842f5..aee1231 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -9,10 +9,14 @@
 #include <linux/decompress/bunzip2.h>
 #include <linux/decompress/unlzma.h>
 #include <linux/decompress/inflate.h>
+#include <linux/decompress/unlzo.h>
 
 #include <linux/types.h>
 #include <linux/string.h>
 
+#ifndef CONFIG_DECOMPRESS_LZO
+# define unlzo NULL
+#endif
 #ifndef CONFIG_DECOMPRESS_GZIP
 # define gunzip NULL
 #endif
@@ -28,6 +32,7 @@ static const struct compress_format {
 	const char *name;
 	decompress_fn decompressor;
 } compressed_formats[] = {
+	{ {0x89, 0x4c}, "lzo", unlzo },
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
new file mode 100644
index 0000000..ad2bda6
--- /dev/null
+++ b/lib/decompress_unlzo.c
@@ -0,0 +1,363 @@
+/* Simple LZO file format decompressor for Linux.
+ *
+ *     Copyright (C) 2009 Andreas Robinson
+ *
+ * Derived from the LZO package
+ *
+ *     Copyright (C) 1996-2008 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ * This program is licensed under the terms of the Linux GPL2. See COPYING.
+ *
+ * LZO files can be generated with the lzop utility, available along with
+ * the full LZO library at http://www.oberhumer.com/opensource/lzo/
+ */
+
+#include <linux/types.h>
+#include <linux/lzo.h>
+#include <linux/zutil.h>
+#include <linux/decompress/mm.h>
+#include "lzo/lzo1x_decompress_fast.c"
+
+/* LZO file format related */
+
+/* Header flags. */
+#define F_ADLER32_D     0x00000001L
+#define F_ADLER32_C     0x00000002L
+#define F_STDIN         0x00000004L
+#define F_STDOUT        0x00000008L
+#define F_NAME_DEFAULT  0x00000010L
+#define F_DOSISH        0x00000020L
+#define F_H_EXTRA_FIELD 0x00000040L
+#define F_H_GMTDIFF     0x00000080L
+#define F_CRC32_D       0x00000100L
+#define F_CRC32_C       0x00000200L
+#define F_MULTIPART     0x00000400L
+#define F_H_FILTER      0x00000800L
+#define F_H_CRC32       0x00001000L
+#define F_H_PATH        0x00002000L
+
+#define F_MASK          0x00003FFFL
+#define F_OS_MASK       0xff000000L
+#define F_CS_MASK       0x00f00000L
+
+/* These bits must be zero. */
+#define F_RESERVED      ((F_MASK | F_OS_MASK | F_CS_MASK) ^ 0xffffffffL)
+
+#define LZO_BLOCK_SIZE	(256*1024l)
+
+/* Supported compression methods */
+#define M_LZO1X_1	1
+#define M_LZO1X_1_15	2
+#define M_LZO1X_999	3
+
+#if 0
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s " fmt, __func__, ## args)
+#else
+#define DPRINTK(fmt, ...)
+#endif
+
+#define THROW(errno)					\
+	do {						\
+		DPRINTK("line %d: throws %s\n",		\
+			__LINE__, #errno);		\
+		ret = (errno);				\
+		goto error_exit;			\
+	} while (0)
+
+#define READ8(src, dst)					\
+	do {						\
+		if (!read_field((src), (dst), 1))	\
+			THROW(LZO_E_INPUT_OVERRUN);	\
+	} while (0)
+
+#define READ16(src, dst)				\
+	do {						\
+		if (!read_field((src), (dst), 2))	\
+			THROW(LZO_E_INPUT_OVERRUN);	\
+	} while (0)
+
+#define READ32(src, dst)				\
+	do {						\
+		if (!read_field((src), (dst), 4))	\
+			THROW(LZO_E_INPUT_OVERRUN);	\
+	} while (0)
+
+struct lzo_source {
+
+	u8 *buf;	/* Start */
+	u8 *buf_end;	/* End */
+	u8 *p;		/* Read position */
+	size_t len;	/* Length */
+	u32 chksum;	/* Running adler32 checksum */
+	u32 flags;	/* LZO file flags */
+};
+
+/* read_field - Read LZO header field (big endian).
+ * src: source data buffer
+ * dst: destination
+ * len: field length in bytes (1 - 4)
+ */
+static int INIT read_field(struct lzo_source *src, u32 *dst, int len)
+{
+	int i;
+	u32 b = 0;
+
+	if (src->p + len > src->buf_end)
+		return 0;
+
+	src->chksum = zlib_adler32(src->chksum, src->p, len);
+
+	if (dst) {
+		for (i = 0; i < len; i++)
+			b = (b << 8) | *(src->p)++;
+		*dst = b;
+	} else
+		src->p += len;
+
+	return len;
+}
+
+static int INIT unpack_block(struct lzo_source *src, u32 c_len, u32 c_chk,
+			     u8 *dst, u32 d_len, u32 d_chk, int skip_checksum)
+{
+	int ret = LZO_E_OK;
+	size_t out_len;
+
+	if (!skip_checksum && (src->flags & F_ADLER32_C)) {
+		u32 chk = zlib_adler32(1, src->p, c_len);
+		if (chk != c_chk)
+			THROW(LZO_E_CORRUPTED);
+	}
+
+	out_len = d_len;
+	ret = lzo1x_decompress_fast(src->p, c_len, dst, &out_len);
+	if (out_len != d_len)
+		THROW(LZO_E_CORRUPTED);
+	if (ret != LZO_E_OK)
+		goto error_exit;
+
+	if (!skip_checksum && (src->flags & F_ADLER32_D)) {
+		u32 chk = zlib_adler32(1, dst, d_len);
+		if (chk != d_chk)
+			THROW(LZO_E_CORRUPTED);
+	}
+
+	src->p += c_len;
+
+error_exit:
+	return ret;
+}
+
+static int INIT read_block_header(struct lzo_source *src,
+				  u32 *c_len, u32 *c_chk,
+				  u32 *d_len, u32 *d_chk)
+{
+	int ret = LZO_E_OK;
+
+	/* Read block sizes */
+
+	READ32(src, d_len);
+
+	if (*d_len == 0)
+		return ret; /* EOF */
+	if (*d_len == 0xffffffffUL)
+		THROW(LZO_E_NOT_YET_IMPLEMENTED); /* split file */
+	if (*d_len > LZO_BLOCK_SIZE)
+		THROW(LZO_E_INVALID_PARAM);
+
+	READ32(src, c_len);
+
+	if (src->p + *c_len > src->buf_end)
+		THROW(LZO_E_INPUT_OVERRUN);
+
+	/* Read checksums */
+
+	if (src->flags & F_ADLER32_D)
+		READ32(src, d_chk);
+
+	if (src->flags & F_ADLER32_C) {
+		if (c_len < d_len)
+			READ32(src, d_chk);
+		else if (src->flags & F_ADLER32_D)
+			c_chk = d_chk;
+		else
+			THROW(LZO_E_INVALID_PARAM);
+	}
+error_exit:
+	return ret;
+}
+
+static const unsigned char lzop_magic[9] =
+	{0x89, 0x4c, 0x5a, 0x4f, 0x00, 0x0d, 0x0a, 0x1a, 0x0a};
+
+/* read_header - read the lzo file header */
+static int INIT read_header(struct lzo_source *src)
+{
+	int ret = LZO_E_OK;
+
+	int i;
+	u32 v, len;
+	u32 method, level;
+	u32 chk, checksum;
+
+	src->flags = 0;
+
+	/* Check magic number */
+
+	for (i = 0; i < 9; i++) {
+		READ8(src, &v);
+		if (v != lzop_magic[i])
+			THROW(LZO_E_INVALID_FORMAT);
+	}
+
+	src->chksum = 1;
+
+	/* Check supported versions */
+
+	READ16(src, &v); /* File format version */
+	if (v < 0x0940)
+		THROW(LZO_E_NOT_YET_IMPLEMENTED);
+
+	READ16(src, NULL); /* ignored: lib_version */
+	READ16(src, &v); /* LZO lib version needed to extract */
+
+	if (v > 0x1020 || v < 0x0900)
+		THROW(LZO_E_NOT_YET_IMPLEMENTED);
+
+	/* Check compression method and level */
+
+	READ8(src, &method);
+	READ8(src, &level);
+
+	if ((method != M_LZO1X_1) && (method != M_LZO1X_1_15) &&
+			(method != M_LZO1X_999) && (level > 9))
+		THROW(LZO_E_NOT_YET_IMPLEMENTED);
+
+	/* Check flags */
+
+	READ32(src, &(src->flags));
+
+	if (src->flags & (F_H_FILTER | F_MULTIPART | F_RESERVED |
+			F_H_CRC32 | F_CRC32_C | F_CRC32_D))
+		THROW(LZO_E_NOT_YET_IMPLEMENTED);
+
+	if ((src->flags & F_ADLER32_D) == 0)
+		THROW(LZO_E_INVALID_PARAM); /* Decompressed checksum required */
+
+	/* Skip uninteresting fields */
+
+	READ32(src, NULL); /* mode */
+	READ32(src, NULL); /* mtime_low */
+	READ32(src, NULL); /* mtime_high */
+
+	/* Skip original file name */
+
+	READ8(src, &len);
+	for (i = 0; i < len; i++)
+		READ8(src, NULL);
+
+	/* Test header checksum */
+
+	chk = src->chksum;
+	READ32(src, &checksum);
+	if (checksum != chk)
+		THROW(LZO_E_CORRUPTED);
+
+	/* Skip extra field */
+
+	if (src->flags & F_H_EXTRA_FIELD) {
+		src->chksum = 1;
+		READ32(src, &len);
+		for (i = 0; i < len; i++)
+			READ8(src, NULL);
+
+		chk = src->chksum;
+		READ32(src, &checksum);
+		if (checksum != chk)
+			THROW(LZO_E_CORRUPTED);
+	}
+
+error_exit:
+	return ret;
+}
+
+int INIT unlzo(unsigned char *in, int in_len,
+		int(*fill)(void*, unsigned int),
+		int(*flush)(void*, unsigned int),
+		unsigned char *out, int *pos,
+		void(*error)(char *x))
+{
+	int ret = LZO_E_OK;
+	struct lzo_source src;
+
+	u8 *buf = NULL;
+	size_t buf_len;
+
+	src.buf = in;
+	src.buf_end = in + in_len;
+	src.len = in_len;
+	src.p = src.buf;
+
+	if (in_len == 0 || fill != NULL) {
+		error("lzo: requested feature not implemented");
+		THROW(LZO_E_NOT_YET_IMPLEMENTED);
+	}
+
+	ret = read_header(&src);
+	if (ret != LZO_E_OK) {
+		error("lzo: bad data header");
+		goto error_exit;
+	}
+
+	if (flush) {
+		buf_len = LZO_BLOCK_SIZE;
+		buf = malloc(buf_len);
+		if (!buf) {
+			error("lzo: out of memory");
+			THROW(LZO_E_OUT_OF_MEMORY);
+		}
+		out = buf;
+	} else if (!out)
+		THROW(LZO_E_ERROR);
+	/* else assume caller has a large enough buffer. */
+
+	while (src.p < src.buf_end && ret == LZO_E_OK) {
+		u32 c_len, c_chk, d_len, d_chk;
+
+		ret = read_block_header(&src, &c_len, &c_chk, &d_len, &d_chk);
+		if (ret != LZO_E_OK) {
+			error("lzo: bad block header");
+			goto error_exit;
+		}
+		if (d_len == 0)
+			break;
+		if (d_len > LZO_BLOCK_SIZE) {
+			error("lzo: invalid block size");
+			THROW(LZO_E_INVALID_PARAM);
+		}
+
+		ret = unpack_block(&src, c_len, c_chk, out, d_len, d_chk, 1);
+		if (ret != LZO_E_OK) {
+			error("lzo: decompression error");
+			goto error_exit;
+		}
+
+		if (flush) {
+			if (flush(buf, d_len) != d_len) {
+				error("lzo: write error");
+				THROW(LZO_E_ERROR);
+			}
+		} else {
+			out += d_len;
+		}
+	}
+
+error_exit:
+	if (pos)
+		*pos = src.p - src.buf;
+	if (buf)
+		free(buf);
+	return (ret == LZO_E_OK) ? 0 : -1;
+}
+
+#define decompress unlzo
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 3eea8f1..f575b87 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -239,6 +239,7 @@ case "$arg" in
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
+		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
 		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
 		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
 		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
diff --git a/usr/Kconfig b/usr/Kconfig
index 588c588..547630d 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -45,6 +45,15 @@ config INITRAMFS_ROOT_GID
 
 	  If you are not sure, leave it set to "0".
 
+config RD_LZO
+	bool "Support initial ramdisks compressed using lzop" if EMBEDDED
+	default !EMBEDDED
+	depends on BLK_DEV_INITRD
+	select DECOMPRESS_LZO
+	help
+	  Support loading of a lzo encoded initial ramdisk or cpio buffer.
+	  If unsure, say N.
+
 config RD_GZIP
 	bool "Support initial ramdisks compressed using gzip" if EMBEDDED
 	default y
@@ -106,20 +115,29 @@ config INITRAMFS_COMPRESSION_NONE
 	  both the cpio image and the unpacked filesystem image will
 	  be present in memory simultaneously
 
+config INITRAMFS_COMPRESSION_LZO
+	bool "LZO"
+	depends on RD_LZO
+	help
+	  Lempel Ziv Oberhumer compression. Its compression ratio is
+	  the poorest among the four choices; maximum compression yields
+	  roughly 7-10% larger initramfs compared to gzip. However,
+	  decompression time is only 55 - 60% of that of gzip.
+
 config INITRAMFS_COMPRESSION_GZIP
 	bool "Gzip"
 	depends on RD_GZIP
 	help
 	  The old and tried gzip compression. Its compression ratio is
-	  the poorest among the 3 choices; however its speed (both
-	  compression and decompression) is the fastest.
+	  worse than that of bzip2 and lzma; however compression and
+	  decompression are faster.
 
 config INITRAMFS_COMPRESSION_BZIP2
 	bool "Bzip2"
 	depends on RD_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The initramfs
+	  Decompression speed is slowest among the four.  The initramfs
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -129,9 +147,9 @@ config INITRAMFS_COMPRESSION_LZMA
 	depends on RD_LZMA
 	help
 	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The initramfs size is about 33%
-	  smaller with LZMA in comparison to gzip.
+	  Its ratio is best, decompression speed is between gzip and bzip2
+	  Compression is slowest. The initramfs size is about 33% smaller
+	  with LZMA in comparison to gzip.
 
 endchoice
 
diff --git a/usr/Makefile b/usr/Makefile
index b84894b..4a887d2 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -9,6 +9,9 @@ PHONY += klibcdirs
 # No compression
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_NONE)   =
 
+# Lzo
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)    = .lzo
+
 # Gzip, but no bzip2
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   = .gz
 
@@ -48,7 +51,8 @@ endif
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
+targets := initramfs_data.cpio.lzo initramfs_data.cpio.gz \
+	initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
diff --git a/usr/initramfs_data.lzo.S b/usr/initramfs_data.lzo.S
new file mode 100644
index 0000000..5921190
--- /dev/null
+++ b/usr/initramfs_data.lzo.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.lzo"
-- 
1.5.6.3

