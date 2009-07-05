Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZGEJwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZGEJwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZGEJw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZGEJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:52:27 -0400
Date: Sun, 5 Jul 2009 09:51:51 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, paulus@samba.org,
       acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       anton@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, jens.axboe@oracle.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf report: Warn on callchain output request from non-callchain file
Message-ID: <tip-91b4eaea93f5be95f4477554399680a53aff2343@git.kernel.org>
Git-Commit-ID: 91b4eaea93f5be95f4477554399680a53aff2343
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 09:51:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91b4eaea93f5be95f4477554399680a53aff2343
Gitweb:     http://git.kernel.org/tip/91b4eaea93f5be95f4477554399680a53aff2343
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 5 Jul 2009 07:39:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jul 2009 10:30:21 +0200

perf report: Warn on callchain output request from non-callchain file

perf report segfaults while trying to handle callchains from a non
callchain data file.

Instead of a segfault, print a useful message to the user.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
