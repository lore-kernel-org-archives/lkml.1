Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbZLOT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbZLOT1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbZLOT13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:27:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429AbZLOT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:27:26 -0500
Date: Tue, 15 Dec 2009 19:25:30 GMT
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
In-Reply-To: <20091215153135.17436.99052.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153135.17436.99052.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Show need-dwarf message only if it is really needed
Message-ID: <tip-411edfe5c1ef02a62ec3be56d3e234dbed71ba20@git.kernel.org>
Git-Commit-ID: 411edfe5c1ef02a62ec3be56d3e234dbed71ba20
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  411edfe5c1ef02a62ec3be56d3e234dbed71ba20
Gitweb:     http://git.kernel.org/tip/411edfe5c1ef02a62ec3be56d3e234dbed71ba20
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:31:35 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:01 +0100

perf probe: Show need-dwarf message only if it is really needed

Show need-dwarf message only if the probe is really requires
debuginfo analysis. This also use pr_debug for debugging message
instead of pr_warning.

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
LKML-Reference: <20091215153135.17436.99052.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |   18 +++++++++++-------
 tools/perf/util/probe-finder.c |    4 +---
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 919037b..438a7bb 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -261,15 +261,19 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
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
+				pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
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
