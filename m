Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbZLQKy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbZLQKy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761691AbZLQKy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:54:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:54029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261AbZLQKyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:54:20 -0500
Date: Thu, 17 Dec 2009 10:52:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091216222415.14459.71383.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222415.14459.71383.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Check new event name
Message-ID: <tip-b7702a2136b5f8e0e186e22cae91aaecf98b418c@git.kernel.org>
Git-Commit-ID: b7702a2136b5f8e0e186e22cae91aaecf98b418c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7702a2136b5f8e0e186e22cae91aaecf98b418c
Gitweb:     http://git.kernel.org/tip/b7702a2136b5f8e0e186e22cae91aaecf98b418c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 16 Dec 2009 17:24:15 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 09:42:44 +0100

perf probe: Check new event name

Check new event name is same syntax as a C symbol in perf command.
In other words, checking the name is as like as other tracepoint
events.

This can prevent user to create an event with useless name (e.g.
foo|bar, foo*bar).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091216222415.14459.71383.stgit@dhcp-100-2-132.bos.redhat.com>
[ v2: minor cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2ca6215..29465d4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -62,6 +62,18 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+/* Check the name is good for event/group */
+static bool check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return false;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return false;
+	}
+	return true;
+}
+
 /* Parse probepoint definition. */
 static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 {
@@ -82,6 +94,9 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		ptr = strchr(arg, ':');
 		if (ptr)	/* Group name is not supported yet. */
 			semantic_error("Group name is not supported yet.");
+		if (!check_event_name(arg))
+			semantic_error("%s is bad for event name -it must "
+				       "follow C symbol-naming rule.", arg);
 		pp->event = strdup(arg);
 		arg = tmp;
 	}
