Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZHFG2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZHFG2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZHFG2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:28:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53224 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZHFG2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=OHM/afB93yVgvK37qtHHqtD/QB5vhTZ6QSKzidYX5x4d5yw1UDu2/ADxXneE1BrUXc
         WavR9JNm/A/YGzB9UM6HIi3Bz79R/2bXwddAnjowNrtAmlu1j2UhmeBsLWjQhFhJvZV4
         Z735Ipfw7p9R26Ah7GC2T7s8cIS3c/ZqpjW9M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/7] tracing/events: Only define remove_subsystem_dir() if CONFIG_MODULES
Date: Thu,  6 Aug 2009 08:27:38 +0200
Message-Id: <1249540058-5528-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we disable modules, we get the following warning in ftrace events
file:

kernel/trace/trace_events.c:912: attention : ‘remove_subsystem_dir’ defined but not used

remove_subystem_dir() is useless if !CONFIG_MODULES, then move it to
the appropriate #ifdef section of trace_events.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   52 +++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cf936..70ecb76 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -908,32 +908,6 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	return system->entry;
 }
 
-static void remove_subsystem_dir(const char *name)
-{
-	struct event_subsystem *system;
-
-	if (strcmp(name, TRACE_SYSTEM) == 0)
-		return;
-
-	list_for_each_entry(system, &event_subsystems, list) {
-		if (strcmp(system->name, name) == 0) {
-			if (!--system->nr_events) {
-				struct event_filter *filter = system->filter;
-
-				debugfs_remove_recursive(system->entry);
-				list_del(&system->list);
-				if (filter) {
-					kfree(filter->filter_string);
-					kfree(filter);
-				}
-				kfree(system->name);
-				kfree(system);
-			}
-			break;
-		}
-	}
-}
-
 static int
 event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *id,
@@ -1018,6 +992,32 @@ struct ftrace_module_file_ops {
 	struct file_operations		filter;
 };
 
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
 static struct ftrace_module_file_ops *
 trace_create_file_ops(struct module *mod)
 {
-- 
1.6.2.3

