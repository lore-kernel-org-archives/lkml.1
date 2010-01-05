Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551Ab0AEFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0AEFdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562Ab0AEFdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:33:16 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:38262 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0AEFdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:33:15 -0500
From: David John <davidjon@xenontk.org>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] BUG: Fix smp_call_function_any to pass the node value to cpumask_of_node.
Date: Tue,  5 Jan 2010 11:03:03 +0530
Message-Id: <1262669583-3802-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change in acpi_cpufreq to use smp_call_function_any causes an
OOPS when it is called since the function erroneously passes the
cpu id to cpumask_of_node rather than the node that the cpu
is on. Fix this.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/kernel/smp.c b/kernel/smp.c
index de735a6..f104084 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -347,7 +347,7 @@ int smp_call_function_any(const struct cpumask *mask,
 		goto call;
 
 	/* Try for same node. */
-	nodemask = cpumask_of_node(cpu);
+	nodemask = cpumask_of_node(cpu_to_node(cpu));
 	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
 	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
 		if (cpu_online(cpu))
