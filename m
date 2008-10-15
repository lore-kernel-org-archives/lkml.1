Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYJOWLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYJOWLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYJOWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:11:09 -0400
Received: from isilmar.linta.de ([213.133.102.198]:36532 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753427AbYJOWLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:11:07 -0400
Date: Thu, 16 Oct 2008 00:11:04 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: David Miller <davem@davemloft.net>, adobriyan@gmail.com, davej@redhat.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sparc64 allmodconfig build failure...
Message-ID: <20081015221104.GA18320@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Sven Wegener <sven.wegener@stealer.net>,
	David Miller <davem@davemloft.net>, adobriyan@gmail.com,
	davej@redhat.com, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net> <20081014120605.GB23213@x200.localdomain> <alpine.LNX.2.00.0810141434030.13897@titan.stealer.net> <20081014.154916.232117559.davem@davemloft.net> <alpine.LNX.2.00.0810152354350.28346@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0810152354350.28346@titan.stealer.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 12:05:46AM +0200, Sven Wegener wrote:
> On Tue, 14 Oct 2008, David Miller wrote:
> 
> > From: Sven Wegener <sven.wegener@stealer.net>
> > Date: Tue, 14 Oct 2008 23:08:17 +0200 (CEST)
> > 
> > > Yeah, with the default governor being any of supported governors, we
> > > either need some ugly #ifdef mess to only export the governor that
> > > is selected or just revert to the old code, which unconditionally
> > > exports all governors. Or something like the patch below. With the
> > > additional modules that I oversaw and that require the export, I'm
> > > fine with just reverting the commit, although I think that
> > > encapsulating the default governor decision in a built-in function
> > > is cleaner than having modules reference different symbols depending
> > > on configuration.
> > 
> > Personally I prefer the revert.
> 
> Fine with me. Dave J. or Linus, please revert 
> c4d14bc0bb5d13e316890651ae4518b764c3344c, because it breaks allmodconfig 
> as reported by David Miller on architectures that have cpufreq code that 
> can be build as a module. All ways to only export the default governor are 
> a ifdef mess and ugly, let's just revert the commit.

Ever wondered why this build failure only happened on sparc, and not on x86?
Because the line
	policy->governor = CPUFREQ_DEFAULT_GOVERNOR
actually isn't needed in any cpufreq driver (no x86 driver sets it) as it is
already set this way in the cpufreq core. Therefore, we can remove this line
from all drivers, and keep the cleanup commit
c4d14bc0bb5d13e316890651ae4518b764c3344c  .

Best,
	Dominik


[PATCH] cpufreq: remove policy->governor setting in drivers initialization

As policy->governor is already set to CPUFREQ_DEFAULT_GOVERNOR in the
(always built-in) cpufreq core, we do not need to set it in the drivers.
This fixes the sparc64 allmodconfig build failure.

Also, remove a totally useles setting of ->policy in cpufreq-pxa3xx.c.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/arch/arm/mach-integrator/cpu.c b/arch/arm/mach-integrator/cpu.c
index e4f72d2..44d4c2e 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/arch/arm/mach-integrator/cpu.c
@@ -184,7 +184,6 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
 {
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.max_freq = 160000;
 	policy->cpuinfo.min_freq = 12000;
 	policy->cpuinfo.transition_latency = 1000000; /* 1 ms, assumed */
diff --git a/arch/arm/mach-pxa/cpufreq-pxa2xx.c b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
index d82528e..1f272ea 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
@@ -335,9 +335,6 @@ static __init int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		pxa27x_guess_max_freq();
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-	if (cpu_is_pxa25x())
-		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
 	policy->cur = get_clk_frequency_khz(0);	   /* current freq */
 	policy->min = policy->max = policy->cur;
diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
index 1ea0c9c..968c830 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa3xx.c
@@ -210,7 +210,6 @@ static __init int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 	int ret = -EINVAL;
 
 	/* set default policy and cpuinfo */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = 104000;
 	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
diff --git a/arch/arm/mach-sa1100/cpu-sa1100.c b/arch/arm/mach-sa1100/cpu-sa1100.c
index f7fa034..244d595 100644
--- a/arch/arm/mach-sa1100/cpu-sa1100.c
+++ b/arch/arm/mach-sa1100/cpu-sa1100.c
@@ -224,7 +224,6 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 	if (policy->cpu != 0)
 		return -EINVAL;
 	policy->cur = policy->min = policy->max = sa11x0_getspeed(0);
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.min_freq = 59000;
 	policy->cpuinfo.max_freq = 287000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/arch/avr32/mach-at32ap/cpufreq.c
index 5dd8d25..d84efe4 100644
--- a/arch/avr32/mach-at32ap/cpufreq.c
+++ b/arch/avr32/mach-at32ap/cpufreq.c
@@ -87,7 +87,6 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 	policy->cur = at32_get_speed(0);
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 
 	printk("cpufreq: AT32AP CPU frequency driver\n");
 
diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index 75cdad2..c22c47b 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -158,8 +158,6 @@ static int __init __bfin_cpu_init(struct cpufreq_policy *policy)
 						 dpm_state_table[index].tscale);
 	}
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-
 	policy->cpuinfo.transition_latency = (bfin_read_PLL_LOCKCNT() / (sclk / 1000000)) * 1000;
 	/*Now ,only support one cpu */
 	policy->cur = cclk;
diff --git a/arch/cris/arch-v32/mach-a3/cpufreq.c b/arch/cris/arch-v32/mach-a3/cpufreq.c
index 8e5a3ca..ee391ec 100644
--- a/arch/cris/arch-v32/mach-a3/cpufreq.c
+++ b/arch/cris/arch-v32/mach-a3/cpufreq.c
@@ -85,7 +85,6 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	int result;
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/arch/cris/arch-v32/mach-fs/cpufreq.c
index d57631c..58bd71e 100644
--- a/arch/cris/arch-v32/mach-fs/cpufreq.c
+++ b/arch/cris/arch-v32/mach-fs/cpufreq.c
@@ -81,7 +81,6 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	int result;
 
 	/* cpuinfo and default policy values */
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 1000000;	/* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
diff --git a/arch/sparc64/kernel/us3_cpufreq.c b/arch/sparc64/kernel/us3_cpufreq.c
index 47e3aca..365b646 100644
--- a/arch/sparc64/kernel/us3_cpufreq.c
+++ b/arch/sparc64/kernel/us3_cpufreq.c
@@ -183,7 +183,6 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	table[3].index = 0;
 	table[3].frequency = CPUFREQ_TABLE_END;
 
-	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 





