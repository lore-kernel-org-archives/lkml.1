Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXLNODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXLNODy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXLNODq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:03:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXLNODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:03:45 -0500
Date: Fri, 14 Dec 2007 15:03:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071214140317.GA1007@elte.hu>
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <47628842.5060908@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47628842.5060908@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rene Herman <rene.herman@gmail.com> wrote:

> On 14-12-07 14:15, Ingo Molnar wrote:
>
>> wow, cool fix! (I remember that there were other systems as well that are 
>> affected by port 0x80 muckery - i thought we had removed port 0x80 
>> accesses long ago.)
>>
>> how about the simpler fix below, as a first-level approach? We can 
>> then remove the _p in/out sequences after this.
>
> Your version does the same thing that the version from Pavel/David 
> does for 32-bit at least.

well, if you carefully look at the code it's not the "same" but a 
similar but cleaner thing - it moves this quirk out of a common include 
file. I take back the "simpler" characterisation - my patch indeed ended 
up being almost the same as David's.

>> +/*
>> + * Some legacy devices need delays for IN/OUT sequences. Most are
>> + * probably not needed but it's the safest to just do this short delay:
>> + */
>> +void native_io_delay(void)
>> +{
>> +	udelay(1);
>> +}
>
> Also note the thread(s) on LKML where 2 us was decided to be a nicely 
> conservative value:

yep, i have updated the delay to 2 usecs. The latest patch is below, as 
queued up in x86.git. (not yet queued up for .24 - it's pending testing 
and more feedback, etc.)

	Ingo

----------------->
Subject: x86: fix in_p/out_p crashes
From: David P. Reed <dpreed@reed.com>

Do not use port 0x80, it can cause crashes, see:

 http://bugzilla.kernel.org/show_bug.cgi?id=6307
 http://bugzilla.kernel.org/show_bug.cgi?id=9511

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

[ mingo@elte.hu: minor restructuring, 32-bit support. ]

Signed-off-by: David P. Reed <dpreed@reed.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/compressed/misc_32.c |    8 ++++----
 arch/x86/boot/compressed/misc_64.c |    8 ++++----
 arch/x86/kernel/quirks.c           |   10 ++++++++++
 include/asm-x86/io_32.h            |    5 +----
 include/asm-x86/io_64.h            |   14 +++++---------
 5 files changed, 24 insertions(+), 21 deletions(-)

Index: linux-x86.q/arch/x86/boot/compressed/misc_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_32.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_32.c
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
Index: linux-x86.q/arch/x86/boot/compressed/misc_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_64.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_64.c
@@ -269,10 +269,10 @@ static void putstr(const char *s)
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
Index: linux-x86.q/arch/x86/kernel/quirks.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/quirks.c
+++ linux-x86.q/arch/x86/kernel/quirks.c
@@ -3,9 +3,19 @@
  */
 #include <linux/pci.h>
 #include <linux/irq.h>
+#include <linux/delay.h>
 
 #include <asm/hpet.h>
 
+/*
+ * Some legacy devices need delays for IN/OUT sequences. Most are
+ * probably not needed but it's the safest to just do this short delay:
+ */
+void native_io_delay(void)
+{
+	udelay(2);
+}
+
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
 static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
Index: linux-x86.q/include/asm-x86/io_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_32.h
+++ linux-x86.q/include/asm-x86/io_32.h
@@ -250,10 +250,7 @@ static inline void flush_write_buffers(v
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void native_io_delay(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
Index: linux-x86.q/include/asm-x86/io_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_64.h
+++ linux-x86.q/include/asm-x86/io_64.h
@@ -35,13 +35,7 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
-
-#ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
-#else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
-#endif
+extern void native_io_delay(void);
 
 /*
  * Talk about misusing macros..
@@ -54,7 +48,8 @@ __asm__ __volatile__ ("out" #s " %" s1 "
 
 #define __OUT(s,s1,x) \
 __OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), "Nd" (port));} \
+__OUT1(s##_p,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); \
+native_io_delay(); } \
 
 #define __IN1(s) \
 static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
@@ -64,7 +59,8 @@ __asm__ __volatile__ ("in" #s " %" s2 "1
 
 #define __IN(s,s1,i...) \
 __IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
+__IN1(s##_p) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; \
+native_io_delay(); } \
 
 #define __INS(s) \
 static inline void ins##s(unsigned short port, void * addr, unsigned long count) \
