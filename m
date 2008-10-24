Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJXFAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJXFAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYJXFAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:00:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30085 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYJXFAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:00:03 -0400
Message-ID: <4901564F.7020308@ct.jp.nec.com>
Date: Thu, 23 Oct 2008 21:59:59 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip/cpus4096-v2] cpumask: fix memory leak and cpumask corruption
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

On CONFIG_CPUMASK_OFFSTACK enabled kernel, when exiting
smp_call_function_many() without calling arch_send_call_function_ipi()
allbutself should be freed.

Also, the memory for allbutself shouldn't be freed when
arch_send_call_function_ipi() is called.  The memory region will be
referenced in generic_smp_call_function_interrupt(). And the memory
will be freed at rcu_free_call_data().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/smp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index da98191..96b39e3 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -88,6 +88,7 @@ static void rcu_free_call_data(struct rcu_head *head)
 	struct call_function_data *data;
 
 	data = container_of(head, struct call_function_data, rcu_head);
+	free_cpumask_var(data->cpumask);
 
 	kfree(data);
 }
@@ -347,7 +348,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	 * into a targetted single call instead since it's faster.
 	 */
 	if (!num_cpus)
-		return;
+		goto out;
 	else if (num_cpus == 1) {
 		cpu = cpumask_first(allbutself);
 		smp_call_function_single(cpu, func, info, wait);
@@ -382,9 +383,12 @@ void smp_call_function_many(const struct cpumask *mask,
 	/* optionally wait for the CPUs to complete */
 	if (wait) {
 		csd_flag_wait(&data->csd);
-		if (unlikely(slowpath))
+		if (unlikely(slowpath)) {
 			smp_call_function_mask_quiesce_stack(allbutself);
+			free_cpumask_var(allbutself);
+		}
 	}
+	return;
 out:
 	free_cpumask_var(allbutself);
 }
-- 
1.5.6


