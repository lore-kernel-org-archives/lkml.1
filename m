Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbXJWVND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbXJWVND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbXJWVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:12:52 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49753 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbXJWVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:12:50 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Tue, 23 Oct 2007 17:12:43 -0400
Message-Id: <1193173966-3550-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consecutive calls to printk are non-atomic, which leads to various
implementations for accumulating strings which can be printed in one call.
This is a generic string buffer which can also be used for non-printk
purposes.  There is no sb_scanf implementation yet as I haven't identified
a user for it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/stringbuf.h |   85 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile              |    2 +-
 lib/stringbuf.c           |   79 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/stringbuf.h
 create mode 100644 lib/stringbuf.c

diff --git a/include/linux/stringbuf.h b/include/linux/stringbuf.h
new file mode 100644
index 0000000..f9200fe
--- /dev/null
+++ b/include/linux/stringbuf.h
@@ -0,0 +1,85 @@
+/*
+ * An auto-expanding string buffer.  There's no sb_alloc because you really
+ * want to allocate it on the stack or embed it in another structure.
+ *
+ * Please don't access the elements directly; that will give us the chance
+ * to change the implementation later if necessary.
+ *
+ * No locking is performed, although memory allocation is done with
+ * GFP_ATOMIC to allow it to be called when you're holding a lock.
+ */
+
+#include <stdarg.h>
+#include <linux/string.h>
+
+struct stringbuf {
+	char *s;
+	int alloc;
+	int len;
+};
+
+/*
+ * Returns the current length of the string.  Note that more memory
+ * may have been allocated for the string than this.
+ */
+static inline int sb_len(struct stringbuf *sb)
+{
+	return sb->len;
+}
+
+/*
+ * Returns a negative errno if an error has been found with this stringbuf,
+ * or 0 if no error has occurred.  If an error has occurred, sb_string()
+ * returns a suitable description of the error
+ */
+static inline int sb_error(struct stringbuf *sb)
+{
+	return sb->alloc < 0 ? sb->alloc : 0;
+}
+
+/*
+ * Initialise a newly-allocated stringbuf
+ */
+static inline void sb_init(struct stringbuf *sb)
+{
+	memset(sb, 0, sizeof(*sb));
+}
+
+/*
+ * Free the contents of a stringbuf, not the stringbuf itself.  The
+ * stringbuf is then reinitialised so it can be reused, or sb_free can
+ * be called on it multiple times.
+ */
+static inline void sb_free(struct stringbuf *sb)
+{
+	if (sb->alloc > 0)
+		kfree(sb->s);
+	sb_init(sb);
+}
+
+extern void sb_printf(struct stringbuf *sb, const char *fmt, ...)
+	__attribute__((format(printf, 2, 3)));
+#if 0
+/* Waiting for a user to show up */
+extern void sb_vprintf(struct stringbuf *sb, const char *fmt, va_list args)
+	__attribute__((format(printf, 2, 0)));
+#endif
+
+/* Get a pointer to the string. */
+static inline char *sb_string(struct stringbuf *sb)
+{
+	return sb->s;
+}
+
+/*
+ * Convert the stringbuf to a string.  It is the caller's responsibility
+ * to free the string.  The stringbuf is then ready to be reused.
+ */
+static inline char *sb_to_string(struct stringbuf *sb)
+{
+	char *s = sb->s;
+	if (sb_error(sb))
+		s = kstrdup(s, GFP_ATOMIC);
+	sb_init(sb);
+	return s;
+}
diff --git a/lib/Makefile b/lib/Makefile
index 3a0983b..0c33ff6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := ctype.o string.o stringbuf.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
diff --git a/lib/stringbuf.c b/lib/stringbuf.c
new file mode 100644
index 0000000..0853062
--- /dev/null
+++ b/lib/stringbuf.c
@@ -0,0 +1,79 @@
+/*
+ * stringbuf.c
+ *
+ * Copyright (c) 2007 Intel Corporation
+ * By Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Released under the terms of the GNU GPL, version 2.
+ *
+ * A simple automatically expanding string.  I'm not opposed to adding
+ * more functions to this (eg sb_scanf, sb_insert, sb_delete, sb_strchr, etc),
+ * but I have no need for them right now, so I haven't added them.
+ */
+
+#include <stdarg.h>
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/stringbuf.h>
+
+#define INITIAL_SIZE 32
+#define ERR_STRING "out of memory"
+
+/*
+ * Not currently used outside this file, but separated from sb_printf
+ * for when someone needs it.
+ */
+static void sb_vprintf(struct stringbuf *sb, const char *format, va_list args)
+{
+	char *s;
+	int size;
+
+	if (sb->alloc == -ENOMEM)
+		return;
+	if (sb->alloc == 0) {
+		sb->s = kmalloc(INITIAL_SIZE, GFP_ATOMIC);
+		if (!sb->s) 
+			goto nomem;
+		sb->alloc = INITIAL_SIZE;
+	}
+
+	s = sb->s + sb->len;
+	size = vsnprintf(s, sb->alloc - sb->len, format, args);
+
+	sb->len += size;
+	if (likely(sb->len < sb->alloc))
+		return;
+
+	s = krealloc(sb->s, sb->len + 1, GFP_ATOMIC);
+	if (!s)
+		goto nomem;
+	sb->s = s;
+	sb->alloc = ksize(s);
+
+	/* Point to the end of the old string since we already updated ->len */
+	s += sb->len - size;
+	vsprintf(s, format, args);
+	return;
+
+ nomem:
+	kfree(sb->s);
+	sb->s = ERR_STRING;
+	sb->len = sizeof(ERR_STRING);
+	sb->alloc = -ENOMEM;
+}
+/* When we get our first modular user, delete this comment
+EXPORT_SYMBOL(sb_vprintf);
+*/
+
+void sb_printf(struct stringbuf *sb, const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	sb_vprintf(sb, format, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(sb_printf);
-- 
1.5.3.4

