Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYLaC7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYLaC7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYLaC7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:59:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbYLaC7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:59:06 -0500
Message-ID: <495ADF3C.4030305@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 10:55:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] add binary printf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Add APIs for binary trace printk infrastructure

vbin_printf(): write args to binary buffer, string is copied
when "%s" is occurred.

bstr_printf(): read from binary buffer for args and format a string

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 b/lib/Kconfig          |    3
 b/lib/vsprintf.c       |  442 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/string.h |    7
 3 files changed, 452 insertions(+)
diff --git a/include/linux/string.h b/include/linux/string.h
index d18fc19..27ac317 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>	/* for inline */
 #include <linux/types.h>	/* for size_t */
 #include <linux/stddef.h>	/* for NULL */
+#include <stdarg.h>
 
 extern char *strndup_user(const char __user *, long);
 
@@ -111,6 +112,12 @@ extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
 
+#ifdef CONFIG_BINARY_PRINTF
+int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
+int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
+int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);
+#endif
+
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
diff --git a/lib/Kconfig b/lib/Kconfig
index fd4118e..aa16cd6 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -2,6 +2,9 @@
 # Library configuration
 #
 
+config BINARY_PRINTF
+	def_bool n
+
 menu "Library routines"
 
 config BITREVERSE
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b77702..b8dd704 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1051,6 +1051,448 @@ int sprintf(char * buf, const char *fmt, ...)
 }
 EXPORT_SYMBOL(sprintf);
 
+#ifdef CONFIG_BINARY_PRINTF
+/*
+ * bprintf service:
+ * vbin_printf() - VA arguments to binary data
+ * bstr_printf() - Binary data to text string
+ */
+
+/**
+ * vbin_printf - Parse a format string and place args' binary value in a buffer
+ * @bin_buf: The buffer to place args' binary value
+ * @size: The size of the buffer(by words(32bits), not characters)
+ * @fmt: The format string to use
+ * @args: Arguments for the format string
+ *
+ * The format follows C99 vsnprintf, except %n is ignored, and its argument
+ * is skiped.
+ *
+ * The return value is the number of words(32bits) which would be generated for
+ * the given input.
+ *
+ * NOTE:
+ * If the return value is greater than @size, the resulting bin_buf is NOT
+ * valid for bstr_printf().
+ */
+int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
+{
+	char *str, *end;
+	int qualifier;
+
+	str = (char *)bin_buf;
+	end = (char *)(bin_buf + size);
+
+#define save_arg(type)							\
+do {									\
+	if (sizeof(type) == 8) {					\
+		unsigned long long value;				\
+		str = PTR_ALIGN(str, sizeof(u32));			\
+		value = va_arg(args, unsigned long long);		\
+		if (str + sizeof(type) <= end) {			\
+			*(u32 *)str = *(u32 *)&value;			\
+			*(u32 *)(str + 4) = *((u32 *)&value + 1);	\
+		}							\
+	} else {							\
+		unsigned long value;					\
+		str = PTR_ALIGN(str, sizeof(type));			\
+		value = va_arg(args, int);				\
+		if (str + sizeof(type) <= end)				\
+			*(typeof(type) *)str = (type)value;		\
+	}								\
+	str += sizeof(type);						\
+} while (0)
+
+	for (; *fmt ; ++fmt) {
+		if (*fmt != '%')
+			continue;
+
+repeat:
+		/* parse flags */
+		++fmt;		/* this also skips first '%' */
+		if (*fmt == '-' || *fmt == '+' || *fmt == ' '
+				|| *fmt == '#' || *fmt == '0')
+			goto repeat;
+
+		/* parse field width */
+		if (isdigit(*fmt))
+			skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			save_arg(int);
+		}
+
+		/* parse the precision */
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt))
+				skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				save_arg(int);
+			}
+		}
+
+		/* parse the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
+		    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+			qualifier = *fmt;
+			++fmt;
+			if (qualifier == 'l' && *fmt == 'l') {
+				qualifier = 'L';
+				++fmt;
+			}
+		}
+
+		/* parse format type */
+		switch (*fmt) {
+		case 'c':
+			save_arg(char);
+			continue;
+		case 's': {
+			/* save the string argument */
+			const char *save_str = va_arg(args, char *);
+			size_t len;
+			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
+					|| (unsigned long)save_str < PAGE_SIZE)
+				save_str = "<NULL>";
+			len = strlen(save_str);
+			if (str + len + 1 < end)
+				memcpy(str, save_str, len + 1);
+			str += len + 1;
+			continue;
+		}
+		case 'p':
+			save_arg(void *);
+			/* skip all alphanumeric pointer suffixes */
+			while (isalnum(fmt[1]))
+				fmt++;
+			continue;
+		case 'n': {
+			/* skip %n 's argument */
+			void *skip_arg;
+			if (qualifier == 'l')
+				skip_arg = va_arg(args, long *);
+			else if (qualifier == 'Z' || qualifier == 'z')
+				skip_arg = va_arg(args, size_t *);
+			else
+				skip_arg = va_arg(args, int *);
+			continue;
+		}
+		case 'o':
+		case 'x':
+		case 'X':
+		case 'd':
+		case 'i':
+		case 'u':
+			/* save arg for case: 'o', 'x', 'X', 'd', 'i', 'u' */
+			if (qualifier == 'L')
+				save_arg(long long);
+			else if (qualifier == 'l')
+				save_arg(unsigned long);
+			else if (qualifier == 'Z' || qualifier == 'z')
+				save_arg(size_t);
+			else if (qualifier == 't')
+				save_arg(ptrdiff_t);
+			else if (qualifier == 'h')
+				save_arg(short);
+			else
+				save_arg(int);
+			continue;
+		default:
+			if (!*fmt)
+				--fmt;
+			continue;
+		}
+	}
+#undef save_arg
+
+	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
+}
+EXPORT_SYMBOL_GPL(vbin_printf);
+
+/**
+ * bstr_printf - Format a string from binary arguments and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @bin_buf: Binary arguments for the format string
+ *
+ * This function like C99 vsnprintf, but the difference is that vsnprintf gets
+ * arguments from stack, and bstr_printf gets arguments from @bin_buf which is
+ * a binary buffer that generated by vbin_printf.
+ *
+ * The format follows C99 vsnprintf, but has some extensions:
+ * %pS output the name of a text symbol
+ * %pF output the name of a function pointer
+ * %pR output the address range in a struct resource
+ * %n is ignored
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ */
+int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
+{
+	unsigned long long num;
+	int base;
+	char *str, *end, c;
+	const char *args = (const char *)bin_buf;
+
+	int flags;
+	int field_width;
+	int precision;
+	int qualifier;
+
+	if (unlikely((int) size < 0)) {
+		/* There can be only one.. */
+		static char warn = 1;
+		WARN_ON(warn);
+		warn = 0;
+		return 0;
+	}
+
+	str = buf;
+	end = buf + size;
+
+#define get_arg(type)							\
+({									\
+	typeof(type) value;						\
+	if (sizeof(type) == 8) {					\
+		args = PTR_ALIGN(args, sizeof(u32));			\
+		*(u32 *)&value = *(u32 *)args;				\
+		*((u32 *)&value + 1) = *(u32 *)(args + 4);		\
+	} else {							\
+		args = PTR_ALIGN(args, sizeof(type));			\
+		value = *(typeof(type) *)args;				\
+	}								\
+	args += sizeof(type);						\
+	value;								\
+})
+
+	/* Make sure end is always >= buf */
+	if (end < buf) {
+		end = ((void *)-1);
+		size = end - buf;
+	}
+
+	for (; *fmt ; ++fmt) {
+		if (*fmt != '%') {
+			if (str < end)
+				*str = *fmt;
+			++str;
+			continue;
+		}
+
+		/* process flags */
+		flags = 0;
+repeat:
+		++fmt;		/* this also skips first '%' */
+		switch (*fmt) {
+		case '-':
+			flags |= LEFT;
+			goto repeat;
+		case '+':
+			flags |= PLUS;
+			goto repeat;
+		case ' ':
+			flags |= SPACE;
+			goto repeat;
+		case '#':
+			flags |= SPECIAL;
+			goto repeat;
+		case '0':
+			flags |= ZEROPAD;
+			goto repeat;
+		}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = get_arg(int);
+			if (field_width < 0) {
+				field_width = -field_width;
+				flags |= LEFT;
+			}
+		}
+
+		/* get the precision */
+		precision = -1;
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt))
+				precision = skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				precision = get_arg(int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
+		    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+			qualifier = *fmt;
+			++fmt;
+			if (qualifier == 'l' && *fmt == 'l') {
+				qualifier = 'L';
+				++fmt;
+			}
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+		case 'c':
+			if (!(flags & LEFT)) {
+				while (--field_width > 0) {
+					if (str < end)
+						*str = ' ';
+					++str;
+				}
+			}
+			c = (unsigned char) get_arg(char);
+			if (str < end)
+				*str = c;
+			++str;
+			while (--field_width > 0) {
+				if (str < end)
+					*str = ' ';
+				++str;
+			}
+			continue;
+
+		case 's':{
+			const char *str_arg = args;
+			size_t len = strlen(str_arg);
+			args += len + 1;
+			str = string(str, end, (char *)str_arg, field_width,
+					precision, flags);
+			continue;
+		}
+
+		case 'p':
+			str = pointer(fmt+1, str, end, get_arg(void *),
+					field_width, precision, flags);
+			/* Skip all alphanumeric pointer suffixes */
+			while (isalnum(fmt[1]))
+				fmt++;
+			continue;
+
+		case 'n':
+			/* skip %n */
+			continue;
+
+		case '%':
+			if (str < end)
+				*str = '%';
+			++str;
+			continue;
+
+		/* integer number formats - set up the flags and "break" */
+		case 'o':
+			base = 8;
+			break;
+
+		case 'x':
+			flags |= SMALL;
+		case 'X':
+			base = 16;
+			break;
+
+		case 'd':
+		case 'i':
+			flags |= SIGN;
+		case 'u':
+			break;
+
+		default:
+			if (str < end)
+				*str = '%';
+			++str;
+			if (*fmt) {
+				if (str < end)
+					*str = *fmt;
+				++str;
+			} else {
+				--fmt;
+			}
+			continue;
+		}
+		if (qualifier == 'L')
+			num = get_arg(long long);
+		else if (qualifier == 'l') {
+			num = get_arg(unsigned long);
+			if (flags & SIGN)
+				num = (signed long) num;
+		} else if (qualifier == 'Z' || qualifier == 'z') {
+			num = get_arg(size_t);
+		} else if (qualifier == 't') {
+			num = get_arg(ptrdiff_t);
+		} else if (qualifier == 'h') {
+			num = (unsigned short) get_arg(short);
+			if (flags & SIGN)
+				num = (signed short) num;
+		} else {
+			num = get_arg(unsigned int);
+			if (flags & SIGN)
+				num = (signed int) num;
+		}
+		str = number(str, end, num, base,
+				field_width, precision, flags);
+	}
+	if (size > 0) {
+		if (str < end)
+			*str = '\0';
+		else
+			end[-1] = '\0';
+	}
+#undef get_arg
+
+	/* the trailing null byte doesn't count towards the total */
+	return str - buf;
+}
+EXPORT_SYMBOL_GPL(bstr_printf);
+
+/**
+ * bprintf - Parse a format string and place args' binary value in a buffer
+ * @bin_buf: The buffer to place args' binary value
+ * @size: The size of the buffer(by words(32bits), not characters)
+ * @fmt: The format string to use
+ * @...: Arguments for the format string
+ *
+ * The function returns the number of words(u32) written
+ * into @bin_buf.
+ */
+int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = vbin_printf(bin_buf, size, fmt, args);
+	va_end(args);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bprintf);
+
+#endif /* CONFIG_BINARY_PRINTF */
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer






