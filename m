Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXEYLpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXEYLpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXEYLpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:45:44 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:54050 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760369AbXEYLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=NKduFBRcYkHEKgVYmiadwvWLhPljbPvgaP7feBVLljQZZy5h2I8zKdz2vmLPsus5ILxOtWk4j79M0FnzkA905GM7Pozy3JGQPxy6Cduno6OiE7xqy6pV9TKn4KExOoRWMTpgws5ZwlIjdb1uCCPLg7mBrYa+ffE9KeVG9nXttto=
Message-ID: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
Date: Fri, 25 May 2007 17:15:39 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org
Subject: [RFC] LZO de/compression support - take 4
Cc: "Richard Purdie" <richard@openedhand.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_189639_3957500.1180093539287"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_189639_3957500.1180093539287
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is kernel port of LZO1X compressor and LZO1X decompressor (safe
version only).

* Changes since 'take 3' (Full Changelog after this):
1) Removed 'unsafe' decompressor - hence also do away with symlinks in
Makefiles.
2) Rolled back changes where I replaced COPY4 with memcpy() calls.
This seemed to be causing too much perf. loss as shown by Richard's
tests. Need perf. testing again to confirm that this patch has perf.
comparable to original LZO code/Richard's patch.
3) Some functions were inlined (DX2, DX3 etc.) - this also seemed to
be one of factors for perf. loss. Changed them back Macros.
4) Added back the 'register' keyword - again seemed to me one of
factors for perf. loss.

Once I pinpoint exact reason for bad perf., I will do above cleanups
again. But this should not be reason for non-inclusion in mainline.
These are only minor cleanups.

Richard, can you please provide perf. results for this patch also?
Also, can you please mail back latest version of your LZO patch? In
meantime, I will try to include benchmarking support to the
'compress-test' module.

* Changelog vs. original LZO:
1) Used standard/kernel defined data types: (this eliminated _huge_
#ifdef chunks
    lzo_bytep -> unsigned char *
    lzo_uint -> size_t
    lzo_xint -> size_t
    lzo_uint32p -> u32 *
2) Removed everything #ifdef'ed under COPY_DICT (this is not set for
LZO1X, so removed corres. parts).
3) Removed code #ifdef'ed for LZO1Y, LZO1Z, other variants.
4) Reformatted the code to match general kernel style.
5) The only code change: (as suggested by Andrey)
-#if defined(__LITTLE_ENDIAN)
-                             m_pos = op - 1;
-                             m_pos -= (*(const unsigned short *)ip) >> 2;
-#else
-                             m_pos = op - 1;
-                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
-#endif

+ m_pos = op - 1 - (cpu_to_le16(*(const u16 *)ip) >> 2);

(Andrey suggested le16_to_cpu for above but I think it should be cpu_to_le16).
*** Need testing on big endian machine ***

Similarly:
-#if defined(__LITTLE_ENDIAN)
-                             m_pos -= (*(const unsigned short *)ip) >> 2;
-#else
-                             m_pos -= (ip[0] >> 2) + (ip[1] << 6);
-#endif

+ m_pos -= cpu_to_le16(*(const u16 *)ip) >> 2;


Apart from above changes, original LZO 2.02 code is retained as-is.

  include/linux/lzo1x.h        |   66 +++++++++++
  lib/Kconfig                  |    6 +
  lib/Makefile                 |    1 +
  lib/lzo1x/Makefile           |    3 +
 lib/lzo1x/lzo1x_compress.c   |  256 ++++++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_decompress.c |  235 ++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_int.h        |   85 ++++++++++++++
 7 files changed, 652 insertions(+), 0 deletions(-)

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---
diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
new file mode 100755
index 0000000..11a6f23
--- /dev/null
+++ b/include/linux/lzo1x.h
@@ -0,0 +1,66 @@
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
+ * This requires 'workmem' of size LZO1X_WORKMEM_SIZE
+ */
+int lzo1x_compress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len,
+		void *workmem);
+
+/*
+ * This decompressor will catch all compressed data violations and
+ * return an error code in this case.
+ */
+int lzo1x_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len);
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 2e7ae6b..257f377 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -64,6 +64,12 @@ config ZLIB_INFLATE
  config ZLIB_DEFLATE
  	tristate

+config LZO1X
+	tristate "LZO1X Compression/Decompression"
+	help
+	  Compression: LZO1X-1
+	  Decompression: LZO1X (safe)
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
index 0000000..fcd0d3e
--- /dev/null
+++ b/lib/lzo1x/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_LZO1X) += lzo1x.o
+lzo1x-objs := lzo1x_compress.o lzo1x_decompress.o
+
diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
new file mode 100755
index 0000000..dd3ee99
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
+		DINDEX1(dindex, ip);
+		m_pos = dict[dindex];
+
+		if ((m_pos < in) || (m_off = (size_t)(ip - m_pos)) <= 0
+				 || m_off > M4_MAX_OFFSET)
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		DINDEX2(dindex, ip);
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
+		do
+			*op++ = *ii++;
+		while (--t > 0);
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
index 0000000..cd8f634
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,235 @@
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
+	unsigned char * const op_end = out + *out_len;
+	*out_len = 0;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
+		NEED_OP(t);
+		NEED_IP(t + 1);
+		do
+			*op++ = *ip++;
+		while (--t > 0);
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
+		COPY4(op, ip);
+		op += 4; ip += 4;
+		if (--t > 0) {
+			if (t >= 4) {
+				do {
+					COPY4(op, ip);
+					op += 4; ip += 4; t -= 4;
+				} while (t >= 4);
+				if (t > 0) do *op++ = *ip++; while (--t > 0);
+			}
+			else
+                		do
+					*op++ = *ip++;
+				while (--t > 0);
+		}
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
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
+				COPY4(op, m_pos);
+				op += 4; m_pos += 4; t -= 4 - (3 - 1);
+				do {
+					COPY4(op, m_pos);
+					op += 4; m_pos += 4; t -= 4;
+				} while (t >= 4);
+				if (t > 0)
+					do *op++ = *m_pos++;
+				while (--t > 0);
+			} else {
+copy_match:
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do
+					*op++ = *m_pos++;
+				while (--t > 0);
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
+			NEED_IP(t + 1);
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
+	/* no EOF code was found */
+	*out_len = (size_t)(op - out);
+	return LZO_E_EOF_NOT_FOUND;
+
+eof_found:
+	*out_len = (size_t)(op - out);
+	return (ip == ip_end ? LZO_E_OK :
+		(ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED :
+		LZO_E_INPUT_OVERRUN));
+
+input_overrun:
+	*out_len = (size_t)(op - out);
+	return LZO_E_INPUT_OVERRUN;
+
+output_overrun:
+	*out_len = (size_t)(op - out);
+	return LZO_E_OUTPUT_OVERRUN;
+
+lookbehind_overrun:
+	*out_len = (size_t)(op - out);
+	return LZO_E_LOOKBEHIND_OVERRUN;
+}
+
+EXPORT_SYMBOL(lzo1x_decompress);
diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
new file mode 100755
index 0000000..4f0fe8d
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,85 @@
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
+#define DX2(p,s1,s2) \
+	(((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
+#define DX3(p,s1,s2,s3) \
+	((DX2((p) + 1, s2, s3) << (s1)) ^ (p)[0])
+#define DINDEX1(d,p) \
+	d = ((size_t)(0x21 * DX3(p, 5, 5, 6)) >> 5) & D_MASK
+#define DINDEX2(d,p) \
+	d = (d & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f)
+
+#define COPY4(dst,src)	*(u32 *)(dst) = *(u32 *)(src)
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
+/* Bounds checking */
+#define TEST_IP	(ip < ip_end)
+#define NEED_IP(x) \
+	if ((size_t)(ip_end - ip) < (size_t)(x)) goto input_overrun
+#define NEED_OP(x) \
+	if ((size_t)(op_end - op) < (size_t)(x)) goto output_overrun
+#define TEST_LB(m_pos) \
+	if (m_pos < out || m_pos >= op) goto lookbehind_overrun
+
+#endif

------=_Part_189639_3957500.1180093539287
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc2.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f23oq1y6
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc2.bz2"

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
qlCkndO+d6UMJuRIUf/F3JFOFCQqnGhSAA==
------=_Part_189639_3957500.1180093539287--
