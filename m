Return-Path: <linux-kernel-owner+w=401wt.eu-S966443AbXEKTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966443AbXEKTWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763592AbXEKTTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:19:39 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:36776 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966156AbXEKTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:19:37 -0400
Message-Id: <20070511000027.596468000@goop.org>
References: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 4/7] add argv_split()
Content-Disposition: inline; filename=split-argv.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

argv_split() is a helper function which takes a string, splits it at
whitespace, and returns a NULL-terminated argv vector.  This is
deliberately simple - it does no quote processing of any kind.

[ Seems to me that this is something which is already being done in
  the kernel, but I couldn't find any other implementations, either to
  steal or replace.  Keep an eye out. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>

---
 include/linux/string.h |    3 
 lib/Makefile           |    2 
 lib/argv_split.c       |  159 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+), 1 deletion(-)

===================================================================
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -108,6 +108,9 @@ extern char *kstrndup(const char *s, siz
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
+extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
+extern void argv_free(char **argv);
+
 #ifdef __cplusplus
 }
 #endif
===================================================================
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
-	 sha1.o irq_regs.o reciprocal_div.o
+	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
===================================================================
--- /dev/null
+++ b/lib/argv_split.c
@@ -0,0 +1,159 @@
+/*
+ * Helper function for splitting a string into an argv-like array.
+ */
+
+#ifndef TEST
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/bug.h>
+#endif
+
+static const char *skip_sep(const char *cp)
+{
+	while (*cp && isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static const char *skip_arg(const char *cp)
+{
+	while (*cp && !isspace(*cp))
+		cp++;
+
+	return cp;
+}
+
+static int count_argc(const char *str)
+{
+	int count = 0;
+
+	while (*str) {
+		str = skip_sep(str);
+		if (*str) {
+			count++;
+			str = skip_arg(str);
+		}
+	}
+
+	return count;
+}
+
+/**
+ * argv_free - free an argv
+ *
+ * @argv - the argument vector to be freed
+ *
+ * Frees an argv and the strings it points to.
+ */
+void argv_free(char **argv)
+{
+	char **p;
+	for (p = argv; *p; p++)
+		kfree(*p);
+
+	kfree(argv);
+}
+EXPORT_SYMBOL(argv_free);
+
+/**
+ * argv_split - split a string at whitespace, returning an argv
+ * @gfp: the GFP mask used to allocate memory
+ * @str: the string to be split
+ * @argcp: returned argument count
+ *
+ * Returns an array of pointers to strings which are split out from
+ * @str.  This is performed by strictly splitting on white-space; no
+ * quote processing is performed.  Multiple whitespace characters are
+ * considered to be a single argument separator.  The returned array
+ * is always NULL-terminated.  Returns NULL on memory allocation
+ * failure.
+ */
+char **argv_split(gfp_t gfp, const char *str, int *argcp)
+{
+	int argc = count_argc(str);
+	char **argv = kzalloc(sizeof(*argv) * (argc+1), gfp);
+	char **argvp;
+
+	if (argv == NULL)
+		goto out;
+
+	*argcp = argc;
+	argvp = argv;
+
+	while (*str) {
+		str = skip_sep(str);
+
+		if (*str) {
+			const char *p = str;
+			char *t;
+
+			str = skip_arg(str);
+
+			t = kstrndup(p, str-p, gfp);
+			if (t == NULL)
+				goto fail;
+			*argvp++ = t;
+		}
+	}
+	*argvp = NULL;
+
+  out:
+	return argv;
+
+  fail:
+	argv_free(argv);
+	return NULL;
+}
+EXPORT_SYMBOL(argv_split);
+
+#ifdef TEST
+#define _GNU_SOURCE
+#include <ctype.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+typedef enum {
+	GFP_KERNEL,
+} gfp_t;
+#define kzalloc(size, x)	malloc(size)
+#define kfree(x)		free(x)
+#define kstrndup(s, n, gfp)	strndup(s, n)
+#define BUG()	abort()
+
+int main() {
+	const char *testvec[] = {
+		"",
+		"x",
+		"\"",
+		"\\\0",
+		"\"",
+		"test one two three",
+		"arg\"foo\"bar biff",
+		"one two\\ three four",
+		"one \"two three\" four",
+		NULL,
+	};
+	const char **t;
+
+	for (t = testvec; *t; t++) {
+		char **argv;
+		int argc;
+		char **a;
+
+		printf("%d: test [%s]\n", t-testvec, *t);
+
+		argv = argv_split(GFP_KERNEL, *t, &argc);
+
+		printf("argc=%d vec=", argc);
+		for (a = argv; *a; a++)
+			printf("[%s] ", *a);
+		printf("\n");
+
+		argv_free(argv);
+	}
+
+	return 0;
+}
+#endif

-- 

