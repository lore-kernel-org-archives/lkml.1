Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965696Ab0BZS0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:26:46 -0500
Received: from mga05.intel.com ([192.55.52.89]:8269 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965631Ab0BZS0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:26:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,547,1262592000"; 
   d="scan'208";a="776262410"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86: remove redundant stack canary initialization
Date: Fri, 26 Feb 2010 04:19:28 -0800
Message-Id: <1267186768-2067-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we moved boot_init_stack_canary to the secondary CPU start code, there is
no need to do this again in cpu_idle(). Stack canary are initialized earlier than
cpu_idle() for both boot and secondary CPUs.

This is suggested by Thomas Gleixner in http://lkml.org/lkml/2010/2/20/14

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/process_32.c |   10 ----------
 arch/x86/kernel/process_64.c |   10 ----------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 37ad1e0..6dae5bf 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,7 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -85,15 +84,6 @@ void cpu_idle(void)
 {
 	int cpu = smp_processor_id();
 
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
 	current_thread_info()->status |= TS_POLLING;
 
 	/* endless idle loop with no priority at all */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 41a26a8..68ecec1 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,7 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -110,15 +109,6 @@ void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
-- 
1.5.6.5

