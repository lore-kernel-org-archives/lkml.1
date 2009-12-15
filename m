Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbZLOT27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbZLOT27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933508AbZLOT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:28:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:50965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535AbZLOT2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:28:47 -0500
Date: Tue, 15 Dec 2009 19:27:35 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153239.17436.55034.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153239.17436.55034.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Check symbols in symtab/kallsyms
Message-ID: <tip-62bdc1b38e2abf3f500229c3bf4c82d33575d1ae@git.kernel.org>
Git-Commit-ID: 62bdc1b38e2abf3f500229c3bf4c82d33575d1ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62bdc1b38e2abf3f500229c3bf4c82d33575d1ae
Gitweb:     http://git.kernel.org/tip/62bdc1b38e2abf3f500229c3bf4c82d33575d1ae
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:32:40 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:05 +0100

perf probe: Check symbols in symtab/kallsyms

Check symbols in symtab/kallsyms when no debuginfo
is available.

e.g.

 # perf probe test
  Fatal: Kernel symbol 'test' not found - probe not added.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153239.17436.55034.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 0584b7a..6b0e4cf 100644
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
@@ -277,6 +288,7 @@ end_dwarf:
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
+		evaluate_probe_point(pp);
 		ret = synthesize_trace_kprobe_event(pp);
 		if (ret == -E2BIG)
 			die("probe point definition becomes too long.");
