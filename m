Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZKXTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZKXTqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbZKXTqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 14:46:39 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:33511 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058AbZKXTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 14:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mEnWlMaINsdiLPja8BFutkStWrQgkF+Xfjw+YhuMCv1JUb7yMBXGhs9JQMBK8hUA7p
         VPY3YLSINXaDr4Ra32jIRCieRWmJ0yE2+oQmUJGSQwzYLoK4V9Y6SsEfWv/hB135Tc29
         oXfsracm09a6Zh4tiEBEqWZB2l8k7jVSFancg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Arjan van de Ven <arjan@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf: Fix bad software/trace event recursion counting
Date: Tue, 24 Nov 2009 20:38:22 +0100
Message-Id: <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091124100724.GA5570@elte.hu>
References: <20091124100724.GA5570@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.6.2.3

