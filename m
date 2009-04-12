Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbZDLKHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbZDLKHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbZDLKHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:07:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:53499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbZDLKH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:07:29 -0400
Date: Sun, 12 Apr 2009 10:06:47 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E04C43.1050504@cn.fujitsu.com>
References: <49E04C43.1050504@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: fix NULL pointer dereference
Message-ID: <tip-bcabd91c271e50eebc0cb9220ac92700332b452e@git.kernel.org>
Git-Commit-ID: bcabd91c271e50eebc0cb9220ac92700332b452e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcabd91c271e50eebc0cb9220ac92700332b452e
Gitweb:     http://git.kernel.org/tip/bcabd91c271e50eebc0cb9220ac92700332b452e
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Sat, 11 Apr 2009 15:52:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 11:59:28 +0200

tracing/filters: fix NULL pointer dereference

Try this, and you'll see NULL pointer dereference bug:

  # echo -n 'parent_comm ==' > sched/sched_process_fork/filter

Because we passed NULL ptr to simple_strtoull().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49E04C43.1050504@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 026be41..9d2162f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -410,6 +410,11 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 		}
 	}
 
+	if (!val_str) {
+		pred->field_name = NULL;
+		return -EINVAL;
+	}
+
 	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
 	if (!pred->field_name)
 		return -ENOMEM;
