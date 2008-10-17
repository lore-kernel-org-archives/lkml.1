Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYJQFNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYJQFNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYJQFNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:13:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:49507 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYJQFNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:13:42 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 16:12:19 +1100
Message-Id: <1224220339.7654.84.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Implement %pR to print struct resource content

Add a %pR option to the kernel vsnprintf that prints the range of
addresses inside a struct resource passed by pointer.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This one does more fancy formatting.

Index: linux-work/lib/vsprintf.c
===================================================================
--- linux-work.orig/lib/vsprintf.c	2008-10-17 13:30:18.000000000 +1100
+++ linux-work/lib/vsprintf.c	2008-10-17 16:10:49.000000000 +1100
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/ioport.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -550,18 +551,58 @@ static char *symbol_string(char *buf, ch
 #endif
 }
 
+static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+{
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+#define MEM_RSRC_SIZE	16
+#else
+#define MEM_RSRC_SIZE	8
+#endif
+
+#ifdef CONFIG_X86
+#define IO_RSRC_SIZE	4
+#elif CONFIG_PPC
+#define IO_RSRC_SIZE	8
+#else
+#define IO_RSRC_SIZE	MEM_RSRC_SIZE
+#endif
+
+	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
+	char sym[4*sizeof(resource_size_t) + 8];
+	char *p = sym, *pend = sym + sizeof(sym);
+	int size = 2 * sizeof(resource_size_t);
+
+	if (res->flags & IORESOURCE_MEM)
+		size = MEM_RSRC_SIZE;
+	else if (res->flags & IORESOURCE_IO)
+		size = IO_RSRC_SIZE;
+
+	*p++ = '[';
+	p = number(p, pend, res->start, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p++ = '-';
+	p = number(p, pend, res->end, 16, size, -1, SPECIAL | SMALL | ZEROPAD);
+	*p++ = ']';
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
- * Right now we just handle 'F' (for symbolic Function descriptor pointers)
- * and 'S' (for Symbolic direct pointers), but this can easily be
- * extended in the future (network address types etc).
- *
- * The difference between 'S' and 'F' is that on ia64 and ppc64 function
- * pointers are really function descriptors, which contain a pointer the
- * real address. 
+ * Right now we handle:
+ *
+ * - 'F' For symbolic Function descriptor pointers
+ * - 'S' For Symbolic direct pointers), but this can easily be
+ *       extended in the future (network address types etc).
+ * - 'R' For a struct resouce pointer, it prints the range of
+ *       addresses (not the name nor the flags)
+ *
+ * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
+ * function pointers are really function descriptors, which contain a
+ * pointer the real address.
  */
 static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
 {
@@ -571,6 +612,8 @@ static char *pointer(const char *fmt, ch
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
+	case 'R':
+		return resource_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -590,6 +633,7 @@ static char *pointer(const char *fmt, ch
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
+ * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing


