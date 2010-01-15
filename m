Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0AOEAg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 23:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460Ab0AOD7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:59:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0AOD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=RRHqD-2QBUoA:10 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=FGfIGzqGBb_-eyKQmZ0A:9 a=eeM_ybOtwOf8Kz8GtlUA:7 a=aDmiRSmc8HuFVIdYLb9N9JOi_TwA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rfSSAgpB8YlTvswe:21 a=EJ7AwCN74JD5_Yzt:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100115035853.256010100@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 22:57:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8] lib: Introduce strnstr()
References: <20100115035726.462940848@goodmis.org>
Content-Disposition: inline; filename=0005-lib-Introduce-strnstr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

It differs strstr() in that it limits the length to be searched
in the first string.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8743.6030805@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/string.h |    5 ++++-
 lib/string.c           |   27 ++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 651839a..a716ee2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -72,7 +72,10 @@ static inline __must_check char *strstrip(char *str)
 }
 
 #ifndef __HAVE_ARCH_STRSTR
-extern char * strstr(const char *,const char *);
+extern char * strstr(const char *, const char *);
+#endif
+#ifndef __HAVE_ARCH_STRNSTR
+extern char * strnstr(const char *, const char *, size_t);
 #endif
 #ifndef __HAVE_ARCH_STRLEN
 extern __kernel_size_t strlen(const char *);
diff --git a/lib/string.c b/lib/string.c
index 9f75b4e..a1cdcfc 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -667,7 +667,7 @@ EXPORT_SYMBOL(memscan);
  */
 char *strstr(const char *s1, const char *s2)
 {
-	int l1, l2;
+	size_t l1, l2;
 
 	l2 = strlen(s2);
 	if (!l2)
@@ -684,6 +684,31 @@ char *strstr(const char *s1, const char *s2)
 EXPORT_SYMBOL(strstr);
 #endif
 
+#ifndef __HAVE_ARCH_STRNSTR
+/**
+ * strnstr - Find the first substring in a length-limited string
+ * @s1: The string to be searched
+ * @s2: The string to search for
+ * @len: the maximum number of characters to search
+ */
+char *strnstr(const char *s1, const char *s2, size_t len)
+{
+	size_t l1 = len, l2;
+
+	l2 = strlen(s2);
+	if (!l2)
+		return (char *)s1;
+	while (l1 >= l2) {
+		l1--;
+		if (!memcmp(s1, s2, l2))
+			return (char *)s1;
+		s1++;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(strnstr);
+#endif
+
 #ifndef __HAVE_ARCH_MEMCHR
 /**
  * memchr - Find a character in an area of memory.
-- 
1.6.5


