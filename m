Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZKHJZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZKHJZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZKHJZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:25:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:34937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZKHJZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:25:45 -0500
Date: Sun, 8 Nov 2009 09:25:03 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       efault@gmx.de, mitake@dcl.info.waseda.ac.jp, jkosina@suse.cz,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       jkosina@suse.cz, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/bench] perf bench: Add sched-messaging.c: Benchmark for scheduler and IPC mechanisms based on hackbench
Message-ID: <tip-e27454cc6352c4226ddc76f5e3a5dedd7dff456a@git.kernel.org>
Git-Commit-ID: e27454cc6352c4226ddc76f5e3a5dedd7dff456a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e27454cc6352c4226ddc76f5e3a5dedd7dff456a
Gitweb:     http://git.kernel.org/tip/e27454cc6352c4226ddc76f5e3a5dedd7dff456a
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Thu, 5 Nov 2009 09:31:32 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:19:17 +0100

perf bench: Add sched-messaging.c: Benchmark for scheduler and IPC mechanisms based on hackbench

This patch adds bench/sched-messaging.c.

This benchmark measures performance of scheduler and IPC
mechanisms, and is based on hackbench by Rusty Russell.

Example of usage:

  % perf bench sched messaging -g 20 -l 1000 -s
  5.432  	  	       	    	    	     # in sec

  % perf bench sched messaging                 # run with default
  options (20 sender and receiver processes per group)
  (10 groups == 400 processes run)

        Total time:0.308 sec

  % perf bench sched messaging -t -g 20	     # # be multi-thread,
  with 20 groups (20 sender and receiver threads per group)
  (20 groups == 800 threads run)

        Total time:0.582 sec

( Rusty is the original author of hackbench.c and he said the code is
  and was under the GPLv2 so fine to be merged. )

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1257381097-4743-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-messaging.c |  332 ++++++++++++++++++++++++++++++++++++
 1 files changed, 332 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
new file mode 100644
index 0000000..36b62c5
--- /dev/null
+++ b/tools/perf/bench/sched-messaging.c
@@ -0,0 +1,332 @@
+/*
+ *
+ * builtin-bench-messaging.c
+ *
+ * messaging: Benchmark for scheduler and IPC mechanisms
+ *
+ * Based on hackbench by Rusty Russell <rusty@rustcorp.com.au>
+ * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../builtin.h"
+#include "bench.h"
+
+/* Test groups of 20 processes spraying to 20 receivers */
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/poll.h>
+#include <limits.h>
+
+#define DATASIZE 100
+
+static int use_pipes = 0;
+static unsigned int loops = 100;
+static unsigned int thread_mode = 0;
+static unsigned int num_groups = 10;
+static int simple = 0;
+
+struct sender_context {
+	unsigned int num_fds;
+	int ready_out;
+	int wakefd;
+	int out_fds[0];
+};
+
+struct receiver_context {
+	unsigned int num_packets;
+	int in_fds[2];
+	int ready_out;
+	int wakefd;
+};
+
+static void barf(const char *msg)
+{
+	fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
+	exit(1);
+}
+
+static void fdpair(int fds[2])
+{
+	if (use_pipes) {
+		if (pipe(fds) == 0)
+			return;
+	} else {
+		if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == 0)
+			return;
+	}
+
+	barf(use_pipes ? "pipe()" : "socketpair()");
+}
+
+/* Block until we're ready to go */
+static void ready(int ready_out, int wakefd)
+{
+	char dummy;
+	struct pollfd pollfd = { .fd = wakefd, .events = POLLIN };
+
+	/* Tell them we're ready. */
+	if (write(ready_out, &dummy, 1) != 1)
+		barf("CLIENT: ready write");
+
+	/* Wait for "GO" signal */
+	if (poll(&pollfd, 1, -1) != 1)
+		barf("poll");
+}
+
+/* Sender sprays loops messages down each file descriptor */
+static void *sender(struct sender_context *ctx)
+{
+	char data[DATASIZE];
+	unsigned int i, j;
+
+	ready(ctx->ready_out, ctx->wakefd);
+
+	/* Now pump to every receiver. */
+	for (i = 0; i < loops; i++) {
+		for (j = 0; j < ctx->num_fds; j++) {
+			int ret, done = 0;
+
+again:
+			ret = write(ctx->out_fds[j], data + done,
+				    sizeof(data)-done);
+			if (ret < 0)
+				barf("SENDER: write");
+			done += ret;
+			if (done < DATASIZE)
+				goto again;
+		}
+	}
+
+	return NULL;
+}
+
+
+/* One receiver per fd */
+static void *receiver(struct receiver_context* ctx)
+{
+	unsigned int i;
+
+	if (!thread_mode)
+		close(ctx->in_fds[1]);
+
+	/* Wait for start... */
+	ready(ctx->ready_out, ctx->wakefd);
+
+	/* Receive them all */
+	for (i = 0; i < ctx->num_packets; i++) {
+		char data[DATASIZE];
+		int ret, done = 0;
+
+again:
+		ret = read(ctx->in_fds[0], data + done, DATASIZE - done);
+		if (ret < 0)
+			barf("SERVER: read");
+		done += ret;
+		if (done < DATASIZE)
+			goto again;
+	}
+
+	return NULL;
+}
+
+static pthread_t create_worker(void *ctx, void *(*func)(void *))
+{
+	pthread_attr_t attr;
+	pthread_t childid;
+	int err;
+
+	if (!thread_mode) {
+		/* process mode */
+		/* Fork the receiver. */
+		switch (fork()) {
+		case -1:
+			barf("fork()");
+			break;
+		case 0:
+			(*func) (ctx);
+			exit(0);
+			break;
+		default:
+			break;
+		}
+
+		return (pthread_t)0;
+	}
+
+	if (pthread_attr_init(&attr) != 0)
+		barf("pthread_attr_init:");
+
+#ifndef __ia64__
+	if (pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN) != 0)
+		barf("pthread_attr_setstacksize");
+#endif
+
+	err = pthread_create(&childid, &attr, func, ctx);
+	if (err != 0) {
+		fprintf(stderr, "pthread_create failed: %s (%d)\n",
+			strerror(err), err);
+		exit(-1);
+	}
+	return childid;
+}
+
+static void reap_worker(pthread_t id)
+{
+	int proc_status;
+	void *thread_status;
+
+	if (!thread_mode) {
+		/* process mode */
+		wait(&proc_status);
+		if (!WIFEXITED(proc_status))
+			exit(1);
+	} else {
+		pthread_join(id, &thread_status);
+	}
+}
+
+/* One group of senders and receivers */
+static unsigned int group(pthread_t *pth,
+		unsigned int num_fds,
+		int ready_out,
+		int wakefd)
+{
+	unsigned int i;
+	struct sender_context *snd_ctx = malloc(sizeof(struct sender_context)
+			+ num_fds * sizeof(int));
+
+	if (!snd_ctx)
+		barf("malloc()");
+
+	for (i = 0; i < num_fds; i++) {
+		int fds[2];
+		struct receiver_context *ctx = malloc(sizeof(*ctx));
+
+		if (!ctx)
+			barf("malloc()");
+
+
+		/* Create the pipe between client and server */
+		fdpair(fds);
+
+		ctx->num_packets = num_fds * loops;
+		ctx->in_fds[0] = fds[0];
+		ctx->in_fds[1] = fds[1];
+		ctx->ready_out = ready_out;
+		ctx->wakefd = wakefd;
+
+		pth[i] = create_worker(ctx, (void *)receiver);
+
+		snd_ctx->out_fds[i] = fds[1];
+		if (!thread_mode)
+			close(fds[0]);
+	}
+
+	/* Now we have all the fds, fork the senders */
+	for (i = 0; i < num_fds; i++) {
+		snd_ctx->ready_out = ready_out;
+		snd_ctx->wakefd = wakefd;
+		snd_ctx->num_fds = num_fds;
+
+		pth[num_fds+i] = create_worker(snd_ctx, (void *)sender);
+	}
+
+	/* Close the fds we have left */
+	if (!thread_mode)
+		for (i = 0; i < num_fds; i++)
+			close(snd_ctx->out_fds[i]);
+
+	/* Return number of children to reap */
+	return num_fds * 2;
+}
+
+static const struct option options[] = {
+	OPT_BOOLEAN('p', "pipe", &use_pipes,
+		    "Use pipe() instead of socketpair()"),
+	OPT_BOOLEAN('t', "thread", &thread_mode,
+		    "Be multi thread instead of multi process"),
+	OPT_INTEGER('g', "group", &num_groups,
+		    "Specify number of groups"),
+	OPT_INTEGER('l', "loop", &loops,
+		    "Specify number of loops"),
+	OPT_BOOLEAN('s', "simple-output", &simple,
+		    "Do simple output (this maybe useful for"
+		    "processing by scripts or graph tools like gnuplot)"),
+	OPT_END()
+};
+
+static const char * const bench_sched_message_usage[] = {
+	"perf bench sched messaging <options>",
+	NULL
+};
+
+int bench_sched_messaging(int argc, const char **argv,
+		    const char *prefix __used)
+{
+	unsigned int i, total_children;
+	struct timeval start, stop, diff;
+	unsigned int num_fds = 20;
+	int readyfds[2], wakefds[2];
+	char dummy;
+	pthread_t *pth_tab;
+
+	argc = parse_options(argc, argv, options,
+			     bench_sched_message_usage, 0);
+
+	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
+	if (!pth_tab)
+		barf("main:malloc()");
+
+	fdpair(readyfds);
+	fdpair(wakefds);
+
+	total_children = 0;
+	for (i = 0; i < num_groups; i++)
+		total_children += group(pth_tab+total_children, num_fds,
+					readyfds[1], wakefds[0]);
+
+	/* Wait for everyone to be ready */
+	for (i = 0; i < total_children; i++)
+		if (read(readyfds[0], &dummy, 1) != 1)
+			barf("Reading for readyfds");
+
+	gettimeofday(&start, NULL);
+
+	/* Kick them off */
+	if (write(wakefds[1], &dummy, 1) != 1)
+		barf("Writing to start them");
+
+	/* Reap them all */
+	for (i = 0; i < total_children; i++)
+		reap_worker(pth_tab[i]);
+
+	gettimeofday(&stop, NULL);
+
+	timersub(&stop, &start, &diff);
+
+	if (simple)
+		printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+	else {
+		printf("(%d sender and receiver %s per group)\n",
+		       num_fds, thread_mode ? "threads" : "processes");
+		printf("(%d groups == %d %s run)\n\n",
+		       num_groups, num_groups * 2 * num_fds,
+		       thread_mode ? "threads" : "processes");
+		printf("\tTotal time:%lu.%03lu sec\n",
+		       diff.tv_sec, diff.tv_usec/1000);
+	}
+
+	return 0;
+}
