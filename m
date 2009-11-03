Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZKCEiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZKCEiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZKCEit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:38:49 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60294 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbZKCEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:38:49 -0500
Date: Tue, 03 Nov 2009 13:38:49 +0900 (JST)
Message-Id: <20091103.133849.430771458054376230.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: [RFC][PATCH 6/7] Adding general performance benchmarking subsystem
 to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding general performance benchmarking subsystem to perf.
This patch adds new builtin-bench-messaging.c

builtin-bench-messaging.c is a benchmark program
to measure performance of scheduler and IPC mechanisms.
This benchmark is based on hackbench by Rusty Russell.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-bench-messaging.c |  315 ++++++++++++++++++++++++++++++++++
 1 files changed, 315 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-bench-messaging.c

diff --git a/tools/perf/builtin-bench-messaging.c b/tools/perf/builtin-bench-messaging.c
new file mode 100644
index 0000000..4aa6ae5
--- /dev/null
+++ b/tools/perf/builtin-bench-messaging.c
@@ -0,0 +1,315 @@
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
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "builtin.h"
+#include "bench-suite.h"
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
+	/* Print time... */
+	timersub(&stop, &start, &diff);
+	printf("%lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+
+	return 0;
+}
-- 
1.5.6.5

