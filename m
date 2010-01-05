Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432Ab0AEWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0AEWmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396Ab0AEWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:42:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0AEWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:42:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 6/8] perf tools: Support tracepoint glob matching
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Date: Tue, 05 Jan 2010 17:47:17 -0500
Message-ID: <20100105224717.19431.68972.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support glob wildcard when selecting tracepoint events by -e option.
Without this patch, perf-tools supports 'GROUP:*:record' syntax for
selecting all tracepoints under GROUP group. With this patch, user
can choose tracepoints more flexible by using partial wildcard,
e.g. 'block:*bio*:record'.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
