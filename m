Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbYCCRUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbYCCRUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYCCRPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbYCCRO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:58 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 19/52] change x86_64 smp_call_function_mask to look alike i386
Date: Mon,  3 Mar 2008 14:12:47 -0300
Message-Id: <1204564400-17636-20-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-19-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the two versions (the inner version, and the outer version, that takes
the locks) of smp_call_function_mask are made into one. With the changes,
i386 and x86_64 versions look exactly the same.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_32.c |    2 +-
 arch/x86/kernel/smp_64.c |   57 +++++++++++++---------------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..e4a6b66 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -583,7 +583,7 @@ native_smp_call_function_mask(cpumask_t mask,
 		atomic_set(&data.finished, 0);
 
 	call_data = &data;
-	mb();
+	wmb();
 
 	/* Send a message to other CPUs */
 	if (cpus_equal(mask, allbutself))
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index aa2edb7..e4494e8 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -354,26 +354,30 @@ static void __smp_call_function(void (*func) (void *info), void *info,
 }
 
 
-/*
- * this function sends a 'generic call function' IPI to all other CPU
- * of the system defined in the mask.
- */
-static int __smp_call_function_mask(cpumask_t mask,
-				    void (*func)(void *), void *info,
-				    int wait)
+int native_smp_call_function_mask(cpumask_t mask,
+				  void (*func)(void *), void *info,
+				  int wait)
 {
 	struct call_data_struct data;
 	cpumask_t allbutself;
 	int cpus;
 
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	/* Holding any lock stops cpus from going down. */
+	spin_lock(&call_lock);
+
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
 	cpus_and(mask, mask, allbutself);
 	cpus = cpus_weight(mask);
 
-	if (!cpus)
+	if (!cpus) {
+		spin_unlock(&call_lock);
 		return 0;
+	}
 
 	data.func = func;
 	data.info = info;
@@ -395,43 +399,14 @@ static int __smp_call_function_mask(cpumask_t mask,
 	while (atomic_read(&data.started) != cpus)
 		cpu_relax();
 
-	if (!wait)
-		return 0;
+	if (wait)
+		 while (atomic_read(&data.finished) != cpus)
+			cpu_relax();
 
-	while (atomic_read(&data.finished) != cpus)
-		cpu_relax();
+	spin_unlock(&call_lock);
 
 	return 0;
 }
-/**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
- * @mask: The set of cpus to run on.  Must not include the current cpu.
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @wait: If true, wait (atomically) until function has completed on other CPUs.
- *
- * Returns 0 on success, else a negative status code.
- *
- * If @wait is true, then returns once @func has returned; otherwise
- * it returns just before the target cpu calls @func.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler or from a bottom half handler.
- */
-int native_smp_call_function_mask(cpumask_t mask,
-				  void (*func)(void *), void *info,
-				  int wait)
-{
-	int ret;
-
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
-	spin_lock(&call_lock);
-	ret = __smp_call_function_mask(mask, func, info, wait);
-	spin_unlock(&call_lock);
-	return ret;
-}
 
 static void stop_this_cpu(void *dummy)
 {
-- 
1.5.0.6

