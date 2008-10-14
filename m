Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYJNIaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYJNIaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYJNIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:30:38 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:45910 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYJNIag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:30:36 -0400
Date: Tue, 14 Oct 2008 10:30:20 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: David Miller <davem@davemloft.net>
cc: davej@redhat.com, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: sparc64 allmodconfig build failure...
In-Reply-To: <20081013.230251.215237620.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net>
References: <20081013.230251.215237620.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Tue, 14 Oct 2008 08:30:33 +0000
	Bayes: 0.4214 Tokens: new, 257; hammy, 5; neutral, 2; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4214]
	*  0.0 DNS_FROM_SECURITYSAGE RBL: Envelope sender in
	*      blackholes.securitysage.com
X-Spam-Signature: 2481baefc4566e34c33356fd1270b5332de07182
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, David Miller wrote:

> sparc64 allmodconfig started failing to build recently:
> 
>   MODPOST 1946 modules
> ERROR: "cpufreq_gov_performance" [arch/sparc64/kernel/us3_cpufreq.ko] undefined!
> 
> It seems to be caused by the following commit:
> 
> commit c4d14bc0bb5d13e316890651ae4518b764c3344c
> Author: Sven Wegener <sven.wegener@stealer.net>
> Date:   Sat Sep 20 16:50:08 2008 +0200
> 
>     [CPUFREQ] Don't export governors for default governor
>     
>     We don't need to export the governors for use as the default governor,
>     because the default governor will be built-in anyway and we can access
>     the symbol directly.

Uhm, we could resolve this dependency with the patch below. Although we 
might as well revert the above commit or introduce an exported function 
that sets the default governor on a policy.

Subject: [CPUFREQ] Fix build failure on sparc64

Commit c4d14bc0bb5d13e316890651ae4518b764c3344c ("[CPUFREQ] Don't export 
governors for default governor") caused a build failure, because there are 
several architectures that have cpufreq code that can be built as a 
module, but the code also requires access to the default governor. Export 
the default governor so that it can be accessed by these module.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/cpufreq/cpufreq_conservative.c |    4 +++-
 drivers/cpufreq/cpufreq_ondemand.c     |    4 +++-
 drivers/cpufreq/cpufreq_performance.c  |    4 +++-
 drivers/cpufreq/cpufreq_powersave.c    |    4 +++-
 drivers/cpufreq/cpufreq_userspace.c    |    4 +++-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index e265783..65297e3 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -576,7 +576,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
-#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+EXPORT_SYMBOL(cpufreq_gov_conservative);
+#else
 static
 #endif
 struct cpufreq_governor cpufreq_gov_conservative = {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 2ab3c12..78348b3 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -626,7 +626,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
-#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+EXPORT_SYMBOL(cpufreq_gov_ondemand);
+#else
 static
 #endif
 struct cpufreq_governor cpufreq_gov_ondemand = {
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index 7e2e515..799bfd1 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -36,7 +36,9 @@ static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 	return 0;
 }
 
-#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE_MODULE
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
+EXPORT_SYMBOL(cpufreq_gov_performance);
+#elif defined(CONFIG_CPU_FREQ_GOV_PERFORMANCE_MODULE)
 static
 #endif
 struct cpufreq_governor cpufreq_gov_performance = {
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index e6db5fa..9db749d 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -35,7 +35,9 @@ static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 	return 0;
 }
 
-#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
+EXPORT_SYMBOL(cpufreq_gov_powersave);
+#else
 static
 #endif
 struct cpufreq_governor cpufreq_gov_powersave = {
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 1442bba..fb47b29 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -187,7 +187,9 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 }
 
 
-#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
+EXPORT_SYMBOL(cpufreq_gov_userspace);
+#else
 static
 #endif
 struct cpufreq_governor cpufreq_gov_userspace = {
