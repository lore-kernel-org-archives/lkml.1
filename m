Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZFCJts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZFCJts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZFCJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:49:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZFCJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:49:28 -0400
Date: Wed, 3 Jun 2009 09:48:48 GMT
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
Subject: [tip:perfcounters/core] perf report: Improve sort key recognition
Message-ID: <tip-5352f35d6ae7b8b981d77137fb268bc54d10624f@git.kernel.org>
Git-Commit-ID: 5352f35d6ae7b8b981d77137fb268bc54d10624f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 09:48:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5352f35d6ae7b8b981d77137fb268bc54d10624f
Gitweb:     http://git.kernel.org/tip/5352f35d6ae7b8b981d77137fb268bc54d10624f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 10:07:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 10:07:39 +0200

perf report: Improve sort key recognition

 - allow case-insensitive tokens - such as --sort Comm,Symbol
 - allow substring shortcuts: --sort sym
 - detect invalid tokens and bail out

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
 Documentation/perf_counter/builtin-report.c |   29 +++++++++++++++-----------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6207a31..a8d3905 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -453,28 +453,18 @@ static int sort_dimension__add(char *tok)
 		if (sd->taken)
 			continue;
 
-		if (strcmp(tok, sd->name))
+		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 		sd->taken = 1;
+
 		return 0;
 	}
 
 	return -ESRCH;
 }
 
-static void setup_sorting(void)
-{
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp))
-		sort_dimension__add(tok);
-
-	free(str);
-}
-
 static int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -880,6 +870,21 @@ static const struct option options[] = {
 	OPT_END()
 };
 
+static void setup_sorting(void)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(report_usage, options);
+		}
+	}
+
+	free(str);
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix)
 {
 	symbol__init();
