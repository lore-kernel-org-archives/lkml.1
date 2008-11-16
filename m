Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbYKPFAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbYKPFAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYKPFAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:00:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:35141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbYKPE77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ROau2neGJ5z9Jyf1KGN7290uYuxoPWpyI23wTKK45rFw24fDLiLs04S7Z7GMIlbXHe
         h278zPuzIkPfeCLx5uq0NN3K9Bm8N3VfWofi7hppxWBmG/y4vbU+nhuh//SoTdH1Wln0
         anQv2Z1n76HLvPcvDR2+fw+aDoEF6HCjFfxqg=
Message-ID: <491FA8C8.1040905@gmail.com>
Date: Sun, 16 Nov 2008 05:59:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on branch
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Make the branch tracer use raw irq save/restore

When the branch tracer inserts an event through probe_likely_condition(),
it calls local_irq_save() and then results in a trace recursion.

local_irq_save() -> trace_hardirqs_off() -> trace_hardirqs_off_caller()
	-> unlikely()

The trace_branch.c file is protected by DISABLE_BRANCH_PROFILING but that
doesn't prevent from external call to functions that use unlikely().

My box crashed each time I tried to set this tracer (sudden and hard reboot).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_branch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 44bd395..23f9b02 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -41,7 +41,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	if (unlikely(!tr))
 		return;
 
-	local_irq_save(flags);
+	raw_local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
 		goto out;
@@ -73,7 +73,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
-	local_irq_restore(flags);
+	raw_local_irq_restore(flags);
 }
 
 static inline
-- 
1.5.2.5
