Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbXLIVYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbXLIVYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXLIVYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:24:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39775 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbXLIVYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:24:42 -0500
Date: Sun, 9 Dec 2007 22:25:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071209212513.GC24284@elf.ucw.cz>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209165908.GA15910@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-09 17:59:08, Andi Kleen wrote:
> > I mean, we expect 8usec delay -- historical ISA timing -- but when
> > _PCI_ card with leds is inserted, it is likely to be faster than old
> > ISA, right?
> 
> Yes, i guess switching to udelay at least on newer systems would
> be a good idea.  I'm not quite sure about systems without TSC though.

Something like this? (Warning, will not probably even compile on
x86-64, I do not have 64-bit compiler near me).

(I believe VGA cards do not need slow outputs, plus udelay is not
available in uncompressor?)

Signed-off-by: Pavel Machek <pavel@suse.cz>	[but it needs fixing x86-64]
								Pavel

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index b74d60d..288e162 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -276,10 +276,10 @@ static void putstr(const char *s)
 	RM_SCREEN_INFO.orig_y = y;
 
 	pos = (x + cols * y) * 2;	/* Update cursor position */
-	outb_p(14, vidport);
-	outb_p(0xff & (pos >> 9), vidport+1);
-	outb_p(15, vidport);
-	outb_p(0xff & (pos >> 1), vidport+1);
+	outb(14, vidport);
+	outb(0xff & (pos >> 9), vidport+1);
+	outb(15, vidport);
+	outb(0xff & (pos >> 1), vidport+1);
 }
 
 static void* memset(void* s, int c, unsigned n)
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index fe881cd..944dc5f 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -3,6 +3,7 @@ #define _ASM_IO_H
 
 #include <linux/string.h>
 #include <linux/compiler.h>
+#include <linux/delay.h>
 
 /*
  * This file contains the definitions for the x86 IO instructions
@@ -17,17 +18,6 @@ #include <linux/compiler.h>
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
- *		Linus
- */
-
  /*
   *  Bit simplified and optimized by Jan Hubicka
   *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
@@ -252,7 +242,7 @@ #endif /* __KERNEL__ */
 
 static inline void native_io_delay(void)
 {
-	asm volatile("outb %%al,$0x80" : : : "memory");
+	udelay(8);
 }
 
 #if defined(CONFIG_PARAVIRT)
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..6dd5ed3 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_IO_H
 #define _ASM_IO_H
 
+#include <linux/delay.h>
 
 /*
  * This file contains the definitions for the x86 IO instructions
@@ -15,17 +16,6 @@ #define _ASM_IO_H
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
- *		Linus
- */
-
  /*
   *  Bit simplified and optimized by Jan Hubicka
   *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
@@ -35,12 +25,10 @@ #define _ASM_IO_H
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
-
 #ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
+#define P_DELAY 40
 #else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
+#define P_DELAY 8
 #endif
 
 /*
@@ -54,7 +42,7 @@ __asm__ __volatile__ ("out" #s " %" s1 "
 
 #define __OUT(s,s1,x) \
 __OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), "Nd" (port));} \
+__OUT1(s##_p,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port));} udelay(P_DELAY); \
 
 #define __IN1(s) \
 static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
@@ -64,7 +52,7 @@ __asm__ __volatile__ ("in" #s " %" s2 "1
 
 #define __IN(s,s1,i...) \
 __IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
+__IN1(s##_p) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); udelay(P_DELAY); return _v; } \
 
 #define __INS(s) \
 static inline void ins##s(unsigned short port, void * addr, unsigned long count) \

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
