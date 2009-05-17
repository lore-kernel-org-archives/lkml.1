Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZEQHMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZEQHMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZEQHMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:12:13 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:33804 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZEQHMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=nP5v1tJpA8RHtFZ8e2Fo4OnJlw1QT7xkdjmSODS/Sxs/nTRG2T0UaXwBgVtwWA43PE
         JOSfV5igX2Xo++mwh0LZtBf769FhBJoPQSZtuckDU8bLgga2YDoRoKpfR2nuap/AOzHW
         7TXE+pOEYJj7HrA8/sCwXIxM5qENXEjrX3b1M=
Date: Sun, 17 May 2009 16:12:10 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
Message-Id: <20090517161210.4274ddf9.h.mitake@gmail.com>
In-Reply-To: <4A0DFE43.7050705@garzik.org>
References: <49EE37AF.4020507@zytor.com>
	<20090421.173123.191021055.davem@davemloft.net>
	<adak55438gp.fsf_-_@cisco.com>
	<20090428.221228.217954247.davem@davemloft.net>
	<20090429115654.GC11586@elte.hu>
	<49F843BC.7020902@garzik.org>
	<adahc071ie4.fsf@cisco.com>
	<49F8B1A1.4010208@garzik.org>
	<a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>
	<4A0B2B54.5090803@zytor.com>
	<4A0B4C1C.9000706@garzik.org>
	<4A0B5A34.1080301@zytor.com>
	<4A0B6A96.2030008@garzik.org>
	<20090514161903.4ba00c09.h.mitake@gmail.com>
	<4A0DFE43.7050705@garzik.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 19:44:03 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Hitoshi Mitake wrote:
> > On Wed, 13 May 2009 20:49:26 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> H. Peter Anvin wrote:
> >>> Jeff Garzik wrote:
> >>>> Judging from this thread and past, I think people will continue to 
> >>>> complain and get confused, even with the above.
> >>>>
> >>> Do you really think so?  Seems unfortunate, since an API rename would be
> >>> way more invasive.  This is the entirety of the header patch
> >>> (compile-tested using 32-bit allyesconfig).
> >> The header patch does not lessen the confusion, because you cannot look 
> >> at the code and immediately tell what is going on...
> >>
> >> Having a single function's behavior change based on #include selection 
> >> is /not/ intuitive at all, particularly for driver writers.  That is 
> >> unlike almost every other Linux API, where functions' behavior stays 
> >> constant across platforms, regardless of magic "under the hood."
> >>
> >> That sort of trick is reserved for arch maintainers who know what they 
> >> are doing :)
> >>
> >> 	Jeff
> >>
> >>
> >>
> > 
> > I found another way:
> > Making architecture with atomic readq/writeq provide HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC
> > and making architecture with non-atomic readq/writeq provide HAVE_READQ/HAVE_WRITEQ.
> > (HAVE_READQ_ATOMIC/HAVE_WRITEQ_ATOMIC should double as HAVE_READQ/HAVE_WRITEQ.)
> > 
> > So driver programmers who need atomic readq/writeq can judge existence of API they really need.
> > If platform doesn't provide atomic readq/writeq, drivers need these can be disabled by Kconfig.
> > And bugs Roland and David talking about will be banished.
> > How about this? > Roland and David
> > I wrote a test patch. Request for comments.
> > 
> > Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
> > 
> > ---
> >  arch/x86/Kconfig |   16 ++++++++++++++--
> >  1 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index df9e885..c94fc48 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -19,8 +19,6 @@ config X86_64
> >  config X86
> >  	def_bool y
> >  	select HAVE_AOUT if X86_32
> > -	select HAVE_READQ
> > -	select HAVE_WRITEQ
> >  	select HAVE_UNSTABLE_SCHED_CLOCK
> >  	select HAVE_IDE
> >  	select HAVE_OPROFILE
> > @@ -2022,6 +2020,20 @@ config HAVE_ATOMIC_IOMAP
> >  	def_bool y
> >  	depends on X86_32
> >  
> > +config HAVE_READQ
> > +	def_bool y
> > +
> > +config HAVE_WRITEQ
> > +	def_bool y
> > +
> > +config HAVE_READQ_ATOMIC
> > +	def_bool y
> > +	depends on X86_64
> > +
> > +config HAVE_WRITEQ_ATOMIC
> > +	def_bool y
> > +	depends on X86_64
> 
> If you create HAVE_{READQ,WRITEQ}_ATOMIC, then you don't really need 
> HAVE_READQ -- the other relevant 32-bit platforms simply need a 
> definition of readq and writeq.  Probably easy enough to have a common 
> definition in asm-generic.
> 
That's good idea. I didn't noticed the way to use asm-generic. Thanks.

How is this?

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

---
 arch/x86/Kconfig             |   10 ++++++++--
 arch/x86/include/asm/io.h    |   27 ++++++---------------------
 include/asm-generic/quadrw.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 23 deletions(-)
 create mode 100644 include/asm-generic/quadrw.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..151b6a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -19,8 +19,6 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
-	select HAVE_READQ
-	select HAVE_WRITEQ
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
@@ -2022,6 +2020,14 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
+config HAVE_READQ_ATOMIC
+	def_bool y
+	depends on X86_64
+
+config HAVE_WRITEQ_ATOMIC
+	def_bool y
+	depends on X86_64
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7373932..bad940d 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -51,32 +51,17 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
-#else
-
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-
-#endif
-
 #define readq_relaxed(a)	readq(a)
 
 #define __raw_readq(a)		readq(a)
 #define __raw_writeq(val, addr)	writeq(val, addr)
 
+#endif	/* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
+#include <asm-generic/quadrw.h>
+#endif	/* CONFIG_X86_32 */
+
 /* Let people know that we have them */
 #define readq			readq
 #define writeq			writeq
diff --git a/include/asm-generic/quadrw.h b/include/asm-generic/quadrw.h
new file mode 100644
index 0000000..78159a2
--- /dev/null
+++ b/include/asm-generic/quadrw.h
@@ -0,0 +1,34 @@
+#ifndef GENERIC_QUADRW_H
+#define GENERIC_QUADRW_H
+
+#include <asm/io.h>
+
+/*
+ * General readq/writeq implementation.
+ * These are not atomic operations.
+ * The drivers which need atomic version readq/writeq,
+ * they should depend on HAVE_{READQ,WRITEQ}_ATOMIC in Kconfig level.
+ */
+
+#ifndef CONFIG_HAVE_READQ_ATOMIC
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+#endif	/* CONFIG_HAVE_READQ_ATOMIC */
+
+#ifndef CONFIG_HAVE_WRITEQ_ATOMIC
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr+4);
+}
+#endif	/* CONFIG_HAVE_WRITEQ_ATOMIC */
+
+#endif	/* GENERIC_QUADRW_H */
-- 
1.5.6.5


