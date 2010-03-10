Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0CJVOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:14:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:53808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757188Ab0CJVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:14:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HDzFzBGiH98ZFmpJTW4FefXqvANT5LHW7xAKnHF
	9YUmuJ0muVJfqj
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1268141220.28032.12.camel@marge.simson.net>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
	 <1267820755.6384.85.camel@marge.simson.net>
	 <1268087062.2830.285.camel@sbs-t61.sc.intel.com>
	 <1268114749.6349.20.camel@marge.simson.net>
	 <1268141220.28032.12.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 10 Mar 2010 22:14:21 +0100
Message-Id: <1268255661.6613.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.40999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 14:27 +0100, Mike Galbraith wrote:
> On Tue, 2010-03-09 at 07:05 +0100, Mike Galbraith wrote:
> > On Mon, 2010-03-08 at 14:24 -0800, Suresh Siddha wrote:
> 
> > > Ok. I dropped that part in v2 patches that I just posted.
> > 
> > Yeah, I see mails (ramble ramble) crossed in the night.  I'll take them
> > out for a spin, see if your box can get fixed up without busting mine :)
> 
...

BTW, does the below also cure your netbook's woes?  (should)


sched: fix select_idle_sibling()

Don't bother with selection when the current cpu is idle.  Recent load
balancing changes also make it no longer necessary to check wake_affine()
success before returning the selected sibling, so we now always use it.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched_fair.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1438,7 +1438,7 @@ static int select_task_rq_fair(struct ta
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
-	int want_affine = 0;
+	int want_affine = 0, cpu_idle = !current->pid;
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
@@ -1496,13 +1496,15 @@ static int select_task_rq_fair(struct ta
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
+			if (!cpu_idle && tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
 				if (tmp->flags & SD_WAKE_AFFINE) {
 					affine_sd = tmp;
 					want_affine = 0;
+					if (target != cpu)
+						cpu_idle = 1;
 				}
 				cpu = target;
 			}
@@ -1518,6 +1520,7 @@ static int select_task_rq_fair(struct ta
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1531,9 +1534,12 @@ static int select_task_rq_fair(struct ta
 		if (tmp)
 			update_shares(tmp);
 	}
+#endif
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		if (cpu_idle || cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+			return cpu;
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;


