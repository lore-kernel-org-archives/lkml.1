Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZFEMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZFEMqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZFEMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:46:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:51824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFEMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:46:16 -0400
Date: Fri, 5 Jun 2009 12:45:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Split out counter creation into a helper function
Message-ID: <tip-f250c030a87273f8838a2302bee7c2b4d03e9151@git.kernel.org>
Git-Commit-ID: f250c030a87273f8838a2302bee7c2b4d03e9151
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 12:45:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f250c030a87273f8838a2302bee7c2b4d03e9151
Gitweb:     http://git.kernel.org/tip/f250c030a87273f8838a2302bee7c2b4d03e9151
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 13:18:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 13:29:57 +0200

perf record: Split out counter creation into a helper function

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |  100 ++++++++++++++-------------
 1 files changed, 53 insertions(+), 47 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index bf59df5..7f2d7ce 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -336,65 +336,71 @@ static void synthesize_events(void)
 	closedir(proc);
 }
 
-static void open_counters(int cpu, pid_t pid)
+static int group_fd;
+
+static void create_counter(int counter, int cpu, pid_t pid)
 {
 	struct perf_counter_attr attr;
-	int counter, group_fd;
 	int track = 1;
 
-	if (pid > 0) {
-		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_events(pid);
-	}
+	memset(&attr, 0, sizeof(attr));
+	attr.config		= event_id[counter];
+	attr.sample_period	= event_count[counter];
+	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr.mmap		= track;
+	attr.comm		= track;
+	attr.inherit	= (cpu < 0) && inherit;
 
-	group_fd = -1;
-	for (counter = 0; counter < nr_counters; counter++) {
+	track = 0; /* only the first counter needs these */
 
-		memset(&attr, 0, sizeof(attr));
-		attr.config		= event_id[counter];
-		attr.sample_period	= event_count[counter];
-		attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
-		attr.mmap		= track;
-		attr.comm		= track;
-		attr.inherit	= (cpu < 0) && inherit;
+	fd[nr_cpu][counter] = sys_perf_counter_open(&attr, pid, cpu, group_fd, 0);
 
-		track = 0; // only the first counter needs these
+	if (fd[nr_cpu][counter] < 0) {
+		int err = errno;
 
-		fd[nr_cpu][counter] =
-			sys_perf_counter_open(&attr, pid, cpu, group_fd, 0);
+		error("syscall returned with %d (%s)\n",
+				fd[nr_cpu][counter], strerror(err));
+		if (err == EPERM)
+			printf("Are you root?\n");
+		exit(-1);
+	}
+	assert(fd[nr_cpu][counter] >= 0);
+	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
 
-		if (fd[nr_cpu][counter] < 0) {
-			int err = errno;
+	/*
+	 * First counter acts as the group leader:
+	 */
+	if (group && group_fd == -1)
+		group_fd = fd[nr_cpu][counter];
+
+	event_array[nr_poll].fd = fd[nr_cpu][counter];
+	event_array[nr_poll].events = POLLIN;
+	nr_poll++;
+
+	mmap_array[nr_cpu][counter].counter = counter;
+	mmap_array[nr_cpu][counter].prev = 0;
+	mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
+	mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+			PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
+	if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
+		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+		exit(-1);
+	}
+}
 
-			error("syscall returned with %d (%s)\n",
-					fd[nr_cpu][counter], strerror(err));
-			if (err == EPERM)
-				printf("Are you root?\n");
-			exit(-1);
-		}
-		assert(fd[nr_cpu][counter] >= 0);
-		fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
+static void open_counters(int cpu, pid_t pid)
+{
+	int counter;
 
-		/*
-		 * First counter acts as the group leader:
-		 */
-		if (group && group_fd == -1)
-			group_fd = fd[nr_cpu][counter];
-
-		event_array[nr_poll].fd = fd[nr_cpu][counter];
-		event_array[nr_poll].events = POLLIN;
-		nr_poll++;
-
-		mmap_array[nr_cpu][counter].counter = counter;
-		mmap_array[nr_cpu][counter].prev = 0;
-		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
-		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ, MAP_SHARED, fd[nr_cpu][counter], 0);
-		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-			exit(-1);
-		}
+	if (pid > 0) {
+		pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_events(pid);
 	}
+
+	group_fd = -1;
+	for (counter = 0; counter < nr_counters; counter++)
+		create_counter(counter, cpu, pid);
+
 	nr_cpu++;
 }
 
