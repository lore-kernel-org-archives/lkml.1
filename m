Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbXLDFvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbXLDFvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 00:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXLDFvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 00:51:46 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:36877 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXLDFvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 00:51:45 -0500
Date: Tue, 4 Dec 2007 16:51:44 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Paul Mackerras <paulus@samba.org>, LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Frederik Himpe <fhimpe@telenet.be>,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH v2] Fix hardware IRQ time accounting problem.
Message-ID: <20071204055144.GR24243@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit fa13a5a1f25f671d084d8884be96fc48d9b68275 (sched: restore
deterministic CPU accounting on powerpc), unconditionally calls
update_process_tick() in system context.  In the deterministic accounting case
this is the correct thing to do.  However, in the non-deterministic accounting
case we need to not do this, and results in the time accounted as hardware irq
time being artificially elevated.

Also this patch collapses 2 consecutive '#ifdef CONFIG_VIRT_CPU_ACCOUNTING'
checks in time.h into one for neatness.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
The problem was seen and reported by Johannes Berg  and Frederik Himpe.
Paul, I think this is good for 2.6.24.

Changes since v1:
 - I noticed that the #define was explictly using "current" rather than
   the task passed in.  Using tsk is the right thing to do.
 - The whiteapce changes dirty-up the patch and are un-needed with the
   change above.

 arch/powerpc/kernel/process.c |    2 +-
 include/asm-powerpc/time.h    |    8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 41e13f4..b9d8837 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -350,7 +350,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	local_irq_save(flags);
 
 	account_system_vtime(current);
-	account_process_tick(current, 0);
+	account_process_vtime(current);
 	calculate_steal_time();
 
 	last = _switch(old_thread, new_thread);
diff --git a/include/asm-powerpc/time.h b/include/asm-powerpc/time.h
index 780f826..a7281e0 100644
--- a/include/asm-powerpc/time.h
+++ b/include/asm-powerpc/time.h
@@ -237,18 +237,14 @@ struct cpu_usage {
 
 DECLARE_PER_CPU(struct cpu_usage, cpu_usage_array);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_process_vtime(struct task_struct *tsk);
-#else
-#define account_process_vtime(tsk)		do { } while (0)
-#endif
-
 #if defined(CONFIG_VIRT_CPU_ACCOUNTING)
 extern void calculate_steal_time(void);
 extern void snapshot_timebases(void);
+#define account_process_vtime(tsk)		account_process_tick(tsk, 0);
 #else
 #define calculate_steal_time()			do { } while (0)
 #define snapshot_timebases()			do { } while (0)
+#define account_process_vtime(tsk)		do { } while (0)
 #endif
 
 extern void secondary_cpu_time_init(void);
-- 
1.5.3.6

