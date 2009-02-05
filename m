Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZBEUoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZBEUoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZBEUoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:44:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:40466 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZBEUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:44:10 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/3] parse_shell_args.c: shell-like argument list parser
Date: Thu,  5 Feb 2009 22:47:42 +0200
Message-Id: <1233866864-14422-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.0.2.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's implementation of argument list parser using shell rules.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/kernel.h |    2 +
 lib/Makefile           |    2 +-
 lib/parse_shell_args.c |  238 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+), 1 deletions(-)
 create mode 100644 lib/parse_shell_args.c

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 343df9e..6095a84 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -208,6 +208,8 @@ extern int func_ptr_is_kernel_text(void *ptr);
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
+extern int parse_shell_args(const char *in, char *out, size_t out_size);
+
 /*
  * FW_BUG
  * Add this to a message where you are sure the firmware is buggy or behaves
diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..3aaf2f3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -20,7 +20,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o
+	 string_helpers.o parse_shell_args.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/parse_shell_args.c b/lib/parse_shell_args.c
new file mode 100644
index 0000000..2b32cab
--- /dev/null
+++ b/lib/parse_shell_args.c
@@ -0,0 +1,238 @@
+/*
+ * lib/parse_shell_args.c
+ *
+ * Copiright (C) 2009 Kirill A. Shutemov
+ *
+ * Shell-like argument list parser
+ */
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+#include <linux/types.h>
+#else
+#include <sys/types.h>
+#endif
+
+#define S_START		0
+#define S_DONE		1
+#define S_NORMAL	2
+#define S_QUOTE		3
+#define S_DQUOTE	4
+
+/**
+ * parse_shell_args - parse shell-like argument list
+ *
+ * @in:		null-terminated input string
+ * @out:	output buffer
+ * @out_size:	output buffer size in byte
+ *
+ * Returns number of arguments or 0 on error.
+ * Parsed arguments store in @out separated by '\0'
+ */
+int parse_shell_args(const char *in, char *out, size_t out_size)
+{
+	int state = S_START;
+	const char *in_p = in;
+	char *out_p = out;
+	int argc = 0;
+	int escape = 0;
+
+	while (state != S_DONE) {
+		if (out_p - out >= out_size)
+			return 0;
+
+		if (escape) {
+			*out_p++ = *in_p++;
+			escape = 0;
+			continue;
+		}
+
+		switch (state) {
+			case S_START:
+				switch (*in_p) {
+					case '\n':
+					case '\0':
+						state = S_DONE;
+						*out_p = '\0';
+						break;
+					case ' ':
+					case '\t':
+						in_p++;
+						break;
+					case '\'':
+						state = S_QUOTE;
+						in_p++;
+						argc++;
+						break;
+					case '"':
+						state = S_DQUOTE;
+						in_p++;
+						argc++;
+						break;
+					default:
+						state = S_NORMAL;
+						argc++;
+						break;
+				}
+				break;
+
+			case S_NORMAL:
+				switch (*in_p) {
+					case '\n':
+					case '\0':
+						state = S_DONE;
+						*out_p = '\0';
+						break;
+					case ' ':
+					case '\t':
+						state = S_START;
+						*out_p++ = '\0';
+						break;
+					case '\'':
+						state = S_QUOTE;
+						in_p++;
+						break;
+					case '\"':
+						state = S_DQUOTE;
+						in_p++;
+						break;
+					case '\\':
+						in_p++;
+						escape = 1;
+						break;
+					default:
+						*out_p++ = *in_p++;
+						break;
+				}
+				break;
+
+			case S_QUOTE:
+				switch (*in_p) {
+					case '\'':
+						state = S_NORMAL;
+						in_p++;
+						break;
+					case '\n':
+					case '\0':
+						return 0;
+						break;
+					default:
+						*out_p++ = *in_p++;
+						break;
+				}
+				break;
+			case S_DQUOTE:
+				switch (*in_p) {
+					case '\"':
+						state = S_NORMAL;
+						in_p++;
+						break;
+					case '\n':
+					case '\0':
+						return 0;
+						break;
+					case '\\':
+						if (*(in_p+1) == '$' ||
+								*(in_p+1) == '`' ||
+								*(in_p+1) == '"' ||
+								*(in_p+1) == '\\' ||
+								*(in_p+1) == '\n') {
+							in_p++;
+							escape = 1;
+						} else
+							*out_p++ = *in_p++;
+						break;
+					default:
+						*out_p++ = *in_p++;
+						break;
+				}
+				break;
+			default:
+				return 0;
+				break;
+		}
+	}
+
+	return argc;
+}
+
+#ifdef __KERNEL__
+EXPORT_SYMBOL(parse_shell_args);
+#else
+/* Unit tests */
+
+#include <limits.h>
+#include <stdio.h>
+#include <string.h>
+
+static void test_parse(const char *in, const char *expected_out, int expected_argc)
+{
+	char out[PATH_MAX];
+	char *out_p = out;
+	int i;
+	int argc;
+
+	argc = parse_shell_args(in, out, PATH_MAX);
+
+	if (argc != expected_argc) {
+		printf("%s: wrong argc: %d, but expected %d\n", in, argc, expected_argc);
+		return;
+	}
+
+	for(i=0; i < argc; i++) {
+		int len;
+
+		if (strcmp(expected_out, out_p)) {
+			printf("%s: %s, but expected %s\n", in , out_p, expected_out);
+			return;
+		}
+
+		len = strlen(expected_out);
+		expected_out += len + 1;
+		out_p += len + 1;
+	}
+
+	printf("%s:\tOK\n", in);
+}
+
+int main(void)
+{
+	test_parse("", "", 0);
+
+	test_parse("/bin/ls", "/bin/ls", 1);
+	test_parse("/bin\\ ls", "/bin ls", 1);
+	test_parse("/bin/ls\n", "/bin/ls", 1);
+	test_parse("/bin/ls\\\n", "/bin/ls\n", 1);
+	test_parse(" /bin/ls", "/bin/ls", 1);
+	test_parse("\t/bin/ls", "/bin/ls", 1);
+	test_parse("/bin/ls ", "/bin/ls", 1);
+	test_parse("/bin/ls\t", "/bin/ls", 1);
+	test_parse("\\'/bin/ls", "\'/bin/ls", 1);
+	test_parse("/bin\\'/ls", "/bin\'/ls", 1);
+	test_parse("/bin'/ls", "", 0);
+	test_parse("/bin\"/ls", "", 0);
+
+	test_parse("'/bin/ls'", "/bin/ls", 1);
+	test_parse("'/bin ls'", "/bin ls", 1);
+	test_parse("'/bin\tls'", "/bin\tls", 1);
+	test_parse("'/bin''/ls'", "/bin/ls", 1);
+	test_parse("/bin'/ls'", "/bin/ls", 1);
+	test_parse("'/bin'/ls", "/bin/ls", 1);
+	test_parse("'/bin \t\"%$#@/ls'", "/bin \t\"%$#@/ls", 1);
+
+	test_parse("\"/bin/ls\"", "/bin/ls", 1);
+	test_parse("\"/bin\"\"/ls\"", "/bin/ls", 1);
+	test_parse("/bin\"/ls\"", "/bin/ls", 1);
+	test_parse("\"/bin\"/ls", "/bin/ls", 1);
+	test_parse("\"\\$\\`\\\"\\\\\\\n\\\\!\\@\\#\\%\\a\"", "$`\"\\\n\\!\\@\\#\\%\\a", 1);
+	test_parse("\"/bin/ls\\\"", "", 0);
+
+	test_parse("/bin/ls -a", "/bin/ls\0-a", 2);
+	test_parse("/bin/ls\t-a", "/bin/ls\0-a", 2);
+	test_parse("/bin/ls  \t \t-a", "/bin/ls\0-a", 2);
+	test_parse("/bin/ls -a -l", "/bin/ls\0-a\0-l", 3);
+	test_parse("/bin/ls '-a -l'", "/bin/ls\0-a -l", 2);
+
+	return 0;
+}
+#endif
-- 
1.6.0.2.GIT

