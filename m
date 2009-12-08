Return-Path: <linux-kernel-owner+w=401wt.eu-S966561AbZLHV64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966561AbZLHV64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966545AbZLHV6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:58:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966551AbZLHV6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:58:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/8] perf probe: Change probe-added message more
	user-friendly
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:02:47 -0500
Message-ID: <20091208220247.10142.91642.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change probe-added message more user-friendly expression and
show usage of new events.

Before:
Added new event: p:probe/schedule_0 schedule+10 prev=%ax cpu=%bx

After:
Added new event:
  probe:schedule_1                         (on schedule+1 with prev cpu)

You can now use it on all perf tools, such as:

        perf record -e probe:schedule_1 -a sleep 1

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/util/probe-event.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a20e382..2c4d301 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -453,17 +453,13 @@ static struct strlist *get_perf_event_names(int fd)
 	return sl;
 }
 
-static int write_trace_kprobe_event(int fd, const char *buf)
+static void write_trace_kprobe_event(int fd, const char *buf)
 {
 	int ret;
 
 	ret = write(fd, buf, strlen(buf));
 	if (ret <= 0)
 		die("Failed to create event.");
-	else
-		printf("Added new event: %s\n", buf);
-
-	return ret;
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
@@ -503,10 +499,19 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 				 PERFPROBE_GROUP, event,
 				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
+			printf("Added new event:\n");
+			/* Get the first parameter (probe-point) */
+			sscanf(pp->probes[i], "%s", buf);
+			show_perf_probe_event(PERFPROBE_GROUP, event,
+					      buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
 		}
 	}
+	/* Show how to use the event. */
+	printf("\nYou can now use it on all perf tools, such as:\n\n");
+	printf("\tperf record -e %s:%s -a sleep 1\n\n", PERFPROBE_GROUP, event);
+
 	strlist__delete(namelist);
 	close(fd);
 }


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
