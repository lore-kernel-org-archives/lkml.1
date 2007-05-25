Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXEYLuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXEYLuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXEYLuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:50:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45172 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbXEYLuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:50:09 -0400
Date: Fri, 25 May 2007 13:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] sched_clock(): cleanups, #2
Message-ID: <20070525115004.GA4574@elte.hu>
References: <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org> <20070525090315.GK8094@one.firstfloor.org> <20070525091928.GA3177@elte.hu> <20070525094640.GL8094@one.firstfloor.org> <20070525101248.GA7547@elte.hu> <20070525112020.GN8094@one.firstfloor.org> <20070525112600.GA27007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525112600.GA27007@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > please send me your current sched-clock.c, i'll redo any remaining 
> > > cleanups.
> > 
> > It needs at least one new preliminary patch (to add on_cpu_single);
> > please get the series from 
> > ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches-2.6.22-rc2-git7-070525-1.tar.gz
> > You need at least tsc-unstable upto paravirt-add-a-sched_clock-paravirt
> > for everything
> 
> thanks.
> 
> you missed one patch: please pick up the NUMAQ change i did too. (i 
> kept the printk to make sure someone notices that and actually tests 
> thing - i dont have a NUMAQ machine to try this on.)
> 
> i'm looking at the other things now.

find below the cleanups from my first patch that didnt make it into your 
cleanups. (plus one more cleanup i noticed while merging the missing 
bits from my first patch) Goes after the bugfix i just sent. Please 
apply.

	Ingo

---------------------->
Subject: [patch] sched_clock(): cleanups, #2
From: Ingo Molnar <mingo@elte.hu>

clean up sched-clock.c - the missing bits.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/sched-clock.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/i386/kernel/sched-clock.c
+++ linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
@@ -89,8 +89,10 @@ unsigned long long native_sched_clock(vo
 	return r;
 }
 
-/* We need to define a real function for sched_clock, to override the
-   weak default version */
+/*
+ * We need to define a real function for sched_clock, to override the
+ * weak default version
+ */
 #ifdef CONFIG_PARAVIRT
 unsigned long long sched_clock(void)
 {
@@ -119,6 +121,9 @@ static void resolve_freq(struct cpufreq_
 {
 	if (!freq->new) {
 		freq->new = cpufreq_get(freq->cpu);
+		/*
+		 * Still no frequency? Then fall back to tsc_khz:
+		 */
 		if (!freq->new)
 			freq->new = tsc_khz;
 	}
@@ -129,6 +134,7 @@ static void resync_freq(void *arg)
 {
 	struct cpufreq_freqs *freq = (void *)arg;
 	struct sc_data *sc = &__get_cpu_var(sc_data);
+
 	sc->sync_base = jiffies;
 	if (!cpu_has_tsc) {
 		sc->unstable = 1;
@@ -155,13 +161,14 @@ static void resync_freq(void *arg)
 static void resync_freq_on_cpu(void *arg)
 {
 	struct cpufreq_freqs f = { .new = 0 };
+
 	f.cpu = get_cpu();
 	resync_freq(&f);
 	put_cpu();
 }
 
-static int sc_freq_event(struct notifier_block *nb, unsigned long event,
-			 void *data)
+static int
+sc_freq_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct cpufreq_freqs *freq = data;
 	struct sc_data *sc;
@@ -210,8 +217,10 @@ static int __cpuinit
 sc_cpu_event(struct notifier_block *self, unsigned long event, void *hcpu)
 {
 	long cpu = (long)hcpu;
+
 	if (event == CPU_ONLINE) {
 		struct cpufreq_freqs f = { .cpu = cpu, .new = 0 };
+
 		on_cpu_single(cpu, resync_freq, &f);
 	}
 	return NOTIFY_DONE;
@@ -221,7 +230,6 @@ static __init int init_sched_clock(void)
 {
 	if (unsynchronized_tsc())
 		no_sc_for_printk = 1;
-
 	/*
 	 * On a race between the various events the initialization
 	 * might be done multiple times, but code is tolerant to
@@ -231,7 +239,7 @@ static __init int init_sched_clock(void)
 				CPUFREQ_TRANSITION_NOTIFIER);
 	hotcpu_notifier(sc_cpu_event, 0);
 	on_each_cpu(resync_freq_on_cpu, NULL, 0, 0);
+
 	return 0;
 }
 core_initcall(init_sched_clock);
-
