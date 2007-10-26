Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbXJZCKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbXJZCKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbXJZCKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:10:34 -0400
Received: from ozlabs.org ([203.10.76.45]:39650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550AbXJZCKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:10:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Fri, 26 Oct 2007 12:11:01 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx>
In-Reply-To: <1193255992-14385-1-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261211.01423.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 05:59:49 Matthew Wilcox wrote:
> Consecutive calls to printk are non-atomic, which leads to various
> implementations for accumulating strings which can be printed in one call.
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  include/linux/stringbuf.h |   77 ++++++++++++++++++++++++++++++++++++++++
>  lib/Makefile              |    2 +-
>  lib/stringbuf.c           |   85 +++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 163 insertions(+), 1 deletions(-)

Hi Willy,

	This just seems like more optimization and complexity that we need.  Interfaces
using vsnprintf don't seem like good candidates for optimization.

How about this?  It's as simple as I could make it...

 include/linux/stringbuf.h |   30 ++++++++++++++++++++++++++++++
 lib/Makefile              |    2 +-
 lib/stringbuf.c           |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/stringbuf.h
 create mode 100644 lib/stringbuf.c

diff --git a/include/linux/stringbuf.h b/include/linux/stringbuf.h
new file mode 100644
index 0000000..70b21c6
--- /dev/null
+++ b/include/linux/stringbuf.h
@@ -0,0 +1,30 @@
+#ifndef _LINUX_STRINGBUF_H
+#define _LINUX_STRINGBUF_H
+#include <linux/slab.h>
+
+/* This starts NULL and gets krealloc'ed as it grows. */
+struct stringbuf {
+	char buf[0];
+};
+
+/* Your stringbuf will point to this if we run out of memory. */
+extern char enomem_string[];
+
+/* Tack some stuff on the stringbuf. */
+extern void sb_printf_append(struct stringbuf **sb,
+			     gfp_t gfp, const char *fmt, ...)
+	__attribute__((format(printf, 3, 4)));
+
+/**
+ * sb_free - free a stringbuf used by sb_printf_append.
+ * @sb: the stringbuf pointer
+ *
+ * Handles the NULL and OOM cases, so no checking needed.
+ */
+static inline void sb_free(struct stringbuf *sb)
+{
+	if (sb->buf != enomem_string)
+		kfree(sb);
+}
+
+#endif /* _LINUX_STRINGBUF_H */
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
index 0000000..ffe977a
--- /dev/null
+++ b/lib/stringbuf.c
@@ -0,0 +1,41 @@
+#include <stdarg.h>
+#include <linux/stringbuf.h>
+#include <linux/module.h>
+
+char enomem_string[] __attribute__((aligned(__alignof__(struct stringbuf))))
+	= "stringbuf: out of memory";
+
+/**
+ * sb_printf_append - append to a stringbuf
+ * @sb: a pointer to the stringbuf ptr (which starts NULL)
+ * @gfp: flags for allocation
+ * @fmt: printf-style format
+ *
+ * Reallocates *@sb and appends to it.  Sets *sb to a explanatory string if
+ * out of memory.
+ */
+void sb_printf_append(struct stringbuf **sb, gfp_t gfp, const char *fmt, ...)
+{
+	unsigned int fmtlen, len;
+	va_list args;
+	struct stringbuf *oldsb = *sb;
+
+	if (oldsb->buf == enomem_string)
+		return;
+
+	va_start(args, fmt);
+	fmtlen = vsnprintf(NULL, 0, fmt, args);
+	va_end(args);
+
+	len = oldsb ? strlen(oldsb->buf) : 0;
+	*sb = krealloc(oldsb, len + fmtlen + 1, gfp);
+	if (!*sb) {
+		kfree(oldsb);
+		*sb = (struct stringbuf *)enomem_string;
+	} else {
+		va_start(args, fmt);
+		vsprintf((*sb)->buf + len, fmt, args);
+		va_end(args);
+	}
+}
+EXPORT_SYMBOL(sb_printf_append);
