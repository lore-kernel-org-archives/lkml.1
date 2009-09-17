Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbZIQSIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbZIQSIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbZIQSIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:08:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438AbZIQSIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:08:12 -0400
Date: Thu, 17 Sep 2009 18:07:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf record: Disable profiling before draining the buffer
Message-ID: <tip-5abfd8bf28feeb633afdea2309fb0927d17606be@git.kernel.org>
Git-Commit-ID: 5abfd8bf28feeb633afdea2309fb0927d17606be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 18:07:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5abfd8bf28feeb633afdea2309fb0927d17606be
Gitweb:     http://git.kernel.org/tip/5abfd8bf28feeb633afdea2309fb0927d17606be
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Sep 2009 19:59:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Sep 2009 20:02:47 +0200

perf record: Disable profiling before draining the buffer

I noticed that perf-record continues profiling itself after the
child terminated and we're draining the buffer.

This can cause a _lot_ of overhead with --all recording - we keep
and keep recording, which produces new and new events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5f3127e..2459e5a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -524,6 +524,7 @@ static int __cmd_record(int argc, const char **argv)
 	pid_t pid = 0;
 	int flags;
 	int ret;
+	unsigned long waking = 0;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -634,10 +635,20 @@ static int __cmd_record(int argc, const char **argv)
 		if (hits == samples) {
 			if (done)
 				break;
-			ret = poll(event_array, nr_poll, 100);
+			ret = poll(event_array, nr_poll, -1);
+			waking++;
+		}
+
+		if (done) {
+			for (i = 0; i < nr_cpu; i++) {
+				for (counter = 0; counter < nr_counters; counter++)
+					ioctl(fd[i][counter], PERF_COUNTER_IOC_DISABLE);
+			}
 		}
 	}
 
+	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+
 	/*
 	 * Approximate RIP event size: 24 bytes.
 	 */
