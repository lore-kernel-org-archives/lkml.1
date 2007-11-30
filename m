Return-Path: <linux-kernel-owner+w=401wt.eu-S934752AbXK3CL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbXK3CL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760917AbXK3CLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:11:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbXK3CLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:11:14 -0500
Message-ID: <474F7177.7050306@redhat.com>
Date: Thu, 29 Nov 2007 18:12:07 -0800
From: Ben Woodard <woodard@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on	boot
 cpu
References: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com> <200711271445.56792.ak@suse.de> <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com>
In-Reply-To: <20071128190525.GD3192@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, Nov 28, 2007 at 11:02:06AM -0500, Neil Horman wrote:
>> On Wed, Nov 28, 2007 at 10:36:49AM -0500, Vivek Goyal wrote:
>>> On Tue, Nov 27, 2007 at 03:24:35PM -0800, Ben Woodard wrote:
>>>> Andi Kleen wrote:
>>>>>> Are we putting the system back in PIC mode or virtual wire mode? I have
>>>>>> not seen systems which support PIC mode. All latest systems seems
>>>>>> to be having virtual wire mode. I think in case of PIC mode, interrupts
>>>>> Yes it's probably virtual wire. For real PIC mode we would need really
>>>>> old systems without APIC.
>>>>>
>>>>>> can be delivered to cpu0 only. In virt wire mode, one can program IOAPIC
>>>>>> to deliver interrupt to any of the cpus and that's what we have been
>>>>> The code doesn't try to program anything specific, it just restores the state
>>>>> that was left over originally by the BIOS.
>>>>>
>>>> So if the BIOS originally left the IOAPIC in a state where the timer 
>>>> interrupts were only going to CPU0 then by restoring that state we could be 
>>>> bringing this problem upon ourselves when we restore that state.
>>>>
>>> Hi Ben,
>>>
>>> Apart from restoring the original state (Bring APICS back to virtual wire
>>> mode), we also reprogram IOAPIC so that timer interrupt can go to crashing
>>> cpu (and not necessarily cpu0). Look at following code in disable_IO_APIC.
>>>
>>>                 entry.dest.physical.physical_dest =
>>>                                         GET_APIC_ID(apic_read(APIC_ID));
>>>
>>> Here we read the apic id of crashing cpu and program IOAPIC accordingly.
>>> This will make sure that even in virtual wire mode, timer interrupts
>>> will be delivered to crashing cpu APIC.
>>>
>> Yes, but according to Bens last debug effort, the APIC printout regarding the
>> timer setup, indicates that ioapic_i8259.pin == -1, meaning that the 8259 is not
>> routed through the ioapic.  In those cases, disable_IO_APIC does not take us
>> through the path you reference above, and does not revert to virtual wire mode.
>> Instead, it simply disables legacy vector 0, which if I understand this
>> correctly, simply tells the ioapic to not handle timer interrupts, trusting that
>> the 8259 in the system will deliver that interrupt where it needs to be.  If the
>> 8259 is wired to deliver timer interrupts to cpu0 only, then you get the problem
>> that we have, do you?
>>
> 
> Ok. Got it. So in this case we route the interrupts directly through LAPIC
> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
> 
> I am looking at Intel Multiprocessor specification v1.4 and as per figure
> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is 
> connected to LINTIN0 pin on all processors. If that is the case, even in
> this mode, all the CPU should see the timer interrupts (which is coming
> from 8259)?
> 
> Can you print the LAPIC registers (print_local_APIC) during normal boot
> and during kdump boot and paste here?

Here are the ones from a normal bootup.

I was unable to get info from a kdump boot. I haven't figured out why 
yet. With the same patch that I used to capture this, when I tried to 
kdump the kernel, it paused a second or two after the backtrace and then 
dropped to BIOS and came up normally.

Here is a little trick, at the point where we are trying to get the info 
to print out, the kernel command line hasn't been completely parsed yet. 
That tricked me for part of the day. I had apic=debug on the command 
line but the logic in print_local_APIC saw the default value because the 
kernel command line had yet to be parsed.

2007-11-29 17:58:07 ***Here is the info you requested
2007-11-29 17:58:07
2007-11-29 17:58:07 printing local APIC contents on CPU#0/0:
2007-11-29 17:58:07 ... APIC ID:      00000000 (0)
2007-11-29 17:58:07 ... APIC VERSION: 80050010
2007-11-29 17:58:07 ... APIC TASKPRI: 00000000 (00)
2007-11-29 17:58:07 ... APIC ARBPRI: 00000000 (00)
2007-11-29 17:58:07 ... APIC PROCPRI: 00000000
2007-11-29 17:58:07 ... APIC EOI: 00000000
2007-11-29 17:58:07 ... APIC RRR: 00000002
2007-11-29 17:58:07 ... APIC LDR: 00000000
2007-11-29 17:58:07 ... APIC DFR: ffffffff
2007-11-29 17:58:07 ... APIC SPIV: 0000010f
2007-11-29 17:58:07 ... APIC ISR field:
2007-11-29 17:58:07 ... APIC TMR field:
2007-11-29 17:58:07 ... APIC IRR field:
2007-11-29 17:58:07 ... APIC ESR: 00000000
2007-11-29 17:58:07 ... APIC ICR: 00004630
2007-11-29 17:58:07 ... APIC ICR2: 07000000
2007-11-29 17:58:07 ... APIC LVTT: 00010000
2007-11-29 17:58:07 ... APIC LVTPC: 00010000
2007-11-29 17:58:07 ... APIC LVT0: 00000700
2007-11-29 17:58:07 ... APIC LVT1: 00000400
2007-11-29 17:58:07 ... APIC LVTERR: 0001000f
2007-11-29 17:58:07 ... APIC TMICT: 80000000
2007-11-29 17:58:07 ... APIC TMCCT: 00000000
2007-11-29 17:58:07 ... APIC TDCR: 00000000
2007-11-29 17:58:07
2007-11-29 17:58:07 number of MP IRQ sources: 15.
2007-11-29 17:58:07 number of IO-APIC #8 registers: 0.
2007-11-29 17:58:07 number of IO-APIC #9 registers: 0.
2007-11-29 17:58:07 number of IO-APIC #10 registers: 0.
2007-11-29 17:58:07 testing the IO APIC.......................
2007-11-29 17:58:07
2007-11-29 17:58:07 IO APIC #8......
2007-11-29 17:58:07 .... register #00: 08000000
2007-11-29 17:58:07 .......    : physical APIC id: 08
2007-11-29 17:58:07 .... register #01: 00170011
2007-11-29 17:58:07 .......     : max redirection entries: 0017
2007-11-29 17:58:07 .......     : PRQ implemented: 0
2007-11-29 17:58:07 .......     : IO APIC version: 0011
2007-11-29 17:58:07 .... register #02: 08000000
2007-11-29 17:58:07 .......     : arbitration: 08
2007-11-29 17:58:07 .... IRQ redirection table:
2007-11-29 17:58:07  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
2007-11-29 17:58:07  00 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  01 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  02 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  03 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  04 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  05 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  06 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  07 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  08 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  09 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0a 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0b 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0c 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0d 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0e 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  0f 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  10 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  11 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  12 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  13 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  14 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  15 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  16 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  17 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07
2007-11-29 17:58:07 IO APIC #9......
2007-11-29 17:58:07 .... register #00: 09000000
2007-11-29 17:58:07 .......    : physical APIC id: 09
2007-11-29 17:58:07 .... register #01: 00060011
2007-11-29 17:58:07 .......     : max redirection entries: 0006
2007-11-29 17:58:07 .......     : PRQ implemented: 0
2007-11-29 17:58:07 .......     : IO APIC version: 0011
2007-11-29 17:58:07 .... register #02: 00000000
2007-11-29 17:58:07 .......     : arbitration: 00
2007-11-29 17:58:07 .... IRQ redirection table:
2007-11-29 17:58:07  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
2007-11-29 17:58:07  00 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:07  01 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  02 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  03 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  04 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  05 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  06 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08
2007-11-29 17:58:08 IO APIC #10......
2007-11-29 17:58:08 .... register #00: 0A000000
2007-11-29 17:58:08 .......    : physical APIC id: 0A
2007-11-29 17:58:08 .... register #01: 00060011
2007-11-29 17:58:08 .......     : max redirection entries: 0006
2007-11-29 17:58:08 .......     : PRQ implemented: 0
2007-11-29 17:58:08 .......     : IO APIC version: 0011
2007-11-29 17:58:08 .... register #02: 00000000
2007-11-29 17:58:08 .......     : arbitration: 00
2007-11-29 17:58:08 .... IRQ redirection table:
2007-11-29 17:58:08  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:
2007-11-29 17:58:08  00 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  01 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  02 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  03 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  04 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  05 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08  06 000 00  1    0    0   0   0    0    0    00
2007-11-29 17:58:08 Using vector-based indexing
2007-11-29 17:58:08 IRQ to pin mappings:
2007-11-29 17:58:08 IRQ0 -> 0:0
2007-11-29 17:58:08 IRQ1 -> 0:0
2007-11-29 17:58:08 IRQ2 -> 0:0
2007-11-29 17:58:08 IRQ3 -> 0:0
2007-11-29 17:58:08 IRQ4 -> 0:0
2007-11-29 17:58:08 IRQ5 -> 0:0
2007-11-29 17:58:08 IRQ6 -> 0:0
2007-11-29 17:58:08 IRQ7 -> 0:0
2007-11-29 17:58:08 IRQ8 -> 0:0
2007-11-29 17:58:08 IRQ9 -> 0:0
2007-11-29 17:58:08 IRQ10 -> 0:0
2007-11-29 17:58:08 IRQ11 -> 0:0
2007-11-29 17:58:08 IRQ12 -> 0:0
2007-11-29 17:58:08 IRQ13 -> 0:0
2007-11-29 17:58:08 IRQ14 -> 0:0
2007-11-29 17:58:08 IRQ15 -> 0:0
2007-11-29 17:58:08 IRQ0 -> 0:0
<snip a whole bunch of identical lines>
2007-11-29 17:58:08 .................................... done.
2007-11-29 17:58:08 Built 4 zonelists.  Total pages: 3937654


The patch that I was using to get this is as follows:
--- linux/init/main.c   (revision 763)
+++ linux/init/main.c   (working copy)
@@ -484,6 +484,8 @@
  {
  }

+extern void print_local_APIC(void);
+
  asmlinkage void __init start_kernel(void)
  {
         char * command_line;
@@ -515,6 +517,11 @@
         setup_per_cpu_areas();
         smp_prepare_boot_cpu(); /* arch-specific boot-cpu hooks */

+       console_loglevel=10;
+       printk(KERN_DEBUG "***Here is the info you requested\n");
+       print_local_APIC();
+       print_IO_APIC();
+
         /*
          * Set up the scheduler prior starting any interrupts (such as the
          * timer interrupt). Full topology setup happens at smp_init()
Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux/arch/x86_64/kernel/io_apic.c  (revision 763)
+++ linux/arch/x86_64/kernel/io_apic.c  (working copy)
@@ -1012,9 +1012,9 @@
         union IO_APIC_reg_02 reg_02;
         unsigned long flags;

-       if (apic_verbosity == APIC_QUIET)
+/*     if (apic_verbosity == APIC_QUIET)
                 return;
-
+*/
         printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", 
mp_irq_entries);
         for (i = 0; i < nr_ioapics; i++)
                 printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
@@ -1131,8 +1131,6 @@
         return;
  }

-#if 0
-
  static __apicdebuginit void print_APIC_bitfield (int base)
  {
         unsigned int v;
@@ -1158,9 +1156,9 @@
  {
         unsigned int v, ver, maxlvt;

-       if (apic_verbosity == APIC_QUIET)
+/*     if (apic_verbosity == APIC_QUIET)
                 return;
-
+*/
         printk("\n" KERN_DEBUG "printing local APIC contents on 
CPU#%d/%d:\n",
                 smp_processor_id(), hard_smp_processor_id());
         v = apic_read(APIC_ID);
@@ -1268,8 +1266,6 @@
         printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
  }

-#endif  /*  0  */
-
  static void __init enable_IO_APIC(void)
  {
         union IO_APIC_reg_01 reg_01;

>  
> Thanks
> Vivek


-- 
-ben
-=-
