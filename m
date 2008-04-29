Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYD2B3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYD2B3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYD2B3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:29:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43562 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYD2B3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:29:42 -0400
Message-ID: <481679F1.7010108@jp.fujitsu.com>
Date: Tue, 29 Apr 2008 10:29:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] stop_machine: short exit path for if we cannot create
 enough threads
References: <481678F5.7080504@jp.fujitsu.com>
In-Reply-To: <481678F5.7080504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stop_machine_run() invokes kthread 'kstopmachine' and the kthread
creates its children for every other cpus.

The current implementation migrates the child thread to its target
cpu as soon as it is created.  It means that the children always
bother some of other cpus even if we cannot create enough threads.

This patch enable us to skip the migration of children if we
cannot have enough threads.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/stop_machine.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 0101aee..5331ee5 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -20,6 +20,7 @@
 /* Thread to stop each CPU in user context. */
 enum stopmachine_state {
 	STOPMACHINE_WAIT,
+	STOPMACHINE_DEPLOY,
 	STOPMACHINE_PREPARE,
 	STOPMACHINE_DISABLE_IRQ,
 	STOPMACHINE_EXIT,
@@ -34,9 +35,16 @@ static int stopmachine(void *cpu)
 	int irqs_disabled = 0;
 	int prepared = 0;
 
+	/* Wait sisters */
+	while (stopmachine_state == STOPMACHINE_WAIT)
+		yield();
+	/* short path for cancel */
+	if (stopmachine_state == STOPMACHINE_EXIT)
+		goto exit;
+
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
-	/* Ack: we are alive */
+	/* Ack: we arrived */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
 	atomic_inc(&stopmachine_thread_ack);
 
@@ -65,7 +73,7 @@ static int stopmachine(void *cpu)
 		else
 			cpu_relax();
 	}
-
+exit:
 	/* Ack: we are exiting. */
 	smp_mb(); /* Must read state first. */
 	atomic_inc(&stopmachine_thread_ack);
@@ -101,20 +109,15 @@ static int stop_machine(void)
 			continue;
 		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
 		if (ret < 0)
-			break;
+			goto exit_threads;
 		stopmachine_num_threads++;
 	}
 
-	/* Wait for them all to come to life. */
+	/* Wait for them all to come to life on the target. */
+	stopmachine_state = STOPMACHINE_DEPLOY;
 	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
 		yield();
 
-	/* If some failed, kill them all. */
-	if (ret < 0) {
-		stopmachine_set_state(STOPMACHINE_EXIT);
-		return ret;
-	}
-
 	/* Now they are all started, make them hold the CPUs, ready. */
 	preempt_disable();
 	stopmachine_set_state(STOPMACHINE_PREPARE);
@@ -125,6 +128,12 @@ static int stop_machine(void)
 	stopmachine_set_state(STOPMACHINE_DISABLE_IRQ);
 
 	return 0;
+
+exit_threads:
+	/* Wait for them all to exit, since stop is canceled */
+	stopmachine_set_state(STOPMACHINE_EXIT);
+
+	return ret;
 }
 
 static void restart_machine(void)

