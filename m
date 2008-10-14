Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYJNGDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYJNGDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 02:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYJNGDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 02:03:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33633
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbYJNGDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 02:03:15 -0400
Date: Mon, 13 Oct 2008 23:02:51 -0700 (PDT)
Message-Id: <20081013.230251.215237620.davem@davemloft.net>
To: sven.wegener@stealer.net
CC: davej@redhat.com, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: sparc64 allmodconfig build failure...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sparc64 allmodconfig started failing to build recently:

  MODPOST 1946 modules
ERROR: "cpufreq_gov_performance" [arch/sparc64/kernel/us3_cpufreq.ko] undefined!

It seems to be caused by the following commit:

commit c4d14bc0bb5d13e316890651ae4518b764c3344c
Author: Sven Wegener <sven.wegener@stealer.net>
Date:   Sat Sep 20 16:50:08 2008 +0200

    [CPUFREQ] Don't export governors for default governor
    
    We don't need to export the governors for use as the default governor,
    because the default governor will be built-in anyway and we can access
    the symbol directly.
    
    This also fixes the following sparse warnings:
    
    drivers/cpufreq/cpufreq_conservative.c:578:25: warning: symbol 'cpufreq_gov_conservative' was not declared. Should it be static?
    drivers/cpufreq/cpufreq_ondemand.c:582:25: warning: symbol 'cpufreq_gov_ondemand' was not declared. Should it be static?
    drivers/cpufreq/cpufreq_performance.c:39:25: warning: symbol 'cpufreq_gov_performance' was not declared. Should it be static?
    drivers/cpufreq/cpufreq_powersave.c:38:25: warning: symbol 'cpufreq_gov_powersave' was not declared. Should it be static?
    drivers/cpufreq/cpufreq_userspace.c:190:25: warning: symbol 'cpufreq_gov_userspace' was not declared. Should it be static?
    
    Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
    Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 4ee53a4..e265783 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -576,13 +576,15 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_conservative = {
 	.name			= "conservative",
 	.governor		= cpufreq_governor_dbs,
 	.max_transition_latency	= TRANSITION_LATENCY_LIMIT,
 	.owner			= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_conservative);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 39253d6..bd06934 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -626,13 +626,15 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+static
+#endif
 struct cpufreq_governor cpufreq_gov_ondemand = {
 	.name			= "ondemand",
 	.governor		= cpufreq_governor_dbs,
 	.max_transition_latency = TRANSITION_LATENCY_LIMIT,
 	.owner			= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_ondemand);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..7e2e515 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -36,12 +36,14 @@ static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE_MODULE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_performance = {
 	.name		= "performance",
 	.governor	= cpufreq_governor_performance,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_performance);
 
 
 static int __init cpufreq_gov_performance_init(void)
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 88d2f44..e6db5fa 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -35,12 +35,14 @@ static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_powersave = {
 	.name		= "powersave",
 	.governor	= cpufreq_governor_powersave,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_powersave);
 
 static int __init cpufreq_gov_powersave_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 32244aa..1442bba 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -187,6 +187,9 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 }
 
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_userspace = {
 	.name		= "userspace",
 	.governor	= cpufreq_governor_userspace,
@@ -194,7 +197,6 @@ struct cpufreq_governor cpufreq_gov_userspace = {
 	.show_setspeed	= show_speed,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_userspace);
 
 static int __init cpufreq_gov_userspace_init(void)
 {
