Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZKCE1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZKCE1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZKCE1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:27:53 -0500
Received: from ozlabs.org ([203.10.76.45]:39468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbZKCE1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:27:52 -0500
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>, Dave Jones <davej@redhat.com>
To: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031457.56452.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:57:56 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/14] cpumask: don't put a cpumask on the stack in x86...cpufreq/powernow-k8.c
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's still mugging the current process's cpumask, but as comment in
1ff6e97f1d says, it's not a trivial fix.

So, at least we can use a cpumask_var_t to do the Wrong Thing the Right Way :)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: cpufreq@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1118,7 +1118,7 @@ static int transition_frequency_pstate(s
 static int powernowk8_target(struct cpufreq_policy *pol,
 		unsigned targfreq, unsigned relation)
 {
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1131,9 +1131,13 @@ static int powernowk8_target(struct cpuf
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
-	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	/* only run on specific CPU from here on. */
+	/* This is poor form: use a workqueue or smp_call_function_single */
+	if (!alloc_cpumask_var(&oldmask, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_copy(oldmask, tsk_cpumask(current));
+	set_cpus_allowed_ptr(current, cpumask_of(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1193,7 +1197,8 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
+	set_cpus_allowed_ptr(current, oldmask);
+	free_cpumask_var(oldmask);
 	return ret;
 }
 

