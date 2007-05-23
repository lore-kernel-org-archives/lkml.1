Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXEWI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXEWI1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXEWI1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:27:38 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:10635 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbXEWI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=dAe6TCITpz3fMMefXxDbg/VBAxBkD9HlP1Wgueq9ysDCuOBNGAv+/rIYihKiKrcu1VHc0YPr/rEP2QcdbU9M7HibOv7LrnvBsswqhAlZgtWUVREW1GhAj4NzLPvC8jzVUW8HVBFZFG8MDY5hVaUfZVI6+yaWPgzvsQhwBV2xdBw=
Message-ID: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
Date: Wed, 23 May 2007 13:57:35 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] LZO de/compression support - take 3
Cc: "Richard Purdie" <richard@openedhand.com>, linux-mm-cc@laptop.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_146284_1174340.1179908855331"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_146284_1174340.1179908855331
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This contains LZO1X-1 compressor and LZO1X decompressor (safe and
standard version).
This includes changes suggested by various people - Thanks to all who
reviewed previous patches for this LZO port.

Changelog vs original LZO 2.02 code:
- Chopped down huge parts of original code that were irrelevant fot this port
- Use of standard data types
- Use memcpy() instead of COPY4 macros used in orig. code
- Various macros -> static inline functions
- Code matches general kernel style
- Various other cleanups suggested in reviews

For now, tested on x86 only.

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---

diff --git a/Makefile b/Makefile
index 34210af..88053ba 100644
--- a/Makefile
+++ b/Makefile
@@ -826,11 +826,18 @@ include/config/kernel.release:
include/config/auto.conf FORCE
 # Listed in dependency order
 PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3

+# prepare4 does module specific things prior to compilation
+prepare4:
+ifneq ($(CONFIG_LZO1X),n)
+	$(Q)ln -sf $(srctree)/lib/lzo1x/lzo1x_decompress.c \
+		$(srctree)/lib/lzo1x/lzo1x_decompress_safe.c
+endif
+
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
 # 2) Create the include2 directory, used for the second asm symlink
-prepare3: include/config/kernel.release
+prepare3: prepare4 include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@echo '  Using $(srctree) as source for kernel'
 	$(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
new file mode 100755
index 0000000..7c2f633
--- /dev/null
+++ b/include/linux/lzo1x.h
@@ -0,0 +1,80 @@
+/* lzo1x.h -- public interface of the LZO1X compression algorithm
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+   All Rights Reserved.
+
+   The LZO library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License,
+   version 2, as published by the Free Software Foundation.
+
+   The LZO library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with the LZO library; see the file COPYING.
+   If not, write to the Free Software Foundation, Inc.,
+   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+   Markus F.X.J. Oberhumer
+   <markus@oberhumer.com>
+   http://www.oberhumer.com/opensource/lzo/
+
+
+   This file is modified version of lzo1x.h found in original LZO 2.02
+   code. Some additional changes have also been made to make it work
+   in kernel space.
+
+   Nitin Gupta
+   <nitingupta910@gmail.com>
+ */
+
+#ifndef __LZO1X_H
+#define __LZO1X_H
+
+/* LZO return codes */
+#define LZO_E_OK			0
+#define LZO_E_ERROR			(-1)
+#define LZO_E_OUT_OF_MEMORY		(-2)    /* [not used right now] */
+#define LZO_E_NOT_COMPRESSIBLE		(-3)    /* [not used right now] */
+#define LZO_E_INPUT_OVERRUN		(-4)
+#define LZO_E_OUTPUT_OVERRUN		(-5)
+#define LZO_E_LOOKBEHIND_OVERRUN	(-6)
+#define LZO_E_EOF_NOT_FOUND		(-7)
+#define LZO_E_INPUT_NOT_CONSUMED	(-8)
+#define LZO_E_NOT_YET_IMPLEMENTED	(-9)    /* [not used right now] */
+
+/* Size of temp buffer (workmem) required by lzo1x_compress */
+#define LZO1X_WORKMEM_SIZE	((size_t) (16384L * sizeof(unsigned char *)))
+
+/*
+ * This required 'workmem' of size LZO1X_WORKMEM_SIZE
+ */
+int lzo1x_compress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len,
+		void *workmem);
+
+
+/*
+ * This decompressor expects valid compressed data.
+ *
+ * If the compressed data gets corrupted somehow (e.g. transmission
+ * via an erroneous channel, disk errors, ...) it will probably crash
+ * your application because absolutely no additional checks are done.
+ */
+int lzo1x_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len);
+
+
+/*
+ * The `safe' decompressor. Somewhat slower.
+ *
+ * This decompressor will catch all compressed data violations and
+ * return an error code in this case.
+ */
+int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len);
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 2e7ae6b..9d30b1f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -64,6 +64,12 @@ config ZLIB_INFLATE
 config ZLIB_DEFLATE
 	tristate

+config LZO1X
+	tristate "LZO1X Compression/Decompression"
+	help
+	  Compression: LZO1X-1
+	  Decompression: LZO1X
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index c8c8e20..4dad99d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
+obj-$(CONFIG_LZO1X)        += lzo1x/

 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
new file mode 100644
index 0000000..e036b42
--- /dev/null
+++ b/lib/lzo1x/Makefile
@@ -0,0 +1,11 @@
+#
+# When compiling this module out of tree, do 'make prepare_lzo'
+# before compiling as usual
+#
+obj-$(CONFIG_LZO1X) += lzo1x.o
+CFLAGS_lzo1x_decompress_safe.o += -DLZO1X_DECOMPRESS_SAFE
+lzo1x-objs := lzo1x_compress.o lzo1x_decompress.o lzo1x_decompress_safe.o
+
+prepare_lzo:
+	@ln -sf lzo1x_decompress.c lzo1x_decompress_safe.c
+
diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
new file mode 100755
index 0000000..690c082
--- /dev/null
+++ b/lib/lzo1x/lzo1x_compress.c
@@ -0,0 +1,256 @@
+/* lzo1x_compress.c -- LZO1X-1 compression
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+   All Rights Reserved.
+
+   The LZO library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License,
+   version 2, as published by the Free Software Foundation.
+
+   The LZO library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with the LZO library; see the file COPYING.
+   If not, write to the Free Software Foundation, Inc.,
+   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+   Markus F.X.J. Oberhumer
+   <markus@oberhumer.com>
+   http://www.oberhumer.com/opensource/lzo/
+
+
+   This file is derived from lzo1x_1.c and lzo1x_c.ch found in original
+   LZO 2.02 code. Some additional changes have also been made to make
+   it work in kernel space.
+
+   Nitin Gupta
+   <nitingupta910@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/compiler.h>
+
+#include "lzo1x_int.h"
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Compression");
+
+/* compress a block of data. */
+static unsigned int
+lzo1x_compress_worker(const unsigned char *in, size_t in_len,
+			unsigned char *out, size_t *out_len,
+			void *workmem)
+{
+	const unsigned char *ip;
+	unsigned char *op;
+	const unsigned char * const in_end = in + in_len;
+	const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
+	const unsigned char *ii;
+	const unsigned char ** const dict = (const unsigned char **)workmem;
+
+	op = out;
+	ip = in;
+	ii = ip;
+
+	ip += 4;
+	for (;;) {
+		const unsigned char *m_pos;
+		size_t m_off;
+		size_t m_len;
+		size_t dindex;
+
+		dindex = DINDEX1(ip);
+		m_pos = dict[dindex];
+
+		if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
+				 || m_off > M4_MAX_OFFSET)
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		dindex = DINDEX2(dindex);
+		m_pos = dict[dindex];
+
+		if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
+				 || m_off > M4_MAX_OFFSET)
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		goto literal;
+
+try_match:
+		if (*(const unsigned short *)m_pos ==
+				*(const unsigned short *)ip) {
+			if (likely(m_pos[2] == ip[2]))
+				goto match;
+		}
+
+		/* a literal */
+literal:
+		dict[dindex] = ip;
+		++ip;
+		if (unlikely(ip >= ip_end))
+			break;
+		continue;
+
+		/* a match */
+match:
+		dict[dindex] = ip;
+		/* store current literal run */
+		if ((size_t)(ip - ii) > 0) {
+			size_t t = (size_t)(ip - ii);
+			if (t <= 3)
+				op[-2] |= (unsigned char)(t);
+			else if (t <= 18)
+				*op++ = (unsigned char)(t - 3);
+			else {
+				size_t tt = t - 18;
+				*op++ = 0;
+				while (tt > 255) {
+					tt -= 255;
+					*op++ = 0;
+				}
+				*op++ = (unsigned char)tt;
+			}
+			do *op++ = *ii++; while (--t > 0);
+		}
+	
+		/* code the match */
+		ip += 3;
+		if (m_pos[3] != *ip++ || m_pos[4] != *ip++ ||
+				m_pos[5] != *ip++ || m_pos[6] != *ip++ ||
+				m_pos[7] != *ip++ || m_pos[8] != *ip++) {
+			--ip;
+			m_len = (size_t)(ip - ii);
+	
+			if (m_off <= M2_MAX_OFFSET) {
+				m_off -= 1;
+				*op++ = (unsigned char)(((m_len - 1) << 5) |
+					((m_off & 7) << 2));
+				*op++ = (unsigned char)(m_off >> 3);
+			}
+			else if (m_off <= M3_MAX_OFFSET) {
+				m_off -= 1;
+				*op++ = (unsigned char)(M3_MARKER |
+					(m_len - 2));
+				goto m3_m4_offset;
+			} else {
+				m_off -= 0x4000;
+				*op++ = (unsigned char)(M4_MARKER |
+					((m_off & 0x4000) >> 11) |
+					(m_len - 2));
+				goto m3_m4_offset;
+			}
+		} else {
+			const unsigned char *end = in_end;
+			const unsigned char *m = m_pos + M2_MAX_LEN + 1;
+			while (ip < end && *m == *ip)
+				m++, ip++;
+			m_len = (size_t)(ip - ii);
+	
+			if (m_off <= M3_MAX_OFFSET) {
+				m_off -= 1;
+				if (m_len <= 33)
+					*op++ = (unsigned char)(M3_MARKER |
+						(m_len - 2));
+				else {
+					m_len -= 33;
+					*op++ = M3_MARKER | 0;
+					goto m3_m4_len;
+				}
+			} else {
+				m_off -= 0x4000;
+				if (m_len <= M4_MAX_LEN)
+					*op++ = (unsigned char)(M4_MARKER |
+						((m_off & 0x4000) >> 11) |
+						(m_len - 2));
+				else {
+					m_len -= M4_MAX_LEN;
+					*op++ = (unsigned char)(M4_MARKER |
+						((m_off & 0x4000) >> 11));
+m3_m4_len:
+					while (m_len > 255) {
+						m_len -= 255;
+						*op++ = 0;
+					}
+					*op++ = (unsigned char)(m_len);
+				}
+			}
+	
+m3_m4_offset:
+			*op++ = (unsigned char)((m_off & 63) << 2);
+			*op++ = (unsigned char)(m_off >> 6);
+		}
+	
+		ii = ip;
+		if (unlikely(ip >= ip_end))
+			break;
+	}
+
+	*out_len = (size_t)(op - out);
+	return (size_t)(in_end - ii);
+}
+
+
+/*
+ * This requires buffer (workmem) of size LZO1X_WORKMEM_SIZE
+ * (exported by lzo1x.h).
+ */
+int
+lzo1x_compress(const unsigned char *in, size_t  in_len,
+		unsigned char *out, size_t *out_len,
+		void *workmem)
+{
+	unsigned char *op = out;
+	size_t t;
+
+	if (!workmem)
+		return -EINVAL;
+
+	if (unlikely(in_len <= M2_MAX_LEN + 5))
+		t = in_len;
+	else {
+		t = lzo1x_compress_worker(in, in_len, op, out_len, workmem);
+        	op += *out_len;
+	}
+
+	if (t > 0) {
+		const unsigned char *ii = in + in_len - t;
+
+		if (op == out && t <= 238)
+			*op++ = (unsigned char)(17 + t);
+		else if (t <= 3)
+			op[-2] |= (unsigned char)(t);
+		else if (t <= 18)
+			*op++ = (unsigned char)(t - 3);
+		else {
+			size_t tt = t - 18;
+			*op++ = 0;
+			while (tt > 255) {
+				tt -= 255;
+				*op++ = 0;
+			}
+			*op++ = (unsigned char)tt;
+		}
+		memcpy(op, ii, t);
+		op += t;
+		ii += t;
+	}
+	*op++ = M4_MARKER | 1;
+	*op++ = 0;
+	*op++ = 0;
+
+	*out_len = (size_t)(op - out);
+	return 0;
+}
+
+EXPORT_SYMBOL(lzo1x_compress);
diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
new file mode 100755
index 0000000..09fa1ca
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,224 @@
+/* lzo1x_decompress.c -- LZO1X decompression
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+   All Rights Reserved.
+
+   The LZO library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License,
+   version 2, as published by the Free Software Foundation.
+
+   The LZO library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with the LZO library; see the file COPYING.
+   If not, write to the Free Software Foundation, Inc.,
+   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+   Markus F.X.J. Oberhumer
+   <markus@oberhumer.com>
+   http://www.oberhumer.com/opensource/lzo/
+
+
+   This file is derived from lzo1x_d1.c and lzo1x_d.ch found in original
+   LZO 2.02 code. Some additional changes have also been made to make
+   it work in kernel space.
+
+   Nitin Gupta
+   <nitingupta910@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/byteorder.h>
+#include <linux/lzo1x.h>
+
+#include "lzo1x_int.h"
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Decompression");
+
+int
+lzo1x_decompress(const unsigned char *in, size_t in_len,
+			unsigned char *out, size_t *out_len)
+{
+	size_t t;
+	unsigned char *op = out;
+	const unsigned char *ip = in, *m_pos;
+	const unsigned char * const ip_end = in + in_len;
+#if defined(HAVE_ANY_OP)
+	unsigned char * const op_end = out + *out_len;
+#endif
+	*out_len = 0;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
+		NEED_OP(t);
+		NEED_IP(t + 1);
+		memcpy(op, ip, t);
+		op += t;
+		ip += t;
+		goto first_literal_run;
+	}
+
+	while (TEST_IP) {
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		/* a literal run */
+		if (t == 0) {
+			NEED_IP(1);
+			while (*ip == 0) {
+				t += 255;
+				ip++;
+				NEED_IP(1);
+			}
+			t += 15 + *ip++;
+		}
+		/* copy literals */
+		NEED_OP(t + 3);
+		NEED_IP(t + 4);
+		memcpy(op, ip, t + 3);
+		op += t + 3;
+		ip += t + 3;
+
+first_literal_run:
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		m_pos = op - (1 + M2_MAX_OFFSET);
+		m_pos -= t >> 2;
+		m_pos -= *ip++ << 2;
+		TEST_LB(m_pos);
+		NEED_OP(3);
+		*op++ = *m_pos++;
+		*op++ = *m_pos++;
+		*op++ = *m_pos;
+		goto match_done;
+	
+		/* handle matches */
+		do {
+match:
+			if (t >= 64) {		/* a M2 match */
+				m_pos = op - 1;
+				m_pos -= (t >> 2) & 7;
+				m_pos -= *ip++ << 3;
+				t = (t >> 5) - 1;
+				TEST_LB(m_pos);
+				NEED_OP(t + 3 - 1);
+				goto copy_match;
+			} else if (t >= 32) {	/* a M3 match */
+				t &= 31;
+				if (t == 0) {
+					NEED_IP(1);
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						NEED_IP(1);
+					}
+					t += 31 + *ip++;
+				}
+				m_pos = op - 1 - (cpu_to_le16(
+					*(const unsigned short *)ip) >> 2);
+				ip += 2;
+			} else if (t >= 16) {	/* a M4 match */
+				m_pos = op;
+				m_pos -= (t & 8) << 11;
+				t &= 7;
+				if (t == 0) {
+					NEED_IP(1);
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						NEED_IP(1);
+					}
+					t += 7 + *ip++;
+				}
+				m_pos -= cpu_to_le16(
+					*(const unsigned short *)ip) >> 2;
+				ip += 2;
+				if (m_pos == op)
+					goto eof_found;
+				m_pos -= 0x4000;
+			} else {		/* a M1 match */
+				m_pos = op - 1;
+				m_pos -= t >> 2;
+				m_pos -= *ip++ << 2;
+				TEST_LB(m_pos);
+				NEED_OP(2);
+				*op++ = *m_pos++;
+				*op++ = *m_pos;
+				goto match_done;
+			}
+	
+			/* copy match */
+			TEST_LB(m_pos);
+			NEED_OP(t + 3 - 1);
+
+copy_match:
+			if (op - m_pos >= BITS_PER_LONG / BITS_PER_BYTE) {
+				memcpy(op, m_pos, t + 2);
+				op += t + 2;
+				m_pos += t + 2;
+			} else {
+				*op = *m_pos;
+				*++op = *++m_pos;
+				do
+					*++op = *++m_pos;
+				while (--t > 0);
+				op++;
+				m_pos++;
+			}
+
+match_done:
+			t = ip[-2] & 3;
+			if (t == 0)
+				break;
+	
+			/* copy literals */
+match_next:
+			NEED_OP(t);
+			NEED_IP(t+1);
+			*op++ = *ip++;
+			if (t > 1) {
+				*op++ = *ip++;
+				if (t > 2)
+					*op++ = *ip++;
+			}
+			t = *ip++;
+		} while (TEST_IP);
+	}
+
+#if defined(HAVE_TEST_IP)
+    /* no EOF code was found */
+    *out_len = (size_t)(op - out);
+    return LZO_E_EOF_NOT_FOUND;
+#endif
+
+eof_found:
+	*out_len = (size_t)(op - out);
+	return (ip == ip_end ? LZO_E_OK :
+		(ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN));
+
+#if defined(LZO1X_DECOMPRESS_SAFE)
+input_overrun:
+    *out_len = (size_t)(op - out);
+    return LZO_E_INPUT_OVERRUN;
+
+output_overrun:
+    *out_len = (size_t)(op - out);
+    return LZO_E_OUTPUT_OVERRUN;
+
+lookbehind_overrun:
+    *out_len = (size_t)(op - out);
+    return LZO_E_LOOKBEHIND_OVERRUN;
+#endif
+}
+
+EXPORT_SYMBOL(lzo1x_decompress);
diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
new file mode 100755
index 0000000..69e6d9b
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,122 @@
+/* lzo1x_int.h -- to be used internally by LZO de/compression algorithms
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 1996-2005 Markus Franz Xaver Johannes Oberhumer
+   All Rights Reserved.
+
+   The LZO library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License,
+   version 2, as published by the Free Software Foundation.
+
+   The LZO library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with the LZO library; see the file COPYING.
+   If not, write to the Free Software Foundation, Inc.,
+   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+
+   Markus F.X.J. Oberhumer
+   <markus@oberhumer.com>
+   http://www.oberhumer.com/opensource/lzo/
+
+
+   This file was derived from several header files found in original
+   LZO 2.02 code. Some additional changes have also been made to make
+   it work in kernel space.
+
+   Nitin Gupta
+   <nitingupta910@gmail.com>
+ */
+
+#ifndef __LZO1X_INT_H
+#define __LZO1X_INT_H
+
+#include <linux/types.h>
+
+#define D_BITS		14
+#define D_SIZE		(1u << D_BITS)
+#define D_MASK		(D_SIZE - 1)
+#define D_HIGH		((D_MASK >> 1) + 1)
+
+static inline size_t DX2(const unsigned char *p, size_t s1, size_t s2)
+{
+	return (((((size_t)(p[2]) << s2) ^ p[1]) << s1) ^ p[0]);
+}
+
+static inline size_t DX3(const unsigned char *p, size_t s1, size_t
s2, size_t s3)
+{
+	return (DX2(p + 1, s2, s3) << s1) ^ p[0];
+}
+
+static inline size_t DINDEX1(const unsigned char *p)
+{
+	return ((size_t)(0x21 * DX3(p, 5, 5, 6)) >> 5) & D_MASK;
+}
+
+static inline size_t DINDEX2(size_t d)
+{
+	return (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f);
+}
+
+/* LZO1X Specific constants */
+#define M1_MAX_OFFSET	0x0400
+#define M2_MAX_OFFSET	0x0800
+#define M3_MAX_OFFSET	0x4000
+#define M4_MAX_OFFSET	0xbfff
+
+#define M1_MIN_LEN	2
+#define M1_MAX_LEN	2
+#define M2_MIN_LEN	3
+#define M2_MAX_LEN	8
+#define M3_MIN_LEN	3
+#define M3_MAX_LEN	33
+#define M4_MIN_LEN	3
+#define M4_MAX_LEN	9
+
+#define M1_MARKER	0
+#define M2_MARKER	64
+#define M3_MARKER	32
+#define M4_MARKER	16
+
+/* LZO return codes */
+#define LZO_E_OK			0
+#define LZO_E_ERROR			(-1)
+#define LZO_E_OUT_OF_MEMORY		(-2)    /* [not used right now] */
+#define LZO_E_NOT_COMPRESSIBLE		(-3)    /* [not used right now] */
+#define LZO_E_INPUT_OVERRUN		(-4)
+#define LZO_E_OUTPUT_OVERRUN		(-5)
+#define LZO_E_LOOKBEHIND_OVERRUN	(-6)
+#define LZO_E_EOF_NOT_FOUND		(-7)
+#define LZO_E_INPUT_NOT_CONSUMED	(-8)
+#define LZO_E_NOT_YET_IMPLEMENTED	(-9)    /* [not used right now] */
+
+/* Macros for 'safe' decompression */
+#ifdef LZO1X_DECOMPRESS_SAFE
+
+#define lzo1x_decompress lzo1x_decompress_safe
+#define TEST_IP	(ip < ip_end)
+#define NEED_IP(x) \
+	if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
+#define NEED_OP(x) \
+	if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
+#define TEST_LB(m_pos) \
+	if (m_pos < out || m_pos >= op) goto lookbehind_overrun
+#define HAVE_TEST_IP
+#define HAVE_ANY_OP
+
+#else	/* !LZO1X_DECOMPRESS_SAFE */
+
+#define	TEST_IP		1
+#define	TEST_LB(x)	((void) 0)
+#define	NEED_IP(x)	((void) 0)
+#define	NEED_OP(x)	((void) 0)
+#undef HAVE_TEST_IP
+#undef HAVE_ANY_OP
+
+#endif /* LZO1X_DECOMPRESS_SAFE */
+
+#endif

------=_Part_146284_1174340.1179908855331
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc2.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f20ihz7n
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc2.bz2"

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

------=_Part_146284_1174340.1179908855331--
