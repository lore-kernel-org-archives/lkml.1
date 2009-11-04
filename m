Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZKDP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZKDP0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZKDPZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:25:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:57300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbZKDPZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:25:38 -0500
Date: Wed, 4 Nov 2009 15:25:16 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091104001229.3454.63987.stgit@harusame>
References: <20091104001229.3454.63987.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Fall back to non-dwarf if possible
Message-ID: <tip-a225a1d911f0e434dc0407df29fd08e4388f3fa4@git.kernel.org>
Git-Commit-ID: a225a1d911f0e434dc0407df29fd08e4388f3fa4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a225a1d911f0e434dc0407df29fd08e4388f3fa4
Gitweb:     http://git.kernel.org/tip/a225a1d911f0e434dc0407df29fd08e4388f3fa4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 3 Nov 2009 19:12:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:02:47 +0100

perf/probes: Fall back to non-dwarf if possible

Fall back to non-dwarf probe point if the probe definition may
not need dwarf analysis, when perf can't find vmlinux/debuginfo.
This might skip some inlined code of target function.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091104001229.3454.63987.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   64 ++++++++++++++++++++++-----------------
 tools/perf/util/probe-finder.c |    6 ++-
 2 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 65bcaed..d111a93 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -189,7 +189,7 @@ static void parse_probe_event(const char *str)
 	/* Parse probe point */
 	parse_probe_point(argv[0], pp);
 	free(argv[0]);
-	if (pp->file)
+	if (pp->file || pp->line)
 		session.need_dwarf = 1;
 
 	/* Copy arguments */
@@ -347,36 +347,24 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if (session.nr_probe == 0)
 		usage_with_options(probe_usage, options);
 
-#ifdef NO_LIBDWARF
 	if (session.need_dwarf)
-		semantic_error("Dwarf-analysis is not supported");
-#endif
-
-	/* Synthesize probes without dwarf */
-	for (j = 0; j < session.nr_probe; j++) {
-#ifndef NO_LIBDWARF
-		if (!session.probes[j].retprobe) {
-			session.need_dwarf = 1;
-			continue;
-		}
-#endif
-		ret = synthesize_probe_event(&session.probes[j]);
-		if (ret == -E2BIG)
-			semantic_error("probe point is too long.");
-		else if (ret < 0)
-			die("Failed to synthesize a probe point.");
-	}
-
-#ifndef NO_LIBDWARF
-	if (!session.need_dwarf)
-		goto setup_probes;
+#ifdef NO_LIBDWARF
+		semantic_error("Debuginfo-analysis is not supported");
+#else	/* !NO_LIBDWARF */
+		pr_info("Some probes require debuginfo.\n");
 
 	if (session.vmlinux)
 		fd = open(session.vmlinux, O_RDONLY);
 	else
 		fd = open_default_vmlinux();
-	if (fd < 0)
-		die("Could not open vmlinux/module file.");
+	if (fd < 0) {
+		if (session.need_dwarf)
+			die("Could not open vmlinux/module file.");
+
+		pr_warning("Could not open vmlinux/module file."
+			   " Try to use symbols.\n");
+		goto end_dwarf;
+	}
 
 	/* Searching probe points */
 	for (j = 0; j < session.nr_probe; j++) {
@@ -386,14 +374,34 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 		lseek(fd, SEEK_SET, 0);
 		ret = find_probepoint(fd, pp);
-		if (ret <= 0)
-			die("No probe point found.\n");
+		if (ret < 0) {
+			if (session.need_dwarf)
+				die("Could not analyze debuginfo.");
+
+			pr_warning("An error occurred in debuginfo analysis. Try to use symbols.\n");
+			break;
+		}
+		if (ret == 0)	/* No error but failed to find probe point. */
+			die("No probe point found.");
 	}
 	close(fd);
 
-setup_probes:
+end_dwarf:
 #endif /* !NO_LIBDWARF */
 
+	/* Synthesize probes without dwarf */
+	for (j = 0; j < session.nr_probe; j++) {
+		pp = &session.probes[j];
+		if (pp->found)	/* This probe is already found. */
+			continue;
+
+		ret = synthesize_probe_event(pp);
+		if (ret == -E2BIG)
+			semantic_error("probe point is too long.");
+		else if (ret < 0)
+			die("Failed to synthesize a probe point.");
+	}
+
 	/* Settng up probe points */
 	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
 	fd = open(buf, O_WRONLY, O_APPEND);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 35d5a69..293cdfc 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -687,8 +687,10 @@ int find_probepoint(int fd, struct probe_point *pp)
 	struct probe_finder pf = {.pp = pp};
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
-		die("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.\n");
+	if (ret != DW_DLV_OK) {
+		pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.\n");
+		return -ENOENT;
+	}
 
 	pp->found = 0;
 	while (++cu_number) {
