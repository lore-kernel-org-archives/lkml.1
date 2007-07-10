Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXGJDeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXGJDeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXGJDeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:34:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXGJDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:34:10 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 20/33] Console-writing code for the new x86 setup code
Date: Mon,  9 Jul 2007 19:51:59 -0700
Message-Id: <11840380363720-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840379311574-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
Message-Id: <bf3e29f3d8c12230b38cae29ef5b476267d40cd1.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

This implements writing text to the console, including printf().

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/printf.c |  331 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/tty.c    |  112 ++++++++++++++++
 2 files changed, 443 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/printf.c
 create mode 100644 arch/i386/boot/tty.c

diff --git a/arch/i386/boot/printf.c b/arch/i386/boot/printf.c
new file mode 100644
index 0000000..ee3d9fc
--- /dev/null
+++ b/arch/i386/boot/printf.c
@@ -0,0 +1,331 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/printf.c
+ *
+ * Oh, it's a waste of space, but oh-so-yummy for debugging.  This
+ * version of printf() does not include 64-bit support.  "Live with
+ * it."
+ *
+ */
+
+#include "boot.h"
+
+static inline int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
+
+static int skip_atoi(const char **s)
+{
+	int i = 0;
+
+	while (isdigit(**s))
+		i = i * 10 + *((*s)++) - '0';
+	return i;
+}
+
+unsigned int atou(const char *s)
+{
+	unsigned int i = 0;
+	while (isdigit(*s))
+		i = i * 10 + (*s++ - '0');
+	return i;
+}
+
+static int strnlen(const char *s, int maxlen)
+{
+	const char *es = s;
+	while (*es && maxlen) {
+		es++;
+		maxlen--;
+	}
+
+	return (es - s);
+}
+
+#define ZEROPAD	1		/* pad with zero */
+#define SIGN	2		/* unsigned/signed long */
+#define PLUS	4		/* show plus */
+#define SPACE	8		/* space if plus */
+#define LEFT	16		/* left justified */
+#define SPECIAL	32		/* 0x */
+#define LARGE	64		/* use 'ABCDEF' instead of 'abcdef' */
+
+#define do_div(n,base) ({ \
+int __res; \
+__res = ((unsigned long) n) % (unsigned) base; \
+n = ((unsigned long) n) / (unsigned) base; \
+__res; })
+
+static char *number(char *str, long num, int base, int size, int precision,
+		    int type)
+{
+	char c, sign, tmp[66];
+	const char *digits = "0123456789abcdefghijklmnopqrstuvwxyz";
+	int i;
+
+	if (type & LARGE)
+		digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	if (type & LEFT)
+		type &= ~ZEROPAD;
+	if (base < 2 || base > 36)
+		return 0;
+	c = (type & ZEROPAD) ? '0' : ' ';
+	sign = 0;
+	if (type & SIGN) {
+		if (num < 0) {
+			sign = '-';
+			num = -num;
+			size--;
+		} else if (type & PLUS) {
+			sign = '+';
+			size--;
+		} else if (type & SPACE) {
+			sign = ' ';
+			size--;
+		}
+	}
+	if (type & SPECIAL) {
+		if (base == 16)
+			size -= 2;
+		else if (base == 8)
+			size--;
+	}
+	i = 0;
+	if (num == 0)
+		tmp[i++] = '0';
+	else
+		while (num != 0)
+			tmp[i++] = digits[do_div(num, base)];
+	if (i > precision)
+		precision = i;
+	size -= precision;
+	if (!(type & (ZEROPAD + LEFT)))
+		while (size-- > 0)
+			*str++ = ' ';
+	if (sign)
+		*str++ = sign;
+	if (type & SPECIAL) {
+		if (base == 8)
+			*str++ = '0';
+		else if (base == 16) {
+			*str++ = '0';
+			*str++ = digits[33];
+		}
+	}
+	if (!(type & LEFT))
+		while (size-- > 0)
+			*str++ = c;
+	while (i < precision--)
+		*str++ = '0';
+	while (i-- > 0)
+		*str++ = tmp[i];
+	while (size-- > 0)
+		*str++ = ' ';
+	return str;
+}
+
+int vsprintf(char *buf, const char *fmt, va_list args)
+{
+	int len;
+	unsigned long num;
+	int i, base;
+	char *str;
+	const char *s;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/* min. # of digits for integers; max
+				   number of chars for from string */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+
+	for (str = buf; *fmt; ++fmt) {
+		if (*fmt != '%') {
+			*str++ = *fmt;
+			continue;
+		}
+
+		/* process flags */
+		flags = 0;
+	      repeat:
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
+			field_width = va_arg(args, int);
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
+				precision = va_arg(args, int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
+			qualifier = *fmt;
+			++fmt;
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+		case 'c':
+			if (!(flags & LEFT))
+				while (--field_width > 0)
+					*str++ = ' ';
+			*str++ = (unsigned char)va_arg(args, int);
+			while (--field_width > 0)
+				*str++ = ' ';
+			continue;
+
+		case 's':
+			s = va_arg(args, char *);
+			len = strnlen(s, precision);
+
+			if (!(flags & LEFT))
+				while (len < field_width--)
+					*str++ = ' ';
+			for (i = 0; i < len; ++i)
+				*str++ = *s++;
+			while (len < field_width--)
+				*str++ = ' ';
+			continue;
+
+		case 'p':
+			if (field_width == -1) {
+				field_width = 2 * sizeof(void *);
+				flags |= ZEROPAD;
+			}
+			str = number(str,
+				     (unsigned long)va_arg(args, void *), 16,
+				     field_width, precision, flags);
+			continue;
+
+		case 'n':
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			continue;
+
+		case '%':
+			*str++ = '%';
+			continue;
+
+			/* integer number formats - set up the flags and "break" */
+		case 'o':
+			base = 8;
+			break;
+
+		case 'X':
+			flags |= LARGE;
+		case 'x':
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
+			*str++ = '%';
+			if (*fmt)
+				*str++ = *fmt;
+			else
+				--fmt;
+			continue;
+		}
+		if (qualifier == 'l')
+			num = va_arg(args, unsigned long);
+		else if (qualifier == 'h') {
+			num = (unsigned short)va_arg(args, int);
+			if (flags & SIGN)
+				num = (short)num;
+		} else if (flags & SIGN)
+			num = va_arg(args, int);
+		else
+			num = va_arg(args, unsigned int);
+		str = number(str, num, base, field_width, precision, flags);
+	}
+	*str = '\0';
+	return str - buf;
+}
+
+int sprintf(char *buf, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vsprintf(buf, fmt, args);
+	va_end(args);
+	return i;
+}
+
+int printf(const char *fmt, ...)
+{
+	char printf_buf[1024];
+	va_list args;
+	int printed;
+
+	va_start(args, fmt);
+	printed = vsprintf(printf_buf, fmt, args);
+	va_end(args);
+
+	puts(printf_buf);
+
+	return printed;
+}
diff --git a/arch/i386/boot/tty.c b/arch/i386/boot/tty.c
new file mode 100644
index 0000000..a8db787
--- /dev/null
+++ b/arch/i386/boot/tty.c
@@ -0,0 +1,112 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/tty.c
+ *
+ * Very simple screen I/O
+ * XXX: Probably should add very simple serial I/O?
+ */
+
+#include "boot.h"
+
+/*
+ * These functions are in .inittext so they can be used to signal
+ * error during initialization.
+ */
+
+void __attribute__((section(".inittext"))) putchar(int ch)
+{
+	unsigned char c = ch;
+
+	if (c == '\n')
+		putchar('\r');	/* \n -> \r\n */
+
+	/* int $0x10 is known to have bugs involving touching registers
+	   it shouldn't.  Be extra conservative... */
+	asm volatile("pushal; int $0x10; popal"
+		     : : "b" (0x0007), "c" (0x0001), "a" (0x0e00|ch));
+}
+
+void __attribute__((section(".inittext"))) puts(const char *str)
+{
+	int n = 0;
+	while (*str) {
+		putchar(*str++);
+		n++;
+	}
+}
+
+/*
+ * Read the CMOS clock through the BIOS, and return the
+ * seconds in BCD.
+ */
+
+static u8 gettime(void)
+{
+	u16 ax = 0x0200;
+	u16 cx, dx;
+
+	asm("int $0x1a"
+	    : "+a" (ax), "=c" (cx), "=d" (dx)
+	    : : "ebx", "esi", "edi");
+
+	return dx >> 8;
+}
+
+/*
+ * Read from the keyboard
+ */
+int getchar(void)
+{
+	u16 ax = 0;
+	asm("int $0x16" : "+a" (ax));
+
+	return ax & 0xff;
+}
+
+static int kbd_pending(void)
+{
+	u8 pending;
+	asm("int $0x16; setnz %0"
+	    : "=rm" (pending)
+	    : "a" (0x0100));
+	return pending;
+}
+
+void kbd_flush(void)
+{
+	for (;;) {
+		if (!kbd_pending())
+			break;
+		getchar();
+	}
+}
+
+int getchar_timeout(void)
+{
+	int cnt = 30;
+	int t0, t1;
+
+	t0 = gettime();
+
+	while (cnt) {
+		if (kbd_pending())
+			return getchar();
+
+		t1 = gettime();
+		if (t0 != t1) {
+			cnt--;
+			t0 = t1;
+		}
+	}
+
+	return 0;		/* Timeout! */
+}
-- 
1.5.2.2

