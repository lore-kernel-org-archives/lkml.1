Return-Path: <linux-kernel-owner+w=401wt.eu-S966596AbZLHV7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966596AbZLHV7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966516AbZLHV7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:59:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966579AbZLHV7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:59:15 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 5/8] perf probe: Support vmlinux on cwd by default
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:03:09 -0500
Message-ID: <20091208220309.10142.33040.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support vmlinux on current working direcotry by default and
also update file-open messages.
Now perf probe searches ./vmlinux too.

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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
