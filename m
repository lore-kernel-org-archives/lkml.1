Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZGEFjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZGEFjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 01:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZGEFja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 01:39:30 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53375 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGEFjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 01:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hyzw1gVnt3rdN3WMuSRky5I/E22uCD/SHECc5/cv63CfFaUp+pKIpTU6bELnKw/MNW
         1/TH/jDtyJ8E9muLQWne03yx5o2PYrHuxABUKX16Y4TshXAOChAUgCPVm59iYlwbka6t
         UaaUZ9EgV4JaIMQ/czM4i7RpHH6xuzxBOVgOU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] perf report: Use a modifiable string for default callchain options
Date: Sun,  5 Jul 2009 07:39:18 +0200
Message-Id: <1246772361-9960-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
References: <1246772361-9960-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user doesn't provide options to tune his callchain output
(ie: if he uses -c without arguments) then the default value passed
in the OPT_CALLBACK_DEFAULT() macro is used.

But it's parsed later by strtok() which will replace comma separators
to a zero. This may segfault as we are using a read-only string.

Use a modifiable one instead, and also fix the "100%" default
minimum threshold value by turning it into a 0 (output every callchains)
as it was intended in the origin.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.2.3

