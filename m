Return-Path: <linux-kernel-owner+w=401wt.eu-S1764127AbXK3CQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764127AbXK3CQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763892AbXK3CQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:16:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760917AbXK3CQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:16:00 -0500
Message-ID: <474F7290.8010504@redhat.com>
Date: Thu, 29 Nov 2007 18:16:48 -0800
From: Ben Woodard <woodard@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot
 cpu
References: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>	<200711271445.56792.ak@suse.de>	<m1lk8jka8j.fsf@ebiederm.dsl.xmission.com>	<474C64CB.7080004@redhat.com>	<20071127194220.GG14887@hmsendeavour.rdu.redhat.com>	<20071127200011.GA3703@redhat.com>	<20071127222408.GH24223@one.firstfloor.org>	<474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com>	<20071128160206.GA21286@hmsendeavour.rdu.redhat.com>	<20071128190525.GD3192@redhat.com> <m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> Ok. Got it. So in this case we route the interrupts directly through LAPIC
>> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
>>
>> I am looking at Intel Multiprocessor specification v1.4 and as per figure
>> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is 
>> connected to LINTIN0 pin on all processors. If that is the case, even in
>> this mode, all the CPU should see the timer interrupts (which is coming
>> from 8259)?
> 
> However things are implemented completely differently now.  I don't think
> the coherent hypertransport domain of AMD processors actually routes
> ExtINT interrupts to all cpus but instead one (the default route?) is
> picked.
> 
> So I think for the kdump case we pretty much need to use an IOAPIC
> in virtual wire mode for recent AMD systems.
> 
> For current Intel systems I believe either scenario still works.
> 
>> Can you print the LAPIC registers (print_local_APIC) during normal boot
>> and during kdump boot and paste here?
> 
> It's worth a look.
> 
> I still think we need to just use apic mode at kernel startup, and
> be done with it.
> 

Neil whipped up a patch to try this and evidently it worked on his test 
boxes but it didn't work very well on our problem tests box. It hung 
after the kernel printed "Ready". i.e. on a normal boot I get:

<snip>
2007-11-29 13:48:29 Loading
vmlinuz-2.6.18-13chaos.ben.test................................
2007-11-29 13:48:29 Loading
initrd-2.6.18-13chaos.ben.test.........................................................
..............................................................................
2007-11-29 13:48:29 Ready.
2007-11-29 13:48:30 Linux version 2.6.18-13chaos.ben.test (ben@wopri) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14
)) #10 SMP Thu Nov 29 13:11:49 PST 2007
2007-11-29 13:48:30 Command line: initrd=initrd-2.6.18-13chaos.ben.test
loglevel=8 console=ttyS0,115200n8 crashkernel=128M@16M elevator=deadline 
swiotlb=65536 selinux=0 apic=debug 
BOOT_IMAGE=vmlinuz-2.6.18-13chaos.ben.test BOOTIF=
01-00-30-48-57-91-56

With Neil's patch:
2007-11-29 17:12:55 PXELINUX 2.11 2004-08-16  Copyright (C) 1994-2004 H. 
Peter Anvin
2007-11-29 17:12:55 Boot options [default: 2.6.18-54.el5.bz336371]:
2007-11-29 17:12:55 linux-2.6.18-13chaos.ben.test-2.6.18-54.el5.bz336371
2007-11-29 17:12:55 linux
2007-11-29 17:12:55 linux-2.6.18-54.el5.bz336371
2007-11-29 17:12:55 linux-2.6.18-52.el5
2007-11-29 17:12:55 linux-2.6.18-13chaos.ben.test-2.6.18-13chaos.ben.test
2007-11-29 17:12:55 linux-2.6.23-0.214.rc8.git2.fc8
2007-11-29 17:12:55 linux-2.6.18-8.1.14.el5
2007-11-29 17:12:55 linux-2.6.18-7chaos
2007-11-29 17:12:55 boot:
2007-11-29 17:13:02 Loading
vmlinuz-2.6.18-13chaos.ben.test................................
2007-11-29 17:13:02 Loading
initrd-2.6.18-13chaos.ben.test.........................................................
..............................................................................
2007-11-29 17:13:02 Ready.
(END)
That's all she wrote. End of story. Had to reboot to another kernel to 
make get it back.

Neil's patch:

--- linux-2.6.18.noarch/arch/x86_64/kernel/i8259.c.orig 2007-11-28 
18:00:31.000000000 -0500
+++ linux-2.6.18.noarch/arch/x86_64/kernel/i8259.c      2007-11-29 
10:37:14.000000000 -0500
@@ -599,4 +599,30 @@

         if (!acpi_ioapic)
                 setup_irq(2, &irq2);
+
+       /*
+         * Switch from PIC to APIC mode.
+         */
+        connect_bsp_APIC();
+        setup_local_APIC();
+
+        if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
+                panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
+                      GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_id);
+                /* Or can we switch back to PIC here? */
+        }
+
+        /*
+         * Now start the IO-APICs
+         */
+        if (!skip_ioapic_setup && nr_ioapics)
+                setup_IO_APIC();
+        else
+                nr_ioapics = 0;
+
+       /*
+        * Disable local irqs here so start_kernel doesn't complain
+        */
+       local_irq_disable();
+
  }
--- linux-2.6.18.noarch/arch/x86_64/kernel/smpboot.c.orig 
2007-11-28 18:07:33.000000000 -0500
+++ linux-2.6.18.noarch/arch/x86_64/kernel/smpboot.c    2007-11-29 
10:37:59.000000000 -0500
@@ -1088,26 +1088,6 @@


         /*
-        * Switch from PIC to APIC mode.
-        */
-       connect_bsp_APIC();
-       setup_local_APIC();
-
-       if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
-               panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-                     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_id);
-               /* Or can we switch back to PIC here? */
-       }
-
-       /*
-        * Now start the IO-APICs
-        */
-       if (!skip_ioapic_setup && nr_ioapics)
-               setup_IO_APIC();
-       else
-               nr_ioapics = 0;
-
-       /*
          * Set up local APIC timer on boot CPU.
          */


> Eric
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec


-- 
-ben
-=-
