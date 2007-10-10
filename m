Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXJJXWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXJJXWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbXJJXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:22:17 -0400
Received: from ryu.zarb.org ([212.85.153.228]:37162 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748AbXJJXWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:22:16 -0400
X-Greylist: delayed 1785 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 19:22:16 EDT
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: hskinnemoen@atmel.com
Subject: [PATCH] AVR32: Fix random segfault with preemption
Date: Wed, 10 Oct 2007 18:52:24 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710101852.27213.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As explained on:
http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&t=53307
If the current process is preempted before it can copy RAR_SUP and RSR_SUP
both register are lost and the process will segfault as soon as it return from 
the syscall since the return adress will be corrupted. 

This patch disable IRQ as soon as we enter the syscall path and reenable them 
when the copy is done. 

In the interrupt handlers, check if we are interrupting the srrf instruction, 
if so disable interrupts and return. The interrupt handler will be re-called 
immediatly when the interrupts are reenabled.

After some stressing workload:
- find / > /dev/null in loop
- top (in ssh)
- ping -f avr32

The segfaults are not seen anymore.

Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>

---

arch/avr32/kernel/entry-avr32b.S |   27 ++++++++++++++++++++++++++-
1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 42657f1..f7f2530 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -159,11 +159,18 @@ handle_vmalloc_miss:

        .section .scall.text,"ax",@progbits
 system_call:
+#ifdef CONFIG_PREEMPT
+       mask_interrupts
+#endif
        pushm   r12             /* r12_orig */
        stmts   --sp, r0-lr
-       zero_fp
+
        mfsr    r0, SYSREG_RAR_SUP
        mfsr    r1, SYSREG_RSR_SUP
+#ifdef CONFIG_PREEMPT
+       unmask_interrupts
+#endif
+       zero_fp
        stm     --sp, r0-r1

        /* check for syscall tracing */
@@ -638,6 +645,13 @@ irq_level\level:
        stmts   --sp,r0-lr
        mfsr    r8, rar_int\level
        mfsr    r9, rsr_int\level
+
+#ifdef CONFIG_PREEMPT
+       sub     r11, pc, (. - system_call)
+       cp.w    r11,r8
+       breq    4f
+#endif
+
        pushm   r8-r9

        mov     r11, sp
@@ -668,6 +682,17 @@ irq_level\level:
        sub     sp, -4          /* ignore r12_orig */
        rete

+#ifdef CONFIG_PREEMPT
+4:
+       mask_interrupts
+       mfsr    r8,rsr_int\level
+       sbr     r8, 16
+       mtsr    rsr_int\level, r8
+       ldmts   sp++,r0-lr
+       sub     sp, -4          /* ignore r12_orig */
+       rete
+#endif
+
 2:     get_thread_info r0
        ld.w    r1, r0[TI_flags]
        bld     r1, TIF_CPU_GOING_TO_SLEEP

