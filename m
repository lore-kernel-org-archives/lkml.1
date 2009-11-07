Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZKHQZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZKHQZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZKHQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:25:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50680 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZKHQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=TYlGDV8Quh61FjTQbp6/FACqmf9+3dFc+bNEXvcTL83joUWKeNroGvlepHGQG6atUg
         YiRMmtWaC4/1UdAUd7U7yHtOsdpoX4i+hEuFCycBUMTKIl41OmZzbw4jVxjoKZsQOcHi
         ahHso57BjbwXLhpqs/hGQNkx77QDBYdngYnww=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: jengelh@medozas.de, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 10/12] string: factorize skip_spaces and export it to be generally available
Date: Sat,  7 Nov 2009 14:23:50 -0200
Message-Id: <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
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
If *s == 1, we depend on isspace() result anyway.

In other words, "a char equals zero is never a space". So remove this check.
Also, *s != 0 is by far the most common case (non-empty string).

Fixed const return as noticed by Jan Engelhardt and James Bottomley

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/string.h |    1 +
 lib/string.c           |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..3bba9ee 100644
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
index b19b87a..d9a51d5 100644
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
+	return str;
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
+	return (char *)skip_spaces(s);
 }
 EXPORT_SYMBOL(strstrip);
 
-- 
1.6.5.2.153.g6e31f.dirty

