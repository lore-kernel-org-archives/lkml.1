Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbYEXII6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbYEXII6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYEXIIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:08:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:52958 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755380AbYEXIIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:08:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ERohj3xgEykEEgbrKaosFOBX9Bdyzt+hWLBFNcs
	4uxaJw6DKQPtK7
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1211586407.4786.5.camel@marge.simson.net>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 24 May 2008 10:08:30 +0200
Message-Id: <1211616510.5895.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-24 at 01:46 +0200, Mike Galbraith wrote:
> On Fri, 2008-05-23 at 19:18 -0400, Greg Smith wrote:

> > Should I still be trying Peter's se.waker patch as well in this mix 
> > somewhere?
> 
> Yeah.

btw, the problem with 2.6.25.4 and this load is one and the same.  With
a 1:N load, you really don't want work generator waking all worker-bees
on it's CPU.  The patchlet below let's you turn it off.

diff --git a/kernel/sched.c b/kernel/sched.c
index 1e4596c..5641eb8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -596,6 +596,7 @@ enum {
 	SCHED_FEAT_START_DEBIT		= 4,
 	SCHED_FEAT_HRTICK		= 8,
 	SCHED_FEAT_DOUBLE_TICK		= 16,
+	SCHED_FEAT_SYNC_WAKEUPS		= 32,
 };
 
 const_debug unsigned int sysctl_sched_features =
@@ -603,7 +604,8 @@ const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
 		SCHED_FEAT_HRTICK		* 1 |
-		SCHED_FEAT_DOUBLE_TICK		* 0;
+		SCHED_FEAT_DOUBLE_TICK		* 0 |
+		SCHED_FEAT_SYNC_WAKEUPS         * 0;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
@@ -1902,6 +1904,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	long old_state;
 	struct rq *rq;
 
+	if (!sched_feat(SYNC_WAKEUPS))
+		sync = 0;
+
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;


