Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbZDANli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbZDANli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764789AbZDANlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:41:13 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:3488 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764720AbZDANlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d54s2bXPejaNxd3u0RjxAQSkSlNIOv1SkJQY2au7ZpGhTif735Lag6TG87+At1uDAx
         eKpvxxVRKPS9FqsT/ko9HNxthh7sFOjQFT3N0BC3e7RobHTi4yLXc+Wpf/BZmw3P6Z1o
         ow/jd3iCXF6Wvr0hQTmLCAL6opZPs/snZvcDU=
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib: add fast lzo decompressor
Date: Wed,  1 Apr 2009 15:40:51 +0200
Message-Id: <1238593252-3435-2-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1238593252-3435-1-git-send-email-andr345@gmail.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an LZO decompressor tweaked to be faster than
the 'safe' decompressor already in the kernel.

On x86_64, it runs in roughly 80% of the time needed by the safe
decompressor.

This function is inherently insecure and can cause buffer overruns.
It is only intended for decompressing implicitly trusted data, such
as an initramfs and the kernel itself.

As such, the function is neither exported nor declared in a header.

Signed-off-by: Andreas Robinson <andr345@gmail.com>
---
 lib/lzo/lzo1x_decompress_fast.c |  206 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 lib/lzo/lzo1x_decompress_fast.c

diff --git a/lib/lzo/lzo1x_decompress_fast.c b/lib/lzo/lzo1x_decompress_fast.c
new file mode 100644
index 0000000..4f7908f
--- /dev/null
+++ b/lib/lzo/lzo1x_decompress_fast.c
@@ -0,0 +1,206 @@
+/*
+ *  LZO1X Decompressor from MiniLZO
+ *
+ *  Copyright (C) 1996-2005 Markus F.X.J. Oberhumer <markus@oberhumer.com>
+ *
+ *  The full LZO package can be found at:
+ *  http://www.oberhumer.com/opensource/lzo/
+ *
+ *  Changed for kernel use by:
+ *  Nitin Gupta <nitingupta910@gmail.com>
+ *  Richard Purdie <rpurdie@openedhand.com>
+ *
+ *  Added 'fast' decompressor:
+ *  Andreas Robinson <andr345@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/lzo.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#define M2_MAX_OFFSET	0x0800
+#define COPY4(dst, src)	\
+		put_unaligned(get_unaligned((const u32 *)(src)), (u32 *)(dst))
+
+/* Faster lzo1x decompression.
+ *
+ * This function is inherently insecure and can cause buffer overruns.
+ * It is not intended for general use and should never be exported or
+ * passed untrusted data.
+ *
+ * The function can also overrun the destination buffer by up to 3 bytes
+ * for performance reasons. Be sure to size the output buffer accordingly.
+ *
+ * Implementation notes - comparisons to the 'safe' decompressor:
+ *
+ * - Removed bounds checking.
+ * - Made copying 32-bit whenever possible.
+ *   This is what causes 3-byte overruns of the destination buffer.
+ * - Added branch prediction hints.
+ *   The likely/unlikely choices were made based on performance testing
+ *   with a 5MB compressed initramfs.
+ */
+int lzo1x_decompress_fast(const unsigned char *in, size_t in_len,
+			  unsigned char *out, size_t *out_len)
+{
+	const unsigned char * const ip_end = in + in_len;
+	const unsigned char *ip = in, *m_pos;
+	unsigned char *op = out;
+	long t;
+
+	*out_len = 0;
+
+	if (*ip > 17) {
+		t = *ip++ - 17;
+		if (t < 4)
+			goto match_next;
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
+			while (*ip == 0) {
+				t += 255;
+				ip++;
+			}
+			t += 15 + *ip++;
+		}
+
+		t += 3;
+		while (t > 0) {
+			COPY4(op, ip);
+			op += 4;
+			ip += 4;
+			t -= 4;
+		}
+		op += t;
+		ip += t;
+
+first_literal_run:
+		t = *ip++;
+		if (t >= 16)
+			goto match;
+		m_pos = op - (1 + M2_MAX_OFFSET);
+		m_pos -= t >> 2;
+		m_pos -= *ip++ << 2;
+
+		*op++ = *m_pos++;
+		*op++ = *m_pos++;
+		*op++ = *m_pos;
+
+		goto match_done;
+
+		do {
+match:
+			if (likely(t >= 64)) {
+				unsigned char u = t;
+				m_pos = op - 1;
+				m_pos -= (t >> 2) & 7;
+				m_pos -= *ip++ << 3;
+				t = (t >> 5) - 1;
+				/* 0 <= t <= 6 */
+
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do {
+					*op++ = *m_pos++;
+				} while (--t > 0);
+
+				t = u & 3;
+				if (t == 0)
+					break;
+				goto match_next;
+
+			} else if (t >= 32) {
+				t &= 31;
+				if (t == 0) {
+					while (unlikely(*ip == 0)) {
+						t += 255;
+						ip++;
+					}
+					t += 31 + *ip++;
+				}
+				m_pos = op - 1;
+				m_pos -= get_unaligned_le16(ip) >> 2;
+				ip += 2;
+
+			} else if (t >= 16) {
+				m_pos = op;
+				m_pos -= (t & 8) << 11;
+
+				t &= 7;
+				if (t == 0) {
+					while (unlikely(*ip == 0)) {
+						t += 255;
+						ip++;
+					}
+					t += 7 + *ip++;
+				}
+				m_pos -= get_unaligned_le16(ip) >> 2;
+				ip += 2;
+				if (m_pos == op)
+					goto eof_found;
+				m_pos -= 0x4000;
+
+			} else {
+				m_pos = op - 1;
+				m_pos -= t >> 2;
+				m_pos -= *ip++ << 2;
+
+				*op++ = *m_pos++;
+				*op++ = *m_pos;
+				goto match_done;
+			}
+
+			if (t >= 2 * 4 - (3 - 1) && (op - m_pos) >= 4) {
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
+				while (t > 0) {
+					*op++ = *m_pos++;
+					t--;
+				}
+			} else {
+				/* copy_match */
+				*op++ = *m_pos++;
+				*op++ = *m_pos++;
+				do {
+					*op++ = *m_pos++;
+				} while (--t > 0);
+			}
+match_done:
+			t = ip[-2] & 3;
+			if (t == 0)
+				break;
+match_next:		/* 1 <= t <= 3 */
+			COPY4(op, ip);
+			op += t;
+			ip += t;
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
+}
+
-- 
1.5.6.3

