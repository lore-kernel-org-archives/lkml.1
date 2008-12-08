Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYLHP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYLHP5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYLHP5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:57:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYLHP5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:57:42 -0500
Date: Mon, 8 Dec 2008 16:57:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-graph-tracer: fix 'flags' variable
	mismatch
Message-ID: <20081208155730.GC405@elte.hu>
References: <4939E600.804@gmail.com> <20081208141406.GA14856@elte.hu> <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812080725i1f144c21td5b121749f507b09@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., had a new compiler warning below.

	Ingo

--------------->
>From e726f5f91effd8944c76475a2688093a03ba0d10 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Dec 2008 16:55:53 +0100
Subject: [PATCH] tracing/function-graph-tracer: fix 'flags' variable mismatch
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

this warning:

 kernel/trace/trace.c: In function ‘trace_vprintk’:
 kernel/trace/trace.c:3626: warning: ‘flags’ may be used uninitialized in this function

shows some confusion about irq_flags / flags use here. We already have
irq_flags so remove the extra flags variable.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0b8659b..8ebe007 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3596,9 +3596,9 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	struct print_entry *entry;
-	unsigned long flags, irq_flags;
 	int cpu, len = 0, size, pc;
+	struct print_entry *entry;
+	unsigned long irq_flags;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
@@ -3623,7 +3623,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags, pc);
+	tracing_generic_entry_update(&entry->ent, irq_flags, pc);
 	entry->ent.type			= TRACE_PRINT;
 	entry->ip			= ip;
 	entry->depth			= depth;
