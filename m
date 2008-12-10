Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYLJDZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYLJDZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 22:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLJDZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 22:25:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbYLJDZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 22:25:38 -0500
Message-ID: <493F35F3.5020000@cn.fujitsu.com>
Date: Wed, 10 Dec 2008 11:22:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: support binary record
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Binary record will save memory in trace buffer, and more events
can be recorded in buffer.

This patch add infrastructure for supporting binary record.

This infrastructure records events by binary and shows events
by human readable text.

And add a API ftrace_struct_printk() using this infrastructure.
(it's like ftrace_printk(), but it record the date by binary)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace.h      |   29 ++++
 include/linux/string.h      |    8 +
 kernel/trace/Makefile       |    1
 kernel/trace/trace.c        |  130 +++++++++++++++++++++
 kernel/trace/trace.h        |   10 +
 kernel/trace/trace_struct.c |  248 +++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c              |  261 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 687 insertions(+)
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 703eb53..d8ed7da 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -248,6 +248,35 @@ static inline void start_boot_trace(void) { }
 static inline void stop_boot_trace(void) { }
 #endif
 
+#ifdef CONFIG_TRACING
+/**
+ * ftrace_struct - ftrace binary storage & show format
+ * ftrace_struct must be permanent in the kernel
+ * inspired from Python's struct
+ */
+struct ftrace_struct {
+	const char *storage_fmt;
+	const char *show_fmt;
+};
+int ftrace_struct_pack(char *buf, unsigned int len, const char *storage_fmt,
+		va_list args);
+int ftrace_struct_spintf(char *buf, size_t size,
+		const struct ftrace_struct *fmt,
+		const char *binary, size_t binary_len);
+struct ftrace_struct *ftrace_struct_permanent_alloc(const char *storage_fmt,
+		const char *show_fmt);
+
+int trace_struct_vprintk(unsigned long ip, const struct ftrace_struct *fmt,
+		va_list args);
+int __ftrace_struct_printk(unsigned long ip, const struct ftrace_struct *fmt,
+		...);
+#define ftrace_struct_printk(fmt...) __ftrace_struct_printk(_THIS_IP_, fmt)
 
+#else
+static inline int ftrace_struct_printk(const struct ftrace_struct *fmt, ...)
+{
+	return 0;
+}
+#endif
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/string.h b/include/linux/string.h
index d18fc19..cf13e9d 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -111,6 +111,14 @@ extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
 
+struct arg_iter {
+	int (*get_next_arg)(struct arg_iter *iter, unsigned long long *ptr,
+			unsigned int type_len);
+};
+
+int snprintf_iter_args(char *str, size_t size, const char *format,
+		struct arg_iter *args);
+
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..46c2b7a 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_TRACING) += trace_struct.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d86e325..4ad84d3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -289,6 +289,28 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	return len;
 }
 
+static int trace_seq_struct_print(struct trace_seq *s,
+		const struct ftrace_struct *fmt,
+		const char *binary, size_t binary_len)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	ret = ftrace_struct_spintf(s->buffer + s->len, len, fmt,
+			binary, binary_len);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+
 /**
  * trace_seq_puts - trace sequence printing of simple string
  * @s: trace sequence descriptor
@@ -1448,6 +1470,19 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_STRUCT_PRINT: {
+		struct struct_print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_puts(s, ": ");
+		trace_seq_struct_print(s, field->fmt, (char *)field->buf,
+				TRACE_BUF_SIZE);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1581,6 +1616,19 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_STRUCT_PRINT: {
+		struct struct_print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_puts(s, ": ");
+		trace_seq_struct_print(s, field->fmt, (char *)field->buf,
+				TRACE_BUF_SIZE);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -1663,6 +1711,18 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_STRUCT_PRINT: {
+		struct struct_print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, ": %lx : ", field->ip);
+		trace_seq_struct_print(s, field->fmt, (char *)field->buf,
+				TRACE_BUF_SIZE);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -3043,6 +3103,76 @@ int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(__ftrace_printk);
 
+int trace_struct_vprintk(unsigned long ip, const struct ftrace_struct *fmt,
+		va_list args)
+{
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static char trace_buf[TRACE_BUF_SIZE];
+
+	struct ring_buffer_event *event;
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	struct struct_print_entry *entry;
+	unsigned long flags, irq_flags;
+	int cpu, len = 0, size, pc;
+
+	if (!tr->ctrl || tracing_disabled)
+		return 0;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	if (unlikely(atomic_read(&data->disabled)))
+		goto out;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+	len = ftrace_struct_pack(trace_buf, TRACE_BUF_SIZE, fmt->storage_fmt,
+			args);
+
+	if (len > TRACE_BUF_SIZE || len < 0)
+		goto out_unlock;
+
+	size = sizeof(*entry) + len;
+	event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
+	if (!event)
+		goto out_unlock;
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_STRUCT_PRINT;
+	entry->ip			= ip;
+	entry->fmt			= fmt;
+
+	memcpy(&entry->buf, trace_buf, len);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+ out_unlock:
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+ out:
+	preempt_enable_notrace();
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_struct_vprintk);
+
+int __ftrace_struct_printk(unsigned long ip, const struct ftrace_struct *fmt,
+		...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_struct_vprintk(ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ftrace_struct_printk);
+
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..f95b766 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_STRUCT_PRINT,
 
 	__TRACE_LAST_TYPE
 };
@@ -94,6 +95,13 @@ struct print_entry {
 	char			buf[];
 };
 
+struct struct_print_entry {
+	struct trace_entry ent;
+	unsigned long ip;
+	const struct ftrace_struct *fmt;
+	u32 buf[];
+};
+
 #define TRACE_OLD_SIZE		88
 
 struct trace_field_cont {
@@ -219,6 +227,8 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct struct_print_entry,		\
+			  TRACE_STRUCT_PRINT);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_struct.c b/kernel/trace/trace_struct.c
new file mode 100644
index 0000000..6814b18
--- /dev/null
+++ b/kernel/trace/trace_struct.c
@@ -0,0 +1,248 @@
+/*
+ * ftrace_struct binary storage tracer
+ *
+ * Copyright (C) 2008 Lai Jiangshan <laijs@cn.fujitsu.com>
+ */
+#include <stdarg.h>
+#include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <linux/string.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+/*
+ * storage format:
+ * x	pad byte
+ * c	char
+ * b	signed char
+ * B	unsigned char
+ * h	short
+ * H	unsigned short
+ * i	int
+ * I	unsigned int
+ * l	long
+ * L	unsigned long
+ * q	long long (64bits)
+ * Q	unsigned long long (64bits)
+ * p	pointer
+ * s	C-style string
+ *
+ * align is 4bytes
+ */
+
+#define CASE_PACK(fmt_byte, type)					\
+case fmt_byte:								\
+	if (sizeof(type) == 8) {					\
+		str = PTR_ALIGN(str, 4);				\
+		value = va_arg(args, unsigned long long);		\
+		if (str + sizeof(type) <= end) {			\
+			*(u32 *)str = *(u32 *)&value;			\
+			*(u32 *)(str + 4) = *((u32 *)&value + 1);	\
+		}							\
+	} else {							\
+		str = PTR_ALIGN(str, sizeof(type));			\
+		value = va_arg(args, int);				\
+		if (str + sizeof(type) <= end)				\
+			*(type *)str = (type)value;			\
+	}								\
+	str += sizeof(type);						\
+	break;
+
+
+int ftrace_struct_pack(char *buf, unsigned int len, const char *storage_fmt,
+		va_list args)
+{
+	unsigned long long value;
+	char *str = buf, *end = buf + len;
+
+	/* align is 4bytes, FIXME: support other align */
+	if (!IS_ALIGNED((unsigned long)buf, 4))
+		return -1;
+
+	while (*storage_fmt) {
+		switch (*storage_fmt) {
+		case 'x':
+			str++;
+			break;
+		CASE_PACK('c', char)
+		CASE_PACK('b', signed char)
+		CASE_PACK('B', unsigned char)
+		CASE_PACK('h', short)
+		CASE_PACK('H', unsigned short)
+		CASE_PACK('i', int)
+		CASE_PACK('I', unsigned int)
+		CASE_PACK('l', long)
+		CASE_PACK('L', unsigned long)
+		CASE_PACK('q', long long)
+		CASE_PACK('Q', unsigned long long)
+		CASE_PACK('p', long) /* use long instead void * */
+		case 's':
+			str += strlcpy(str, va_arg(args, char *), end - str);
+			str++;
+			break;
+		default:
+			return -1;
+		}
+		storage_fmt++;
+	}
+	return str - buf;
+}
+
+#define CASE_UNPACK(fmt_byte, type)					\
+case fmt_byte:								\
+	if (sizeof(type) == 8) {					\
+		str = PTR_ALIGN(str, 4);				\
+		if (str + sizeof(type) <= end) {			\
+			*(u32 *)&value = *(u32 *)str;			\
+			*((u32 *)&value + 1) = *(u32 *)(str + 4);	\
+		} else							\
+			ret = -1;					\
+	} else {							\
+		str = PTR_ALIGN(str, sizeof(type));			\
+		if (str + sizeof(type) <= end)				\
+			value = *(type *)str;				\
+		else							\
+			ret = -1;					\
+	}								\
+	str += sizeof(type);						\
+	break;
+
+
+static
+int ftrace_struct_unpack_one(char storage_type, unsigned long long *ptr,
+		const char *binary, unsigned int len)
+{
+	unsigned long long value;
+	const char *str = binary, *end = binary + len;
+	int ret = 0;
+
+	switch (storage_type) {
+	case 'x':
+		return 1;
+	CASE_UNPACK('c', char)
+	CASE_UNPACK('b', signed char)
+	CASE_UNPACK('B', unsigned char)
+	CASE_UNPACK('h', short)
+	CASE_UNPACK('H', unsigned short)
+	CASE_UNPACK('i', int)
+	CASE_UNPACK('I', unsigned int)
+	CASE_UNPACK('l', long)
+	CASE_UNPACK('L', unsigned long)
+	CASE_UNPACK('q', long long)
+	CASE_UNPACK('Q', unsigned long long)
+	CASE_UNPACK('p', long) /* use long instead void * */
+	case 's':
+		ret = strlen(str) + 1;
+		if (ret <= end - str)
+			*ptr = (unsigned long)str;
+		else
+			ret = -1;
+		return ret;
+	default:
+		return -1;
+	}
+
+	if (ret == -1)
+		return -1;
+
+	*ptr = value;
+	return str - binary;
+}
+/*
+ * FIXME: write a portable ftrace_struct_unpack()
+ *	- unpack binary data and rebuild a va_list
+ */
+
+struct ftrace_struct_arg_iter {
+	struct arg_iter arg_iter_head;
+	const char *storage_fmt;
+	const char *binary;
+	const char *binary_end;
+};
+
+static
+int ftrace_struct_get_next_arg(struct arg_iter *head, unsigned long long *ptr,
+		unsigned int type_len)
+{
+	int ret;
+	struct ftrace_struct_arg_iter *iter = container_of(head,
+			struct ftrace_struct_arg_iter, arg_iter_head);
+
+	while (*iter->storage_fmt == 'x') {
+		iter->storage_fmt++;
+		iter->binary++;
+	}
+	ret = ftrace_struct_unpack_one(*iter->storage_fmt, ptr, iter->binary,
+			iter->binary_end - iter->binary);
+	if (ret < 0)
+		return ret;
+	iter->storage_fmt++;
+	iter->binary += ret;
+	return ret;
+}
+
+int ftrace_struct_spintf(char *buf, size_t size,
+		const struct ftrace_struct *fmt,
+		const char *binary, size_t binary_len)
+{
+	struct ftrace_struct_arg_iter args = {
+		{ ftrace_struct_get_next_arg },
+		fmt->storage_fmt,
+		binary,
+		binary + binary_len,
+	};
+	return snprintf_iter_args(buf, size, fmt->show_fmt,
+			&args.arg_iter_head);
+}
+
+struct ftrace_struct_permanent {
+	struct list_head head;
+	struct ftrace_struct fmt;
+};
+
+#define MAX_PERMANENT_ALLOC 1024
+static int permanent_count;
+static LIST_HEAD(permanent_list);
+static DEFINE_MUTEX(lock);
+
+struct ftrace_struct *ftrace_struct_permanent_alloc(const char *storage_fmt,
+		const char *show_fmt)
+{
+	struct ftrace_struct_permanent *pos;
+	struct ftrace_struct fmt = {NULL, NULL};
+	mutex_lock(&lock);
+	list_for_each_entry(pos, &permanent_list, head) {
+		if (strcmp(pos->fmt.storage_fmt, storage_fmt) == 0
+				&& strcmp(pos->fmt.show_fmt, show_fmt) == 0)
+			goto finish;
+	}
+
+	if (permanent_count >= MAX_PERMANENT_ALLOC)
+		goto err;
+	fmt.storage_fmt = kstrdup(storage_fmt, GFP_KERNEL);
+	if (!fmt.storage_fmt)
+		goto err;
+	fmt.show_fmt = kstrdup(show_fmt, GFP_KERNEL);
+	if (!fmt.show_fmt)
+		goto err;
+	pos = kmalloc(sizeof(*pos), GFP_KERNEL);
+	if (!pos)
+		goto err;
+
+	pos->fmt = fmt;
+	list_add(&pos->head, &permanent_list);
+	permanent_count++;
+finish:
+	mutex_unlock(&lock);
+	return &pos->fmt;
+err:
+	kfree(fmt.storage_fmt);
+	kfree(fmt.show_fmt);
+	mutex_unlock(&lock);
+	return NULL;
+}
+EXPORT_SYMBOL(ftrace_struct_permanent_alloc);
+
+
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..f2f794f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -856,6 +856,267 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 EXPORT_SYMBOL(vsnprintf);
 
 /**
+ * snprintf_iter_args - Format a string and place it in a buffer
+ * @buf: The buffer to place the result into
+ * @size: The size of the buffer, including the trailing null space
+ * @fmt: The format string to use
+ * @args: struct arg_iter style arguments for the format string
+ *
+ * This function follows C99 vsnprintf, but has some extensions:
+ * %pS output the name of a text symbol
+ * %pF output the name of a function pointer
+ * %pR output the address range in a struct resource
+ *
+ * The return value is the number of characters which would
+ * be generated for the given input, excluding the trailing
+ * '\0', as per ISO C99. If you want to have the exact
+ * number of characters written into @buf as return value
+ * (not including the trailing '\0'), use vscnprintf(). If the
+ * return is greater than or equal to @size, the resulting
+ * string is truncated.
+ */
+int snprintf_iter_args(char *buf, size_t size, const char *fmt,
+		struct arg_iter *args)
+{
+	unsigned long long num;
+	int base;
+	char *str, *end, c;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/* min. # of digits for integers; max
+				   number of chars for from string */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+				/* 'z' support added 23/7/1999 S.H.    */
+				/* 'z' changed to 'Z' --davidm 1/25/99 */
+				/* 't' added for ptrdiff_t */
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
+#define iter_arg(args, type) ({						\
+	unsigned long long __value;					\
+	if (args->get_next_arg(args, &__value, sizeof(type)) < 0)	\
+		goto error;						\
+	(type)__value;							\
+})
+
+	str = buf;
+	end = buf + size;
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
+			++fmt;		/* this also skips first '%' */
+			switch (*fmt) {
+			case '-':
+				flags |= LEFT;
+				goto repeat;
+			case '+':
+				flags |= PLUS;
+				goto repeat;
+			case ' ':
+				flags |= SPACE;
+				goto repeat;
+			case '#':
+				flags |= SPECIAL;
+				goto repeat;
+			case '0':
+				flags |= ZEROPAD;
+				goto repeat;
+			}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = iter_arg(args, int);
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
+				precision = iter_arg(args, int);
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
+			c = iter_arg(args, unsigned char);
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
+		case 's':
+			str = string(str, end, (char *)iter_arg(args, long),
+					field_width, precision, flags);
+			continue;
+
+		case 'p':
+			str = pointer(fmt+1, str, end,
+					(void *)iter_arg(args, long),
+					field_width, precision, flags);
+			/* Skip all alphanumeric pointer suffixes */
+			while (isalnum(fmt[1]))
+				fmt++;
+			continue;
+
+		case 'n':
+			/* FIXME:
+			* What does C99 say about the overflow case here? */
+			if (qualifier == 'l') {
+				long *ip = (long *)iter_arg(args, long);
+				*ip = (str - buf);
+			} else if (qualifier == 'Z' || qualifier == 'z') {
+				size_t *ip = (size_t *)iter_arg(args, long);
+				*ip = (str - buf);
+			} else {
+				int *ip = (int *)iter_arg(args, long);
+				*ip = (str - buf);
+			}
+			continue;
+
+		case '%':
+			if (str < end)
+				*str = '%';
+			++str;
+			continue;
+
+			/*
+			 * integer number formats
+			 * - set up the flags and "break"
+			 */
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
+			num = iter_arg(args, long long);
+		else if (qualifier == 'l') {
+			num = iter_arg(args, unsigned long);
+			if (flags & SIGN)
+				num = (signed long) num;
+		} else if (qualifier == 'Z' || qualifier == 'z') {
+			num = iter_arg(args, size_t);
+		} else if (qualifier == 't') {
+			num = iter_arg(args, ptrdiff_t);
+		} else if (qualifier == 'h') {
+			num = iter_arg(args, unsigned short);
+			if (flags & SIGN)
+				num = (signed short) num;
+		} else {
+			num = iter_arg(args, unsigned int);
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
+	/* the trailing null byte doesn't count towards the total */
+	return str-buf;
+
+error:
+	return -1;
+#undef iter_arg
+}
+
+/**
  * vscnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space




