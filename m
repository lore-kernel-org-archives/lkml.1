Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbZLOTb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbZLOTb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbZLOTbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:31:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:51007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760974AbZLOT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:29:16 -0500
Date: Tue, 15 Dec 2009 19:25:58 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153149.17436.61265.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153149.17436.61265.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix --del to update current event list
Message-ID: <tip-3e3405906dab00afecd5a16871850a088eba4626@git.kernel.org>
Git-Commit-ID: 3e3405906dab00afecd5a16871850a088eba4626
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e3405906dab00afecd5a16871850a088eba4626
Gitweb:     http://git.kernel.org/tip/3e3405906dab00afecd5a16871850a088eba4626
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:31:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:01 +0100

perf probe: Fix --del to update current event list

Fix --del option to update current existing event list
after perf probe deleted an event.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153149.17436.61265.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    5 ++++-
 tools/perf/util/strlist.c     |    6 +++---
 tools/perf/util/strlist.h     |    7 ++++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1eacee6..eab25d6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -540,10 +540,12 @@ static void del_trace_kprobe_event(int fd, const char *group,
 				   const char *event, struct strlist *namelist)
 {
 	char buf[128];
+	struct str_node *ent;
 
 	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
 		die("Failed to copy event.");
-	if (!strlist__has_entry(namelist, buf)) {
+	ent = strlist__find(namelist, buf);
+	if (!ent) {
 		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
 		return;
 	}
@@ -553,6 +555,7 @@ static void del_trace_kprobe_event(int fd, const char *group,
 
 	write_trace_kprobe_event(fd, buf);
 	printf("Remove event: %s:%s\n", group, event);
+	strlist__remove(namelist, ent);
 }
 
 void del_trace_kprobe_events(struct strlist *dellist)
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 7ad3817..6783a20 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -102,7 +102,7 @@ void strlist__remove(struct strlist *self, struct str_node *sn)
 	str_node__delete(sn, self->dupstr);
 }
 
-bool strlist__has_entry(struct strlist *self, const char *entry)
+struct str_node *strlist__find(struct strlist *self, const char *entry)
 {
 	struct rb_node **p = &self->entries.rb_node;
 	struct rb_node *parent = NULL;
@@ -120,10 +120,10 @@ bool strlist__has_entry(struct strlist *self, const char *entry)
 		else if (rc < 0)
 			p = &(*p)->rb_right;
 		else
-			return true;
+			return sn;
 	}
 
-	return false;
+	return NULL;
 }
 
 static int strlist__parse_list_entry(struct strlist *self, const char *s)
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index cb46593..59091c7 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -23,7 +23,12 @@ int strlist__load(struct strlist *self, const char *filename);
 int strlist__add(struct strlist *self, const char *str);
 
 struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
-bool strlist__has_entry(struct strlist *self, const char *entry);
+struct str_node *strlist__find(struct strlist *self, const char *entry);
+
+static inline bool strlist__has_entry(struct strlist *self, const char *entry)
+{
+	return strlist__find(self, entry) != NULL;
+}
 
 static inline bool strlist__empty(const struct strlist *self)
 {
