Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbZJOIub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbZJOIub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934976AbZJOIu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:50:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:33766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935000AbZJOIu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:50:26 -0400
Date: Thu, 15 Oct 2009 08:49:25 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, srostedt@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091014194358.637991808@goodmis.org>
References: <20091014194358.637991808@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle newlines in trace parsing better
Message-ID: <tip-f1d1feecf07261d083859ecfef0d4399036f9683@git.kernel.org>
Git-Commit-ID: f1d1feecf07261d083859ecfef0d4399036f9683
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:49:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1d1feecf07261d083859ecfef0d4399036f9683
Gitweb:     http://git.kernel.org/tip/f1d1feecf07261d083859ecfef0d4399036f9683
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 14 Oct 2009 15:43:37 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 10:42:37 +0200

perf tools: Handle newlines in trace parsing better

New lines between args in the trace format can break the
parsing. This should not be the case.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091014194358.637991808@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-parse.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f73ee55..59e4e4d 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1716,12 +1716,18 @@ process_arg_token(struct event *event, struct print_arg *arg,
 
 static int event_read_print_args(struct event *event, struct print_arg **list)
 {
-	enum event_type type;
+	enum event_type type = EVENT_ERROR;
 	struct print_arg *arg;
 	char *token;
 	int args = 0;
 
 	do {
+		if (type == EVENT_NEWLINE) {
+			free_token(token);
+			type = read_token_item(&token);
+			continue;
+		}
+
 		arg = malloc_or_die(sizeof(*arg));
 		memset(arg, 0, sizeof(*arg));
 
