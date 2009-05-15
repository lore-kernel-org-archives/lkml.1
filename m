Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZEOEH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZEOEH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZEOEHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:07:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZEOEHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:07:46 -0400
Message-Id: <20090515040746.458607391@goodmis.org>
References: <20090515040554.074680910@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 00:05:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] x86/stacktrace: return 0 instead of -1 for stack ops
Content-Disposition: inline; filename=0001-x86-stacktrace-return-0-instead-of-1-for-stack-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If we return -1 in the ops->stack for the stacktrace saving, we end up
breaking out of the loop if the stack we are tracing is in the exception
stack. This causes traces like:

          <idle>-0     [002] 34263.745825: raise_softirq_irqoff <-__blk_complete_request
          <idle>-0     [002] 34263.745826:
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0
 <= 0

By returning "0" instead, the irq stack is saved as well, and we see:

          <idle>-0     [003]   883.280992: raise_softirq_irqoff <-__hrtimer_star
t_range_ns
          <idle>-0     [003]   883.280992:
 <= hrtimer_start_range_ns
 <= tick_nohz_restart_sched_tick
 <= cpu_idle
 <= start_secondary
 <=
 <= 0
 <= 0

[ Impact: record stacks from interrupts ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/stacktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index f7bddc2..4aaf7e4 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -20,7 +20,7 @@ save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
 
 static int save_stack_stack(void *data, char *name)
 {
-	return -1;
+	return 0;
 }
 
 static void save_stack_address(void *data, unsigned long addr, int reliable)
-- 
1.6.2.4

-- 
