Return-Path: <linux-kernel-owner+w=401wt.eu-S964957AbXFFMe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957AbXFFMe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762458AbXFFMeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:34:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:16271 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323AbXFFMeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=hPrUF+kYcN03WYs6NhVm1fcb7fQCHOdamGvdpBzZmIPZ1rD74kDSiYKtgDnOYBzrumlOz1XNwN/DSk+nVBkS2LYZ1xz5zbKTCISYc+f11+vVrdb19pTGRHALaT0VYJhPTjRI+ikpQpmtmVtQRVv0ozm2XKezA4FJ1XsffQlmJlY=
Message-ID: <4cefeab80706060534h2461ddffu35f463d7728519a0@mail.gmail.com>
Date: Wed, 6 Jun 2007 18:04:17 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] LZO de/compression support - take 7
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_40004_32564654.1181133257339"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_40004_32564654.1181133257339
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
version only).

* Changes since 'take 6' (Full Changelog after this):
1) Fixed unaligned memory access problems as pointed out by author --
LZO_UNALIGNED_OK_{2,4} collapsed to UNALIGNED_OK which is #defined for
archs that allow unaligned access (see lib/lzo1x/Makefile). For other
archs, we fall down to byte-by-byte access avoiding any unaligned
access. In original code, LZO_UNALIGNED_OK_{2,4} resp. describe if we
can do unaligned access for ushort and uint32.

2) le16_to_cpu() is no longer used. After above change, this did not
contribute to cleanups for which it was used in first place.

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

5) Get rid of LZO_CHECK_MPOS_NON_DET macro and PTR* macros.

6) Fixed unaligned memory access problems as pointed out by author --
LZO_UNALIGNED_OK_{2,4} collapsed to UNALIGNED_OK which is #defined for
arch that allow unaligned access (see lib/lzo1x/Makefile). For other
archs, we fall down to byte-by-byte access avoiding any unaligned
access. In original code, LZO_UNALIGNED_OK_{2,4} resp. describe if we
can do unaligned access for ushort and uint32.

* Testing:
Tested on x86(_32) only. Earlier versions were tested on AMD64, PPC
also. No changes have been made since those versions that can affect
correctness on these archs (UNSIGNED_OK is still #defined for them, so
behavior for them is still the same).

  include/linux/lzo1x.h        |   66 ++++++++++
  lib/Kconfig                  |    6 +
  lib/Makefile                 |    2 +
  lib/lzo1x/Makefile           |   16 +++
 lib/lzo1x/lzo1x_compress.c   |  263 ++++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_decompress.c |  270 ++++++++++++++++++++++++++++++++++++++++++
 lib/lzo1x/lzo1x_int.h        |   87 ++++++++++++++
 7 files changed, 710 insertions(+), 0 deletions(-)

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---

diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
new file mode 100755
index 0000000..4fe52a2
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
+#define LZO_E_OUT_OF_MEMORY		(-2)	/* [not used right now] */
+#define LZO_E_NOT_COMPRESSIBLE		(-3)	/* [not used right now] */
+#define LZO_E_INPUT_OVERRUN		(-4)
+#define LZO_E_OUTPUT_OVERRUN		(-5)
+#define LZO_E_LOOKBEHIND_OVERRUN	(-6)
+#define LZO_E_EOF_NOT_FOUND		(-7)
+#define LZO_E_INPUT_NOT_CONSUMED	(-8)
+#define LZO_E_NOT_YET_IMPLEMENTED	(-9)	/* [not used right now] */
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
index 2e7ae6b..eb95eaa 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -64,6 +64,12 @@ config ZLIB_INFLATE
  config ZLIB_DEFLATE
  	tristate

+config LZO1X_COMPRESS
+	tristate
+
+config LZO1X_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index c8c8e20..448ae37 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
+obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x/
+obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x/

  obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
diff --git a/lib/lzo1x/Makefile b/lib/lzo1x/Makefile
new file mode 100644
index 0000000..2f51ca7
--- /dev/null
+++ b/lib/lzo1x/Makefile
@@ -0,0 +1,16 @@
+# Archs where unaligned access is allowed.
+# NOTE: If unaligned access is slower than byte-by-byte access
+#	on some arch, then do not add such arch to this list.
+#	For archs not in this list, normal byte-by-byte access
+#	is done avoiding any unaligned access.
+UNALIGNED_OK_ARCHS = i386 ia64 ppc powerpc
+
+TEST_ARCH = ($(findstring $(ARCH),$(UNALIGNED_OK_ARCHS)))
+
+ifneq ($(TEST_ARCH),"")
+	CFLAGS_lzo1x_compress.o += -DUNALIGNED_OK
+	CFLAGS_lzo1x_decompress.o += -DUNALIGNED_OK
+endif
+
+obj-$(CONFIG_LZO1X_COMPRESS) += lzo1x_compress.o
+obj-$(CONFIG_LZO1X_DECOMPRESS) += lzo1x_decompress.o
diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
new file mode 100755
index 0000000..7b36ee4
--- /dev/null
+++ b/lib/lzo1x/lzo1x_compress.c
@@ -0,0 +1,263 @@
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
+#ifdef UNALIGNED_OK
+		if (*(const unsigned short *)m_pos ==
+				*(const unsigned short *)ip) {
+#else
+		if (m_pos[0] != ip[0] || m_pos[1] != ip[1]) {
+#endif
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
+				op[-2] |= (unsigned char)t;
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
+			do {
+				*op++ = *ii++;
+			} while (--t > 0);
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
+		do {
+			*op++ = *ii++;
+		} while (--t > 0);
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
index 0000000..6ddc1fb
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,270 @@
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
+		do {
+			*op++ = *ip++;
+		} while (--t > 0);
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
+#ifndef UNALIGNED_OK
+		if (((ip | op ) & 3) == 0) {
+#endif
+			COPY4(op, ip);
+			op += 4;
+			ip += 4;
+			if (--t > 0) {
+				if (t >= 4) {
+					do {
+						COPY4(op, ip);
+						op += 4;
+						ip += 4;
+						t -= 4;
+					} while (t >= 4);
+					if (t > 0)
+						do {
+							*op++ = *ip++;
+						} while (--t > 0);
+				} else
+					do {
+						*op++ = *ip++;
+					} while (--t > 0);
+			}
+#ifndef UNALIGNED_OK
+		} else {
+			*op++ = *ip++;
+			*op++ = *ip++;
+			*op++ = *ip++;
+			do {
+				*op++ = *ip++;
+			} while (--t > 0);
+		}
+#endif
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
+#if defined(UNALIGNED_OK) && defined(__LITTLE_ENDIAN)
+				m_pos = op - 1;
+				m_pos -= (*(const unsigned short *)ip) >> 2;
+#else
+				m_pos = op - 1;
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
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
+#if defined(UNALIGNED_OK) && defined(__LITTLE_ENDIAN)
+				m_pos -= (*(const unsigned short *)ip) >> 2;
+#else
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
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
+#ifdef UNALIGNED_OK
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
+#else
+			if (t >= 2 * 4 - (3 - 1) &&
+					(((op | m_pos) &  3) == 0)) {
+#endif
+				COPY4(op, m_pos);
+				op += 4;
+				m_pos += 4;
+				t -= 4 - (3 - 1);
+				do {
+					COPY4(op, m_pos);
+					op += 4;
+					m_pos += 4;
+					t -= 4;
+				} while (t >= 4);
+				if (t > 0)
+					do {
+						*op++ = *m_pos++;
+					} while (--t > 0);
+			} else {
+copy_match:
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do {
+					*op++ = *m_pos++;
+				} while (--t > 0);
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
index 0000000..cf2226d
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,87 @@
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
+#ifdef UNALIGNED_OK
+#define COPY4(dst,src)	*(u32 *)(dst) = *(u32 *)(src)
+#endif
+
+/* LZO1X specific constants */
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

------=_Part_40004_32564654.1181133257339
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc4-take7.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2lri4ee
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc4-take7.bz2"

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
------=_Part_40004_32564654.1181133257339--
