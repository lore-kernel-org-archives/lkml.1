Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbYDVPXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbYDVPXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933748AbYDVPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:22:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45036 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933744AbYDVPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:22:49 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 11:22:49 EDT
Subject: Re: [PATCH 6/11] arm: convert to generic helpers for IPI function
	calls
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <1208851058-8500-7-git-send-email-jens.axboe@oracle.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
	 <1208851058-8500-7-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 22 Apr 2008 16:00:47 +0100
Message-Id: <1208876447.31997.30.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 14:59:29.0015 (UTC) FILETIME=[76C4E870:01C8A489]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 09:57 +0200, Jens Axboe wrote:
> This converts arm to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested
> at all, not even compiled.

With the minor fixes below, it compiles and seems to run OK on RealView
EB + ARM11MPCore (4 CPUs):

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9c85329..6344466 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -484,7 +484,7 @@ asmlinkage void __exception do_IPI(struct pt_regs *regs)
 				generic_smp_call_function_interrupt();
 				break;
 
-			case IPI_CALL_FUNC:
+			case IPI_CALL_FUNC_SINGLE:
 				generic_smp_call_function_single_interrupt();
 				break;
 
@@ -536,14 +536,13 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 static int
-on_each_cpu_mask(void (*func)(void *), void *info, int retry, int wait,
-		 cpumask_t mask)
+on_each_cpu_mask(void (*func)(void *), void *info, int wait, cpumask_t mask)
 {
 	int ret = 0;
 
 	preempt_disable();
 
-	ret = smp_call_function_mask(mask, func, info, retry, wait);
+	ret = smp_call_function_mask(mask, func, info, wait);
 	if (cpu_isset(smp_processor_id(), mask))
 		func(info);
 
@@ -612,7 +611,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	cpumask_t mask = mm->cpu_vm_mask;
 
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
@@ -623,7 +622,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -645,7 +644,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mask);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)


-- 
Catalin

