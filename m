Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYIGJNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYIGJNy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYIGJNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:13:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:21236 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYIGJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:13:43 -0400
Message-ID: <48C39B42.4080504@colorfullife.com>
Date: Sun, 07 Sep 2008 11:13:38 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tony.luck@intel.com
Subject: ia64 start secondary cpus: what's the first line where interrupts
 can arrive?
Content-Type: multipart/mixed;
 boundary="------------010303020601040308050703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010303020601040308050703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

For my rcu implementation, I try to figure out how the boot process for 
secondary cpus works.

arch/ia64/kernel/smpboot.c contains the following code:
> static void __cpuinit
> smp_callin (void)
> {
> [snip]
>         per_cpu(cpu_state, cpuid) = CPU_ONLINE;
>         spin_unlock(&vector_lock);
>         ipi_call_unlock_irq();
> <<<<<
> <<<<< ipi_call_unlock_irq() does local_irq_enable()
> <<<<<
>         smp_setup_percpu_timer();
>
>         ia64_mca_cmc_vector_setup();    /* Setup vector on AP */
>
> #ifdef CONFIG_PERFMON
>         pfm_init_percpu();
> #endif
>
>         local_irq_enable();
> <<<<<
> <<<<< Another local_irq_enable().
> <<<<<
Which of these two local_irq_enable()'s is the right one?

And: IMHO it's unclean to abuse ipi_call_unlock_irq() to enable the 
local interrupts.
What about the attached patch? Untested due to lack of test hardware.

--
    Manfred

--------------010303020601040308050703
Content-Type: text/plain;
 name="patch-ia64-smpboot"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-ia64-smpboot"

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 03f1a99..f4868d2 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -396,14 +396,17 @@ smp_callin (void)
 
 	fix_b0_for_bsp();
 
-	ipi_call_lock_irq();
+	ipi_call_lock();
 	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	cpu_set(cpuid, cpu_online_map);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
-	ipi_call_unlock_irq();
+	ipi_call_unlock();
+	
+	/* begin processing interrupts */
+	local_irq_enable();
 
 	smp_setup_percpu_timer();
 
@@ -413,8 +416,6 @@ smp_callin (void)
 	pfm_init_percpu();
 #endif
 
-	local_irq_enable();
-
 	if (!(sal_platform_features & IA64_SAL_PLATFORM_FEATURE_ITC_DRIFT)) {
 		/*
 		 * Synchronize the ITC with the BP.  Need to do this after irqs are

--------------010303020601040308050703--
