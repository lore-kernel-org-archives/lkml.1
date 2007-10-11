Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbXJKWOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbXJKWOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbXJKWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:21 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45352
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757732AbXJKWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:20 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/7] RT: Only consider online CPUs when pushing rt tasks
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 17:59:59 -0400
Message-ID: <20071011215959.27097.71140.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

task->cpus_allowed can have bit positions that are set for CPUs that are
not currently online.  So we optimze our search by ANDing against the online
set.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 24b38b4..0ca3905 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1510,10 +1510,14 @@ static int push_rt_task(struct rq *this_rq)
 
 	/* Only try this algorithm three times */
 	for (tries = 0; tries < 3; tries++) {
+		cpumask_t mask;
+
+		cpus_and(mask, cpu_online_map, next_task->cpus_allowed);
+
 		/*
 		 * Scan each rq for the lowest prio.
 		 */
-		for_each_cpu_mask(cpu, next_task->cpus_allowed) {
+		for_each_cpu_mask(cpu, mask) {
 			struct rq *rq = &per_cpu(runqueues, cpu);
 
 			if (cpu == smp_processor_id())

