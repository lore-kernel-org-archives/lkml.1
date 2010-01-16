Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0APMbU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455Ab0APMbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:31:19 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53395 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0APMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:31:18 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] perf probe: Remove build error of builtin-probe.c
Date: Sat, 16 Jan 2010 21:31:16 +0900
Message-Id: <1263645076-9993-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this build error when building tip tree,

| cc1: warnings being treated as errors
| builtin-probe.c:123: error: ‘opt_show_lines’ defined but not used

This error is caused by:
| #ifndef NO_LIBDWARF
| 	OPT_CALLBACK('L', "line", NULL,
| 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
| 		     "Show source code lines.", opt_show_lines),
| #endif

My environment defines NO_LIBDWARF, so gcc treated opt_show_lines() as garbage.
So I moved opt_show_lines() into #ifndef NO_LIBDWARF ... #endif block.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 tools/perf/builtin-probe.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 1d3a99e..34f2acb 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -118,15 +118,6 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
-static int opt_show_lines(const struct option *opt __used,
-			  const char *str, int unset __used)
-{
-	if (str)
-		parse_line_range_desc(str, &session.line_range);
-	INIT_LIST_HEAD(&session.line_range.line_list);
-	session.show_lines = true;
-	return 0;
-}
 /* Currently just checking function name from symbol map */
 static void evaluate_probe_point(struct probe_point *pp)
 {
@@ -148,6 +139,16 @@ static int open_vmlinux(void)
 	pr_debug("Try to open %s\n", session.kmap->dso->long_name);
 	return open(session.kmap->dso->long_name, O_RDONLY);
 }
+
+static int opt_show_lines(const struct option *opt __used,
+			  const char *str, int unset __used)
+{
+	if (str)
+		parse_line_range_desc(str, &session.line_range);
+	INIT_LIST_HEAD(&session.line_range.line_list);
+	session.show_lines = true;
+	return 0;
+}
 #endif
 
 static const char * const probe_usage[] = {
-- 
1.6.5.2

