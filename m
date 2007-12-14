Return-Path: <linux-kernel-owner+w=401wt.eu-S1765509AbXLNC7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765509AbXLNC7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbXLNC7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:59:35 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:53372 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXLNC7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:59:34 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX186tAJM77AgQXT6M1kk5j52
Message-ID: <4761F193.7090400@reed.com>
Date: Thu, 13 Dec 2007 21:59:31 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some
 AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos>
In-Reply-To: <1184274754.12353.254.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of outb to "unused" diagnostic port 0x80 for time delay
with udelay based time delay on x86_64 architecture machines.  Fix for
bugs 9511 and 6307 in bugzilla, plus bugs reported in
bugzilla.redhat.com.

Derived from suggestion (that didn't compile) by Pavel Machek, and
tested, also based on measurements of typical timings of out's
collated by Rene Herman from many in the community.

This patch fixes a number of bugs known to cause problems on HP
Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
when hwclock is used to show or set the time.  Also, it potentially
improves bus utilization on SMP machines, by using a waiting process
that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.

i386 family fixes (completely parallel) were not included, considering
that such machines might involve more risk of problems on legacy machines.

Signed-off-by: David P. Reed <dpreed@reed.com>

Index: linux-2.6/arch/x86/boot/compressed/misc_64.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc_64.c
+++ linux-2.6/arch/x86/boot/compressed/misc_64.c
@@ -269,10 +269,10 @@ static void putstr(const char *s)
         RM_SCREEN_INFO.orig_y = y;

         pos = (x + cols * y) * 2;       /* Update cursor position */
-       outb_p(14, vidport);
-       outb_p(0xff & (pos >> 9), vidport+1);
-       outb_p(15, vidport);
-       outb_p(0xff & (pos >> 1), vidport+1);
+       outb(14, vidport);
+       outb(0xff & (pos >> 9), vidport+1);
+       outb(15, vidport);
+       outb(0xff & (pos >> 1), vidport+1);
  }

  static void* memset(void* s, int c, unsigned n)
Index: linux-2.6/include/asm/io_64.h
===================================================================
--- linux-2.6.orig/include/asm/io_64.h
+++ linux-2.6/include/asm/io_64.h
@@ -1,6 +1,7 @@
  #ifndef _ASM_IO_H
  #define _ASM_IO_H

+#include <linux/delay.h>

  /*
   * This file contains the definitions for the x86 IO instructions
@@ -15,19 +16,7 @@
   * mistake somewhere.
   */

-/*
- * Thanks to James van Artsdalen for a better timing-fix than
- * the two short jumps: using outb's to a nonexistent port seems
- * to guarantee better timings even on fast machines.
- *
- * On the other hand, I'd like to be sure of a non-existent port:
- * I feel a bit unsafe about using 0x80 (should be safe, though)
- *
- *             Linus
- */
-
- /*
-  *  Bit simplified and optimized by Jan Hubicka
+/*   Bit simplified and optimized by Jan Hubicka
    *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
    *
    *  isa_memset_io, isa_memcpy_fromio, isa_memcpy_toio added,
@@ -35,36 +24,36 @@
    *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
    */

-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
-
+/* the following delays are really conservative, at least for modern 
machines */
  #ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO 
__SLOW_DOWN_IO __SLOW_DOWN_IO
+#define _IOPORT_PAUSE_DELAY 10
  #else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
+#define _IOPORT_PAUSE_DELAY 2
  #endif

  /*
   * Talk about misusing macros..
   */
-#define __OUT1(s,x) \
+#define __OUT1(s, x) \
  static inline void out##s(unsigned x value, unsigned short port) {

-#define __OUT2(s,s1,s2) \
-__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1"
-
-#define __OUT(s,s1,x) \
-__OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), 
"Nd" (port));} \
+#define __OUT2(s, s1, s2) \
+  __asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1" : : "a" (value), 
"Nd" \
+(port));
+
+#define __OUT(s, s1, x) \
+__OUT1(s, x) __OUT2(s, s1, "w") } \
+ __OUT1(s##_p, x) __OUT2(s, s1, "w") udelay(_IOPORT_PAUSE_DELAY); } \

  #define __IN1(s) \
  static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;

-#define __IN2(s,s1,s2) \
-__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0"
+#define __IN2(s, s1, s2) \
+__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0" : "=a" (_v) : "Nd" 
(port));

-#define __IN(s,s1,i...) \
-__IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" 
(port) ,##i ); return _v; } \
+#define __IN(s, s1) \
+__IN1(s) __IN2(s, s1, "w") return _v; } \
+ __IN1(s##_p) __IN2(s, s1, "w") udelay(_IOPORT_PAUSE_DELAY); return _v; } \

  #define __INS(s) \
  static inline void ins##s(unsigned short port, void * addr, unsigned 
long count) \

