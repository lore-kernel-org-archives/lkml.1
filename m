Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbXJILPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbXJILPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 07:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXJILOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 07:14:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:3756 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXJILOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 07:14:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rb15nmwruhhFmCw2xCt9ZsiL2ojjH9QyDLZlodIVGT4ztTalT37+omHKAiILRCuoRVAPf6MJXa1zjvsUdYWhnoyy8WDlnm5rLpudPE2fC/sLaLP01G3wILnNs5TJF0VIpF5pp8SnWscvreY5anMIsZSQkmJ2TxH0fvwCuSHi2sE=
Subject: Re: [RFC][PATCH] Escaping the arguments of kernel messages for
	sane user-space localisation
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1191872730.27240.29.camel@grianne>
References: <1191872730.27240.29.camel@grianne>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 13:14:43 +0200
Message-Id: <1191928483.17405.15.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,


On Mon, 2007-10-08 at 21:45 +0200, Vegard Nossum wrote:
> These functions make it quite easy to make snprintf() automatically
> escape certain characters in string arguments, for example. I think they
> are also well suited to printing to variable-sized buffers, though the
> last time I looked, there was no krealloc in the kernel, which makes it
> again useless. Perhaps there are other uses, though?

I have now found what I think is another valid use. What I have done is
to make xprintf() emit the output directly to the kernel ring-buffer.

This means two things:
1. We get rid of a (static) 1K temporary buffer in printk().
2. A single log message (as emitted by a single call to printk()) is no
longer limited to 1K bytes, but is limited to the size of the ring
buffer (this was obviously always true).

In particular, I think this output from bloat-o-meter is interesting:

add/remove: 25/3 grow/shrink: 0/2 up/down: 1955/-2585 (-630)
function                                     old     new   delta
vxprintf                                       -    1048   +1048
xprintf_number                                 -     499    +499
vsnprintf_unknown_conversion                   -      44     +44
printk_put                                     -      35     +35
printk_unknown_conversion                      -      34     +34
vsnprintf_end                                  -      33     +33
xprintf                                        -      32     +32
vsnprintf_put_char                             -      24     +24
printk_end_param                               -      22     +22
printk_begin_param                             -      22     +22
vsnprintf_begin                                -      21     +21
vsnprintf_put_param                            -      20     +20
vsnprintf_put_format                           -      20     +20
printk_put_param                               -      16     +16
printk_put_format                              -      16     +16
printk_begin                                   -      15     +15
vsnprintf_size                                 -      13     +13
printk_size                                    -      10     +10
vsnprintf_end_param                            -       5      +5
vsnprintf_begin_param                          -       5      +5
printk_end                                     -       5      +5
static.log_level                               -       4      +4
printed_len                                    -       4      +4
new_line                                       -       4      +4
escape_args                                    -       4      +4
static.log_level_unknown                       4       -      -4
vprintk                                      537     396    -141
number                                       488       -    -488
vsnprintf                                   1052     124    -928
static.printk_buf                           1024       -   -1024


There is only one very small caveat (that I can see) to be mentioned:
You can still use multiple printk() calls to append new text to a
partial message, but you can NOT output several messages in a single
call. I think, however, that no sanely written code would do this
anyway, with perhaps the exception of writes to /proc/kmsg, which may
contain newlines which will NOT be preceded by log-levels (or
timestamps). The solution would be to change this location to output the
user-provided data as an argument to %s (like my first kprint patches
did anyway), and maybe escape any newlines. I don't think it's an issue.

So please consider this patch instead of the first I submitted. New
diffstat looks like this:

 include/linux/xprintf.h |   28 +++++
 kernel/printk.c         |  171 +++++++++++++++++----------
 lib/vsprintf.c          |  296 ++++++++++++++++++++++++++++-------------------
 3 files changed, 314 insertions(+), 181 deletions(-)


Kind regards,
Vegard Nossum



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
index 8451dfc..78a5be1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -31,6 +31,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
+#include <linux/xprintf.h>
 
 #include <asm/uaccess.h>
 
@@ -481,6 +482,80 @@ static int have_callable_console(void)
 	return 0;
 }
 
+static int printed_len;
+static int new_line = 1;
+
+/* Output a single character to the log buffer, and keep count of how many
+ * we print. Also keep track of whether we are starting a new line or not
+ * the next time we print something. */
+static void printk_put(char c)
+{
+	new_line = (c == '\n');
+
+	emit_log_char(c);
+	printed_len++;
+}
+
+static void printk_begin(void *data)
+{
+	printed_len = 0;
+}
+
+static void printk_end(void *data)
+{
+}
+
+static void printk_put_format(void *data, char c)
+{
+	printk_put(c);
+}
+
+/* If set, we output markers in the log to indicate what parts of a message
+ * are from the format string, and what parts are the arguments. */
+static int escape_args;
+
+static void printk_begin_param(void *data)
+{
+	if(escape_args)
+		printk_put('\x1f');
+}
+
+static void printk_end_param(void *data)
+{
+	if(escape_args)
+		printk_put('\x1f');
+}
+
+static void printk_put_param(void *data, char c)
+{
+	printk_put(c);
+}
+
+static long printk_size(void *data)
+{
+	return printed_len;
+}
+
+static void printk_unknown_conversion(void *data, char c)
+{
+	printk_put('%');
+
+	if (c)
+		printk_put(c);
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
@@ -522,10 +597,7 @@ static volatile unsigned int printk_cpu = UINT_MAX;
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	unsigned long flags;
-	int printed_len;
-	char *p;
-	static char printk_buf[1024];
-	static int log_level_unknown = 1;
+	int len;
 
 	preempt_disable();
 	if (unlikely(oops_in_progress) && printk_cpu == smp_processor_id())
@@ -539,66 +611,43 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	spin_lock(&logbuf_lock);
 	printk_cpu = smp_processor_id();
 
-	/* Emit the output into the temporary buffer */
-	printed_len = vscnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	if(new_line) {
+		static int log_level;
 
-	/*
-	 * Copy the output into log_buf.  If the caller didn't provide
-	 * appropriate log level tags, we insert them here
-	 */
-	for (p = printk_buf; *p; p++) {
-		if (log_level_unknown) {
-                        /* log_level_unknown signals the start of a new line */
-			if (printk_time) {
-				int loglev_char;
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
-				/*
-				 * force the log level token to be
-				 * before the time output.
-				 */
-				if (p[0] == '<' && p[1] >='0' &&
-				   p[1] <= '7' && p[2] == '>') {
-					loglev_char = p[1];
-					p += 3;
-					printed_len -= 3;
-				} else {
-					loglev_char = default_message_loglevel
-						+ '0';
-				}
-				t = printk_clock();
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf,
-						"<%c>[%5lu.%06lu] ",
-						loglev_char,
-						(unsigned long)t,
-						nanosec_rem/1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
-				printed_len += tlen;
-			} else {
-				if (p[0] != '<' || p[1] < '0' ||
-				   p[1] > '7' || p[2] != '>') {
-					emit_log_char('<');
-					emit_log_char(default_message_loglevel
-						+ '0');
-					emit_log_char('>');
-					printed_len += 3;
-				}
-			}
-			log_level_unknown = 0;
-			if (!*p)
-				break;
+		/* Extract log-level */
+		if (fmt[0] == '<' && fmt[1] >= '0'
+			&& fmt[1] <= '7' && fmt[2] == '>')
+		{
+			log_level = fmt[1] - '0';
+			fmt += 3;
+		} else {
+			log_level = default_message_loglevel;
+		}
+
+		escape_args = 0;
+		xprintf(NULL, &printk_ops, "<%d>", log_level);
+
+		/* Print the current time... */
+		if (printk_time) {
+			unsigned long long t;
+			unsigned long nanosec_rem;
+
+			t = printk_clock();
+			nanosec_rem = do_div(t, 1000000000);
+
+			escape_args = 0;
+			xprintf(NULL, &printk_ops, "[%5lu.%06lu] ",
+				(unsigned long) t, nanosec_rem / 1000);
 		}
-		emit_log_char(*p);
-		if (*p == '\n')
-			log_level_unknown = 1;
 	}
 
+	/* Print the message straight to the log buffer */
+	escape_args = 1;
+	vxprintf(NULL, &printk_ops, fmt, args);
+
+	/* Copy this prevent a race when we return this value. */
+	len = printed_len;
+
 	if (!down_trylock(&console_sem)) {
 		/*
 		 * We own the drivers.  We can drop the spinlock and
@@ -637,7 +686,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 
 	preempt_enable();
-	return printed_len;
+	return len;
 }
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
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


