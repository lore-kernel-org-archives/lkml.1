Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXFTANh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXFTANh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbXFTANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:13:30 -0400
Received: from kumera.dghda.com ([80.68.90.171]:4258 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXFTAN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:13:29 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 20:13:29 EDT
From: "Duane Griffin" <duaneg@dghda.com>
Message-Id: <20070620000646.186114175@dastardly.home.dghda.com>
References: <20070620000644.891099313@dastardly.home.dghda.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 01:06:45 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, didier <did447@gmail.com>,
       Solra Bizna <sbizna@tejat.net>, Daniel Drake <dsd@gentoo.org>
Subject: [patch 1/2] HFS+: Refactor ASCII to unicode conversion routine for later reuse
Content-Disposition: inline; filename=hfsplus-refactor-unicode.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor existing HFS+ ASCII to unicode string conversion routine to
split out character conversion functionality. This will be reused by
the custom dentry hash and comparison routines. This approach avoids
unnecessary memory allocation compared to using the string conversion
routine directly in the new functions.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

--- linux-2.6.21.orig/fs/hfsplus/unicode.c
+++ linux-2.6.21/fs/hfsplus/unicode.c
@@ -239,58 +239,97 @@ out:
 	return res;
 }
 
-int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr, const char *astr, int len)
+/*
+ * Convert one or more ASCII characters into a single unicode character.
+ * Returns the number of ASCII characters corresponding to the unicode char.
+ */
+static
+int asc2uc(struct super_block *sb, const char *astr, int len, wchar_t *uc)
 {
-	struct nls_table *nls = HFSPLUS_SB(sb).nls;
-	int size, off, decompose;
-	wchar_t c;
-	u16 outlen = 0;
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
+struct decomposed_uc {
+	int size;
+	wchar_t str[3];
+};
+
+/* Decomposes a single unicode character. */
+static void decompose_uc(wchar_t uc, struct decomposed_uc *duc)
+{
+	int off, ii;
 
-	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
+	duc->size = 1;
+	duc->str[0] = uc;
+
+	off = hfsplus_decompose_table[(uc >> 12) & 0xf];
+	if (off == 0 || off == 0xffff)
+		return;
+
+	off = hfsplus_decompose_table[off + ((uc >> 8) & 0xf)];
+	if (!off)
+		return;
+
+	off = hfsplus_decompose_table[off + ((uc >> 4) & 0xf)];
+	if (!off)
+		return;
+
+	off = hfsplus_decompose_table[off + (uc & 0xf)];
+
+	duc->size = off & 3;
+	off /= 4;
+	for (ii = 0; ii < duc->size; ++ii)
+		duc->str[ii] = hfsplus_decompose_table[off++];
+}
+
+/*
+ * Convert a ASCII character(s) to a unicode character.
+ * The unicode character will be decomposed, if required.
+ * Returns the number of ASCII characters converted.
+ */
+static int asc2ucd(struct super_block *sb,
+	const char *astr, int len, struct decomposed_uc *duc)
+{
+	int size = asc2uc(sb, astr, len, duc->str);
+	bool decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
+
+	if (decompose && *duc->str >= 0xc0)
+		decompose_uc(*duc->str, duc);
+	else
+		duc->size = 1;
+
+	return size;
+}
+
+int hfsplus_asc2uni(struct super_block *sb,
+	struct hfsplus_unistr *ustr, const char *astr, int len)
+{
+	u16 outlen = 0;
+	struct decomposed_uc duc;
 
 	while (outlen < HFSPLUS_MAX_STRLEN && len > 0) {
-		size = nls->char2uni(astr, len, &c);
-		if (size <= 0) {
-			c = '?';
-			size = 1;
-		}
+		int ii;
+		int size = asc2ucd(sb, astr, len, &duc);
+		if (outlen + duc.size > HFSPLUS_MAX_STRLEN)
+			break;
+
 		astr += size;
 		len -= size;
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
-				break;
-			do {
-				ustr->unicode[outlen++] = cpu_to_be16(hfsplus_decompose_table[off++]);
-			} while (--size > 0);
-			continue;
-		}
-	done:
-		ustr->unicode[outlen++] = cpu_to_be16(c);
+		for (ii = 0; ii < duc.size; ++ii)
+			ustr->unicode[outlen++] = cpu_to_be16(duc.str[ii]);
 	}
 	ustr->length = cpu_to_be16(outlen);
 	if (len > 0)

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
