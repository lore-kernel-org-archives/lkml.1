Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbXFFR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbXFFR1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXFFR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:27:39 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:60012 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbXFFR1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:27:38 -0400
Subject: [PATCH -mm] Add LZO1X compression support to the kernel
From: Richard Purdie <rpurdie@openedhand.com>
To: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 18:26:32 +0100
Message-Id: <1181150792.5686.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add LZO1X compression/decompression support to the kernel.

This has been created by taking my originally proposed patch and slowly
reworking it to conform to CodingStyle whilst periodically comparing the
output bytecode with the original.

The result is a version which gives the exactly same bytecode as the
original code on x86_32, x86_64 and ARM (the ARM version did differ in
one place but the code is functionally the same and it looks like a gcc
optimisation issue).

There are some differences between this version and Nitin's. This
version removes the LZO_ALIGNED_OK_4 code paths since these are not
active in minilzo on any machine. Mine also only activates the unaligned
access ok code paths on x86_32 and x86_64, again in common with minilzo.
This was not functional in my original patch due to issues with the way
the kernel defines UINT_MAX compared to userspace as detailed elsewhere.

There is some ugliness I've not removed, particularly the PTR_*()
defines and the associated two if statements. I think this is the cause
of the code differences I originally saw between Nitin's version and
mine in the compressor so I've left these for further examination. The
bytecode does change quite drastically if I attempt to simplify that
code. 

Also, my version probably adheres to coding style a little more closely
since I moved some variable definitions around and removed a ton of
pointless casts.

Nitin: Have you any objections to this version? If not, I'll finish
analysing the PTR_ code changes and then hopefully we can get something
into -mm...

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/lzo.h        |   51 ++++++++
 lib/Kconfig                |    6 
 lib/Makefile               |    2 
 lib/lzo/Makefile           |    6 
 lib/lzo/lzo1x_compress.c   |  225 ++++++++++++++++++++++++++++++++++++
 lib/lzo/lzo1x_decompress.c |  274 +++++++++++++++++++++++++++++++++++++++++++++
 lib/lzo/lzodefs.h          |   71 +++++++++++
 7 files changed, 635 insertions(+)

Index: linux-2.6.21/include/linux/lzo.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21/include/linux/lzo.h	2007-06-06 17:02:46.000000000 +0100
@@ -0,0 +1,51 @@
+/*
+ * LZO Public Kernel Interface
+ * A mini subset of the LZO real-time data compression library
+ *
+ * Copyright (C) 2007 Nokia Corporation. All rights reserved.
+ *
+ * Author: Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#define LZO1X_MEM_COMPRESS	(16384 * sizeof(unsigned char *))
+#define LZO1X_1_MEM_COMPRESS	LZO1X_MEM_COMPRESS
+
+#define lzo1x_worst_compress(x) (x + (x / 64) + 16 + 3)
+
+int lzo1x_1_compress(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+
+/* safe decompression with overrun testing */
+int lzo1x_decompress_safe(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+
+/*
+ * Return values (< 0 = Error)
+ */
+#define LZO_E_OK                    0
+#define LZO_E_ERROR                 (-1)
+#define LZO_E_OUT_OF_MEMORY         (-2)
+#define LZO_E_NOT_COMPRESSIBLE      (-3)
+#define LZO_E_INPUT_OVERRUN         (-4)
+#define LZO_E_OUTPUT_OVERRUN        (-5)
+#define LZO_E_LOOKBEHIND_OVERRUN    (-6)
+#define LZO_E_EOF_NOT_FOUND         (-7)
+#define LZO_E_INPUT_NOT_CONSUMED    (-8)
+#define LZO_E_NOT_YET_IMPLEMENTED   (-9)
+
+
Index: linux-2.6.21/lib/Kconfig
===================================================================
--- linux-2.6.21.orig/lib/Kconfig	2007-06-06 12:06:38.000000000 +0100
+++ linux-2.6.21/lib/Kconfig	2007-06-06 16:44:38.000000000 +0100
@@ -80,6 +80,12 @@ config ZLIB_INFLATE
 config ZLIB_DEFLATE
 	tristate
 
+config LZO_COMPRESS
+	tristate
+
+config LZO_DECOMPRESS
+	tristate
+
 #
 # Generic allocator support is selected if needed
 #
Index: linux-2.6.21/lib/Makefile
===================================================================
--- linux-2.6.21.orig/lib/Makefile	2007-06-06 12:06:38.000000000 +0100
+++ linux-2.6.21/lib/Makefile	2007-06-06 16:41:17.000000000 +0100
@@ -51,6 +51,8 @@ obj-$(CONFIG_GENERIC_ALLOCATOR) += genal
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
 obj-$(CONFIG_ZLIB_DEFLATE) += zlib_deflate/
 obj-$(CONFIG_REED_SOLOMON) += reed_solomon/
+obj-$(CONFIG_LZO_COMPRESS) += lzo/
+obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 
 obj-$(CONFIG_TEXTSEARCH) += textsearch.o
 obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
Index: linux-2.6.21/lib/lzo/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21/lib/lzo/Makefile	2007-06-06 16:33:57.000000000 +0100
@@ -0,0 +1,6 @@
+lzo_compress-objs := lzo1x_compress.o
+lzo_decompress-objs := lzo1x_decompress.o
+
+obj-$(CONFIG_LZO_COMPRESS) += lzo_compress.o
+obj-$(CONFIG_LZO_DECOMPRESS) += lzo_decompress.o
+
Index: linux-2.6.21/lib/lzo/lzodefs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21/lib/lzo/lzodefs.h	2007-06-06 17:25:10.000000000 +0100
@@ -0,0 +1,71 @@
+/* lzodefs.h -- architecture, OS and compiler specific defines
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
+   Markus F.X.J. Oberhumer <markus@oberhumer.com>
+
+   The full LZO package can be found at:
+   http://www.oberhumer.com/opensource/lzo/
+
+   Trimmed for kernel use by:
+   Richard Purdie <rpurdie@openedhand.com>
+ */
+
+#define LZO_VERSION             0x2020
+#define LZO_VERSION_STRING      "2.02"
+#define LZO_VERSION_DATE        "Oct 17 2005"
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
+#define D_BITS		14
+#define D_MASK		((1u << D_BITS) - 1)
+#define D_HIGH		((D_MASK >> 1) + 1)
+
+#define _DINDEX(dv,p)	(((0x9f5f * (dv))) >> 5)
+#define DINDEX(dv,p)	((size_t)((_DINDEX(dv,p)) & D_MASK))
+
+#define DX2(p,s1,s2) 	(((((size_t)((p)[2]) << (s2)) ^ (p)[1]) << (s1)) ^ (p)[0])
+
+#define DX3(p,s1,s2,s3) ((DX2((p)+1,s2,s3) << (s1)) ^ (p)[0])
+#define DMS(v,s)	((size_t) (((v) & (D_MASK >> (s))) << (s)))
+
+/* Which machines to allow unaligned accesses on */
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
+#define LZO_UNALIGNED_OK_2
+#define LZO_UNALIGNED_OK_4
+#endif
+
Index: linux-2.6.21/lib/lzo/lzo1x_compress.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21/lib/lzo/lzo1x_compress.c	2007-06-06 17:23:55.000000000 +0100
@@ -0,0 +1,225 @@
+/*
+ *  LZO1X Compressor from MiniLZO
+ *
+ *  Copyright (C) 1996-2005 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ *  The full LZO package can be found at:
+ *  http://www.oberhumer.com/opensource/lzo/
+ *
+ *  Changed for kernel use by:
+ *  Richard Purdie <rpurdie@openedhand.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/string.h>
+#include <linux/lzo.h>
+#include "lzodefs.h"
+
+#define PTR_LT(a,b)		(((unsigned long)(a)) < ((unsigned long)(b)))
+#define PTR_DIFF(a,b)		(((unsigned long)(a)) - ((unsigned long)(b)))
+
+static noinline size_t
+_lzo1x_1_do_compress(const unsigned char *in , size_t in_len,
+		unsigned char *out, size_t *out_len, void *wrkmem)
+{
+	const unsigned char * const in_end = in + in_len;
+	const unsigned char * const ip_end = in + in_len - M2_MAX_LEN - 5;
+	const unsigned char ** const dict = wrkmem;
+	const unsigned char *ip = in, *ii = ip;
+	const unsigned char *end, *m, *m_pos;
+	size_t m_off, m_len, dindex;
+	unsigned char *op = out;
+
+	ip += 4;
+
+	for (;;) {
+		dindex = DMS((0x21 * DX3(ip,5,5,6)) >> 5, 0);
+		m_pos = dict[dindex];
+
+		if (m_pos = ip - (unsigned long) PTR_DIFF(ip,m_pos),
+			(PTR_LT(m_pos,in) ||
+			(m_off = (unsigned long) PTR_DIFF(ip,m_pos)) == 0 ||
+			m_off > M4_MAX_OFFSET ))
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		dindex = (dindex & (D_MASK & 0x7ff)) ^ (D_HIGH | 0x1f);
+		m_pos = dict[dindex];
+
+		if (m_pos = ip - (unsigned long) PTR_DIFF(ip,m_pos),
+			(PTR_LT(m_pos,in) ||
+			(m_off = (unsigned long) PTR_DIFF(ip,m_pos)) <= 0 ||
+			m_off > M4_MAX_OFFSET ))
+			goto literal;
+
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		goto literal;
+
+try_match:
+#if defined(LZO_UNALIGNED_OK_2)
+		if (*(const unsigned short *) m_pos == *(const unsigned short *) ip)
+#else
+		if (m_pos[0] == ip[0] && m_pos[1] == ip[1])
+#endif
+		{
+			if (likely(m_pos[2] == ip[2]))
+					goto match;
+		}
+
+literal:
+		dict[dindex] = ip;
+		++ip;
+		if (unlikely(ip >= ip_end))
+			break;
+		continue;
+
+match:
+		dict[dindex] = ip;
+		if (((unsigned long) (ip - ii)) > 0) {
+			size_t t = ip - ii;
+
+			if (t <= 3) {
+				op[-2] |= t;
+			} else if (t <= 18) {
+				*op++ = (t - 3);
+			} else {
+				size_t tt = t - 18;
+
+				*op++ = 0;
+				while (tt > 255) {
+					tt -= 255;
+					*op++ = 0;
+				}
+				*op++ = tt;
+			}
+			do {
+				*op++ = *ii++;
+			} while (--t > 0);
+		}
+
+		ip += 3;
+		if (m_pos[3] != *ip++ || m_pos[4] != *ip++ || m_pos[5] != *ip++ ||
+			m_pos[6] != *ip++ || m_pos[7] != *ip++ || m_pos[8] != *ip++) {
+			--ip;
+			m_len = ip - ii;
+
+			if (m_off <= M2_MAX_OFFSET) {
+				m_off -= 1;
+				*op++ = (((m_len - 1) << 5) | ((m_off & 7) << 2));
+				*op++ = (m_off >> 3);
+			} else if (m_off <= M3_MAX_OFFSET) {
+				m_off -= 1;
+				*op++ = (M3_MARKER | (m_len - 2));
+				goto m3_m4_offset;
+			} else {
+				m_off -= 0x4000;
+
+				*op++ = (M4_MARKER | ((m_off & 0x4000) >> 11) | (m_len - 2));
+				goto m3_m4_offset;
+			}
+		} else {
+			end = in_end;
+			m = m_pos + M2_MAX_LEN + 1;
+
+			while (ip < end && *m == *ip)
+				m++, ip++;
+			m_len = ip - ii;
+
+			if (m_off <= M3_MAX_OFFSET) {
+				m_off -= 1;
+				if (m_len <= 33) {
+					*op++ = (M3_MARKER | (m_len - 2));
+				} else {
+					m_len -= 33;
+					*op++ = M3_MARKER | 0;
+					goto m3_m4_len;
+				}
+			} else {
+				m_off -= 0x4000;
+				if (m_len <= M4_MAX_LEN) {
+					*op++ = (M4_MARKER | ((m_off & 0x4000) >> 11) | (m_len - 2));
+				} else {
+					m_len -= M4_MAX_LEN;
+					*op++ = (M4_MARKER | ((m_off & 0x4000) >> 11));
+m3_m4_len:
+					while (m_len > 255) {
+						m_len -= 255;
+						*op++ = 0;
+					}
+
+					*op++ = (m_len);
+				}
+			}
+m3_m4_offset:
+			*op++ = ((m_off & 63) << 2);
+			*op++ = (m_off >> 6);
+		}
+
+		ii = ip;
+		if (unlikely(ip >= ip_end))
+			break;
+	}
+
+	*out_len = op - out;
+	return in_end - ii;
+}
+
+int lzo1x_1_compress(const unsigned char *in , size_t in_len,
+			unsigned char *out, size_t *out_len,
+			void *wrkmem )
+{
+	const unsigned char *ii;
+	unsigned char *op = out;
+	size_t t;
+
+	if (unlikely(in_len <= M2_MAX_LEN + 5)) {
+		t = in_len;
+	} else {
+		t = _lzo1x_1_do_compress(in,in_len,op,out_len,wrkmem);
+		op += *out_len;
+	}
+
+	if (t > 0) {
+		ii = in + in_len - t;
+
+		if (op == out && t <= 238) {
+			*op++ = (17 + t);
+		} else if (t <= 3) {
+			op[-2] |= (t);
+		} else if (t <= 18) {
+			*op++ = (t - 3);
+		} else {
+			size_t tt = t - 18;
+
+			*op++ = 0;
+			while (tt > 255) {
+				tt -= 255;
+				*op++ = 0;
+			}
+
+			*op++ = (tt);
+		}
+		do {
+			*op++ = *ii++;
+		} while (--t > 0);
+	}
+
+	*op++ = M4_MARKER | 1;
+	*op++ = 0;
+	*op++ = 0;
+
+	*out_len = op - out;
+	return LZO_E_OK;
+}
+
+EXPORT_SYMBOL_GPL(lzo1x_1_compress);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Compressor");
+
Index: linux-2.6.21/lib/lzo/lzo1x_decompress.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21/lib/lzo/lzo1x_decompress.c	2007-06-06 17:18:10.000000000 +0100
@@ -0,0 +1,274 @@
+/*
+ *  LZO1X Decompressor from MiniLZO
+ *
+ *  Copyright (C) 1996-2005 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ *  The full LZO package can be found at:
+ *  http://www.oberhumer.com/opensource/lzo/
+ *
+ *  Changed for kernel use by:
+ *  Richard Purdie <rpurdie@openedhand.com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/string.h>
+#include <linux/lzo.h>
+#include "lzodefs.h"
+
+#define HAVE_IP_OR(x, ip_end, ip) ((size_t)(ip_end - ip) < (size_t)(x))
+#define HAVE_OP_OR(x, op_end, op) ((size_t)(op_end - op) < (size_t)(x))
+#define HAVE_LB_OR(m_pos, out, op) (m_pos < out || m_pos >= op)
+
+#if defined(LZO_UNALIGNED_OK_4)
+#define COPY4(dst,src)	*(u32 *)(dst) = *(const u32 *)(src)
+#endif
+
+int lzo1x_decompress_safe (const unsigned char *in , size_t in_len,
+			unsigned char *out, size_t *out_len)
+{
+	const unsigned char * const ip_end = in + in_len;
+	unsigned char * const op_end = out + *out_len;
+	const unsigned char *ip = in, *m_pos;
+	unsigned char *op = out;
+	unsigned long t;
+
+	*out_len = 0;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
+		if (HAVE_OP_OR(t, op_end, op))
+			goto output_overrun;
+		if (HAVE_IP_OR(t + 1, ip_end, ip))
+			goto input_overrun;
+		do {
+			*op++ = *ip++;
+		} while (--t > 0);
+		goto first_literal_run;
+	}
+
+	while ((ip < ip_end)) {
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		if (t == 0) {
+			if (HAVE_IP_OR(1, ip_end, ip))
+				goto input_overrun;
+			while (*ip == 0) {
+				t += 255;
+				ip++;
+				if (HAVE_IP_OR(1, ip_end, ip))
+					goto input_overrun;
+			}
+			t += 15 + *ip++;
+		}
+		if (HAVE_OP_OR(t + 3, op_end, op))
+			goto output_overrun;
+		if (HAVE_IP_OR(t + 4, ip_end, ip))
+			goto input_overrun;
+
+#if defined(LZO_UNALIGNED_OK_4)
+		COPY4(op,ip);
+		op += 4;
+		ip += 4;
+		if (--t > 0) {
+			if (t >= 4) {
+				do {
+					COPY4(op,ip);
+					op += 4;
+					ip += 4;
+					t -= 4;
+				} while (t >= 4);
+				if (t > 0) {
+					do {
+						*op++ = *ip++;
+					} while (--t > 0);
+				}
+			} else {
+				do {
+					*op++ = *ip++;
+				} while (--t > 0);
+			}
+		}
+#else
+		*op++ = *ip++;
+		*op++ = *ip++;
+		*op++ = *ip++;
+		do {
+			*op++ = *ip++;
+		} while (--t > 0);
+#endif
+
+first_literal_run:
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		m_pos = op - (1 + M2_MAX_OFFSET);
+		m_pos -= t >> 2;
+		m_pos -= *ip++ << 2;
+
+		if (HAVE_LB_OR(m_pos, out, op))
+			goto lookbehind_overrun;
+
+		if (HAVE_OP_OR(3, op_end, op))
+			goto output_overrun;
+		*op++ = *m_pos++;
+		*op++ = *m_pos++;
+		*op++ = *m_pos;
+
+		goto match_done;
+
+		do {
+match:
+			if (t >= 64) {
+				m_pos = op - 1;
+				m_pos -= (t >> 2) & 7;
+				m_pos -= *ip++ << 3;
+				t = (t >> 5) - 1;
+				if (HAVE_LB_OR(m_pos, out, op))
+					goto lookbehind_overrun;
+				if (HAVE_OP_OR(t + 3 - 1, op_end, op))
+					goto output_overrun;
+				goto copy_match;
+			} else if (t >= 32) {
+				t &= 31;
+				if (t == 0) {
+					if (HAVE_IP_OR(1, ip_end, ip))
+						goto input_overrun;
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						if (HAVE_IP_OR(1, ip_end, ip))
+							goto input_overrun;
+					}
+					t += 31 + *ip++;
+				}
+#if defined(LZO_UNALIGNED_OK_2) && defined(__LITTLE_ENDIAN)
+				m_pos = op - 1;
+				m_pos -= (*(const unsigned short *) ip) >> 2;
+#else
+				m_pos = op - 1;
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
+				ip += 2;
+			} else if (t >= 16) {
+				m_pos = op;
+				m_pos -= (t & 8) << 11;
+
+				t &= 7;
+				if (t == 0) {
+					if (HAVE_IP_OR(1, ip_end, ip))
+						goto input_overrun;
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+						if (HAVE_IP_OR(1, ip_end, ip))
+							goto input_overrun;
+					}
+					t += 7 + *ip++;
+				}
+#if defined(LZO_UNALIGNED_OK_2) && defined(__LITTLE_ENDIAN)
+				m_pos -= (*(const unsigned short *) ip) >> 2;
+#else
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
+				ip += 2;
+				if (m_pos == op)
+					goto eof_found;
+				m_pos -= 0x4000;
+			} else {
+				m_pos = op - 1;
+				m_pos -= t >> 2;
+				m_pos -= *ip++ << 2;
+
+				if (HAVE_LB_OR(m_pos, out, op))
+					goto lookbehind_overrun;
+				if (HAVE_OP_OR(2, op_end, op))
+					goto output_overrun;
+
+				*op++ = *m_pos++;
+				*op++ = *m_pos;
+				goto match_done;
+			}
+
+			if (HAVE_LB_OR(m_pos, out, op))
+				goto lookbehind_overrun;
+			if (HAVE_OP_OR(t + 3 - 1, op_end, op))
+				goto output_overrun;
+
+#if defined(LZO_UNALIGNED_OK_4)
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
+				COPY4(op,m_pos);
+				op += 4;
+				m_pos += 4;
+				t -= 4 - (3 - 1);
+				do {
+					COPY4(op,m_pos);
+					op += 4;
+					m_pos += 4;
+					t -= 4;
+				} while (t >= 4);
+				if (t > 0)
+					do {
+						*op++ = *m_pos++;
+					} while (--t > 0);
+			} else
+#endif
+			{
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
+match_next:
+			if (HAVE_OP_OR(t, op_end, op))
+				goto output_overrun;
+			if (HAVE_IP_OR(t + 1, ip_end, ip))
+				goto input_overrun;
+
+			*op++ = *ip++;
+			if (t > 1) {
+				*op++ = *ip++;
+				if (t > 2)
+					*op++ = *ip++;
+			}
+
+			t = *ip++;
+		} while (ip < ip_end);
+	}
+
+	*out_len = op - out;
+	return LZO_E_EOF_NOT_FOUND;
+
+eof_found:
+	*out_len = op - out;
+	return (ip == ip_end ? LZO_E_OK :
+		(ip < ip_end ? LZO_E_INPUT_NOT_CONSUMED : LZO_E_INPUT_OVERRUN));
+input_overrun:
+	*out_len = op - out;
+	return LZO_E_INPUT_OVERRUN;
+
+output_overrun:
+	*out_len = op - out;
+	return LZO_E_OUTPUT_OVERRUN;
+
+lookbehind_overrun:
+	*out_len = op - out;
+	return LZO_E_LOOKBEHIND_OVERRUN;
+}
+
+EXPORT_SYMBOL_GPL(lzo1x_decompress_safe);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LZO1X Decompressor");
+

