Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZKOHOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZKOHOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZKOHO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:29 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZKOHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=J/ZB/rph+Nm7q39W9KxsquOFP/87ceuq+4WpOw0uB5fSxTdVto04mML9zbhz99yWJ7
         Ave8uoNPi0RjAeWRBnPTp3mN5hujV6luEl0RpsxXOz8fyAWp1NQzAXEPuO8auem3NImk
         53KFcLJYFDDC9WlQoMRuFajCh5bEiblQHje3g=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 10/12] string: factorize skip_spaces and export it to be generally available
Date: Sat, 14 Nov 2009 05:11:58 -0200
Message-Id: <b6353c59eca999d76c7951f24aae6eb890eb510b.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the following sentence:
    while (*s && isspace(*s))
        s++;

If *s == 0, isspace() evaluates to ((_ctype[*s] & 0x20) != 0), which
evaluates to ((0x08 & 0x20) != 0) which equals to 0 as well.
If *s == 1, we depend on isspace() result anyway. In other words,
"a char equals zero is never a space", so remove this check.

Also, *s != 0 is most common case (non-null string).

Fixed const return as noticed by Jan Engelhardt and James Bottomley.
Fixed unnecessary extra cast on strstrip() as noticed by Jan Engelhardt.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/ctype.h  |    1 +
 include/linux/string.h |    1 +
 lib/string.c           |   19 +++++++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/ctype.h b/include/linux/ctype.h
index 6dec944..a3d6ee0 100644
--- a/include/linux/ctype.h
+++ b/include/linux/ctype.h
@@ -27,6 +27,7 @@ extern const unsigned char _ctype[];
 #define islower(c)	((__ismask(c)&(_L)) != 0)
 #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
 #define ispunct(c)	((__ismask(c)&(_P)) != 0)
+/* Note: isspace() must return false for %NUL-terminator */
 #define isspace(c)	((__ismask(c)&(_S)) != 0)
 #define isupper(c)	((__ismask(c)&(_U)) != 0)
 #define isxdigit(c)	((__ismask(c)&(_D|_X)) != 0)
diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..168dad1 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -62,6 +62,7 @@ extern char * strnchr(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
+extern char * __must_check skip_spaces(const char *);
 extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
diff --git a/lib/string.c b/lib/string.c
index b19b87a..087d33b 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -330,6 +330,20 @@ EXPORT_SYMBOL(strnchr);
 #endif
 
 /**
+ * skip_spaces - Removes leading whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Returns a pointer to the first non-whitespace character in @s.
+ */
+char *skip_spaces(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+EXPORT_SYMBOL(skip_spaces);
+
+/**
  * strstrip - Removes leading and trailing whitespace from @s.
  * @s: The string to be stripped.
  *
@@ -352,10 +366,7 @@ char *strstrip(char *s)
 		end--;
 	*(end + 1) = '\0';
 
-	while (*s && isspace(*s))
-		s++;
-
-	return s;
+	return skip_spaces(s);
 }
 EXPORT_SYMBOL(strstrip);
 
-- 
1.6.5.2.180.gc5b3e.dirty

