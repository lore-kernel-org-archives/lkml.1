Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXJXUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXJXUAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXJXUAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:00:01 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49986 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXJXT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:59:59 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Wed, 24 Oct 2007 15:59:49 -0400
Message-Id: <1193255992-14385-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071024195847.GE27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consecutive calls to printk are non-atomic, which leads to various
implementations for accumulating strings which can be printed in one call.
This is a generic string buffer which can also be used for non-printk
purposes.  There is no sb_scanf implementation yet as I haven't identified
a user for it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/stringbuf.h |   77 ++++++++++++++++++++++++++++++++++++++++
 lib/Makefile              |    2 +-
 lib/stringbuf.c           |   85 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/stringbuf.h
 create mode 100644 lib/stringbuf.c

diff --git a/include/linux/stringbuf.h b/include/linux/stringbuf.h
new file mode 100644
index 0000000..c030bc6
--- /dev/null
+++ b/include/linux/stringbuf.h
@@ -0,0 +1,77 @@
+/*
+ * An auto-expanding string buffer.  There's no sb_alloc because you really
+ * want to allocate it on the stack or embed it in another structure.
+ *
+ * No locking is performed for you; callers are expected to handle locking
+ * themselves if necessary.
+ */
+
+#include <stdarg.h>
+#include <linux/string.h>
+
+/*
+ * 'buf' is the string and may be accessed directly.
+ * 'len' is the number of bytes excluding the NUL terminator.  It may
+ *   also be accessed directly, but note that a freshly-initialised
+ *   stringbuf has a NULL buf, and a len of 0.
+ * 'alloc' is the number of bytes currently allocated to 'buf'.  It
+ *   probably shouldn't be accessed directly.  If you find yourself
+ *   having to, maybe you need to add more functionality to the
+ *   stringbuf code.
+ */
+struct stringbuf {
+	char *buf;
+	int len;
+	int alloc;
+};
+
+/*
+ * Returns a negative errno if an error has been found with this stringbuf,
+ * or 0 if no error has occurred.  If an error has occurred, sb->buf
+ * contains a suitable description of the error
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
+		kfree(sb->buf);
+	sb_init(sb);
+}
+
+extern void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
+	__attribute__((format(printf, 3, 4)));
+#if 0
+/* Waiting for a user to show up */
+extern void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *fmt,
+			va_list args) __attribute__((format(printf, 3, 0)));
+#endif
+
+/*
+ * Convert the stringbuf to a string.  It is the caller's responsibility
+ * to free the string.  The stringbuf is then ready to be reused.
+ */
+static inline char *sb_to_string(struct stringbuf *sb)
+{
+	char *s = sb->buf;
+	if (sb_error(sb))
+		s = kstrdup(s, GFP_ATOMIC);
+	sb_init(sb);
+	return s;
+}
diff --git a/lib/Makefile b/lib/Makefile
index 3a0983b..f075389 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,7 +14,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o
+	 bust_spinlocks.o hexdump.o kasprintf.o stringbuf.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/stringbuf.c b/lib/stringbuf.c
new file mode 100644
index 0000000..b4e59f4
--- /dev/null
+++ b/lib/stringbuf.c
@@ -0,0 +1,85 @@
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
+#define INITIAL_SIZE 128
+#define ERR_STRING "out of memory"
+
+/*
+ * Not currently used outside this file, but separated from sb_printf
+ * for when someone needs it.
+ */
+static void sb_vprintf(struct stringbuf *sb, gfp_t gfp, const char *format, va_list args)
+{
+	char *s;
+	int size, newlen;
+
+	if (sb->alloc == -ENOMEM)
+		return;
+	if (sb->alloc == 0) {
+		sb->buf = kmalloc(INITIAL_SIZE, gfp);
+		if (!sb->buf) 
+			goto nomem;
+		sb->alloc = INITIAL_SIZE;
+	}
+
+	s = sb->buf + sb->len;
+	size = vsnprintf(s, sb->alloc - sb->len, format, args);
+
+	sb->len += size;
+	if (likely(sb->len < sb->alloc))
+		return;
+
+	/*
+	 * Ensure we always grow the buffer by at least 1.5x.  slab and
+	 * slub already enforce this, but slob will happily allocate
+	 * sizes down to two bytes in granularity
+	 */
+	newlen = max(sb->len + 1, sb->alloc + sb->alloc / 2);
+	s = krealloc(sb->buf, newlen, gfp);
+	if (!s)
+		goto nomem;
+	sb->buf = s;
+	sb->alloc = ksize(s);
+
+	/* Point to the end of the old string since we already updated ->len */
+	s += sb->len - size;
+	vsprintf(s, format, args);
+	return;
+
+ nomem:
+	kfree(sb->buf);
+	sb->buf = ERR_STRING;
+	sb->len = sizeof(ERR_STRING);
+	sb->alloc = -ENOMEM;
+}
+/* When we get our first modular user, delete this comment
+EXPORT_SYMBOL(sb_vprintf);
+*/
+
+void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	sb_vprintf(sb, gfp, format, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(sb_printf);
-- 
1.5.3.4

