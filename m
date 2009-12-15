Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbZLOP3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbZLOP3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZLOP3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:29:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758734AbZLOP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:28:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 13/14] perf probe: Check symbols in symtab/kallsyms
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
Date: Tue, 15 Dec 2009 10:32:40 -0500
Message-ID: <20091215153239.17436.55034.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check symbols in symtab/kallsyms when no debuginfo
is available.

e.g.

# perf probe test
  Fatal: Kernel symbol 'test' not found - probe not added.

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

 tools/perf/builtin-probe.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5008605..f019536 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -59,6 +59,7 @@ static struct {
 	struct strlist *dellist;
 	struct symbol_conf conf;
 	struct perf_session *psession;
+	struct map *kmap;
 } session;
 
 
@@ -115,22 +116,26 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+/* Currently just checking function name from symbol map */
+static void evaluate_probe_point(struct probe_point *pp)
+{
+	struct symbol *sym;
+	sym = map__find_symbol_by_name(session.kmap, pp->function,
+				       session.psession, NULL);
+	if (!sym)
+		die("Kernel symbol \'%s\' not found - probe not added.",
+		    pp->function);
+}
+
 #ifndef NO_LIBDWARF
 static int open_vmlinux(void)
 {
-	struct map *kmap;
-	kmap = map_groups__find_by_name(&session.psession->kmaps,
-					MAP__FUNCTION, "[kernel.kallsyms]");
-	if (!kmap) {
-		pr_debug("Could not find kernel map.\n");
-		return -ENOENT;
-	}
-	if (map__load(kmap, session.psession, NULL) < 0) {
+	if (map__load(session.kmap, session.psession, NULL) < 0) {
 		pr_debug("Failed to load kernel map.\n");
 		return -EINVAL;
 	}
-	pr_debug("Try to open %s\n", kmap->dso->long_name);
-	return open(kmap->dso->long_name, O_RDONLY);
+	pr_debug("Try to open %s\n", session.kmap->dso->long_name);
+	return open(session.kmap->dso->long_name, O_RDONLY);
 }
 #endif
 
@@ -219,6 +224,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 
 	/* Initialize symbol maps for vmlinux */
+	session.conf.sort_by_name = true;
 	if (session.conf.vmlinux_name == NULL)
 		session.conf.try_vmlinux_path = true;
 	if (symbol__init(&session.conf) < 0)
@@ -227,6 +233,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 					     &session.conf);
 	if (session.psession == NULL)
 		die("Failed to init perf_session.");
+	session.kmap = map_groups__find_by_name(&session.psession->kmaps,
+						MAP__FUNCTION,
+						"[kernel.kallsyms]");
+	if (!session.kmap)
+		die("Could not find kernel map.\n");
 
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
@@ -279,6 +290,7 @@ end_dwarf:
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
+		evaluate_probe_point(pp);
 		ret = synthesize_trace_kprobe_event(pp);
 		if (ret == -E2BIG)
 			die("probe point definition becomes too long.");


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
