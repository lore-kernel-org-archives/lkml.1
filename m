Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0BLWhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:37:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:44169 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0BLWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 28/28] debug_core: Turn off tracing while in the debugger
Date: Fri, 12 Feb 2010 16:35:43 -0600
Message-Id: <1266014143-29444-29-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:28.0504 (UTC) FILETIME=[D11BA580:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger should turn off kernel tracing any time the
debugger is active and restore it on resume.

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 580fc3b..f7ebb7f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -474,6 +474,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 	int sstep_tries = 100;
 	int error;
 	int i, cpu;
+	int trace_on = 0;
 acquirelock:
 	/*
 	 * Interrupts will be restored by the 'trap return' code, except when
@@ -518,6 +519,8 @@ return_normal:
 			 */
 			if (arch_kgdb_ops.correct_hw_break)
 				arch_kgdb_ops.correct_hw_break();
+			if (trace_on)
+				tracing_on();
 			atomic_set(&cpu_in_kgdb[cpu], 0);
 			touch_softlockup_watchdog_sync();
 			clocksource_touch_watchdog();
@@ -592,6 +595,9 @@ return_normal:
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
 	exception_level = 0;
+	trace_on = tracing_is_on();
+	if (trace_on)
+		tracing_off();
 
 	while (1) {
 cpu_master_loop:
@@ -645,6 +651,8 @@ kgdb_restore:
 		else
 			kgdb_sstep_pid = 0;
 	}
+	if (trace_on)
+		tracing_on();
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
 	touch_softlockup_watchdog_sync();
-- 
1.6.4.rc1

