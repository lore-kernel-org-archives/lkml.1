Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0APJoN (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732Ab0APJoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:44:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:54222 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0APJoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:44:07 -0500
Date: Sat, 16 Jan 2010 09:43:41 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E8743.6030805@cn.fujitsu.com>
References: <4B4E8743.6030805@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] lib: Introduce strnstr()
Message-ID: <tip-d5f1fb53353edc38da326445267c1df0c9676df2@git.kernel.org>
Git-Commit-ID: d5f1fb53353edc38da326445267c1df0c9676df2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:43:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5f1fb53353edc38da326445267c1df0c9676df2
Gitweb:     http://git.kernel.org/tip/d5f1fb53353edc38da326445267c1df0c9676df2
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:53:55 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:09 -0500

lib: Introduce strnstr()

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
