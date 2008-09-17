Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYIQSW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYIQSW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYIQSWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:22:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:17273 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbYIQSWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Wour9AzyNiSsJcc/u2JMPPr2Kt2qExNn8WWVUVWuijjDjg8Klx7wenuXrURghb0ASY
         5mEatUfS8C3n/OAWvvYagJhZrPqTrH92A2fPwCfwvuzWiXUXofpvPmLJUQwaL11yMxx1
         bm9f4qrDHa1pIdbn4wWJB0BwlUIAoF/il8vVo=
Subject: [PATCH 1/3] lib: pull base-guessing logic to helper function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 11:22:02 -0700
Message-Id: <1221675722.7298.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small behavior change in this patch, previously, when
no base was specified and the string began with 0x? the base would
be guessed as 8, unless isxdigit(?) was true.  This would then return
0 as 'x' was larger than 8.  Now, the base is always guessed as 16 if
the string starts with '0x'

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |   84 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c399bc1..3f8c428 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -32,6 +32,18 @@
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x')
+			return 16;
+		else
+			return 8;
+	} else {
+		return 10;
+	}
+}
+
 /**
  * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
@@ -40,32 +52,28 @@
  */
 unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
 {
-	unsigned long result = 0,value;
+	unsigned long result = 0;
 
-	if (!base) {
-		base = 10;
-		if (*cp == '0') {
-			base = 8;
-			cp++;
-			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
-				cp++;
-				base = 16;
-			}
-		}
-	} else if (base == 16) {
-		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
-			cp += 2;
-	}
-	while (isxdigit(*cp) &&
-	       (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
-		result = result*base + value;
+	if (!base)
+		base = simple_guess_base(cp);
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+		cp += 2;
+
+	while (isxdigit(*cp)) {
+		unsigned int value;
+
+		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (value >= base)
+			break;
+		result = result * base + value;
 		cp++;
 	}
+
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoul);
 
 /**
@@ -91,32 +99,28 @@ EXPORT_SYMBOL(simple_strtol);
  */
 unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
 {
-	unsigned long long result = 0,value;
+	unsigned long long result = 0;
 
-	if (!base) {
-		base = 10;
-		if (*cp == '0') {
-			base = 8;
-			cp++;
-			if ((TOLOWER(*cp) == 'x') && isxdigit(cp[1])) {
-				cp++;
-				base = 16;
-			}
-		}
-	} else if (base == 16) {
-		if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')
-			cp += 2;
-	}
-	while (isxdigit(*cp)
-	 && (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
-		result = result*base + value;
+	if (!base)
+		base = simple_guess_base(cp);
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+		cp += 2;
+
+	while (isxdigit(*cp)) {
+		unsigned int value;
+
+		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		if (value >= base)
+			break;
+		result = result * base + value;
 		cp++;
 	}
+
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoull);
 
 /**
-- 
1.6.0.2.405.g3cc38


