Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbZARQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbZARQjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbZARQjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:55181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZARQjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:32 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] x86-64: Convert exception stacks to per-cpu
Date: Mon, 19 Jan 2009 01:39:11 +0900
Message-Id: <1232296759-2253-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Move the exception stacks to per-cpu, removing specific allocation code.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/cpu/common.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 496f0a0..b6d7eec 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -913,8 +913,9 @@ void __cpuinit pda_init(int cpu)
 	}
 }
 
-static char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-				  DEBUG_STKSZ] __page_aligned_bss;
+static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
+	__aligned(PAGE_SIZE);
 
 extern asmlinkage void ignore_sysret(void);
 
@@ -972,15 +973,12 @@ void __cpuinit cpu_init(void)
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct orig_ist *orig_ist = &per_cpu(orig_ist, cpu);
 	unsigned long v;
-	char *estacks = NULL;
 	struct task_struct *me;
 	int i;
 
 	/* CPU 0 is initialised in head64.c */
 	if (cpu != 0)
 		pda_init(cpu);
-	else
-		estacks = boot_exception_stacks;
 
 	me = current;
 
@@ -1014,18 +1012,13 @@ void __cpuinit cpu_init(void)
 	 * set up and load the per-CPU TSS
 	 */
 	if (!orig_ist->ist[0]) {
-		static const unsigned int order[N_EXCEPTION_STACKS] = {
-		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STACK_ORDER,
-		  [DEBUG_STACK - 1] = DEBUG_STACK_ORDER
+		static const unsigned int sizes[N_EXCEPTION_STACKS] = {
+		  [0 ... N_EXCEPTION_STACKS - 1] = EXCEPTION_STKSZ,
+		  [DEBUG_STACK - 1] = DEBUG_STKSZ
 		};
+		char *estacks = per_cpu(exception_stacks, cpu);
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
-			if (cpu) {
-				estacks = (char *)__get_free_pages(GFP_ATOMIC, order[v]);
-				if (!estacks)
-					panic("Cannot allocate exception "
-					      "stack %ld %d\n", v, cpu);
-			}
-			estacks += PAGE_SIZE << order[v];
+			estacks += sizes[v];
 			orig_ist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
 		}
-- 
1.6.0.2

