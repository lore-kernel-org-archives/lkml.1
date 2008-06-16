Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYFPKed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYFPKed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYFPKeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:34:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYFPKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:34:25 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups and RT scheduling
	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <485445AE.2010602@uw.no>
References: <485445AE.2010602@uw.no>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 12:34:07 +0200
Message-Id: <1213612447.16944.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 00:26 +0200, Daniel K. wrote:
> I get the following on the latest Linus git tree.
> 
> Testcase:
> 
> mkdir /dev/cgroup
> mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup
> 
> mkdir -p /dev/cgroup/burn/oops
> cd /dev/cgroup/burn
> 
> echo 3 > cpuset.cpus
> echo 0 > cpuset.mems
> echo 1000000 > cpu.rt_period_us
> echo 940000  > cpu.rt_runtime_us
> 
> echo 3 > oops/cpuset.cpus
> echo 0 > oops/cpuset.mems
> echo 100000 > oops/cpu.rt_period_us
> echo 4000 > oops/cpu.rt_runtime_us
> 
> echo $$ > oops/tasks
> schedtool -R -p 1 -e burnP6
> 
> And then it breaks into the pieces below, as captured by netconsole.

Excellent report, thanks!


Does the below work for you?


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7784,7 +7784,6 @@ static void init_tg_rt_entry(struct task
 	else
 		rt_se->rt_rq = parent->my_q;
 
-	rt_se->rt_rq = &rq->rt;
 	rt_se->my_q = rt_rq;
 	rt_se->parent = parent;
 	INIT_LIST_HEAD(&rt_se->run_list);

