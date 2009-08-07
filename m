Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZHGMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZHGMZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZHGMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:25:48 -0400
Received: from rood.intersec.com ([88.191.78.202]:60545 "EHLO mx2.intersec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654AbZHGMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:25:47 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2009 08:25:47 EDT
X-Intersec-Trusted-Host: yes
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Pierre Habouzit <madcoder@debian.org>,
       Pierre Habouzit <pierre.habouzit@intersec.com>
Subject: [PATCH 2/2] perf-record: improve -A UI for empty or non-existent perf.data
Date: Fri,  7 Aug 2009 14:16:01 +0200
Message-Id: <1249647361-11582-3-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.6.4.rc2.183.g9085a
In-Reply-To: <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
References: <1249647361-11582-1-git-send-email-pierre.habouzit@intersec.com>
 <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Habouzit <madcoder@debian.org>

1. Ignore the -A argument if there is no perf.data file
2. Treat an empty file like a non existent file.

Else, perf will try to read the perf.data header, and fail with an error.

Treating an empty file like a non-existent file makes sense, since an
interupted (as in SIGKILLed) perf could leave such files around, and you
don't want to annoy the user with errors for files with no data in it.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
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
-- 
1.6.4.rc2.183.g9085a

