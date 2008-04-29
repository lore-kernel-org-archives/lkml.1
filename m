Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYD2Bc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYD2Bc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYD2BcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:32:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33474 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYD2BcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:32:18 -0400
Message-ID: <48167A7F.1010203@jp.fujitsu.com>
Date: Tue, 29 Apr 2008 10:31:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] stop_machine: add timeout for child thread deployment
References: <481678F5.7080504@jp.fujitsu.com>
In-Reply-To: <481678F5.7080504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If stopmachine() invoked while one of onlined cpu is locked up
by some reason, stopmachine cannot finish its work because the
locked cpu cannot stop.

This patch allows stopmachine to return -EBUSY if any of
kstopmachine's child threads cannot start running on its target
cpu.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/stop_machine.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

Index: GIT-torvalds/kernel/stop_machine.c
===================================================================
--- GIT-torvalds.orig/kernel/stop_machine.c	2008-04-29 00:29:20.000000000 +0900
+++ GIT-torvalds/kernel/stop_machine.c	2008-04-29 00:31:55.000000000 +0900
@@ -29,6 +29,9 @@
 static enum stopmachine_state stopmachine_state;
 static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
+static atomic_t stopmachine_busy_exit;
+
+static unsigned long stopmachine_timeout = 5; /* secs, arbitrary */
 
 static int stopmachine(void *cpu)
 {
@@ -42,6 +45,7 @@
 	if (stopmachine_state == STOPMACHINE_EXIT)
 		goto exit;
 
+	/* If target cpu is on fire, this call can stuck */
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we arrived */
@@ -83,6 +87,12 @@
 	if (prepared)
 		preempt_enable();
 
+	if (atomic_read(&stopmachine_busy_exit)) {
+		atomic_dec(&stopmachine_busy_exit);
+		printk(KERN_INFO "stopmachine: cpu#%d is not busy now.\n",
+			(int)(long)cpu);
+	}
+
 	return 0;
 }
 
@@ -99,6 +109,15 @@
 static int stop_machine(void)
 {
 	int i, ret = 0;
+	unsigned long limit;
+
+	if (atomic_read(&stopmachine_busy_exit)) {
+		/*
+		 * previous try was timeout, and still there is a unreachable
+		 * cpu and abandoned child.
+		 */
+		return -EBUSY;
+	}
 
 	atomic_set(&stopmachine_thread_ack, 0);
 	stopmachine_num_threads = 0;
@@ -113,10 +132,15 @@
 		stopmachine_num_threads++;
 	}
 
+	limit = jiffies + msecs_to_jiffies(stopmachine_timeout * MSEC_PER_SEC);
+
 	/* Wait for them all to come to life on the target. */
 	stopmachine_state = STOPMACHINE_DEPLOY;
 	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
-		yield();
+		if (time_is_after_jiffies(limit))
+			yield();
+		else
+			goto deploy_timeout;
 
 	/* Now they are all started, make them hold the CPUs, ready. */
 	preempt_disable();
@@ -129,6 +153,20 @@
 
 	return 0;
 
+deploy_timeout:
+	printk(KERN_CRIT "stopmachine: Failed to stop machine in time(%lds). "
+		"Are there any CPUs on file?\n", stopmachine_timeout);
+
+	/* defer exit check to the beginning of next try. */
+	atomic_set(&stopmachine_busy_exit, stopmachine_num_threads);
+
+	printk(KERN_INFO "stopmachine: cpu#%d is initiator of failed stop.\n",
+			raw_smp_processor_id());
+	smp_wmb();
+	stopmachine_state = STOPMACHINE_EXIT;
+
+	return -EBUSY;
+
 exit_threads:
 	/* Wait for them all to exit, since stop is canceled */
 	stopmachine_set_state(STOPMACHINE_EXIT);
