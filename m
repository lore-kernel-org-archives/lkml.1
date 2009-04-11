Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZDKHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZDKHws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbZDKHvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:51:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60964 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbZDKHvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:51:52 -0400
Message-ID: <49E04C43.1050504@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:52:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] tracing/filters: fix NULL pointer dereference
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try this, and you'll see NULL pointer dereference bug:
  # echo -n 'parent_comm ==' > sched/sched_process_fork/filter

Because we passed NULL ptr to simple_strtoull().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

