Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYEMX6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYEMX6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbYEMX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:57:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:52334 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721AbYEMX5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=peKjkAM2hxADDixBNMDHYqUl5CnBbeToI0iowyJKY2MQe1w+K3JR0ze/Lkm/RaZYkqfp9BbShISM1DMOhjoxvXWcLh5x9+fHQgyAB5NBhM6s5p16vIOupmcHovo2mX3Ata/YpGhLyJcSNyJOv25PbvMp1sEePg3tSegHC5u2e5k=
Subject: [PATCH 2/3] lib: vsnprintf.c remove macros defining strict string
	functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 16:57:44 -0700
Message-Id: <1210723064.6191.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
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
 lib/vsprintf.c |  145 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 97 insertions(+), 48 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index dc5c3ae..3547fb5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -131,6 +131,19 @@ long long simple_strtoll(const char *cp,char **endp,unsigned int base)
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
+
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
  * @cp: The string to be converted
@@ -153,7 +166,26 @@ long long simple_strtoll(const char *cp,char **endp,unsigned int base)
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
@@ -167,7 +199,29 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
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
+	if (ret < 0 || tmp > LONG_MAX) {
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
@@ -191,7 +245,26 @@ int strict_strtol(const char *cp, unsigned int base, long *res);
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
@@ -205,53 +278,29 @@ int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
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
+	if (ret < 0 || tmp > LLONG_MAX) {
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
1.5.5.1.482.g0f174


