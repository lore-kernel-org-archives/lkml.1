Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYIFKPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYIFKPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 06:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYIFKPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 06:15:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYIFKPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 06:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JhvTi7+FIts090/3pMWxRUOoL++DZOPHDcoZWFCi7jURnr8d9eNz8dYh8B6DlZ+Fh5
         IGs8UKe9Ckv61yDUD3mVlMevGMQPADOawhsGvbVX8dWY9pCzZUx4BNgyx+uHNyoJVnwS
         y2ULEg/8OiVtDSvnP+XWbL2p7je+UN22em6Ek=
Date: Sat, 6 Sep 2008 14:15:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906101533.GA7273@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905183835.GA19215@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Sep 05, 2008 at 08:38:35PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > So as you see it's more then enough self-solid :) So I wouldn't break 
| > it 'cause of printing. If we have enough memory for bit field - we 
| > could just mark there if pin is connected to irq and print connection 
| > map after. Don't get me wrong please - I just don't want to overload 
| > this function with additional call.
| 
| the compiler will inline that single-called function just fine, as long 
| as you declare it static.
| 
| spreading printouts over several functions isnt all that bad i think. We 
| could even drop the 'not connected' complication - it's evident enough 
| from the fact that nothing gets printed.
| 
| 	Ingo
| 

Ingo, how about the following approach? We don't introduce new
functions but rather srink the code by new printout form.

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: io-apic - setup_IO_APIC_irqs code simplification

By changing printout form we are able to shrink code a bit.

Former printout example:

	init IO_APIC IRQs
	 IO-APIC (apicid-pin) 1-1, 1-2, 1-3 not connected.
	 IO-APIC (apicid-pin) 2-1, 2-2, 2-3 not connected.

New printout example:

	init IO_APIC IRQs
	 1-1 1-2 1-3 (apicid-pin) not connected
	 2-1 2-2 2-3 (apicid-pin) not connected

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-06 13:46:23.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-06 14:08:13.000000000 +0400
@@ -1516,41 +1516,44 @@ static void setup_IO_APIC_irq(int apic, 
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic, pin, idx, irq, first_notcon = 1;
+	int apic, pin, idx, irq;
+	int notcon = 0;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 
-		idx = find_irq_entry(apic,pin,mp_INT);
-		if (idx == -1) {
-			if (first_notcon) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG " IO-APIC (apicid-pin) %d-%d", mp_ioapics[apic].mp_apicid, pin);
-				first_notcon = 0;
-			} else
-				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mp_apicid, pin);
-			continue;
-		}
-		if (!first_notcon) {
-			apic_printk(APIC_VERBOSE, " not connected.\n");
-			first_notcon = 1;
-		}
+			idx = find_irq_entry(apic, pin, mp_INT);
+			if (idx == -1) {
+				apic_printk(APIC_VERBOSE,
+					KERN_DEBUG " %d-%d",
+					mp_ioapics[apic].mp_apicid, pin);
+				if (!notcon)
+					notcon = 1;
+				continue;
+			}
 
-		irq = pin_2_irq(idx, apic, pin);
+			irq = pin_2_irq(idx, apic, pin);
 #ifdef CONFIG_X86_32
-                if (multi_timer_check(apic, irq))
-                        continue;
+			if (multi_timer_check(apic, irq))
+				continue;
 #endif
-		add_pin_to_irq(irq, apic, pin);
+			add_pin_to_irq(irq, apic, pin);
 
-		setup_IO_APIC_irq(apic, pin, irq,
-				  irq_trigger(idx), irq_polarity(idx));
-	}
+			setup_IO_APIC_irq(apic, pin, irq,
+					irq_trigger(idx), irq_polarity(idx));
+		}
+		if (notcon) {
+			apic_printk(APIC_VERBOSE,
+				KERN_DEBUG " (apicid-pin) not connected\n");
+			notcon = 0;
+		}
 	}
 
-	if (!first_notcon)
-		apic_printk(APIC_VERBOSE, " not connected.\n");
+	if (notcon)
+		apic_printk(APIC_VERBOSE,
+			KERN_DEBUG " (apicid-pin) not connected\n");
 }
 
 /*
