Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0CMM1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:27:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:37842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0CMM07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:26:59 -0500
Date: Sat, 13 Mar 2010 12:26:00 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, stable@kernel.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, stable@kernel.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
In-Reply-To: <20100312232217.2017.45017.stgit@localhost6.localdomain6>
References: <20100312232217.2017.45017.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix probe_point buffer overrun
Message-ID: <tip-594087a04eea544356f9c52e83c1a9bc380ce80f@git.kernel.org>
Git-Commit-ID: 594087a04eea544356f9c52e83c1a9bc380ce80f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 12:26:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  594087a04eea544356f9c52e83c1a9bc380ce80f
Gitweb:     http://git.kernel.org/tip/594087a04eea544356f9c52e83c1a9bc380ce80f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 12 Mar 2010 18:22:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Mar 2010 08:32:22 +0100

perf probe: Fix probe_point buffer overrun

Fix probe_point array-size overrun problem. In some cases (e.g.
inline function), one user-specified probe-point can be
translated to many probe address, and it overruns pre-defined
array-size. This also removes redundant MAX_PROBES macro
definition.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: <stable@kernel.org>
LKML-Reference: <20100312232217.2017.45017.stgit@localhost6.localdomain6>
[ Note that only root can create new probes. Eventually we should remove
  the MAX_PROBES limit, but that is a larger patch not eligible to
  perf/urgent treatment. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-probe.c     |    1 -
 tools/perf/util/probe-finder.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c30a335..152d6c9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -47,7 +47,6 @@
 #include "util/probe-event.h"
 
 #define MAX_PATH_LEN 256
-#define MAX_PROBES 128
 
 /* Session management structure */
 static struct {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1e6c65e..f9cbbf1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -455,6 +455,9 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
 
+	if (pp->found == MAX_PROBES)
+		die("Too many( > %d) probe point found.\n", MAX_PROBES);
+
 	pp->probes[pp->found] = strdup(tmp);
 	pp->found++;
 }
