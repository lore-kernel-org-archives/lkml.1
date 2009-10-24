Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZJXUGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZJXUGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 16:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZJXUGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 16:06:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:35622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZJXUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 16:06:34 -0400
Date: Sat, 24 Oct 2009 12:58:53 -0700
From: Arjan van de Ven <arjan@infradead.org> (by way of Arjan van de
	Ven <arjan@infradead.org>)
To: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu
Message-ID: <20091024125853.35143117@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/3] sched: Enable wake balancing for the SMT/HT domain
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Enable wake balancing for the SMT/HT domain
From: Arjan van de Ven <arjan@linux.intel.com>

Logical CPUs that are part of a hyperthreading/SMT set are equivalent
in terms of where to execute a task; after all they share pretty much
all resources including the L1 cache.

This means that if task A wakes up task B, we should really consider
all logical CPUs in the SMT/HT set to run task B, not just the CPU that
task A is running on; in case task A keeps running, task B now gets to 
execute with no latency. In the case where task A then immediately goes
to wait for a response from task B, nothing is lost due to the aforementioned
equivalency.

This patch turns on the "balance on wakup" and turns of "affine wakeups"
for the SMT/HT scheduler domain to get this lower latency behavior.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/include/linux/topology.h b/include/linux/topology.h
index fc0bf3e..3665dc2 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,8 +95,8 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
-				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_BALANCE_WAKE			\
+				| 0*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
