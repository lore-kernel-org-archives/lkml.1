Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZKPVMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZKPVMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZKPVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:12:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:39080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZKPVMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:12:51 -0500
Date: Mon, 16 Nov 2009 21:10:50 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258396365-29217-5-git-send-email-acme@infradead.org>
References: <1258396365-29217-5-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-list: New plumbing command
Message-ID: <tip-c34984b2bbc77596c97c333539bffc90d2033178@git.kernel.org>
Git-Commit-ID: c34984b2bbc77596c97c333539bffc90d2033178
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c34984b2bbc77596c97c333539bffc90d2033178
Gitweb:     http://git.kernel.org/tip/c34984b2bbc77596c97c333539bffc90d2033178
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 16:32:45 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 22:05:51 +0100

perf buildid-list: New plumbing command

With this we can list the buildids in a perf.data file so that
we can pipe them to other, distro specific tools that from the
buildids can figure out separate packages (foo-debuginfo) where
we can find the matching symtabs so that perf report can do its
job.

E.g:

[acme@doppio linux-2.6-tip]$ perf buildid-list | head -5
8e08b117e5458ad3f85da16d42d0fc5cd21c5869
520c2387a587cc5acfcf881e27dba1caaeab4b1f
ec8dd400904ddfcac8b1c343263a790f977159dc
7caedbca5a6d8ab39a7fe44bd28c07d3e14a3f3f
379bb828fd08859dbea73279f04abefabc95a6a3
[acme@doppio linux-2.6-tip]$ perf buildid-list -v | head -5
8e08b117e5458ad3f85da16d42d0fc5cd21c5869 /sbin/init
520c2387a587cc5acfcf881e27dba1caaeab4b1f /lib64/ld-2.10.1.so
ec8dd400904ddfcac8b1c343263a790f977159dc /lib64/libc-2.10.1.so
7caedbca5a6d8ab39a7fe44bd28c07d3e14a3f3f /sbin/udevd
379bb828fd08859dbea73279f04abefabc95a6a3 /lib64/libdl-2.10.1.so
[acme@doppio linux-2.6-tip]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258396365-29217-5-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-buildid-list.txt |   34 +++++++
 tools/perf/Makefile                            |    1 +
 tools/perf/builtin-buildid-list.c              |  116 ++++++++++++++++++++++++
 tools/perf/builtin.h                           |    1 +
 tools/perf/command-list.txt                    |    1 +
 tools/perf/perf.c                              |    1 +
 6 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
new file mode 100644
index 0000000..abab34e
--- /dev/null
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -0,0 +1,34 @@
+perf-buildid-list(1)
+====================
+
+NAME
+----
+perf-buildid-list - List the buildids in a perf.data file
+
+SYNOPSIS
+--------
+[verse]
+'perf buildid-list <options>'
+
+DESCRIPTION
+-----------
+This command displays the buildids found in a perf.data file, so that other
+tools can be used to fetch packages with matching symbol tables for use by
+perf report.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Input file name. (default: perf.data)
+-f::
+--force::
+	Don't do ownership validation.
+-v::
+--verbose::
+	Be more verbose, showing the name of the DSOs after the buildids.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-top[1],
+linkperf:perf-report[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7cd896..46a58a8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,6 +430,7 @@ BUILTIN_OBJS += bench/sched-pipe.o
 
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
+BUILTIN_OBJS += builtin-buildid-list.o
 BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
new file mode 100644
index 0000000..2e377e1
--- /dev/null
+++ b/tools/perf/builtin-buildid-list.c
@@ -0,0 +1,116 @@
+/*
+ * builtin-buildid-list.c
+ *
+ * Builtin buildid-list command: list buildids in perf.data
+ *
+ * Copyright (C) 2009, Red Hat Inc.
+ * Copyright (C) 2009, Arnaldo Carvalho de Melo <acme@redhat.com>
+ */
+#include "builtin.h"
+#include "perf.h"
+#include "util/cache.h"
+#include "util/data_map.h"
+#include "util/debug.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/symbol.h"
+
+static char const *input_name = "perf.data";
+static int force;
+
+static const char *const buildid_list_usage[] = {
+	"perf report [<options>]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show counter open errors, etc)"),
+	OPT_END()
+};
+
+static int perf_file_section__process_buildids(struct perf_file_section *self,
+					       int feat, int fd)
+{
+	if (feat != HEADER_BUILD_ID)
+		return 0;
+
+	if (lseek(fd, self->offset, SEEK_SET) < 0) {
+		pr_warning("Failed to lseek to %Ld offset for buildids!\n",
+			   self->offset);
+		return -1;
+	}
+
+	if (perf_header__read_build_ids(fd, self->offset, self->size)) {
+		pr_warning("Failed to read buildids!\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __cmd_buildid_list(void)
+{
+	int err = -1;
+	struct perf_header *header;
+	struct perf_file_header f_header;
+	struct stat input_stat;
+	int input = open(input_name, O_RDONLY);
+
+	if (input < 0) {
+		pr_err("failed to open file: %s", input_name);
+		if (!strcmp(input_name, "perf.data"))
+			pr_err("  (try 'perf record' first)");
+		pr_err("\n");
+		goto out;
+	}
+
+	err = fstat(input, &input_stat);
+	if (err < 0) {
+		perror("failed to stat file");
+		goto out_close;
+	}
+
+	if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {
+		pr_err("file %s not owned by current user or root\n",
+		       input_name);
+		goto out_close;
+	}
+
+	if (!input_stat.st_size) {
+		pr_info("zero-sized file, nothing to do!\n");
+		goto out_close;
+	}
+
+	err = -1;
+	header = perf_header__new();
+	if (header == NULL)
+		goto out_close;
+
+	if (perf_file_header__read(&f_header, header, input) < 0) {
+		pr_warning("incompatible file format");
+		goto out_close;
+	}
+
+	err = perf_header__process_sections(header, input,
+				         perf_file_section__process_buildids);
+
+	if (err < 0)
+		goto out_close;
+
+	dsos__fprintf_buildid(stdout);
+out_close:
+	close(input);
+out:
+	return err;
+}
+
+int cmd_buildid_list(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, options, buildid_list_usage, 0);
+	setup_pager();
+	return __cmd_buildid_list();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index f0cd5b1..e97954a 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -16,6 +16,7 @@ extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_bench(int argc, const char **argv, const char *prefix);
+extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 981c40b..d37b16c 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -4,6 +4,7 @@
 #
 perf-annotate			mainporcelain common
 perf-bench			mainporcelain common
+perf-buildid-list		mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
 perf-record			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 8936786..53359eb 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -287,6 +287,7 @@ static void handle_internal_command(int argc, const char **argv)
 	static struct cmd_struct commands[] = {
 		{ "help", cmd_help, 0 },
 		{ "list", cmd_list, 0 },
+		{ "buildid-list", cmd_buildid_list, 0 },
 		{ "record", cmd_record, 0 },
 		{ "report", cmd_report, 0 },
 		{ "bench", cmd_bench, 0 },
