Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbZLNWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbZLNWJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932616AbZLNWJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:09:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:53027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbZLNWJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:09:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf record: Rename perf.data to perf.data.old if --force/-f is used
Date: Mon, 14 Dec 2009 20:09:30 -0200
Message-Id: <1260828571-3613-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260828571-3613-1-git-send-email-acme@infradead.org>
References: <1260828571-3613-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a66a58d..66979a5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -421,10 +421,19 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 
 	if (!stat(output_name, &st) && st.st_size) {
-		if (!force && !append_file) {
-			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
-					output_name);
-			exit(-1);
+		if (!force) {
+			if (!append_file) {
+				pr_err("Error, output file %s exists, use -A "
+				       "to append or -f to overwrite.\n",
+				       output_name);
+				exit(-1);
+			}
+		} else {
+			char oldname[PATH_MAX];
+			snprintf(oldname, sizeof(oldname), "%s.old",
+				 output_name);
+			unlink(oldname);
+			rename(output_name, oldname);
 		}
 	} else {
 		append_file = 0;
-- 
1.6.2.5

