Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CHHzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:55:18 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54349 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0CHHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:55:15 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf: Make printing table easily
Date: Mon,  8 Mar 2010 16:55:10 +0900
Message-Id: <1268034910-12544-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Making table of matrix by printf is painful work,
but it can be found in perf here and there.
So I'd like to propose semi-automation of making table.
New files util/table.c provides stuffs for easy table printing.

At first, user has to allocate struct table like this:
   	  struct table *t = table_new();

Then, user can define columns by table_add_fixed() for stuffs
registers can contain or table_add_string() for string.
	  table_add_fixed(t, "%p", SIZE_OF_ADDR);
	  table_add_string(t, "%30s", 30);
First argument is pointer to struct table.
Second one is format specifier.

Third argument for table_add_fixed() is size of objects in rows.
Third one for table_add_string() is maximum length of
printing string. If it is 0, no truncate will be done.

After making columns, user can print each rows like this:
      	  table_printf(t, table_test, 2501, "one");

Example of use:

| /* program */
| static void table_test(void)
| {
| 	struct table *t = table_new();
|
| 	table_add_fixed(t, "%p", SIZE_OF_ADDR);
| 	table_add_fixed(t, "%10d", sizeof(int));
| 	table_add_string(t, "%30s", 30);
|
| 	table_printf(t, table_test, 2501, "one");
| 	table_printf(t, t, 0x2501, "two");
| 	table_printf(t, table_printf, 42, "Answer to the Ultimate Question of "
| 		     "Life, the Universe, and Everything");
|
| 	table_free(t);
| }
|
| int main(void)
| {
| 	table_test();
| }

| /* output */
| 0x420340       2501                            one
| 0xc9c080       9473                            two
| 0x450e90         42 Answer to the Ultimate Questi~   <- Third argument is truncated

Current util/table.c is too weak, but this can be a basic start point.
I think this is useful, how do you think?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile     |    2 +
 tools/perf/util/table.c |  157 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/table.h |   32 ++++++++++
 3 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/table.c
 create mode 100644 tools/perf/util/table.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 54a5b50..93ecf09 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,6 +387,7 @@ LIB_H += util/thread.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
+LIB_H += util/table.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -433,6 +434,7 @@ LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
 LIB_OBJS += util/probe-event.o
 LIB_OBJS += util/util.o
+LIB_OBJS += util/table.o
 
 BUILTIN_OBJS += builtin-annotate.o
 
diff --git a/tools/perf/util/table.c b/tools/perf/util/table.c
new file mode 100644
index 0000000..a8b770d
--- /dev/null
+++ b/tools/perf/util/table.c
@@ -0,0 +1,157 @@
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdarg.h>
+
+#include <linux/kernel.h>
+
+#include "util.h"
+#include "table.h"
+
+struct table *table_new(void)
+{
+	struct table *new;
+
+	new = zalloc(sizeof(struct table));
+	new->column_formats.next = &new->column_formats;
+	new->column_formats.prev = &new->column_formats;
+	return new;
+}
+
+void table_free(struct table *t)
+{
+	struct list_head *l;
+
+	list_for_each_prev(l, &t->column_formats) {
+		struct column_format *fmt
+			= container_of(l, struct column_format, formats);
+		free(fmt);
+	}
+
+	free(t);
+}
+
+static void table_add_column(struct table *t, struct column_format *new)
+{
+	list_add_tail(&new->formats, &t->column_formats);
+}
+
+void table_add_fixed(struct table *t, const char *spec, int size)
+{
+	struct column_format *fmt;
+
+	fmt = zalloc(sizeof(struct column_format));
+	fmt->spec = spec;
+	fmt->size = size;
+	table_add_column(t, fmt);
+}
+
+void table_add_string(struct table *t, const char *spec, int trunc)
+{
+	struct column_format *fmt;
+
+	BUG_ON(trunc < 0);
+
+	fmt = zalloc(sizeof(struct column_format));
+	fmt->spec = spec;
+	fmt->size = SIZE_OF_ADDR;
+	fmt->attr |= TABLE_ATTR_STRING;
+	fmt->trunc = trunc;
+	table_add_column(t, fmt);
+}
+
+void table_printf(struct table *t, ...)
+{
+	va_list ap;
+	struct list_head *l;
+
+	unsigned char byte = 0;
+	unsigned short word = 0;
+	unsigned long dword = 0;
+	unsigned long long qword = 0;
+	char *str = NULL;
+
+	va_start(ap, t);
+
+	list_for_each(l, &t->column_formats) {
+		struct column_format *fmt
+			= container_of(l, struct column_format, formats);
+
+		if (fmt->attr & TABLE_ATTR_STRING) {
+			BUG_ON(fmt->size != SIZE_OF_ADDR);
+
+			str = va_arg(ap, char *);
+
+			if (!fmt->trunc || (strlen(str) < fmt->trunc)) {
+				printf(fmt->spec, str);
+			} else {
+				char *trunced = zalloc(fmt->trunc + 1);
+				memcpy(trunced, str, fmt->trunc);
+				trunced[fmt->trunc - 1] = '~';
+				printf(fmt->spec, trunced);
+			}
+		} else {
+			switch (fmt->size) {
+			case 1:
+				byte = (unsigned char)va_arg(ap, unsigned int);
+				printf(fmt->spec, byte);
+				break;
+			case 2:
+				word = (unsigned short)va_arg(ap, unsigned int);
+				printf(fmt->spec, word);
+				break;
+			case 4:
+				dword = va_arg(ap, unsigned long);
+				printf(fmt->spec, dword);
+				break;
+			case 8:
+				qword = va_arg(ap, unsigned long long);
+				printf(fmt->spec, qword);
+				break;
+			default:
+				die("table_printf(): unknown size:%d\n",
+				    fmt->size);
+				break;
+			}
+		}
+
+		if (l->next != &t->column_formats)
+			printf(" ");
+	}
+
+	printf("\n");
+	va_end(ap);
+}
+
+#if 0
+/* usage sample */
+
+/* program */
+static void table_test(void)
+{
+	struct table *t = table_new();
+
+	table_add_fixed(t, "%p", SIZE_OF_ADDR);
+	table_add_fixed(t, "%10d", sizeof(int));
+	table_add_string(t, "%30s", 30);
+
+	table_printf(t, table_test, 2501, "one");
+	table_printf(t, t, 0x2501, "two");
+	table_printf(t, table_printf, 42, "Answer to the Ultimate Question of "
+		     "Life, the Universe, and Everything");
+
+	table_free(t);
+}
+
+int main(void)
+{
+	table_test();
+}
+
+/* output */
+0x420340       2501                            one
+0xc9c080       9473                            two
+0x450e90         42 Answer to the Ultimate Questi~
+
+#endif
diff --git a/tools/perf/util/table.h b/tools/perf/util/table.h
new file mode 100644
index 0000000..8a7c7d8
--- /dev/null
+++ b/tools/perf/util/table.h
@@ -0,0 +1,32 @@
+
+#ifndef __PERF_TABLE_H
+#define __PERF_TABLE_H
+
+#include <linux/list.h>
+
+#define SIZE_OF_ADDR sizeof(void *)
+
+#define TABLE_ATTR_STRING 0x00000001
+
+struct column_format {
+	struct list_head formats;
+
+	const char       *spec;
+	int              size;
+	int              attr;
+	unsigned int     trunc;
+};
+
+struct table {
+	int columns;
+	struct list_head column_formats;
+};
+
+struct table *table_new(void);
+void table_free(struct table *t);
+void table_printf(struct table *t, ...);
+
+void table_add_fixed(struct table *t, const char *spec, int size);
+void table_add_string(struct table *t, const char *spec, int trunc);
+
+#endif	/* __PERF_TABLE_H */
-- 
1.6.5.2

