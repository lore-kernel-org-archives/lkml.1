Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYA1NSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYA1NSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYA1NSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:18:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbYA1NSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:18:41 -0500
Date: Mon, 28 Jan 2008 14:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Mike Galbraith <efault@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-ID: <20080128131823.GB8269@elte.hu>
References: <479B69D2.5050603@wpkg.org> <200801271339.14668.toralf.foerster@gmx.de> <1201460328.5092.95.camel@homer.simson.net> <200801272214.49928.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801272214.49928.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Toralf, for me the group scheduler offers superior interactivity on my 
laptop for a number of reasons. The biggest practical effect is because 
it splits the CPU time between Xorg (root UID) and desktop apps. This 
helps particularly well when there's compile jobs going on, etc. - Xorg 
still gets a guaranteed share of CPU time which is a nice touch. The 
mouse does not lag that much under load, etc. It's not always possible 
to renice every aspect of my destop.

i wasnt using dnetc myself, so i never triggered your particular issue - 
but i met a similar issue with the distcc user. I think it's more robust 
in general to isolate the dnetc user a bit from the rest of the system - 
even at nice +19 dnetc can interact with your desktop apps.

( In the long run, dnetc (and distcc, and all the other batch/clustering
  apps) would automatically set their uid to a lower cpu_share value, so
  this manual tweaking would not be needed. )

So if you have some time to play with this, could you please try the 
following experiment. Put the following line into your 
/etc/rc.d/rc.local file:

 echo 2 > /sys/kernel/uids/`grep -w dnetc /etc/passwd | cut -d: -f3`/cpu_share

with group scheduling (CONFIG_FAIR_GROUP_SCHED=y) enabled. Also apply 
the patch attached below as well - which fixes some interactivity 
problems with group scheduling.

Could you try that kernel and compare it to a FAIR_GROUP_SCHED-disabled 
kernel's interactivity, and send us your observations?

the group scheduler needs tuning in your case, but in the end, i believe 
it can offer even better interactivity than what we had before - so it 
would be nice if you could try it and compare.

If this still doesnt do the trick and the group scheduler is worse in 
your testing then there's something else going on as well which we need 
to fix. (even if you ultimately decide to disable the group scheduler) 
At minimum we should be able to reach a "works just as well as with 
group scheduling disabled" state. Thanks,

	Ingo

Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -520,7 +520,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
+		if (sched_feat(NEW_FAIR_SLEEPERS))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
@@ -1106,7 +1106,11 @@ static void check_preempt_wakeup(struct 
 	}
 
 	gran = sysctl_sched_wakeup_granularity;
-	if (unlikely(se->load.weight != NICE_0_LOAD))
+	/*
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
+	 */
+	if (unlikely(se->load.weight > NICE_0_LOAD))
 		gran = calc_delta_fair(gran, &se->load);
 
 	if (pse->vruntime + gran < se->vruntime)
