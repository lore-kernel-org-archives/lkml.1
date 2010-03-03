Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab0CCGzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:55:15 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50449 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0CCGzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:55:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M+xEWb89FVZJ0gaW59izSw2B1N3lo/T0jp76ZdK8kTBKbFDJ6cT5dag0i53mKUIh2v
         WW/6tWgzlaejmQnzBdJU18Lu7owqFYfEiRWdjr3UeIyBzJxh84SmJIeNrAtuW3S9kCal
         YSt3pBn+5IZS4x3g9nVy/bROqZCkalpjazJRg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf/x86-64: Use frame pointer to walk on irq and process stacks
Date: Wed,  3 Mar 2010 07:55:02 +0100
Message-Id: <1267599302-2886-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using the frame pointer based stack walker on every
contexts in x86-32, but not in x86-64 where we only use the
seven-league boots on the exception stacks.

Use it also on irq and process stacks. This utterly accelerate
the captures.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/dumpstack_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 676bc05..cab4f72 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -202,7 +202,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
 				if (ops->stack(data, "IRQ") < 0)
 					break;
-				bp = print_context_stack(tinfo, stack, bp,
+				bp = ops->walk_stack(tinfo, stack, bp,
 					ops, data, irq_stack_end, &graph);
 				/*
 				 * We link to the next stack (which would be
@@ -223,7 +223,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	/*
 	 * This handles the process stack:
 	 */
-	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL, &graph);
+	bp = ops->walk_stack(tinfo, stack, bp, ops, data, NULL, &graph);
 	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
-- 
1.6.2.3

