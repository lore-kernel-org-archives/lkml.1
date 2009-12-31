Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZLaExJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZLaExJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 23:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZLaExI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 23:53:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44139 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZLaExH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 23:53:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iDpeZC0gt+6DigQbPbKyIV66f24zgsPDq4JR8auMC2CtbooMMKDlapV/qd79Xr51c/
         RybeAIx2naSKXvsVv0GRL5Fbr2BtjDzq0jsGnqW8vcrSBNiy0nBCYscA+dDgyve6YBjT
         NA/diqt+4cnUo/R3qMi5darkdejYTqAr8dGUA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf: Pass appropriate frame pointer to dump_trace()
Date: Thu, 31 Dec 2009 05:53:02 +0100
Message-Id: <1262235183-5320-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the frame pointer from the regs of the interrupted path
to dump_trace() while processing the stack trace.

Currently, dump_trace() takes the current bp and starts the
callchain from dump_trace() itself. This is wasteful because
we need to walk through the entire NMI/DEBUG stack before
retrieving the interrupted point.

We can fix that by just using the frame pointer from the captured
regs. It points exactly where we want to start.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.2.3

