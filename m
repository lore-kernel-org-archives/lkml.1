Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZKARB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZKARB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZKARB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:01:57 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:61343 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZKARB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bDJa/iYJx67HId7znHUz+Nf/lJGomeFmRkL55t8ANBMhokr5qi22nWxmC3r53MgouU
         CcIwqcnSkfjOi1mnm6dc1tnXBLaBCsZE6PmW61Kr0UzTUXRF9eLuS4RqWnSFdIpLynC6
         CRjAK2zoDtNRS7SgURJSHBxkcLnRGT4KG44uE=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 15:01:40 -0200
Message-ID: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com>
Subject: [PATCH] vsprintf: reduce code size, clean up
To: laijs@cn.fujitsu.com, mingo@elte.hu, fweisbec@gmail.com,
       davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5b5bc2f4f0499bc32d523d8121b781a89c8f1dd8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 14:48:49 -0200
Subject: [PATCH] vsprintf: reduce code size, clean up
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch reduces code size by 382 bytes on my Core 2:
   text    data     bss     dec     hex filename
  15765       0       8   15773    3d9d lib/vsprintf.o-before
  15383       7       8   15398    3c26 lib/vsprintf.o-after

It changes string "<NULL>" to "(null)".

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/vsprintf.c |  170 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 86 insertions(+), 84 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..fc77518 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -34,6 +34,8 @@
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)

+static char null[] = "(null)";
+
 static unsigned int simple_guess_base(const char *cp)
 {
 	if (cp[0] == '0') {
@@ -551,7 +553,7 @@ static char *string(char *buf, char *end, char *s,
struct printf_spec spec)
 	int len, i;

 	if ((unsigned long)s < PAGE_SIZE)
-		s = "<NULL>";
+		s = null;

 	len = strnlen(s, spec.precision);

@@ -666,8 +668,8 @@ static char *ip4_string(char *p, const u8 *addr,
bool leading_zeros)
 		if (i < 3)
 			*p++ = '.';
 	}
-
 	*p = '\0';
+
 	return p;
 }

@@ -735,8 +737,9 @@ static char *ip6_compressed_string(char *p, const
char *addr)
 				p = pack_hex_byte(p, hi);
 			else
 				*p++ = hex_asc_lo(hi);
+			p = pack_hex_byte(p, lo);
 		}
-		if (hi || lo > 0x0f)
+		else if (lo > 0x0f)
 			p = pack_hex_byte(p, lo);
 		else
 			*p++ = hex_asc_lo(lo);
@@ -748,8 +751,8 @@ static char *ip6_compressed_string(char *p, const
char *addr)
 			*p++ = ':';
 		p = ip4_string(p, &in6.s6_addr[12], false);
 	}
-
 	*p = '\0';
+
 	return p;
 }

@@ -762,8 +765,8 @@ static char *ip6_string(char *p, const char *addr,
const char *fmt)
 		if (fmt[0] == 'I' && i != 7)
 			*p++ = ':';
 	}
-
 	*p = '\0';
+
 	return p;
 }

@@ -822,30 +825,34 @@ static char *pointer(const char *fmt, char *buf,
char *end, void *ptr,
 			struct printf_spec spec)
 {
 	if (!ptr)
-		return string(buf, end, "(null)", spec);
+		return string(buf, end, null, spec);

-	switch (*fmt) {
-	case 'F':
+	switch (TOLOWER(*fmt)) {
 	case 'f':
+	/* or case 'F' */
 		ptr = dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
-	case 'S':
+	case 's':
+	/* or case 'S' */
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
-	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
-	case 'm':			/* Contiguous: 000102030405 */
+	case 'm':
+	/* or case 'M' */
+		/* case 'M': Colon separated: 00:01:02:03:04:05 */
+		/* case 'm': Contiguous: 000102030405 */
 		return mac_address_string(buf, end, ptr, spec, fmt);
-	case 'I':			/* Formatted IP supported
-					 * 4:	1.2.3.4
-					 * 6:	0001:0203:...:0708
-					 * 6c:	1::708 or 1::1.2.3.4
-					 */
-	case 'i':			/* Contiguous:
-					 * 4:	001.002.003.004
-					 * 6:   000102...0f
-					 */
+	case 'i':
+	/* or case 'I' */
+		/* case 'I': Formatted IP supported
+		 * 4:	1.2.3.4
+		 * 6:	0001:0203:...:0708
+		 * 6c:	1::708 or 1::1.2.3.4
+		 */
+		/* case 'i': Contiguous:
+		 * 4:	001.002.003.004
+		 * 6:   000102...0f
+		 */
 		switch (fmt[1]) {
 		case '6':
 			return ip6_addr_string(buf, end, ptr, spec, fmt);
@@ -970,8 +977,8 @@ precision:
 qualifier:
 	/* get the conversion qualifier */
 	spec->qualifier = -1;
-	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+	if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
+	    TOLOWER(*fmt) == 'z' || *fmt == 't') {
 		spec->qualifier = *fmt++;
 		if (unlikely(spec->qualifier == *fmt)) {
 			if (spec->qualifier == 'l') {
@@ -1038,7 +1045,7 @@ qualifier:
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
-	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
+	} else if (TOLOWER(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -1091,8 +1098,7 @@ qualifier:
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	char *str, *end, c;
-	int read;
+	char *str, *end;
 	struct printf_spec spec = {0};

 	/* Reject out-of-range values early.  Large positive sizes are
@@ -1111,8 +1117,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)

 	while (*fmt) {
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);

 		fmt += read;

@@ -1136,13 +1141,14 @@ int vsnprintf(char *buf, size_t size, const
char *fmt, va_list args)
 			spec.precision = va_arg(args, int);
 			break;

-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
 						*str = ' ';
 					++str;
-
 				}
 			}
 			c = (unsigned char) va_arg(args, int);
@@ -1155,6 +1161,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)
 				++str;
 			}
 			break;
+		}

 		case FORMAT_TYPE_STR:
 			str = string(str, end, va_arg(args, char *), spec);
@@ -1185,8 +1192,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)
 			if (qualifier == 'l') {
 				long *ip = va_arg(args, long *);
 				*ip = (str - buf);
-			} else if (qualifier == 'Z' ||
-					qualifier == 'z') {
+			} else if (TOLOWER(qualifier) == 'z') {
 				size_t *ip = va_arg(args, size_t *);
 				*ip = (str - buf);
 			} else {
@@ -1396,7 +1402,6 @@ int vbin_printf(u32 *bin_buf, size_t size, const
char *fmt, va_list args)
 {
 	struct printf_spec spec = {0};
 	char *str, *end;
-	int read;

 	str = (char *)bin_buf;
 	end = (char *)(bin_buf + size);
@@ -1421,14 +1426,15 @@ do {									\
 	str += sizeof(type);						\
 } while (0)

-
 	while (*fmt) {
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);

 		fmt += read;

 		switch (spec.type) {
 		case FORMAT_TYPE_NONE:
+		case FORMAT_TYPE_INVALID:
+		case FORMAT_TYPE_PERCENT_CHAR:
 			break;

 		case FORMAT_TYPE_WIDTH:
@@ -1445,11 +1451,11 @@ do {									\
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
-				save_str = "<NULL>";
-			len = strlen(save_str);
-			if (str + len + 1 < end)
-				memcpy(str, save_str, len + 1);
-			str += len + 1;
+				save_str = null;
+			len = strlen(save_str) + 1;
+			if (str + len < end)
+				memcpy(str, save_str, len);
+			str += len;
 			break;
 		}

@@ -1460,19 +1466,13 @@ do {									\
 				fmt++;
 			break;

-		case FORMAT_TYPE_PERCENT_CHAR:
-			break;
-
-		case FORMAT_TYPE_INVALID:
-			break;
-
 		case FORMAT_TYPE_NRCHARS: {
 			/* skip %n 's argument */
 			int qualifier = spec.qualifier;
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
-			else if (qualifier == 'Z' || qualifier == 'z')
+			else if (TOLOWER(qualifier) == 'z')
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
@@ -1538,11 +1538,9 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  */
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 {
-	unsigned long long num;
-	char *str, *end, c;
-	const char *args = (const char *)bin_buf;
-
 	struct printf_spec spec = {0};
+	char *str, *end;
+	const char *args = (const char *)bin_buf;

 	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
@@ -1572,10 +1570,8 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 	}

 	while (*fmt) {
-		int read;
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);

 		fmt += read;

@@ -1599,7 +1595,9 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 			spec.precision = get_arg(int);
 			break;

-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1617,11 +1615,11 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 				++str;
 			}
 			break;
+		}

 		case FORMAT_TYPE_STR: {
 			const char *str_arg = args;
-			size_t len = strlen(str_arg);
-			args += len + 1;
+			args += strlen(str_arg) + 1;
 			str = string(str, end, (char *)str_arg, spec);
 			break;
 		}
@@ -1648,15 +1646,15 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 			/* skip */
 			break;

-		default:
+		default: {
+			unsigned long long num;
+
 			switch (spec.type) {

 			case FORMAT_TYPE_LONG_LONG:
 				num = get_arg(long long);
 				break;
 			case FORMAT_TYPE_ULONG:
-				num = get_arg(unsigned long);
-				break;
 			case FORMAT_TYPE_LONG:
 				num = get_arg(unsigned long);
 				break;
@@ -1686,8 +1684,9 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 			}

 			str = number(str, end, num, spec);
-		}
-	}
+		} /* default: */
+		} /* switch(spec.type) */
+	} /* while(*fmt) */

 	if (size > 0) {
 		if (str < end)
@@ -1727,6 +1726,13 @@ EXPORT_SYMBOL_GPL(bprintf);

 #endif /* CONFIG_BINARY_PRINTF */

+static noinline const char *skip_space(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return str;
+}
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1742,18 +1748,16 @@ int vsscanf(const char * buf, const char *
fmt, va_list args)
 	int qualifier;
 	int base;
 	int field_width;
-	int is_sign = 0;
+	bool is_sign;

-	while(*fmt && *str) {
+	while (*fmt && *str) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			while (isspace(*fmt))
-				++fmt;
-			while (isspace(*str))
-				++str;
+			fmt = skip_space(fmt);
+			str = skip_space(str);
 		}

 		/* anything that is not a conversion must match exactly */
@@ -1785,8 +1789,8 @@ int vsscanf(const char * buf, const char * fmt,
va_list args)

 		/* get conversion qualifier */
 		qualifier = -1;
-		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-		    *fmt == 'Z' || *fmt == 'z') {
+		if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
+		    TOLOWER(*fmt) == 'z') {
 			qualifier = *fmt++;
 			if (unlikely(qualifier == *fmt)) {
 				if (qualifier == 'h') {
@@ -1798,13 +1802,14 @@ int vsscanf(const char * buf, const char *
fmt, va_list args)
 				}
 			}
 		}
-		base = 10;
-		is_sign = 0;

 		if (!*fmt || !*str)
 			break;

-		switch(*fmt++) {
+		base = 10;
+		is_sign = 0;
+
+		switch (TOLOWER(*fmt++)) {
 		case 'c':
 		{
 			char *s = (char *) va_arg(args,char*);
@@ -1822,8 +1827,7 @@ int vsscanf(const char * buf, const char * fmt,
va_list args)
 			if(field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
-			while (isspace(*str))
-				str++;
+			str = skip_space(str);

 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--) {
@@ -1844,7 +1848,7 @@ int vsscanf(const char * buf, const char * fmt,
va_list args)
 			base = 8;
 			break;
 		case 'x':
-		case 'X':
+		/* or case 'X' */
 			base = 16;
 			break;
 		case 'i':
@@ -1866,19 +1870,17 @@ int vsscanf(const char * buf, const char *
fmt, va_list args)
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		while (isspace(*str))
-			str++;
+		str = skip_space(str);

 		digit = *str;
 		if (is_sign && digit == '-')
 			digit = *(str + 1);

-		if (!digit
-                    || (base == 16 && !isxdigit(digit))
-                    || (base == 10 && !isdigit(digit))
-                    || (base == 8 && (!isdigit(digit) || digit > '7'))
-                    || (base == 0 && !isdigit(digit)))
-				break;
+		if (!digit || (base == 16 && !isxdigit(digit))
+		    || (base == 10 && !isdigit(digit))
+		    || (base == 8 && (!isdigit(digit) || digit > '7'))
+		    || (base == 0 && !isdigit(digit)))
+			break;

 		switch(qualifier) {
 		case 'H':	/* that's 'hh' in format */
-- 
1.6.5.2.140.g5f809
