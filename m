Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162Ab0AENy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0AENy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117Ab0AENy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:54:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0AENy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:54:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf report: Fix --no-call-chain option handling
Date: Tue,  5 Jan 2010 11:54:45 -0200
Message-Id: <1262699685-27820-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To avoid the funny:

[root@doppio ~]# perf record -a -f sleep 2s
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.334 MB perf.data (~14572 samples) ]
[root@doppio ~]# perf report --no-call-graph
selected -g but no callchain data. Did you call perf record without -g?

And fix the bug reported by peterz when we do indeed record with
callchains and then ask for a report without:

[root@doppio ~]# perf record -a -g -f sleep 2s
[root@doppio ~]# perf report --no-call-graph
Segmentation fault
[root@doppio ~]#

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4292d7a..80d691a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,6 +35,7 @@ static char		const *input_name = "perf.data";
 
 static int		force;
 static bool		hide_unresolved;
+static bool		dont_use_callchains;
 
 static int		show_threads;
 static struct perf_read_values	show_threads_values;
@@ -172,7 +173,8 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 					" -g?\n");
 			return -1;
 		}
-	} else if (callchain_param.mode != CHAIN_NONE && !symbol_conf.use_callchain) {
+	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
+		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
@@ -246,11 +248,19 @@ out_delete:
 
 static int
 parse_callchain_opt(const struct option *opt __used, const char *arg,
-		    int unset __used)
+		    int unset)
 {
 	char *tok;
 	char *endptr;
 
+	/*
+	 * --no-call-graph
+	 */
+	if (unset) {
+		dont_use_callchains = true;
+		return 0;
+	}
+
 	symbol_conf.use_callchain = true;
 
 	if (!arg)
-- 
1.6.2.5

