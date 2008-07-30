Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYG3K2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYG3K2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYG3K17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:27:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYG3K17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:27:59 -0400
Subject: [RFT][PATCH] sched: scale sysctl_sched_shares_ratelimit with
	nr_cpus
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>, vatsa <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 12:27:55 +0200
Message-Id: <1217413675.8157.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[And now with proper lkml address - so much for auto-add address entries]

Dhaval, Vatsa,

Could you guys give this patch a spin on the big iron and possibly tune
the default shares_ratelimit value to give satisfactory fairness on your
large machines while considering the overhead?


---
Subject: sched: scale sysctl_sched_shares_ratelimit with nr_cpus

David reported that his Niagra spend a little too much time in
tg_shares_up(), which considering he has a large cpu count makes sense.

So scale the ratelimit value with the number of cpus like we do for
other controls as well.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -809,9 +809,9 @@ const_debug unsigned int sysctl_sched_nr
 
 /*
  * ratelimit for updating the group shares.
- * default: 0.5ms
+ * default: 0.25ms
  */
-const_debug unsigned int sysctl_sched_shares_ratelimit = 500000;
+const_debug unsigned int sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * period over which we measure -rt task cpu usage in us.
@@ -5732,6 +5732,8 @@ static inline void sched_init_granularit
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
+
+	sysctl_sched_shares_ratelimit *= factor;
 }
 
 #ifdef CONFIG_SMP


