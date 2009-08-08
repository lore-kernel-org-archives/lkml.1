Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZHHC1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZHHC1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZHHC1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:27:07 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:34906 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZHHC0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PegXio7lyi7BINTBmvuU9cfhb/UUuGIwTpFIcmFKVoxq2XnS1SlkirWv+tqJMKcOdF
         vR+0O+0DuA84T4e0w5c+IQbXbiQJmBWSUOHjcCNlenLz46ITbGxW4S+9uJZEQ6gkIrXA
         JGvlcEDiTHKWueFEMkMGQtUTJXgwX3RuzZvJQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 3/4] perf tools: callchain: Default display callchain from report if recorded with -g
Date: Sat,  8 Aug 2009 04:26:38 +0200
Message-Id: <1249698400-5441-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we recorded with -g option to record the callchain, let's display
the callchain by default from perf report.

The user can override this default using "-g none" option from
perf report.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
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
-- 
1.6.2.3

