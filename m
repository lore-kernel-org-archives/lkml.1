Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZKDQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZKDQCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbZKDQCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:02:30 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:58706 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968AbZKDQCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=EDqpa/+egFjPahwlB9i7kAT+dmL/sOn+mBcB/uBFLIXfoSkv2fLmj21/knDphIVso3
         AarOkuikfTebNdQkug9kVqlhMwLtaXMwJc5hPUEep8E7TKV6WsgcuXFL+BRMWkoWuDYf
         jKCezBq9OKvpdoqtoiSZRNcWvftaZsQRiJugE=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 14:02:08 -0200
Message-ID: <b8bf37780911040802r4b88e3ffu156af0832e11709a@mail.gmail.com>
Subject: [PATCH RFC] vsprintf: reuse almost identical simple_strtoulX() 
	functions
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
Date: Tue, 3 Nov 2009 13:56:14 -0200
Subject: [PATCH RFC] vsprintf: reuse almost identical
simple_strtoulX() functions
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The difference between simple_strtoul() and simple_strtoull() is just
the size of the variable used to keep track of the sum of characters
converted to numbers:

unsigned long simple_strtoul() {...}
unsigned long long simple_strtoull(){...}

Overflow situation is not checked on both functions, so an extremely large
string can break these functions so that we don't notice it.

As we do not care for overflowing on these functions, always keep the sum
using the larger variable around (unsigned long long) on simple_strtoull()
and cast it to (unsigned long) on simple_strtoul(), which then becomes
just a wrapper around simple_strtoull().

Code size decreases by 304 bytes:
   text    data     bss     dec     hex filename
  15543       0       8   15551    3cbf lib/vsprintf.o-before
  15239       0       8   15247    3b8f lib/vsprintf.o-after

Comments?

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/vsprintf.c |   48 ++++++++++++++----------------------------------
 1 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 566c947..7ec96a3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -49,14 +49,14 @@ static unsigned int simple_guess_base(const char *cp)
 }

 /**
- * simple_strtoul - convert a string to an unsigned long
+ * simple_strtoull - convert a string to an unsigned long long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
+unsigned long long simple_strtoull(const char *cp, char **endp,
unsigned int base)
 {
-	unsigned long result = 0;
+	unsigned long long result = 0;

 	if (!base)
 		base = simple_guess_base(cp);
@@ -78,54 +78,34 @@ unsigned long simple_strtoul(const char *cp, char
**endp, unsigned int base)

 	return result;
 }
-EXPORT_SYMBOL(simple_strtoul);
+EXPORT_SYMBOL(simple_strtoull);

 /**
- * simple_strtol - convert a string to a signed long
+ * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long simple_strtol(const char *cp, char **endp, unsigned int base)
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
-	if (*cp == '-')
-		return -simple_strtoul(cp + 1, endp, base);
-
-	return simple_strtoul(cp, endp, base);
+	return (unsigned long)simple_strtoull(cp, endp, base);
 }
-EXPORT_SYMBOL(simple_strtol);
+EXPORT_SYMBOL(simple_strtoul);

 /**
- * simple_strtoull - convert a string to an unsigned long long
+ * simple_strtol - convert a string to a signed long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp, char **endp,
unsigned int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result = 0;
-
-	if (!base)
-		base = simple_guess_base(cp);
-
-	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
-		cp += 2;
-
-	while (isxdigit(*cp)) {
-		unsigned int value;
-
-		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
-		if (value >= base)
-			break;
-		result = result * base + value;
-		cp++;
-	}
-	if (endp)
-		*endp = (char *)cp;
+	if (*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);

-	return result;
+	return simple_strtoul(cp, endp, base);
 }
-EXPORT_SYMBOL(simple_strtoull);
+EXPORT_SYMBOL(simple_strtol);

 /**
  * simple_strtoll - convert a string to a signed long long
-- 
1.6.5.2.143.g8cc62.dirty
