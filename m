Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZBZTAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZBZTAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZBZS7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:59:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZBZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:59:05 -0500
Message-Id: <20090226185901.113852600@goodmis.org>
References: <20090226185419.371469287@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 13:54:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 2/6] string: add strtok_r to kernel
Content-Disposition: inline; filename=0002-string-add-strtok_r-to-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the function strtok_r to the kernel. This acts just like
the strtok_r that is implemented in glibc, but trimmed down.
Note, this is strtok_r and not strtok. The _r version is reentrant,
where as strtok is not, and thus not suitable for the kernel.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/string.h |    3 +++
 lib/string.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index d18fc19..c5973a5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -76,6 +76,9 @@ extern char * strpbrk(const char *,const char *);
 #ifndef __HAVE_ARCH_STRSEP
 extern char * strsep(char **,const char *);
 #endif
+#ifndef __HAVE_ARCH_STRTOK_R
+extern char *strtok_r(char *, const char *, char **);
+#endif
 #ifndef __HAVE_ARCH_STRSPN
 extern __kernel_size_t strspn(const char *,const char *);
 #endif
diff --git a/lib/string.c b/lib/string.c
index b19b87a..04461b0 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -493,6 +493,49 @@ char *strsep(char **s, const char *ct)
 EXPORT_SYMBOL(strsep);
 #endif
 
+#ifndef __HAVE_ARCH_STRTOK_R
+/**
+ * strtok_r - extract tokens from strings
+ * @s:  The string to be searched
+ * @ct: The characters to deliminate the tokens
+ * @saveptr: The pointer to the next token
+ *
+ * It returns the next token found outside of the @ct delimiters.
+ * Multiple occurrences of @ct characters will be considered
+ * a single delimiter. In other words, the returned token will
+ * always have a size greater than 0 (or NULL if no token found).
+ *
+ * A '\0' is placed at the end of the found token, and
+ * @saveptr is updated to point to the location after that.
+ */
+char *strtok_r(char *s, const char *ct, char **saveptr)
+{
+	char *ret;
+	int skip;
+
+	if (!s)
+		return NULL;
+
+	/* Find start of first token */
+	skip = strspn(s, ct);
+	*saveptr = s + skip;
+
+	/* return NULL if we found no token */
+	if (!*saveptr[0])
+		return NULL;
+
+	/*
+	 * strsep is different than strtok, where as saveptr will be NULL
+	 * if token not found. strtok makes it point to the end of the string.
+	 */
+	ret = strsep(saveptr, ct);
+	if (!*saveptr)
+		*saveptr = &ret[strlen(ret)];
+	return ret;
+}
+EXPORT_SYMBOL(strtok_r);
+#endif
+
 /**
  * sysfs_streq - return true if strings are equal, modulo trailing newline
  * @s1: one string
-- 
1.5.6.5

-- 
