Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbXEVIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbXEVIu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbXEVIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:50:18 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:12242 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXEVIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:50:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=jIiznq7oM/U5Z4sGFKQokfo52ywMgvV2BjhKwoGCkaZhEDaS3HUKVEQ8V+nYggsJZSs7gsT0feX1hASNeN25GJcROw5iBPeEWjDTj8dbWMQh4bS8F8r5HkTQGt0bKwgR5E61K/qBesFzeASDe1YheA+ZI9gB2DHJpdmKQ4uptso=
Message-ID: <4cefeab80705220150p80899bw69e0de0203194ed9@mail.gmail.com>
Date: Tue, 22 May 2007 14:20:13 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: LZO de/compression support - take 2
Cc: "Richard Purdie" <richard@openedhand.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Andrey Panin" <pazke@donpac.ru>, linux-mm-cc@laptop.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_124696_7686708.1179823813542"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_124696_7686708.1179823813542
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is LZO1X-1 compressor and LZO1X decompressor (safe and standard version).

This code is derived from original LZO 2.02 code found at:
http://www.oberhumer.com/opensource/lzo/download/

I am not too sure of some of the additional changes I made. I have
marked these code parts within #if 0 .... #endif blocks and their
replacement code in corres. #if 1 ... #endif blocks. Please consider
esp. these parts in the reviews.
I will remove this #ifdeffery once reviews are done.

Thanks to all who reviewed previous version of this code - this patch
also includes various changes they suggested.

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
index 0000000..9f2db46
--- /dev/null
+++ b/lib/lzo1x/lzo1x_compress.c
@@ -0,0 +1,266 @@
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
+	register const unsigned char *ip;
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
+		register const unsigned char *m_pos;
+		size_t m_off;
+		size_t m_len;
+		size_t dindex;
+
+		DINDEX1(dindex,ip);
+		m_pos = dict[dindex];
+
+#if 0
+		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
+			goto literal;
+#endif
+#if 1
+		if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
+				 || m_off > M4_MAX_OFFSET)
+			goto literal;
+#endif
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		DINDEX2(dindex,ip);
+		m_pos = dict[dindex];
+
+#if 0
+		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
+			goto literal;
+#endif
+#if 1
+		if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
+				 || m_off > M4_MAX_OFFSET)
+			goto literal;
+#endif
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
+			register size_t t = (size_t)(ip - ii);
+			if (t <= 3)
+				op[-2] |= (unsigned char)(t);
+			else if (t <= 18)
+				*op++ = (unsigned char)(t - 3);
+			else {
+				register size_t tt = t - 18;
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
index 0000000..332c0cf
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,266 @@
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
+	register size_t t;
+	register unsigned char *op = out;
+	register const unsigned char *ip = in, *m_pos;
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
+#if 0
+#if defined(__LITTLE_ENDIAN)
+				m_pos = op - 1;
+				m_pos -= (*(const unsigned short *)ip) >> 2;
+#else
+				m_pos = op - 1;
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
+#endif
+#if 1
+				m_pos = op - 1 - (cpu_to_le16(
+					*(const unsigned short *)ip) >> 2);
+#endif
+
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
+#if 0
+#if defined(__LITTLE_ENDIAN)
+				m_pos -= (*(const unsigned short *)ip) >> 2;
+#else
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
+#endif
+#if 1
+				m_pos -= cpu_to_le16(
+					*(const unsigned short *)ip) >> 2;
+#endif
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
+#if 0	// RFC!
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
+				COPY4(op,m_pos);
+				op += 4; m_pos += 4; t -= 4 - (3 - 1);
+				do {
+					COPY4(op,m_pos);
+					op += 4; m_pos += 4; t -= 4;
+				} while (t >= 4);
+				if (t > 0)
+					do
+						*op++ = *m_pos++;
+					while (--t > 0);
+			} else {
+copy_match:
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do
+					*op++ = *m_pos++;
+				while (--t > 0);
+			}
+#endif
+#if 1
+copy_match:
+			if (op - m_pos >= BITS_PER_LONG / BITS_PER_BYTE) {
+				memcpy(op, m_pos, t + 2);
+				op += t + 2;
+				m_pos += t + 2;
+			} else {
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do
+					*op++ = *m_pos++;
+				while (--t > 0);
+			}
+#endif
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
index 0000000..9faa628
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,132 @@
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
+#define D_SIZE		(1u << D_BITS)
+#define D_MASK		(D_SIZE - 1)
+#define D_HIGH		((D_MASK >> 1) + 1)
+
+#define DX2(p,s1,s2) \
+	(((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
+#define DX3(p,s1,s2,s3) ((DX2((p)+1,s2,s3) << (s1)) ^ (p)[0])
+#define DMUL(a,b)	((size_t) ((a) * (b)))
+#define DMS(v,s)	((size_t) (((v) & (D_MASK >> (s))) << (s)))
+#define DM(v)		DMS(v,0)
+
+#define D_BITS		14
+#define DINDEX1(d,p)	d = DM(DMUL(0x21,DX3(p,5,5,6)) >> 5)
+#define DINDEX2(d,p)	d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
+
+/*
+--------------------- Will Disappear --------------------------
+#define PTR(a)		((unsigned long) (a))
+#define PTR_LT(a,b)	(PTR(a) < PTR(b))
+#define PTR_GE(a,b)	(PTR(a) >= PTR(b))
+#define PTR_DIFF(a,b)	(PTR(a) - PTR(b))
+#define pd(a,b)		((size_t) ((a)-(b)))
+
+#define LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,max_offset) \
+	( m_pos = ip - (size_t) PTR_DIFF(ip,m_pos), \
+	PTR_LT(m_pos,in) || \
+	(m_off = (size_t) PTR_DIFF(ip,m_pos)) <= 0 || \
+	m_off > max_offset )
+
+// XXX: what's the meaning of foll. in macro above??
+	( m_pos = ip - (size_t) PTR_DIFF(ip,m_pos), \
+------------------------XXXXX------------------------------------
+*/
+
+/* LZO1X Specific constants */
+
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
+#define LZO_E_OK                    0
+#define LZO_E_ERROR                 (-1)
+#define LZO_E_OUT_OF_MEMORY         (-2)    /* [not used right now] */
+#define LZO_E_NOT_COMPRESSIBLE      (-3)    /* [not used right now] */
+#define LZO_E_INPUT_OVERRUN         (-4)
+#define LZO_E_OUTPUT_OVERRUN        (-5)
+#define LZO_E_LOOKBEHIND_OVERRUN    (-6)
+#define LZO_E_EOF_NOT_FOUND         (-7)
+#define LZO_E_INPUT_NOT_CONSUMED    (-8)
+#define LZO_E_NOT_YET_IMPLEMENTED   (-9)    /* [not used right now] */
+
+/* Macros for 'safe' decompression */
+#ifdef LZO1X_DECOMPRESS_SAFE
+
+#define lzo1x_decompress lzo1x_decompress_safe
+#define LZO_TEST_OVERRUN_LOOKBEHIND
+#define TEST_IP	(ip < ip_end)
+#define NEED_IP(x) \
+	if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
+#define NEED_OP(x) \
+	if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
+#define TEST_LB(m_pos)        if (m_pos < out || m_pos >= op) goto
lookbehind_overrun
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
+#endif /* already included */

------=_Part_124696_7686708.1179823813542
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc2.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f204691w
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc2.bz2"

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
------=_Part_124696_7686708.1179823813542--
