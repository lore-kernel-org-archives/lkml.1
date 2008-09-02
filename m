Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbYIBNuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbYIBNuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIBNta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:49:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:49:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
In-Reply-To: <20080902349.573187695@firstfloor.org>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-Id: <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
Date: Tue,  2 Sep 2008 15:49:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


panic calls smp_send_stop which eventually calls smp_call_function_*.
smp_call_function warns about disabled interrupts. But it's legal
to call panic in this case. When this happens panic() prints
several ugly backtraces. So don't check for disabled interrupts
in panic state.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c
+++ linux/kernel/smp.c
@@ -216,7 +216,7 @@ int smp_call_function_single(int cpu, vo
 	int err = 0;
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON(system_state < SYSTEM_PANIC && irqs_disabled());
 
 	if (cpu == me) {
 		local_irq_save(flags);
@@ -260,7 +260,8 @@ EXPORT_SYMBOL(smp_call_function_single);
 void __smp_call_function_single(int cpu, struct call_single_data *data)
 {
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON((data->flags & CSD_FLAG_WAIT) && irqs_disabled());
+	WARN_ON(system_state < SYSTEM_PANIC &&
+		(data->flags & CSD_FLAG_WAIT) && irqs_disabled());
 
 	generic_exec_single(cpu, data);
 }
@@ -329,7 +330,7 @@ int smp_call_function_mask(cpumask_t mas
 	int slowpath = 0;
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON(system_state < SYSTEM_PANIC && irqs_disabled());
 
 	cpu = smp_processor_id();
 	allbutself = cpu_online_map;
