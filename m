Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYEMX55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYEMX55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYEMX5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:57:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32990 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYEMX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sdXIIyIT1Tc/CAfwzyUKZ5bECbdXXJ11o6m7dieDSNVvb/AWX1q5vEd+tnzHD/IyLn+s88/5xZA9Vlw8ugTOKCL0gPzO8ahQH9hz/RwLpWLCQscGDMgxXXNwiV/DdH6pq42f4lvCA/8kKetvZ5wAS5gMJnLcGk7ixC3behTIo4o=
Subject: [PATCH 1/3] lib: vsprintf.c pull out two small helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 16:57:43 -0700
Message-Id: <1210723063.6191.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic for guessing what number base when none is specified is
pulled out into a common helper.  Small codingstyle changes while
in the area.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |  101 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6021757..dc5c3ae 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -29,40 +29,51 @@
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x')
+			return 16;
+		return 8;
+	} else {
+		return 10;
+	}
+}
+
+static u8 chartou8(char ch)
+{
+	if (isdigit(ch))
+		return ch - '0';
+	else
+		return TOLOWER(ch) - 'a' + 10;
+}
+
 /**
  * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long simple_strtoul(const char *cp,char **endp,unsigned int base)
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long result = 0,value;
+	unsigned long result = 0;
+	u8 value;
 
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
+	if (!base)
+		base = simple_guess_base(cp);
+
+	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 			cp += 2;
-	}
-	while (isxdigit(*cp) &&
-	       (value = isdigit(*cp) ? *cp-'0' : TOLOWER(*cp)-'a'+10) < base) {
-		result = result*base + value;
+
+	while (isxdigit(*cp) && (value = chartou8(*cp) < base)) {
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
@@ -71,13 +82,12 @@ EXPORT_SYMBOL(simple_strtoul);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long simple_strtol(const char *cp,char **endp,unsigned int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoul(cp+1,endp,base);
-	return simple_strtoul(cp,endp,base);
+	if(*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);
+	return simple_strtoul(cp, endp, base);
 }
-
 EXPORT_SYMBOL(simple_strtol);
 
 /**
@@ -86,34 +96,26 @@ EXPORT_SYMBOL(simple_strtol);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result = 0,value;
+	unsigned long long result = 0;
+	u8 value;
 
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
+	while (isxdigit(*cp) && (value = chartou8(*cp) < base)) {
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
@@ -124,12 +126,11 @@ EXPORT_SYMBOL(simple_strtoull);
  */
 long long simple_strtoll(const char *cp,char **endp,unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoull(cp+1,endp,base);
-	return simple_strtoull(cp,endp,base);
+	if (*cp == '-')
+		return -simple_strtoull(cp + 1, endp, base);
+	return simple_strtoull(cp, endp, base);
 }
 
-
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
  * @cp: The string to be converted
-- 
1.5.5.1.482.g0f174


