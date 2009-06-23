Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZFWUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZFWUBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbZFWUBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:01:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:45119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbZFWUBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:01:18 -0400
Date: Tue, 23 Jun 2009 20:00:46 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245757369.3776.1.camel@localhost.localdomain>
References: <1245757369.3776.1.camel@localhost.localdomain>
Subject: [tip:perfcounters/urgent] perf stat: Fix verbose for perf stat
Message-ID: <tip-cca03c0aeb18a975abec28df518a2b64ae3e6964@git.kernel.org>
Git-Commit-ID: cca03c0aeb18a975abec28df518a2b64ae3e6964
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 20:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cca03c0aeb18a975abec28df518a2b64ae3e6964
Gitweb:     http://git.kernel.org/tip/cca03c0aeb18a975abec28df518a2b64ae3e6964
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Tue, 23 Jun 2009 17:12:49 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 21:58:44 +0200

perf stat: Fix verbose for perf stat

Error message should use stderr for verbose (-v), otherwise
message will be lost for:

 $ ./perf stat -v <cmd>  > /dev/null

For example on AMD bus-cycles event is not available so now
it looks like:

 $ ./perf stat -v -e bus-cycles ls > /dev/null
Error: counter 0, sys_perf_counter_open() syscall returned with -1 (Invalid argument)

 Performance counter stats for 'ls':

  <not counted>  bus-cycles

    0.006765877  seconds time elapsed.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245757369.3776.1.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6d3eeac..5e04fcc 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -109,6 +109,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
+
+#define ERR_PERF_OPEN \
+"Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
+
 static void create_perf_stat_counter(int counter)
 {
 	struct perf_counter_attr *attr = attrs + counter;
@@ -119,20 +123,20 @@ static void create_perf_stat_counter(int counter)
 
 	if (system_wide) {
 		int cpu;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
-			if (fd[cpu][counter] < 0 && verbose) {
-				printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[cpu][counter], strerror(errno));
-			}
+			if (fd[cpu][counter] < 0 && verbose)
+				fprintf(stderr, ERR_PERF_OPEN, counter,
+					fd[cpu][counter], strerror(errno));
 		}
 	} else {
 		attr->inherit	= inherit;
 		attr->disabled	= 1;
 
 		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
-		if (fd[0][counter] < 0 && verbose) {
-			printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[0][counter], strerror(errno));
-		}
+		if (fd[0][counter] < 0 && verbose)
+			fprintf(stderr, ERR_PERF_OPEN, counter,
+				fd[0][counter], strerror(errno));
 	}
 }
 
@@ -168,7 +172,7 @@ static void read_counter(int counter)
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
-	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (fd[cpu][counter] < 0)
 			continue;
 
