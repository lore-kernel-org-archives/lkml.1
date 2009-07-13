Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZGMKx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZGMKx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 06:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZGMKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 06:53:27 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:4274 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZGMKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 06:53:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: I.1 - System calls - ioctl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, eranian@gmail.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <20090622125837.GA9429@infradead.org>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622114931.GB24366@elte.hu>  <20090622125837.GA9429@infradead.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 12:53:13 +0200
Message-Id: <1247482393.7529.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
> But talking about syscalls the sys_perf_counter_open prototype is
> really ugly - it uses either the pid or cpu argument which is a pretty
> clear indicator it should actually be two sys calls.

Would something like the below be any better?

It would allow us to later add something like PERF_TARGET_SOCKET and
things like that.

(utterly untested)

---
 include/linux/perf_counter.h |   12 ++++++++++++
 include/linux/syscalls.h     |    3 ++-
 kernel/perf_counter.c        |   24 +++++++++++++++++++++++-
 tools/perf/builtin-record.c  |   11 ++++++++++-
 tools/perf/builtin-stat.c    |   12 ++++++++++--
 tools/perf/builtin-top.c     |   11 ++++++++++-
 tools/perf/perf.h            |    7 +++----
 7 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 5e970c7..f7dd22e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -189,6 +189,18 @@ struct perf_counter_attr {
 	__u64			__reserved_3;
 };
 
+enum perf_counter_target_ids {
+	PERF_TARGET_PID		= 0,
+	PERF_TARGET_CPU		= 1,
+
+	PERF_TARGET_MAX		/* non-ABI */
+};
+
+struct perf_counter_target {
+	__u32			id;
+	__u64			val;
+};
+
 /*
  * Ioctls that can be done on a perf counter fd:
  */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 80de700..670edad 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -760,5 +760,6 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 asmlinkage long sys_perf_counter_open(
 		struct perf_counter_attr __user *attr_uptr,
-		pid_t pid, int cpu, int group_fd, unsigned long flags);
+		struct perf_counter_target __user *target,
+		int group_fd, unsigned long flags);
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index fa20a9d..205f0b6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3969,15 +3969,18 @@ err_size:
  */
 SYSCALL_DEFINE5(perf_counter_open,
 		struct perf_counter_attr __user *, attr_uptr,
-		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
+		struct perf_counter_target __user *, target_uptr,
+		int, group_fd, unsigned long, flags)
 {
 	struct perf_counter *counter, *group_leader;
 	struct perf_counter_attr attr;
+	struct perf_counter_target target;
 	struct perf_counter_context *ctx;
 	struct file *counter_file = NULL;
 	struct file *group_file = NULL;
 	int fput_needed = 0;
 	int fput_needed2 = 0;
+	int pid, cpu;
 	int ret;
 
 	/* for future expandability... */
@@ -3998,6 +4001,25 @@ SYSCALL_DEFINE5(perf_counter_open,
 			return -EINVAL;
 	}
 
+	ret = copy_from_user(&target, target_uptr, sizeof(target));
+	if (ret)
+		return ret;
+
+	switch (target.id) {
+	case PERF_TARGET_PID:
+		pid = target.val;
+		cpu = -1;
+		break;
+
+	case PERF_TARGET_CPU:
+		cpu = target.val;
+		pid = -1;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4ef78a5..b172d30 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -374,6 +374,7 @@ static struct perf_header_attr *get_header_attr(struct perf_counter_attr *a, int
 static void create_counter(int counter, int cpu, pid_t pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
+	struct perf_counter_target target;
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
 	struct {
@@ -409,8 +410,16 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->disabled		= 1;
 
+	if (cpu < 0) {
+		target.id = PERF_TARGET_PID;
+		target.val = pid;
+	} else {
+		target.id = PERF_TARGET_CPU;
+		target.val = cpu;
+	}
+
 try_again:
-	fd[nr_cpu][counter] = sys_perf_counter_open(attr, pid, cpu, group_fd, 0);
+	fd[nr_cpu][counter] = sys_perf_counter_open(attr, &target, group_fd, 0);
 
 	if (fd[nr_cpu][counter] < 0) {
 		int err = errno;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 27921a8..342e642 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -106,6 +106,7 @@ static u64			runtime_cycles_noise;
 static void create_perf_stat_counter(int counter, int pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
+	struct perf_counter_target target;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -114,8 +115,12 @@ static void create_perf_stat_counter(int counter, int pid)
 	if (system_wide) {
 		unsigned int cpu;
 
+		target.id = PERF_TARGET_CPU;
+
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
+			target.val = cpu;
+
+			fd[cpu][counter] = sys_perf_counter_open(attr, &target, -1, 0);
 			if (fd[cpu][counter] < 0 && verbose)
 				fprintf(stderr, ERR_PERF_OPEN, counter,
 					fd[cpu][counter], strerror(errno));
@@ -125,7 +130,10 @@ static void create_perf_stat_counter(int counter, int pid)
 		attr->disabled	     = 1;
 		attr->enable_on_exec = 1;
 
-		fd[0][counter] = sys_perf_counter_open(attr, pid, -1, -1, 0);
+		target.id = PERF_TARGET_PID;
+		target.val = pid;
+
+		fd[0][counter] = sys_perf_counter_open(attr, &target, -1, 0);
 		if (fd[0][counter] < 0 && verbose)
 			fprintf(stderr, ERR_PERF_OPEN, counter,
 				fd[0][counter], strerror(errno));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 95d5c0a..facc870 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -548,6 +548,7 @@ int group_fd;
 
 static void start_counter(int i, int counter)
 {
+	struct perf_counter_target target;
 	struct perf_counter_attr *attr;
 	unsigned int cpu;
 
@@ -560,8 +561,16 @@ static void start_counter(int i, int counter)
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 	attr->freq		= freq;
 
+	if (cpu < 0) {
+		target.id = PERF_TARGET_PID;
+		target.val = target_pid;
+	} else {
+		target.id = PERF_TARGET_CPU;
+		target.val = cpu;
+	}
+
 try_again:
-	fd[i][counter] = sys_perf_counter_open(attr, target_pid, cpu, group_fd, 0);
+	fd[i][counter] = sys_perf_counter_open(attr, &target, group_fd, 0);
 
 	if (fd[i][counter] < 0) {
 		int err = errno;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e5148e2..3d663d7 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -85,12 +85,11 @@ static inline unsigned long long rdclock(void)
 
 static inline int
 sys_perf_counter_open(struct perf_counter_attr *attr,
-		      pid_t pid, int cpu, int group_fd,
-		      unsigned long flags)
+		      struct perf_counter_target *target,
+		      int group_fd, unsigned long flags)
 {
 	attr->size = sizeof(*attr);
-	return syscall(__NR_perf_counter_open, attr, pid, cpu,
-		       group_fd, flags);
+	return syscall(__NR_perf_counter_open, attr, target, group_fd, flags);
 }
 
 #define MAX_COUNTERS			256


