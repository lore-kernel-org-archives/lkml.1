Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZFCTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZFCTQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZFCTQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:16:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZFCTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:16:36 -0400
Date: Wed, 3 Jun 2009 19:15:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf help: Fix bug when there's no perf-* command around
Message-ID: <tip-051cdc3c2d0e24443ac03aff03ee89807ec8c589@git.kernel.org>
Git-Commit-ID: 051cdc3c2d0e24443ac03aff03ee89807ec8c589
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 19:15:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  051cdc3c2d0e24443ac03aff03ee89807ec8c589
Gitweb:     http://git.kernel.org/tip/051cdc3c2d0e24443ac03aff03ee89807ec8c589
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 20:09:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 20:09:11 +0200

perf help: Fix bug when there's no perf-* command around

main_cmds can be empty - fix util/help.c to handle this case
without segfaulting.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/util/help.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/perf_counter/util/help.c b/Documentation/perf_counter/util/help.c
index 397487f..6653f7d 100644
--- a/Documentation/perf_counter/util/help.c
+++ b/Documentation/perf_counter/util/help.c
@@ -298,7 +298,7 @@ static void add_cmd_list(struct cmdnames *cmds, struct cmdnames *old)
 
 const char *help_unknown_cmd(const char *cmd)
 {
-	int i, n, best_similarity = 0;
+	int i, n = 0, best_similarity = 0;
 	struct cmdnames main_cmds, other_cmds;
 
 	memset(&main_cmds, 0, sizeof(main_cmds));
@@ -315,20 +315,24 @@ const char *help_unknown_cmd(const char *cmd)
 	      sizeof(main_cmds.names), cmdname_compare);
 	uniq(&main_cmds);
 
-	/* This reuses cmdname->len for similarity index */
-	for (i = 0; i < main_cmds.cnt; ++i)
-		main_cmds.names[i]->len =
-			levenshtein(cmd, main_cmds.names[i]->name, 0, 2, 1, 4);
+	if (main_cmds.cnt) {
+		/* This reuses cmdname->len for similarity index */
+		for (i = 0; i < main_cmds.cnt; ++i)
+			main_cmds.names[i]->len =
+				levenshtein(cmd, main_cmds.names[i]->name, 0, 2, 1, 4);
 
-	qsort(main_cmds.names, main_cmds.cnt,
-	      sizeof(*main_cmds.names), levenshtein_compare);
+		qsort(main_cmds.names, main_cmds.cnt,
+		      sizeof(*main_cmds.names), levenshtein_compare);
+
+		best_similarity = main_cmds.names[0]->len;
+		n = 1;
+		while (n < main_cmds.cnt && best_similarity == main_cmds.names[n]->len)
+			++n;
+	}
 
-	best_similarity = main_cmds.names[0]->len;
-	n = 1;
-	while (n < main_cmds.cnt && best_similarity == main_cmds.names[n]->len)
-		++n;
 	if (autocorrect && n == 1) {
 		const char *assumed = main_cmds.names[0]->name;
+
 		main_cmds.names[0] = NULL;
 		clean_cmdnames(&main_cmds);
 		fprintf(stderr, "WARNING: You called a Git program named '%s', "
@@ -345,7 +349,7 @@ const char *help_unknown_cmd(const char *cmd)
 
 	fprintf(stderr, "perf: '%s' is not a perf-command. See 'perf --help'.\n", cmd);
 
-	if (best_similarity < 6) {
+	if (main_cmds.cnt && best_similarity < 6) {
 		fprintf(stderr, "\nDid you mean %s?\n",
 			n < 2 ? "this": "one of these");
 
