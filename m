Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYA1CR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYA1CR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYA1CRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:17:49 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54702 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYA1CRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:17:48 -0500
Date: Mon, 28 Jan 2008 08:01:29 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Message-ID: <20080128023129.GD1044@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 27, 2008 at 09:01:15PM +0100, Guillaume Chazarain wrote:
> I noticed some strangely high wake up latencies with FAIR_USER_SCHED
> using this script:

<snip>

> We have two busy loops with UID=1.
> And UID=2 maintains the running median of its wake up latency.
> I get these latencies:
> 
> # ./sched.py
> 4.300022 ms
> 4.801178 ms
> 4.604006 ms

Given that sysctl_sched_wakeup_granularity is set to 10ms by default,
this doesn't sound abnormal.

<snip>

> Disabling FAIR_USER_SCHED restores wake up latencies in the noise:
> 
> # ./sched.py
> -0.156975 ms
> -0.067091 ms
> -0.022984 ms

The reason why we are getting better wakeup latencies for !FAIR_USER_SCHED is 
because of this snippet of code in place_entity():

	if (!initial) {
		/* sleeps upto a single latency don't count. */
		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
						     ^^^^^^^^^^^^^^^^^^
			vruntime -= sysctl_sched_latency;

		/* ensure we never gain time by being placed backwards. */
		vruntime = max_vruntime(se->vruntime, vruntime);
	}


NEW_FAIR_SLEEPERS feature gives credit for sleeping only to tasks and
not group-level entities. With the patch attached, I could see that wakeup 
latencies with FAIR_USER_SCHED are restored to the same level as 
!FAIR_USER_SCHED. 

However I am not sure whether that is the way to go. We want to let one group of
tasks running as much as possible until the fairness/wakeup-latency threshold is
exceeded. If someone does want better wakeup latencies between groups too, they 
can always tune sysctl_sched_wakeup_granularity.

<snip>

> Strangely enough, another way to restore normal latencies is to change
> setuid(2) to setuid(1), that is, putting the latency measurement in
> the same group as the two busy loops.



-- 
Regards,
vatsa

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fix.patch"


---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -511,7 +511,7 @@
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
+		if (sched_feat(NEW_FAIR_SLEEPERS))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */

--LQksG6bCIzRHxTLp--
