Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbZKAEK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbZKAEK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 00:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbZKAEKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 00:10:25 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:54680 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZKAEKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 00:10:25 -0400
Date: Sun, 01 Nov 2009 13:10:27 +0900 (JST)
Message-Id: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Adding hackbench.c to tools/
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

It seems that hackbench is the de-fact standard benchmarking program for scheduler of Linux.
But when I ask google where hackbench.c is,
some answers are replied. Like these, (in order of google result)

http://devresources.linux-foundation.org/craiger/hackbench/ (this page containts link to hackbench.c)
http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c

And it seems that second one is newer.

I think this situation is very confusable.
So I wrote this patch to add hackbench to tools/ of kernel tree.
This may help hackbench users like me.

And hackbench this patch contains has little improvements.
1) Output
   Output is single float value, with out "Time: " string.
   I believe this is more friendly form for processing by script languages.

2) Option processing
   I don't like original option processing of hackbench,
   because it requires -pipe when I want to specify num of groups.
   I rewrote option processing with getopt_long().

3) checkpatch.pl friendly

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>


diff --git a/tools/hackbench/Makefile b/tools/hackbench/Makefile
new file mode 100644
index 0000000..11da1b6
--- /dev/null
+++ b/tools/hackbench/Makefile
@@ -0,0 +1,3 @@
+
+hackbench: hackbench.c
+	gcc -o hackbench hackbench.c -lpthread -Wall -O2
diff --git a/tools/hackbench/hackbench.c b/tools/hackbench/hackbench.c
new file mode 100644
index 0000000..3790d36
--- /dev/null
+++ b/tools/hackbench/hackbench.c
@@ -0,0 +1,337 @@
+/*
+ * hackbench.c
+ *
+ * Test program for measuring performance of
+ * scheduler and unix-socket (or pipe).
+ */
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
+#define _GNU_SOURCE
+#include <getopt.h>
+
+#define DATASIZE 100
+static unsigned int loops = 100;
+/*
+ * 0 means thread mode and others mean process (default)
+ */
+static unsigned int process_mode = 1;
+
+static int use_pipes;		       /* default:0 */
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
+
+static void barf(const char *msg)
+{
+	fprintf(stderr, "%s (error: %s)\n", msg, strerror(errno));
+	exit(1);
+}
+
+static void print_usage_exit(void)
+{
+	printf("Usage: hackbench <option list>\n");
+	printf("\tlist of available options...\n");
+	printf("\t-p | --pipe\t\t: Use pipe() instead of socketpair()\n");
+	printf("\t-t | --thread\t\t: Be multi thread instead of"
+	       "multi process\n");
+	printf("\t-g | --group <num>\t: Specify number of groups\n");
+	printf("\t-l | --loops <num>\t: Specify number of loops\n");
+	printf("\t-h | --help\t\t: Print this help\n");
+
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
+	barf("Creating fdpair");
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
+			if (done < sizeof(data))
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
+	if (process_mode)
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
+pthread_t create_worker(void *ctx, void *(*func)(void *))
+{
+	pthread_attr_t attr;
+	pthread_t childid;
+	int err;
+
+	if (process_mode) {
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
+		}
+
+		return (pthread_t) 0;
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
+void reap_worker(pthread_t id)
+{
+	int status;
+
+	if (process_mode) {
+		/* process mode */
+		wait(&status);
+		if (!WIFEXITED(status))
+			exit(1);
+	} else {
+		void *status;
+
+		pthread_join(id, &status);
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
+		ctx->num_packets = num_fds*loops;
+		ctx->in_fds[0] = fds[0];
+		ctx->in_fds[1] = fds[1];
+		ctx->ready_out = ready_out;
+		ctx->wakefd = wakefd;
+
+		pth[i] = create_worker(ctx, (void *)(void *)receiver);
+
+		snd_ctx->out_fds[i] = fds[1];
+		if (process_mode)
+			close(fds[0]);
+	}
+
+	/* Now we have all the fds, fork the senders */
+	for (i = 0; i < num_fds; i++) {
+		snd_ctx->ready_out = ready_out;
+		snd_ctx->wakefd = wakefd;
+		snd_ctx->num_fds = num_fds;
+
+		pth[num_fds+i] = create_worker(snd_ctx, (void *)(void *)sender);
+	}
+
+	/* Close the fds we have left */
+	if (process_mode)
+		for (i = 0; i < num_fds; i++)
+			close(snd_ctx->out_fds[i]);
+
+	/* Return number of children to reap */
+	return num_fds * 2;
+}
+
+struct option longopts[] = {
+	{ "pipe", no_argument, NULL, 'p'},
+	{ "thread", no_argument, NULL, 't'},
+	{ "group", required_argument, NULL, 'g'},
+	{ "loop", required_argument, NULL, 'l'},
+	{ "help", no_argument, NULL, 'h'},
+	{ NULL, 0, NULL, 0 }
+};
+
+int main(int argc, char *argv[])
+{
+	unsigned int i, num_groups = 10, total_children;
+	struct timeval start, stop, diff;
+	unsigned int num_fds = 20;
+	int readyfds[2], wakefds[2];
+	char dummy;
+	pthread_t *pth_tab;
+
+	int opt;
+	extern char *optarg;
+
+	while ((opt = getopt_long(argc, argv, "ptg:l:h", longopts, NULL))
+	       != -1) {
+		switch (opt) {
+		case 'p':
+			use_pipes = 1;
+			break;
+		case 't':
+			process_mode = 0;
+			break;
+		case 'g':
+			num_groups = atoi(optarg);
+			break;
+		case 'l':
+			loops = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			print_usage_exit();
+			exit(1);
+			break;
+		}
+	}
+
+	pth_tab = malloc(num_fds * 2 * num_groups * sizeof(pthread_t));
+
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
+	exit(0);
+}
