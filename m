Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbZEOOne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbZEOOne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZEOOnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:43:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:54692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZEOOnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:43:23 -0400
Date: Fri, 15 May 2009 14:42:52 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A0CDC6F.7070200@cn.fujitsu.com>
References: <4A0CDC6F.7070200@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filters: add missing unlock in a failure path
Message-ID: <tip-8cd995b6deedf98b7694ed32a786ee7f793d1eec@git.kernel.org>
Git-Commit-ID: 8cd995b6deedf98b7694ed32a786ee7f793d1eec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:42:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cd995b6deedf98b7694ed32a786ee7f793d1eec
Gitweb:     http://git.kernel.org/tip/8cd995b6deedf98b7694ed32a786ee7f793d1eec
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 15 May 2009 11:07:27 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 May 2009 23:55:10 -0400

tracing/filters: add missing unlock in a failure path

[ Impact: fix deadlock in a rare case we fail to allocate memory ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A0CDC6F.7070200@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace_events_filter.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 85ad6a8..22c2998 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1079,9 +1079,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		return 0;
 	}
 
+	err = -ENOMEM;
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-		return -ENOMEM;
+		goto out_unlock;
 
 	filter_disable_preds(call);
 	replace_filter_string(call->filter, filter_string);
@@ -1101,7 +1102,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+out_unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
@@ -1123,9 +1124,10 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		return 0;
 	}
 
+	err = -ENOMEM;
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-		return -ENOMEM;
+		goto out_unlock;
 
 	filter_free_subsystem_preds(system);
 	replace_filter_string(system->filter, filter_string);
@@ -1145,7 +1147,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+out_unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
