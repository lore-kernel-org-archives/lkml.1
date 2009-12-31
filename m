Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZLaObe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZLaObe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZLaObd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:31:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:57094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZLaObc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:31:32 -0500
Date: Thu, 31 Dec 2009 14:30:33 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
References: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Pass appropriate frame pointer to dump_trace()
Message-ID: <tip-48b5ba9cc98d676712da29d9931f1c88e5185ff2@git.kernel.org>
Git-Commit-ID: 48b5ba9cc98d676712da29d9931f1c88e5185ff2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48b5ba9cc98d676712da29d9931f1c88e5185ff2
Gitweb:     http://git.kernel.org/tip/48b5ba9cc98d676712da29d9931f1c88e5185ff2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Dec 2009 05:53:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Dec 2009 13:11:31 +0100

perf: Pass appropriate frame pointer to dump_trace()

Pass the frame pointer from the regs of the interrupted path
to dump_trace() while processing the stack trace.

Currently, dump_trace() takes the current bp and starts the
callchain from dump_trace() itself. This is wasteful because
we need to walk through the entire NMI/DEBUG stack before
retrieving the interrupted point.

We can fix that by just using the frame pointer from the
captured regs. It points exactly where we want to start.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c223b7e..d616c06 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2347,7 +2347,7 @@ perf_callchain_kernel(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
 	callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
 }
 
 /*
