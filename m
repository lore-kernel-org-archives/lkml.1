Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZKBNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZKBNva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZKBNv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:51:29 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53323 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZKBNv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:51:28 -0500
Date: Mon, 02 Nov 2009 22:51:29 +0900 (JST)
Message-Id: <20091102.225129.149607581235026541.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       acme@redhat.com, fweisbec@gmail.com, efault@gmx.de
Subject: [PATCH][RFC] Adding benchmark subsystem to perf
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <200911022357.36541.rusty@rustcorp.com.au>
References: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp>
	<20091102104124.GA5193@elte.hu>
	<200911022357.36541.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH][RFC] Adding hackbench.c to tools/
Date: Mon, 2 Nov 2009 23:57:36 +1030

> ,
>  Arnaldo Carvalho de Melo <acme@redhat.com>,
>  Frédéric_Weisbecker <fweisbec@gmail.com>,
>  Mike Galbraith <efault@gmx.de>
> Date: Mon, 2 Nov 2009 23:57:36 +1030
> User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
> 
> On Mon, 2 Nov 2009 09:11:24 pm Ingo Molnar wrote:
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > It seems that hackbench is the de-fact standard benchmarking program 
> > > for scheduler of Linux. But when I ask google where hackbench.c is, 
> > > some answers are replied. Like these, (in order of google result)
> > > 
> > > http://devresources.linux-foundation.org/craiger/hackbench/ (this page 
> > > containts link to hackbench.c) 
> > > http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> > > 
> > > And it seems that second one is newer.
> > > 
> > > I think this situation is very confusable. So I wrote this patch to 
> > > add hackbench to tools/ of kernel tree. This may help hackbench users 
> > > like me.
> > 
> > I think we can do something nicer: would you be interested in adding it 
> > as a 'perf bench hackbench' sub-command of tools/perf/?
> > 
> > We already have the tools to measure scheduling behavior under 'perf 
> > sched', so having a 'perf bench' array of common tests would be nice to 
> > have.
> > 
> > ( I've Cc:-ed Rusty, the original author of hackbench.c. Rusty, the file 
> >   has no explicit GPLv2 compatible license - is it fine to be put
> >   into GPLv2 code? )

I should send the mail to Rusty too. Sorry.

> 
> Yep, like all my code it's standard v2 "or later".
> 
> Sounds like a good plan, thanks!
> Rusty.
> 

Thanks for your permission!
I wrote a patch. This adds builtin-bench.c and its document
perf-bench.txt to tools/perf/Documentation/.

How about this?

--- below is the patch and description ---

Adding general performance benchmarking subsystem and its document to perf.
This provides benchmark for scheduler based on Rusty Russel's hackbench.

New hackbench this patch containts has little improvements.
1) Output
   Output is single float value, with out "Time: " string.
   I believe this is more friendly form for processing by script languages.

2) Option processing
   I don't like original option processing of hackbench,
   because it requires -pipe when I want to specify num of groups.
   I rewrote option processing with getopt_long().

Example of usage:
% perf bench sched -t -l 1000
2.863

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
new file mode 100644
index 0000000..88f9451
--- /dev/null
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -0,0 +1,49 @@
+perf-bench(1)
+==============
+
+NAME
+----
+perf-bench - General benchmarking subsystem provided by perf
+
+SYNOPSIS
+--------
+[verse]
+'perf bench' <subsystem> [<options>]
+
+DESCRIPTION
+-----------
+This command measures performance of various kernel subsystems.
+
+This is the list of supported subsystems:
+
+'sched': Scheduler and IPC mechanisms. Result is time and printed to
+standard output. This benchmark is based on hackbench.
+
+OPTIONS
+-------
+
+<subsystem>::
+	Specify subsystem.
+
+'sched' specific
+----------------
+
+-p::
+--pipe::
+	Use pipe() instead of socketpair().
+
+-t::
+--thread::
+	Be multi thread instead of multi process.
+
+-g <number of groups>::
+--group=<number of groups>::
+	Specify number of groups.
+
+-l <number of loops>::
+--loop=<number of loops>::
+	Specify number of loops.
+
+SEE ALSO
+--------
+linkperf:perf-stat[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 742a32e..6786f0f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -392,6 +392,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
+BUILTIN_OBJS += builtin-bench.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
new file mode 100644
index 0000000..8d139d1
--- /dev/null
+++ b/tools/perf/builtin-bench.c
@@ -0,0 +1,355 @@
+/*
+ *
+ * builtin-bench.c
+ *
+ * General benchmarking subsystem provided by perf
+ *
+ * Based on hackbench by Rusty Russell <rusty@rustcorp.com.au>
+ * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *
+ */
+
+/*
+ *
+ * Available benchmarking list:
+ *  sched ... evaluating performance of scheduler and IPC mechanism
+ *
+ */
+
+#include "perf.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "builtin.h"
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
+#include <assert.h>
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
+static const char * const bench_sched_usage[] = {
+	"perf bench sched <options>",
+	NULL
+};
+
+static int cmd_bench_sched(int argc, const char **argv,
+			   const char *prefix __used)
+{
+	unsigned int i, total_children;
+	struct timeval start, stop, diff;
+	unsigned int num_fds = 20;
+	int readyfds[2], wakefds[2];
+	char dummy;
+	pthread_t *pth_tab;
+
+	argc = parse_options(argc, argv, options, bench_sched_usage, 0);
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
+
+struct bench_subsys {
+	const char *name;
+	int (*fn)(int, const char **, const char *);
+};
+
+static struct bench_subsys subsys_array[] = {
+	{ "sched", cmd_bench_sched },
+	{ NULL, NULL }
+};
+
+int cmd_bench(int argc, const char **argv, const char *prefix __used)
+{
+	int i, status = 0;
+
+	if (argc < 2) {
+		printf("Usage: perf bench <subsystem> [<options>]\n");
+		goto end;
+	}
+
+	for (i = 0; subsys_array[i].name; i++) {
+		if (!strcmp(subsys_array[i].name, argv[1])) {
+			status = subsys_array[i].fn(argc--, argv++, prefix);
+			goto end;
+		}
+	}
+
+	/* No subsystem matched. */
+	fprintf(stderr, "Unknown subsystem:%s\n", argv[0]);
+	status = 1;
+
+end:
+	return status;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index e11d8d2..b346b66 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -25,5 +25,6 @@ extern int cmd_timechart(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
+extern int cmd_bench(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 19fc7fe..9e7b48c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -295,6 +295,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
 		{ "sched", cmd_sched, 0 },
+		{ "bench", cmd_bench, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
