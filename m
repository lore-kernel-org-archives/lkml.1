Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYLDN6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYLDN6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYLDN5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:57:54 -0500
Received: from ozlabs.org ([203.10.76.45]:40649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYLDN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:57:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t.
Date: Fri, 5 Dec 2008 00:27:41 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050027.41948.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There's only one user, and it's a fairly easy conversion.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c 
b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -458,11 +458,6 @@ static int centrino_verify (struct cpufr
  *
  * Sets a new CPUFreq policy.
  */
-struct allmasks {
-	cpumask_t		saved_mask;
-	cpumask_t		covered_cpus;
-};
-
 static int centrino_target (struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -472,12 +467,15 @@ static int centrino_target (struct cpufr
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-	CPUMASK_ALLOC(allmasks);
-	CPUMASK_PTR(saved_mask, allmasks);
-	CPUMASK_PTR(covered_cpus, allmasks);
+	cpumask_var_t saved_mask, covered_cpus;
 
-	if (unlikely(allmasks == NULL))
+	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
+	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+		free_cpumask_var(saved_mask);
+		return -ENOMEM;
+	}
+	cpumask_copy(saved_mask, &current->cpus_allowed);
 
 	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
 		retval = -ENODEV;
@@ -493,9 +491,7 @@ static int centrino_target (struct cpufr
 		goto out;
 	}
 
-	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
-	cpus_clear(*covered_cpus);
 	for_each_cpu_mask_nr(j, policy->cpus) {
 		const cpumask_t *mask;
 
@@ -605,7 +601,8 @@ migrate_end:
 	preempt_enable();
 	set_cpus_allowed_ptr(current, saved_mask);
 out:
-	CPUMASK_FREE(allmasks);
+	free_cpumask_var(saved_mask);
+	free_cpumask_var(covered_cpus);
 	return retval;
 }
 

