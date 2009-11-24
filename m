Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbZKXUil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbZKXUil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932646AbZKXUik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:38:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:33174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbZKXUij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:38:39 -0500
Date: Tue, 24 Nov 2009 20:36:39 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       peterz@infradead.org, arjan@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       arjan@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
References: <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix bad software/trace event recursion counting
Message-ID: <tip-fe6126722718e51fba4879517c11ac12d9775bcc@git.kernel.org>
Git-Commit-ID: fe6126722718e51fba4879517c11ac12d9775bcc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe6126722718e51fba4879517c11ac12d9775bcc
Gitweb:     http://git.kernel.org/tip/fe6126722718e51fba4879517c11ac12d9775bcc
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 24 Nov 2009 20:38:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 21:34:00 +0100

perf_events: Fix bad software/trace event recursion counting

Commit 4ed7c92d68a5387ba5f7030dc76eab03558e27f5
(perf_events: Undo some recursion damage) has introduced a bad
reference counting of the recursion context. putting the context
behaves like getting it, dropping every software/trace events
after the first one in a context.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index accfd7b..35df94e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3914,7 +3914,7 @@ void perf_swevent_put_recursion_context(int rctx)
 {
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	barrier();
-	cpuctx->recursion[rctx]++;
+	cpuctx->recursion[rctx]--;
 	put_cpu_var(perf_cpu_context);
 }
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
