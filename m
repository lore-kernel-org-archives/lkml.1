Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZHUL7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZHUL7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZHUL7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:59:12 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:3210 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbZHUL7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:59:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: Latest Linus tree oopses on Nehalem box
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jes Sorensen <jes@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090821114645.GD24647@elte.hu>
References: <4A8E7CBE.3020209@sgi.com>  <20090821114645.GD24647@elte.hu>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 13:58:54 +0200
Message-Id: <1250855934.7538.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 13:46 +0200, Ingo Molnar wrote:
> * Jes Sorensen <jes@sgi.com> wrote:
> 
> > Hi,
> >
> > I am seeing this one with the latest Linus' git tree as of this 
> > morning on a Nehalem box. Using the defconfig + megaraid driver.
> >
> > Not sure if this is already fixed, or if someone already knows 
> > whats wrong? Smells like a yet another BIOS bug - yes the BIOS on 
> > this thing is rubbish.
> 
> my Nehalem (16 logical cpus) boots fine:
> 
>  aldebaran:~> uname -a
>  Linux aldebaran 2.6.31-rc6-tip-01272-g9919e28-dirty #1518 SMP Fri 
>  Aug 21 11:13:12 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> > [    6.664800] RIP: 0010:[<ffffffff810391e7>]  [<ffffffff810391e7>]  
> > find_busiest_group+0x620/0x6fd 
> 
> Nothing similar is open at the moment.
> 
> There's only one open .31 scheduler regression bug at the moment: a 
> rare division by zero bug that sometimes crashes boxes - the bigger 
> the box the likelier the crash.

That's actually a -tip only regression caused by
a5004278f0525dcb9aa43703ef77bf371ea837cd.

I thought to had found the race that caused the /0 (the below patch),
but testing has proven me wrong. Still looking at that.

---
Subject: sched: Avoid division by zero
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Aug 07 21:53:17 CEST 2009

Patch a5004278f0525dcb9aa43703ef77bf371ea837cd (sched: Fix cgroup smp
fairness) introduced the possibility of a divide-by-zero because
load-balancing is not synchronized between sched_domains.

This can cause the state of cpus to change between the first and
second loop over the sched domain in tg_shares_up().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1522,7 +1522,8 @@ static void __set_se_shares(struct sched
  */
 static void
 update_group_shares_cpu(struct task_group *tg, int cpu,
-			unsigned long sd_shares, unsigned long sd_rq_weight)
+			unsigned long sd_shares, unsigned long sd_rq_weight,
+			unsigned long sd_eff_weight)
 {
 	unsigned long rq_weight;
 	unsigned long shares;
@@ -1535,13 +1536,15 @@ update_group_shares_cpu(struct task_grou
 	if (!rq_weight) {
 		boost = 1;
 		rq_weight = NICE_0_LOAD;
+		if (sd_rq_weight == sd_eff_weight)
+			sd_eff_weight += NICE_0_LOAD;
+		sd_rq_weight = sd_eff_weight;
 	}
 
 	/*
-	 *           \Sum shares * rq_weight
-	 * shares =  -----------------------
-	 *               \Sum rq_weight
-	 *
+	 *             \Sum_j shares_j * rq_weight_i
+	 * shares_i =  -----------------------------
+	 *                  \Sum_j rq_weight_j
 	 */
 	shares = (sd_shares * rq_weight) / sd_rq_weight;
 	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
@@ -1593,14 +1596,8 @@ static int tg_shares_up(struct task_grou
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	for_each_cpu(i, sched_domain_span(sd)) {
-		unsigned long sd_rq_weight = rq_weight;
-
-		if (!tg->cfs_rq[i]->rq_weight)
-			sd_rq_weight = eff_weight;
-
-		update_group_shares_cpu(tg, i, shares, sd_rq_weight);
-	}
+	for_each_cpu(i, sched_domain_span(sd))
+		update_group_shares_cpu(tg, i, shares, rq_weight, eff_weight);
 
 	return 0;
 }


