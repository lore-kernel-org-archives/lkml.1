Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZDLKIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZDLKIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZDLKIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:08:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:53515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760059AbZDLKH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:07:58 -0400
Date: Sun, 12 Apr 2009 10:07:11 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E04CF0.3010105@cn.fujitsu.com>
References: <49E04CF0.3010105@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: return proper error code when writing filter file
Message-ID: <tip-44e9c8b7adc52079f0535f9de0c2c2477831389b@git.kernel.org>
Git-Commit-ID: 44e9c8b7adc52079f0535f9de0c2c2477831389b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:07:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44e9c8b7adc52079f0535f9de0c2c2477831389b
Gitweb:     http://git.kernel.org/tip/44e9c8b7adc52079f0535f9de0c2c2477831389b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Sat, 11 Apr 2009 15:55:28 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 11:59:29 +0200

tracing/filters: return proper error code when writing filter file

- propagate return value of filter_add_pred() to the user

- return -ENOSPC but not -ENOMEM or -EINVAL when the filter array
  is full

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49E04CF0.3010105@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c        |   10 ++++++----
 kernel/trace/trace_events_filter.c |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 054bc18..576f4fa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -521,9 +521,10 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return cnt;
 	}
 
-	if (filter_add_pred(call, pred)) {
+	err = filter_add_pred(call, pred);
+	if (err < 0) {
 		filter_free_pred(pred);
-		return -EINVAL;
+		return err;
 	}
 
 	*ppos += cnt;
@@ -588,10 +589,11 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		return cnt;
 	}
 
-	if (filter_add_subsystem_pred(system, pred)) {
+	err = filter_add_subsystem_pred(system, pred);
+	if (err < 0) {
 		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
-		return -EINVAL;
+		return err;
 	}
 
 	*ppos += cnt;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 49b3ef5..e03cbf1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -215,7 +215,7 @@ static int __filter_add_pred(struct ftrace_event_call *call,
 		}
 	}
 
-	return -ENOMEM;
+	return -ENOSPC;
 }
 
 static int is_string_field(const char *type)
@@ -319,7 +319,7 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 	}
 
 	if (i == MAX_FILTER_PRED)
-		return -EINVAL;
+		return -ENOSPC;
 
 	events_for_each(call) {
 		int err;
