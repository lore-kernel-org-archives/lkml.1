Return-Path: <linux-kernel-owner+w=401wt.eu-S1751191Ab0AMKbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab0AMKbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589Ab0AMKa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:30:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:58934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0AMKa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:30:58 -0500
Date: Wed, 13 Jan 2010 10:30:19 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262227945-27014-1-git-send-regression-fweisbec@gmail.com>
References: <1262227945-27014-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Stop stack frame walking off kernel addresses boundaries
Message-ID: <tip-c2c5d45d46c8c0fd34291dec958670ad4816796f@git.kernel.org>
Git-Commit-ID: c2c5d45d46c8c0fd34291dec958670ad4816796f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:30:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2c5d45d46c8c0fd34291dec958670ad4816796f
Gitweb:     http://git.kernel.org/tip/c2c5d45d46c8c0fd34291dec958670ad4816796f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Dec 2009 03:52:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:32:54 +0100

perf: Stop stack frame walking off kernel addresses boundaries

While processing kernel perf callchains, an bad entry can be
considered as a valid stack pointer but not as a kernel address.

In this case, we hang in an endless loop. This can happen in an
x86-32 kernel after processing the last entry in a kernel
stacktrace.

Just stop the stack frame walking after we encounter an invalid
kernel address.

This fixes a hard lockup in x86-32.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1262227945-27014-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c56bc28..6d81755 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -123,13 +123,15 @@ print_context_stack_bp(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
 		unsigned long addr = *ret_addr;
 
-		if (__kernel_text_address(addr)) {
-			ops->address(data, addr, 1);
-			frame = frame->next_frame;
-			ret_addr = &frame->return_address;
-			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
-		}
+		if (!__kernel_text_address(addr))
+			break;
+
+		ops->address(data, addr, 1);
+		frame = frame->next_frame;
+		ret_addr = &frame->return_address;
+		print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 	}
+
 	return (unsigned long)frame;
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
