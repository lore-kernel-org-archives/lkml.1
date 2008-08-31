Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYHaSq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYHaSq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYHaSqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:46:18 -0400
Received: from sing.entic.net ([208.64.63.147]:36464 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYHaSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:46:18 -0400
X-Greylist: delayed 2171 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2008 14:46:18 EDT
Message-Id: <200808311809.m7VI9whf014532@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org
Date: Sun, 31 Aug 2008 19:58:49 +0200
Subject: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpu is taken offline, the CPU_DYING notifiers are called on the
dying cpu. According to <linux/notifiers.h>, the cpu should be "not
running any task, not handling interrupts, soon dead".

For the current implementation, this is not true:
- __cpu_disable can fail. If it fails, then the cpu will remain alive
  and happy.
- At least on x86, __cpu_disable() briefly enables the local interrupts
  to handle any outstanding interrupts.

What about moving CPU_DYING down a few lines, behind the __cpu_disable()
line?
There are only two CPU_DYING handlers in the kernel right now: one in
kvm, one in the scheduler. Both should work with the patch applied
[and: I'm not sure if either one handles a failing __cpu_disable()]

The patch survives simple offlining a cpu. kvm untested due to lack
of a test setup.

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
---
 kernel/cpu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e202a68..5b7c88f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -199,13 +199,14 @@ static int __ref take_cpu_down(void *_param)
 	struct take_cpu_down_param *param = _param;
 	int err;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
 		return err;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
+
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
-- 
1.5.5.1

