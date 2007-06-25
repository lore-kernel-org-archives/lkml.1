Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbXFYMLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbXFYMLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXFYMLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:11:41 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2280 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbXFYMLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:11:40 -0400
Date: Mon, 25 Jun 2007 14:11:58 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Duane Griffin <duaneg@dghda.com>
cc: linux-kernel@vger.kernel.org, didier <did447@gmail.com>,
       Solra Bizna <sbizna@tejat.net>, Daniel Drake <dsd@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] HFS+: Refactor ASCII to unicode conversion routine
 for later reuse
In-Reply-To: <20070620000646.186114175@dastardly.home.dghda.com>
Message-ID: <Pine.LNX.4.64.0706251407320.1817@scrub.home>
References: <20070620000644.891099313@dastardly.home.dghda.com>
 <20070620000646.186114175@dastardly.home.dghda.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 20 Jun 2007, Duane Griffin wrote:

> Refactor existing HFS+ ASCII to unicode string conversion routine to
> split out character conversion functionality. This will be reused by
> the custom dentry hash and comparison routines. This approach avoids
> unnecessary memory allocation compared to using the string conversion
> routine directly in the new functions.

I like the idea of this, but not that it generates larger code, so I 
reformatted it a little to get rid of the decomposed_uc struct which 
required an unnecessary data copy, so now the it even generates slightly 
smaller code. :)

bye, Roman


From: Duane Griffin <duaneg@dghda.com>

Refactor existing HFS+ ASCII to unicode string conversion routine to
split out character conversion functionality. This will be reused by
the custom dentry hash and comparison routines. This approach avoids
unnecessary memory allocation compared to using the string conversion
routine directly in the new functions.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
---
 fs/hfsplus/unicode.c |  105 +++++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 45 deletions(-)

Index: linux-2.6/fs/hfsplus/unicode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/unicode.c
+++ linux-2.6/fs/hfsplus/unicode.c
@@ -239,58 +239,73 @@ out:
 	return res;
 }
 
-int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr, const char *astr, int len)
+/*
+ * Convert one or more ASCII characters into a single unicode character.
+ * Returns the number of ASCII characters corresponding to the unicode char.
+ */
+static inline int asc2unichar(struct super_block *sb, const char *astr, int len,
+			      wchar_t *uc)
 {
-	struct nls_table *nls = HFSPLUS_SB(sb).nls;
-	int size, off, decompose;
+	int size = HFSPLUS_SB(sb).nls->char2uni(astr, len, uc);
+	if (size <= 0) {
+		*uc = '?';
+		size = 1;
+	}
+	switch (*uc) {
+	case 0x2400:
+		*uc = 0;
+		break;
+	case ':':
+		*uc = '/';
+		break;
+	}
+	return size;
+}
+
+/* Decomposes a single unicode character. */
+static inline u16 *decompose_unichar(wchar_t uc, int *size)
+{
+	int off;
+
+	off = hfsplus_decompose_table[(uc >> 12) & 0xf];
+	if (off == 0 || off == 0xffff)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + ((uc >> 8) & 0xf)];
+	if (!off)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + ((uc >> 4) & 0xf)];
+	if (!off)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + (uc & 0xf)];
+	*size = off & 3;
+	return hfsplus_decompose_table + (off / 4);
+}
+
+int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
+		    const char *astr, int len)
+{
+	int size, dsize, decompose;
+	u16 *dstr, outlen = 0;
 	wchar_t c;
-	u16 outlen = 0;
 
 	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
-
 	while (outlen < HFSPLUS_MAX_STRLEN && len > 0) {
-		size = nls->char2uni(astr, len, &c);
-		if (size <= 0) {
-			c = '?';
-			size = 1;
-		}
-		astr += size;
-		len -= size;
-		switch (c) {
-		case 0x2400:
-			c = 0;
-			break;
-		case ':':
-			c = '/';
-			break;
-		}
-		if (c >= 0xc0 && decompose) {
-			off = hfsplus_decompose_table[(c >> 12) & 0xf];
-			if (!off)
-				goto done;
-			if (off == 0xffff) {
-				goto done;
-			}
-			off = hfsplus_decompose_table[off + ((c >> 8) & 0xf)];
-			if (!off)
-				goto done;
-			off = hfsplus_decompose_table[off + ((c >> 4) & 0xf)];
-			if (!off)
-				goto done;
-			off = hfsplus_decompose_table[off + (c & 0xf)];
-			size = off & 3;
-			if (!size)
-				goto done;
-			off /= 4;
-			if (outlen + size > HFSPLUS_MAX_STRLEN)
+		size = asc2unichar(sb, astr, len, &c);
+
+		if (decompose && (dstr = decompose_unichar(c, &dsize))) {
+			if (outlen + dsize > HFSPLUS_MAX_STRLEN)
 				break;
 			do {
-				ustr->unicode[outlen++] = cpu_to_be16(hfsplus_decompose_table[off++]);
-			} while (--size > 0);
-			continue;
-		}
-	done:
-		ustr->unicode[outlen++] = cpu_to_be16(c);
+				ustr->unicode[outlen++] = cpu_to_be16(*dstr++);
+			} while (--dsize > 0);
+		} else
+			ustr->unicode[outlen++] = cpu_to_be16(c);
+
+		astr += size;
+		len -= size;
 	}
 	ustr->length = cpu_to_be16(outlen);
 	if (len > 0)

