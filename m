Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYIQSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYIQSWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYIQSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:22:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61441 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYIQSWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rPRDFHj3T3Mv4TK+5ZSBb+iKeERgSYavslnmBb5211Jr8UcehrVf8Jh/CmBwI2ZVPt
         O9ZaD+gsHkz5m0i4G7rRyXyTEesgyhekYdfuvNwPZPvyu3jmivtBK3k8XX1CkTBdlQ2f
         tNF6OBLwOAwlDkrpxc3U6XHsvCDqTCKSHWhaY=
Subject: [PATCH 3/3] lib: remove defining macros for strict_strto??
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 11:22:12 -0700
Message-Id: <1221675732.7298.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open-code them rather than using defining macros.  Add casts to the
signed cases as they call into the unsigned versions.

Avoids the sparse warnings:
lib/vsprintf.c:249:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:249:1:    expected unsigned long *res
lib/vsprintf.c:249:1:    got long *res
lib/vsprintf.c:249:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:249:1:    expected unsigned long *res
lib/vsprintf.c:249:1:    got long *res
lib/vsprintf.c:251:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:251:1:    expected unsigned long long *res
lib/vsprintf.c:251:1:    got long long *res
lib/vsprintf.c:251:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:251:1:    expected unsigned long long *res
lib/vsprintf.c:251:1:    got long long *res

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |  117 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 68 insertions(+), 49 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 4d62235..96125ba 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -135,7 +135,6 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 	return simple_strtoull(cp, endp, base);
 }
 
-
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
  * @cp: The string to be converted
@@ -158,7 +157,27 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
  * simple_strtoul just ignores the successive invalid characters and
  * return the converted value of prefix part of the string.
  */
-int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
+int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
+{
+	char *tail;
+	unsigned long val;
+	size_t len;
+
+	*res = 0;
+	len = strlen(cp);
+	if (len == 0)
+		return -EINVAL;
+
+	val = simple_strtoul(cp, &tail, base);
+	if ((*tail == '\0') ||
+		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoul);
 
 /**
  * strict_strtol - convert a string to a long strictly
@@ -172,7 +191,20 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
  * It returns 0 if conversion is successful and *res is set to the converted
  * value, otherwise it returns -EINVAL and *res is set to 0.
  */
-int strict_strtol(const char *cp, unsigned int base, long *res);
+int strict_strtol(const char *cp, unsigned int base, long *res)
+{
+	int ret;
+	if (*cp == '-') {
+		ret = strict_strtoul(cp + 1, base, (unsigned long *)res);
+		if (!ret)
+			*res = -(*res);
+	} else {
+		ret = strict_strtoul(cp, base, (unsigned long *)res);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(strict_strtol);
 
 /**
  * strict_strtoull - convert a string to an unsigned long long strictly
@@ -196,7 +228,27 @@ int strict_strtol(const char *cp, unsigned int base, long *res);
  * simple_strtoull just ignores the successive invalid characters and
  * return the converted value of prefix part of the string.
  */
-int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
+int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res)
+{
+	char *tail;
+	unsigned long long val;
+	size_t len;
+
+	*res = 0;
+	len = strlen(cp);
+	if (len == 0)
+		return -EINVAL;
+
+	val = simple_strtoull(cp, &tail, base);
+	if ((*tail == '\0') ||
+		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoull);
 
 /**
  * strict_strtoll - convert a string to a long long strictly
@@ -210,53 +262,20 @@ int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
  * It returns 0 if conversion is successful and *res is set to the converted
  * value, otherwise it returns -EINVAL and *res is set to 0.
  */
-int strict_strtoll(const char *cp, unsigned int base, long long *res);
-
-#define define_strict_strtoux(type, valtype)				\
-int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
-{									\
-	char *tail;							\
-	valtype val;							\
-	size_t len;							\
-									\
-	*res = 0;							\
-	len = strlen(cp);						\
-	if (len == 0)							\
-		return -EINVAL;						\
-									\
-	val = simple_strtou##type(cp, &tail, base);			\
-	if ((*tail == '\0') ||						\
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
-		*res = val;						\
-		return 0;						\
-	}								\
-									\
-	return -EINVAL;							\
-}									\
-
-#define define_strict_strtox(type, valtype)				\
-int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
-{									\
-	int ret;							\
-	if (*cp == '-') {						\
-		ret = strict_strtou##type(cp+1, base, res);		\
-		if (!ret)						\
-			*res = -(*res);					\
-	} else								\
-		ret = strict_strtou##type(cp, base, res);		\
-									\
-	return ret;							\
-}									\
-
-define_strict_strtoux(l, unsigned long)
-define_strict_strtox(l, long)
-define_strict_strtoux(ll, unsigned long long)
-define_strict_strtox(ll, long long)
+int strict_strtoll(const char *cp, unsigned int base, long long *res)
+{
+	int ret;
+	if (*cp == '-') {
+		ret = strict_strtoull(cp + 1, base, (unsigned long long *)res);
+		if (!ret)
+			*res = -(*res);
+	} else {
+		ret = strict_strtoull(cp, base, (unsigned long long *)res);
+	}
 
-EXPORT_SYMBOL(strict_strtoul);
-EXPORT_SYMBOL(strict_strtol);
+	return ret;
+}
 EXPORT_SYMBOL(strict_strtoll);
-EXPORT_SYMBOL(strict_strtoull);
 
 static int skip_atoi(const char **s)
 {
-- 
1.6.0.2.405.g3cc38

