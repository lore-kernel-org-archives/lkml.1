Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYDENvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYDENvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYDENue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:34 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:37199 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYDENuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=Rlv0zBqWlIuWEH3S02wMpY2FQbLTJlbCui0obdGc4Ud39ZUXU6H9kevurtWSTPoHtGpQ5Rs5s5iQyVu085odlmdKG7JrnWSXGbNTy1Izz0TXjMAOlHx5aZkZY58iKmStGI0PUStcCRnoq9nPKTHfu48Ix6Tz/t5423p/WTw9dso=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:08 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 5/9] x86: use cpumask_of_cpu()
Content-Disposition: inline; filename=x86-use-cpumask_of_cpu.patch
Message-ID: <47f783a6.19ac7e0a.525e.5161@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpumask_of_cpu() rather than the pair of cpus_clear() and cpu_set().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    4 ++--
 arch/x86/kernel/genapic_flat_64.c       |    5 +----
 arch/x86/kernel/io_apic_64.c            |    4 +---
 3 files changed, 4 insertions(+), 9 deletions(-)

Index: 2.6-git/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/genapic_flat_64.c
+++ 2.6-git/arch/x86/kernel/genapic_flat_64.c
@@ -138,12 +138,9 @@ static cpumask_t physflat_target_cpus(vo
 
 static cpumask_t physflat_vector_allocation_domain(int cpu)
 {
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
+	return cpumask_of_cpu(cpu);
 }
 
-
 static void physflat_send_IPI_mask(cpumask_t cpumask, int vector)
 {
 	send_IPI_mask_sequence(cpumask, vector);
Index: 2.6-git/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ 2.6-git/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -254,8 +254,8 @@ struct threshold_attr {
 static cpumask_t affinity_set(unsigned int cpu)
 {
 	cpumask_t oldmask = current->cpus_allowed;
-	cpumask_t newmask = CPU_MASK_NONE;
-	cpu_set(cpu, newmask);
+	cpumask_t newmask = cpumask_of_cpu(cpu);
+
 	set_cpus_allowed(current, newmask);
 	return oldmask;
 }
Index: 2.6-git/arch/x86/kernel/io_apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_64.c
+++ 2.6-git/arch/x86/kernel/io_apic_64.c
@@ -1351,9 +1351,7 @@ static int ioapic_retrigger_irq(unsigned
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	cpus_clear(mask);
-	cpu_set(first_cpu(cfg->domain), mask);
-
+	mask = cpumask_of_cpu(first_cpu(cfg->domain));
 	send_IPI_mask(mask, cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 

-- 
