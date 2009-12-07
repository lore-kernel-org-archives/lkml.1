Return-Path: <linux-kernel-owner+w=401wt.eu-S935493AbZLGQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493AbZLGQ4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935444AbZLGQ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:56:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935083AbZLGQ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:56:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 3/5] perf probe: Fix event namelist to duplicate
	string
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 07 Dec 2009 12:00:46 -0500
Message-ID: <20091207170046.19230.55557.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix event namelist to duplicate string. Without duplicating,
adding multiple probes causes stack overwrite bug, because
it reuses a buffer on stack while the buffer is already
added in the namelist. String duplication solves this bug
because only contents of the buffer is copied to the namelist.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/util/probe-event.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index cd7fbda..de0d913 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -413,12 +413,13 @@ static struct strlist *get_perf_event_names(int fd)
 
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
-	sl = strlist__new(false, NULL);
+	sl = strlist__new(true, NULL);
 	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
 		ent = strlist__entry(rawlist, i);
 		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
 		strlist__add(sl, event);
 		free(group);
+		free(event);
 	}
 
 	strlist__delete(rawlist);
@@ -480,5 +481,6 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 			strlist__add(namelist, event);
 		}
 	}
+	strlist__delete(namelist);
 	close(fd);
 }


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
