Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYA1EeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYA1EeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYA1Eda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:30 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYA1Ed2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:28 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"
Date: Sun, 27 Jan 2008 20:09:42 -0800
Message-Id: <1201493382-29804-6-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201493382-29804-5-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-3-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-4-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-5-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

This patch is trying to address the same use case I explained in the previous workqueue
isolation patch. Which is when a high priority realtime (FIFO, RR) user-space thread
is using 100% CPU for extended periods of time. In which case stopmachine threads do not
get a chance to run and entire machine essentially hangs because other CPUs are waiting
for the all stopmachine threads to run.
This use case is perfectly valid if one is using a CPU as a dedicated engine
(crunching numbers, hard realtime, etc). Think of it as an SPE in the Cell processor.
Which is what CPU isolation enables in first place.

Stopmachine is particularly bad when it comes to latencies. It's currently used for
module insertion and removal only. Given that threads running on the isolated CPUs
are unlikely to use kernel services anyway I'd consider this patch pretty safe.

The patch adds no overhead and/or side effects when CPU isolation is disabled.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/stop_machine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 51b5ee5..0f4cc3f 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -99,7 +99,7 @@ static int stop_machine(void)
 	stopmachine_state = STOPMACHINE_WAIT;
 
 	for_each_online_cpu(i) {
-		if (i == raw_smp_processor_id())
+		if (i == raw_smp_processor_id() || cpu_isolated(i))
 			continue;
 		ret = kernel_thread(stopmachine, (void *)(long)i,CLONE_KERNEL);
 		if (ret < 0)
-- 
1.5.3.7

