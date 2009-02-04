Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbZBDUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbZBDUA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZBDUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:00:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:63464 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZBDUAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,380,1231142400"; 
   d="scan'208";a="107114104"
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <200902040719.25593.borntraeger@de.ibm.com>
References: <200901301729.30284.borntraeger@de.ibm.com>
	 <200902030948.13519.borntraeger@de.ibm.com>
	 <20090203122847.GG19979@elte.hu>
	 <200902040719.25593.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 04 Feb 2009 11:59:44 -0800
Message-Id: <1233777584.16238.16.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 22:19 -0800, Christian Borntraeger wrote:
> Am Tuesday 03 February 2009 13:28:47 schrieb Ingo Molnar:
> > > > +         if (!cpu_active(cpu) {
> > >
> > > That does not compile...I used the following:
> > >             if (!cpu_active(cpu)) {
> >
> > Could you please resubmit an updated patch?
> 
> Suresh,
> 
> can you send the updated patch? After all, its your work and we need your
> Signed-off-by anyway.
> 
> You can add my
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks Christian for testing the fix. Ingo, appended is the updated patch. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: fix nohz load balancer on cpu offline

Christian Borntraeger reports:

> After a logical cpu offline, even on a complete idle system, there
> is one cpu with full ticks. It turns out that nohz.cpu_mask has the
> the offlined cpu still set.
> 
> In select_nohz_load_balancer() we check if the system is completely
> idle to turn of load balancing. We compare cpu_online_map with
> nohz.cpu_mask.  Since cpu_online_map is updated on cpu unplug,
> but nohz.cpu_mask is not, the check fails and the scheduler believes
that
> we need an "idle load balancer" even on a fully idle system. Since the
ilb 
> cpu does not deactivate the timer tick this breaks NOHZ.

Fix the select_nohz_load_balancer() to not set the nohz.cpu_mask
while a cpu is going offline.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 96439a4..8a0419b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4026,19 +4026,24 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
-		/*
-		 * If we are going offline and still the leader, give up!
-		 */
-		if (!cpu_active(cpu) &&
-		    atomic_read(&nohz.load_balancer) == cpu) {
+		if (!cpu_active(cpu)) {
+			if (atomic_read(&nohz.load_balancer) != cpu)
+				return 0;
+
+			/*
+			 * If we are going offline and still the leader,
+			 * give up!
+			 */
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
+
 			return 0;
 		}
 
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
+
 		/* time for ilb owner also to sleep */
 		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)


