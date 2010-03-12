Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709Ab0CLXOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab0CLXOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:14:06 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/3] [BUGFIX] perf probe: Fix probe_point buffer overrun
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 12 Mar 2010 18:22:17 -0500
Message-ID: <20100312232217.2017.45017.stgit@localhost6.localdomain6>
In-Reply-To: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
References: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix probe_point array-size overrun problem. In some cases (e.g. inline
function), one user-specified probe-point can be translated to many
probe address, and it overruns pre-defined array-size.
This also removes redundant MAX_PROBES macro definition.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
