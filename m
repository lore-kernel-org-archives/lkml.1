Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753311AbYLRUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYLRUcU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLRUcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:32:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYLRUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:32:05 -0500
Date: Thu, 18 Dec 2008 21:31:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081218203140.GA18757@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218201938.GB12376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218201938.GB12376@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks, applied - and i started testing them. [...]

the sched.h bits needed the small fix below. (struct sched_domain is not 
defined on UP)

	Ingo

------------->
>From edb4c71953409c1deac1a80528ac0aa768762b33 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 18 Dec 2008 21:30:23 +0100
Subject: [PATCH] sched: move test_sd_parent() to an SMP section of sched.h

Impact: build fix

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5a933d9..e5f928a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -920,6 +920,15 @@ extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
+/* Test a flag in parent sched domain */
+static inline int test_sd_parent(struct sched_domain *sd, int flag)
+{
+	if (sd->parent && (sd->parent->flags & flag))
+		return 1;
+
+	return 0;
+}
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1431,15 +1440,6 @@ struct task_struct {
 #endif
 };
 
-/* Test a flag in parent sched domain */
-static inline int test_sd_parent(struct sched_domain *sd, int flag)
-{
-	if (sd->parent && (sd->parent->flags & flag))
-		return 1;
-
-	return 0;
-}
-
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
