Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZKDOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZKDOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZKDOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:49:11 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbZKDOtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MVzP8p0qvp+FdakoxGp0UzxH5Dj3P/5Q/pthfSMsrWT3XcBxWL2eJJwo6uzmzchqjI
         h1JkXZnQRzensQW4S9geMgEprwxFFo/g4CUbC+HIifyJ4cJyM4Fu53fpYEPV9LplcU4G
         dNrlSG0hDwYM57dlzw+Y14mthWBpcTPGM3Pbs=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:48:55 -0200
Message-ID: <b8bf37780911040648n9353f58m972ac0f4b6c5e986@mail.gmail.com>
Subject: [PATCH v3 6/7] vsprintf: move local vars to block local vars and 
	remove unneeded ones
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>
Date: Tue, 3 Nov 2009 10:59:30 -0200
Subject: [PATCH v3 6/7] vsprintf: move local vars to block local vars
and remove unneeded ones
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Cleanup by moving variables closer to the scope where they're used in fact.
Also, remove unneeded ones.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   64 ++++++++++++++++++++++++-------------------------------
 1 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index af79152..f703fdf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -842,8 +842,8 @@ static char *pointer(const char *fmt, char *buf,
char *end, void *ptr,
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
+	case 's':
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
@@ -1105,8 +1105,7 @@ qualifier:
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	char *str, *end, c;
-	int read;
+	char *str, *end;
 	struct printf_spec spec = {0};

 	/* Reject out-of-range values early.  Large positive sizes are
@@ -1125,8 +1124,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)

 	while (*fmt) {
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);

 		fmt += read;

@@ -1150,7 +1148,9 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)
 			spec.precision = va_arg(args, int);
 			break;

-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1169,6 +1169,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)
 				++str;
 			}
 			break;
+		}

 		case FORMAT_TYPE_STR:
 			str = string(str, end, va_arg(args, char *), spec);
@@ -1413,7 +1414,6 @@ int vbin_printf(u32 *bin_buf, size_t size, const
char *fmt, va_list args)
 {
 	struct printf_spec spec = {0};
 	char *str, *end;
-	int read;

 	str = (char *)bin_buf;
 	end = (char *)(bin_buf + size);
@@ -1439,12 +1439,14 @@ do {									\
 } while (0)

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
@@ -1478,12 +1480,6 @@ do {									\
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
@@ -1556,10 +1552,9 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  */
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 {
-	unsigned long long num;
-	char *str, *end, c;
-	const char *args = (const char *)bin_buf;
 	struct printf_spec spec = {0};
+	char *str, *end;
+	const char *args = (const char *)bin_buf;

 	if (WARN_ON_ONCE((int) size < 0))
 		return 0;
@@ -1589,10 +1584,8 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 	}

 	while (*fmt) {
-		int read;
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);

 		fmt += read;

@@ -1616,7 +1609,9 @@ int bstr_printf(char *buf, size_t size, const
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
@@ -1634,11 +1629,11 @@ int bstr_printf(char *buf, size_t size, const
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
@@ -1650,11 +1645,6 @@ int bstr_printf(char *buf, size_t size, const
char *fmt, const u32 *bin_buf)
 			break;

 		case FORMAT_TYPE_PERCENT_CHAR:
-			if (str < end)
-				*str = '%';
-			++str;
-			break;
-
 		case FORMAT_TYPE_INVALID:
 			if (str < end)
 				*str = '%';
@@ -1665,15 +1655,15 @@ int bstr_printf(char *buf, size_t size, const
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
@@ -1703,8 +1693,9 @@ int bstr_printf(char *buf, size_t size, const
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
@@ -1758,7 +1749,7 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
 	char digit;
 	int num = 0;
 	int qualifier, base, field_width;
-	int is_sign = 0;
+	bool is_sign;

 	while (*fmt && *str) {
 		/* skip any white space in format */
@@ -1814,12 +1805,13 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
 				}
 			}
 		}
-		base = 10;
-		is_sign = 0;

 		if (!*fmt || !*str)
 			break;

+		base = 10;
+		is_sign = 0;
+
 		switch (*fmt++) {
 		case 'c':
 		{
-- 
1.6.5.2.143.g8cc62.dirty
