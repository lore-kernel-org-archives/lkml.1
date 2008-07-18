Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYGRAsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYGRAsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbYGRAsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:48:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61881 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757769AbYGRAsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:48:45 -0400
Date: Fri, 18 Jul 2008 01:47:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       Huang Ying <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap
 trouble
In-Reply-To: <19f34abd0807171358p3c5a44f9i91ab23d3f5e9671f@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0807180117320.6536@cliff.in.clinika.pl>
References: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com> 
 <200807171245.31641.bjorn.helgaas@hp.com> <19f34abd0807171358p3c5a44f9i91ab23d3f5e9671f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Vegard Nossum wrote:

> Hah, I actually managed to get netconsole working. This is the log
> that fails (v2.6.26):
> 
> http://folk.uio.no/vegardno/linux/numa-netconsole.txt
> 
> I think this looks really interesting:
> 
> [    0.093562] ExtINT not setup in hardware but reported by MP table
> [    0.093854] ENABLING IO-APIC IRQs
> [    0.094244] ..TIMER: vector=0x31 apic1=-1 pin1=2 apic2=-1 pin2=0
> [    0.094985] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.094985] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.094985] ..... (found pin 0) ...<7>APIC error on CPU0: 00(80)
> [    0.094985]  failed.
> [    0.094985] ...trying to set up timer as Virtual Wire IRQ...<7>APIC
> error on CPU0: 80(80)
> [    0.105761]  works.
> 
> This error would be:
>            7: Illegal register address
> 
> Looks like APIC was misconfigured, which might explain IRQ routing weirdness?

 Here pin1 and pin2 have been correctly initialised, but apic1 and apic2
are both set to -1.  This is an "impossible scenario."  Because of that
I/O APIC code actually pokes at random registers of the local APIC which
immediately precedes I/O APIC #0 in the fixmap.  Results may be arbitrary.

> Will try to provide the booting one later. Now zZz...

 Your system uses an MP table and there were quite a lot of changes in its
support code recently.  A bug must have crept in.  Please try the appended
patch and the "apic=debug" option for both cases and the resulting logs
may shed some light.

  Maciej

patch-next-2.6.26-rc9-20080711-apic-dprintk-0
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h	2008-07-16 14:50:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h	2008-07-18 00:33:19.000000000 +0000
@@ -10,7 +10,7 @@
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
-#define Dprintk(x...)
+#define Dprintk printk
 
 /*
  * Debugging macros
