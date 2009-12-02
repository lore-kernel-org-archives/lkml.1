Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZLBQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZLBQX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZLBQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:23:29 -0500
Received: from flmx07.ccur.com ([12.192.68.12]:37386 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZLBQX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:23:28 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 11:23:28 EST
Message-ID: <4B169397.5020609@ccur.com>
Date: Wed, 2 Dec 2009 10:19:35 -0600
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Setting /proc/irq/[n]/smp_affinity failure on 8 cpu
 systems
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to mention an irq set affinity issue occurs on an
older Dell PowerEdge 6650 system:
    - 8 cpus (4 are hyper-threaded),
    - uses the struct apic 'apic_default' support
    - 32 bit (x86) kernel

This issue is that once you change the irq smp_affinity of an irq
to be less than all cpus in the system, you can never change really the
irq smp_affinity back to be all cpus in the system (0xff) again,
even though no error status is returned on the "/bin/echo ff >
/proc/irq/[n]/smp_affinity" operation.

This is due to that fact that BAD_APICID has the same value as
all cpus (0xff) on 32bit kernels, and thus the value returned from
set_desc_affinity() via the cpu_mask_to_apicid_and() function is treated
as a failure in set_ioapic_affinity_irq_desc(), and no affinity changes
are made.

It seems like changing the BAD_APICID value from 0xFF to 0xFFFF for
CONFIG_X86_32 might be one possible solution, and it seems to function
properly for this Dell PowerEdge 6650 system.

Thank you for your time.

Signed-off-by: John Blackwood <john.blackwood@ccur.com>


diff -rup linux-2.6.32-rc8/arch/x86/include/asm/apicdef.h new/arch/x86/include/asm/apicdef.h
--- linux-2.6.32-rc8/arch/x86/include/asm/apicdef.h     2009-11-19 16:32:38.000000000 -0600
+++ new/arch/x86/include/asm/apicdef.h  2009-12-01 15:15:34.000000000 -0600
@@ -413,9 +413,6 @@ struct local_apic {

    #undef u32

-#ifdef CONFIG_X86_32
- #define BAD_APICID 0xFFu
-#else
- #define BAD_APICID 0xFFFFu
-#endif
+#define BAD_APICID 0xFFFFu
+
    #endif /* _ASM_X86_APICDEF_H */
diff -rup linux-2.6.32-rc8/arch/x86/include/asm/apic.h new/arch/x86/include/asm/apic.h
--- linux-2.6.32-rc8/arch/x86/include/asm/apic.h        2009-11-19 16:32:38.000000000 -0600
+++ new/arch/x86/include/asm/apic.h     2009-12-01 15:15:34.000000000 -0600
@@ -591,7 +591,7 @@ static inline physid_mask_t default_apic
    #endif /* CONFIG_X86_LOCAL_APIC */

    #ifdef CONFIG_X86_32
-extern u8 cpu_2_logical_apicid[NR_CPUS];
+extern u16 cpu_2_logical_apicid[NR_CPUS];
    #endif

    #endif /* _ASM_X86_APIC_H */
diff -rup linux-2.6.32-rc8/arch/x86/kernel/smpboot.c new/arch/x86/kernel/smpboot.c
--- linux-2.6.32-rc8/arch/x86/kernel/smpboot.c  2009-11-19 16:32:38.000000000 -0600
+++ new/arch/x86/kernel/smpboot.c       2009-12-01 15:15:34.000000000 -0600
@@ -146,7 +146,7 @@ static void unmap_cpu_to_node(int cpu)
    #ifdef CONFIG_X86_32
    static int boot_cpu_logical_apicid;

-u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
+u16 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
                                          { [0 ... NR_CPUS-1] = BAD_APICID };

    static void map_cpu_to_logical_apicid(void)



