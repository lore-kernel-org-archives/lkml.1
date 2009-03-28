Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbZC1WnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbZC1WnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZC1Wm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:42:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbZC1Wm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:42:57 -0400
Date: Sat, 28 Mar 2009 23:42:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [git pull] printk changes for v2.6.30
Message-ID: <20090328224238.GA26506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git printk-for-linus

Highlights:

 - the introduction of these 'binary printk' APIs:

 +int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
 +int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
 +int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);

   Relied on by the tracing tree.

Known risks:

 - The vsnprintf changes are intrusive, and printk formatting bugs 
   do not tend to be functional (they are visual mostly), so they 
   get found later than other types of bugs. We had two bugs there.

 - There are no known regressions.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      vsprintf: unify the format decoding layer for its 3 users
      vsprintf: fix bug in negative value printing

Guillaume Knispel (1):
      printk: correct the behavior of printk_timed_ratelimit()

Ingo Molnar (1):
      printk: introduce printk_once()

Lai Jiangshan (1):
      vsprintf: add binary printf

Vegard Nossum (2):
      fix regression from "vsprintf: unify the format decoding layer for its 3 users"
      vsprintf: unify the format decoding layer for its 3 users, cleanup


 include/linux/kernel.h |   17 +
 include/linux/string.h |    7 +
 kernel/printk.c        |    7 +-
 lib/Kconfig            |    3 +
 lib/vsprintf.c         | 1005 +++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 810 insertions(+), 229 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 914918a..6e4406e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -242,6 +242,19 @@ extern struct ratelimit_state printk_ratelimit_state;
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
+
+/*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+#define printk_once(x...) ({			\
+	static int __print_once = 1;		\
+						\
+	if (__print_once) {			\
+		__print_once = 0;		\
+		printk(x);			\
+	}					\
+})
+
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -253,6 +266,10 @@ static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_once(x...) printk(x)
+
 #endif
 
 extern int printk_needs_cpu(int cpu);
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
 
diff --git a/kernel/printk.c b/kernel/printk.c
index e3602d0..2be7199 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1292,8 +1292,11 @@ EXPORT_SYMBOL(printk_ratelimit);
 bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 			unsigned int interval_msecs)
 {
-	if (*caller_jiffies == 0 || time_after(jiffies, *caller_jiffies)) {
-		*caller_jiffies = jiffies + msecs_to_jiffies(interval_msecs);
+	if (*caller_jiffies == 0
+			|| !time_in_range(jiffies, *caller_jiffies,
+					*caller_jiffies
+					+ msecs_to_jiffies(interval_msecs))) {
+		*caller_jiffies = jiffies;
 		return true;
 	}
 	return false;
diff --git a/lib/Kconfig b/lib/Kconfig
index 2a9c69f..8ade0a7 100644
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
index 0fbd012..be3001f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -396,7 +396,38 @@ static noinline char* put_dec(char *buf, unsigned long long num)
 #define SMALL	32		/* Must be 32 == 0x20 */
 #define SPECIAL	64		/* 0x */
 
-static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
+enum format_type {
+	FORMAT_TYPE_NONE, /* Just a string part */
+	FORMAT_TYPE_WIDTH,
+	FORMAT_TYPE_PRECISION,
+	FORMAT_TYPE_CHAR,
+	FORMAT_TYPE_STR,
+	FORMAT_TYPE_PTR,
+	FORMAT_TYPE_PERCENT_CHAR,
+	FORMAT_TYPE_INVALID,
+	FORMAT_TYPE_LONG_LONG,
+	FORMAT_TYPE_ULONG,
+	FORMAT_TYPE_LONG,
+	FORMAT_TYPE_USHORT,
+	FORMAT_TYPE_SHORT,
+	FORMAT_TYPE_UINT,
+	FORMAT_TYPE_INT,
+	FORMAT_TYPE_NRCHARS,
+	FORMAT_TYPE_SIZE_T,
+	FORMAT_TYPE_PTRDIFF
+};
+
+struct printf_spec {
+	enum format_type	type;
+	int			flags;		/* flags to number() */
+	int			field_width;	/* width of output field */
+	int			base;
+	int			precision;	/* # of digits/chars */
+	int			qualifier;
+};
+
+static char *number(char *buf, char *end, unsigned long long num,
+			struct printf_spec spec)
 {
 	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
 	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
@@ -404,32 +435,32 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	char tmp[66];
 	char sign;
 	char locase;
-	int need_pfx = ((type & SPECIAL) && base != 10);
+	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
-	locase = (type & SMALL);
-	if (type & LEFT)
-		type &= ~ZEROPAD;
+	locase = (spec.flags & SMALL);
+	if (spec.flags & LEFT)
+		spec.flags &= ~ZEROPAD;
 	sign = 0;
-	if (type & SIGN) {
+	if (spec.flags & SIGN) {
 		if ((signed long long) num < 0) {
 			sign = '-';
 			num = - (signed long long) num;
-			size--;
-		} else if (type & PLUS) {
+			spec.field_width--;
+		} else if (spec.flags & PLUS) {
 			sign = '+';
-			size--;
-		} else if (type & SPACE) {
+			spec.field_width--;
+		} else if (spec.flags & SPACE) {
 			sign = ' ';
-			size--;
+			spec.field_width--;
 		}
 	}
 	if (need_pfx) {
-		size--;
-		if (base == 16)
-			size--;
+		spec.field_width--;
+		if (spec.base == 16)
+			spec.field_width--;
 	}
 
 	/* generate full string in tmp[], in reverse order */
@@ -441,10 +472,10 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 		tmp[i++] = (digits[do_div(num,base)] | locase);
 	} while (num != 0);
 	*/
-	else if (base != 10) { /* 8 or 16 */
-		int mask = base - 1;
+	else if (spec.base != 10) { /* 8 or 16 */
+		int mask = spec.base - 1;
 		int shift = 3;
-		if (base == 16) shift = 4;
+		if (spec.base == 16) shift = 4;
 		do {
 			tmp[i++] = (digits[((unsigned char)num) & mask] | locase);
 			num >>= shift;
@@ -454,12 +485,12 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	}
 
 	/* printing 100 using %2d gives "100", not "00" */
-	if (i > precision)
-		precision = i;
+	if (i > spec.precision)
+		spec.precision = i;
 	/* leading space padding */
-	size -= precision;
-	if (!(type & (ZEROPAD+LEFT))) {
-		while(--size >= 0) {
+	spec.field_width -= spec.precision;
+	if (!(spec.flags & (ZEROPAD+LEFT))) {
+		while(--spec.field_width >= 0) {
 			if (buf < end)
 				*buf = ' ';
 			++buf;
@@ -476,23 +507,23 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 		if (buf < end)
 			*buf = '0';
 		++buf;
-		if (base == 16) {
+		if (spec.base == 16) {
 			if (buf < end)
 				*buf = ('X' | locase);
 			++buf;
 		}
 	}
 	/* zero or space padding */
-	if (!(type & LEFT)) {
-		char c = (type & ZEROPAD) ? '0' : ' ';
-		while (--size >= 0) {
+	if (!(spec.flags & LEFT)) {
+		char c = (spec.flags & ZEROPAD) ? '0' : ' ';
+		while (--spec.field_width >= 0) {
 			if (buf < end)
 				*buf = c;
 			++buf;
 		}
 	}
 	/* hmm even more zero padding? */
-	while (i <= --precision) {
+	while (i <= --spec.precision) {
 		if (buf < end)
 			*buf = '0';
 		++buf;
@@ -504,7 +535,7 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 		++buf;
 	}
 	/* trailing space padding */
-	while (--size >= 0) {
+	while (--spec.field_width >= 0) {
 		if (buf < end)
 			*buf = ' ';
 		++buf;
@@ -512,17 +543,17 @@ static char *number(char *buf, char *end, unsigned long long num, int base, int
 	return buf;
 }
 
-static char *string(char *buf, char *end, char *s, int field_width, int precision, int flags)
+static char *string(char *buf, char *end, char *s, struct printf_spec spec)
 {
 	int len, i;
 
 	if ((unsigned long)s < PAGE_SIZE)
 		s = "<NULL>";
 
-	len = strnlen(s, precision);
+	len = strnlen(s, spec.precision);
 
-	if (!(flags & LEFT)) {
-		while (len < field_width--) {
+	if (!(spec.flags & LEFT)) {
+		while (len < spec.field_width--) {
 			if (buf < end)
 				*buf = ' ';
 			++buf;
@@ -533,7 +564,7 @@ static char *string(char *buf, char *end, char *s, int field_width, int precisio
 			*buf = *s;
 		++buf; ++s;
 	}
-	while (len < field_width--) {
+	while (len < spec.field_width--) {
 		if (buf < end)
 			*buf = ' ';
 		++buf;
@@ -541,21 +572,24 @@ static char *string(char *buf, char *end, char *s, int field_width, int precisio
 	return buf;
 }
 
-static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int precision, int flags)
+static char *symbol_string(char *buf, char *end, void *ptr,
+				struct printf_spec spec)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
 	sprint_symbol(sym, value);
-	return string(buf, end, sym, field_width, precision, flags);
+	return string(buf, end, sym, spec);
 #else
-	field_width = 2*sizeof(void *);
-	flags |= SPECIAL | SMALL | ZEROPAD;
-	return number(buf, end, value, 16, field_width, precision, flags);
+	spec.field_width = 2*sizeof(void *);
+	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+	return number(buf, end, value, spec);
 #endif
 }
 
-static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+static char *resource_string(char *buf, char *end, struct resource *res,
+				struct printf_spec spec)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
 #define IO_RSRC_PRINTK_SIZE	4
@@ -564,7 +598,11 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 #ifndef MEM_RSRC_PRINTK_SIZE
 #define MEM_RSRC_PRINTK_SIZE	8
 #endif
-
+	struct printf_spec num_spec = {
+		.base = 16,
+		.precision = -1,
+		.flags = SPECIAL | SMALL | ZEROPAD,
+	};
 	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
 	char sym[4*sizeof(resource_size_t) + 8];
 	char *p = sym, *pend = sym + sizeof(sym);
@@ -576,17 +614,18 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 		size = MEM_RSRC_PRINTK_SIZE;
 
 	*p++ = '[';
-	p = number(p, pend, res->start, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	num_spec.field_width = size;
+	p = number(p, pend, res->start, num_spec);
 	*p++ = '-';
-	p = number(p, pend, res->end, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	p = number(p, pend, res->end, num_spec);
 	*p++ = ']';
 	*p = 0;
 
-	return string(buf, end, sym, field_width, precision, flags);
+	return string(buf, end, sym, spec);
 }
 
-static char *mac_address_string(char *buf, char *end, u8 *addr, int field_width,
-				int precision, int flags)
+static char *mac_address_string(char *buf, char *end, u8 *addr,
+				struct printf_spec spec)
 {
 	char mac_addr[6 * 3]; /* (6 * 2 hex digits), 5 colons and trailing zero */
 	char *p = mac_addr;
@@ -594,16 +633,17 @@ static char *mac_address_string(char *buf, char *end, u8 *addr, int field_width,
 
 	for (i = 0; i < 6; i++) {
 		p = pack_hex_byte(p, addr[i]);
-		if (!(flags & SPECIAL) && i != 5)
+		if (!(spec.flags & SPECIAL) && i != 5)
 			*p++ = ':';
 	}
 	*p = '\0';
+	spec.flags &= ~SPECIAL;
 
-	return string(buf, end, mac_addr, field_width, precision, flags & ~SPECIAL);
+	return string(buf, end, mac_addr, spec);
 }
 
-static char *ip6_addr_string(char *buf, char *end, u8 *addr, int field_width,
-			 int precision, int flags)
+static char *ip6_addr_string(char *buf, char *end, u8 *addr,
+				struct printf_spec spec)
 {
 	char ip6_addr[8 * 5]; /* (8 * 4 hex digits), 7 colons and trailing zero */
 	char *p = ip6_addr;
@@ -612,16 +652,17 @@ static char *ip6_addr_string(char *buf, char *end, u8 *addr, int field_width,
 	for (i = 0; i < 8; i++) {
 		p = pack_hex_byte(p, addr[2 * i]);
 		p = pack_hex_byte(p, addr[2 * i + 1]);
-		if (!(flags & SPECIAL) && i != 7)
+		if (!(spec.flags & SPECIAL) && i != 7)
 			*p++ = ':';
 	}
 	*p = '\0';
+	spec.flags &= ~SPECIAL;
 
-	return string(buf, end, ip6_addr, field_width, precision, flags & ~SPECIAL);
+	return string(buf, end, ip6_addr, spec);
 }
 
-static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
-			 int precision, int flags)
+static char *ip4_addr_string(char *buf, char *end, u8 *addr,
+				struct printf_spec spec)
 {
 	char ip4_addr[4 * 4]; /* (4 * 3 decimal digits), 3 dots and trailing zero */
 	char temp[3];	/* hold each IP quad in reverse order */
@@ -637,8 +678,9 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
 			*p++ = '.';
 	}
 	*p = '\0';
+	spec.flags &= ~SPECIAL;
 
-	return string(buf, end, ip4_addr, field_width, precision, flags & ~SPECIAL);
+	return string(buf, end, ip4_addr, spec);
 }
 
 /*
@@ -663,41 +705,233 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
+static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
+			struct printf_spec spec)
 {
 	if (!ptr)
-		return string(buf, end, "(null)", field_width, precision, flags);
+		return string(buf, end, "(null)", spec);
 
 	switch (*fmt) {
 	case 'F':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
 	case 'S':
-		return symbol_string(buf, end, ptr, field_width, precision, flags);
+		return symbol_string(buf, end, ptr, spec);
 	case 'R':
-		return resource_string(buf, end, ptr, field_width, precision, flags);
+		return resource_string(buf, end, ptr, spec);
 	case 'm':
-		flags |= SPECIAL;
+		spec.flags |= SPECIAL;
 		/* Fallthrough */
 	case 'M':
-		return mac_address_string(buf, end, ptr, field_width, precision, flags);
+		return mac_address_string(buf, end, ptr, spec);
 	case 'i':
-		flags |= SPECIAL;
+		spec.flags |= SPECIAL;
 		/* Fallthrough */
 	case 'I':
 		if (fmt[1] == '6')
-			return ip6_addr_string(buf, end, ptr, field_width, precision, flags);
+			return ip6_addr_string(buf, end, ptr, spec);
 		if (fmt[1] == '4')
-			return ip4_addr_string(buf, end, ptr, field_width, precision, flags);
-		flags &= ~SPECIAL;
+			return ip4_addr_string(buf, end, ptr, spec);
+		spec.flags &= ~SPECIAL;
+		break;
+	}
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2*sizeof(void *);
+		spec.flags |= ZEROPAD;
+	}
+	spec.base = 16;
+
+	return number(buf, end, (unsigned long) ptr, spec);
+}
+
+/*
+ * Helper function to decode printf style format.
+ * Each call decode a token from the format and return the
+ * number of characters read (or likely the delta where it wants
+ * to go on the next call).
+ * The decoded token is returned through the parameters
+ *
+ * 'h', 'l', or 'L' for integer fields
+ * 'z' support added 23/7/1999 S.H.
+ * 'z' changed to 'Z' --davidm 1/25/99
+ * 't' added for ptrdiff_t
+ *
+ * @fmt: the format string
+ * @type of the token returned
+ * @flags: various flags such as +, -, # tokens..
+ * @field_width: overwritten width
+ * @base: base of the number (octal, hex, ...)
+ * @precision: precision of a number
+ * @qualifier: qualifier of a number (long, size_t, ...)
+ */
+static int format_decode(const char *fmt, struct printf_spec *spec)
+{
+	const char *start = fmt;
+
+	/* we finished early by reading the field width */
+	if (spec->type == FORMAT_TYPE_WIDTH) {
+		if (spec->field_width < 0) {
+			spec->field_width = -spec->field_width;
+			spec->flags |= LEFT;
+		}
+		spec->type = FORMAT_TYPE_NONE;
+		goto precision;
+	}
+
+	/* we finished early by reading the precision */
+	if (spec->type == FORMAT_TYPE_PRECISION) {
+		if (spec->precision < 0)
+			spec->precision = 0;
+
+		spec->type = FORMAT_TYPE_NONE;
+		goto qualifier;
+	}
+
+	/* By default */
+	spec->type = FORMAT_TYPE_NONE;
+
+	for (; *fmt ; ++fmt) {
+		if (*fmt == '%')
+			break;
+	}
+
+	/* Return the current non-format string */
+	if (fmt != start || !*fmt)
+		return fmt - start;
+
+	/* Process flags */
+	spec->flags = 0;
+
+	while (1) { /* this also skips first '%' */
+		bool found = true;
+
+		++fmt;
+
+		switch (*fmt) {
+		case '-': spec->flags |= LEFT;    break;
+		case '+': spec->flags |= PLUS;    break;
+		case ' ': spec->flags |= SPACE;   break;
+		case '#': spec->flags |= SPECIAL; break;
+		case '0': spec->flags |= ZEROPAD; break;
+		default:  found = false;
+		}
+
+		if (!found)
+			break;
+	}
+
+	/* get field width */
+	spec->field_width = -1;
+
+	if (isdigit(*fmt))
+		spec->field_width = skip_atoi(&fmt);
+	else if (*fmt == '*') {
+		/* it's the next argument */
+		spec->type = FORMAT_TYPE_WIDTH;
+		return ++fmt - start;
+	}
+
+precision:
+	/* get the precision */
+	spec->precision = -1;
+	if (*fmt == '.') {
+		++fmt;
+		if (isdigit(*fmt)) {
+			spec->precision = skip_atoi(&fmt);
+			if (spec->precision < 0)
+				spec->precision = 0;
+		} else if (*fmt == '*') {
+			/* it's the next argument */
+			spec->type = FORMAT_TYPE_PRECISION;
+			return ++fmt - start;
+		}
+	}
+
+qualifier:
+	/* get the conversion qualifier */
+	spec->qualifier = -1;
+	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
+	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+		spec->qualifier = *fmt;
+		++fmt;
+		if (spec->qualifier == 'l' && *fmt == 'l') {
+			spec->qualifier = 'L';
+			++fmt;
+		}
+	}
+
+	/* default base */
+	spec->base = 10;
+	switch (*fmt) {
+	case 'c':
+		spec->type = FORMAT_TYPE_CHAR;
+		return ++fmt - start;
+
+	case 's':
+		spec->type = FORMAT_TYPE_STR;
+		return ++fmt - start;
+
+	case 'p':
+		spec->type = FORMAT_TYPE_PTR;
+		return fmt - start;
+		/* skip alnum */
+
+	case 'n':
+		spec->type = FORMAT_TYPE_NRCHARS;
+		return ++fmt - start;
+
+	case '%':
+		spec->type = FORMAT_TYPE_PERCENT_CHAR;
+		return ++fmt - start;
+
+	/* integer number formats - set up the flags and "break" */
+	case 'o':
+		spec->base = 8;
 		break;
+
+	case 'x':
+		spec->flags |= SMALL;
+
+	case 'X':
+		spec->base = 16;
+		break;
+
+	case 'd':
+	case 'i':
+		spec->flags |= SIGN;
+	case 'u':
+		break;
+
+	default:
+		spec->type = FORMAT_TYPE_INVALID;
+		return fmt - start;
 	}
-	flags |= SMALL;
-	if (field_width == -1) {
-		field_width = 2*sizeof(void *);
-		flags |= ZEROPAD;
+
+	if (spec->qualifier == 'L')
+		spec->type = FORMAT_TYPE_LONG_LONG;
+	else if (spec->qualifier == 'l') {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_LONG;
+		else
+			spec->type = FORMAT_TYPE_ULONG;
+	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
+		spec->type = FORMAT_TYPE_SIZE_T;
+	} else if (spec->qualifier == 't') {
+		spec->type = FORMAT_TYPE_PTRDIFF;
+	} else if (spec->qualifier == 'h') {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_SHORT;
+		else
+			spec->type = FORMAT_TYPE_USHORT;
+	} else {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_INT;
+		else
+			spec->type = FORMAT_TYPE_UINT;
 	}
-	return number(buf, end, (unsigned long) ptr, 16, field_width, precision, flags);
+
+	return ++fmt - start;
 }
 
 /**
@@ -726,18 +960,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	int base;
 	char *str, *end, c;
-
-	int flags;		/* flags to number() */
-
-	int field_width;	/* width of output field */
-	int precision;		/* min. # of digits for integers; max
-				   number of chars for from string */
-	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
-				/* 'z' support added 23/7/1999 S.H.    */
-				/* 'z' changed to 'Z' --davidm 1/25/99 */
-				/* 't' added for ptrdiff_t */
+	int read;
+	struct printf_spec spec = {0};
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
@@ -758,184 +983,144 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		size = end - buf;
 	}
 
-	for (; *fmt ; ++fmt) {
-		if (*fmt != '%') {
-			if (str < end)
-				*str = *fmt;
-			++str;
-			continue;
-		}
+	while (*fmt) {
+		const char *old_fmt = fmt;
 
-		/* process flags */
-		flags = 0;
-		repeat:
-			++fmt;		/* this also skips first '%' */
-			switch (*fmt) {
-				case '-': flags |= LEFT; goto repeat;
-				case '+': flags |= PLUS; goto repeat;
-				case ' ': flags |= SPACE; goto repeat;
-				case '#': flags |= SPECIAL; goto repeat;
-				case '0': flags |= ZEROPAD; goto repeat;
-			}
+		read = format_decode(fmt, &spec);
 
-		/* get field width */
-		field_width = -1;
-		if (isdigit(*fmt))
-			field_width = skip_atoi(&fmt);
-		else if (*fmt == '*') {
-			++fmt;
-			/* it's the next argument */
-			field_width = va_arg(args, int);
-			if (field_width < 0) {
-				field_width = -field_width;
-				flags |= LEFT;
-			}
-		}
+		fmt += read;
 
-		/* get the precision */
-		precision = -1;
-		if (*fmt == '.') {
-			++fmt;	
-			if (isdigit(*fmt))
-				precision = skip_atoi(&fmt);
-			else if (*fmt == '*') {
-				++fmt;
-				/* it's the next argument */
-				precision = va_arg(args, int);
+		switch (spec.type) {
+		case FORMAT_TYPE_NONE: {
+			int copy = read;
+			if (str < end) {
+				if (copy > end - str)
+					copy = end - str;
+				memcpy(str, old_fmt, copy);
 			}
-			if (precision < 0)
-				precision = 0;
+			str += read;
+			break;
 		}
 
-		/* get the conversion qualifier */
-		qualifier = -1;
-		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-		    *fmt =='Z' || *fmt == 'z' || *fmt == 't') {
-			qualifier = *fmt;
-			++fmt;
-			if (qualifier == 'l' && *fmt == 'l') {
-				qualifier = 'L';
-				++fmt;
-			}
-		}
+		case FORMAT_TYPE_WIDTH:
+			spec.field_width = va_arg(args, int);
+			break;
 
-		/* default base */
-		base = 10;
+		case FORMAT_TYPE_PRECISION:
+			spec.precision = va_arg(args, int);
+			break;
 
-		switch (*fmt) {
-			case 'c':
-				if (!(flags & LEFT)) {
-					while (--field_width > 0) {
-						if (str < end)
-							*str = ' ';
-						++str;
-					}
-				}
-				c = (unsigned char) va_arg(args, int);
-				if (str < end)
-					*str = c;
-				++str;
-				while (--field_width > 0) {
+		case FORMAT_TYPE_CHAR:
+			if (!(spec.flags & LEFT)) {
+				while (--spec.field_width > 0) {
 					if (str < end)
 						*str = ' ';
 					++str;
-				}
-				continue;
-
-			case 's':
-				str = string(str, end, va_arg(args, char *), field_width, precision, flags);
-				continue;
-
-			case 'p':
-				str = pointer(fmt+1, str, end,
-						va_arg(args, void *),
-						field_width, precision, flags);
-				/* Skip all alphanumeric pointer suffixes */
-				while (isalnum(fmt[1]))
-					fmt++;
-				continue;
-
-			case 'n':
-				/* FIXME:
-				* What does C99 say about the overflow case here? */
-				if (qualifier == 'l') {
-					long * ip = va_arg(args, long *);
-					*ip = (str - buf);
-				} else if (qualifier == 'Z' || qualifier == 'z') {
-					size_t * ip = va_arg(args, size_t *);
-					*ip = (str - buf);
-				} else {
-					int * ip = va_arg(args, int *);
-					*ip = (str - buf);
-				}
-				continue;
 
-			case '%':
+				}
+			}
+			c = (unsigned char) va_arg(args, int);
+			if (str < end)
+				*str = c;
+			++str;
+			while (--spec.field_width > 0) {
 				if (str < end)
-					*str = '%';
+					*str = ' ';
 				++str;
-				continue;
+			}
+			break;
 
-				/* integer number formats - set up the flags and "break" */
-			case 'o':
-				base = 8;
-				break;
+		case FORMAT_TYPE_STR:
+			str = string(str, end, va_arg(args, char *), spec);
+			break;
 
-			case 'x':
-				flags |= SMALL;
-			case 'X':
-				base = 16;
-				break;
+		case FORMAT_TYPE_PTR:
+			str = pointer(fmt+1, str, end, va_arg(args, void *),
+				      spec);
+			while (isalnum(*fmt))
+				fmt++;
+			break;
 
-			case 'd':
-			case 'i':
-				flags |= SIGN;
-			case 'u':
-				break;
+		case FORMAT_TYPE_PERCENT_CHAR:
+			if (str < end)
+				*str = '%';
+			++str;
+			break;
 
-			default:
+		case FORMAT_TYPE_INVALID:
+			if (str < end)
+				*str = '%';
+			++str;
+			if (*fmt) {
 				if (str < end)
-					*str = '%';
+					*str = *fmt;
 				++str;
-				if (*fmt) {
-					if (str < end)
-						*str = *fmt;
-					++str;
-				} else {
-					--fmt;
-				}
-				continue;
+			} else {
+				--fmt;
+			}
+			break;
+
+		case FORMAT_TYPE_NRCHARS: {
+			int qualifier = spec.qualifier;
+
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else if (qualifier == 'Z' ||
+					qualifier == 'z') {
+				size_t *ip = va_arg(args, size_t *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			break;
 		}
-		if (qualifier == 'L')
-			num = va_arg(args, long long);
-		else if (qualifier == 'l') {
-			num = va_arg(args, unsigned long);
-			if (flags & SIGN)
-				num = (signed long) num;
-		} else if (qualifier == 'Z' || qualifier == 'z') {
-			num = va_arg(args, size_t);
-		} else if (qualifier == 't') {
-			num = va_arg(args, ptrdiff_t);
-		} else if (qualifier == 'h') {
-			num = (unsigned short) va_arg(args, int);
-			if (flags & SIGN)
-				num = (signed short) num;
-		} else {
-			num = va_arg(args, unsigned int);
-			if (flags & SIGN)
-				num = (signed int) num;
+
+		default:
+			switch (spec.type) {
+			case FORMAT_TYPE_LONG_LONG:
+				num = va_arg(args, long long);
+				break;
+			case FORMAT_TYPE_ULONG:
+				num = va_arg(args, unsigned long);
+				break;
+			case FORMAT_TYPE_LONG:
+				num = va_arg(args, long);
+				break;
+			case FORMAT_TYPE_SIZE_T:
+				num = va_arg(args, size_t);
+				break;
+			case FORMAT_TYPE_PTRDIFF:
+				num = va_arg(args, ptrdiff_t);
+				break;
+			case FORMAT_TYPE_USHORT:
+				num = (unsigned short) va_arg(args, int);
+				break;
+			case FORMAT_TYPE_SHORT:
+				num = (short) va_arg(args, int);
+				break;
+			case FORMAT_TYPE_INT:
+				num = (int) va_arg(args, int);
+				break;
+			default:
+				num = va_arg(args, unsigned int);
+			}
+
+			str = number(str, end, num, spec);
 		}
-		str = number(str, end, num, base,
-				field_width, precision, flags);
 	}
+
 	if (size > 0) {
 		if (str < end)
 			*str = '\0';
 		else
 			end[-1] = '\0';
 	}
+
 	/* the trailing null byte doesn't count towards the total */
 	return str-buf;
+
 }
 EXPORT_SYMBOL(vsnprintf);
 
@@ -1058,6 +1243,372 @@ int sprintf(char * buf, const char *fmt, ...)
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
+	struct printf_spec spec = {0};
+	char *str, *end;
+	int read;
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
+
+	while (*fmt) {
+		read = format_decode(fmt, &spec);
+
+		fmt += read;
+
+		switch (spec.type) {
+		case FORMAT_TYPE_NONE:
+			break;
+
+		case FORMAT_TYPE_WIDTH:
+		case FORMAT_TYPE_PRECISION:
+			save_arg(int);
+			break;
+
+		case FORMAT_TYPE_CHAR:
+			save_arg(char);
+			break;
+
+		case FORMAT_TYPE_STR: {
+			const char *save_str = va_arg(args, char *);
+			size_t len;
+			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
+					|| (unsigned long)save_str < PAGE_SIZE)
+				save_str = "<NULL>";
+			len = strlen(save_str);
+			if (str + len + 1 < end)
+				memcpy(str, save_str, len + 1);
+			str += len + 1;
+			break;
+		}
+
+		case FORMAT_TYPE_PTR:
+			save_arg(void *);
+			/* skip all alphanumeric pointer suffixes */
+			while (isalnum(*fmt))
+				fmt++;
+			break;
+
+		case FORMAT_TYPE_PERCENT_CHAR:
+			break;
+
+		case FORMAT_TYPE_INVALID:
+			if (!*fmt)
+				--fmt;
+			break;
+
+		case FORMAT_TYPE_NRCHARS: {
+			/* skip %n 's argument */
+			int qualifier = spec.qualifier;
+			void *skip_arg;
+			if (qualifier == 'l')
+				skip_arg = va_arg(args, long *);
+			else if (qualifier == 'Z' || qualifier == 'z')
+				skip_arg = va_arg(args, size_t *);
+			else
+				skip_arg = va_arg(args, int *);
+			break;
+		}
+
+		default:
+			switch (spec.type) {
+
+			case FORMAT_TYPE_LONG_LONG:
+				save_arg(long long);
+				break;
+			case FORMAT_TYPE_ULONG:
+			case FORMAT_TYPE_LONG:
+				save_arg(unsigned long);
+				break;
+			case FORMAT_TYPE_SIZE_T:
+				save_arg(size_t);
+				break;
+			case FORMAT_TYPE_PTRDIFF:
+				save_arg(ptrdiff_t);
+				break;
+			case FORMAT_TYPE_USHORT:
+			case FORMAT_TYPE_SHORT:
+				save_arg(short);
+				break;
+			default:
+				save_arg(int);
+			}
+		}
+	}
+	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
+
+#undef save_arg
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
+	char *str, *end, c;
+	const char *args = (const char *)bin_buf;
+
+	struct printf_spec spec = {0};
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
+	while (*fmt) {
+		int read;
+		const char *old_fmt = fmt;
+
+		read = format_decode(fmt, &spec);
+
+		fmt += read;
+
+		switch (spec.type) {
+		case FORMAT_TYPE_NONE: {
+			int copy = read;
+			if (str < end) {
+				if (copy > end - str)
+					copy = end - str;
+				memcpy(str, old_fmt, copy);
+			}
+			str += read;
+			break;
+		}
+
+		case FORMAT_TYPE_WIDTH:
+			spec.field_width = get_arg(int);
+			break;
+
+		case FORMAT_TYPE_PRECISION:
+			spec.precision = get_arg(int);
+			break;
+
+		case FORMAT_TYPE_CHAR:
+			if (!(spec.flags & LEFT)) {
+				while (--spec.field_width > 0) {
+					if (str < end)
+						*str = ' ';
+					++str;
+				}
+			}
+			c = (unsigned char) get_arg(char);
+			if (str < end)
+				*str = c;
+			++str;
+			while (--spec.field_width > 0) {
+				if (str < end)
+					*str = ' ';
+				++str;
+			}
+			break;
+
+		case FORMAT_TYPE_STR: {
+			const char *str_arg = args;
+			size_t len = strlen(str_arg);
+			args += len + 1;
+			str = string(str, end, (char *)str_arg, spec);
+			break;
+		}
+
+		case FORMAT_TYPE_PTR:
+			str = pointer(fmt+1, str, end, get_arg(void *), spec);
+			while (isalnum(*fmt))
+				fmt++;
+			break;
+
+		case FORMAT_TYPE_PERCENT_CHAR:
+			if (str < end)
+				*str = '%';
+			++str;
+			break;
+
+		case FORMAT_TYPE_INVALID:
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
+			break;
+
+		case FORMAT_TYPE_NRCHARS:
+			/* skip */
+			break;
+
+		default:
+			switch (spec.type) {
+
+			case FORMAT_TYPE_LONG_LONG:
+				num = get_arg(long long);
+				break;
+			case FORMAT_TYPE_ULONG:
+				num = get_arg(unsigned long);
+				break;
+			case FORMAT_TYPE_LONG:
+				num = get_arg(unsigned long);
+				break;
+			case FORMAT_TYPE_SIZE_T:
+				num = get_arg(size_t);
+				break;
+			case FORMAT_TYPE_PTRDIFF:
+				num = get_arg(ptrdiff_t);
+				break;
+			case FORMAT_TYPE_USHORT:
+				num = get_arg(unsigned short);
+				break;
+			case FORMAT_TYPE_SHORT:
+				num = get_arg(short);
+				break;
+			case FORMAT_TYPE_UINT:
+				num = get_arg(unsigned int);
+				break;
+			default:
+				num = get_arg(int);
+			}
+
+			str = number(str, end, num, spec);
+		}
+	}
+
+	if (size > 0) {
+		if (str < end)
+			*str = '\0';
+		else
+			end[-1] = '\0';
+	}
+
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
