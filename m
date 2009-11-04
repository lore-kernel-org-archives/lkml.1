Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZKDASK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZKDASK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZKDASI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:18:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZKDASF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:18:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 3/5] perf/probes: Fall back to non-dwarf if
	possible
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 03 Nov 2009 19:12:30 -0500
Message-ID: <20091104001229.3454.63987.stgit@harusame>
In-Reply-To: <20091104001204.3454.75999.stgit@harusame>
References: <20091104001204.3454.75999.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fall back to non-dwarf probe point if the probe definition may not
need dwarf analysis, when perf can't find vmlinux/debuginfo.
This might skip some inlined code of target function.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/builtin-probe.c     |   65 +++++++++++++++++++++++-----------------
 tools/perf/util/probe-finder.c |    8 +++--
 2 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 454ddfc..e44491b 100644
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
@@ -386,14 +374,35 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 		lseek(fd, SEEK_SET, 0);
 		ret = find_probepoint(fd, pp);
-		if (ret <= 0)
-			die("No probe point found.\n");
+		if (ret < 0) {
+			if (session.need_dwarf)
+				die("Could not analyze debuginfo.");
+
+			pr_warning("An error was occurred in debuginfo"
+				   " analysis. Try to use symbols.\n");
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
index 86cead3..f628dee 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -687,9 +687,11 @@ int find_probepoint(int fd, struct probe_point *pp)
 	struct probe_finder pf = {.pp = pp};
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK)
-		die("Not found dwarf info in the vmlinux"
-		    " - please rebuild with CONFIG_DEBUG_INFO.\n");
+	if (ret != DW_DLV_OK) {
+		pr_warning("Not found dwarf info in the vmlinux"
+			   " - please rebuild with CONFIG_DEBUG_INFO.\n");
+		return -ENOENT;
+	}
 
 	pp->found = 0;
 	while (++cu_number) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
