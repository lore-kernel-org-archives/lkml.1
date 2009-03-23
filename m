Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZCWU75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZCWU75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbZCWU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:58:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:49228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760498AbZCWU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:58:47 -0400
Date: Mon, 23 Mar 2009 20:57:16 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       fengguang.wu@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, fengguang.wu@intel.com, mingo@elte.hu
In-Reply-To: <20090323172417.677932499@chello.nl>
References: <20090323172417.677932499@chello.nl>
Subject: [tip:perfcounters/core] kerneltop: use mmap() output
Message-ID: <tip-0488f729768605502accdae7335911b4400a5927@git.kernel.org>
Git-Commit-ID: 0488f729768605502accdae7335911b4400a5927
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 20:57:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0488f729768605502accdae7335911b4400a5927
Gitweb:     http://git.kernel.org/tip/0488f729768605502accdae7335911b4400a5927
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Mar 2009 18:22:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 21:45:11 +0100

kerneltop: use mmap() output

update kerneltop to use the mmap() output to gather overflow information

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090323172417.677932499@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   93 +++++++++++++++++++++++++++-----
 1 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index a72c9bd..80b7905 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -84,6 +84,7 @@
 #include <sys/prctl.h>
 #include <sys/wait.h>
 #include <sys/uio.h>
+#include <sys/mman.h>
 
 #include <linux/unistd.h>
 
@@ -119,17 +120,25 @@ typedef long long               __s64;
 
 
 #ifdef __x86_64__
-# define __NR_perf_counter_open 295
+#define __NR_perf_counter_open 295
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #ifdef __i386__
-# define __NR_perf_counter_open 333
+#define __NR_perf_counter_open 333
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
 #endif
 
 #ifdef __powerpc__
 #define __NR_perf_counter_open 319
+#define rmb() 		asm volatile ("sync" ::: "memory")
+#define cpu_relax()	asm volatile ("" ::: "memory");
 #endif
 
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+
 asmlinkage int sys_perf_counter_open(
         struct perf_counter_hw_event    *hw_event_uptr          __user,
         pid_t                           pid,
@@ -181,6 +190,7 @@ static int			profile_cpu			= -1;
 static int			nr_cpus				=  0;
 static int			nmi				=  1;
 static int			group				=  0;
+static unsigned int		page_size;
 
 static char			*vmlinux;
 
@@ -1117,16 +1127,68 @@ static void process_options(int argc, char *argv[])
 	}
 }
 
+struct mmap_data {
+	int counter;
+	void *base;
+	unsigned int mask;
+	unsigned int prev;
+};
+
+static unsigned int mmap_read_head(struct mmap_data *md)
+{
+	struct perf_counter_mmap_page *pc = md->base;
+	unsigned int seq, head;
+
+repeat:
+	rmb();
+	seq = pc->lock;
+
+	if (unlikely(seq & 1)) {
+		cpu_relax();
+		goto repeat;
+	}
+
+	head = pc->data_head;
+
+	rmb();
+	if (pc->lock != seq)
+		goto repeat;
+
+	return head;
+}
+
+static void mmap_read(struct mmap_data *md)
+{
+	unsigned int head = mmap_read_head(md);
+	unsigned int old = md->prev;
+	unsigned char *data = md->base + page_size;
+
+	if (head - old > md->mask) {
+		printf("ERROR: failed to keep up with mmap data\n");
+		exit(-1);
+	}
+
+	for (; old != head;) {
+		__u64 *ptr = (__u64 *)&data[old & md->mask];
+		old += sizeof(__u64);
+
+		process_event(*ptr, md->counter);
+	}
+
+	md->prev = old;
+}
+
 int main(int argc, char *argv[])
 {
 	struct pollfd event_array[MAX_NR_CPUS][MAX_COUNTERS];
+	struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 	struct perf_counter_hw_event hw_event;
 	int i, counter, group_fd;
 	unsigned int cpu;
-	uint64_t ip;
-	ssize_t res;
 	int ret;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+
 	process_options(argc, argv);
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -1153,8 +1215,6 @@ int main(int argc, char *argv[])
 			hw_event.record_type	= PERF_RECORD_IRQ;
 			hw_event.nmi		= nmi;
 
-			printf("FOO: %d %llx %llx\n", counter, event_id[counter], event_count[counter]);
-
 			fd[i][counter] = sys_perf_counter_open(&hw_event, tid, cpu, group_fd, 0);
 			fcntl(fd[i][counter], F_SETFL, O_NONBLOCK);
 			if (fd[i][counter] < 0) {
@@ -1174,6 +1234,17 @@ int main(int argc, char *argv[])
 
 			event_array[i][counter].fd = fd[i][counter];
 			event_array[i][counter].events = POLLIN;
+
+			mmap_array[i][counter].counter = counter;
+			mmap_array[i][counter].prev = 0;
+			mmap_array[i][counter].mask = 2*page_size - 1;
+			mmap_array[i][counter].base = mmap(NULL, 3*page_size,
+					PROT_READ, MAP_SHARED, fd[i][counter], 0);
+			if (mmap_array[i][counter].base == MAP_FAILED) {
+				printf("kerneltop error: failed to mmap with %d (%s)\n",
+						errno, strerror(errno));
+				exit(-1);
+			}
 		}
 	}
 
@@ -1188,14 +1259,8 @@ int main(int argc, char *argv[])
 		int hits = events;
 
 		for (i = 0; i < nr_cpus; i++) {
-			for (counter = 0; counter < nr_counters; counter++) {
-				res = read(fd[i][counter], (char *) &ip, sizeof(ip));
-				if (res > 0) {
-					assert(res == sizeof(ip));
-
-					process_event(ip, counter);
-				}
-			}
+			for (counter = 0; counter < nr_counters; counter++)
+				mmap_read(&mmap_array[i][counter]);
 		}
 
 		if (time(NULL) >= last_refresh + delay_secs) {
