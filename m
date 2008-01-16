Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYAPBBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYAPBBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYAPBA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:00:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:5113 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbYAPBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rHN7pLgzL24LqXldvd8pSgI9eTWFSrnCNIPGaw8EY2PV7h1nDF6zkyxQzBywp0nrWf/Xko9rCCnkmZcrZyN7t9aTnq0Ka4/gaa0dwd+qXuEGo935Y1TRo/XXcdw0XWu650Noj/Q2YZW+gRJMBz83cgGCjC33QJHWEN/HC73hBuA=
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/4] printk: implement merging printk
Date: Wed, 16 Jan 2008 10:00:09 +0900
Message-Id: <12004452113770-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
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
<7>         everything seems dandy

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/kernel.h |   71 ++++++++++++++++
 kernel/printk.c        |  215 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 286 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ade3ac9..f92a4a1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -175,6 +175,29 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 extern void dump_thread(struct pt_regs *regs, struct user *dump);
 
 #ifdef CONFIG_PRINTK
+struct mprintk {
+	char *		header;
+	char *		body;
+	char *		cur;
+	char *		prv;
+	char *		end;
+	int		overflowed;
+};
+
+#define MPRINTK_INITIALIZER(_buf, _size)				\
+	{								\
+		.header		= NULL,					\
+		.body		= _buf,					\
+		.cur		= _buf,					\
+		.prv		= NULL,					\
+		.end		= _buf + _size,				\
+		.overflowed	= 0,					\
+	}
+
+#define DEFINE_MPRINTK(name, size)					\
+	char __##name##_buf[size];					\
+	struct mprintk name = MPRINTK_INITIALIZER(__##name##_buf, size)
+
 asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 asmlinkage int printk_header(const char *header, const char * fmt, ...)
@@ -183,10 +206,33 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
+
+static inline void mprintk_init(struct mprintk *mp, char *buf, size_t size)
+{
+	*mp = (struct mprintk)MPRINTK_INITIALIZER(buf, size);
+}
+extern int vmprintk_push(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int mprintk_push(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int mprintk(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
 extern int log_buf_get_len(void);
 extern int log_buf_read(int idx);
 extern int log_buf_copy(char *dest, int idx, int len);
 #else
+struct mprintk { };
+#define MPRINTK_INITIALIZER(_buf, _size)	{ }
+#define DEFINE_MPRINTK(name, size)		\
+	struct mprintk name = __MPRINTK_INITIALIZER(NULL, size)
+
 static inline int vprintk_header(const char *header, const char *s, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 static inline int vprintk_header(const char *header, const char *s, va_list args)
@@ -201,6 +247,31 @@ static inline int vprintk(const char *s, va_list args) { return 0; }
 static inline int printk(const char *s, ...)
 	__attribute__ ((format (printf, 1, 2)));
 static inline int __cold printk(const char *s, ...) { return 0; }
+static inline void mprintk_init(struct mprintk *mp, char *buf, size_t size) { }
+static inline int vmprintk_push(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk_push(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+static inline int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+{ return 0; }
+static inline int mprintk_push(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk_push(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
+static inline int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk_set_header(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
+static inline int mprintk(struct mprintk *mp, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+static inline int mprintk(struct mprintk *mp, const char *fmt, ...)
+{ return 0; }
 static inline int log_buf_get_len(void) { return 0; }
 static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
diff --git a/kernel/printk.c b/kernel/printk.c
index 1cde1d6..873ecd8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -832,6 +832,221 @@ asmlinkage int vprintk_header(const char *header, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL(vprintk_header);
 
+static void mprintk_flush(struct mprintk *mp)
+{
+	printk_header(mp->header, "%s", mp->body);
+	mp->prv = NULL;
+	mp->cur = mp->body;
+}
+
+/**
+ * vmprintk_push - format and push message to merging printk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk_push() except that it takes
+ * va_list @args intead of argument list.
+ */
+int vmprintk_push(struct mprintk *mp, const char *fmt, va_list args)
+{
+	char *start = mp->cur;
+	size_t size = mp->end - start;
+	int printed = 0;
+	int ret;
+
+	if (!start)
+		return vprintk(fmt, args);
+
+	/*
+	 * Push header log level if the header has log level && the
+	 * previous push overrided log level && this push doesn't
+	 * override log level.
+	 */
+	if (mp->header && is_loglevel(mp->header) &&
+	    mp->prv && (mp->prv == mp->body || mp->prv[-1] == '\n') &&
+	    is_loglevel(mp->prv) && mp->cur[-1] == '\n') {
+		char tbuf[4];
+
+		vsnprintf(tbuf, sizeof(tbuf), fmt, args);
+
+		if (!is_loglevel(tbuf)) {
+			ret = snprintf(start, size, "<%c>", mp->header[1]);
+			printed += ret;
+			if (ret >= size)
+				goto overflow;
+			start += ret;
+			size -= ret;
+		}
+	}
+
+	ret = vsnprintf(start, size, fmt, args);
+	printed += ret;
+	if (ret >= size)
+		goto overflow;
+
+	mp->prv = mp->cur;
+	mp->cur += printed;
+
+	return printed;
+
+ overflow:
+	mp->cur[0] = '\0';
+	mprintk_flush(mp);
+	vprintk_header(mp->header, fmt, args);
+
+	if (!mp->overflowed) {
+		printk("\n" KERN_ERR
+		       "mprintk buffer overflow, please file a bug report\n");
+		dump_stack();
+		mp->overflowed = 1;
+	}
+
+	return printed;
+}
+EXPORT_SYMBOL(vmprintk_push);
+
+/**
+ * vmprintk_set_header - format and set header to merging printk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk_set_header() except that it
+ * takes va_list @args intead of argument list.
+ */
+int vmprintk_set_header(struct mprintk *mp, const char *fmt, va_list args)
+{
+	int ret;
+
+	if (!mp->cur)
+		return vprintk(fmt, args);
+
+	if (mp->header || mp->prv) {
+		printk(KERN_WARNING "vmprintk_set_header() called on "
+		       "dirty mprintk instance\n");
+		WARN_ON(1);
+		return 0;
+	}
+
+	ret = vmprintk_push(mp, fmt, args);
+	if (mp->prv) {
+		mp->header = mp->body;
+		mp->body = ++mp->cur;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(vmprintk_set_header);
+
+/**
+ * vmprintk - format and push message to merging printk instance and flush it
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ * @args: va_list to format @fmt
+ *
+ * This function is identical to mprintk() except that it takes
+ * va_list @args intead of argument list.
+ */
+int vmprintk(struct mprintk *mp, const char *fmt, va_list args)
+{
+	int ret = 0;
+
+	if (!mp->cur)
+		return vprintk(fmt, args);
+
+	if (fmt)
+		ret = vmprintk_push(mp, fmt, args);
+	mprintk_flush(mp);
+
+	return ret;
+}
+EXPORT_SYMBOL(vmprintk);
+
+/**
+ * mprintk_push - format and push message to merging printk instance
+ * @mp: mprintk instance to use
+ * @fmt: format string
+ *
+ * This function formats @fmt and the following list of arguments and
+ * append the result to @mp.  If @mp has header with log level and
+ * @fmt is multiline, this function takes care of restoring header
+ * log level if the previous push contained log level overrided and
+ * this push doesn't.
+ *
+ * If the buffer pointed to by @mp is too short to contain the pushed
+ * message, @mp is flushed, the message to push is printed directly
+ * and warning message with stack dump is printed.  If buffer is NULL,
+ * the formatted message is printed directly.  Message is never lost.
+ * The warning message and the stack dump are printed only once for
+ * each @mp instance.
+ *
+ * For example, if @mp header is set to "<7>ata1.00: " and the first
+ * push is "line0\n", second "<4>line1\nline2\n" and the third
+ * "line3\n", the following is the end result.
+ *
+ * <7>ata1.00: line0
+ * <4>ata1.00: line1	(different log level, header is printed again)
+ * <4>         line2
+ * <7>         line3
+ */
+int mprintk_push(struct mprintk *mp, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vmprintk_push(mp, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(mprintk_push);
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
+ * mprintk - push a message to merging printk instance and flush it
+ * @mp: mprintk instance to use
+ * @fmt: format string (can be NULL)
+ *
+ * Push message formatted according to @fmt and arguments to @mp and
+ * flush it.  If @fmt is NULL, only the latter operation occurs.  NULL
+ * @fmt is allowed to avoid zero length formatting string warning from
+ * compiler.
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
 #else
 
 asmlinkage long sys_syslog(int type, char __user *buf, int len)
-- 
1.5.2.4

