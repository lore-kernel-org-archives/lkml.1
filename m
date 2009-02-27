Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZB0GUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZB0GUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZB0GTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:19:51 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:51620 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZB0GTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UYnWXNUiEqU2v9zTqv/ZlVnndQLbs588k0pTzrcEAzIn+ckbo6VEnDDjMaMNWcNNf/
         pdaeEC+Hm5EOtHhdzPoukcBdJl+GpoU3cLWlo6rXpp+nQfDfw7EiEuEnRWIB3GdbpX+t
         PAEFBn+yAncL0/kmq5lCcHYv5BBnt9vE+97vA=
Date: Fri, 27 Feb 2009 07:19:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH][RFC] vsprintf: unify the format decoding layer for its 3
	users
Message-ID: <20090227061936.GA5318@nowhere>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226185635.GA12895@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 07:56:35PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Instead of calling the in/out helper from the decoder, why not 
> > calling the decoder from these three functions and let them 
> > take the appropriate actions for each decoded format token?
> > 
> > Naive example:
> > 
> > bstr_printf() {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			read_number_from_buf()
> > 			str = number(....)
> > 		....
> > }
> > 
> > vsnprintf {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			var_arg(...)
> > 			str = number(....)
> > 		....
> > }
> > 
> > vbin_printf {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			var_arg(...)
> > 			write_number_to_buffer()
> > 		...
> > }
> > 
> > And the standard in/out pieces can be invoked through helpers.
> 
> ok, that looks rather clean too. And maybe vsnprintf() and 
> bstr_printf() could be further unified?
> 
> I guess it depends on how it all looks like in the end. Only one 
> way to find out ...
> 
> 	Ingo


Ok, here is a try, I've mostly unified the format decoding bits.
Most interesting other helpers were already implemented (pointer(),
string() and number()

Note: it is based on top of Lai's work, which means you will need the ftrace_bprintk()
patches if you want to give it a try.

I've tested it successfully (through the usual printk messages and the events tracing).

---
Subject: [PATCH][RFC] vsprintf: unify the format decoding layer for its 3 users


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

Here is the result of a small comparative benchmark while putting the following
ftrace_printk on the timer interrupt. ftrace_printk is the old implementation,
ftrace_bprintk is a the new one:

ftrace_printk("This is the timer interrupt: %llu", jiffies_64);

After some time running on low load (no X, no really active processes):

ftrace_printk:  duration average: 2044 ns, avg of bytes stored per entry: 39
ftrace_bprintk: duration average: 1426 ns, avg of bytes stored per entry: 16

Higher load (started X and launched a cat running on an X console looping on
traces printing):

ftrace_printk:  duration average: 8812 ns
ftrace_bprintk: duration average: 2611 ns

Which means the new implementation can be 70 % faster on higher load.
And it consumes lesser memory on the ring buffer.

The curent implementation rewrites a lot of format decoding bits from
vsnprintf() function, making now 3 differents functions to maintain
in their duplicated parts of printf format decoding bits.

Suggested by Ingo Molnar, this patch tries to factorize the most
possible common bits from these functions.
The real common part between them is the format decoding. Although
they do somewhat similar jobs, their way to export or import the parameters
is very different. Thus, only the decoding layer is extracted, unless you see
other parts that could be worth factorized.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |  799 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 448 insertions(+), 351 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3543bbe..1c32ca2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -700,6 +700,229 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 	return number(buf, end, (unsigned long) ptr, 16, field_width, precision, flags);
 }
 
+
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
+/*
+ * Helper function to decode printf style format.
+ * Each call decode a token from the format and return the
+ * number of characters read (or likely the delta where it wants
+ * to go on the next call).
+ * The decoded token is returned through the parameters
+ *
+ * @fmt: the format string
+ * @type of the token returned
+ * @flags: various flags such as +, -, # tokens..
+ * @field_width: overwritten width
+ * @base: base of the number (octal, hex, ...)
+ * @precision: precision of a number
+ * @qualifier: qualifier of a number (long, size_t, ...)
+ */
+static int format_decode(const char *fmt, enum format_type *type, int *flags,
+			  int *field_width, int *base, int *precision,
+			  int *qualifier)
+{
+	const char *start = fmt;
+	bool sign = false;
+
+	/* we finished early by reading the field width */
+	if (*type == FORMAT_TYPE_WITDH) {
+		if (*field_width < 0) {
+			*field_width = -*field_width;
+			*flags |= LEFT;
+		}
+		*type = FORMAT_TYPE_NONE;
+		goto precision;
+	}
+
+	/* we finished early by reading the precision */
+	if (*type == FORMAT_TYPE_PRECISION) {
+		if (*precision < 0)
+			*precision = 0;
+
+		*type = FORMAT_TYPE_NONE;
+		goto qualifier;
+	}
+
+	/* By default */
+	*type = FORMAT_TYPE_NONE;
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
+	*flags = 0;
+
+	while (1) { /* this also skips first '%' */
+		bool found = true;
+
+		++fmt;
+
+		switch (*fmt) {
+		case '-':
+			*flags |= LEFT;
+			break;
+		case '+':
+			*flags |= PLUS;
+			break;
+		case ' ':
+			*flags |= SPACE;
+			break;
+		case '#':
+			*flags |= SPECIAL;
+			break;
+		case '0':
+			*flags |= ZEROPAD;
+			break;
+		default:
+			found = false;
+		}
+
+		if (!found)
+			break;
+	}
+
+	/* get field width */
+	*field_width = -1;
+
+	if (isdigit(*fmt))
+		*field_width = skip_atoi(&fmt);
+	else if (*fmt == '*') {
+		/* it's the next argument */
+		*type = FORMAT_TYPE_WITDH;
+		return ++fmt - start;
+	}
+
+precision:
+	/* get the precision */
+	*precision = -1;
+	if (*fmt == '.') {
+		++fmt;
+		if (isdigit(*fmt)) {
+			*precision = skip_atoi(&fmt);
+			if (*precision < 0)
+				*precision = 0;
+		} else if (*fmt == '*') {
+			/* it's the next argument */
+			*type = FORMAT_TYPE_WITDH;
+			return ++fmt - start;
+		}
+	}
+
+qualifier:
+	/* get the conversion qualifier */
+	*qualifier = -1;
+	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
+	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+		*qualifier = *fmt;
+		++fmt;
+		if (*qualifier == 'l' && *fmt == 'l') {
+			*qualifier = 'L';
+			++fmt;
+		}
+	}
+
+	/* default base */
+	*base = 10;
+	switch (*fmt) {
+	case 'c':
+		*type = FORMAT_TYPE_CHAR;
+		return ++fmt - start;
+
+	case 's':
+		*type = FORMAT_TYPE_STR;
+		return ++fmt - start;
+
+	case 'p':
+		*type = FORMAT_TYPE_PTR;
+		return fmt - start;
+		/* skip alnum */
+
+	case 'n':
+		/* FIXME:
+		* What does C99 say about the overflow case here? */
+		*type = FORMAT_TYPE_NRCHARS;
+		return ++fmt - start;
+
+	case '%':
+		*type = FORMAT_TYPE_PERCENT_CHAR;
+		return ++fmt - start;
+
+	/* integer number formats - set up the flags and "break" */
+	case 'o':
+		*base = 8;
+		break;
+
+	case 'x':
+		*flags |= SMALL;
+
+	case 'X':
+		*base = 16;
+		break;
+
+	case 'd':
+	case 'i':
+		sign = true;
+	case 'u':
+		break;
+
+	default:
+		*type = FORMAT_TYPE_INVALID;
+		return fmt - start;
+	}
+
+	if (*qualifier == 'L')
+		*type = FORMAT_TYPE_LONG_LONG;
+	else if (*qualifier == 'l') {
+		if (sign)
+			*type = FORMAT_TYPE_LONG;
+		else
+			*type = FORMAT_TYPE_ULONG;
+	} else if (*qualifier == 'Z' || *qualifier == 'z') {
+		*type = FORMAT_TYPE_SIZE_T;
+	} else if (*qualifier == 't') {
+		*type = FORMAT_TYPE_PTRDIFF;
+	} else if (*qualifier == 'h') {
+		if (sign)
+			*type = FORMAT_TYPE_SHORT;
+		else
+			*type = FORMAT_TYPE_USHORT;
+	} else {
+		if (sign)
+			*type = FORMAT_TYPE_INT;
+		else
+			*type = FORMAT_TYPE_UINT;
+	}
+
+	return ++fmt - start;
+}
+
+
 /**
  * vsnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
@@ -726,15 +949,17 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
 	unsigned long long num;
-	int base;
+	int base = 0;
 	char *str, *end, c;
+	int read;
+	enum format_type type = FORMAT_TYPE_NONE;
 
-	int flags;		/* flags to number() */
+	int flags = 0;		/* flags to number() */
 
-	int field_width;	/* width of output field */
-	int precision;		/* min. # of digits for integers; max
+	int field_width = 0;	/* width of output field */
+	int precision = 0;	/* min. # of digits for integers; max
 				   number of chars for from string */
-	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+	int qualifier = 0;	/* 'h', 'l', or 'L' for integer fields */
 				/* 'z' support added 23/7/1999 S.H.    */
 				/* 'z' changed to 'Z' --davidm 1/25/99 */
 				/* 't' added for ptrdiff_t */
@@ -758,184 +983,133 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
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
+		read = format_decode(fmt, &type, &flags, &field_width, &base,
+					&precision, &qualifier);
 
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
+		switch (type) {
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
+			field_width = va_arg(args, int);
+			break;
 
-		/* default base */
-		base = 10;
+		case FORMAT_TYPE_PRECISION:
+			precision = va_arg(args, int);
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
+		case FORMAT_TYPE_CHAR:
+			if (!(flags & LEFT)) {
 				while (--field_width > 0) {
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
+			while (--field_width > 0) {
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
+			str = string(str, end, va_arg(args, char *),
+					field_width, precision, flags);
+			break;
 
-			case 'x':
-				flags |= SMALL;
-			case 'X':
-				base = 16;
-				break;
+		case FORMAT_TYPE_PTR:
+			str = pointer(fmt+1, str, end, va_arg(args, void *),
+				      field_width, precision, flags);
+			while (isalnum(fmt[1]))
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
-		}
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
-		}
-		str = number(str, end, num, base,
+			} else {
+				--fmt;
+			}
+			break;
+
+		case FORMAT_TYPE_NRCHARS:
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else if (qualifier == 'Z' || qualifier == 'z') {
+				size_t *ip = va_arg(args, size_t *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			break;
+
+		default:
+			if (type == FORMAT_TYPE_LONG_LONG)
+				num = va_arg(args, long long);
+			else if (type == FORMAT_TYPE_ULONG)
+				num = va_arg(args, unsigned long);
+			else if (type == FORMAT_TYPE_LONG)
+				num = va_arg(args, unsigned long);
+			else if (type == FORMAT_TYPE_SIZE_T)
+				num = va_arg(args, size_t);
+			else if (type == FORMAT_TYPE_PTRDIFF)
+				num = va_arg(args, ptrdiff_t);
+			else if (type == FORMAT_TYPE_USHORT)
+				num = (unsigned short) va_arg(args, int);
+			else if (type == FORMAT_TYPE_SHORT)
+				num = (short) va_arg(args, int);
+			else if (type == FORMAT_TYPE_UINT)
+				num = va_arg(args, unsigned int);
+			else
+				num = va_arg(args, unsigned int);
+
+			str = number(str, end, num, base,
 				field_width, precision, flags);
+		}
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
 
@@ -1085,7 +1259,13 @@ EXPORT_SYMBOL(sprintf);
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args)
 {
 	char *str, *end;
-	int qualifier;
+	int qualifier = 0;
+	int base = 0;
+	enum format_type type = 0;
+	int flags = 0;
+	int field_width = 0;
+	int precision = 0;
+	int read;
 
 	str = (char *)bin_buf;
 	end = (char *)(bin_buf + size);
@@ -1110,57 +1290,31 @@ do {									\
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
+		read = format_decode(fmt, &type, &flags, &field_width, &base,
+					&precision, &qualifier);
 
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
+		switch (type) {
+		case FORMAT_TYPE_NONE: {
+			break;
 		}
 
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
+			save_arg(int);
+			break;
 
-		/* parse format type */
-		switch (*fmt) {
-		case 'c':
+		case FORMAT_TYPE_PRECISION:
+			save_arg(int);
+			break;
+
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
@@ -1170,15 +1324,25 @@ repeat:
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
 			while (isalnum(fmt[1]))
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
 			void *skip_arg;
 			if (qualifier == 'l')
@@ -1187,37 +1351,29 @@ repeat:
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
+			if (type == FORMAT_TYPE_LONG_LONG)
 				save_arg(long long);
-			else if (qualifier == 'l')
+			else if (type == FORMAT_TYPE_ULONG ||
+				 type == FORMAT_TYPE_LONG)
 				save_arg(unsigned long);
-			else if (qualifier == 'Z' || qualifier == 'z')
+			else if (type == FORMAT_TYPE_SIZE_T)
 				save_arg(size_t);
-			else if (qualifier == 't')
+			else if (type == FORMAT_TYPE_PTRDIFF)
 				save_arg(ptrdiff_t);
-			else if (qualifier == 'h')
+			else if (type == FORMAT_TYPE_USHORT ||
+				 type == FORMAT_TYPE_SHORT)
 				save_arg(short);
 			else
 				save_arg(int);
-			continue;
-		default:
-			if (!*fmt)
-				--fmt;
-			continue;
 		}
 	}
-#undef save_arg
-
 	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
+
+#undef save_arg
 }
 EXPORT_SYMBOL_GPL(vbin_printf);
 
@@ -1253,10 +1409,11 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 	char *str, *end, c;
 	const char *args = (const char *)bin_buf;
 
-	int flags;
-	int field_width;
-	int precision;
-	int qualifier;
+	int flags = 0;
+	int field_width = 0;
+	int precision = 0;
+	int qualifier = 0;
+	enum format_type type = 0;
 
 	if (unlikely((int) size < 0)) {
 		/* There can be only one.. */
@@ -1290,82 +1447,36 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
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
+		read = format_decode(fmt, &type, &flags, &field_width, &base,
+					&precision, &qualifier);
 
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
+		switch (type) {
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
+			field_width = get_arg(int);
+			break;
 
-		/* default base */
-		base = 10;
+		case FORMAT_TYPE_PRECISION:
+			precision = get_arg(int);
+			break;
 
-		switch (*fmt) {
-		case 'c':
+		case FORMAT_TYPE_CHAR:
 			if (!(flags & LEFT)) {
 				while (--field_width > 0) {
 					if (str < end)
@@ -1382,53 +1493,31 @@ repeat:
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
 			str = string(str, end, (char *)str_arg, field_width,
 					precision, flags);
-			continue;
+			break;
 		}
 
-		case 'p':
+		case FORMAT_TYPE_PTR:
 			str = pointer(fmt+1, str, end, get_arg(void *),
-					field_width, precision, flags);
-			/* Skip all alphanumeric pointer suffixes */
+				      field_width, precision, flags);
 			while (isalnum(fmt[1]))
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
-			break;
-
-		case 'd':
-		case 'i':
-			flags |= SIGN;
-		case 'u':
 			break;
 
-		default:
+		case FORMAT_TYPE_INVALID:
 			if (str < end)
 				*str = '%';
 			++str;
@@ -1439,36 +1528,44 @@ repeat:
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
-		}
-		str = number(str, end, num, base,
+			break;
+
+		case FORMAT_TYPE_NRCHARS:
+			/* skip */
+			break;
+
+		default:
+			if (type == FORMAT_TYPE_LONG_LONG)
+				num = get_arg(long long);
+			else if (type == FORMAT_TYPE_ULONG)
+				num = get_arg(unsigned long);
+			else if (type == FORMAT_TYPE_LONG)
+				num = get_arg(unsigned long);
+			else if (type == FORMAT_TYPE_SIZE_T)
+				num = get_arg(size_t);
+			else if (type == FORMAT_TYPE_PTRDIFF)
+				num = get_arg(ptrdiff_t);
+			else if (type == FORMAT_TYPE_USHORT)
+				num = get_arg(unsigned short);
+			else if (type == FORMAT_TYPE_SHORT)
+				num = get_arg(short);
+			else if (type == FORMAT_TYPE_UINT)
+				num = get_arg(unsigned int);
+			else
+				num = get_arg(int);
+
+			str = number(str, end, num, base,
 				field_width, precision, flags);
+		}
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


