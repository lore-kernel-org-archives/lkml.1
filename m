Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZKOHOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZKOHOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZKOHOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:14 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63185 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZKOHOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=r8Aeb3gc39tHYGu8RkCbVhqWYaopJ0cPwIMMEvpImRidM25AnFrewXb3rmmFQMRlaO
         PjUWuHp2Imm6T6tM7s+at3eY3WWpgjZ9BgWAZslwVwLqo5FLYlTvD7hT/XFFgi6aDwme
         KC7pBOSJkO2BxJeaaeJbt7WyysL8MFJ71Tz40=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 06/12] vsprintf: move local vars to block local vars and remove unneeded ones
Date: Sat, 14 Nov 2009 05:11:54 -0200
Message-Id: <021f33f95bbc3a3b92c25e6306b1f80f2c5d7aae.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup by moving variables closer to the scope where they're used in fact.
Also, remove unneeded ones.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   64 ++++++++++++++++++++++++-------------------------------
 1 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3c83f7b..8b60f77 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -840,8 +840,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
+	case 's':
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
@@ -1103,8 +1103,7 @@ qualifier:
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	char *str, *end, c;
-	int read;
+	char *str, *end;
 	struct printf_spec spec = {0};
 
 	/* Reject out-of-range values early.  Large positive sizes are
@@ -1123,8 +1122,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 
 	while (*fmt) {
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);
 
 		fmt += read;
 
@@ -1148,7 +1146,9 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			spec.precision = va_arg(args, int);
 			break;
 
-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1167,6 +1167,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				++str;
 			}
 			break;
+		}
 
 		case FORMAT_TYPE_STR:
 			str = string(str, end, va_arg(args, char *), spec);
@@ -1411,7 +1412,6 @@ int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
 {
 	struct printf_spec spec = {0};
 	char *str, *end;
-	int read;
 
 	str = (char *)bin_buf;
 	end = (char *)(bin_buf + size);
@@ -1437,12 +1437,14 @@ do {									\
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
@@ -1475,12 +1477,6 @@ do {									\
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
@@ -1553,10 +1549,9 @@ EXPORT_SYMBOL_GPL(vbin_printf);
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
@@ -1586,10 +1581,8 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 	}
 
 	while (*fmt) {
-		int read;
 		const char *old_fmt = fmt;
-
-		read = format_decode(fmt, &spec);
+		int read = format_decode(fmt, &spec);
 
 		fmt += read;
 
@@ -1613,7 +1606,9 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			spec.precision = get_arg(int);
 			break;
 
-		case FORMAT_TYPE_CHAR:
+		case FORMAT_TYPE_CHAR: {
+			char c;
+
 			if (!(spec.flags & LEFT)) {
 				while (--spec.field_width > 0) {
 					if (str < end)
@@ -1631,11 +1626,11 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
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
@@ -1647,11 +1642,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
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
@@ -1662,15 +1652,15 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
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
@@ -1700,8 +1690,9 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			}
 
 			str = number(str, end, num, spec);
-		}
-	}
+		} /* default: */
+		} /* switch(spec.type) */
+	} /* while(*fmt) */
 
 	if (size > 0) {
 		if (str < end)
@@ -1755,7 +1746,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 	char digit;
 	int num = 0;
 	int qualifier, base, field_width;
-	int is_sign = 0;
+	bool is_sign;
 
 	while (*fmt && *str) {
 		/* skip any white space in format */
@@ -1811,12 +1802,13 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
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
1.6.5.2.180.gc5b3e.dirty

