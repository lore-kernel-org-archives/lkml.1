Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZFYTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZFYTpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbZFYToh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:44:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:45366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058AbZFYTof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:44:35 -0400
Date: Thu, 25 Jun 2009 19:43:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf-report: Add modes for inherited stats and no-samples
Message-ID: <tip-649c48a9e7fafcc72bfcc99471d9dea98d789d59@git.kernel.org>
Git-Commit-ID: 649c48a9e7fafcc72bfcc99471d9dea98d789d59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:44:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  649c48a9e7fafcc72bfcc99471d9dea98d789d59
Gitweb:     http://git.kernel.org/tip/649c48a9e7fafcc72bfcc99471d9dea98d789d59
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Jun 2009 21:12:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:08 +0200

perf-report: Add modes for inherited stats and no-samples

Now that we can collect per task statistics, add modes that
make use of that facility.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4f0240..798a56d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,6 +41,8 @@ static int			force				= 0;
 static int			append_file			= 0;
 static int			call_graph			= 0;
 static int			verbose				= 0;
+static int			inherit_stat			= 0;
+static int			no_samples			= 0;
 
 static long			samples;
 static struct timeval		last_read;
@@ -393,6 +395,12 @@ static void create_counter(int counter, int cpu, pid_t pid)
 		attr->sample_freq	= freq;
 	}
 
+	if (no_samples)
+		attr->sample_freq = 0;
+
+	if (inherit_stat)
+		attr->inherit_stat = 1;
+
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -571,7 +579,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	while (!done) {
+	for (;;) {
 		int hits = samples;
 
 		for (i = 0; i < nr_cpu; i++) {
@@ -579,8 +587,11 @@ static int __cmd_record(int argc, const char **argv)
 				mmap_read(&mmap_array[i][counter]);
 		}
 
-		if (hits == samples)
+		if (hits == samples) {
+			if (done)
+				break;
 			ret = poll(event_array, nr_poll, 100);
+		}
 	}
 
 	/*
@@ -629,6 +640,10 @@ static const struct option options[] = {
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_BOOLEAN('s', "stat", &inherit_stat,
+		    "per thread counts"),
+	OPT_BOOLEAN('n', "no-samples", &no_samples,
+		    "don't sample"),
 	OPT_END()
 };
 
