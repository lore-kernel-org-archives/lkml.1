Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZFBUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZFBUSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZFBUSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:18:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:39528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbZFBUR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:59 -0400
Date: Tue, 2 Jun 2009 20:17:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, jkacur@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>,
	<new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Fix up the ABI shakeup
Message-ID: <tip-c70975bc8d5bac487616785f5d5bc7b090dfa2d9@git.kernel.org>
Git-Commit-ID: c70975bc8d5bac487616785f5d5bc7b090dfa2d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:17:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c70975bc8d5bac487616785f5d5bc7b090dfa2d9
Gitweb:     http://git.kernel.org/tip/c70975bc8d5bac487616785f5d5bc7b090dfa2d9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 17:38:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:34 +0200

perf_counter tools: Fix up the ABI shakeup

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |   18 +++++++++---------
 Documentation/perf_counter/builtin-stat.c   |   22 +++++++++++-----------
 Documentation/perf_counter/builtin-top.c    |   20 ++++++++++----------
 Documentation/perf_counter/perf.h           |    4 ++--
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index bace7a8..c2fd042 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -322,7 +322,7 @@ static void synthesize_events(void)
 
 static void open_counters(int cpu, pid_t pid)
 {
-	struct perf_counter_hw_event hw_event;
+	struct perf_counter_attr attr;
 	int counter, group_fd;
 	int track = 1;
 
@@ -334,18 +334,18 @@ static void open_counters(int cpu, pid_t pid)
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++) {
 
-		memset(&hw_event, 0, sizeof(hw_event));
-		hw_event.config		= event_id[counter];
-		hw_event.irq_period	= event_count[counter];
-		hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-		hw_event.mmap		= track;
-		hw_event.comm		= track;
-		hw_event.inherit	= (cpu < 0) && inherit;
+		memset(&attr, 0, sizeof(attr));
+		attr.config		= event_id[counter];
+		attr.sample_period	= event_count[counter];
+		attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+		attr.mmap		= track;
+		attr.comm		= track;
+		attr.inherit	= (cpu < 0) && inherit;
 
 		track = 0; // only the first counter needs these
 
 		fd[nr_cpu][counter] =
-			sys_perf_counter_open(&hw_event, pid, cpu, group_fd, 0);
+			sys_perf_counter_open(&attr, pid, cpu, group_fd, 0);
 
 		if (fd[nr_cpu][counter] < 0) {
 			int err = errno;
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 644f850..27abe6a 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -79,22 +79,22 @@ static __u64			walltime_nsecs;
 
 static void create_perfstat_counter(int counter)
 {
-	struct perf_counter_hw_event hw_event;
+	struct perf_counter_attr attr;
 
-	memset(&hw_event, 0, sizeof(hw_event));
-	hw_event.config		= event_id[counter];
-	hw_event.record_type	= 0;
-	hw_event.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
-	hw_event.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
+	memset(&attr, 0, sizeof(attr));
+	attr.config		= event_id[counter];
+	attr.sample_type	= 0;
+	attr.exclude_kernel = event_mask[counter] & EVENT_MASK_KERNEL;
+	attr.exclude_user   = event_mask[counter] & EVENT_MASK_USER;
 
 	if (scale)
-		hw_event.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
+		attr.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 					  PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide) {
 		int cpu;
 		for (cpu = 0; cpu < nr_cpus; cpu ++) {
-			fd[cpu][counter] = sys_perf_counter_open(&hw_event, -1, cpu, -1, 0);
+			fd[cpu][counter] = sys_perf_counter_open(&attr, -1, cpu, -1, 0);
 			if (fd[cpu][counter] < 0) {
 				printf("perfstat error: syscall returned with %d (%s)\n",
 						fd[cpu][counter], strerror(errno));
@@ -102,10 +102,10 @@ static void create_perfstat_counter(int counter)
 			}
 		}
 	} else {
-		hw_event.inherit	= inherit;
-		hw_event.disabled	= 1;
+		attr.inherit	= inherit;
+		attr.disabled	= 1;
 
-		fd[0][counter] = sys_perf_counter_open(&hw_event, 0, -1, -1, 0);
+		fd[0][counter] = sys_perf_counter_open(&attr, 0, -1, -1, 0);
 		if (fd[0][counter] < 0) {
 			printf("perfstat error: syscall returned with %d (%s)\n",
 					fd[0][counter], strerror(errno));
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index a2cff7b..5029d8e 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -537,7 +537,7 @@ static void mmap_read(struct mmap_data *md)
 		old += size;
 
 		if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
-			if (event->header.type & PERF_RECORD_IP)
+			if (event->header.type & PERF_SAMPLE_IP)
 				process_event(event->ip.ip, md->counter);
 		} else {
 			switch (event->header.type) {
@@ -563,7 +563,7 @@ static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
 static int __cmd_top(void)
 {
-	struct perf_counter_hw_event hw_event;
+	struct perf_counter_attr attr;
 	pthread_t thread;
 	int i, counter, group_fd, nr_poll = 0;
 	unsigned int cpu;
@@ -577,15 +577,15 @@ static int __cmd_top(void)
 			if (target_pid == -1 && profile_cpu == -1)
 				cpu = i;
 
-			memset(&hw_event, 0, sizeof(hw_event));
-			hw_event.config		= event_id[counter];
-			hw_event.irq_period	= event_count[counter];
-			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
-			hw_event.mmap		= use_mmap;
-			hw_event.munmap		= use_munmap;
-			hw_event.freq		= freq;
+			memset(&attr, 0, sizeof(attr));
+			attr.config		= event_id[counter];
+			attr.sample_period	= event_count[counter];
+			attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+			attr.mmap		= use_mmap;
+			attr.munmap		= use_munmap;
+			attr.freq		= freq;
 
-			fd[i][counter] = sys_perf_counter_open(&hw_event, target_pid, cpu, group_fd, 0);
+			fd[i][counter] = sys_perf_counter_open(&attr, target_pid, cpu, group_fd, 0);
 			if (fd[i][counter] < 0) {
 				int err = errno;
 				printf("kerneltop error: syscall returned with %d (%s)\n",
diff --git a/Documentation/perf_counter/perf.h b/Documentation/perf_counter/perf.h
index 5a2520b..10622a4 100644
--- a/Documentation/perf_counter/perf.h
+++ b/Documentation/perf_counter/perf.h
@@ -53,11 +53,11 @@ static inline unsigned long long rdclock(void)
 	_min1 < _min2 ? _min1 : _min2; })
 
 static inline int
-sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
+sys_perf_counter_open(struct perf_counter_attr *attr_uptr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	return syscall(__NR_perf_counter_open, hw_event_uptr, pid, cpu,
+	return syscall(__NR_perf_counter_open, attr_uptr, pid, cpu,
 		       group_fd, flags);
 }
 
