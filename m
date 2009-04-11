Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZDKHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZDKHzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbZDKHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:54:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50979 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbZDKHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:54:44 -0400
Message-ID: <49E04CF0.3010105@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:55:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] tracing/filters: return proper error code when writing
 filter file
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- propogate return value of filter_add_pred() to the user
- return -ENOSPC but not -ENOMEM or -EINVAL when the filter array
  is full

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
index 8e3a095..f16a921 100644
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
-- 
1.5.4.rc3

