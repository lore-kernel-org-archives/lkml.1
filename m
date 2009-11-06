Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZKFGxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZKFGxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZKFGxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:53:04 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:54074 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZKFGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:53:03 -0500
Date: Fri, 6 Nov 2009 06:53:08 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
In-Reply-To: <1257465692.4394.295.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0911060623390.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>  <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>  <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>  <1257301490.2668.280.camel@sbs-t61.sc.intel.com> 
 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>  <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org> <1257465692.4394.295.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Suresh Siddha wrote:

> >  I've checked some docs too and you may want to check whether to qualify 
> > the use of the EOI register further with the DT (Delivery Type) bit in the 
> > Boot Configuration register.  It affects ICH2 at least
> 
> For relatively newer ICH's like ICH5, boot configuration register is
> marked as a reserved register (perhaps with the serial bus going away,
> so did this register but again with out the io-apic version change).
> 
> Anyways, our understanding is that EOI register in ICH2 should work
> irrespective of DT bit in the boot config register.

 What I mean is if the serial delivery type is used, then an interrupt 
will be acked twice -- once via an EOI message sent from the local APIC 
over the serial bus and then again via the write to the EOI register.  
There is a race condition here, so if the IRQ line is still/again 
asserted, then most likely two consecutive IRQ messages will be sent by 
the I/O APIC and they may be accepted by two different local units and 
eventually delivered to the OS.  Linux will cope, but still this is sloppy 
programming, so it should be best avoided -- if possible that is.

> >  Also you may want to see whether the complication in ack_apic_level() 
> > that is meant to deal with an APIC erratum really matters for FSB delivery 
> > -- I guess not, because if you explicitly ACK an interrupt in the I/O 
> > unit, then even if it was incorrectly recorded as edge-triggered in the 
> > local unit, the IRR bit will be correctly reset and the next message 
> > delivered properly.  Given you introduce a conditional statement anyway, 
> > you can place more code within it and there will be no performance hit for 
> > the other path and certainly a gain for this one.
> 
> I am not sure if I follow. With the recent changes (tip commit
> 5231a68614b94f60e8f6c56bc6e3d75955b9e75e), we use ipi on a new cpu to
> handle a pending level-triggered  interrupt on the cpu that is going
> offline. It's just not only in the case of io-apic erratum for 0x11, we
> see level triggered interrupt as edge interrupt at the cpu.

 I don't get it, sorry -- an interrupt has its trigger mode implied by the 
IRQ_LEVEL status flag being set or clear in the IRQ's descriptor.  What's 
set in the local APIC's TMR does not (or should not) matter IMO.

 Has the trigger mode mismatch erratum been seen for FSB delivered 
interrupts anyway?  My proposed patch is below.  Includes the code 
rearrangement I proposed as well.  Untested, not even built.

  Maciej
---
 Complete the EOI dance for the trigger mode mismatch APIC erratum before 
proceeding to IRQ migration.  Omit the erratum workaround for I/O APICs 
using FSB delivery as they get their EOI message delivered by hand.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 31e9db3..6e4edad 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2555,33 +2555,50 @@ static void ack_apic_level(unsigned int irq)
 #endif
 
 	/*
-	 * It appears there is an erratum which affects at least version 0x11
-	 * of I/O APIC (that's the 82093AA and cores integrated into various
-	 * chipsets).  Under certain conditions a level-triggered interrupt is
-	 * erroneously delivered as edge-triggered one but the respective IRR
-	 * bit gets set nevertheless.  As a result the I/O unit expects an EOI
-	 * message but it will never arrive and further interrupts are blocked
-	 * from the source.  The exact reason is so far unknown, but the
-	 * phenomenon was observed when two consecutive interrupt requests
-	 * from a given source get delivered to the same CPU and the source is
-	 * temporarily disabled in between.
-	 *
-	 * A workaround is to simulate an EOI message manually.  We achieve it
-	 * by setting the trigger mode to edge and then to level when the edge
-	 * trigger mode gets detected in the TMR of a local APIC for a
-	 * level-triggered interrupt.  We mask the source for the time of the
-	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
-	 * The idea is from Manfred Spraul.  --macro
+	 * We must acknowledge the irq before we move it or the acknowledge
+	 * will not propagate properly.
 	 */
-	cfg = desc->chip_data;
-	i = cfg->vector;
-	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
+	if (use_eoi_reg) {
+		ack_APIC_irq();
+		eoi_ioapic_irq(desc);
+	} else {
+		/*
+		 * It appears there is an erratum which affects at least
+		 * version 0x11 of I/O APIC (that's the 82093AA and cores
+		 * integrated into various chipsets).  Under certain
+		 * conditions a level-triggered interrupt is erroneously
+		 * delivered as edge-triggered one but the respective IRR
+		 * bit gets set nevertheless.  As a result the I/O unit
+		 * expects an EOI message but it will never arrive and
+		 * further interrupts are blocked from the source.  The
+		 * exact reason is so far unknown, but the phenomenon was
+		 * observed when two consecutive interrupt requests from
+		 * a given source get delivered to the same CPU and the
+		 * source is temporarily disabled in between.
+		 *
+		 * A workaround is to simulate an EOI message manually.
+		 * We achieve it by setting the trigger mode to edge and
+		 * then to level when the edge trigger mode gets detected
+		 * in the TMR of a local APIC for a level-triggered
+		 * interrupt.  We mask the source for the time of the
+		 * operation to prevent an edge-triggered interrupt
+		 * escaping meanwhile.
+		 *
+		 * The idea is from Manfred Spraul.  --macro
+		 */
+		cfg = desc->chip_data;
+		i = cfg->vector;
+		v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 
-	/*
-	 * We must acknowledge the irq before we move it or the acknowledge will
-	 * not propagate properly.
-	 */
-	ack_APIC_irq();
+		ack_APIC_irq();
+
+		/* Tail end of version 0x11 I/O APIC bug workaround. */
+		atomic_inc(&irq_mis_count);
+		spin_lock(&ioapic_lock);
+		__mask_and_edge_IO_APIC_irq(cfg);
+		__unmask_and_level_IO_APIC_irq(cfg);
+		spin_unlock(&ioapic_lock);
+	}
 
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
@@ -2616,20 +2633,6 @@ static void ack_apic_level(unsigned int irq)
 			move_masked_irq(irq);
 		unmask_IO_APIC_irq_desc(desc);
 	}
-
-	/* Tail end of version 0x11 I/O APIC bug workaround */
-	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
-
-		if (use_eoi_reg)
-			eoi_ioapic_irq(desc);
-		else {
-			spin_lock(&ioapic_lock);
-			__mask_and_edge_IO_APIC_irq(cfg);
-			__unmask_and_level_IO_APIC_irq(cfg);
-			spin_unlock(&ioapic_lock);
-		}
-	}
 }
 
 #ifdef CONFIG_INTR_REMAP
