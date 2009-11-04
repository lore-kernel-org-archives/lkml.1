Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZKDARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZKDARw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZKDARu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:17:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbZKDARs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:17:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 2/5] perf/probes: Improve error messages
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 03 Nov 2009 19:12:21 -0500
Message-ID: <20091104001221.3454.52030.stgit@harusame>
In-Reply-To: <20091104001204.3454.75999.stgit@harusame>
References: <20091104001204.3454.75999.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve error messages in perf-probe so that users can figure
out problems easily.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
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

 tools/perf/builtin-probe.c     |   21 ++++++++++++++-------
 tools/perf/util/probe-finder.c |    3 ++-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a99a366..454ddfc 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -294,10 +294,11 @@ static int write_new_event(int fd, const char *buf)
 {
 	int ret;
 
-	printf("Adding new event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
-		die("failed to create event.");
+		die("Failed to create event.");
+	else
+		printf("Added new event: %s\n", buf);
 
 	return ret;
 }
@@ -310,7 +311,7 @@ static int synthesize_probe_event(struct probe_point *pp)
 	int i, len, ret;
 	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
 	if (!buf)
-		die("calloc");
+		die("Failed to allocate memory by calloc.");
 	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
 	if (ret <= 0 || ret >= MAX_CMDLEN)
 		goto error;
@@ -363,7 +364,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		if (ret == -E2BIG)
 			semantic_error("probe point is too long.");
 		else if (ret < 0)
-			die("snprintf");
+			die("Failed to synthesize a probe point.");
 	}
 
 #ifndef NO_LIBDWARF
@@ -375,7 +376,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	else
 		fd = open_default_vmlinux();
 	if (fd < 0)
-		die("vmlinux/module file open");
+		die("Could not open vmlinux/module file.");
 
 	/* Searching probe points */
 	for (j = 0; j < session.nr_probe; j++) {
@@ -396,8 +397,14 @@ setup_probes:
 	/* Settng up probe points */
 	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
 	fd = open(buf, O_WRONLY, O_APPEND);
-	if (fd < 0)
-		die("kprobe_events open");
+	if (fd < 0) {
+		if (errno == ENOENT)
+			die("kprobe_events file does not exist"
+			    " - please rebuild with CONFIG_KPROBE_TRACER.");
+		else
+			die("Could not open kprobe_events file: %s",
+			    strerror(errno));
+	}
 	for (j = 0; j < session.nr_probe; j++) {
 		pp = &session.probes[j];
 		if (pp->found == 1) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index db96186..86cead3 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -688,7 +688,8 @@ int find_probepoint(int fd, struct probe_point *pp)
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
 	if (ret != DW_DLV_OK)
-		die("Failed to call dwarf_init(). Maybe, not a dwarf file.\n");
+		die("Not found dwarf info in the vmlinux"
+		    " - please rebuild with CONFIG_DEBUG_INFO.\n");
 
 	pp->found = 0;
 	while (++cu_number) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
