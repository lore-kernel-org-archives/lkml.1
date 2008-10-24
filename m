Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYJXEun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYJXEun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYJXErX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:47:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27176 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbYJXErW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:47:22 -0400
Message-ID: <49015358.9050308@ct.jp.nec.com>
Date: Thu, 23 Oct 2008 21:47:20 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of call_function_data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The following assignment in smp_call_function_many() may cause unexpected
behavior, when !CPUMASK_OFFSTACK.
	data->cpumask = allbutself;

Because it copys pointer of stack and the value will be modified after
exit from smp_call_function_many().

The type of cpumask field of call_function_data structure should be
cpumask_var_t and an operation to assign is needed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/cpumask.h |    9 +++++++++
 kernel/smp.c            |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d1f22ee..7bfc0f1 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -511,6 +511,10 @@ typedef struct cpumask *cpumask_var_t;
 
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void free_cpumask_var(cpumask_var_t mask);
+static inline void assign_cpumask_var(cpumask_var_t *dst, cpumask_var_t src)
+{
+	*dst = src;
+}
 
 #else
 typedef struct cpumask cpumask_var_t[1];
@@ -524,6 +528,11 @@ static inline void free_cpumask_var(cpumask_var_t mask)
 {
 }
 
+static inline void assign_cpumask_var(cpumask_var_t *dst, cpumask_var_t src)
+{
+	(*dst)[0] = src[0];
+}
+
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index dccbb42..da98191 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -24,7 +24,7 @@ struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	struct cpumask *cpumask;
+	cpumask_var_t cpumask;
 	struct rcu_head rcu_head;
 };
 
@@ -370,7 +370,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	data->csd.func = func;
 	data->csd.info = info;
 	data->refs = num_cpus;
-	data->cpumask = allbutself;
+	assign_cpumask_var(&data->cpumask, allbutself);
 
 	spin_lock_irqsave(&call_function_lock, flags);
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
-- 
1.5.6

