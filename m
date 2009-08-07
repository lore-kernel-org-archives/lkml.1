Return-Path: <linux-kernel-owner+w=401wt.eu-S932813AbZHGPKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbZHGPKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbZHGPKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:10:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797AbZHGPKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:10:47 -0400
Date: Fri, 7 Aug 2009 15:10:05 GMT
From: tip-bot for Pierre Habouzit <pierre.habouzit@intersec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, pierre.habouzit@intersec.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, pierre.habouzit@intersec.com, mingo@elte.hu
In-Reply-To: <1249647361-11582-3-git-send-email-pierre.habouzit@intersec.com>
References: <1249647361-11582-3-git-send-email-pierre.habouzit@intersec.com>
Subject: [tip:perfcounters/urgent] perf record: Fix the -A UI for empty or non-existent perf.data
Message-ID: <tip-7e6649a1a2dd0774160dc4f8d5db762ac3678ba0@git.kernel.org>
Git-Commit-ID: 7e6649a1a2dd0774160dc4f8d5db762ac3678ba0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 15:10:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e6649a1a2dd0774160dc4f8d5db762ac3678ba0
Gitweb:     http://git.kernel.org/tip/7e6649a1a2dd0774160dc4f8d5db762ac3678ba0
Author:     Pierre Habouzit <pierre.habouzit@intersec.com>
AuthorDate: Fri, 7 Aug 2009 14:16:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 17:08:17 +0200

perf record: Fix the -A UI for empty or non-existent perf.data

1. Ignore the -A argument if there is no perf.data file
2. Treat an empty file like a non existent file.

Else, perf will try to read the perf.data header, and fail with
an error.

Treating an empty file like a non-existent file makes sense,
since an interupted (as in SIGKILLed) perf could leave such
files around, and you don't want to annoy the user with errors
for files with no data in it.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249647361-11582-3-git-send-email-pierre.habouzit@intersec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6da0992..afbfb9d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -524,10 +524,14 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (!stat(output_name, &st) && !force && !append_file) {
-		fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
-				output_name);
-		exit(-1);
+	if (!stat(output_name, &st) && st.st_size) {
+		if (!force && !append_file) {
+			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
+					output_name);
+			exit(-1);
+		}
+	} else {
+		append_file = 0;
 	}
 
 	flags = O_CREAT|O_RDWR;
