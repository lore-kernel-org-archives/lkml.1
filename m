Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775Ab0AMKhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0AMKhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712Ab0AMKg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:38497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab0AMKgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:55 -0500
Date: Wed, 13 Jan 2010 10:34:59 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100105224717.19431.68972.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224717.19431.68972.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Support tracepoint glob matching
Message-ID: <tip-fb1d2edf7ee25a26ad0b238d0ee335a3b28b7aa3@git.kernel.org>
Git-Commit-ID: fb1d2edf7ee25a26ad0b238d0ee335a3b28b7aa3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:35:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb1d2edf7ee25a26ad0b238d0ee335a3b28b7aa3
Gitweb:     http://git.kernel.org/tip/fb1d2edf7ee25a26ad0b238d0ee335a3b28b7aa3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 5 Jan 2010 17:47:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 10:09:13 +0100

perf tools: Support tracepoint glob matching

Support glob wildcard when selecting tracepoint events by -e
option. Without this patch, perf-tools supports 'GROUP:*:record'
syntax for selecting all tracepoints under GROUP group.

With this patch, user can choose tracepoints more flexibly by using
partial wildcards, e.g. 'block:*bio*:record'.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20100105224717.19431.68972.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 609d5a9..05d0c5c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -450,7 +450,8 @@ parse_single_tracepoint_event(char *sys_name,
 /* sys + ':' + event + ':' + flags*/
 #define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
 static enum event_result
-parse_subsystem_tracepoint_event(char *sys_name, char *flags)
+parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
+				char *flags)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
@@ -474,6 +475,9 @@ parse_subsystem_tracepoint_event(char *sys_name, char *flags)
 		    || !strcmp(evt_ent->d_name, "filter"))
 			continue;
 
+		if (!strglobmatch(evt_ent->d_name, evt_exp))
+			continue;
+
 		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s%s%s", sys_name,
 			       evt_ent->d_name, flags ? ":" : "",
 			       flags ?: "");
@@ -522,9 +526,10 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return EVT_FAILED;
 
-	if (!strcmp(evt_name, "*")) {
+	if (strpbrk(evt_name, "*?")) {
 		*strp = evt_name + evt_length;
-		return parse_subsystem_tracepoint_event(sys_name, flags);
+		return parse_multiple_tracepoint_event(sys_name, evt_name,
+						       flags);
 	} else
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, flags,
