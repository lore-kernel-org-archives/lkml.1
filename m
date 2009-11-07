Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZKHQel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZKHQel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZKHQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:34:40 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45455 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZKHQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=NKPyuGxqDLvvRRT1i1in+iyP0nfgyztxbOFw9GDtOg7LIiAuuB+cdXynCtSM7QsKYW
         xLmnR/OlTEFLdAIOMq3TnxmpfPl6cgXnbD0gcgL3R4XpvNZXG55/rKqNhcZ9RHhRFA9g
         +TRyzu/YjjPHTxdJ5nQNnOuva0F1R1j377f4U=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: jengelh@medozas.de, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 08/12] vsprintf: reuse almost identical simple_strtoulX() functions
Date: Sat,  7 Nov 2009 14:33:13 -0200
Message-Id: <57d62b178a5bbd0393e83a2293ba933e60ddc658.1257602781.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The difference between simple_strtoul() and simple_strtoull() is just
the size of the variable used to keep track of the sum of characters
converted to numbers:

unsigned long simple_strtoul() {...}
unsigned long long simple_strtoull(){...}

Both are same size (8 bytes) on my Core 2/gcc 4.4.1.
Overflow condition is not checked on both functions, so an extremely large
string can break these functions so that they don't even notice it.

As we do not care for overflowing on these functions, always keep the sum
using the larger variable around (unsigned long long) on simple_strtoull()
and cast it to (unsigned long) on simple_strtoul(), which then becomes
just a wrapper around simple_strtoull().

Code size decreases by 304 bytes:
   text    data     bss     dec     hex filename
  15543       0       8   15551    3cbf lib/vsprintf.o-before
  15239       0       8   15247    3b8f lib/vsprintf.o-after

Removed unnecessary cast as noticed by Jan Engelhardt.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
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
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long result = 0;
+	unsigned long long result = 0;
 
 	if (!base)
 		base = simple_guess_base(cp);
@@ -78,54 +78,34 @@ unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 
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
+	return simple_strtoull(cp, endp, base);
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
-unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
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
1.6.5.2.153.g6e31f.dirty

