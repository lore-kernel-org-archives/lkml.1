Return-Path: <linux-kernel-owner+w=401wt.eu-S938503AbXGUO7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938503AbXGUO7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761771AbXGUO5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:57:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:45571 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbXGUO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:57:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/4] [TIME] Simplify smp_call_function_single() call sequence
Date: Sat, 21 Jul 2007 17:57:57 +0300
Message-Id: <1185029878966-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11850298772540-git-send-email-avi@qumranet.com>
References: <11850298772540-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single() now knows how to call the function on the
current cpu.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 kernel/time/tick-broadcast.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 8001d37..fe36b9a 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -241,21 +241,12 @@ out:
  */
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
-	int cpu = get_cpu();
-
-	if (!cpu_isset(*oncpu, cpu_online_map)) {
+	if (!cpu_isset(*oncpu, cpu_online_map))
 		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
-	} else {
-
-		if (cpu == *oncpu)
-			tick_do_broadcast_on_off(&reason);
-		else
-			smp_call_function_single(*oncpu,
-						 tick_do_broadcast_on_off,
-						 &reason, 1, 1);
-	}
-	put_cpu();
+	else
+		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
+					 &reason, 1, 1);
 }
 
 /*
-- 
1.5.2.4

