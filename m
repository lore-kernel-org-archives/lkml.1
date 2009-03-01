Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZCAECf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZCAECf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 23:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZCAEBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 23:01:47 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:64137 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbZCAEBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 23:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:from:date:subject:to:cc;
        b=BzSMHeUsRqd6U963ZzEbW3i/F0oIYatw6DCalbjoFiXh3Xdvj/sc5YHAbWcirgqJW3
         ybB22m1LCfWOjobhBzbeWkpVO5E/4fHCp9Kj2KflzbAgia37D0kzQVXjbQeAQ5WtPbpI
         3Qr4csZrSvOy/JopWyuuH5NCsGuplIFEEFprs=
Message-ID: <49aa08a4.1818d00a.5416.69de@mx.google.com>
In-Reply-To: <20090228091305.GA20533@elte.hu>
References: <20090228091305.GA20533@elte.hu>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 1 Mar 2009 03:34:10 +0100
Subject: [PATCH 5/5 v3] vsprintf: unify the format decoding layer for its 3 users
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An new optimization is making its way to ftrace. Its purpose is to
make ftrace_printk() consuming less memory and be faster.

Written by Lai Jiangshan, the approach is to delay the formatting
job from tracing time to output time.
Currently, a call to ftrace_printk will format the whole string and
insert it into the ring buffer. Then you can read it on /debug/tracing/trace
file.

The new implementation stores the address of the format string and
the binary parameters into the ring buffer, making the packet more compact
and faster to insert.
Later, when the user exports the traces, the format string is retrieved
with the binary parameters and the formatting job is eventually done.

The new implementation rewrites a lot of format decoding bits from
vsnprintf() function, making now 3 differents functions to maintain
in their duplicated parts of printf format decoding bits.

Suggested by Ingo Molnar, this patch tries to factorize the most
possible common bits from these functions.
The real common part between them is the format decoding. Although
they do somewhat similar jobs, their way to export or import the parameters
is very different. Thus, only the decoding layer is extracted, unless you see
other parts that could be worth factorized.

Changes in V2:

- Address a suggestion from Linus to group the format_decode() parameters inside
  a structure.

Changes in v3:

- Address other cleanups suggested by Ingo and Linus such as passing the
  printf_spec struct to the format helpers: pointer()/number()/string()
  Note that this struct is passed by copy and not by address. This is to
  avoid side effects because these functions often change these values and the
  changes shoudn't be persistant when a callee helper returns.
  It would be too risky.

- Various cleanups (code alignement, switch/case instead of if/else fountains).

- Fix a bug that printed the first format specifier following a %p


Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |  976 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 543 insertions(+), 433 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3543bbe..af7a055 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -396,7 +396,38 @@ static noinline char* put_dec(char *buf, unsigned long long num)
 #define SMALL	32		/* Must be 32 == 0x20 */
 #define SPECIAL	64		/* 0x */
 
-static char *number(char *buf, char *end, unsigned long long num, int base, int size, int precision, int type)
+enum format_type {
+	FORMAT_TYPE_NONE, /* Just a string part */
+	FORMAT_TYPE_WITDH,
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
@@ -663,41 +705,234 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr, int field_width,
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
+	bool sign = false;
+
+	/* we finished early by reading the field width */
+	if (spec->type == FORMAT_TYPE_WITDH) {
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
+		spec->type = FORMAT_TYPE_WITDH;
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
+			spec->type = FORMAT_TYPE_WITDH;
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
+		sign = true;
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
+		if (sign)
+			spec->type = FORMAT_TYPE_LONG;
+		else
+			spec->type = FORMAT_TYPE_ULONG;
+	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
+		spec->type = FORMAT_TYPE_SIZE_T;
+	} else if (spec->qualifier == 't') {
+		spec->type = FORMAT_TYPE_PTRDIFF;
+	} else if (spec->qualifier == 'h') {
+		if (sign)
+			spec->type = FORMAT_TYPE_SHORT;
+		else
+			spec->type = FORMAT_TYPE_USHORT;
+	} else {
+		if (sign)
+			spec->type = FORMAT_TYPE_INT;
+		else
+			spec->type = FORMAT_TYPE_UINT;
 	}
-	return number(buf, end, (unsigned long) ptr, 16, field_width, precision, flags);
+
+	return ++fmt - start;
 }
 
 /**
@@ -726,18 +961,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
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
@@ -758,184 +984,144 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
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
+		char *old_fmt = (char *)fmt;
 
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
+		case FORMAT_TYPE_WITDH:
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
+			case FORMAT_TYPE_UINT:
+				num = va_arg(args, unsigned int);
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
 
@@ -1084,8 +1270,9 @@ EXPORT_SYMBOL(sprintf);
  */
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
 {
+	struct printf_spec spec = {0};
 	char *str, *end;
-	int qualifier;
+	int read;
 
 	str = (char *)bin_buf;
 	end = (char *)(bin_buf + size);
@@ -1110,57 +1297,26 @@ do {									\
 	str += sizeof(type);						\
 } while (0)
 
-	for (; *fmt ; ++fmt) {
-		if (*fmt != '%')
-			continue;
 
-repeat:
-		/* parse flags */
-		++fmt;		/* this also skips first '%' */
-		if (*fmt == '-' || *fmt == '+' || *fmt == ' '
-				|| *fmt == '#' || *fmt == '0')
-			goto repeat;
+	while (*fmt) {
+		read = format_decode(fmt, &spec);
 
-		/* parse field width */
-		if (isdigit(*fmt))
-			skip_atoi(&fmt);
-		else if (*fmt == '*') {
-			++fmt;
-			/* it's the next argument */
-			save_arg(int);
-		}
+		fmt += read;
 
-		/* parse the precision */
-		if (*fmt == '.') {
-			++fmt;
-			if (isdigit(*fmt))
-				skip_atoi(&fmt);
-			else if (*fmt == '*') {
-				++fmt;
-				/* it's the next argument */
-				save_arg(int);
-			}
-		}
+		switch (spec.type) {
+		case FORMAT_TYPE_NONE:
+			break;
 
-		/* parse the conversion qualifier */
-		qualifier = -1;
-		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-		    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
-			qualifier = *fmt;
-			++fmt;
-			if (qualifier == 'l' && *fmt == 'l') {
-				qualifier = 'L';
-				++fmt;
-			}
-		}
+		case FORMAT_TYPE_WITDH:
+		case FORMAT_TYPE_PRECISION:
+			save_arg(int);
+			break;
 
-		/* parse format type */
-		switch (*fmt) {
-		case 'c':
+		case FORMAT_TYPE_CHAR:
 			save_arg(char);
-			continue;
-		case 's': {
-			/* save the string argument */
+			break;
+
+		case FORMAT_TYPE_STR: {
 			const char *save_str = va_arg(args, char *);
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
@@ -1170,16 +1326,27 @@ repeat:
 			if (str + len + 1 < end)
 				memcpy(str, save_str, len + 1);
 			str += len + 1;
-			continue;
+			break;
 		}
-		case 'p':
+
+		case FORMAT_TYPE_PTR:
 			save_arg(void *);
 			/* skip all alphanumeric pointer suffixes */
-			while (isalnum(fmt[1]))
+			while (isalnum(*fmt))
 				fmt++;
-			continue;
-		case 'n': {
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
 			/* skip %n 's argument */
+			int qualifier = spec.qualifier;
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
@@ -1187,37 +1354,37 @@ repeat:
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
-			continue;
+			break;
 		}
-		case 'o':
-		case 'x':
-		case 'X':
-		case 'd':
-		case 'i':
-		case 'u':
-			/* save arg for case: 'o', 'x', 'X', 'd', 'i', 'u' */
-			if (qualifier == 'L')
+
+		default:
+			switch (spec.type) {
+
+			case FORMAT_TYPE_LONG_LONG:
 				save_arg(long long);
-			else if (qualifier == 'l')
+				break;
+			case FORMAT_TYPE_ULONG:
+			case FORMAT_TYPE_LONG:
 				save_arg(unsigned long);
-			else if (qualifier == 'Z' || qualifier == 'z')
+				break;
+			case FORMAT_TYPE_SIZE_T:
 				save_arg(size_t);
-			else if (qualifier == 't')
+				break;
+			case FORMAT_TYPE_PTRDIFF:
 				save_arg(ptrdiff_t);
-			else if (qualifier == 'h')
+				break;
+			case FORMAT_TYPE_USHORT:
+			case FORMAT_TYPE_SHORT:
 				save_arg(short);
-			else
+				break;
+			default:
 				save_arg(int);
-			continue;
-		default:
-			if (!*fmt)
-				--fmt;
-			continue;
+			}
 		}
 	}
-#undef save_arg
-
 	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
+
+#undef save_arg
 }
 EXPORT_SYMBOL_GPL(vbin_printf);
 
@@ -1249,14 +1416,10 @@ EXPORT_SYMBOL_GPL(vbin_printf);
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 {
 	unsigned long long num;
-	int base;
 	char *str, *end, c;
 	const char *args = (const char *)bin_buf;
 
-	int flags;
-	int field_width;
-	int precision;
-	int qualifier;
+	struct printf_spec spec = {0};
 
 	if (unlikely((int) size < 0)) {
 		/* There can be only one.. */
@@ -1290,84 +1453,37 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
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
+		int read;
+		char *old_fmt = (char *)fmt;
 
-		/* process flags */
-		flags = 0;
-repeat:
-		++fmt;		/* this also skips first '%' */
-		switch (*fmt) {
-		case '-':
-			flags |= LEFT;
-			goto repeat;
-		case '+':
-			flags |= PLUS;
-			goto repeat;
-		case ' ':
-			flags |= SPACE;
-			goto repeat;
-		case '#':
-			flags |= SPECIAL;
-			goto repeat;
-		case '0':
-			flags |= ZEROPAD;
-			goto repeat;
-		}
+		read = format_decode(fmt, &spec);
 
-		/* get field width */
-		field_width = -1;
-		if (isdigit(*fmt))
-			field_width = skip_atoi(&fmt);
-		else if (*fmt == '*') {
-			++fmt;
-			/* it's the next argument */
-			field_width = get_arg(int);
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
-				precision = get_arg(int);
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
-		    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
-			qualifier = *fmt;
-			++fmt;
-			if (qualifier == 'l' && *fmt == 'l') {
-				qualifier = 'L';
-				++fmt;
-			}
-		}
+		case FORMAT_TYPE_WITDH:
+			spec.field_width = get_arg(int);
+			break;
 
-		/* default base */
-		base = 10;
+		case FORMAT_TYPE_PRECISION:
+			spec.precision = get_arg(int);
+			break;
 
-		switch (*fmt) {
-		case 'c':
-			if (!(flags & LEFT)) {
-				while (--field_width > 0) {
+		case FORMAT_TYPE_CHAR:
+			if (!(spec.flags & LEFT)) {
+				while (--spec.field_width > 0) {
 					if (str < end)
 						*str = ' ';
 					++str;
@@ -1377,58 +1493,34 @@ repeat:
 			if (str < end)
 				*str = c;
 			++str;
-			while (--field_width > 0) {
+			while (--spec.field_width > 0) {
 				if (str < end)
 					*str = ' ';
 				++str;
 			}
-			continue;
+			break;
 
-		case 's':{
+		case FORMAT_TYPE_STR: {
 			const char *str_arg = args;
 			size_t len = strlen(str_arg);
 			args += len + 1;
-			str = string(str, end, (char *)str_arg, field_width,
-					precision, flags);
-			continue;
+			str = string(str, end, (char *)str_arg, spec);
+			break;
 		}
 
-		case 'p':
-			str = pointer(fmt+1, str, end, get_arg(void *),
-					field_width, precision, flags);
-			/* Skip all alphanumeric pointer suffixes */
-			while (isalnum(fmt[1]))
+		case FORMAT_TYPE_PTR:
+			str = pointer(fmt+1, str, end, get_arg(void *), spec);
+			while (isalnum(*fmt))
 				fmt++;
-			continue;
-
-		case 'n':
-			/* skip %n */
-			continue;
+			break;
 
-		case '%':
+		case FORMAT_TYPE_PERCENT_CHAR:
 			if (str < end)
 				*str = '%';
 			++str;
-			continue;
-
-		/* integer number formats - set up the flags and "break" */
-		case 'o':
-			base = 8;
-			break;
-
-		case 'x':
-			flags |= SMALL;
-		case 'X':
-			base = 16;
 			break;
 
-		case 'd':
-		case 'i':
-			flags |= SIGN;
-		case 'u':
-			break;
-
-		default:
+		case FORMAT_TYPE_INVALID:
 			if (str < end)
 				*str = '%';
 			++str;
@@ -1439,36 +1531,54 @@ repeat:
 			} else {
 				--fmt;
 			}
-			continue;
-		}
-		if (qualifier == 'L')
-			num = get_arg(long long);
-		else if (qualifier == 'l') {
-			num = get_arg(unsigned long);
-			if (flags & SIGN)
-				num = (signed long) num;
-		} else if (qualifier == 'Z' || qualifier == 'z') {
-			num = get_arg(size_t);
-		} else if (qualifier == 't') {
-			num = get_arg(ptrdiff_t);
-		} else if (qualifier == 'h') {
-			num = (unsigned short) get_arg(short);
-			if (flags & SIGN)
-				num = (signed short) num;
-		} else {
-			num = get_arg(unsigned int);
-			if (flags & SIGN)
-				num = (signed int) num;
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
 #undef get_arg
 
 	/* the trailing null byte doesn't count towards the total */
-- 
1.6.1


