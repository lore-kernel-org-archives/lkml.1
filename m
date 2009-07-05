Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZGEFje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZGEFje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 01:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZGEFjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 01:39:23 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:43552 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZGEFjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 01:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NgrYMUucPgjVaC1nYVO/soxkkqSy6ajHKdBZGyjvNA7GI0ypZNd3rZQenKa+Rkiuki
         JCWKuIWo8kUHBOmhNlGwbevTYYLaCNjM8UN5hX9652wPdPUT2xzm+WugsFmNMVMR9Pfd
         x5qLAVK1ZETN8R+xKcTdXjwMQKejOM1LnLHyI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] perf report: Warn on callchain output request from non-callchain file
Date: Sun,  5 Jul 2009 07:39:17 +0200
Message-Id: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf report segfaults while trying to handle callchains from a non
callchain data file.
Instead of a segfault, print a useful message to the user.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fa937f5..9f9575a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1684,9 +1684,19 @@ static int __cmd_report(void)
 
 	sample_type = perf_header__sample_type();
 
-	if (sort__has_parent && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
-		fprintf(stderr, "selected --sort parent, but no callchain data\n");
-		exit(-1);
+	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+		if (sort__has_parent) {
+			fprintf(stderr, "selected --sort parent, but no"
+					" callchain data. Did you call"
+					" perf record without -g?\n");
+			exit(-1);
+		}
+		if (callchain) {
+			fprintf(stderr, "selected -c but no callchain data."
+					" Did you call perf record without"
+					" -g?\n");
+			exit(-1);
+		}
 	}
 
 	if (load_kernel() < 0) {
-- 
1.6.2.3

