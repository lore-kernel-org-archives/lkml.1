Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZKVIob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZKVIob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbZKVIo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:44:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:44565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbZKVIoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:44:25 -0500
Date: Sun, 22 Nov 2009 08:43:48 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258688237-3797-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258688237-3797-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Make the mem/memcpy tests more user-friendly
Message-ID: <tip-12eac0bf0461910ae6dd7f071f156f75461a37cf@git.kernel.org>
Git-Commit-ID: 12eac0bf0461910ae6dd7f071f156f75461a37cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12eac0bf0461910ae6dd7f071f156f75461a37cf
Gitweb:     http://git.kernel.org/tip/12eac0bf0461910ae6dd7f071f156f75461a37cf
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Fri, 20 Nov 2009 12:37:17 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 09:41:06 +0100

perf bench: Make the mem/memcpy tests more user-friendly

mem-memcpy.c uses perf event system calls to obtain CPU clocks.
And it suddenly dies with BUG_ON() when it running on Linux
doesn't support perf event.

Also fail at calloc() can occur easily when too large
length is passed. Fail of calloc() causes sudden death
with assert().

These behaviours are not friendly. So I fixed the treating of
errors.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258688237-3797-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
[ v2: improved a few small details ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/mem-memcpy.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index d4f4f98..5165fd1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -22,9 +22,10 @@
 
 #define K 1024
 
-static const char *length_str = "1MB";
-static const char *routine    = "default";
-static int use_clock = 0;
+static const char	*length_str	= "1MB";
+static const char	*routine	= "default";
+static int		use_clock	= 0;
+static int		clock_fd;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -57,17 +58,19 @@ static const char * const bench_mem_memcpy_usage[] = {
 	NULL
 };
 
-static int clock_fd;
-
 static struct perf_event_attr clock_attr = {
-	.type = PERF_TYPE_HARDWARE,
-	.config = PERF_COUNT_HW_CPU_CYCLES
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES
 };
 
 static void init_clock(void)
 {
 	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
-	BUG_ON(clock_fd < 0);
+
+	if (clock_fd < 0 && errno == ENOSYS)
+		die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
+	else
+		BUG_ON(clock_fd < 0);
 }
 
 static u64 get_clock(void)
@@ -104,7 +107,8 @@ int bench_mem_memcpy(int argc, const char **argv,
 	tv_diff.tv_sec = 0;
 	tv_diff.tv_usec = 0;
 	length = (size_t)perf_atoll((char *)length_str);
-	if ((long long int)length <= 0) {
+
+	if ((s64)length <= 0) {
 		fprintf(stderr, "Invalid length:%s\n", length_str);
 		return 1;
 	}
@@ -124,9 +128,12 @@ int bench_mem_memcpy(int argc, const char **argv,
 	}
 
 	dst = calloc(length, sizeof(char));
-	assert(dst);
+	if (!dst)
+		die("memory allocation failed - maybe length is too large?\n");
+
 	src = calloc(length, sizeof(char));
-	assert(src);
+	if (!src)
+		die("memory allocation failed - maybe length is too large?\n");
 
 	if (bench_format == BENCH_FORMAT_DEFAULT) {
 		printf("# Copying %s Bytes from %p to %p ...\n\n",
@@ -136,8 +143,9 @@ int bench_mem_memcpy(int argc, const char **argv,
 	if (use_clock) {
 		init_clock();
 		clock_start = get_clock();
-	} else
+	} else {
 		BUG_ON(gettimeofday(&tv_start, NULL));
+	}
 
 	routines[i].fn(dst, src, length);
 
@@ -176,9 +184,8 @@ int bench_mem_memcpy(int argc, const char **argv,
 			printf("%lf\n", bps);
 		break;
 	default:
-		/* reaching here is something disaster */
-		fprintf(stderr, "Unknown format:%d\n", bench_format);
-		exit(1);
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
 		break;
 	}
 
