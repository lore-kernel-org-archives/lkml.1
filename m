Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYBAOad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYBAOad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYBAOa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:30:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbYBAOaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:30:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Fri, 1 Feb 2008 15:28:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801281802.01748.rjw@sisk.pl> <20080201135125.GA16249@elte.hu>
In-Reply-To: <20080201135125.GA16249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011528.17423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > >  arch/x86/kernel/built-in.o: In function `wakeup_start':
> > >  : undefined reference to `swsusp_pg_dir'
> > > 
> > > config attached.
> > 
> > I see.  CONFIG_HIBERNATION && CONFIG_ACPI -> CONFIG_ACPI_SLEEP and the 
> > Makefile in arch/x86/kernel/acpi/ wants to build wakeup.S, which is 
> > not necessary.  Hmm.
> > 
> > We can do a couple of things:
> > (1) make wakeup_$(BITS).o depend on CONFIG_SUSPEND (alone)
> >     This will build it if CONFIG_SUSPEND is set, but CONFIG_ACPI is not
> >     (still, that's consistent with the change in question).
> > (2) make wakeup_$(BITS).o depend on CONFIG_SUSPEND and CONFIG_ACPI
> > (3) define CONFIG_ACPI_SUSPEND depending on ACPI and SUSPEND and
> >     make wakeup_$(BITS).o as well as swsusp_pg_dir depend on that (most
> >     elegant)
> > 
> > Which one do you prefer?
> 
> no strong preference here - pick the one you like best and send a patch 
> please :-)

Here you go, but I think it falls into the ACPI category.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Since hibernation uses its own temporary page tables for restoring
the image kernel, swsusp_pg_dir is only needed for ACPI resume from
RAM.  Also, some files under arch/x86/kernel/acpi need only be compiled
if ACPI suspend to RAM is going to be used.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/Makefile |    2 +-
 arch/x86/mm/init_32.c         |   10 +++++-----
 drivers/acpi/Kconfig          |    5 +++++
 3 files changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -423,23 +423,23 @@ static void __init pagetable_init(void)
 	paravirt_pagetable_setup_done(pgd_base);
 }
 
-#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI_SUSPEND
 /*
- * Swap suspend & friends need this for resume because things like the intel-agp
+ * ACPI suspend needs this for resume, because things like the intel-agp
  * driver might have split up a kernel 4MB mapping.
  */
-char __nosavedata swsusp_pg_dir[PAGE_SIZE]
+char swsusp_pg_dir[PAGE_SIZE]
 	__attribute__ ((aligned(PAGE_SIZE)));
 
 static inline void save_pg_dir(void)
 {
 	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
 }
-#else
+#else /* !CONFIG_ACPI_SUSPEND */
 static inline void save_pg_dir(void)
 {
 }
-#endif
+#endif /* !CONFIG_ACPI_SUSPEND */
 
 void zap_low_mappings(void)
 {
Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -42,6 +42,11 @@ menuconfig ACPI
 
 if ACPI
 
+config ACPI_SUSPEND
+	bool
+	depends on SUSPEND
+	default y
+
 config ACPI_SLEEP
 	bool
 	depends on PM_SLEEP
Index: linux-2.6/arch/x86/kernel/acpi/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/Makefile
+++ linux-2.6/arch/x86/kernel/acpi/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_ACPI)		+= boot.o
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_SUSPEND)	+= sleep.o wakeup_$(BITS).o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
