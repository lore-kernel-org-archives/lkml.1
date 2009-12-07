Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbZLGRjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbZLGRjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935565AbZLGRi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:38:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:41696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935535AbZLGRir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:38:47 -0500
Date: Mon, 7 Dec 2009 17:37:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091207170046.19230.55557.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091207170046.19230.55557.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix event namelist to duplicate string
Message-ID: <tip-e1d2017b24fb31602f1128e6a8b2afc54c9283cd@git.kernel.org>
Git-Commit-ID: e1d2017b24fb31602f1128e6a8b2afc54c9283cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1d2017b24fb31602f1128e6a8b2afc54c9283cd
Gitweb:     http://git.kernel.org/tip/e1d2017b24fb31602f1128e6a8b2afc54c9283cd
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 7 Dec 2009 12:00:46 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 18:33:21 +0100

perf probe: Fix event namelist to duplicate string

Fix event namelist to duplicate string. Without duplicating, adding
multiple probes causes stack overwrite bug, because it reuses a
buffer on stack while the buffer is already added in the namelist.
String duplication solves this bug because only contents of the
buffer is copied to the namelist.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091207170046.19230.55557.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
