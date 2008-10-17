Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYJQDCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYJQDCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYJQDCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:02:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:34580 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbYJQDCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:02:35 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081016.013850.85183428.davem@davemloft.net>
References: <48F409E9.3030501@zytor.com>
	 <20081013.223811.174710738.davem@davemloft.net>
	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	 <20081016.013850.85183428.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:02:13 +1100
Message-Id: <1224212533.7654.60.camel@pasglop>
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

Time that we sort that out once for all. I have patches for converting
some of PCI that I'll send later, and doing more as we speak.

I took Linus variant, added 0x and made it print lowercase. There's
still the question of whether we want to also make it pad with zeros
(the number of zeros being based on the size of resource_size_t,
maybe with hacks to limit IO size on x86 ?)

Let me know and I'll respin if necessary.

Index: linux-work/lib/vsprintf.c
===================================================================
--- linux-work.orig/lib/vsprintf.c	2008-10-17 13:30:18.000000000 +1100
+++ linux-work/lib/vsprintf.c	2008-10-17 13:55:25.000000000 +1100
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/ioport.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/div64.h>
@@ -550,6 +551,22 @@ static char *symbol_string(char *buf, ch
 #endif
 }
 
+static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
+{
+	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
+	char sym[4*sizeof(resource_size_t) + 8];
+	char *p = sym, *pend = sym + sizeof(sym);
+
+	*p++ = '[';
+	p = number(p, pend, res->start, 16, -1, -1, SPECIAL | SMALL);
+	*p++ = '-';
+	p = number(p, pend, res->end, 16, -1, -1, SPECIAL | SMALL);
+	*p++ = ']';
+	*p = 0;
+
+	return string(buf, end, sym, field_width, precision, flags);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -571,6 +588,8 @@ static char *pointer(const char *fmt, ch
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
+	case 'R':
+		return resource_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {


