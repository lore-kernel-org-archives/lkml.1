Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbZFJPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbZFJPne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZFJPnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:43:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:52825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760172AbZFJPnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:43:22 -0400
Date: Wed, 10 Jun 2009 15:42:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Small frequency related fixes
Message-ID: <tip-4502d77c1d8f15f20c04b92cb96c12d4e465de29@git.kernel.org>
Git-Commit-ID: 4502d77c1d8f15f20c04b92cb96c12d4e465de29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 15:42:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4502d77c1d8f15f20c04b92cb96c12d4e465de29
Gitweb:     http://git.kernel.org/tip/4502d77c1d8f15f20c04b92cb96c12d4e465de29
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 15:03:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 16:55:26 +0200

perf_counter tools: Small frequency related fixes

Create the counter in a disabled state and only enable it after we
mmap() the buffer, this allows us to see the first few samples (and
observe the frequency ramp).

Furthermore, print the period in the verbose report.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/builtin-report.c |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index deaee42..a5698ad 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -347,6 +347,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
+	attr->disabled		= 1;
 
 	track = 0; /* only the first counter needs these */
 
@@ -402,6 +403,8 @@ try_again:
 		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
 		exit(-1);
 	}
+
+	ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_ENABLE);
 }
 
 static void open_counters(int cpu, pid_t pid)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0b18cb9..9a0e31e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -47,6 +47,7 @@ struct ip_event {
 	struct perf_event_header header;
 	__u64 ip;
 	__u32 pid, tid;
+	__u64 period;
 };
 
 struct mmap_event {
@@ -943,12 +944,13 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	uint64_t ip = event->ip.ip;
 	struct map *map = NULL;
 
-	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
+	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
 		event->ip.pid,
-		(void *)(long)ip);
+		(void *)(long)ip,
+		(long long)event->ip.period);
 
 	dprintf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
