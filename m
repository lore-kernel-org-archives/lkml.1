Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXIXUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXIXUiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXIXUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:37:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:30218 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXIXUh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uM2MwKs286fMPmyAipzZht8ycNyh6R6g88LZn5h4FyMHnkXO+onXoU/JVcSboUUTOY33RWf3tKVyKpWuNElQUcq1Z30Em12TlIDmGPgWl0USP2LAP4EJjnq9MlNC3IdeOjNFmBBHbdWIsCdFkZTEQ7jYicbxZtPwTZ19j6lYhRQ=
Message-ID: <19f34abd0709241337t545b3433mdc336055e2fb8330@mail.gmail.com>
Date: Mon, 24 Sep 2007 22:37:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: holzheu@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <1190653250.2010.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
	 <1190647156.30132.92.camel@localhost>
	 <19f34abd0709240943s13472c97ma7a4aff3a6089e8f@mail.gmail.com>
	 <1190653250.2010.2.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-09-24 at 18:43 +0200, Vegard Nossum wrote:
> > Storing the format-string separately allows us to hash THAT instead of
> > the formatted (ie. console output) message. Since this will never
> > change from message to message, it can be looked up in a table or
> > whatever and allow user-space to do translations without for example
> > regular expressions.
>
> That hash will change with each linux version given the
> inevitable spelling fixes, message reformatting and such.

But we can keep the old ones too. That shouldn't be much of a problem.
I mean, it probably wouldn't rely on a hash alone. The format string
itself can be compared with the translation database.

> > I will follow up with some code to demonstrate as soon as I can.
>
> Looking forward to it.

Okay, so I have one huge file that does more or less what I want. The
main problem with this, as I see it, is that it largely duplicates
vsnprintf() from lib/vsprintf.c (minus the functions I coped verbatim
from the same file). This is bad because the job of maintaining that
is now doubled (or worse). Hopefully it won't change much in the
future either.

For now, the main() function is most important. This demonstrates that
what I want is in fact possible. printf() is now split in two --
args_printf_prepare() and args_snprintf(). The former takes your
arguments as you would pass them to any *printff() function, but only
converts your arguments (and stores them in a struct args). The latter
takes the format string and the stored struct args and puts the whole
thing in a buffer (just like snprintf()).

I know Gmail isn't too friendly with code formatting, but this is just
an example program anyway, so it shouldn't really matter. Also, a
disclaimer: Almost completely untested.


Vegard


#define _GNU_SOURCE
#include <ctype.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* This was shamelessly copied form include/asm-generic/div64.h */
# define do_div(n,base) ({                                      \
        uint32_t __base = (base);                               \
        uint32_t __rem;                                         \
        __rem = ((uint64_t)(n)) % __base;                       \
        (n) = ((uint64_t)(n)) / __base;                         \
        __rem;                                                  \
 })

/* This was shamelessly copied from lib/vsprintf.c */
static char* put_dec_trunc(char *buf, unsigned q)
{
	unsigned d3, d2, d1, d0;
	d1 = (q>>4) & 0xf;
	d2 = (q>>8) & 0xf;
	d3 = (q>>12);

	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
	q = (d0 * 0xcd) >> 11;
	d0 = d0 - 10*q;
	*buf++ = d0 + '0'; /* least significant digit */
	d1 = q + 9*d3 + 5*d2 + d1;
	if (d1 != 0) {
		q = (d1 * 0xcd) >> 11;
		d1 = d1 - 10*q;
		*buf++ = d1 + '0'; /* next digit */

		d2 = q + 2*d2;
		if ((d2 != 0) || (d3 != 0)) {
			q = (d2 * 0xd) >> 7;
			d2 = d2 - 10*q;
			*buf++ = d2 + '0'; /* next digit */

			d3 = q + 4*d3;
			if (d3 != 0) {
				q = (d3 * 0xcd) >> 11;
				d3 = d3 - 10*q;
				*buf++ = d3 + '0';  /* next digit */
				if (q != 0)
					*buf++ = q + '0';  /* most sign. digit */
			}
		}
	}
	return buf;
}
static char* put_dec_full(char *buf, unsigned q)
{
	unsigned d3, d2, d1, d0;
	d1 = (q>>4) & 0xf;
	d2 = (q>>8) & 0xf;
	d3 = (q>>12);

	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
	q = (d0 * 0xcd) >> 11;
	d0 = d0 - 10*q;
	*buf++ = d0 + '0';
	d1 = q + 9*d3 + 5*d2 + d1;
		q = (d1 * 0xcd) >> 11;
		d1 = d1 - 10*q;
		*buf++ = d1 + '0';

		d2 = q + 2*d2;
			q = (d2 * 0xd) >> 7;
			d2 = d2 - 10*q;
			*buf++ = d2 + '0';

			d3 = q + 4*d3;
				q = (d3 * 0xcd) >> 11; /* - shorter code */
				d3 = d3 - 10*q;
				*buf++ = d3 + '0';
					*buf++ = q + '0';
	return buf;
}
static char* put_dec(char *buf, unsigned long long num)
{
	while (1) {
		unsigned rem;
		if (num < 100000)
			return put_dec_trunc(buf, num);
		rem = do_div(num, 100000);
		buf = put_dec_full(buf, rem);
	}
}
#define ZEROPAD 1               /* pad with zero */
#define SIGN    2               /* unsigned/signed long */
#define PLUS    4               /* show plus */
#define SPACE   8               /* space if plus */
#define LEFT    16              /* left justified */
#define SPECIAL 32              /* 0x */
#define LARGE   64              /* use 'ABCDEF' instead of 'abcdef' */
static int skip_atoi(const char **s)
{
        int i=0;
        while (isdigit(**s))
                i = i*10 + *((*s)++) - '0';
        return i;
}
/* End of shameless copy. */


/**
 * Simple string buffer implementation
 */
struct buffer {
	unsigned int size;

	unsigned int pos;
	char *data;
};

void buffer_init(struct buffer *buf)
{
	buf->size = 0;
	buf->pos = 0;
	buf->data = NULL;
}

void buffer_deinit(struct buffer *buf)
{
	free(buf->data);

	buf->size = 0;
	buf->pos = 0;
	buf->data = NULL;
}

void buffer_write(struct buffer *buf, char c)
{
	if(buf->pos == buf->size) {
		buf->size = buf->size ? 2 * buf->size : 8;
		buf->data = realloc(buf->data, buf->size);
	}

	buf->data[buf->pos++] = c;
}

/* The equivalent of number() in lib/vsprintf.c */
void buffer_write_number(struct buffer *buf, unsigned long long num, int base,
	int size, int precision, int type)
{
	char sign, tmp[66];
	const char *digits;
	static const char small_digits[] = "0123456789abcdefx";
	static const char large_digits[] = "0123456789ABCDEFX";
	int need_pfx = ((type & SPECIAL) && base != 10);
	int i;

	digits = (type & LARGE) ? large_digits : small_digits;
	if(type & LEFT)
		type &= ~ZEROPAD;
	if(base < 2 || base > 36)
		return;

	sign = 0;
	if(type & SIGN) {
		if((signed long long) num < 0) {
			sign = '-';
			num = -(signed long long) num;
			--size;
		} else if(type & PLUS) {
			sign = '+';
			--size;
		} else if(type & SPACE) {
			sign = ' ';
			--size;
		}
	}

	if(need_pfx) {
		--size;
		if(base == 16)
			size--;
	}

	i = 0;
	if(num == 0)
		tmp[i++] = '0';
	else if(base != 10) {
		int mask = base - 1;
		int shift = 3;

		if(base == 16)
			shift = 4;

		do {
			tmp[i++] = digits[((unsigned char) num) & mask];
			num >>= shift;
		} while(num);
	} else {
		i = put_dec(tmp, num) - tmp;
	}

	if(i > precision)
		precision = i;

	size -= precision;
	if(!(type & (ZEROPAD + LEFT))) {
		while(--size >= 0)
			buffer_write(buf, ' ');
	}

	if(sign)
		buffer_write(buf, sign);

	if(need_pfx) {
		buffer_write(buf, '0');
		if(base == 16)
			buffer_write(buf, digits[16]);
	}

	if(!(type & LEFT)) {
		char c = (type & ZEROPAD) ? '0' : ' ';
		while(--size >= 0)
			buffer_write(buf, c);
	}

	while(i <= --precision)
		buffer_write(buf, '0');

	while(--i >= 0)
		buffer_write(buf, tmp[i]);

	while(--size >= 0)
		buffer_write(buf, ' ');
}

char *buffer_dup(struct buffer *buf)
{
	return strndup(buf->data, buf->pos);
}

/**
 * Expanding args-array
 */
struct args {
	unsigned int size;

	unsigned int argc;
	char **argv;
};

void args_push(struct args *args, char *arg)
{
	if(args->argc == args->size) {
		args->size = args->size ? 2 * args->size : 8;
		args->argv = realloc(args->argv, args->size);
	}

	args->argv[args->argc++] = arg;
}

void args_vprintf_prepare(struct args *args, const char *fmt, va_list ap)
{
	const char *p;

	for(p = fmt; *p; ++p) {
		int flags;
		int field_width;
		int precision;
		int qualifier;
		int base;

		int i;
		char c;
		const char *s;
		int len;
		unsigned long long num;

		struct buffer str;

		/* skip to the next format */
		if(*p != '%')
			continue;

		buffer_init(&str);

		/* read flags */
		flags = 0;
	repeat:
		++p;
		switch(*p) {
		case '-': flags |= LEFT; goto repeat;
		case '+': flags |= PLUS; goto repeat;
		case ' ': flags |= SPACE; goto repeat;
		case '#': flags |= SPECIAL; goto repeat;
		case '0': flags |= ZEROPAD; goto repeat;
		}

		/* read field width */
		field_width = -1;
		if(isdigit(*p))
			field_width = skip_atoi(&p);
		else if(*p == '*') {
			++p;
			field_width = va_arg(ap, int);
			if(field_width < 0) {
				field_width = -field_width;
				flags |= LEFT;
			}
		}

		/* read precision */
		precision = -1;
		if(*p == '.') {
			++p;
			if(isdigit(*p))
				precision = skip_atoi(&p);
			else if(*p == '*') {
				++p;
				precision = va_arg(ap, int);
			}

			if(precision < 0)
				precision = 0;
		}

		/* read conversion qualifier */
		qualifier = -1;
		if(*p == 'h' || *p == 'l' || *p == 'L'
			|| *p == 'Z' || *p == 'z' || *p == 't')
		{
			qualifier = *p;
			++p;
			if(qualifier == 'l' && *p == 'l') {
				qualifier = 'L';
				++p;
			}
		}

		/* default base */
		base = 10;

		/* XXX: only %c and %s supported yet */
		switch(*p) {
		case 'c':
			if(!(flags & LEFT)) {
				while(--field_width > 0)
					buffer_write(&str, ' ');
			}

			c = (unsigned char) va_arg(ap, int);
			buffer_write(&str, c);

			while(--field_width > 0)
				buffer_write(&str, ' ');

			args_push(args, buffer_dup(&str));
			buffer_deinit(&str);
			continue;
		case 's':
			/* XXX: see vnprintf() in lib/vsprintf.c */
			s = va_arg(ap, char *);
			len = strnlen(s, precision);

			if(!(flags & LEFT)) {
				while(len < field_width--)
					buffer_write(&str, ' ');
			}
			for(i = 0; i < len; ++i, ++s)
				buffer_write(&str, *s);
			while(len < field_width--)
				buffer_write(&str, ' ');

			args_push(args, buffer_dup(&str));
			buffer_deinit(&str);
			continue;
		case 'p':
			if(field_width == -1) {
				field_width = 2 * sizeof(void *);
				flags |= ZEROPAD;
			}

			buffer_write_number(&str,
				(unsigned long) va_arg(ap, void *),
				16, field_width, precision, flags);

			args_push(args, buffer_dup(&str));
			buffer_deinit(&str);
			continue;
		case 'n':
			/* Nothing happens. */
			buffer_deinit(&str);
			continue;
		case '%':
			/* Nothing happens. */
			buffer_deinit(&str);
			continue;
		case 'o':
			base = 8;
			break;
		case 'X':
			flags |= LARGE;
		case 'x':
			base = 16;
			break;
		case 'd':
		case 'i':
			flags |= SIGN;
		case 'u':
			break;

		default:
			/* In this case, we need to pop an empty argument in
			 * the real snprintf(). */
			args_push(args, buffer_dup(&str));
			buffer_deinit(&str);
			continue;
		}

		if(qualifier == 'L')
			num = va_arg(ap, long long);
		else if(qualifier == 'l') {
			num = va_arg(ap, unsigned long);
			if(flags & SIGN)
				num = (signed long) num;
		} else if(qualifier == 'Z' || qualifier == 'z') {
			num = va_arg(ap, size_t);
		} else if(qualifier == 't') {
#define ptrdiff_t typeof((void *) 0 - (void *) 0)
			num = va_arg(ap, ptrdiff_t);
		} else if(qualifier == 'h') {
			num = (unsigned short) va_arg(ap, int);
			if(flags & SIGN)
				num = (signed short) num;
		} else {
			num = va_arg(ap, unsigned int);
			if(flags & SIGN)
				num = (signed int) num;
		}

		buffer_write_number(&str, num, base, field_width,
			precision, flags);

		args_push(args, buffer_dup(&str));
		buffer_deinit(&str);
	}
}

void args_printf_prepare(struct args *args, const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	args_vprintf_prepare(args, fmt, ap);
	va_end(ap);
}

/* Here we just parse the format string without really caring about the field
 * parameters; they've been formatted already by args_printf_prepare(). */
int args_snprintf(struct args *args,
	char *buf, size_t size, const char *fmt)
{
	const char *p;
	unsigned int argp = 0;

	char *str;
	char *end;

	if((int) size < 0)
		return 0;

	str = buf;
	end = buf + size;

	/* Make sure end is always >= buf */
	if(end < buf) {
		end = ((void *) -1);
		size = end - buf;
	}

	for(p = fmt; *p; ++p) {
		char *arg;

		if(*p != '%') {
			if(str < end)
				*str = *p;
			++str;
			continue;
		}

		/* skip flags */
	repeat:
		++p;
		switch(*p) {
		case '-': goto repeat;
		case '+': goto repeat;
		case ' ': goto repeat;
		case '#': goto repeat;
		case '0': goto repeat;
		}

		/* skip field width */
		if(*p == '*')
			++p;
		else while(isdigit(*p))
			++p;

		/* skip precision */
		if(*p == '.') {
			++p;

			if(*p == '*')
				++p;
			else while(isdigit(*p))
				++p;
		}

		/* skip the conversion qualifier */
		if(*p == 'h' || *p == 'l' || *p == 'L'
			|| *p == 'Z' || *p == 'z' || *p == 't')
		{
			if(*p == 'l') {
				++p;

				if(*p == 'l')
					++p;
			} else
				++p;
		}

		/* skip the conversion specifier */
		switch(*p) {
		case 'n':
			/* XXX: (not implemented) */
			continue;
		case '%':
			if(str < end)
				*str = '%';
			++str;
			continue;
		}

		for(arg = args->argv[argp]; *arg; ++arg) {
			if(str < end)
				*str = *arg;
			++str;
		}

		++argp;
	}

	if(size > 0) {
		if(str < end)
			*str = '\0';
		else
			end[-1] = '\0';
	}

	return str - buf;
}

int
main(int argc, char *argv[])
{
	const char format[] = "Hello %s (%d times)!";
	struct args args;

	args.size = 0;
	args.argc = 0;
	args.argv = NULL;

	args_printf_prepare(&args, format, "world", 5);

	/* We can do whatever we want with the arguments now, like dumping
	 * them. */
	{
		unsigned int i;
		printf("Argument dump:\n");
		for(i = 0; i < args.argc; i++)
			printf("arg #%d: %s\n", 1 + i, args.argv[i]);
		printf("\n");
	}

	/* Use the format string and our "prepared" (ie. pre-formatted)
	 * argument list to actually format the string. */
	{
		static char out[512];
		printf("Reformatting:\n");

		args_snprintf(&args, out, sizeof(out), format);

		printf("%s\n", out);
		printf("\n");
	}

	return 0;
}
