Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYDVDcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYDVDcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYDVDcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:32:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52686
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbYDVDcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:32:11 -0400
Date: Mon, 21 Apr 2008 20:32:12 -0700 (PDT)
Message-Id: <20080421.203212.262634448.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: sched tree bisectability
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While trying to bisect a regression added by the sched tree merges
today, I found the following gem that broke compilation mid-bisect:

commit d0b27fa77854b149ad4af08b0fe47fe712a47ade
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:44:57 2008 +0200

    sched: rt-group: synchonised bandwidth period
    
    Various SMP balancing algorithms require that the bandwidth period
    run in sync.
    
    Possible improvements are moving the rt_bandwidth thing into root_domain
    and keeping a span per rt_bandwidth which marks throttled cpus.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


That change adds:

@@ -156,6 +161,80 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
+struct rt_bandwidth {
+	ktime_t rt_period;
+	u64 rt_runtime;
+	struct hrtimer rt_period_timer;
+};
+

and then things like:

+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	ktime_t now;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	if (hrtimer_active(&rt_b->rt_period_timer))
+		return;
+
+	spin_lock(&rt_b->rt_runtime_lock);

rt_bandwidth does not have a rt_runtime_lock member, so the compile
fails.  The very next changeset adds it:

commit ac086bc22997a2be24fc40fc8d46522fe7e03d11
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:44:58 2008 +0200

    sched: rt-group: smp balancing
    
    Currently the rt group scheduling does a per cpu runtime limit, however
    the rt load balancer makes no guarantees about an equal spread of real-
    time tasks, just that at any one time, the highest priority tasks run.
    
    Solve this by making the runtime limit a global property by borrowing
    excessive runtime from the other cpus once the local limit runs out.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index bb20323..313cd4f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -164,6 +164,7 @@ struct rt_prio_array {
 struct rt_bandwidth {
 	ktime_t rt_period;
 	u64 rt_runtime;
+	spinlock_t rt_runtime_lock;
 	struct hrtimer rt_period_timer;
 };
 
