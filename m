Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbZDLKH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbZDLKH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbZDLKHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:07:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53509 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZDLKHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:07:46 -0400
Date: Sun, 12 Apr 2009 10:06:59 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E04C53.4010600@cn.fujitsu.com>
References: <49E04C53.4010600@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: allow user input integer to be oct or hex
Message-ID: <tip-a3e0ab050774117d4a6173087c8bf3888662a83f@git.kernel.org>
Git-Commit-ID: a3e0ab050774117d4a6173087c8bf3888662a83f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:07:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3e0ab050774117d4a6173087c8bf3888662a83f
Gitweb:     http://git.kernel.org/tip/a3e0ab050774117d4a6173087c8bf3888662a83f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Sat, 11 Apr 2009 15:52:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 11:59:28 +0200

tracing/filters: allow user input integer to be oct or hex

Before patch:

 # echo 'parent_pid == 0x10' > events/sched/sched_process_fork/filter
 # cat sched/sched_process_fork/filter
 parent_pid == 0

After patch:

 # cat sched/sched_process_fork/filter
 parent_pid == 16

Also check the input more strictly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49E04C53.4010600@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9d2162f..49b3ef5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -419,12 +419,13 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 	if (!pred->field_name)
 		return -ENOMEM;
 
-	pred->val = simple_strtoull(val_str, &tmp, 10);
+	pred->val = simple_strtoull(val_str, &tmp, 0);
 	if (tmp == val_str) {
 		pred->str_val = kstrdup(val_str, GFP_KERNEL);
 		if (!pred->str_val)
 			return -ENOMEM;
-	}
+	} else if (*tmp != '\0')
+		return -EINVAL;
 
 	return 0;
 }
