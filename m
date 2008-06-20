Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYFTAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYFTAgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 20:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYFTAgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 20:36:31 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63246 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751198AbYFTAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 20:36:30 -0400
Date: Fri, 20 Jun 2008 01:35:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806190225.51088.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806200024170.12929@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806190011.38548.rjw@sisk.pl>
 <Pine.LNX.4.55.0806182345380.7802@cliff.in.clinika.pl> <200806190225.51088.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Rafael J. Wysocki wrote:

> That helped a lot, the system seems to work normally now.
> 
> Here's the relevant snippet from dmesg:
> 
> [    0.108006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <3>
> [    0.108006] ..... (found apic 0 pin 2) ...<3> failed.
> [    0.108006] ...trying to set up timer as Virtual Wire IRQ...<3> works.
> 
> and the whole thing is at: http://www.sisk.pl/kernel/debug/20080618/dmesg-2.log

 Hmm, that only proved the 8259A is indeed wired to the pin #2 of the I/O 
APIC.

> I, personally, don't have any and AMD only has SB600 documentation on its
> web page (it's still marked as "AMD confidential" ;-)).

 Well, the IC block is most likely the same as that's not rocket science
and once done there is no need to fiddle with that.  That written, I am
afraid there is nothing useful about the IC in the document, except that
it's there and consists of an I/O APIC providing 24 inputs and the usual
pair of 8259A cores.  Thanks for the reference anyway.

> There is an interrupt controller in there, but I'm not sure if there's any
> 8259A.  The northbridge is on the CPU, actually.

 I will praise the day someone ships an x86 machine without an 8259A core!

 As expressed in another mail I suspect there may actually be a direct
route from the 8254 to INTIN0 in the southbridge -- this is what other
bootstrap logs seen in the Internet suggest.  This would mean this
particular BIOS is buggy (is it the latest version?) and provides an
incorrect IRQ override in its ACPI tables, for example because the
responsible block has been blindly copied from a machine using a commoner
wiring.  This could be moderately easily fixed up with a quirk based on
the PCI ID (after checking it again, we actually used to have a quirk for
ATI in this area, but the way it was done suggests the issue was not
understood well enough).

 Could you please remove the hack sent yesterday and test the patch
provided below?  I do hope it builds, but I have no immediate means to
check it.  Please report the output.  The intent is to test INTIN0
directly before testing INTIN2 through the 8259A.  Thanks.

 Aside of that, what I have gathered from your reports (please correct me
if I have got it wrong) is that when the through-8259A mode is used, then
after a while 8254 timer interrupts stop arriving.  What's interesting,
the "Virtual Wire IRQ" seems to work for you correctly (that's quite an
odd setup where a local APIC input is used in the native mode -- please
post /proc/interrupts for confirmation), which in turn implies the master
8259A drives its INT output as we expect.  Why would the I/O APIC input
have problems then?  Hmm...

  Maciej

patch-2.6.26-rc1-20080505-ioapic-replace-debug-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-06-18 03:24:54.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-06-20 00:12:39.000000000 +0000
@@ -360,6 +360,26 @@ static void add_pin_to_irq(unsigned int 
 	entry->pin = pin;
 }
 
+/*
+ * Reroute an IRQ to a different pin.
+ */
+static void __init replace_pin_at_irq(unsigned int irq,
+				      int oldapic, int oldpin,
+				      int newapic, int newpin)
+{
+	struct irq_pin_list *entry = irq_2_pin + irq;
+
+	while (1) {
+		if (entry->apic == oldapic && entry->pin == oldpin) {
+			entry->apic = newapic;
+			entry->pin = newpin;
+		}
+		if (!entry->next)
+			break;
+		entry = irq_2_pin + entry->next;
+	}
+}
+
 
 #define DO_ACTION(name,R,ACTION, FINAL)					\
 									\
@@ -1679,6 +1699,11 @@ static inline void __init check_timer(vo
 		apic2 = apic1;
 	}
 
+	replace_pin_at_irq(0, 0, 0, apic1, pin1);
+	apic1 = 0;
+	pin1 = 0;
+	setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
@@ -1711,7 +1736,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		/* replace_pin_at_irq(0, apic1, pin1, apic2, pin2); */
+		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
