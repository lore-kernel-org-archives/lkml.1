Return-Path: <linux-kernel-owner+w=401wt.eu-S1765889AbYEGS0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765889AbYEGS0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbYEGSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:25:39 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:27681 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765574AbYEGSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nmC1EI4eWivd7Zgr4de9hx3h7KShSx/VrzW3bAPxhgDFQHBo/HLHwlzEiPlAFbtPuyihvR3YA2BPhTPLkIeo93hLEWYb+NyWpEAT3hGitBvJlARlaZ8cwdEWB2q41AhMp5rL0Z0Qkfdu3m7F1GrGdeJ6rNLaFDSJVJBpc2e2QKM=
Subject: [PATCH 1/2] lib: vsprintf.c pull out two small helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 11:25:30 -0700
Message-Id: <1210184730.19279.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic for guessing what number base when none is specified is
pulled out into a common helper.  Small codigstyle changes while
in the area.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |  101 +++++++++++++++++++++++++++----------------------------
 1 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6021757..0b39c34 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -29,40 +29,50 @@
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
+static unsigned int chartoint(char ch)
+{
+	ch = TOLOWER(ch);
+	if (isdigit(ch))
+		return ch - '0';
+	else
+		return ch - 'a' + 10;
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
+	unsigned long result = 0, value;
 
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
+	while ((value = chartoint(*cp)) < base) {
+		result = result * base + value;
 		cp++;
 	}
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoul);
 
 /**
@@ -71,13 +81,12 @@ EXPORT_SYMBOL(simple_strtoul);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long simple_strtol(const char *cp,char **endp,unsigned int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoul(cp+1,endp,base);
-	return simple_strtoul(cp,endp,base);
+	if (*cp == '-')
+		return -simple_strtoul(cp + 1, endp, base);
+	return simple_strtoul(cp, endp, base);
 }
-
 EXPORT_SYMBOL(simple_strtol);
 
 /**
@@ -86,34 +95,24 @@ EXPORT_SYMBOL(simple_strtol);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp,char **endp,unsigned int base)
+unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result = 0,value;
+	unsigned long long result = 0, value;
 
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
+	while ((value = chartoint(*cp)) < base) {
+		result = result * base + value;
 		cp++;
 	}
 	if (endp)
 		*endp = (char *)cp;
 	return result;
 }
-
 EXPORT_SYMBOL(simple_strtoull);
 
 /**
@@ -122,11 +121,11 @@ EXPORT_SYMBOL(simple_strtoull);
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
  */
-long long simple_strtoll(const char *cp,char **endp,unsigned int base)
+long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
-	if(*cp=='-')
-		return -simple_strtoull(cp+1,endp,base);
-	return simple_strtoull(cp,endp,base);
+	if(*cp == '-')
+		return -simple_strtoull(cp + 1, endp, base);
+	return simple_strtoull(cp, endp, base);
 }
 

-- 
1.5.5.1.350.gbbbf


