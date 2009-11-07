Return-Path: <linux-kernel-owner+w=401wt.eu-S1751145AbZKGH3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbZKGH3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 02:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZKGH3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 02:29:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:62566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZKGH3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 02:29:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,699,1249282800"; 
   d="scan'208";a="744707744"
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
In-Reply-To: <alpine.LFD.2.00.0911060623390.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
	 <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
	 <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
	 <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
	 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>
	 <1257465692.4394.295.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0911060623390.9725@eddie.linux-mips.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 06 Nov 2009 23:27:50 -0800
Message-Id: <1257578870.2536.52.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 22:53 -0800, Maciej W. Rozycki wrote:
>  What I mean is if the serial delivery type is used, then an interrupt 
> will be acked twice -- once via an EOI message sent from the local APIC 
> over the serial bus and then again via the write to the EOI register.  

Maciej, Case where we are doing an explicit EOI to the io-apic (using
EOI register) is when the level triggered interrupt gets registered at
the cpu as an edge interrupt (in the local apic's trigger mode
register).

It will arrive as an edge interrupt for two cases.
a) for corner conditions which hit the 82093AA (io-apic version 0x11)
erratum
b) with my recent patch in -tip, during a cpu offline, when we send an
ipi (IPI is always registered as an edge triggered at the cpu) to
service the interrupt at the new cpu destination, instead of servicing
at it's old destination cpu (as it has already disabled interrupts and
going down -- like not being on the cpu_online_map etc).

So we are not acking the io-apic twice in this case, as the eoi to the
local apic won't brodcast the eoi to the io-apic (because of the edge
mode in trigger mode register of the local apic).

> There is a race condition here, so if the IRQ line is still/again 
> asserted, then most likely two consecutive IRQ messages will be sent by 
> the I/O APIC and they may be accepted by two different local units and 
> eventually delivered to the OS.  Linux will cope, but still this is sloppy 
> programming, so it should be best avoided -- if possible that is.

I hope the above clarified.

> > 
> > I am not sure if I follow. With the recent changes (tip commit
> > 5231a68614b94f60e8f6c56bc6e3d75955b9e75e), we use ipi on a new cpu to
> > handle a pending level-triggered  interrupt on the cpu that is going
> > offline. It's just not only in the case of io-apic erratum for 0x11, we
> > see level triggered interrupt as edge interrupt at the cpu.
> 
>  I don't get it, sorry -- an interrupt has its trigger mode implied by the 
> IRQ_LEVEL status flag being set or clear in the IRQ's descriptor.  What's 
> set in the local APIC's TMR does not (or should not) matter IMO.

Same, did the above clarify?

> 
>  Has the trigger mode mismatch erratum been seen for FSB delivered 
> interrupts anyway? 

No.

>  Complete the EOI dance for the trigger mode mismatch APIC erratum before 
> proceeding to IRQ migration. 

I am ok with what you are tying to fix, but not your patch. please see
below.

> +	if (use_eoi_reg) {
> +		ack_APIC_irq();
> +		eoi_ioapic_irq(desc);

We shouldn't do this unconditionally. i.e., we should do this double ack
only when the level-triggered interrupt is seen as an edge triggered
interrupt at the  cpu (specified by the trigger mode register in local
apic).

Otherwise as you mentioned above, we will see two EOI msg's at the
io-apic (one by the cpu's eoi broadcast and another by explicit eoi to
the io-apic).

Best way to fix the issue you noticed is by simply moving the tail end
of that erratum fix before we try to migrate the irq to a new place.

Do you agree?

---
From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: x86, io-apic: move the effort of clearing remoteIRR explicitly
before migrating the irq

When the level-triggered interrupt is seen as an edge interrupt, we try
to clear the remoteIRR explicitly (using either an io-apic eoi register
when present or through the idea of changing trigger mode of the io-apic
RTE to edge and then back to level). But this explicit try also needs to
happen before we try to migrate the irq. Otherwise irq migration attempt
will fail anyhow, as it postpones the irq migration to a later attempt
when it sees the remoteIRR in the io-apic RTE still set.

Signed-off-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 47d95c3..9a26ea1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2583,6 +2583,20 @@ static void ack_apic_level(unsigned int irq)
 	 */
 	ack_APIC_irq();
 
+	/* Tail end of version 0x11 I/O APIC bug workaround */
+	if (!(v & (1 << (i & 0x1f)))) {
+		atomic_inc(&irq_mis_count);
+
+		if (use_eoi_reg)
+			eoi_ioapic_irq(desc);
+		else {
+			spin_lock(&ioapic_lock);
+			__mask_and_edge_IO_APIC_irq(cfg);
+			__unmask_and_level_IO_APIC_irq(cfg);
+			spin_unlock(&ioapic_lock);
+		}
+	}
+
 	/* Now we can move and renable the irq */
 	if (unlikely(do_unmask_irq)) {
 		/* Only migrate the irq if the ack has been received.
@@ -2616,20 +2630,6 @@ static void ack_apic_level(unsigned int irq)
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


