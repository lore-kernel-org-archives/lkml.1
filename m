Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZCLNVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZCLNVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZCLNVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:21:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39340 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZCLNVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:21:12 -0400
Message-Id: <49B91A7E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 13:21:50 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] eliminate spurious pointless WARN_ON()s
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

--- tip/kernel/smp.c
+++ tip-smp-call-defer-warn/kernel/smp.c
@@ -282,9 +282,6 @@ int smp_call_function_single(int cpu, vo
 	 */
 	this_cpu = get_cpu();
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
 		func(info);
@@ -292,6 +289,9 @@ int smp_call_function_single(int cpu, vo
 		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
 			struct call_single_data *data = &d;
 
+			/* Can deadlock when called with interrupts disabled */
+			WARN_ON(irqs_disabled());
+
 			if (!wait)
 				data = &__get_cpu_var(csd_data);
 
@@ -365,9 +365,6 @@ void smp_call_function_many(const struct
 	unsigned long flags;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	if (cpu == this_cpu)
@@ -387,6 +384,9 @@ void smp_call_function_many(const struct
 		return;
 	}
 
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
 



