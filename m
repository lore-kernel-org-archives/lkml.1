Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZDKHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZDKHv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbZDKHvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:51:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62737 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbZDKHvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:51:37 -0400
Message-ID: <49E04C32.6060508@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:52:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] tracing/filters: NUL-terminate user input filter
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure messages from user space are NUL-terminated strings,
otherwise we could dump random memory while reading filter file.

Try this:
 # echo 'parent_comm ==' > events/sched/sched_process_fork/filter
 # cat events/sched/sched_process_fork/filter
 parent_comm == �

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 64ec4d2..054bc18 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -503,6 +503,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
 	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 	if (!pred)
@@ -569,6 +570,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
+	buf[cnt] = '\0';
 
 	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 	if (!pred)
-- 
1.5.4.rc3

