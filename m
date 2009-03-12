Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbZCLMQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbZCLMQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZCLMPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:15:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36650 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbZCLMPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:15:54 -0400
Message-Id: <49B90B31.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:16:33 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Andi Kleen" <andi@firstfloor.org>
Subject: [PATCH] eliminate spurious pointless WARN_ON()s
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namely during early boot, the panic() or BUG() paths may end up in
smp_call_function_*() with just a single online CPU. In that situation
the warnings generated are not only meaningless, but also result in
relevant output being cluttered.

Therefore, defer the WARN_ON() checks until after the (unaffected from
the problem that is being attempted to be detected here) cases have
been handled.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>

---
 kernel/smp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.29-rc7/kernel/smp.c	2009-03-04 09:11:00.000000000 +0100
+++ 2.6.29-rc7-smp-call-defer-warn/kernel/smp.c	2009-02-13 12:17:02.000000000 +0100
@@ -222,9 +222,6 @@ int smp_call_function_single(int cpu, vo
 	int me = get_cpu();
 	int err = 0;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	if (cpu == me) {
 		local_irq_save(flags);
 		func(info);
@@ -232,6 +229,9 @@ int smp_call_function_single(int cpu, vo
 	} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
 		struct call_single_data *data;
 
+		/* Can deadlock when called with interrupts disabled */
+		WARN_ON(irqs_disabled());
+
 		if (!wait) {
 			/*
 			 * We are calling a function on a single CPU
@@ -325,9 +325,6 @@ void smp_call_function_many(const struct
 	unsigned long flags;
 	int cpu, next_cpu;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	/* So, what's a CPU they want?  Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == smp_processor_id())
@@ -347,6 +344,9 @@ void smp_call_function_many(const struct
 		return;
 	}
 
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
 	data = kmalloc(sizeof(*data) + cpumask_size(), GFP_ATOMIC);
 	if (unlikely(!data)) {
 		/* Slow path. */



