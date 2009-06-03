Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZFCSnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZFCSnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbZFCSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:43:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZFCSnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:43:17 -0400
Date: Wed, 3 Jun 2009 18:42:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: Print out all arguments
Message-ID: <tip-44db76c8553c328f4ae02481d77bb3a88ca17645@git.kernel.org>
Git-Commit-ID: 44db76c8553c328f4ae02481d77bb3a88ca17645
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 18:42:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44db76c8553c328f4ae02481d77bb3a88ca17645
Gitweb:     http://git.kernel.org/tip/44db76c8553c328f4ae02481d77bb3a88ca17645
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 19:36:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 19:36:07 +0200

perf stat: Print out all arguments

Before:

 Performance counter stats for '/home/mingo/hackbench':

After:

 Performance counter stats for '/home/mingo/hackbench 10':

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
 Documentation/perf_counter/builtin-stat.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 2357a66..4fc0d80 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -228,6 +228,7 @@ static int do_perfstat(int argc, const char **argv)
 	int counter;
 	int status;
 	int pid;
+	int i;
 
 	if (!system_wide)
 		nr_cpus = 1;
@@ -243,14 +244,17 @@ static int do_perfstat(int argc, const char **argv)
 
 	if ((pid = fork()) < 0)
 		perror("failed to fork");
+
 	if (!pid) {
 		if (execvp(argv[0], (char **)argv)) {
 			perror(argv[0]);
 			exit(-1);
 		}
 	}
+
 	while (wait(&status) >= 0)
 		;
+
 	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
 	t1 = rdclock();
 
@@ -259,8 +263,12 @@ static int do_perfstat(int argc, const char **argv)
 	fflush(stdout);
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, " Performance counter stats for \'%s\':\n",
-		argv[0]);
+	fprintf(stderr, " Performance counter stats for \'%s", argv[0]);
+
+	for (i = 1; i < argc; i++)
+		fprintf(stderr, " %s", argv[i]);
+
+	fprintf(stderr, "\':\n");
 	fprintf(stderr, "\n");
 
 	for (counter = 0; counter < nr_counters; counter++)
