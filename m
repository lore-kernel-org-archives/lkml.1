Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYJNVJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYJNVJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYJNVIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:08:39 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:55639 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbYJNVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:08:34 -0400
Date: Tue, 14 Oct 2008 23:08:17 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: David Miller <davem@davemloft.net>, davej@redhat.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: sparc64 allmodconfig build failure...
In-Reply-To: <20081014120605.GB23213@x200.localdomain>
Message-ID: <alpine.LNX.2.00.0810141434030.13897@titan.stealer.net>
References: <20081013.230251.215237620.davem@davemloft.net> <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net> <20081014120605.GB23213@x200.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Tue, 14 Oct 2008 21:08:27 +0000
	Bayes: 0.3501 Tokens: new, 433; hammy, 10; neutral, 2; spammy, 2.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3501]
	*  0.0 DNS_FROM_SECURITYSAGE RBL: Envelope sender in
	*      blackholes.securitysage.com
X-Spam-Signature: a2643069032d7a0e8d7c4e12a54f1522b80539b8
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Alexey Dobriyan wrote:

> On Tue, Oct 14, 2008 at 10:30:20AM +0200, Sven Wegener wrote:
> > On Mon, 13 Oct 2008, David Miller wrote:
> > 
> > > sparc64 allmodconfig started failing to build recently:
> > > 
> > >   MODPOST 1946 modules
> > > ERROR: "cpufreq_gov_performance" [arch/sparc64/kernel/us3_cpufreq.ko] undefined!
> > > 
> > > It seems to be caused by the following commit:
> > > 
> > > commit c4d14bc0bb5d13e316890651ae4518b764c3344c
> > > Author: Sven Wegener <sven.wegener@stealer.net>
> > > Date:   Sat Sep 20 16:50:08 2008 +0200
> > > 
> > >     [CPUFREQ] Don't export governors for default governor
> > >     
> > >     We don't need to export the governors for use as the default governor,
> > >     because the default governor will be built-in anyway and we can access
> > >     the symbol directly.
> > 
> > Uhm, we could resolve this dependency with the patch below. Although we 
> > might as well revert the above commit or introduce an exported function 
> > that sets the default governor on a policy.
> > 
> > Subject: [CPUFREQ] Fix build failure on sparc64
> > 
> > Commit c4d14bc0bb5d13e316890651ae4518b764c3344c ("[CPUFREQ] Don't export 
> > governors for default governor") caused a build failure, because there are 
> > several architectures that have cpufreq code that can be built as a 
> > module, but the code also requires access to the default governor. Export 
> > the default governor so that it can be accessed by these module.
> 
> > --- a/drivers/cpufreq/cpufreq_conservative.c
> > +++ b/drivers/cpufreq/cpufreq_conservative.c
> > @@ -576,7 +576,9 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> >  	return 0;
> >  }
> >  
> > -#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
> > +#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
> > +EXPORT_SYMBOL(cpufreq_gov_conservative);
> > +#else
> >  static
> >  #endif
> 
> This is ugly, ugly.

Yeah, with the default governor being any of supported governors, we 
either need some ugly #ifdef mess to only export the governor that is 
selected or just revert to the old code, which unconditionally exports all 
governors. Or something like the patch below. With the additional modules 
that I oversaw and that require the export, I'm fine with just reverting 
the commit, although I think that encapsulating the default governor 
decision in a built-in function is cleaner than having modules reference 
different symbols depending on configuration.



Subject: [CPUFREQ] Fix build failure on sparc64

Commit c4d14bc0bb5d13e316890651ae4518b764c3344c ("[CPUFREQ] Don't export
governors for default governor") caused a build failure, because there
are several architectures that have cpufreq code that can be built as a
module, but the code also requires access to the default governor.
Instead of messing around with even more #ifdef code, add an exported
function that sets the default governor on a policy.

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
index e4f72d2..58a9b77 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -184,7 +184,7 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
 {
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.max_freq = 160000;
 	policy->cpuinfo.min_freq = 12000;
 	policy->cpuinfo.transition_latency = 1000000; /* 1 ms, assumed */
diff --git a/arch/arm/mach-pxa/cpufreq-pxa2xx.c b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
index d82528e..e013621 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
@@ -335,7 +335,7 @@ static __init int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		pxa27x_guess_max_freq();
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	if (cpu_is_pxa25x())
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
index 1ea0c9c..27a295b 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
@@ -210,7 +210,7 @@ static __init int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 	int ret = -EINVAL;
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.min_freq = 104000;
 	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index f7fa034..94a3cde 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -224,7 +224,7 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 	if (policy->cpu != 0)
 		return -EINVAL;
 	policy->cur = policy->min = policy->max = sa11x0_getspeed(0);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.min_freq = 59000;
 	policy->cpuinfo.max_freq = 287000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/arch/avr32/mach-at32ap/cpufreq.c
index 5dd8d25..20e9e79 100644
--- a/arch/avr32/mach-at32ap/cpufreq.c
+++ b/arch/avr32/mach-at32ap/cpufreq.c
@@ -87,7 +87,7 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 	policy->cur = at32_get_speed(0);
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 
 	printk("cpufreq: AT32AP CPU frequency driver\n");
 
diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index 75cdad2..fe76fec 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -158,7 +158,7 @@ static int __init __bfin_cpu_init(struct cpufreq_policy *policy)
 						 dpm_state_table[index].tscale);
 	}
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 
 	policy->cpuinfo.transition_latency = (bfin_read_PLL_LOCKCNT() / (sclk / 1000000)) * 1000;
 	/*Now ,only support one cpu */
diff --git a/arch/cris/arch-v32/mach-a3/cpufreq.c b/arch/cris/arch-v32/mach-a3/cpufreq.c
index 8e5a3ca..4d64157 100644
--- a/arch/cris/arch-v32/mach-a3/cpufreq.c
+++ b/arch/cris/arch-v32/mach-a3/cpufreq.c
@@ -85,7 +85,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	int result;
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/arch/cris/arch-v32/mach-fs/cpufreq.c
index d57631c..245c1d0 100644
--- a/arch/cris/arch-v32/mach-fs/cpufreq.c
+++ b/arch/cris/arch-v32/mach-fs/cpufreq.c
@@ -81,7 +81,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	int result;
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.transition_latency = 1000000;	/* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
diff --git a/arch/sparc64/kernel/us3_cpufreq.c b/arch/sparc64/kernel/us3_cpufreq.c
index 47e3aca..7bc5c78 100644
--- a/arch/sparc64/kernel/us3_cpufreq.c
+++ b/arch/sparc64/kernel/us3_cpufreq.c
@@ -183,7 +183,7 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	table[3].index = 0;
 	table[3].frequency = CPUFREQ_TABLE_END;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 31d6f53..c6bb3b7 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -813,7 +813,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	INIT_WORK(&policy->update, handle_update);
 
 	/* Set governor before ->init, so that driver could check it */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	cpufreq_policy_set_default_governor(policy);
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
@@ -1554,6 +1554,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	return ret;
 }
 
+void cpufreq_policy_set_default_governor(struct cpufreq_policy *policy)
+{
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+}
+EXPORT_SYMBOL_GPL(cpufreq_policy_set_default_governor);
 
 int cpufreq_register_governor(struct cpufreq_governor *governor)
 {
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 1ee608f..3651092 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -190,6 +190,7 @@ extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
 extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
 				   unsigned int cpu);
 
+void cpufreq_policy_set_default_governor(struct cpufreq_policy *policy);
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
