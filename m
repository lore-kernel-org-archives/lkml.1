Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080Ab0AQHAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0AQHAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846Ab0AQHAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:00:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:46575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0AQHAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:00:01 -0500
Date: Sun, 17 Jan 2010 06:59:09 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1263645076-9993-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1263645076-9993-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix build error of builtin-probe.c
Message-ID: <tip-0eda7385db1f30271ade830a231006938a76fb53@git.kernel.org>
Git-Commit-ID: 0eda7385db1f30271ade830a231006938a76fb53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 06:59:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0eda7385db1f30271ade830a231006938a76fb53
Gitweb:     http://git.kernel.org/tip/0eda7385db1f30271ade830a231006938a76fb53
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sat, 16 Jan 2010 21:31:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 07:55:19 +0100

perf probe: Fix build error of builtin-probe.c

I got this build error when building tip tree:

| cc1: warnings being treated as errors
| builtin-probe.c:123: error: 'opt_show_lines' defined but not used

This error is caused by:

| #ifndef NO_LIBDWARF
|	OPT_CALLBACK('L', "line", NULL,
|		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
|		     "Show source code lines.", opt_show_lines),
| #endif

My environment defines NO_LIBDWARF, so gcc treated
opt_show_lines() as garbage. So I moved opt_show_lines() into
#ifndef NO_LIBDWARF ... #endif block.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1263645076-9993-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
