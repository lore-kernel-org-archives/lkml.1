Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXJ2Fi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXJ2Fi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXJ2Fiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:38:52 -0400
Received: from ozlabs.org ([203.10.76.45]:54373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbXJ2Fiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:38:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Mon, 29 Oct 2007 16:38:54 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
References: <20071024195847.GE27248@parisc-linux.org> <200710272009.31430.rusty@rustcorp.com.au> <20071029030352.GC19691@waste.org>
In-Reply-To: <20071029030352.GC19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291638.54899.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 14:03:52 Matt Mackall wrote:
> And on SLOB, which doesn't have those bloaty power-of-2 constraints?
> Looks like ~500 reallocs, including 250000 bytes of memcpy. Ouch!

In other words, the system was compiled for size optimization and that's
what happened.

The question is: how bad is it?  Let's look at those numbers for SLOB (32-bit
x86).  First we find that it does 1000 reallocs to build the string, so it
really is worst case: we do a memcpy every time, so that's 500k of copying.

Yet SLOB comes in at 423 ns per call.  Remember that the other allocators got
around 1491 ns?  I went back and turned slub debugging off, and that number
hardly changed.

Deeper probing didn't show any convincing cause for the speedup.  Perhaps
slob is recycling memory for this case far better than the others,
outweighing the overhead.

Here's the patch I'm using, analysis welcome.
Rusty.
===
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index cb4c670..a7b4033 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -239,6 +239,121 @@ int run_guest(struct lguest *lg, unsigned long __user *user)
 	return -ENOENT;
 }
 
+#include <linux/slab.h>
+#include <linux/stringbuf.h>
+#include <linux/ktime.h>
+
+static inline void *realloc_no_copy(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+	size_t ks = 0;
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return ZERO_SIZE_PTR;
+	}
+
+	if (p)
+		ks = ksize(p);
+
+	if (ks >= new_size)
+		return (void *)p;
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret)
+		kfree(p);
+	return ret;
+}
+
+static void test_stringbuf(void)
+{
+	unsigned int i, j;
+	ktime_t start, end;
+	unsigned int sb_alloc_count = 0;
+	char c[5];
+
+	start = ktime_get();
+	for (i = 0; i < 1000; i++) {
+		struct stringbuf *oldsb = NULL, *sb = NULL;
+
+		for (j = 0; j < 1000; j++) {
+			unsigned int k;
+			sb_printf_append(&sb, GFP_KERNEL, "a");
+			sb_alloc_count += (sb != oldsb);
+			oldsb = sb;
+#if 0
+			if (sb->buf[j+1] != '\0') {
+				printk("Final sb->buf[%i] = %i\n",
+				       j+1, sb->buf[j+1]);
+				break;
+			}
+			for (k = 0; k < j; k++) {
+				if (sb->buf[k] != 'a') {
+					printk("sb->buf[%i] = %i\n",
+					       k, sb->buf[k]);
+					break;
+				}
+			}
+#endif
+		}
+		sb_free(sb);
+	}
+	end = ktime_get();
+
+	printk("1000 x 1000 sb_printf_append == %lli ns %u allocs\n",
+	       ktime_to_ns(ktime_sub(end, start)), sb_alloc_count);
+
+	start = ktime_get();
+	for (i = 0; i < 1000; i++) {
+		struct stringbuf *oldsb = NULL, *sb = NULL;
+
+		for (j = 0; j < 1000; j++) {
+			sprintf(c, "a", &sb);
+			sb_alloc_count += (sb != oldsb);
+			oldsb = sb;
+		}
+		sb_free(sb);
+	}
+	end = ktime_get();
+
+	printk("1000 x 1000 sprintf == %lli ns\n",
+	       ktime_to_ns(ktime_sub(end, start)));
+
+	sb_alloc_count = 0;
+	start = ktime_get();
+	for (i = 0; i < 1000; i++) {
+		struct stringbuf *oldsb = NULL, *sb = NULL;
+
+		for (j = 0; j < 1000; j++) {
+			sb = realloc_no_copy(oldsb, j + 1, GFP_KERNEL);
+			sb_alloc_count += (sb != oldsb);
+			oldsb = sb;
+		}
+		kfree(sb);
+	}
+	end = ktime_get();
+
+	printk("1000 x 1000 realloc_no_copy == %lli ns %u allocs\n",
+	       ktime_to_ns(ktime_sub(end, start)), sb_alloc_count);
+
+	sb_alloc_count = 0;
+	start = ktime_get();
+	for (i = 0; i < 1000; i++) {
+		struct stringbuf *oldsb = NULL, *sb = NULL;
+
+		for (j = 0; j < 1000; j++) {
+			sb = krealloc(oldsb, j + 1, GFP_KERNEL);
+			sb_alloc_count += (sb != oldsb);
+			oldsb = sb;
+		}
+		kfree(sb);
+	}
+	end = ktime_get();
+
+	printk("1000 x 1000 krealloc == %lli ns %u allocs\n",
+	       ktime_to_ns(ktime_sub(end, start)), sb_alloc_count);
+}
+
 /*H:000
  * Welcome to the Host!
  *
@@ -251,6 +366,8 @@ static int __init init(void)
 {
 	int err;
 
+	test_stringbuf();
+
 	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
 	if (paravirt_enabled()) {
 		printk("lguest is afraid of %s\n", pv_info.name);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
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
diff --git a/kernel/module.c b/kernel/module.c
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
index 0000000..e3c51be
--- /dev/null
+++ b/lib/stringbuf.c
@@ -0,0 +1,48 @@
+#include <stdarg.h>
+#include <linux/stringbuf.h>
+#include <linux/module.h>
+
+char enomem_string[] __attribute__((aligned(__alignof__(struct stringbuf))))
+	= "stringbuf: out of memory";
+EXPORT_SYMBOL(enomem_string);
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
+	if (oldsb) {
+		len = strlen(oldsb->buf);
+		*sb = krealloc(oldsb, fmtlen + len + 1, gfp);
+	} else {
+		len = 0;
+		*sb = kmalloc(fmtlen + 1, gfp);
+	}
+
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
diff --git a/mm/slub.c b/mm/slub.c
index aac1dd3..0760285 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3075,6 +3075,7 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, void *caller)
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
+EXPORT_SYMBOL(__kmalloc_track_caller);
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 					int node, void *caller)
