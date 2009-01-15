Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbZAOBbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbZAOBbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZAOBbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:31:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62369 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZAOBbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:31:35 -0500
Message-ID: <496E91CC.4020209@cn.fujitsu.com>
Date: Thu, 15 Jan 2009 09:30:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/ftrace: add missing unlock in register_stat_tracer()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should unlock all_stat_sessions_mutex before returning failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

I noticed Ingo tend to delete the impact line from my changelog
if it added nothing new to the title, so no impact line for this
patch. :)

---
 kernel/trace/trace_stat.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index cb29282..8669f3c 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -73,8 +73,10 @@ int register_stat_tracer(struct tracer_stat *trace)
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
-		if (node->ts == trace)
+		if (node->ts == trace) {
+			mutex_unlock(all_stat_sessions_mutex);
 			return -EINVAL;
+		}
 	}
 	mutex_unlock(&all_stat_sessions_mutex);
 
-- 
1.5.4.rc3
