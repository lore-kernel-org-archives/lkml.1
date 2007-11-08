Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXKHV54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXKHV54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXKHV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:57:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:6364 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbXKHV5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:57:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=t8XxwGuVzqbHlgBGluiSZYwH5ZozrMLeqvy6obzGM7G/ul15Rhs9EtoiWRGsXvA+NL/c54hhUlX8AhHv41B2mFMPRRSIASjY6RJufoXMVqJkD8a0LCsK/GvHTvfM99gYsBbqezqDfWgZe5atRHiwpPn2WVMyagBC+7YkIcnIVVQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk: trivial optimizations
Date: Thu, 8 Nov 2007 14:57:32 -0700
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_MZ4MH2XSRY1s1Z5"
Message-Id: <200711081457.32211.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_MZ4MH2XSRY1s1Z5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrew,

This patch exploits some optimization opportunities
similar to those in first two patches I sent a while ago.

In particular:

In arch/x86/boot/printf.c gets rid of unused tail of digits:
const char *digits = "0123456789abcdefghijklmnopqrstuvwxyz";
(we are using 0-9a-f only)

Uses smaller/faster lowercasing (by ORing with 0x20)
if we know that we work on numbers/digits. Makes
strtoul smaller, and also we are getting rid of 
  static const char small_digits[] = "0123456789abcdefx";
  static const char large_digits[] = "0123456789ABCDEFX";
since this works equally well:
  static const char digits[16] = "0123456789ABCDEF";

Size savings:

$ size vmlinux.org vmlinux
   text    data     bss     dec     hex filename
 877320  112252   90112 1079684  107984 vmlinux.org
 877048  112252   90112 1079412  107874 vmlinux

It may be also a tiny bit faster because code has less
branches now, but I doubt it is measurable.

Patch is run-tested.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda

--Boundary-00=_MZ4MH2XSRY1s1Z5
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.24-rc2-printf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.24-rc2-printf.patch"

diff -urpN linux-2.6.23-rc9/arch/i386/boot/printf.c linux-2.6.23-rc9-printf/arch/i386/boot/printf.c
--- linux-2.6.23-rc9/arch/x86/boot/printf.c	2007-10-08 15:40:45.000000000 +0100
+++ linux-2.6.23-rc9-printf/arch/x86/boot/printf.c	2007-10-08 16:39:57.000000000 +0100
@@ -33,8 +33,8 @@ static int skip_atoi(const char **s)
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SPECIAL	32		/* 0x */
-#define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
 
 #define do_div(n,base) ({ \
 int __res; \
@@ -45,12 +45,16 @@ __res; })
 static char *number(char *str, long num, int base, int size, int precision,
 		    int type)
 {
-	char c, sign, tmp[66];
-	const char *digits = "0123456789abcdefghijklmnopqrstuvwxyz";
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char c, sign, locase;
 	int i;
 
-	if (type & LARGE)
-		digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters */
+	locase = (type & SMALL);
 	if (type & LEFT)
 		type &= ~ZEROPAD;
 	if (base < 2 || base > 36)
@@ -81,7 +85,7 @@ static char *number(char *str, long num,
 		tmp[i++] = '0';
 	else
 		while (num != 0)
-			tmp[i++] = digits[do_div(num, base)];
+			tmp[i++] = (digits[do_div(num, base)] | locase);
 	if (i > precision)
 		precision = i;
 	size -= precision;
@@ -95,7 +99,7 @@ static char *number(char *str, long num,
 			*str++ = '0';
 		else if (base == 16) {
 			*str++ = '0';
-			*str++ = digits[33];
+			*str++ = ('X' | locase);
 		}
 	}
 	if (!(type & LEFT))
@@ -244,9 +248,9 @@ int vsprintf(char *buf, const char *fmt,
 			base = 8;
 			break;
 
-		case 'X':
-			flags |= LARGE;
 		case 'x':
+			flags |= SMALL;
+		case 'X':
 			base = 16;
 			break;
 
diff -urpN linux-2.6.23-rc9/lib/vsprintf.c linux-2.6.23-rc9-printf/lib/vsprintf.c
--- linux-2.6.23-rc9/lib/vsprintf.c	2007-10-08 15:40:48.000000000 +0100
+++ linux-2.6.23-rc9-printf/lib/vsprintf.c	2007-10-08 16:41:35.000000000 +0100
@@ -26,6 +26,9 @@
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
 
+/* Works only for digits and letters, but small and fast */
+#define TOLOWER(x) ((x) | 0x20)
+
 /**
  * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
@@ -41,17 +44,17 @@ unsigned long simple_strtoul(const char 
 		if (*cp == '0') {
 			base = 8;
 			cp++;
-			if ((toupper(*cp) == 'X') && isxdigit(cp[1])) {
+			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
 				cp++;
 				base = 16;
 			}
 		}
 	} else if (base == 16) {
-		if (cp[0] == '0' && toupper(cp[1]) == 'X')
+		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
 	}
 	while (isxdigit(*cp) &&
-	       (value = isdigit(*cp) ? *cp-'0' : toupper(*cp)-'A'+10) < base) {
+	       (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
 		result = result*base + value;
 		cp++;
 	}
@@ -92,17 +95,17 @@ unsigned long long simple_strtoull(const
 		if (*cp == '0') {
 			base = 8;
 			cp++;
-			if ((toupper(*cp) == 'X') && isxdigit(cp[1])) {
+			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
 				cp++;
 				base = 16;
 			}
 		}
 	} else if (base == 16) {
-		if (cp[0] == '0' && toupper(cp[1]) == 'X')
+		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
 	}
-	while (isxdigit(*cp) && (value = isdigit(*cp) ? *cp-'0' : (islower(*cp)
-	    ? toupper(*cp) : *cp)-'A'+10) < base) {
+	while (isxdigit(*cp)
+	 && (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
 		result = result*base + value;
 		cp++;
 	}
@@ -237,24 +240,25 @@ static noinline char* put_dec(char *buf,
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
-#define SPECIAL	32		/* 0x */
-#define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
 
 static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
 {
-	char sign,tmp[66];
-	const char *digits;
-	/* we are called with base 8, 10 or 16, only, thus don't need "g..."  */
-	static const char small_digits[] = "0123456789abcdefx"; /* "ghijklmnopqrstuvwxyz"; */
-	static const char large_digits[] = "0123456789ABCDEFX"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char sign;
+	char locase;
 	int need_pfx = ((type & SPECIAL) && base != 10);
 	int i;
 
-	digits = (type & LARGE) ? large_digits : small_digits;
+	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters */
+	locase = (type & SMALL);
 	if (type & LEFT)
 		type &= ~ZEROPAD;
-	if (base < 2 || base > 36)
-		return NULL;
 	sign = 0;
 	if (type & SIGN) {
 		if ((signed long long) num < 0) {
@@ -281,7 +285,7 @@ static char *number(char *buf, char *end
 		tmp[i++] = '0';
 	/* Generic code, for any base:
 	else do {
-		tmp[i++] = digits[do_div(num,base)];
+		tmp[i++] = (digits[do_div(num,base)] | locase);
 	} while (num != 0);
 	*/
 	else if (base != 10) { /* 8 or 16 */
@@ -289,7 +293,7 @@ static char *number(char *buf, char *end
 		int shift = 3;
 		if (base == 16) shift = 4;
 		do {
-			tmp[i++] = digits[((unsigned char)num) & mask];
+			tmp[i++] = (digits[((unsigned char)num) & mask] | locase);
 			num >>= shift;
 		} while (num);
 	} else { /* base 10 */
@@ -321,7 +325,7 @@ static char *number(char *buf, char *end
 		++buf;
 		if (base == 16) {
 			if (buf < end)
-				*buf = digits[16]; /* for arbitrary base: digits[33]; */
+				*buf = ('X' | locase);
 			++buf;
 		}
 	}
@@ -557,9 +561,9 @@ int vsnprintf(char *buf, size_t size, co
 				base = 8;
 				break;
 
-			case 'X':
-				flags |= LARGE;
 			case 'x':
+				flags |= SMALL;
+			case 'X':
 				base = 16;
 				break;
 

--Boundary-00=_MZ4MH2XSRY1s1Z5--
