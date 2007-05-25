Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbXEYLqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbXEYLqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXEYLqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:46:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbXEYLqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:46:14 -0400
Date: Fri, 25 May 2007 13:46:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] sched_clock: fix preempt count imbalance
Message-ID: <20070525114605.GA4023@elte.hu>
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

you introduced a crash-bug via your cleanups - the patch below fixes it.

	Ingo

----------------------------->
Subject: [patch] sched_clock: fix preempt count imbalance
From: Ingo Molnar <mingo@elte.hu>

fix preempt count imbalance.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/sched-clock.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
===================================================================
--- linux-cfs-2.6.22-rc2-mm1.q.orig/arch/i386/kernel/sched-clock.c
+++ linux-cfs-2.6.22-rc2-mm1.q/arch/i386/kernel/sched-clock.c
@@ -164,7 +164,10 @@ static int sc_freq_event(struct notifier
 			 void *data)
 {
 	struct cpufreq_freqs *freq = data;
-	struct sc_data *sc = &per_cpu(sc_data, freq->cpu);
+	struct sc_data *sc;
+
+	preempt_disable();
+	sc = &per_cpu(sc_data, freq->cpu);
 
 	if (cpu_has(&cpu_data[freq->cpu], X86_FEATURE_CONSTANT_TSC))
 		goto out;
@@ -194,7 +197,8 @@ static int sc_freq_event(struct notifier
 		break;
 	}
 out:
-	put_cpu();
+	preempt_enable();
+
 	return NOTIFY_DONE;
 }
 
