Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZFBWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZFBWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZFBWdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:33:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:57036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbZFBWc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:32:59 -0400
Date: Tue, 2 Jun 2009 22:32:27 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Print more info instead of <unknown> entries
Message-ID: <tip-0a520c63e1625b92ef775da40192e1542910e7f6@git.kernel.org>
Git-Commit-ID: 0a520c63e1625b92ef775da40192e1542910e7f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 22:32:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a520c63e1625b92ef775da40192e1542910e7f6
Gitweb:     http://git.kernel.org/tip/0a520c63e1625b92ef775da40192e1542910e7f6
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 2 Jun 2009 23:24:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 23:24:45 +0200

perf report: Print more info instead of <unknown> entries

Sometimes we still fail to find a DSO or look up a symbol,
print out the raw information in this case (which an help
debug the problem), instead of a not very helpful <unknown>
string.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   28 +++++++++++++++++++-------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index b84aaf1..270e986 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -201,7 +201,9 @@ static struct thread *thread__new(pid_t pid)
 
 	if (self != NULL) {
 		self->pid = pid;
-		self->comm = NULL;
+		self->comm = malloc(30);
+		if (self->comm)
+			sprintf(self->comm, ":%d", pid);
 		INIT_LIST_HEAD(&self->maps);
 	}
 
@@ -333,7 +335,7 @@ sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__comm_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "  %16s", self->thread->comm ?: "<unknown>");
+	return fprintf(fp, "  %16s", self->thread->comm);
 }
 
 static struct sort_entry sort_comm = {
@@ -363,7 +365,10 @@ sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 static size_t
 sort__dso_print(FILE *fp, struct hist_entry *self)
 {
-	return fprintf(fp, "  %-25s", self->dso ? self->dso->name : "<unknown>");
+	if (self->dso)
+		return fprintf(fp, "  %-25s", self->dso->name);
+
+	return fprintf(fp, "  %016llx", (__u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
@@ -392,11 +397,17 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "  %#018llx", (unsigned long long)self->ip);
+		ret += fprintf(fp, "  %#018llx", (__u64)self->ip);
+
+	if (self->dso)
+		ret += fprintf(fp, "  %s: ", self->dso->name);
+	else
+		ret += fprintf(fp, "  %#016llx: ", (__u64)self->ip);
 
-	ret += fprintf(fp, "  %s: %s",
-			self->dso ? self->dso->name : "<unknown>",
-			self->sym ? self->sym->name : "<unknown>");
+	if (self->sym)
+		ret += fprintf(fp, "%s", self->sym->name);
+	else
+		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
 
 	return ret;
 }
@@ -772,7 +783,8 @@ more:
 				event->mmap.filename);
 		}
 		if (thread == NULL || map == NULL) {
-			fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
+			if (verbose)
+				fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
 			goto broken_event;
 		}
 		thread__insert_map(thread, map);
