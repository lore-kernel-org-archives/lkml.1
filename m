Return-Path: <linux-kernel-owner+w=401wt.eu-S933474AbXLNNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbXLNNPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXLNNPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:15:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765851AbXLNNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:15:32 -0500
Date: Fri, 14 Dec 2007 14:15:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071214131502.GA14359@elte.hu>
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4761F193.7090400@reed.com>
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


* David P. Reed <dpreed@reed.com> wrote:

> Replace use of outb to "unused" diagnostic port 0x80 for time delay 
> with udelay based time delay on x86_64 architecture machines.  Fix for 
> bugs 9511 and 6307 in bugzilla, plus bugs reported in 
> bugzilla.redhat.com.
>
> Derived from suggestion (that didn't compile) by Pavel Machek, and 
> tested, also based on measurements of typical timings of out's 
> collated by Rene Herman from many in the community.
>
> This patch fixes a number of bugs known to cause problems on HP
> Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
> when hwclock is used to show or set the time.  Also, it potentially
> improves bus utilization on SMP machines, by using a waiting process
> that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.
>
> i386 family fixes (completely parallel) were not included, considering 
> that such machines might involve more risk of problems on legacy 
> machines.

wow, cool fix! (I remember that there were other systems as well that 
are affected by port 0x80 muckery - i thought we had removed port 0x80 
accesses long ago.)

how about the simpler fix below, as a first-level approach? We can then 
remove the _p in/out sequences after this.

this is also something for v2.6.24 merging.

	Ingo

----------------------------->
Subject: x86: fix in/out_p delays
From: Ingo Molnar <mingo@elte.hu>

Debugged by David P. Reed <dpreed@reed.com>.

Do not use port 0x80, it can cause crashes, see:

 http://bugzilla.kernel.org/show_bug.cgi?id=6307
 http://bugzilla.kernel.org/show_bug.cgi?id=9511

instead of just removing _p postfixes en masse, lets just first
remove the 0x80 port usage, then remove any unnecessary _p io ops
gradually. It's more debuggable this way.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/compressed/misc_32.c |    8 ++++----
 arch/x86/boot/compressed/misc_64.c |    8 ++++----
 arch/x86/kernel/quirks.c           |    9 +++++++++
 include/asm-x86/io_32.h            |    5 +----
 include/asm-x86/io_64.h            |    5 +----
 5 files changed, 19 insertions(+), 16 deletions(-)

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
@@ -275,10 +275,10 @@ static void putstr(const char *s)
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
@@ -6,6 +6,15 @@
 
 #include <asm/hpet.h>
 
+/*
+ * Some legacy devices need delays for IN/OUT sequences. Most are
+ * probably not needed but it's the safest to just do this short delay:
+ */
+void native_io_delay(void)
+{
+	udelay(1);
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
@@ -35,10 +35,7 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void native_io_delay(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
