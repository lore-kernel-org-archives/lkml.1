Return-Path: <linux-kernel-owner+w=401wt.eu-S935892AbZAPO02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892AbZAPO02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935924AbZAPOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:23:39 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:39691 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935877AbZAPOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:23:37 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 09:23:36 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jd9K1b0nTMDUMs2gRfl8RcGLHvXnj1ZpieK2zDrCC0vVqShwoLgGjainL+NQE7Oom0
         2IBi6aHKCh+qC9jfnZgvRuIzCELqGBtkO1Qt4zqE+CrDlMxGaZW8276rrublRba6A8bt
         zHE6DJeaYOGCJyB0foO+j4CoRQbKqsxuo6ssM=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 04/17] x86-64: Convert exception stacks to per-cpu
Date: Fri, 16 Jan 2009 09:16:23 -0500
Message-Id: <1232115396-26367-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-3-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the exception stacks to per-cpu, removing specific allocation code.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/cpu/common.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5ddbca0..70ce998 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -908,8 +908,9 @@ void __cpuinit pda_init(int cpu)
 	}
 }
 
-static char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-				  DEBUG_STKSZ] __page_aligned_bss;
+static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
+	__aligned(PAGE_SIZE);
 
 extern asmlinkage void ignore_sysret(void);
 
@@ -967,15 +968,12 @@ void __cpuinit cpu_init(void)
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
 
@@ -1009,18 +1007,13 @@ void __cpuinit cpu_init(void)
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
1.6.1.rc1

