Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbXEXAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbXEXAq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763696AbXEXAmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:42:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17325 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761856AbXEXAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:41:59 -0400
Message-ID: <4654DF53.2020000@mvista.com>
Date: Wed, 23 May 2007 17:41:55 -0700
From: Kevin Hilman <khilman@mvista.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable	preemption
References: <20070522230128.891568116@mvista.com> <1179891586.12708.135.camel@chaos>
In-Reply-To: <1179891586.12708.135.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 2007-05-22 at 16:01 -0700, Kevin Hilman wrote:
>> Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
>> adds a preempt_disable but no preempt_enable().
>>
>> Signed-off-by: Kevin Hilman <khilman@mvista.com>
> 
> Good catch. Applied.

Thomas could you apply this instead?

After discussions w/RMK and validation of my own on OMAP2 (ARMv6), it
seems that these disable/enable sections aren't necessary.

Signed-off-by: Kevin Hilman <khilman@mvista.com>

reverted:
--- linux-2.6.21/include/asm-arm/tlbflush.h
+++ linux-2.6.21.orig/include/asm-arm/tlbflush.h
@@ -246,7 +246,6 @@
 	const int zero = 0;
 	const unsigned int __tlb_flag = __cpu_tlb_flags;

-	preempt_disable();
 	if (tlb_flag(TLB_WB))
 		dsb();

@@ -258,7 +257,6 @@
 		asm("mcr p15, 0, %0, c8, c6, 0" : : "r" (zero) : "cc");
 	if (tlb_flag(TLB_V4_I_FULL | TLB_V6_I_FULL))
 		asm("mcr p15, 0, %0, c8, c5, 0" : : "r" (zero) : "cc");
-	preempt_enable();

 	if (tlb_flag(TLB_V6_I_FULL | TLB_V6_D_FULL |
 		     TLB_V6_I_PAGE | TLB_V6_D_PAGE |
@@ -276,7 +274,6 @@
 	const int asid = ASID(mm);
 	const unsigned int __tlb_flag = __cpu_tlb_flags;

-	preempt_disable();
 	if (tlb_flag(TLB_WB))
 		dsb();

@@ -297,7 +294,6 @@
 		asm("mcr p15, 0, %0, c8, c6, 2" : : "r" (asid) : "cc");
 	if (tlb_flag(TLB_V6_I_ASID))
 		asm("mcr p15, 0, %0, c8, c5, 2" : : "r" (asid) : "cc");
-	preempt_enable();

 	if (tlb_flag(TLB_V6_I_FULL | TLB_V6_D_FULL |
 		     TLB_V6_I_PAGE | TLB_V6_D_PAGE |
@@ -314,7 +310,6 @@
 	const int zero = 0;
 	const unsigned int __tlb_flag = __cpu_tlb_flags;

-	preempt_disable();
 	uaddr = (uaddr & PAGE_MASK) | ASID(vma->vm_mm);

 	if (tlb_flag(TLB_WB))
@@ -339,7 +334,6 @@
 		asm("mcr p15, 0, %0, c8, c6, 1" : : "r" (uaddr) : "cc");
 	if (tlb_flag(TLB_V6_I_PAGE))
 		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (uaddr) : "cc");
-	preempt_enable();

 	if (tlb_flag(TLB_V6_I_FULL | TLB_V6_D_FULL |
 		     TLB_V6_I_PAGE | TLB_V6_D_PAGE |
@@ -355,7 +349,6 @@
 	const int zero = 0;
 	const unsigned int __tlb_flag = __cpu_tlb_flags;

-	preempt_disable();
 	kaddr &= PAGE_MASK;

 	if (tlb_flag(TLB_WB))
@@ -406,13 +399,11 @@
 {
 	const unsigned int __tlb_flag = __cpu_tlb_flags;

-	preempt_disable();
 	if (tlb_flag(TLB_DCLEAN))
 		asm("mcr	p15, 0, %0, c7, c10, 1	@ flush_pmd"
 			: : "r" (pmd) : "cc");
 	if (tlb_flag(TLB_WB))
 		dsb();
-	preempt_enable();
 }

 static inline void clean_pmd_entry(pmd_t *pmd)
