Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZKVEV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZKVEV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZKVEVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:21:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42536 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbZKVEVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TVADiZQl3EMtQxCGzOcL9nluCMvpcqekXQhG3BBsg3xOGsiUpLr36uD9XcaWmHFMdq
         FhL54jHvFiicD3syvxSC/fprOOt3VJwznS7xuxab5MuHk/GdVmhr0lZnw3bUhSK8ZrMX
         kRYgwIH8lKfsl0C7RuJN2zEQwBJbdeuB8y15g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/4] tracing: Forget about the nmi buffer from syscall events
Date: Sun, 22 Nov 2009 05:21:33 +0100
Message-Id: <1258863695-10464-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
References: <1258863695-10464-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are never in an nmi context when we commit a syscall trace to
perf. So just forget about the nmi buffer there.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
---
 kernel/trace/trace_syscalls.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 0bb9348..41b6dd9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -511,10 +511,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 
 	cpu = smp_processor_id();
 
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+	trace_buf = rcu_dereference(perf_trace_buf);
 
 	if (!trace_buf)
 		goto end;
@@ -617,10 +614,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 
 	cpu = smp_processor_id();
 
-	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
-	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+	trace_buf = rcu_dereference(perf_trace_buf);
 
 	if (!trace_buf)
 		goto end;
-- 
1.6.2.3

