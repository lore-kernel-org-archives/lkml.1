Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbYGSBN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbYGSBN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYGSBLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50820 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbYGSBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.822797000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:32 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk
Subject: [PATCH 6/8] NR_CPUS: Replace NR_CPUS in cpufreq userspace routines
Content-Disposition: inline; filename=repl-NR_CPUS-in-cpufreq_userspace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * This patch seems to have been misplaced.  Replace arrays sized by NR_CPUS
    with percpu variables.

    Prior reference: http://marc.info/?l=linux-kernel&m=120251421825989&w=4
    Subject:    [PATCH 1/4] cpufreq: change cpu freq tables to per_cpu variables
    From:       Mike Travis <travis () sgi ! com>
    Date:       2008-02-08 23:37:39

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: cpufreq@lists.linux.org.uk
---
 drivers/cpufreq/cpufreq_userspace.c |   79 +++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 36 deletions(-)

--- linux-2.6.tip.orig/drivers/cpufreq/cpufreq_userspace.c
+++ linux-2.6.tip/drivers/cpufreq/cpufreq_userspace.c
@@ -30,16 +30,18 @@
 /**
  * A few values needed by the userspace governor
  */
-static unsigned int	cpu_max_freq[NR_CPUS];
-static unsigned int	cpu_min_freq[NR_CPUS];
-static unsigned int	cpu_cur_freq[NR_CPUS]; /* current CPU freq */
-static unsigned int	cpu_set_freq[NR_CPUS]; /* CPU freq desired by userspace */
-static unsigned int	cpu_is_managed[NR_CPUS];
+static DEFINE_PER_CPU(unsigned int, cpu_max_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_min_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
+static DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by
+							userspace */
+static DEFINE_PER_CPU(unsigned int, cpu_is_managed);
 
 static DEFINE_MUTEX	(userspace_mutex);
 static int cpus_using_userspace_governor;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
 
 /* keep track of frequency transitions */
 static int
@@ -48,12 +50,12 @@ userspace_cpufreq_notifier(struct notifi
 {
         struct cpufreq_freqs *freq = data;
 
-	if (!cpu_is_managed[freq->cpu])
+	if (!per_cpu(cpu_is_managed, freq->cpu))
 		return 0;
 
 	dprintk("saving cpu_cur_freq of cpu %u to be %u kHz\n",
 			freq->cpu, freq->new);
-	cpu_cur_freq[freq->cpu] = freq->new;
+	per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
 
         return 0;
 }
@@ -77,15 +79,15 @@ static int cpufreq_set(struct cpufreq_po
 	dprintk("cpufreq_set for cpu %u, freq %u kHz\n", policy->cpu, freq);
 
 	mutex_lock(&userspace_mutex);
-	if (!cpu_is_managed[policy->cpu])
+	if (!per_cpu(cpu_is_managed, policy->cpu))
 		goto err;
 
-	cpu_set_freq[policy->cpu] = freq;
+	per_cpu(cpu_set_freq, policy->cpu) = freq;
 
-	if (freq < cpu_min_freq[policy->cpu])
-		freq = cpu_min_freq[policy->cpu];
-	if (freq > cpu_max_freq[policy->cpu])
-		freq = cpu_max_freq[policy->cpu];
+	if (freq < per_cpu(cpu_min_freq, policy->cpu))
+		freq = per_cpu(cpu_min_freq, policy->cpu);
+	if (freq > per_cpu(cpu_max_freq, policy->cpu))
+		freq = per_cpu(cpu_max_freq, policy->cpu);
 
 	/*
 	 * We're safe from concurrent calls to ->target() here
@@ -104,7 +106,7 @@ static int cpufreq_set(struct cpufreq_po
 
 static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", cpu_cur_freq[policy->cpu]);
+	return sprintf(buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
 }
 
 static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
@@ -127,12 +129,17 @@ static int cpufreq_governor_userspace(st
 		}
 		cpus_using_userspace_governor++;
 
-		cpu_is_managed[cpu] = 1;
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
-		cpu_set_freq[cpu] = policy->cur;
-		dprintk("managing cpu %u started (%u - %u kHz, currently %u kHz)\n", cpu, cpu_min_freq[cpu], cpu_max_freq[cpu], cpu_cur_freq[cpu]);
+		per_cpu(cpu_is_managed, cpu) = 1;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
+		per_cpu(cpu_set_freq, cpu) = policy->cur;
+		dprintk("managing cpu %u started "
+			"(%u - %u kHz, currently %u kHz)\n",
+				cpu,
+				per_cpu(cpu_min_freq, cpu),
+				per_cpu(cpu_max_freq, cpu),
+				per_cpu(cpu_cur_freq, cpu));
 
 		mutex_unlock(&userspace_mutex);
 		break;
@@ -145,34 +152,34 @@ static int cpufreq_governor_userspace(st
 					CPUFREQ_TRANSITION_NOTIFIER);
 		}
 
-		cpu_is_managed[cpu] = 0;
-		cpu_min_freq[cpu] = 0;
-		cpu_max_freq[cpu] = 0;
-		cpu_set_freq[cpu] = 0;
+		per_cpu(cpu_is_managed, cpu) = 0;
+		per_cpu(cpu_min_freq, cpu) = 0;
+		per_cpu(cpu_max_freq, cpu) = 0;
+		per_cpu(cpu_set_freq, cpu) = 0;
 		dprintk("managing cpu %u stopped\n", cpu);
 		mutex_unlock(&userspace_mutex);
 		break;
 	case CPUFREQ_GOV_LIMITS:
 		mutex_lock(&userspace_mutex);
-		dprintk("limit event for cpu %u: %u - %u kHz,"
+		dprintk("limit event for cpu %u: %u - %u kHz, "
 			"currently %u kHz, last set to %u kHz\n",
 			cpu, policy->min, policy->max,
-			cpu_cur_freq[cpu], cpu_set_freq[cpu]);
-		if (policy->max < cpu_set_freq[cpu]) {
+			per_cpu(cpu_cur_freq, cpu),
+			per_cpu(cpu_set_freq, cpu));
+		if (policy->max < per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->max,
 						CPUFREQ_RELATION_H);
-		}
-		else if (policy->min > cpu_set_freq[cpu]) {
+		} else if (policy->min > per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->min,
 						CPUFREQ_RELATION_L);
-		}
-		else {
-			__cpufreq_driver_target(policy, cpu_set_freq[cpu],
+		} else {
+			__cpufreq_driver_target(policy,
+						per_cpu(cpu_set_freq, cpu),
 						CPUFREQ_RELATION_L);
 		}
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
 		mutex_unlock(&userspace_mutex);
 		break;
 	}

-- 
