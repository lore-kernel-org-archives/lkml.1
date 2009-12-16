Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbZLPWVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbZLPWVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763044AbZLPWU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763012AbZLPWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:20:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/3] perf probe: Check new event name
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 16 Dec 2009 17:24:15 -0500
Message-ID: <20091216222415.14459.71383.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check new event name is same syntax as c symbol in perf command.
In other words, checking the name is as like as other tracepoint
events.
This can prevent user to create an event with useless name (e.g.
foo|bar, foo*bar).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/probe-event.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2ca6215..6fca3b6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -62,6 +62,17 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+/* Check the name is good for event/group */
+static bool good_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return false;
+	while (*++name != '\0')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return false;
+	return true;
+}
+
 /* Parse probepoint definition. */
 static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 {
@@ -82,6 +93,9 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		ptr = strchr(arg, ':');
 		if (ptr)	/* Group name is not supported yet. */
 			semantic_error("Group name is not supported yet.");
+		if (!good_event_name(arg))
+			semantic_error("%s is bad for event name -it must "
+				       "follow C symbol-naming rule.", arg);
 		pp->event = strdup(arg);
 		arg = tmp;
 	}


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
