Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXERJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXERJ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXERJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:58:34 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:23432 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbXERJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=AxCsmP6bfSWSHO5UB06sxuTXj+9UIOZakMoz3DEaasRPAZhSJmVEJeXrxt6/3EWs4Ee6xb7DWEcMxAXkibvVXbMD+mJpjOl+iDOheWW7b8R+/gdFDI7e/vMOC3seNIkbboE93wxF24pDdmugMTWidF53UMOdT3Ll6yJQaZDxK4A=
Message-ID: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
Date: Fri, 18 May 2007 15:28:31 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] LZO1X de/compression support
Cc: "Richard Purdie" <richard@openedhand.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_63595_22928973.1179482311423"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_63595_22928973.1179482311423
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This is kernel port of LZO1X de/compression algo stripped down to just ~500 LOC!
It is derived from original LZO 2.02 code found at:
http://www.oberhumer.com/opensource/lzo/download/
The code has also been reformatted to match general kernel style.

Facts for LZO (at least for original code. Should hold true for this
port also - hence the RFC!):
- The compressor can never overrun buffer.
- The "non-safe" version of decompressor can never overrun buffer if
compressed data is unmodified. I am not sure about this if compressed
data is malicious (to be confirmed from the author).
- The "safe" version can never crash (buffer overrun etc.) - confirmed
from the author.

This patch, as of yet, only gives 'non-safe' version of decompressor.
The 'safe' version  will be included soon.

Since 'non-safe' version has no problems if compressed data is
unmodified, it is useful in cases we have such guarantees on
compressed data and hence don't want additional overhead of 'safe'
version. For e.g. Compressed Caching project
(http://linuxcompressed.sourceforge.net) has been using the 'non-safe'
version of LZO1X since long time without any problems w.r.t.
de/compression itself.

For now, I have tested this on x86 only.

Signed-off-by: Nitin Gupta <nitingupta910@gmail.com>
---

diff --git a/include/linux/lzo1x.h b/include/linux/lzo1x.h
new file mode 100755
index 0000000..aae547e
--- /dev/null
+++ b/include/linux/lzo1x.h
@@ -0,0 +1,61 @@
+/* lzo1x.h -- public interface of the LZO1X compression algorithm
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
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
+/* Size of temp buffer (workmem) required by lzo1x_compress */
+#define LZO1X_WORKMEM_SIZE	((size_t) (16384L * sizeof(unsigned char *)))
+
+/* LZO1X_1 compression */
+int
+lzo1x_compress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len,
+		void *workmem);
+
+/* LZO1X_1 decompression */
+int
+lzo1x_decompress(const unsigned char *src, size_t src_len,
+		unsigned char *dst, size_t *dst_len);
+
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
index 0000000..322683e
--- /dev/null
+++ b/lib/lzo1x/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_LZO1X) += lzo1x.o
+lzo1x-objs := lzo1x_compress.o lzo1x_decompress.o
diff --git a/lib/lzo1x/lzo1x_compress.c b/lib/lzo1x/lzo1x_compress.c
new file mode 100755
index 0000000..02e3324
--- /dev/null
+++ b/lib/lzo1x/lzo1x_compress.c
@@ -0,0 +1,255 @@
+/* lzo1x_compress.c -- LZO1X-1 compression
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
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
+		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
+			goto literal;
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		DINDEX2(dindex,ip);
+		m_pos = dict[dindex];
+
+		if (LZO_CHECK_MPOS_NON_DET(m_pos,m_off,in,ip,M4_MAX_OFFSET))
+			goto literal;
+		if (m_off <= M2_MAX_OFFSET || m_pos[3] == ip[3])
+			goto try_match;
+
+		goto literal;
+
+try_match:
+        if (*(const unsigned short *)m_pos != *(const unsigned short *)ip) {
+        } else {
+		if (likely(m_pos[2] == ip[2]))
+			goto match;
+        }
+
+	/* a literal */
+literal:
+	dict[dindex] = ip;
+	++ip;
+	if (unlikely(ip >= ip_end))
+		break;
+	continue;
+
+
+	/* a match */
+match:
+	dict[dindex] = ip;
+	/* store current literal run */
+	if (pd(ip,ii) > 0) {
+		register size_t t = pd(ip,ii);
+		if (t <= 3)
+			op[-2] |= (unsigned char)(t);
+		else if (t <= 18)
+			*op++ = (unsigned char)(t - 3);
+		else {
+			register size_t tt = t - 18;
+			*op++ = 0;
+			while (tt > 255) {
+				tt -= 255;
+				*op++ = 0;
+                	}
+			*op++ = (unsigned char)(tt);
+		}
+		do *op++ = *ii++; while (--t > 0);
+	}
+
+	/* code the match */
+	ip += 3;
+	if (m_pos[3] != *ip++ || m_pos[4] != *ip++ || m_pos[5] != *ip++ ||
+            m_pos[6] != *ip++ || m_pos[7] != *ip++ || m_pos[8] != *ip++) {
+		--ip;
+		m_len = pd(ip, ii);
+
+		if (m_off <= M2_MAX_OFFSET) {
+			m_off -= 1;
+			*op++ = (unsigned char)(((m_len - 1) << 5) | ((m_off & 7) << 2));
+			*op++ = (unsigned char)(m_off >> 3);
+		}
+		else if (m_off <= M3_MAX_OFFSET) {
+			m_off -= 1;
+			*op++ = (unsigned char)(M3_MARKER | (m_len - 2));
+			goto m3_m4_offset;
+		} else {
+			m_off -= 0x4000;
+			*op++ = (unsigned char)(M4_MARKER |
+				((m_off & 0x4000) >> 11) | (m_len - 2));
+			goto m3_m4_offset;
+		}
+        } else {
+		const unsigned char *end = in_end;
+		const unsigned char *m = m_pos + M2_MAX_LEN + 1;
+		while (ip < end && *m == *ip)
+			m++, ip++;
+		m_len = pd(ip, ii);
+
+		if (m_off <= M3_MAX_OFFSET) {
+			m_off -= 1;
+			if (m_len <= 33)
+				*op++ = (unsigned char)(M3_MARKER | (m_len - 2));
+			else {
+				m_len -= 33;
+				*op++ = M3_MARKER | 0;
+				goto m3_m4_len;
+			}
+		} else {
+			m_off -= 0x4000;
+			if (m_len <= M4_MAX_LEN)
+				*op++ = (unsigned char)(M4_MARKER |
+					((m_off & 0x4000) >> 11) | (m_len - 2));
+			else {
+				m_len -= M4_MAX_LEN;
+				*op++ = (unsigned char)(M4_MARKER | ((m_off & 0x4000) >> 11));
+m3_m4_len:
+				while (m_len > 255) {
+					m_len -= 255;
+					*op++ = 0;
+				}
+				*op++ = (unsigned char)(m_len);
+			}
+		}
+
+m3_m4_offset:
+		*op++ = (unsigned char)((m_off & 63) << 2);
+		*op++ = (unsigned char)(m_off >> 6);
+	}
+
+	ii = ip;
+	if (unlikely(ip >= ip_end))
+		break;
+	}
+
+	*out_len = pd(op, out);
+	return pd(in_end,ii);
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
+		t = lzo1x_compress_worker(in,in_len,op,out_len,workmem);
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
+			*op++ = (unsigned char)(tt);
+		}
+		do {
+			*op++ = *ii++;
+		} while (--t > 0);
+	}
+	*op++ = M4_MARKER | 1;
+	*op++ = 0;
+	*op++ = 0;
+
+	*out_len = pd(op, out);
+	return 0;
+}
+
+EXPORT_SYMBOL(lzo1x_compress);
diff --git a/lib/lzo1x/lzo1x_decompress.c b/lib/lzo1x/lzo1x_decompress.c
new file mode 100755
index 0000000..fbd4d69
--- /dev/null
+++ b/lib/lzo1x/lzo1x_decompress.c
@@ -0,0 +1,216 @@
+/* lzo1x_decompress.c -- LZO1X decompression
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
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
+	register unsigned char *op;
+	register const unsigned char *ip, *m_pos;
+	const unsigned char * const ip_end = in + in_len;
+
+	*out_len = 0;
+
+	op = out;
+	ip = in;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
+		do
+			*op++ = *ip++;
+		while (--t > 0);
+		goto first_literal_run;
+	}
+
+	while (1) {
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		/* a literal run */
+		if (t == 0) {
+			while (*ip == 0) {
+				t += 255;
+				ip++;
+			}
+			t += 15 + *ip++;
+		}
+		/* copy literals */
+		COPY4(op,ip);
+		op += 4;
+		ip += 4;
+		if (--t > 0) {
+			if (t >= 4) {
+				do {
+					COPY4(op,ip);
+					op += 4; ip += 4; t -= 4;
+				} while (t >= 4);
+			if (t > 0)
+				do
+					*op++ = *ip++;
+				while (--t > 0);
+			} else
+				do
+					*op++ = *ip++;
+				while (--t > 0);
+		}
+
+first_literal_run:
+
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		m_pos = op - (1 + M2_MAX_OFFSET);
+		m_pos -= t >> 2;
+		m_pos -= *ip++ << 2;
+		*op++ = *m_pos++; *op++ = *m_pos++; *op++ = *m_pos;
+		goto match_done;
+	
+		/* handle matches */
+		do {
+	match:
+			if (t >= 64) {		/* a M2 match */
+				m_pos = op - 1;
+				m_pos -= (t >> 2) & 7;
+				m_pos -= *ip++ << 3;
+				t = (t >> 5) - 1;
+				goto copy_match;
+			} else if (t >= 32) {	/* a M3 match */
+				t &= 31;
+				if (t == 0) {
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+					}
+					t += 31 + *ip++;
+				}
+#if defined(__LITTLE_ENDIAN)
+				m_pos = op - 1;
+				m_pos -= (*(const unsigned short *)ip) >> 2;
+#else
+				m_pos = op - 1;
+				m_pos -= (ip[0] >> 2) + (ip[1] << 6);
+#endif
+			ip += 2;
+			} else if (t >= 16) {	/* a M4 match */
+				m_pos = op;
+				m_pos -= (t & 8) << 11;
+				t &= 7;
+				if (t == 0) {
+					while (*ip == 0) {
+						t += 255;
+						ip++;
+					}
+					t += 7 + *ip++;
+				}
+#if defined(__LITTLE_ENDIAN)
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
+				*op++ = *m_pos++; *op++ = *m_pos;
+				goto match_done;
+			}
+	
+			/* copy match */
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
+				*op++ = *m_pos++; *op++ = *m_pos++;
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
+			*op++ = *ip++;
+			if (t > 1) {
+				*op++ = *ip++;
+				if (t > 2)
+					*op++ = *ip++;
+			}
+			t = *ip++;
+		} while (1);
+	}
+
+eof_found:
+	*out_len = pd(op, out);
+	return (ip == ip_end ? 0 : -1);
+}
+
+EXPORT_SYMBOL(lzo1x_decompress);
diff --git a/lib/lzo1x/lzo1x_int.h b/lib/lzo1x/lzo1x_int.h
new file mode 100755
index 0000000..4dd993d
--- /dev/null
+++ b/lib/lzo1x/lzo1x_int.h
@@ -0,0 +1,105 @@
+/* lzo1x_int.h -- to be used internally by LZO de/compression algorithms
+
+   This file is part of the LZO real-time data compression library.
+
+   Copyright (C) 2005 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2004 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2003 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2002 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2001 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 2000 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1999 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1998 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1997 Markus Franz Xaver Johannes Oberhumer
+   Copyright (C) 1996 Markus Franz Xaver Johannes Oberhumer
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
+#define DENTRY(p,in)	(p)
+
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
+#define COPY4(dst,src)	*(uint32_t *)(dst) = *(uint32_t *)(src)
+
+
+/* LZO1X Specific constants */
+
+#define M1_MAX_OFFSET	0x0400
+#define M2_MAX_OFFSET	0x0800
+#define M3_MAX_OFFSET	0x4000
+#define M4_MAX_OFFSET	0xbfff
+
+#define MX_MAX_OFFSET	(M1_MAX_OFFSET + M2_MAX_OFFSET)
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
+#define MIN_LOOKAHEAD	(M2_MAX_LEN + 1)
+
+#endif /* already included */

------=_Part_63595_22928973.1179482311423
Content-Type: application/x-bzip2; name=patch_lzo_2.6.22-rc1.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1ugkpn0
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc1.bz2"

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
OXYIAA==
------=_Part_63595_22928973.1179482311423--
