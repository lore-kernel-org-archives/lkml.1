Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZLOPba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZLOPba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZLOPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:31:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbZLOP1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:27:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 04/14] perf probe: Show need-dwarf message only if it is
	really needed
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
Date: Tue, 15 Dec 2009 10:31:35 -0500
Message-ID: <20091215153135.17436.99052.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show need-dwarf message only if the probe is really requires
debuginfo analysis. This also use pr_debug for debugging message
instead of pr_warning.

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

 tools/perf/builtin-probe.c     |   20 +++++++++++++-------
 tools/perf/util/probe-finder.c |    4 +---
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 919037b..7f35709 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -261,15 +261,21 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 		lseek(fd, SEEK_SET, 0);
 		ret = find_probepoint(fd, pp);
-		if (ret < 0) {
-			if (session.need_dwarf)
-				die("Could not analyze debuginfo.");
-
-			pr_warning("An error occurred in debuginfo analysis. Try to use symbols.\n");
-			break;
-		}
+		if (ret > 0)
+			continue;
 		if (ret == 0)	/* No error but failed to find probe point. */
 			die("No probe point found.");
+		/* Error path */
+		if (session.need_dwarf) {
+			if (ret == -ENOENT)
+				pr_warning("No dwarf info found in the vmlinux"
+					   " - please rebuild with "
+					   "CONFIG_DEBUG_INFO.\n");
+			die("Could not analyze debuginfo.");
+		}
+		pr_debug("An error occurred in debuginfo analysis."
+			 " Try to use symbols.\n");
+		break;
 	}
 	close(fd);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 4585f1d..4b852c0 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -687,10 +687,8 @@ int find_probepoint(int fd, struct probe_point *pp)
 	struct probe_finder pf = {.pp = pp};
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK) {
-		pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.\n");
+	if (ret != DW_DLV_OK)
 		return -ENOENT;
-	}
 
 	pp->found = 0;
 	while (++cu_number) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
