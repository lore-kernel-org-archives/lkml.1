Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZGJKnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZGJKnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZGJKmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:42:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:53477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbZGJKmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:42:33 -0400
Date: Fri, 10 Jul 2009 10:41:52 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A55A8BE.9010707@cn.fujitsu.com>
References: <4A55A8BE.9010707@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filter: Remove empty subsystem and its directory
Message-ID: <tip-dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c@git.kernel.org>
Git-Commit-ID: dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:41:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
Gitweb:     http://git.kernel.org/tip/dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 9 Jul 2009 16:22:22 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:55:28 +0200

tracing/filter: Remove empty subsystem and its directory

Remove empty subsystem and its directory when module unload.

Before patch:
 # rmmod trace-events-sample.ko
 # ls sample
 enable  filter

After patch:
 # rmmod trace-events-sample.ko
 # ls sample
 ls: cannot access sample: No such file or directory

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A55A8BE.9010707@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_events.c |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 52eb0d8..94305c7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -757,6 +757,7 @@ struct event_subsystem {
 	const char		*name;
 	struct dentry		*entry;
 	void			*filter;
+	int			nr_events;
 };
 
 struct filter_pred;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fecac13..90cf936 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -851,8 +851,10 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
-		if (strcmp(system->name, name) == 0)
+		if (strcmp(system->name, name) == 0) {
+			system->nr_events++;
 			return system->entry;
+		}
 	}
 
 	/* need to create new entry */
@@ -871,6 +873,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return d_events;
 	}
 
+	system->nr_events = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
 		debugfs_remove(system->entry);
@@ -905,6 +908,32 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	return system->entry;
 }
 
+static void remove_subsystem_dir(const char *name)
+{
+	struct event_subsystem *system;
+
+	if (strcmp(name, TRACE_SYSTEM) == 0)
+		return;
+
+	list_for_each_entry(system, &event_subsystems, list) {
+		if (strcmp(system->name, name) == 0) {
+			if (!--system->nr_events) {
+				struct event_filter *filter = system->filter;
+
+				debugfs_remove_recursive(system->entry);
+				list_del(&system->list);
+				if (filter) {
+					kfree(filter->filter_string);
+					kfree(filter);
+				}
+				kfree(system->name);
+				kfree(system);
+			}
+			break;
+		}
+	}
+}
+
 static int
 event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *id,
@@ -1079,6 +1108,7 @@ static void trace_module_remove_events(struct module *mod)
 			list_del(&call->list);
 			trace_destroy_fields(call);
 			destroy_preds(call);
+			remove_subsystem_dir(call->system);
 		}
 	}
 
