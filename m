Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZE0JH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZE0JH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbZE0JHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:07:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:55970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbZE0JHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:07:13 -0400
Date: Wed, 27 May 2009 09:06:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add built-in pager support
Message-ID: <tip-a930d2c0d0a685ab955472b08baad041cc5edb4a@git.kernel.org>
Git-Commit-ID: a930d2c0d0a685ab955472b08baad041cc5edb4a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 09:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a930d2c0d0a685ab955472b08baad041cc5edb4a
Gitweb:     http://git.kernel.org/tip/a930d2c0d0a685ab955472b08baad041cc5edb4a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 09:50:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:59:00 +0200

perf_counter tools: Add built-in pager support

Add Git's pager.c (and sigchain) code. A command only
has to call setup_pager() to get paged interactive
output.

Non-interactive (redirected, command-piped, etc.) uses
are not affected.

Update perf-report to make use of this.

[ Impact: new feature ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile           |    4 +
 Documentation/perf_counter/builtin-report.c   |    3 +
 Documentation/perf_counter/util/environment.c |    8 ++
 Documentation/perf_counter/util/pager.c       |   99 +++++++++++++++++++++++++
 Documentation/perf_counter/util/sigchain.c    |   52 +++++++++++++
 Documentation/perf_counter/util/sigchain.h    |   11 +++
 6 files changed, 177 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index efb0589..51b13f9 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -297,11 +297,13 @@ LIB_H += util/util.h
 LIB_H += util/help.h
 LIB_H += util/strbuf.h
 LIB_H += util/run-command.h
+LIB_H += util/sigchain.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
 LIB_OBJS += util/config.o
 LIB_OBJS += util/ctype.o
+LIB_OBJS += util/environment.o
 LIB_OBJS += util/exec_cmd.o
 LIB_OBJS += util/help.o
 LIB_OBJS += util/levenshtein.o
@@ -314,6 +316,8 @@ LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
 LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
+LIB_OBJS += util/sigchain.o
+LIB_OBJS += util/pager.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-record.o
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index e2712cd..9aef7c5 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -7,6 +7,7 @@
 #include <ctype.h>
 
 #include "util/list.h"
+#include "util/cache.h"
 #include "util/rbtree.h"
 
 #include "perf.h"
@@ -992,5 +993,7 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 
 	parse_options(argc, argv, options, report_usage, 0);
 
+	setup_pager();
+
 	return __cmd_report();
 }
diff --git a/Documentation/perf_counter/util/environment.c b/Documentation/perf_counter/util/environment.c
new file mode 100644
index 0000000..9b1c819
--- /dev/null
+++ b/Documentation/perf_counter/util/environment.c
@@ -0,0 +1,8 @@
+/*
+ * We put all the perf config variables in this same object
+ * file, so that programs can link against the config parser
+ * without having to link against all the rest of perf.
+ */
+#include "cache.h"
+
+const char *pager_program;
diff --git a/Documentation/perf_counter/util/pager.c b/Documentation/perf_counter/util/pager.c
new file mode 100644
index 0000000..a28bcca
--- /dev/null
+++ b/Documentation/perf_counter/util/pager.c
@@ -0,0 +1,99 @@
+#include "cache.h"
+#include "run-command.h"
+#include "sigchain.h"
+
+/*
+ * This is split up from the rest of git so that we can do
+ * something different on Windows.
+ */
+
+static int spawned_pager;
+
+#ifndef __MINGW32__
+static void pager_preexec(void)
+{
+	/*
+	 * Work around bug in "less" by not starting it until we
+	 * have real input
+	 */
+	fd_set in;
+
+	FD_ZERO(&in);
+	FD_SET(0, &in);
+	select(1, &in, NULL, &in, NULL);
+
+	setenv("LESS", "FRSX", 0);
+}
+#endif
+
+static const char *pager_argv[] = { "sh", "-c", NULL, NULL };
+static struct child_process pager_process;
+
+static void wait_for_pager(void)
+{
+	fflush(stdout);
+	fflush(stderr);
+	/* signal EOF to pager */
+	close(1);
+	close(2);
+	finish_command(&pager_process);
+}
+
+static void wait_for_pager_signal(int signo)
+{
+	wait_for_pager();
+	sigchain_pop(signo);
+	raise(signo);
+}
+
+void setup_pager(void)
+{
+	const char *pager = getenv("PERF_PAGER");
+
+	if (!isatty(1))
+		return;
+	if (!pager) {
+		if (!pager_program)
+			perf_config(perf_default_config, NULL);
+		pager = pager_program;
+	}
+	if (!pager)
+		pager = getenv("PAGER");
+	if (!pager)
+		pager = "less";
+	else if (!*pager || !strcmp(pager, "cat"))
+		return;
+
+	spawned_pager = 1; /* means we are emitting to terminal */
+
+	/* spawn the pager */
+	pager_argv[2] = pager;
+	pager_process.argv = pager_argv;
+	pager_process.in = -1;
+#ifndef __MINGW32__
+	pager_process.preexec_cb = pager_preexec;
+#endif
+	if (start_command(&pager_process))
+		return;
+
+	/* original process continues, but writes to the pipe */
+	dup2(pager_process.in, 1);
+	if (isatty(2))
+		dup2(pager_process.in, 2);
+	close(pager_process.in);
+
+	/* this makes sure that the parent terminates after the pager */
+	sigchain_push_common(wait_for_pager_signal);
+	atexit(wait_for_pager);
+}
+
+int pager_in_use(void)
+{
+	const char *env;
+
+	if (spawned_pager)
+		return 1;
+
+	env = getenv("PERF_PAGER_IN_USE");
+	return env ? perf_config_bool("PERF_PAGER_IN_USE", env) : 0;
+}
diff --git a/Documentation/perf_counter/util/sigchain.c b/Documentation/perf_counter/util/sigchain.c
new file mode 100644
index 0000000..1118b99
--- /dev/null
+++ b/Documentation/perf_counter/util/sigchain.c
@@ -0,0 +1,52 @@
+#include "sigchain.h"
+#include "cache.h"
+
+#define SIGCHAIN_MAX_SIGNALS 32
+
+struct sigchain_signal {
+	sigchain_fun *old;
+	int n;
+	int alloc;
+};
+static struct sigchain_signal signals[SIGCHAIN_MAX_SIGNALS];
+
+static void check_signum(int sig)
+{
+	if (sig < 1 || sig >= SIGCHAIN_MAX_SIGNALS)
+		die("BUG: signal out of range: %d", sig);
+}
+
+int sigchain_push(int sig, sigchain_fun f)
+{
+	struct sigchain_signal *s = signals + sig;
+	check_signum(sig);
+
+	ALLOC_GROW(s->old, s->n + 1, s->alloc);
+	s->old[s->n] = signal(sig, f);
+	if (s->old[s->n] == SIG_ERR)
+		return -1;
+	s->n++;
+	return 0;
+}
+
+int sigchain_pop(int sig)
+{
+	struct sigchain_signal *s = signals + sig;
+	check_signum(sig);
+	if (s->n < 1)
+		return 0;
+
+	if (signal(sig, s->old[s->n - 1]) == SIG_ERR)
+		return -1;
+	s->n--;
+	return 0;
+}
+
+void sigchain_push_common(sigchain_fun f)
+{
+	sigchain_push(SIGINT, f);
+	sigchain_push(SIGHUP, f);
+	sigchain_push(SIGTERM, f);
+	sigchain_push(SIGQUIT, f);
+	sigchain_push(SIGPIPE, f);
+}
diff --git a/Documentation/perf_counter/util/sigchain.h b/Documentation/perf_counter/util/sigchain.h
new file mode 100644
index 0000000..618083b
--- /dev/null
+++ b/Documentation/perf_counter/util/sigchain.h
@@ -0,0 +1,11 @@
+#ifndef SIGCHAIN_H
+#define SIGCHAIN_H
+
+typedef void (*sigchain_fun)(int);
+
+int sigchain_push(int sig, sigchain_fun f);
+int sigchain_pop(int sig);
+
+void sigchain_push_common(sigchain_fun f);
+
+#endif /* SIGCHAIN_H */
