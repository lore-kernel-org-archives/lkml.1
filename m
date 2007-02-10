Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbXBJMAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbXBJMAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBJLvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:50278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400AbXBJLuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:44 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Catalin Marinas <catalin.marinas@arm.com>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [24/25] x86_64: do not always end the stack trace with ULONG_MAX
Message-Id: <20070210115037.9683913DD5@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Catalin Marinas <catalin.marinas@arm.com>

It makes more sense to end the stack trace with ULONG_MAX only if
nr_entries < max_entries.  Otherwise, we lose one entry in the long stack
traces and cannot know whether the trace was complete or not.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/stacktrace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/stacktrace.c
===================================================================
--- linux.orig/arch/x86_64/kernel/stacktrace.c
+++ linux/arch/x86_64/kernel/stacktrace.c
@@ -32,7 +32,7 @@ static void save_stack_address(void *dat
 		trace->skip--;
 		return;
 	}
-	if (trace->nr_entries < trace->max_entries - 1)
+	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = addr;
 }
 
@@ -49,7 +49,8 @@ static struct stacktrace_ops save_stack_
 void save_stack_trace(struct stack_trace *trace, struct task_struct *task)
 {
 	dump_trace(task, NULL, NULL, &save_stack_ops, trace);
-	trace->entries[trace->nr_entries++] = ULONG_MAX;
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL(save_stack_trace);
 
