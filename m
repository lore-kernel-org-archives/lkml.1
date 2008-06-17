Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbYFQWwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbYFQWwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYFQWwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:52:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbYFQWwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:52:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Wed, 18 Jun 2008 00:53:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl> <200806172338.38318.rjw@sisk.pl>
In-Reply-To: <200806172338.38318.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806180053.40044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 of June 2008, Rafael J. Wysocki wrote:
> On Tuesday, 17 of June 2008, Maciej W. Rozycki wrote:
> > On Tue, 17 Jun 2008, Rafael J. Wysocki wrote:
> > 
> > > May I gently ask that the patch ("x86: I/O APIC: timer through 8259A second-chance")
> > > be reverted?
> > 
> >  We're trying to find a solution for a long-standing problem and this
> > patch is a step in that direction.  We need to find out exactly what is
> > going wrong with the HP nx6325 system and removing the patch would make us
> > lose the opportunity to get things right in this area.  At the time I
> > submitted that patch I warned a lot of testing would be required before it
> > goes upstream and hopefully my request will get honored.  If you do not
> > want to participate in testing for whatever reason, you have the right to
> > do so, but I insist on the patch to stay at least until we know the source
> > of the problem and conclude there is no other way to get it fixed.  Len
> > reported he's got the same system and it behaves the same, so I hope he'll
> > be able to do the testing if you decide to opt out.
> 
> I can do the testing actually, but IMO putting that patch into linux-next was a
> mistake.
> 
> >  Unfortunately the 64-bit variation has a lot of necessary logging
> > disabled by default (as you have now discovered with the need to rename
> > apic_printk() to printk()), so my plan is to cook up a patch to enable all
> > the available logging facilities around that code first.
> 
> Well, that's easy.  I can send you a dmesg output with all of the printk()s in
> there functional if that helps, but frankly I don't see how this is going to
> get you more information than I've already posted.

Here you go.  Below is the relevant snippet from the yesterday's linux-next
dmesg with the patches:
"x86: I/O APIC: timer through 8259A second-chance"
"x86: add C1E aware idle function"
reverted and the appended debug patch applied.

[    0.108006] TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <2> failed
[    0.108006] ...trying to set up timer as Virtual Wire IRQ...<2> works.

The entire dmesg is at: http://www.sisk.pl/kernel/debug/20080616/dmesg-4.log

Thanks,
Rafael

---
 arch/x86/kernel/io_apic_64.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-next/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-next.orig/arch/x86/kernel/io_apic_64.c
+++ linux-next/arch/x86/kernel/io_apic_64.c
@@ -1667,7 +1667,7 @@ static inline void __init check_timer(vo
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
+	printk(KERN_CRIT "TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		cfg->vector, apic1, pin1, apic2, pin2);
 
 	if (pin1 != -1) {
@@ -1686,14 +1686,14 @@ static inline void __init check_timer(vo
 			goto out;
 		}
 		clear_IO_APIC_pin(apic1, pin1);
-		apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: 8254 timer not "
+		printk(KERN_CRIT "..MP-BIOS bug: 8254 timer not "
 				"connected to IO-APIC\n");
 	}
 
-	apic_printk(APIC_VERBOSE,KERN_INFO "...trying to set up timer (IRQ0) "
+	printk(KERN_CRIT "...trying to set up timer (IRQ0) "
 				"through the 8259A ... ");
 	if (pin2 != -1) {
-		apic_printk(APIC_VERBOSE,"\n..... (found apic %d pin %d) ...",
+		printk(KERN_CRIT "\n..... (found apic %d pin %d) ...",
 			apic2, pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
@@ -1702,7 +1702,7 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
-			apic_printk(APIC_VERBOSE," works.\n");
+			printk(KERN_CRIT " works.\n");
 			timer_through_8259 = 1;
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
@@ -1718,28 +1718,28 @@ static inline void __init check_timer(vo
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 	}
-	apic_printk(APIC_VERBOSE," failed.\n");
+	printk(KERN_CRIT " failed.\n");
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
+		printk(KERN_CRIT "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
 
-	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
+	printk(KERN_CRIT "...trying to set up timer as Virtual Wire IRQ...");
 
 	irq_desc[0].chip = &lapic_irq_type;
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_VERBOSE," works.\n");
+		printk(KERN_CRIT " works.\n");
 		goto out;
 	}
 	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
-	apic_printk(APIC_VERBOSE," failed.\n");
+	printk(KERN_CRIT " failed.\n");
 
-	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as ExtINT IRQ...");
+	printk(KERN_CRIT "...trying to set up timer as ExtINT IRQ...");
 
 	init_8259A(0);
 	make_8259A_irq(0);
@@ -1748,10 +1748,10 @@ static inline void __init check_timer(vo
 	unlock_ExtINT_logic();
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_VERBOSE," works.\n");
+		printk(KERN_CRIT " works.\n");
 		goto out;
 	}
-	apic_printk(APIC_VERBOSE," failed :(.\n");
+	printk(KERN_CRIT " failed :(.\n");
 	panic("IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter\n");
 out:
 	local_irq_restore(flags);
