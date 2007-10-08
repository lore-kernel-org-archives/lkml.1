Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbXJHTpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbXJHTpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXJHTpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:45:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:35330 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXJHTpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ugULDagSA5Lsj9dSR4CfdyBUGlCe+y9GryyLmDwwzGk+9lwqxbu5zUntNmH2JOFev9qnXU0OouD9dM0IcrZLJ1e+vB/6EpyWvk7/pVj6TuVVQaSgdfFRYGQlE5817EXTUIZ18xCB4+xV930fUtDVjVM6TLxULYBQlPRrHBTv9O8=
Subject: [RFC][PATCH] Escaping the arguments of kernel messages for sane
	user-space localisation
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Oct 2007 21:45:30 +0200
Message-Id: <1191872730.27240.29.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I send here the simplified patch to emit log messages with markers for
the message arguments, as per your suggestion. Do you still think this
is over-kill?

The rigour exists in order to preserve the generality of snprintf(),
instead of changing it to include printk-specific code, which in my
opinion does not belong there.

If these changes to make snprintf() more customizable will never be used
in any other place in the kernel, then they are clearly also over-kill.

These functions make it quite easy to make snprintf() automatically
escape certain characters in string arguments, for example. I think they
are also well suited to printing to variable-sized buffers, though the
last time I looked, there was no krealloc in the kernel, which makes it
again useless. Perhaps there are other uses, though?

This patch in particular makes printk() put a \x1f (ASCII "unit
separator") before and after each argument. It seems that user-space
terminal emulators handle this (by not printing anything, so in effect
there is no visual change), but the VGA console will print funny symbols
instead. I've tried to change this in drivers/char/vt.c by masking out
this character from the ones to display, but to no avail. I am sure it
is possible, but I am not able to do it.

Please let me know what you think.

Kind regards,
Vegard



 include/linux/xprintf.h |   28 +++++
 kernel/printk.c         |   89 ++++++++++++++-
 lib/vsprintf.c          |  296 ++++++++++++++++++++++++++++----------------
 3 files changed, 292 insertions(+), 121 deletions(-)

diff --git a/include/linux/xprintf.h b/include/linux/xprintf.h
new file mode 100644
index 0000000..76efc43
--- /dev/null
+++ b/include/linux/xprintf.h
@@ -0,0 +1,28 @@
+#ifndef LINUX_XPRINTF_H
+#define LINUX_XPRINTF_H
+
+#include <stdarg.h>
+#include <linux/kernel.h>
+
+struct xprintf_ops {
+	void (*begin)(void *data);
+	void (*end)(void *data);
+	void (*put_format)(void *data, char c);
+
+	void (*begin_param)(void *data);
+	void (*end_param)(void *data);
+	void (*put_param)(void *data, char c);
+
+	long (*size)(void *data);
+
+	void (*unknown_conversion)(void *data, char c);
+};
+
+extern void xprintf(void *data, const struct xprintf_ops *ops,
+	const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern void vxprintf(void *data, const struct xprintf_ops *ops,
+	const char *fmt, va_list args)
+	__attribute__ ((format (printf, 3, 0)));
+
+#endif
diff --git a/kernel/printk.c b/kernel/printk.c
index 8451dfc..1db2e6d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -31,6 +31,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
+#include <linux/xprintf.h>
 
 #include <asm/uaccess.h>
 
@@ -481,6 +482,85 @@ static int have_callable_console(void)
 	return 0;
 }
 
+struct printk_data {
+	char *buf;
+	const size_t size;
+
+	char *str;
+	char *end;
+};
+
+static void printk_put_char(struct printk_data *d, char c)
+{
+	if (d->str < d->end)
+		*d->str = c;
+	d->str++;
+}
+
+static void printk_begin(void *data)
+{
+	struct printk_data *d = data;
+	d->str = d->buf;
+	d->end = d->buf + d->size;
+}
+
+static void printk_end(void *data)
+{
+	struct printk_data *d = data;
+
+	if (d->size > 0) {
+		if (d->str < d->end)
+			d->str[0] = '\0';
+		else
+			d->end[-1] = '\0';
+	}
+}
+
+static void printk_put_format(void *data, char c)
+{
+	printk_put_char(data, c);
+}
+
+static void printk_begin_param(void *data)
+{
+	printk_put_char(data, '\x1f');
+}
+
+static void printk_end_param(void *data)
+{
+	printk_put_char(data, '\x1f');
+}
+
+static void printk_put_param(void *data, char c)
+{
+	printk_put_char(data, c);
+}
+
+static long printk_size(void *data)
+{
+	struct printk_data *d = data;
+	return d->str - d->buf;
+}
+
+static void printk_unknown_conversion(void *data, char c)
+{
+	printk_put_char(data, '%');
+	if (c)
+		printk_put_char(data, c);
+}
+
+static const struct xprintf_ops printk_ops = {
+	.begin			= &printk_begin,
+	.end			= &printk_end,
+	.put_format		= &printk_put_format,
+	.begin_param		= &printk_begin_param,
+	.end_param		= &printk_end_param,
+	.put_param		= &printk_put_param,
+	.size			= &printk_size,
+	.unknown_conversion	= &printk_unknown_conversion,
+};
+
+
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -526,6 +606,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	char *p;
 	static char printk_buf[1024];
 	static int log_level_unknown = 1;
+	static struct printk_data data = {
+		.buf = printk_buf,
+		.size = sizeof(printk_buf),
+	};
 
 	preempt_disable();
 	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
@@ -540,7 +624,10 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printk_cpu = smp_processor_id();
 
 	/* Emit the output into the temporary buffer */
-	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	vxprintf(&data, &printk_ops, fmt, args);
+	printed_len = data.str - printk_buf;
+	if (printed_len >= data.size)
+		printed_len = data.size - 1;
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7b481ce..60fb5e2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -22,6 +22,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
+#include <linux/xprintf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -240,7 +241,8 @@ static noinline char* put_dec(char *buf, unsigned long long num)
 #define SPECIAL	32		/* 0x */
 #define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
 
-static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
+static void xprintf_number(void *data, const struct xprintf_ops *ops,
+	unsigned long long num, int base, int size, int precision, int type)
 {
 	char sign,tmp[66];
 	const char *digits;
@@ -254,7 +256,7 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	if (type & LEFT)
 		type &= ~ZEROPAD;
 	if (base < 2 || base > 36)
-		return NULL;
+		return;
 	sign = 0;
 	if (type & SIGN) {
 		if ((signed long long) num < 0) {
@@ -302,59 +304,116 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	/* leading space padding */
 	size -= precision;
 	if (!(type & (ZEROPAD+LEFT))) {
-		while(--size >= 0) {
-			if (buf < end)
-				*buf = ' ';
-			++buf;
-		}
+		while (--size >= 0)
+			ops->put_param(data, ' ');
 	}
 	/* sign */
-	if (sign) {
-		if (buf < end)
-			*buf = sign;
-		++buf;
-	}
+	if (sign)
+		ops->put_param(data, sign);
 	/* "0x" / "0" prefix */
 	if (need_pfx) {
-		if (buf < end)
-			*buf = '0';
-		++buf;
+		ops->put_param(data, '0');
 		if (base == 16) {
-			if (buf < end)
-				*buf = digits[16]; /* for arbitrary base: digits[33]; */
-			++buf;
+			ops->put_param(data, digits[16]);
+			/* for arbitrary base: digits[33]; */
 		}
 	}
 	/* zero or space padding */
 	if (!(type & LEFT)) {
 		char c = (type & ZEROPAD) ? '0' : ' ';
-		while (--size >= 0) {
-			if (buf < end)
-				*buf = c;
-			++buf;
-		}
+		while (--size >= 0)
+			ops->put_param(data, c);
 	}
 	/* hmm even more zero padding? */
-	while (i <= --precision) {
-		if (buf < end)
-			*buf = '0';
-		++buf;
-	}
+	while (i <= --precision)
+		ops->put_param(data, '0');
 	/* actual digits of result */
-	while (--i >= 0) {
-		if (buf < end)
-			*buf = tmp[i];
-		++buf;
-	}
+	while (--i >= 0)
+		ops->put_param(data, tmp[i]);
 	/* trailing space padding */
-	while (--size >= 0) {
-		if (buf < end)
-			*buf = ' ';
-		++buf;
+	while (--size >= 0)
+		ops->put_param(data, ' ');
+}
+
+struct vsnprintf_data {
+	char *buf;
+	const size_t size;
+
+	char *str;
+	char *end;
+};
+
+static void vsnprintf_put_char(struct vsnprintf_data *d, char c)
+{
+	if (d->str < d->end)
+		*d->str = c;
+	d->str++;
+}
+
+static void vsnprintf_begin(void *data)
+{
+	struct vsnprintf_data *d = data;
+	d->str = d->buf;
+	d->end = d->buf + d->size;
+}
+
+static void vsnprintf_end(void *data)
+{
+	struct vsnprintf_data *d = data;
+
+	if (d->size > 0) {
+		if (d->str < d->end)
+			d->str[0] = '\0';
+		else
+			d->end[-1] = '\0';
+
+		/* The trailing null byte doesn't count towards the total,
+		 * so we don't increment the buffer pointer. */
 	}
-	return buf;
 }
 
+static void vsnprintf_put_format(void *data, char c)
+{
+	vsnprintf_put_char(data, c);
+}
+
+static void vsnprintf_begin_param(void *data)
+{
+}
+
+static void vsnprintf_end_param(void *data)
+{
+}
+
+static void vsnprintf_put_param(void *data, char c)
+{
+	vsnprintf_put_char(data, c);
+}
+
+static long vsnprintf_size(void *data)
+{
+	struct vsnprintf_data *d = data;
+	return d->str - d->buf;
+}
+
+static void vsnprintf_unknown_conversion(void *data, char c)
+{
+	vsnprintf_put_char(data, '%');
+	if (c)
+		vsnprintf_put_char(data, c);
+}
+
+static const struct xprintf_ops vsnprintf_ops = {
+	.begin			= &vsnprintf_begin,
+	.end			= &vsnprintf_end,
+	.put_format		= &vsnprintf_put_format,
+	.begin_param		= &vsnprintf_begin_param,
+	.end_param		= &vsnprintf_end_param,
+	.put_param		= &vsnprintf_put_param,
+	.size			= &vsnprintf_size,
+	.unknown_conversion	= &vsnprintf_unknown_conversion,
+};
+
 /**
  * vsnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -375,10 +434,37 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
  */
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
+	struct vsnprintf_data data = {
+		.size = size,
+		.buf = buf,
+	};
+
+	/* Reject out-of-range values early.  Large positive sizes are
+	   used for unknown buffer sizes. */
+	if (unlikely((int) size < 0)) {
+		/* There can be only one.. */
+		static char warn = 1;
+		WARN_ON(warn);
+		warn = 0;
+		return 0;
+	}
+
+	vxprintf(&data, &vsnprintf_ops, fmt, args);
+	return data.str - buf;
+}
+
+EXPORT_SYMBOL(vsnprintf);
+
+/* This is similar to printf(), except we output not to a string, but call
+ * the callback functions provided through xprintf_ops. This gives much
+ * flexibility in what and where to output the result of the formatting. */
+void vxprintf(void *data, const struct xprintf_ops *ops,
+	const char *fmt, va_list args)
+{
 	int len;
 	unsigned long long num;
 	int i, base;
-	char *str, *end, c;
+	char c;
 	const char *s;
 
 	int flags;		/* flags to number() */
@@ -391,33 +477,16 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				/* 'z' changed to 'Z' --davidm 1/25/99 */
 				/* 't' added for ptrdiff_t */
 
-	/* Reject out-of-range values early.  Large positive sizes are
-	   used for unknown buffer sizes. */
-	if (unlikely((int) size < 0)) {
-		/* There can be only one.. */
-		static char warn = 1;
-		WARN_ON(warn);
-		warn = 0;
-		return 0;
-	}
-
-	str = buf;
-	end = buf + size;
-
-	/* Make sure end is always >= buf */
-	if (end < buf) {
-		end = ((void *)-1);
-		size = end - buf;
-	}
+	ops->begin(data);
 
 	for (; *fmt ; ++fmt) {
 		if (*fmt != '%') {
-			if (str < end)
-				*str = *fmt;
-			++str;
+			ops->put_format(data, *fmt);
 			continue;
 		}
 
+		ops->begin_param(data);
+
 		/* process flags */
 		flags = 0;
 		repeat:
@@ -477,21 +546,14 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		switch (*fmt) {
 			case 'c':
 				if (!(flags & LEFT)) {
-					while (--field_width > 0) {
-						if (str < end)
-							*str = ' ';
-						++str;
-					}
+					while (--field_width > 0)
+						ops->put_param(data, ' ');
 				}
 				c = (unsigned char) va_arg(args, int);
-				if (str < end)
-					*str = c;
-				++str;
-				while (--field_width > 0) {
-					if (str < end)
-						*str = ' ';
-					++str;
-				}
+				ops->put_param(data, c);
+				while (--field_width > 0)
+					ops->put_param(data, ' ');
+				ops->end_param(data);
 				continue;
 
 			case 's':
@@ -502,22 +564,16 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				len = strnlen(s, precision);
 
 				if (!(flags & LEFT)) {
-					while (len < field_width--) {
-						if (str < end)
-							*str = ' ';
-						++str;
-					}
+					while (len < field_width--)
+						ops->put_param(data, ' ');
 				}
 				for (i = 0; i < len; ++i) {
-					if (str < end)
-						*str = *s;
-					++str; ++s;
-				}
-				while (len < field_width--) {
-					if (str < end)
-						*str = ' ';
-					++str;
+					ops->put_param(data, *s);
+					++s;
 				}
+				while (len < field_width--)
+					ops->put_param(data, ' ');
+				ops->end_param(data);
 				continue;
 
 			case 'p':
@@ -525,31 +581,30 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 					field_width = 2*sizeof(void *);
 					flags |= ZEROPAD;
 				}
-				str = number(str, end,
-						(unsigned long) va_arg(args, void *),
-						16, field_width, precision, flags);
+				xprintf_number(data, ops,
+					(unsigned long) va_arg(args, void *),
+					16, field_width, precision, flags);
+				ops->end_param(data);
 				continue;
 
 
 			case 'n':
-				/* FIXME:
-				* What does C99 say about the overflow case here? */
 				if (qualifier == 'l') {
-					long * ip = va_arg(args, long *);
-					*ip = (str - buf);
+					long *ip = va_arg(args, long *);
+					*ip = ops->size(data);
 				} else if (qualifier == 'Z' || qualifier == 'z') {
-					size_t * ip = va_arg(args, size_t *);
-					*ip = (str - buf);
+					size_t *ip = va_arg(args, size_t *);
+					*ip = ops->size(data);
 				} else {
-					int * ip = va_arg(args, int *);
-					*ip = (str - buf);
+					int *ip = va_arg(args, int *);
+					*ip = ops->size(data);
 				}
+				ops->end_param(data);
 				continue;
 
 			case '%':
-				if (str < end)
-					*str = '%';
-				++str;
+				ops->put_param(data, '%');
+				ops->end_param(data);
 				continue;
 
 				/* integer number formats - set up the flags and "break" */
@@ -570,16 +625,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 				break;
 
 			default:
-				if (str < end)
-					*str = '%';
-				++str;
-				if (*fmt) {
-					if (str < end)
-						*str = *fmt;
-					++str;
-				} else {
+				ops->unknown_conversion(data, *fmt);
+				if (!*fmt)
 					--fmt;
-				}
+				ops->end_param(data);
 				continue;
 		}
 		if (qualifier == 'L')
@@ -601,20 +650,15 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			if (flags & SIGN)
 				num = (signed int) num;
 		}
-		str = number(str, end, num, base,
-				field_width, precision, flags);
-	}
-	if (size > 0) {
-		if (str < end)
-			*str = '\0';
-		else
-			end[-1] = '\0';
+		xprintf_number(data, ops,
+			num, base, field_width, precision, flags);
+		ops->end_param(data);
 	}
-	/* the trailing null byte doesn't count towards the total */
-	return str-buf;
+
+	ops->end(data);
 }
 
-EXPORT_SYMBOL(vsnprintf);
+EXPORT_SYMBOL(vxprintf);
 
 /**
  * vscnprintf - Format a string and place it in a buffer
@@ -665,6 +709,18 @@ int snprintf(char * buf, size_t size, const char *fmt, ...)
 
 EXPORT_SYMBOL(snprintf);
 
+/* See vxprintf(). */
+void xprintf(void *data, const struct xprintf_ops *ops, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vxprintf(data, ops, fmt, ap);
+	va_end(ap);
+}
+
+EXPORT_SYMBOL(xprintf);
+
 /**
  * scnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into


