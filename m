Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYGLDRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYGLDRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYGLDRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:17:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:10783 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYGLDRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=Jh8cyoFByBLm2IH4BCY9U7fn/fHwgODszpPmzYrJqyBTxxTuJjQAASkBe6lnmQolq6
         YKeSE3J/He10AwEAKWwf1kdQkqtldkkztya1hpHTtKYsWw5uLKFlNpJdZdV5AEr8+ULn
         v0BXNqvDET14qQj7ERHCHD2uPLEvof0/hd5ww=
Date: Sat, 12 Jul 2008 05:17:37 +0200
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080712031736.GA3040@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807111603m45b65f73q90399891fb8795f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the patch below help?

Yes, it does! Well done!

(It needed a couple of minor syntax fixes, so I'm attaching the final
patch as well.)

Can somebody else please test/ack/review it too? This should eventually
go into 2.6.26 if it doesn't break anything else.


Vegard


>From da802021c32be4020ec810f04b56d3654a8d4766 Mon Sep 17 00:00:00 2001
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date: Sat, 12 Jul 2008 05:01:55 +0200
Subject: [PATCH] cpuset: fix cpu hotplug

This patch fixes a "kernel BUG at kernel/sched.c:5859!"
when cpu hotplug is used with CONFIG_CPUSETS=y.

[ Fixed invalid syntax ]
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/cpuset.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..860a190 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1912,11 +1912,22 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
 				unsigned long phase, void *unused_cpu)
 {
-	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+	switch (phase) {
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		common_cpu_mem_hotplug_unplug();
+		break;
+	default:
 		return NOTIFY_DONE;
+	}
 
-	common_cpu_mem_hotplug_unplug();
-	return 0;
+	return NOTIFY_OK;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-- 
1.5.4.1

