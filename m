Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbZDKHxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbZDKHxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbZDKHwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:52:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60128 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbZDKHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:52:08 -0400
Message-ID: <49E04C53.4010600@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:52:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] tracing/filters: allow user input integer to be oct or
 hex
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before patching:
 # echo 'parent_pid == 0x10' > events/sched/sched_process_fork/filter
 # cat sched/sched_process_fork/filter
 parent_pid == 0

After patching:
 # cat sched/sched_process_fork/filter
 parent_pid == 16

Also check the input more strictly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

