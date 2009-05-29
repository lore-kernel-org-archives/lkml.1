Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbZE2JBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbZE2JBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZE2JB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:01:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59594 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbZE2JB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:01:26 -0400
Date: Fri, 29 May 2009 09:00:57 GMT
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
Subject: [tip:perfcounters/core] perf_counter tools: Split display into reading and printing
Message-ID: <tip-2996f5ddb7ba8889caeeac65edafe48845106eaa@git.kernel.org>
Git-Commit-ID: 2996f5ddb7ba8889caeeac65edafe48845106eaa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:00:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2996f5ddb7ba8889caeeac65edafe48845106eaa
Gitweb:     http://git.kernel.org/tip/2996f5ddb7ba8889caeeac65edafe48845106eaa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 09:10:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 May 2009 09:21:49 +0200

perf_counter tools: Split display into reading and printing

We introduce the extra pass to allow the print-out to possibly
rely on already read counters.

[ Impact: cleanup ]

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
 Documentation/perf_counter/builtin-stat.c |   40 ++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 6a29361..0c92eb7 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -71,6 +71,9 @@ static const unsigned int default_count[] = {
 	  10000,
 };
 
+static __u64			event_res[MAX_COUNTERS][3];
+static __u64			event_scaled[MAX_COUNTERS];
+
 static void create_perfstat_counter(int counter)
 {
 	struct perf_counter_hw_event hw_event;
@@ -123,16 +126,19 @@ static inline int nsec_counter(int counter)
 }
 
 /*
- * Print out the results of a single counter:
+ * Read out the results of a single counter:
  */
-static void print_counter(int counter)
+static void read_counter(int counter)
 {
-	__u64 count[3], single_count[3];
+	__u64 *count, single_count[3];
 	ssize_t res;
 	int cpu, nv;
 	int scaled;
 
+	count = event_res[counter];
+
 	count[0] = count[1] = count[2] = 0;
+
 	nv = scale ? 3 : 1;
 	for (cpu = 0; cpu < nr_cpus; cpu ++) {
 		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
@@ -148,16 +154,35 @@ static void print_counter(int counter)
 	scaled = 0;
 	if (scale) {
 		if (count[2] == 0) {
-			fprintf(stderr, " %14s  %-20s\n",
-				"<not counted>", event_name(counter));
+			event_scaled[counter] = -1;
+			count[0] = 0;
 			return;
 		}
+
 		if (count[2] < count[1]) {
-			scaled = 1;
+			event_scaled[counter] = 1;
 			count[0] = (unsigned long long)
 				((double)count[0] * count[1] / count[2] + 0.5);
 		}
 	}
+}
+
+/*
+ * Print out the results of a single counter:
+ */
+static void print_counter(int counter)
+{
+	__u64 *count;
+	int scaled;
+
+	count = event_res[counter];
+	scaled = event_scaled[counter];
+
+	if (scaled == -1) {
+		fprintf(stderr, " %14s  %-20s\n",
+			"<not counted>", event_name(counter));
+		return;
+	}
 
 	if (nsec_counter(counter)) {
 		double msecs = (double)count[0] / 1000000;
@@ -214,6 +239,9 @@ static int do_perfstat(int argc, const char **argv)
 	fprintf(stderr, "\n");
 
 	for (counter = 0; counter < nr_counters; counter++)
+		read_counter(counter);
+
+	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
 
