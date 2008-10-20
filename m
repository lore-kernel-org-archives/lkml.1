Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYJTEIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYJTEIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYJTEIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:08:22 -0400
Received: from ozlabs.org ([203.10.76.45]:42926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYJTEIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:08:21 -0400
To: Linus Torvalds <torvalds@osdl.org>
CC: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       linux-pci@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       <yhlu.kernel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 20 Oct 2008 15:07:34 +1100
Subject: [PATCH 1/2] Implement %pR to print struct resource content
Message-Id: <20081020040820.C1882DDDEA@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Add a %pR option to the kernel vsnprintf that prints the range of
addresses inside a struct resource passed by pointer.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Padding now defaults to 4 digits for IO and 8 for MEM

 lib/vsprintf.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

--- linux-work.orig/lib/vsprintf.c	2008-10-17 13:30:18.000000000 +1100
+++ linux-work/lib/vsprintf.c	2008-10-20 14:39:15.000000000 +1100
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/ioport.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -550,18 +551,51 @@ static char *symbol_string(char *buf, ch
 #endif
 }
 
+static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+{
+#ifndef IO_RSRC_PRINTK_SIZE
+#define IO_RSRC_PRINTK_SIZE	4
+#endif
+
+#ifndef MEM_RSRC_PRINTK_SIZE
+#define MEM_RSRC_PRINTK_SIZE	8
+#endif
+
+	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
+	char sym[4*sizeof(resource_size_t) + 8];
+	char *p = sym, *pend = sym + sizeof(sym);
+	int size = -1;
+
+	if (res->flags & IORESOURCE_IO)
+		size = IO_RSRC_PRINTK_SIZE;
+	else if (res->flags & IORESOURCE_MEM)
+		size = MEM_RSRC_PRINTK_SIZE;
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
+ * - 'F' For symbolic function descriptor pointers
+ * - 'S' For symbolic direct pointers
+ * - 'R' For a struct resource pointer, it prints the range of
+ *       addresses (not the name nor the flags)
+ *
+ * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
+ * function pointers are really function descriptors, which contain a
+ * pointer to the real address.
  */
 static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field_width, int precision, int flags)
 {
@@ -571,6 +605,8 @@ static char *pointer(const char *fmt, ch
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
+	case 'R':
+		return resource_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
@@ -590,6 +626,7 @@ static char *pointer(const char *fmt, ch
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
  * %pF output the name of a function pointer
+ * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
