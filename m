Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZLIH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZLIH1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZLIH1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:27:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:45765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZLIH1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:27:36 -0500
Date: Wed, 9 Dec 2009 07:25:47 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091208220309.10142.33040.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220309.10142.33040.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Support vmlinux on cwd by default
Message-ID: <tip-f984f03da35357b23d53e9cad29e909810857451@git.kernel.org>
Git-Commit-ID: f984f03da35357b23d53e9cad29e909810857451
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f984f03da35357b23d53e9cad29e909810857451
Gitweb:     http://git.kernel.org/tip/f984f03da35357b23d53e9cad29e909810857451
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 8 Dec 2009 17:03:09 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 07:26:52 +0100

perf probe: Support vmlinux on cwd by default

Support vmlinux on current working direcotry by default and
also update file-open messages.
Now perf probe searches ./vmlinux too.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091208220309.10142.33040.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1347fdf..1c97e13 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -43,11 +43,12 @@
 #include "util/probe-event.h"
 
 /* Default vmlinux search paths */
-#define NR_SEARCH_PATH 3
+#define NR_SEARCH_PATH 4
 const char *default_search_path[NR_SEARCH_PATH] = {
 "/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
 "/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
 "/boot/vmlinux-debug-%s",			/* Ubuntu */
+"./vmlinux",					/* CWD */
 };
 
 #define MAX_PATH_LEN 256
@@ -205,13 +206,14 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 #else	/* !NO_LIBDWARF */
 		pr_debug("Some probes require debuginfo.\n");
 
-	if (session.vmlinux)
+	if (session.vmlinux) {
+		pr_debug("Try to open %s.", session.vmlinux);
 		fd = open(session.vmlinux, O_RDONLY);
-	else
+	} else
 		fd = open_default_vmlinux();
 	if (fd < 0) {
 		if (session.need_dwarf)
-			die("Could not open vmlinux/module file.");
+			die("Could not open debuginfo file.");
 
 		pr_debug("Could not open vmlinux/module file."
 			 " Try to use symbols.\n");
