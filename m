Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbZLOP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbZLOP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZLOP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:29:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758749AbZLOP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:28:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 14/14] perf probe: Fix to show which probe point is not
	found
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:32:47 -0500
Message-ID: <20091215153247.17436.49068.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf probe to show which probe point is not found.
With out this patch, it shows just "No probe point found."
This doesn't help users if they specify several probes.
e.g.

# perf probe -f --add schedule --add test
  Fatal: No probe point found.

This patch makes error message more helpful as below.

# perf probe --add schedule --add test
  Fatal: Probe point 'test' not found. - probe not added.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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

 tools/perf/builtin-probe.c    |    7 +++++--
 tools/perf/util/probe-event.c |   34 ++++++++++++++++++++++++----------
 tools/perf/util/probe-event.h |    1 +
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index f019536..beb49e3 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -265,8 +265,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		ret = find_probepoint(fd, pp);
 		if (ret > 0)
 			continue;
-		if (ret == 0)	/* No error but failed to find probe point. */
-			die("No probe point found.");
+		if (ret == 0) {	/* No error but failed to find probe point. */
+			synthesize_perf_probe_point(pp);
+			die("Probe point '%s' not found. - probe not added.",
+			    pp->probes[0]);
+		}
 		/* Error path */
 		if (session.need_dwarf) {
 			if (ret == -ENOENT)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e74ecfc..3c2e743 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -249,11 +249,12 @@ void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
 	argv_free(argv);
 }
 
-int synthesize_perf_probe_event(struct probe_point *pp)
+/* Synthesize only probe point (not argument) */
+int synthesize_perf_probe_point(struct probe_point *pp)
 {
 	char *buf;
 	char offs[64] = "", line[64] = "";
-	int i, len, ret;
+	int ret;
 
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
 	if (!buf)
@@ -274,10 +275,24 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 				 offs, pp->retprobe ? "%return" : "", line);
 	else
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
-	if (ret <= 0)
-		goto error;
-	len = ret;
+	if (ret <= 0) {
+error:
+		free(pp->probes[0]);
+		pp->probes[0] = NULL;
+	}
+	return ret;
+}
+
+int synthesize_perf_probe_event(struct probe_point *pp)
+{
+	char *buf;
+	int i, len, ret;
 
+	len = synthesize_perf_probe_point(pp);
+	if (len < 0)
+		return 0;
+
+	buf = pp->probes[0];
 	for (i = 0; i < pp->nr_args; i++) {
 		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
 				 pp->args[i]);
@@ -290,6 +305,7 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 	return pp->found;
 error:
 	free(pp->probes[0]);
+	pp->probes[0] = NULL;
 
 	return ret;
 }
@@ -319,6 +335,7 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	return pp->found;
 error:
 	free(pp->probes[0]);
+	pp->probes[0] = NULL;
 
 	return ret;
 }
@@ -418,7 +435,7 @@ static void show_perf_probe_event(const char *event, const char *place,
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
-	int fd, nr;
+	int fd;
 	struct probe_point pp;
 	struct strlist *rawlist;
 	struct str_node *ent;
@@ -430,10 +447,7 @@ void show_perf_probe_events(void)
 	strlist__for_each(ent, rawlist) {
 		parse_trace_kprobe_event(ent->s, &pp);
 		/* Synthesize only event probe point */
-		nr = pp.nr_args;
-		pp.nr_args = 0;
-		synthesize_perf_probe_event(&pp);
-		pp.nr_args = nr;
+		synthesize_perf_probe_point(&pp);
 		/* Show an event */
 		show_perf_probe_event(pp.event, pp.probes[0], &pp);
 		clear_probe_point(&pp);
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 8fd3052..7f1d499 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -7,6 +7,7 @@
 
 extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
 				   bool *need_dwarf);
+extern int synthesize_perf_probe_point(struct probe_point *pp);
 extern int synthesize_perf_probe_event(struct probe_point *pp);
 extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
