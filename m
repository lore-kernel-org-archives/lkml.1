Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYBMJL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYBMJL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYBMJKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:10:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24265 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYBMJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YO1qARp6FDQiwJEUtwghmfYIiGXiFA6uxJ4coNTrtKX36grCcXn5KVhmLlBgPsEhWhaF2vJkCPyB6uNhAiY9EB+NI7R2gI1QVvffmPQCNFmKxbZNIKmD43t8Y96ExYA7sl0IZP4bphFToA2mY0yIQBZa00PHxhvJDre/OQxrHD8=
From: Tejun Heo <htejun@gmail.com>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/5] printk: implement merging printk
Date: Wed, 13 Feb 2008 18:09:31 +0900
Message-Id: <12028937743431-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12028937731333-git-send-email-htejun@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There often are times printk messages need to be assembled piece by
piece and it's usually done using one of the following methods.

* Calling printk() on partial message segments.  This used to be quite
  common but has a problem - the message can break up if someone else
  prints something in the middle.

* Prepping a temp buffer and build message piece-by-piece using
  snprintf().  This is the most generic solution but corner case
  handling can be tedious and on overflow messages can be lost and
  such overflows would go unnoticed if overflow detection isn't
  properly done.

* Collect all the partial data and perform printk() once with all the
  parameters.  This is often combined with the second.  This usually
  works but printing messages can become non-trivial programming
  problem and can get quite tedious if the message format varies
  depending on data.

None of the above is quite satisfactory.  This patch implement merging
printk - mprintk to deal with this problem.  It's basically a helper
to construct message piece-by-piece into the specified buffer.  The
caller still has to care about buffer size and how the buffer is
allocated but mprintk makes it easier.

* DEFINE_MPRINTK() macro makes it easy to define a mprintk instance
  with on-stack buffer.  Malloc'd buffer can also be used.

* Message is never lost.  On buffer overflow, all queued and to be
  queued messages are printed followed by warning message and stack
  dump.  The warning message and stack dump are printed only once per
  mprintk instance.  The caller also doesn't have to handle buffer
  malloc failure.  If buffer is initialized to NULL, mprintk simply
  bypasses the messages to printk().

* Has good support for multiline messages.  A mprintk instance can
  have header associated with it and the header can have log level.
  Header log level is used if a partial message doesn't specify log
  level explicitly.  When log level is specified explicitly in a
  partial message, the log level is applied to the partial message
  only.

A simple example.

  DEFINE_MPRINTK(mp, 2 * 80);

  mprintk_set_header(&mp, KERN_DEBUG "ata%u.%2u: ", 1, 0);
  mprintk_push(&mp, "ATA %d", 7);
  mprintk_push(&mp, ", %u sectors\n", 1024);
  mprintk(&mp, "everything seems dandy\n");

Which will be printed like the following as a single message.

<7>ata1.00: ATA 7, 1024 sectors
<7>ata1.00  everything seems dandy

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/kernel.h |   73 ++++++++++++
 kernel/printk.c        |  300 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 370 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d885208..a9cbda8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -177,6 +177,27 @@ struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
 #ifdef CONFIG_PRINTK
+struct mprintk {
+	char		*buf;
+	char		*body;
+	char		*cur;
+	char		*end;
+	unsigned int	flags;
+};
+
+#define MPRINTK_INITIALIZER(_buf, _size)				\
+	{								\
+		.buf		= _buf,					\
+		.body		= _buf,					\
+		.cur		= _buf,					\
+		.end		= _buf + _size,				\
+		.flags		= 0					\
+	}
+
+#define DEFINE_MPRINTK(name, size)					\
+	char __##name##_buf[size];					\
+	struct mprintk name = MPRINTK_INITIALIZER(__##name##_buf, size)
+
 asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 asmlinkage int printk_header(const char *header, const char * fmt, ...)
@@ -185,6 +206,26 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
+
+static inline void mprintk_init(struct mprintk *mp, char *buf, size_t size)
+{
+	*mp = (struct mprintk)MPRINTK_INITIALIZER(buf, size);
+}
+extern void mprintk_init_alloc(struct mprintk *mp, gfp_t gfp);
+extern void mprintk_free(struct mprintk *mp);
+extern int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int vmprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int mprintk(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int mprintk_flush(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
 extern int log_buf_get_len(void);
 extern int log_buf_read(int idx);
 extern int log_buf_copy(char *dest, int idx, int len);
@@ -196,6 +237,11 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 #else
+struct mprintk { };
+#define MPRINTK_INITIALIZER(_buf, _size)	{ }
+#define DEFINE_MPRINTK(name, size)		\
+	struct mprintk name = __MPRINTK_INITIALIZER(NULL, size)
+
 static inline int vprintk_header(const char *header, const char *s, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 static inline int vprintk_header(const char *header, const char *s, va_list args)
@@ -210,6 +256,33 @@ static inline int vprintk(const char *s, va_list args) { return 0; }
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
+static inline void mprintk_init(struct mprintk *mp, char *buf, size_t size) { }
+static inline void mprintk_init_alloc(struct mprintk *mp, gfp_t gfp) { }
+static inline void mprintk_free(struct mprintk *mp) { }
+static inline int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int vmprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int mprintk(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
+static inline int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
+static inline int mprintk_flush(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk_flush(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
 static inline int log_buf_get_len(void) { return 0; }
 static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
diff --git a/kernel/printk.c b/kernel/printk.c
index 2283a75..0b552b9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/ctype.h>
 
 #include <asm/uaccess.h>
 
@@ -52,6 +53,12 @@ void __attribute__((weak)) early_printk(const char *fmt, ...)
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
+/* mprintk flags */
+#define MPRINTK_BUF_ALLOC		(1 << 0)
+#define MPRINTK_HAS_HEADER_LOGLV	(1 << 1)
+#define MPRINTK_OVERFLOWED		(1 << 2)
+#define MPRINTK_LOGLV_OVERRIDDEN	(1 << 3)
+
 DECLARE_WAIT_QUEUE_HEAD(log_wait);
 
 int console_printk[4] = {
@@ -731,15 +738,18 @@ asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
 
 	/* Parse header log level */
 	if (header) {
-		size_t len = strlen(header);
+		const char *p;
 
 		if (is_loglevel(header)) {
 			last_lv = header[1] - '0';
 			header += 3;
 		}
 
-		if (len >= 2 && !strcmp(header + len - 2, ": "))
-			header_colon = header + len - 2;
+		p = header + strlen(header) - 1;
+		while (p > header && isspace(*p))
+			p--;
+		if (p > header && *p == ':')
+			header_colon = p;
 	}
 
 	/* Emit the output into the temporary buffer */
@@ -857,6 +867,290 @@ out_restore_irqs:
 }
 EXPORT_SYMBOL(vprintk_header);
 
+static bool mp_no_buffer(struct mprintk *mp)
+{
+	return unlikely(!mp->buf || mp->buf == mp->end);
+}
+
+static char *mp_header(struct mprintk *mp)
+{
+	if (mp->body != mp->buf)
+		return mp->buf;
+	return NULL;
+}
+
+static void mp_flush(struct mprintk *mp)
+{
+	printk_header(mp_header(mp), "%s", mp->body);
+	mp->cur = mp->body;
+	mp->cur[0] = '\0';
+	mp->flags &= ~MPRINTK_LOGLV_OVERRIDDEN;
+}
+
+/**
+ * mprintk_init_alloc - allocate buffer and initialize mprintk instance
+ * @mp: mprintk instance to initialize
+ * @gfp: allocation flags
+ *
+ * This function initializes @mp such that buffer is automatically
+ * allocated with @gfp flags.
+ */
+void mprintk_init_alloc(struct mprintk *mp, gfp_t gfp)
+{
+	/*
+	 * This can be implemented as dynamically growing buffer but
+	 * printk truncates messages at PRINTK_BUF_LEN.  Allocating
+	 * PRINTK_BUF_LEN bytes upfront is good enough for now.
+	 */
+	mprintk_init(mp, kmalloc(PRINTK_BUF_LEN, gfp), PRINTK_BUF_LEN);
+	mp->flags |= MPRINTK_BUF_ALLOC;
+}
+EXPORT_SYMBOL(mprintk_init_alloc);
+
+/**
+ * mprintk_free - free mprintk buffer
+ * @mp: mprintk instance to free buffer for
+ *
+ * If @mp was initialized using mprintk_init_alloc(), free mp->buf;
+ * otherwise, noop.
+ */
+void mprintk_free(struct mprintk *mp)
+{
+	if (mp->flags & MPRINTK_BUF_ALLOC) {
+		kfree(mp->buf);
+		mp->buf = NULL;
+	}
+}
+EXPORT_SYMBOL(mprintk_free);
+
+/**
+ * vmprintk - format and add message chunk to mprintk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk() except that it takes
+ * va_list @args intead of argument list.
+ */
+int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+{
+	char *start = mp->cur;
+	size_t size = mp->end - start;
+	int new_line = mp->cur == mp->body || mp->cur[-1] == '\n';
+	int printed = 0;
+	int ret;
+
+	if (mp_no_buffer(mp))
+		return vprintk(fmt, args);
+
+	/*
+	 * Prepend header log level if the previous chunk has
+	 * overridden the log level (implies header log level exists)
+	 * && the current chunk starts a new line and doesn't have
+	 * explicit log level.
+	 */
+	if ((mp->flags & MPRINTK_LOGLV_OVERRIDDEN) && new_line) {
+		char tbuf[4];
+		va_list args_copy;
+
+		va_copy(args_copy, args);
+		vsnprintf(tbuf, sizeof(tbuf), fmt, args_copy);
+		va_end(args_copy);
+
+		if (!is_loglevel(tbuf)) {
+			ret = snprintf(start, size, "<%c>", mp_header(mp)[1]);
+			printed += ret;
+			if (ret >= size)
+				goto overflow;
+			start += ret;
+			size -= ret;
+			mp->flags &= ~MPRINTK_LOGLV_OVERRIDDEN;
+		}
+	}
+
+	ret = vsnprintf(start, size, fmt, args);
+	printed += ret;
+	if (ret >= size)
+		goto overflow;
+
+	if ((mp->flags & MPRINTK_HAS_HEADER_LOGLV) &&
+	    new_line && is_loglevel(start))
+		mp->flags |= MPRINTK_LOGLV_OVERRIDDEN;
+
+	mp->cur += printed;
+
+	return printed;
+
+ overflow:
+	mp->cur[0] = '\0';
+	mp_flush(mp);
+	printed = vprintk_header(mp_header(mp), fmt, args);
+
+	if (!(mp->flags & MPRINTK_OVERFLOWED)) {
+		printk("\n" KERN_ERR
+		       "mprintk buffer overflow, please file a bug report\n");
+		dump_stack();
+		mp->flags |= MPRINTK_OVERFLOWED;
+	}
+
+	return printed;
+}
+EXPORT_SYMBOL(vmprintk);
+
+/**
+ * vmprintk_set_header - format and set header to mprintk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk_set_header() except that it
+ * takes va_list @args intead of argument list.
+ */
+int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+{
+	const char *reason;
+	int ret;
+
+	if (mp_no_buffer(mp))
+		return vprintk(fmt, args);
+
+	if (mp_header(mp) || mp->cur != mp->body) {
+		reason = "dirty mprintk instance";
+		goto err;
+	}
+	if (mp->body + 1 == mp->end) {
+		reason = "buffer too short (1 byte)";
+		goto err;
+	}
+
+	/* reserve one byte for separator */
+	mp->end--;
+	ret = vmprintk(mp, fmt, args);
+	mp->end++;
+
+	if (mp->cur != mp->body) {
+		mp->body = ++mp->cur;
+		if (is_loglevel(mp_header(mp)))
+			mp->flags |= MPRINTK_HAS_HEADER_LOGLV;
+	}
+
+	return ret;
+
+ err:
+	printk(KERN_WARNING "vmprintk_set_header() failed: %s\n", reason);
+	dump_stack();
+	return 0;
+}
+EXPORT_SYMBOL(vmprintk_set_header);
+
+/**
+ * vmprintk_flush - format and add message chunk to mprintk instance and flush
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk_flush() except that it takes
+ * va_list @args intead of argument list.
+ */
+int vmprintk_flush(struct mprintk *mp, const char *fmt, va_list args)
+{
+	int ret = 0;
+
+	if (mp_no_buffer(mp))
+		return vprintk(fmt, args);
+
+	if (fmt)
+		ret = vmprintk(mp, fmt, args);
+	mp_flush(mp);
+
+	return ret;
+}
+EXPORT_SYMBOL(vmprintk_flush);
+
+/**
+ * mprintk - format and add message chunk to mprintk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ *
+ * This function formats @fmt and the following list of arguments and
+ * append the result to @mp.  If @mp has header with log level and
+ * @fmt is multiline, this function takes care of restoring header log
+ * level if the previous message contained log level overrided and
+ * this message doesn't.
+ *
+ * If the buffer pointed to by @mp is too short to contain the added
+ * message, @mp is flushed, the message to add is printed directly and
+ * warning message with stack dump is printed.  If buffer is NULL, the
+ * formatted message is printed directly.  Message is never lost.  The
+ * warning message and the stack dump are printed only once for each
+ * @mp instance.
+ *
+ * For example, if @mp header is set to "<7>ata1.00: " and the first
+ * message is "line0\n", second "<4>line1\nline2\n" and the third
+ * "line3\n", the following is the end result.
+ *
+ * <7>ata1.00: line0
+ * <4>ata1.00: line1	(different log level, header is printed again)
+ * <4>         line2
+ * <7>         line3
+ */
+int mprintk(struct mprintk *mp, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vmprintk(mp, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(mprintk);
+
+/**
+ * mprintk_set_header - set header of merging printk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ *
+ * Set header of @mp to the string formatted according to @fmt and
+ * arguments.
+ */
+int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vmprintk_set_header(mp, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(mprintk_set_header);
+
+/**
+ * mprintk_flush - format and add a message to mprintk instance and flush it
+ * @mp: mprintk instance to use
+ * @fmt: format string (can be NULL)
+ *
+ * Add message formatted according to @fmt and arguments to @mp and
+ * flush it.  If @fmt is NULL, only the latter operation occurs.  NULL
+ * @fmt is allowed to avoid zero length formatting string warning from
+ * compiler.
+ */
+int mprintk_flush(struct mprintk *mp, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vmprintk_flush(mp, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(mprintk_flush);
+
 #else
 
 asmlinkage long sys_syslog(int type, char __user *buf, int len)
-- 
1.5.2.4

