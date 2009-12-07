Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZLGHM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZLGHM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZLGHM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:12:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:51348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbZLGHM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:12:57 -0500
Date: Mon, 7 Dec 2009 07:12:33 GMT
From: tip-bot for Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, drepper@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
References: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Optimize parse_subsystem_tracepoint_event()
Message-ID: <tip-180570fdb7a3c404b599f0a318c2ccf86e4827ed@git.kernel.org>
Git-Commit-ID: 180570fdb7a3c404b599f0a318c2ccf86e4827ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  180570fdb7a3c404b599f0a318c2ccf86e4827ed
Gitweb:     http://git.kernel.org/tip/180570fdb7a3c404b599f0a318c2ccf86e4827ed
Author:     Ulrich Drepper <drepper@redhat.com>
AuthorDate: Sun, 6 Dec 2009 13:25:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 08:09:29 +0100

perf tools: Optimize parse_subsystem_tracepoint_event()

Uses of strcat are almost always signs that someone is too lazy
to think about the code a bit more carefully.  One always has to
know about the lengths of the strings involved to avoid buffer
overflows.

This is one case where the size of the object code for me is
reduced by 38 bytes.  The code should also be faster, especially
if flags is non-NULL.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: a.p.zijlstra@chello.nl
Cc: fweisbec@gmail.com
Cc: jaswinderrajput@gmail.com
Cc: paulus@samba.org
LKML-Reference: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 448a13b..e5bc0fb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -467,7 +467,6 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 	while ((evt_ent = readdir(evt_dir))) {
 		char event_opt[MAX_EVOPT_LEN + 1];
 		int len;
-		unsigned int rem = MAX_EVOPT_LEN;
 
 		if (!strcmp(evt_ent->d_name, ".")
 		    || !strcmp(evt_ent->d_name, "..")
@@ -475,20 +474,12 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 		    || !strcmp(evt_ent->d_name, "filter"))
 			continue;
 
-		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s", sys_name,
-			       evt_ent->d_name);
+		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
+			       evt_ent->d_name, flags ? ":" : "",
+			       flags ?: "");
 		if (len < 0)
 			return EVT_FAILED;
 
-		rem -= len;
-		if (flags) {
-			if (rem < strlen(flags) + 1)
-				return EVT_FAILED;
-
-			strcat(event_opt, ":");
-			strcat(event_opt, flags);
-		}
-
 		if (parse_events(NULL, event_opt, 0))
 			return EVT_FAILED;
 	}
