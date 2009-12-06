Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbZLFSZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbZLFSZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbZLFSZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933596AbZLFSZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:25:48 -0500
Date: Sun, 6 Dec 2009 13:25:30 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
To: a.p.zijlstra@chello.nl, fweisbec@gmail.com, jaswinderrajput@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org
Subject: Minor optimization in parse_subsystem_tracepoint_event
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses of strcat are almost always signs that someone is too lazy to think
about the code a bit more carefully.  One always has to know about the
lengths of the strings involved to avoid buffer overflows.

This is one case where the size of the object code for me is reduced by
38 bytes.  The code should also be faster, especially if flags is non-NULL.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9e5dbd6..4c0bd3c 100644
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
