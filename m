Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZCZDr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZCZDr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZCZDrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:47:19 -0400
Received: from hq2.tensilica.com ([65.205.227.30]:18560 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbZCZDrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:47:18 -0400
Message-ID: <49CAFA83.1000005@tensilica.com>
Date: Wed, 25 Mar 2009 20:46:11 -0700
From: Piet Delaney <piet.delaney@tensilica.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-mm@kvack.org, Johannes Weiner <jw@emlix.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH} - There appears  to be a minor race condition in sched.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter:

There appears to be a minor race condition in sched.c where
you can get a division by zero. I suspect that it only shows
up when the kernel is compiled without optimization and the code
loads rq->nr_running from memory twice.

It's part of our SMP stabilization changes that I just posted to:

     git://git.kernel.org/pub/scm/linux/kernel/git/piet/xtensa-2.6.27-smp.git

I mentioned it to Johannes the other day and he suggested passing it on to you ASAP.

-------------------------------- Begin kernel/sched.c --------------------------------
index 9a1ddb8..607ee38 100644
@@ -1388,9 +1388,11 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
  static unsigned long cpu_avg_load_per_task(int cpu)
  {
         struct rq *rq = cpu_rq(cpu);
+       unsigned long nr_running = rq->nr_running;

-       if (rq->nr_running)
-               rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+        /* Local copy of nr_running used to avoid a possible div by zero */
+       if (nr_running)
+               rq->avg_load_per_task = rq->load.weight / nr_running;

         return rq->avg_load_per_task;
  }
-------------------------------- End kernel/sched.c --------------------------------

-piet

