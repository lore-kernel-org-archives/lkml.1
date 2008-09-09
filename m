Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIID2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIID2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYIID2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:28:36 -0400
Received: from mga05.intel.com ([192.55.52.89]:64427 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbYIID2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,362,1217833200"; 
   d="scan'208";a="378161653"
Subject: [BUG] 2.6.27-rc5 couldn't boot on tulsa machine randomly
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Sep 2008 11:26:33 +0800
Message-Id: <1220930793.25574.20.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my tulsa x86-64 machine, kernel 2.6.25-rc5 couldn't boot randomly.

Basically, function __enable_runtime forgets to reset  rt_rq->rt_throttled to 0.
When every cpu is up, per-cpu migration_thread is created and it runs very fast,
sometimes to mark the corresponding rt_rq->rt_throttled to 1 very quickly. After
all cpus are up, with below calling chain,
sched_init_smp => arch_init_sched_domains => build_sched_domains => ...
=> cpu_attach_domain => rq_attach_root => set_rq_online => ... => ﻿__enable_runtime,
﻿__enable_runtime is called against every rt_rq again, so rt_rq->rt_time is reset to
0, but ﻿rt_rq->rt_throttled might be still 1. Later on function do_sched_rt_period_timer
couldn't reset it, and all RT tasks couldn't be scheduled to run on that cpu.
here is RT task migration_thread which is woken up when a task is migrated to another cpu.

Below patch fixes it against 2.6.27-rc5.

﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.27-rc5/kernel/sched_rt.c linux-2.6.27-rc5_fix/kernel/sched_rt.c
--- linux-2.6.27-rc5/kernel/sched_rt.c	2008-09-09 11:06:43.000000000 +0800
+++ linux-2.6.27-rc5_fix/kernel/sched_rt.c	2008-09-09 11:13:04.000000000 +0800
@@ -350,6 +350,7 @@ static void __enable_runtime(struct rq *
 		spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_b->rt_runtime;
 		rt_rq->rt_time = 0;
+		rt_rq->rt_throttled = 0;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
 	}


