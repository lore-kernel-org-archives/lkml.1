Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZGEJwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZGEJwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZGEJwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:52:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:55414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbZGEJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:52:40 -0400
Date: Sun, 5 Jul 2009 09:52:04 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, anton@samba.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, jens.axboe@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, anton@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, jens.axboe@oracle.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246772361-9960-2-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf report: Use a modifiable string for default callchain options
Message-ID: <tip-be9038859e56f729cc9d3b070a35fb8829a73696@git.kernel.org>
Git-Commit-ID: be9038859e56f729cc9d3b070a35fb8829a73696
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 09:52:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be9038859e56f729cc9d3b070a35fb8829a73696
Gitweb:     http://git.kernel.org/tip/be9038859e56f729cc9d3b070a35fb8829a73696
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 5 Jul 2009 07:39:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jul 2009 10:30:21 +0200

perf report: Use a modifiable string for default callchain options

If the user doesn't provide options to tune his callchain output
(ie: if he uses -c without arguments) then the default value passed
in the OPT_CALLBACK_DEFAULT() macro is used.

But it's parsed later by strtok() which will replace comma separators
to a zero. This may segfault as we are using a read-only string.

Use a modifiable one instead, and also fix the "100%" default
minimum threshold value by turning it into a 0 (output every callchains)
as it was intended in the origin.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1246772361-9960-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9f9575a..3db99fd 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -58,6 +58,8 @@ static char		*parent_pattern = default_parent_pattern;
 static regex_t		parent_regex;
 
 static int		exclude_other = 1;
+
+static char		callchain_default_opt[] = "flat,0";
 static int		callchain;
 static enum chain_mode	callchain_mode;
 static double		callchain_min_percent = 0.0;
@@ -1871,7 +1873,7 @@ static const struct option options[] = {
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('c', "callchain", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
-		     "Default: flat,0", &parse_callchain_opt, "flat,100"),
+		     "Default: flat,0", &parse_callchain_opt, callchain_default_opt),
 	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
