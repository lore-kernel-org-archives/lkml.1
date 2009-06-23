Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZFWLoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZFWLoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbZFWLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:43:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:40314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406AbZFWLnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:43:49 -0400
Subject: [PATCH -tip] perf_counter tools: fix verbose for perf stat
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 17:12:49 +0530
Message-Id: <1245757369.3776.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Error message should use stderr for verbose otherwise message will be lost for
 $ ./perf stat -v <cmd>  > /dev/null

For example on AMD bus-cycles event is not available so now it looks like:
 $ ./perf stat -v -e bus-cycles ls > /dev/null
Error: counter 0, sys_perf_counter_open() syscall returned with -1 (Invalid argument)

 Performance counter stats for 'ls':

  <not counted>  bus-cycles

    0.006765877  seconds time elapsed.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
 
-- 
1.6.0.6



