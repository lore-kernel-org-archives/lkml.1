Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYGPD4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYGPD4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYGPD4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:56:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6304 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYGPD4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:56:44 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4747612"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Max Krasnyansky <maxk@qualcomm.com>, dmitry.adamushko@gmail.com,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, vegard.nossum@gmail.com
Subject: [PATCH] cpu hotplug: Make cpu_active_map synchronization dependency clear
Date: Tue, 15 Jul 2008 20:56:26 -0700
Message-Id: <1216180586-8313-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This goes on top of the cpu_active_map (take 2) patch.

Currently we depend on the stop_machine to provide nescessesary
synchronization for the cpu_active_map updates.
As Dmitry Adamushko pointed this is fragile and is not much clearer
than the previous scheme. In other words we do not want to depend on
the internal stop machine operation here.
So make the synchronization rules clear by doing synchronize_sched()
after clearing out cpu active bit.

Tested on quad-Core2 with:

   while true; do
      for i in 1 2 3; do
        echo 0 > /sys/devices/system/cpu/cpu$i/online
      done
      for i in 1 2 3; do
        echo 1 > /sys/devices/system/cpu/cpu$i/online
      done
   done
and
   stress -c 200

No lockdep, preempt or other complaints.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: dmitry.adamushko@gmail.com
Cc: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu
Cc: rostedt@goodmis.org
Cc: vegard.nossum@gmail.com
---
 kernel/cpu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 71c5c9d..541f78e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -301,6 +301,14 @@ int __ref cpu_down(unsigned int cpu)
 
 	cpu_clear(cpu, cpu_active_map);
 
+	/* Make sure the all cpus did the reschedule and are not
+	 * using stale version of the cpu_active_map.
+	 * This is not strictly necessary becuase stop_machine() 
+	 * that we run down the line already provides the required 
+	 * synchronization. But it's really a side effect and we do not 
+	 * want to depend on the innards of the stop_machine here. */
+	synchronize_sched();
+
 	err = _cpu_down(cpu, 0);
 
 	if (cpu_online(cpu))
-- 
1.5.5.1

