Return-Path: <linux-kernel-owner+w=401wt.eu-S1765967AbYEGS0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765967AbYEGS0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbYEGSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:25:38 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:27172 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765554AbYEGSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pcd8tK/fNlp1IHgko0/9RwFtRBc889Zxff6NHyaiYH0VmVDewIlzxlvUiFAZG9ZayGDcYlRaMt1fxgz9fuSQ/GAM/U+MK9wXTq5tmgHgxbG0OEcab5RCae5yO7aqVkyNalFq4K2zsxPqCxkEJHyTb4TuwxJdJwSn+AiXP4MzC4s=
Subject: [PATCH 2/2] lib: vsprintf.c remove macros defining strict string
	functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 11:25:29 -0700
Message-Id: <1210184729.19279.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly code the strict string conversion functions rather than using
defining macros.  Pull out a small helper to check the strict conditions
required at the end of a string (nul-terminated or newline).

Add additional checks in strict_strtol and strict_strtoll for numeric
overflow of the signed types.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 lib/vsprintf.c |  144 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0b39c34..ff0c93d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -128,6 +128,18 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 	return simple_strtoull(cp, endp, base);
 }
 
+/*
+ * Strictly check that the string is nul terminated or has a newline
+ * immediately following len chars.
+ */
+static int strict_checktail(size_t len, const char *cp, const char *tail)
+{
+	if ((*tail == '\0') ||
+	    ((len == (size_t)(tail - cp) + 1) && (*tail == '\n')))
+		return 1;
+	else
+		return 0;
+}
 
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
@@ -151,7 +163,26 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
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
+	if (strict_checktail(len, cp, tail)) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoul);
 
 /**
  * strict_strtol - convert a string to a long strictly
@@ -165,7 +196,29 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
  * It returns 0 if conversion is successful and *res is set to the converted
  * value, otherwise it returns -EINVAL and *res is set to 0.
  */
-int strict_strtol(const char *cp, unsigned int base, long *res);
+int strict_strtol(const char *cp, unsigned int base, long *res)
+{
+	int ret;
+	unsigned long tmp;
+
+	if (*cp == '-')
+		ret = strict_strtoul(cp + 1, base, &tmp);
+	else
+		ret = strict_strtoul(cp, base, &tmp);
+
+	if (!ret || tmp > LONG_MAX) {
+		*res = 0;
+		return -EINVAL;
+	}
+
+	if (*cp == '-')
+		*res = -tmp;
+	else
+		*res = tmp;
+
+	return 0;
+}
+EXPORT_SYMBOL(strict_strtol);
 
 /**
  * strict_strtoull - convert a string to an unsigned long long strictly
@@ -189,7 +242,26 @@ int strict_strtol(const char *cp, unsigned int base, long *res);
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
+	if (strict_checktail(len, cp, tail)) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoull);
 
 /**
  * strict_strtoll - convert a string to a long long strictly
@@ -203,53 +275,29 @@ int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
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
-	val = simple_strtoul(cp, &tail, base);				\
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
+	unsigned long long tmp;
 
-EXPORT_SYMBOL(strict_strtoul);
-EXPORT_SYMBOL(strict_strtol);
+	if (*cp == '-')
+		ret = strict_strtoull(cp + 1, base, &tmp);
+	else
+		ret = strict_strtoull(cp, base, &tmp);
+
+	if (!ret || tmp > LLONG_MAX) {
+		*res = 0;
+		return -EINVAL;
+	}
+
+	if (*cp == '-')
+		*res = -tmp;
+	else
+		*res = tmp;
+
+	return 0;
+}
 EXPORT_SYMBOL(strict_strtoll);
-EXPORT_SYMBOL(strict_strtoull);
 
 static int skip_atoi(const char **s)
 {
-- 
1.5.5.1.350.gbbbf

