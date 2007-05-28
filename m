Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbXE1G7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbXE1G7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXE1G72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:59:28 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:44406 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXE1G70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=KByBomCgu92eJ9BN27rpOi7tmXcEAVfln6uZ+5LQQBLw4FXN5Hvzd0oQijMjU1H0ka6t9tQX8XOV/0PnxLuIqhHwsW+lAwnE5yzpd9g72uKFPhA9rNR79WpTfjnbSuxPuDehm/xbc/B9iFh04JuUlnBgpFt/bBGekJlBMpxgOsw=
Message-ID: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
Date: Mon, 28 May 2007 12:29:25 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net
Subject: [RFC] LZO de/compression support - take 5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_220783_28196686.1180335565302"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_220783_28196686.1180335565302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
version only).

--
If we get no perf. problems with this patch, then I beleive it is now
suitable to inclusion in mainline. Further cleanups and optimizations
can surely be done after that. It's still just ~500 LOC.
--

* Changes since 'take 4' (Full Changelog after this):
1) Again applied 1 cleanup (use cpu_to_le16): this was not causing slower perf.
2) Rolled back very minor cleanup: LZO_CHECK_MPOS_NON_DET macro is
back.   This is the last of cleanups that can cause different
assembler output than original. _Maybe_ this is cause for that ~9%
slowdown seen by Richard in compressor.

Can anyone do timing measurement in kernel space only. This will
eliminate all possible problems w.r.t usespace testing. I tried doing
the same using get_jiffies_64() across calls to compressor in the
'compress-test' module but this is giving same value when measured
just before and after calls to lzo1x_compress(). I don't know why.

If anyone can simply measure time across lzo1x_compress() and
lzo1x_decompress() calls in this compress-test module, then that will
give us proper perf. figures.

* Changelog vs. original LZO:
1) Used standard/kernel defined data types: (this eliminated _huge_
#ifdef chunks)
   lzo_bytep -> unsigned char *
   lzo_uint -> size_t
   lzo_xint -> size_t
   lzo_uint32p -> u32 *
   lzo_uintptr_t  -> unsigned long
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


 include/linux/lzo1x.h        |   66 +++++++++++
 lib/Kconfig                  |    6 +
 lib/Makefile                 |    1 +
 lib/lzo1x/Makefile           |    3 +
 lib/lzo1x/lzo1x_compress.c   |  259 ++++++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_decompress.c |  238 ++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_int.h        |   96 ++++++++++++++++
 7 files changed, 669 insertions(+), 0 deletions(-)

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---

 b/include/linux/lzo1x.h
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
index 0000000..5b0e87f
--- /dev/null
+++ b/lib/lzo1x/lzo1x_compress.c
@@ -0,0 +1,259 @@
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
+#include <linux/lzo1x.h>
+
+#include "lzo1x_int.h"
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Compression");
+
+/* compress a block of data. */
+static noinline unsigned int
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
+		if (LZO_CHECK_MPOS_NON_DET(m_pos, m_off, in, ip,
+				M4_MAX_OFFSET))
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		DINDEX2(dindex, ip);
+		m_pos = dict[dindex];
+
+		if (LZO_CHECK_MPOS_NON_DET(m_pos, m_off, in, ip,
+				M4_MAX_OFFSET))
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
+			do
+				*op++ = *ii++;
+			while (--t > 0);
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
+			op[-2] |= (unsigned char)t;
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
+	return LZO_E_OK;
+}
+
+EXPORT_SYMBOL(lzo1x_compress);
diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
new file mode 100755
index 0000000..75ce294
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,238 @@
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
+				if (t > 0)
+					do
+						*op++ = *ip++;
+					while (--t > 0);
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
index 0000000..6c7850c
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,96 @@
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
+#define PTR(a)		((unsigned long)(a))
+#define PTR_LT(a,b)	(PTR(a) < PTR(b))
+#define PTR_GE(a,b)	(PTR(a) >= PTR(b))
+#define PTR_DIFF(a,b)	(PTR(a) - PTR(b))
+
+#define LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,max_offset) \
+	(m_pos = ip - (size_t)PTR_DIFF(ip, m_pos), \
+	PTR_LT(m_pos, in) || \
+	(m_off = (size_t)PTR_DIFF(ip, m_pos)) <= 0 || \
+	m_off > max_offset)
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

------=_Part_220783_28196686.1180335565302
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc3.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f28kx5v2
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc3.bz2"

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
ZLA=
------=_Part_220783_28196686.1180335565302--
