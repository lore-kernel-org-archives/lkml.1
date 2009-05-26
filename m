Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZEZPke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZEZPke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZEZPk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:40:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:51130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZEZPkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:40:25 -0400
Date: Tue, 26 May 2009 15:39:33 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526152134.GF4424@ghostprotocols.net>
References: <20090526152134.GF4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf: Don't assume /proc/kallsyms is ordered
Message-ID: <tip-abd54f68629fa73ed4fa040d433196211a9bbed2@git.kernel.org>
Git-Commit-ID: abd54f68629fa73ed4fa040d433196211a9bbed2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 15:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abd54f68629fa73ed4fa040d433196211a9bbed2
Gitweb:     http://git.kernel.org/tip/abd54f68629fa73ed4fa040d433196211a9bbed2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 May 2009 12:21:34 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 17:36:13 +0200

perf: Don't assume /proc/kallsyms is ordered

perf: Don't assume /proc/kallsyms is ordered

Since we _are_ ordering it by the symbol start, just traverse the
freshly built rbtree setting the prev->end members to curr->start - 1.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090526152134.GF4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   48 +++++++++++++++------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index b19b893..e178190 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -360,17 +360,9 @@ static int load_kallsyms(void)
 	char *line = NULL;
 	size_t n;
 
-	if (getline(&line, &n, file) < 0 || !line)
-		goto out_delete_dso;
-
-	unsigned long long previous_start;
-	char c, previous_symbf[4096];
-	if (sscanf(line, "%llx %c %s", &previous_start, &c, previous_symbf) != 3)
-		goto out_delete_line;
-
 	while (!feof(file)) {
 		unsigned long long start;
-		char symbf[4096];
+		char c, symbf[4096];
 
 		if (getline(&line, &n, file) < 0)
 			break;
@@ -379,21 +371,35 @@ static int load_kallsyms(void)
 			goto out_delete_dso;
 
 		if (sscanf(line, "%llx %c %s", &start, &c, symbf) == 3) {
-			if (start > previous_start) {
-				struct symbol *sym = symbol__new(previous_start,
-								 start - previous_start,
-								 previous_symbf);
+			/*
+			 * Well fix up the end later, when we have all sorted.
+			 */
+			struct symbol *sym = symbol__new(start, 0xdead, symbf);
 
-				if (sym == NULL)
-					goto out_delete_dso;
+			if (sym == NULL)
+				goto out_delete_dso;
 
-				dso__insert_symbol(kernel_dso, sym);
-				previous_start = start;
-				strcpy(previous_symbf, symbf);
-			}
+			dso__insert_symbol(kernel_dso, sym);
 		}
 	}
 
+	/*
+	 * Now that we have all sorted out, just set the ->end of all
+	 * symbols
+	 */
+	struct rb_node *nd, *prevnd = rb_first(&kernel_dso->syms);
+
+	if (prevnd == NULL)
+		goto out_delete_line;
+
+	for (nd = rb_next(prevnd); nd; nd = rb_next(nd)) {
+		struct symbol *prev = rb_entry(prevnd, struct symbol, rb_node),
+			      *curr = rb_entry(nd, struct symbol, rb_node);
+
+		prev->end = curr->start - 1;
+		prevnd = nd;
+	}
+
 	dsos__add(kernel_dso);
 	free(line);
 	fclose(file);
