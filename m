Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbZD0Pve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbZD0Pve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbZD0PvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:51:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58766 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755728AbZD0PvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:51:22 -0400
Date: Mon, 27 Apr 2009 11:51:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: NLS: utf8 conversions
In-Reply-To: <49F5682F.20300@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.0904271144330.10904-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Clemens Ladisch wrote:

> The single-character utf8_* routines in nls_base.c are just special
> cases of the NLS API for the UTF-8 encoding; the string-oriented
> routines, as far as I can see, are actually only used to do conversions
> between UTF-8 and UTF-16, not wchar_t, so they probably should be
> renamed.
> 
> As for the NLS API itself: If we want to be able to handle code points
> larger than U+FFFF, the obvious answer is to make wchar_t a 32-bit type.
> This should not be too large a problem because the FS NLS API is
> designed so that wchar_t is only used for temporary values, i.e.,
> characters are converted from some on-disk encoding to wchar_t, then
> from wchar_t to some I/O encoding (usually UTF-8); and the conversions
> are done one code point at a time.
> 
> The file systems that use some form of UTF-16 (VFAT, NTFS, CIFS, UDF,
> etc.) use the NLS API in a different way: they treat the individual
> UTF-16 values as wchar_t values and do only the conversion from wchar_t
> to the I/O encoding.  Here we'd need to introduce an additional
> conversion step between UTF-16 and wchar_t, i.e., treat UTF-16 like any
> other multibyte encoding.

Your comments agree pretty well with what I had concluded.  However a 
lot of the source files have lengthy tables of wchar_t values; changing 
them to 32 bits would waste a lot of space.

As a sort of compromise, I came up with this patch (not tested yet,
although it compiles okay).  How does it look to you?

Alan Stern



Index: usb-2.6/include/linux/nls.h
===================================================================
--- usb-2.6.orig/include/linux/nls.h
+++ usb-2.6/include/linux/nls.h
@@ -3,8 +3,23 @@
 
 #include <linux/init.h>
 
-/* unicode character */
-typedef __u16 wchar_t;
+/* Unicode has changed over the years.  Unicode code points no longer
+ * fit into 16 bits; as of Unicode 5 valid code points range from 0
+ * to 0x10ffff (17 planes, where each plane holds 65536 code points).
+ *
+ * The original decision to represent Unicode characters as 16-bit
+ * wchar_t values is now outdated.  But plane 0 still includes the
+ * most commonly used characters, so we will retain it.  The newer
+ * 32-bit unicode_t type can be used when it is necessary to
+ * represent the full Unicode character set.
+ */
+
+/* Plane-0 Unicode character */
+typedef u16 wchar_t;
+#define MAX_WCHAR_T	0xffff
+
+/* Arbitrary Unicode character */
+typedef u32 unicode_t;
 
 struct nls_table {
 	const char *charset;
@@ -21,6 +36,13 @@ struct nls_table {
 /* this value hold the maximum octet of charset */
 #define NLS_MAX_CHARSET_SIZE 6 /* for UTF-8 */
 
+/* Byte order for UTF-16 strings */
+enum utf16_endian {
+	UTF16_HOST_ENDIAN,
+	UTF16_LITTLE_ENDIAN,
+	UTF16_BIG_ENDIAN
+};
+
 /* nls.c */
 extern int register_nls(struct nls_table *);
 extern int unregister_nls(struct nls_table *);
@@ -28,10 +50,10 @@ extern struct nls_table *load_nls(char *
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
 
-extern int utf8_mbtowc(wchar_t *, const __u8 *, int);
-extern int utf8_mbstowcs(wchar_t *, const __u8 *, int);
-extern int utf8_wctomb(__u8 *, wchar_t, int);
-extern int utf8_wcstombs(__u8 *, const wchar_t *, int);
+extern int utf8_to_utf32(unicode_t *, const u8 *, int);
+extern int utf32_to_utf8(u8 *, unicode_t, int);
+extern int utf8s_to_utf16s(wchar_t *, const u8 *, int);
+extern int utf16s_to_utf8s(u8 *, const wchar_t *, int, int, enum utf16_endian);
 
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned char c)
 {
Index: usb-2.6/fs/nls/nls_base.c
===================================================================
--- usb-2.6.orig/fs/nls/nls_base.c
+++ usb-2.6/fs/nls/nls_base.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/kmod.h>
 #include <linux/spinlock.h>
+#include <asm/byteorder.h>
 
 static struct nls_table default_table;
 static struct nls_table *tables = &default_table;
@@ -43,10 +44,18 @@ static const struct utf8_table utf8_tabl
     {0,						       /* end of table    */}
 };
 
+#define UNICODE_MAX	0x0010ffff
+#define PLANE_SIZE	0x00010000
+
+#define SURROGATE_MASK	0xfffff800
+#define SURROGATE_PAIR	0x0000d800
+#define SURROGATE_LOW	0x00000400
+#define SURROGATE_BITS	0x000003ff
+
 int
-utf8_mbtowc(wchar_t *p, const __u8 *s, int n)
+utf8_to_utf32(unicode_t *p, const u8 *s, int n)
 {
-	long l;
+	unsigned long l;
 	int c0, c, nc;
 	const struct utf8_table *t;
   
@@ -57,9 +66,10 @@ utf8_mbtowc(wchar_t *p, const __u8 *s, i
 		nc++;
 		if ((c0 & t->cmask) == t->cval) {
 			l &= t->lmask;
-			if (l < t->lval)
+			if (l < t->lval || l > UNICODE_MAX ||
+					(l & SURROGATE_MASK) == SURROGATE_PAIR)
 				return -1;
-			*p = l;
+			*p = (unicode_t) l;
 			return nc;
 		}
 		if (n <= nc)
@@ -72,76 +82,122 @@ utf8_mbtowc(wchar_t *p, const __u8 *s, i
 	}
 	return -1;
 }
+EXPORT_SYMBOL(utf8_to_utf32);
 
 int
-utf8_mbstowcs(wchar_t *pwcs, const __u8 *s, int n)
+utf32_to_utf8(u8 *s, unicode_t u, int maxlen)
 {
-	__u16 *op;
-	const __u8 *ip;
-	int size;
-
-	op = pwcs;
-	ip = s;
-	while (*ip && n > 0) {
-		if (*ip & 0x80) {
-			size = utf8_mbtowc(op, ip, n);
-			if (size == -1) {
-				/* Ignore character and move on */
-				ip++;
-				n--;
-			} else {
-				op++;
-				ip += size;
-				n -= size;
-			}
-		} else {
-			*op++ = *ip++;
-			n--;
-		}
-	}
-	return (op - pwcs);
-}
-
-int
-utf8_wctomb(__u8 *s, wchar_t wc, int maxlen)
-{
-	long l;
+	unsigned long l;
 	int c, nc;
 	const struct utf8_table *t;
-  
+
 	if (!s)
 		return 0;
-  
-	l = wc;
+
+	l = u;
+	if (l > UNICODE_MAX || (l & SURROGATE_MASK) == SURROGATE_PAIR)
+		return -1;
+
 	nc = 0;
 	for (t = utf8_table; t->cmask && maxlen; t++, maxlen--) {
 		nc++;
 		if (l <= t->lmask) {
 			c = t->shift;
-			*s = t->cval | (l >> c);
+			*s = (u8) (t->cval | (l >> c));
 			while (c > 0) {
 				c -= 6;
 				s++;
-				*s = 0x80 | ((l >> c) & 0x3F);
+				*s = (u8) (0x80 | ((l >> c) & 0x3F));
 			}
 			return nc;
 		}
 	}
 	return -1;
 }
+EXPORT_SYMBOL(utf32_to_utf8);
 
 int
-utf8_wcstombs(__u8 *s, const wchar_t *pwcs, int maxlen)
+utf8s_to_utf16s(wchar_t *pwcs, const u8 *s, int n)
 {
-	const __u16 *ip;
-	__u8 *op;
+	u16 *op;
 	int size;
+	unicode_t u;
+
+	op = pwcs;
+	while (*s && n > 0) {
+		if (*s & 0x80) {
+			size = utf8_to_utf32(&u, s, n);
+			if (size < 0) {
+				/* Ignore character and move on */
+				size = 1;
+			} else if (u >= PLANE_SIZE) {
+				u -= PLANE_SIZE;
+				*op++ = (wchar_t) (SURROGATE_PAIR |
+						((u >> 10) & SURROGATE_BITS));
+				*op++ = (wchar_t) (SURROGATE_PAIR |
+						SURROGATE_LOW |
+						(u & SURROGATE_BITS));
+			} else {
+				*op++ = (wchar_t) u;
+			}
+			s += size;
+			n -= size;
+		} else {
+			*op++ = *s++;
+			n--;
+		}
+	}
+	return op - pwcs;
+}
+EXPORT_SYMBOL(utf8s_to_utf16s);
+
+static inline unsigned long get_utf16(unsigned c, enum utf16_endian endian)
+{
+	switch (endian) {
+	default:
+		return c;
+	case UTF16_LITTLE_ENDIAN:
+		return __le16_to_cpu(c);
+	case UTF16_BIG_ENDIAN:
+		return __be16_to_cpu(c);
+	}
+}
+
+int
+utf16s_to_utf8s(u8 *s, const wchar_t *pwcs, int maxlen, int inlen,
+		enum utf16_endian endian)
+{
+	u8 *op;
+	int size;
+	unsigned long u, v;
 
 	op = s;
-	ip = pwcs;
-	while (*ip && maxlen > 0) {
-		if (*ip > 0x7f) {
-			size = utf8_wctomb(op, *ip, maxlen);
+	while (inlen > 0 && maxlen > 0) {
+		u = get_utf16(*pwcs, endian);
+		if (!u)
+			break;
+		pwcs++;
+		inlen--;
+		if (u > 0x7f) {
+			if ((u & SURROGATE_MASK) == SURROGATE_PAIR) {
+				if (u & SURROGATE_LOW) {
+					/* Ignore character and move on */
+					continue;
+				}
+				if (inlen <= 0)
+					break;
+				v = get_utf16(*pwcs, endian);
+				if ((v & SURROGATE_MASK) != SURROGATE_PAIR ||
+						!(v & SURROGATE_LOW)) {
+					/* Ignore character and move on */
+					continue;
+				}
+				u = PLANE_SIZE + ((u & SURROGATE_BITS) << 10)
+						+ (v & SURROGATE_BITS);
+				pwcs++;
+				inlen--;
+			}
+			size = utf32_to_utf8(op, u, maxlen);
 			if (size == -1) {
 				/* Ignore character and move on */
 			} else {
@@ -149,13 +205,13 @@ utf8_wcstombs(__u8 *s, const wchar_t *pw
 				maxlen -= size;
 			}
 		} else {
-			*op++ = (__u8) *ip;
+			*op++ = (u8) u;
 			maxlen--;
 		}
-		ip++;
 	}
-	return (op - s);
+	return op - s;
 }
+EXPORT_SYMBOL(utf16s_to_utf8s);
 
 int register_nls(struct nls_table * nls)
 {
@@ -467,9 +523,5 @@ EXPORT_SYMBOL(unregister_nls);
 EXPORT_SYMBOL(unload_nls);
 EXPORT_SYMBOL(load_nls);
 EXPORT_SYMBOL(load_nls_default);
-EXPORT_SYMBOL(utf8_mbtowc);
-EXPORT_SYMBOL(utf8_mbstowcs);
-EXPORT_SYMBOL(utf8_wctomb);
-EXPORT_SYMBOL(utf8_wcstombs);
 
 MODULE_LICENSE("Dual BSD/GPL");
Index: usb-2.6/fs/nls/nls_utf8.c
===================================================================
--- usb-2.6.orig/fs/nls/nls_utf8.c
+++ usb-2.6/fs/nls/nls_utf8.c
@@ -15,7 +15,11 @@ static int uni2char(wchar_t uni, unsigne
 {
 	int n;
 
-	if ( (n = utf8_wctomb(out, uni, boundlen)) == -1) {
+	if (boundlen <= 0)
+		return -ENAMETOOLONG;
+
+	n = utf32_to_utf8(out, uni, boundlen);
+	if (n < 0) {
 		*out = '?';
 		return -EINVAL;
 	}
@@ -25,11 +29,14 @@ static int uni2char(wchar_t uni, unsigne
 static int char2uni(const unsigned char *rawstring, int boundlen, wchar_t *uni)
 {
 	int n;
+	unicode_t u;
 
-	if ( (n = utf8_mbtowc(uni, rawstring, boundlen)) == -1) {
+	n = utf8_to_utf32(&u, rawstring, boundlen);
+	if (n < 0 || u > MAX_WCHAR_T) {
 		*uni = 0x003f;	/* ? */
-		n = -EINVAL;
+		return -EINVAL;
 	}
+	*uni = (wchar_t) u;
 	return n;
 }
 
Index: usb-2.6/fs/befs/linuxvfs.c
===================================================================
--- usb-2.6.orig/fs/befs/linuxvfs.c
+++ usb-2.6/fs/befs/linuxvfs.c
@@ -513,7 +513,7 @@ befs_utf2nls(struct super_block *sb, con
 {
 	struct nls_table *nls = BEFS_SB(sb)->nls;
 	int i, o;
-	wchar_t uni;
+	unicode_t uni;
 	int unilen, utflen;
 	char *result;
 	/* The utf8->nls conversion won't make the final nls string bigger
@@ -539,16 +539,16 @@ befs_utf2nls(struct super_block *sb, con
 	for (i = o = 0; i < in_len; i += utflen, o += unilen) {
 
 		/* convert from UTF-8 to Unicode */
-		utflen = utf8_mbtowc(&uni, &in[i], in_len - i);
-		if (utflen < 0) {
+		utflen = utf8_to_utf32(&uni, &in[i], in_len - i);
+		if (utflen < 0)
 			goto conv_err;
-		}
 
 		/* convert from Unicode to nls */
+		if (uni > MAX_WCHAR_T)
+			goto conv_err;
 		unilen = nls->uni2char(uni, &result[o], in_len - o);
-		if (unilen < 0) {
+		if (unilen < 0)
 			goto conv_err;
-		}
 	}
 	result[o] = '\0';
 	*out_len = o;
@@ -619,15 +619,13 @@ befs_nls2utf(struct super_block *sb, con
 
 		/* convert from nls to unicode */
 		unilen = nls->char2uni(&in[i], in_len - i, &uni);
-		if (unilen < 0) {
+		if (unilen < 0)
 			goto conv_err;
-		}
 
 		/* convert from unicode to UTF-8 */
-		utflen = utf8_wctomb(&result[o], uni, 3);
-		if (utflen <= 0) {
+		utflen = utf32_to_utf8(&result[o], uni, 3);
+		if (utflen <= 0)
 			goto conv_err;
-		}
 	}
 
 	result[o] = '\0';
Index: usb-2.6/fs/fat/dir.c
===================================================================
--- usb-2.6.orig/fs/fat/dir.c
+++ usb-2.6/fs/fat/dir.c
@@ -22,6 +22,19 @@
 #include <asm/uaccess.h>
 #include "fat.h"
 
+/*
+ * Maximum buffer size of short name.
+ * [(MSDOS_NAME + '.') * max one char + nul]
+ * For msdos style, ['.' (hidden) + MSDOS_NAME + '.' + nul]
+ */
+#define FAT_MAX_SHORT_SIZE	((MSDOS_NAME + 1) * NLS_MAX_CHARSET_SIZE + 1)
+/*
+ * Maximum buffer size of unicode chars from slots.
+ * [(max longname slots * 13 (size in a slot) + nul) * sizeof(wchar_t)]
+ */
+#define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
+#define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
+
 static inline loff_t fat_make_i_pos(struct super_block *sb,
 				    struct buffer_head *bh,
 				    struct msdos_dir_entry *de)
@@ -171,7 +184,8 @@ static inline int fat_uni_to_x8(struct m
 				unsigned char *buf, int size)
 {
 	if (sbi->options.utf8)
-		return utf8_wcstombs(buf, uni, size);
+		return utf16s_to_utf8s(buf, uni, size, FAT_MAX_UNI_CHARS,
+				UTF16_HOST_ENDIAN);
 	else
 		return uni16_to_x8(buf, uni, size, sbi->options.unicode_xlate,
 				   sbi->nls_io);
@@ -325,19 +339,6 @@ parse_long:
 }
 
 /*
- * Maximum buffer size of short name.
- * [(MSDOS_NAME + '.') * max one char + nul]
- * For msdos style, ['.' (hidden) + MSDOS_NAME + '.' + nul]
- */
-#define FAT_MAX_SHORT_SIZE	((MSDOS_NAME + 1) * NLS_MAX_CHARSET_SIZE + 1)
-/*
- * Maximum buffer size of unicode chars from slots.
- * [(max longname slots * 13 (size in a slot) + nul) * sizeof(wchar_t)]
- */
-#define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
-#define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
-
-/*
  * Return values: negative -> error, 0 -> not found, positive -> found,
  * value is the total amount of slots, including the shortname entry.
  */
Index: usb-2.6/fs/fat/namei_vfat.c
===================================================================
--- usb-2.6.orig/fs/fat/namei_vfat.c
+++ usb-2.6/fs/fat/namei_vfat.c
@@ -502,11 +502,11 @@ xlate_to_uni(const unsigned char *name, 
 	if (utf8) {
 		int name_len = strlen(name);
 
-		*outlen = utf8_mbstowcs((wchar_t *)outname, name, PATH_MAX);
+		*outlen = utf8s_to_utf16s((wchar_t *)outname, name, PATH_MAX);
 
 		/*
 		 * We stripped '.'s before and set len appropriately,
-		 * but utf8_mbstowcs doesn't care about len
+		 * but utf8s_to_utf16s doesn't care about len
 		 */
 		*outlen -= (name_len - len);
 
Index: usb-2.6/fs/isofs/joliet.c
===================================================================
--- usb-2.6.orig/fs/isofs/joliet.c
+++ usb-2.6/fs/isofs/joliet.c
@@ -37,37 +37,6 @@ uni16_to_x8(unsigned char *ascii, __be16
 	return (op - ascii);
 }
 
-/* Convert big endian wide character string to utf8 */
-static int
-wcsntombs_be(__u8 *s, const __u8 *pwcs, int inlen, int maxlen)
-{
-	const __u8 *ip;
-	__u8 *op;
-	int size;
-	__u16 c;
-
-	op = s;
-	ip = pwcs;
-	while ((*ip || ip[1]) && (maxlen > 0) && (inlen > 0)) {
-		c = (*ip << 8) | ip[1];
-		if (c > 0x7f) {
-			size = utf8_wctomb(op, c, maxlen);
-			if (size == -1) {
-				/* Ignore character and move on */
-				maxlen--;
-			} else {
-				op += size;
-				maxlen -= size;
-			}
-		} else {
-			*op++ = (__u8) c;
-		}
-		ip += 2;
-		inlen--;
-	}
-	return (op - s);
-}
-
 int
 get_joliet_filename(struct iso_directory_record * de, unsigned char *outname, struct inode * inode)
 {
@@ -79,8 +48,9 @@ get_joliet_filename(struct iso_directory
 	nls = ISOFS_SB(inode->i_sb)->s_nls_iocharset;
 
 	if (utf8) {
-		len = wcsntombs_be(outname, de->name,
-				de->name_len[0] >> 1, PAGE_SIZE);
+		len = utf16s_to_utf8s(outname, (const wchar_t *) de->name,
+				PAGE_SIZE, de->name_len[0] >> 1,
+				UTF16_BIG_ENDIAN);
 	} else {
 		len = uni16_to_x8(outname, (__be16 *) de->name,
 				de->name_len[0] >> 1, nls);
Index: usb-2.6/fs/ncpfs/ncplib_kernel.c
===================================================================
--- usb-2.6.orig/fs/ncpfs/ncplib_kernel.c
+++ usb-2.6/fs/ncpfs/ncplib_kernel.c
@@ -1113,11 +1113,13 @@ ncp__io2vol(struct ncp_server *server, u
 
 		if (NCP_IS_FLAG(server, NCP_FLAG_UTF8)) {
 			int k;
+			unicode_t u;
 
-			k = utf8_mbtowc(&ec, iname, iname_end - iname);
-			if (k < 0)
+			k = utf8_to_utf32(&u, iname, iname_end - iname);
+			if (k < 0 || u > MAX_WCHAR_T)
 				return -EINVAL;
 			iname += k;
+			ec = u;
 		} else {
 			if (*iname == NCP_ESC) {
 				int k;
@@ -1214,7 +1216,7 @@ ncp__vol2io(struct ncp_server *server, u
 		if (NCP_IS_FLAG(server, NCP_FLAG_UTF8)) {
 			int k;
 
-			k = utf8_wctomb(iname, ec, iname_end - iname);
+			k = utf32_to_utf8(iname, ec, iname_end - iname);
 			if (k < 0) {
 				err = -ENAMETOOLONG;
 				goto quit;
Index: usb-2.6/drivers/usb/core/message.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/message.c
+++ usb-2.6/drivers/usb/core/message.c
@@ -780,14 +780,13 @@ int usb_string(struct usb_device *dev, i
 {
 	unsigned char *tbuf;
 	int err;
-	unsigned int u;
 
 	if (dev->state == USB_STATE_SUSPENDED)
 		return -EHOSTUNREACH;
 	if (size <= 0 || !buf || !index)
 		return -EINVAL;
 	buf[0] = 0;
-	tbuf = kmalloc(256 + 2, GFP_NOIO);
+	tbuf = kmalloc(256, GFP_NOIO);
 	if (!tbuf)
 		return -ENOMEM;
 
@@ -814,12 +813,9 @@ int usb_string(struct usb_device *dev, i
 	if (err < 0)
 		goto errout;
 
-	for (u = 2; u < err; u += 2)
-		le16_to_cpus((u16 *)&tbuf[u]);
-	tbuf[u] = 0;
-	tbuf[u + 1] = 0;
 	size--;		/* leave room for trailing NULL char in output buffer */
-	err = utf8_wcstombs(buf, (u16 *)&tbuf[2], size);
+	err = utf16s_to_utf8s(buf, (wchar_t *) &tbuf[2], size, (err - 2) / 2,
+			UTF16_LITTLE_ENDIAN);
 	buf[err] = 0;
 
 	if (tbuf[1] != USB_DT_STRING)

