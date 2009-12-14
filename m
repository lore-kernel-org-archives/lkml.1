Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZLND6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZLND6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbZLND6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:58:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53655 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbZLND6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:58:32 -0500
Message-ID: <4B25B7D2.8090505@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 11:58:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] lib: Introduce strnstr()
References: <4B25B797.1040201@cn.fujitsu.com>
In-Reply-To: <4B25B797.1040201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It differs strstr() in that it limits the length to be searched
in the first string.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/string.h |    5 ++++-
 lib/string.c           |   27 ++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..fa6a5ba 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -64,7 +64,10 @@ extern char * strrchr(const char *,int);
 #endif
 extern char * __must_check strstrip(char *);
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
index e96421a..a5fff51 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -656,7 +656,7 @@ EXPORT_SYMBOL(memscan);
  */
 char *strstr(const char *s1, const char *s2)
 {
-	int l1, l2;
+	size_t l1, l2;
 
 	l2 = strlen(s2);
 	if (!l2)
@@ -673,6 +673,31 @@ char *strstr(const char *s1, const char *s2)
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
1.6.3

