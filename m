Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZHILKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZHILKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZHILKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:10:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZHILKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:10:31 -0400
Date: Sun, 9 Aug 2009 11:09:59 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249690585-9145-3-git-send-email-fweisbec@gmail.com>
References: <1249690585-9145-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: callchain: Fix 'perf report' display to be callchain by default
Message-ID: <tip-b1a88349c37624755b28ac3b3152b48f52c1f487@git.kernel.org>
Git-Commit-ID: b1a88349c37624755b28ac3b3152b48f52c1f487
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:09:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1a88349c37624755b28ac3b3152b48f52c1f487
Gitweb:     http://git.kernel.org/tip/b1a88349c37624755b28ac3b3152b48f52c1f487
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 02:16:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:42 +0200

perf tools: callchain: Fix 'perf report' display to be callchain by default

If we recorded with -g option to record the callchain, right now
we require a -g option to perf report as well - and people reported
this as unnecessary complication: the user already specified -g
once, no need to require it a second time.

So if the recording includes call-chains, display the callchain by
default from perf report.

( The user can override this default using "-g none" option from
  perf report. )

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1249690585-9145-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   16 +++++++++++++++-
 tools/perf/util/callchain.h |    1 +
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a5e2f8d..c4a8e10 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -68,7 +68,7 @@ static int		callchain;
 
 static
 struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_ABS,
+	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5
 };
 
@@ -1836,6 +1836,13 @@ static int __cmd_report(void)
 					" -g?\n");
 			exit(-1);
 		}
+	} else if (callchain_param.mode != CHAIN_NONE && !callchain) {
+			callchain = 1;
+			if (register_callchain_param(&callchain_param) < 0) {
+				fprintf(stderr, "Can't register callchain"
+						" params\n");
+				exit(-1);
+			}
 	}
 
 	if (load_kernel() < 0) {
@@ -1974,6 +1981,13 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	else if (!strncmp(tok, "fractal", strlen(arg)))
 		callchain_param.mode = CHAIN_GRAPH_REL;
 
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		callchain = 0;
+
+		return 0;
+	}
+
 	else
 		return -1;
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index b2d128e..a926ae4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 
 enum chain_mode {
+	CHAIN_NONE,
 	CHAIN_FLAT,
 	CHAIN_GRAPH_ABS,
 	CHAIN_GRAPH_REL
