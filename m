Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbXLNNe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbXLNNe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759477AbXLNNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:34:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762882AbXLNNeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:34:18 -0500
Date: Fri, 14 Dec 2007 14:33:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071214133338.GA24895@elte.hu>
References: <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211131413.1079be59@the-village.bc.nu> <20071211133249.GA16750@one.firstfloor.org> <20071211134725.GB17992@elf.ucw.cz> <20071211135020.GB16750@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211135020.GB16750@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Why is TSC significant? udelay() based on bogomips seems to be good 
> > enough...?
> 
> Maybe I'm not sure how accurate it really is on non TSC system. On the 
> other hand it is unclear that the port 80 IO is always the same time 
> so it's probably ok to vary a bit. So most likely going to udelay() 
> unconditionally is fine.

yep, agreed, and have queued up the patch below. I've killed the 
misc_*.c outb_p() uses because they happen before there's an udelay() 
available - but that should be perfectly fine anyway: i dont remember 
any video hardware that needed pauses for cursor updates, i think those 
_p()'s just came in accidentally. (there's hardware that needed _p() for 
other aspects of video such as mode switching - but cursor updates ...)

	Ingo

------------------>
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
 arch/x86/kernel/quirks.c           |   10 ++++++++++
 include/asm-x86/io_32.h            |    5 +----
 include/asm-x86/io_64.h            |    5 +----
 5 files changed, 20 insertions(+), 16 deletions(-)

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

