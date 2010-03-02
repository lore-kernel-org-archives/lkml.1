Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab0CBJzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:55:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62957 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0CBJzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:55:07 -0500
Message-ID: <4B8CE06A.9090207@cn.fujitsu.com>
Date: Tue, 02 Mar 2010 17:54:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix warning in s_next
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning in s_next() can be triggered by lseek():
 [<c018b3f7>] ? s_next+0x77/0x80
 [<c013e3c1>] warn_slowpath_common+0x81/0xa0
 [<c018b3f7>] ? s_next+0x77/0x80
 [<c013e3fa>] warn_slowpath_null+0x1a/0x20
 [<c018b3f7>] s_next+0x77/0x80
 [<c01efa77>] traverse+0x117/0x200
 [<c01eff13>] seq_lseek+0xa3/0x120
 [<c01efe70>] ? seq_lseek+0x0/0x120
 [<c01d7081>] vfs_llseek+0x41/0x50
 [<c01d8116>] sys_llseek+0x66/0xa0
 [<c0102bd0>] sysenter_do_call+0x12/0x26

It is because s_start() calls s_next() without reset leftover.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..5edf410 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1703,6 +1703,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		ftrace_enable_cpu();
 
+		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 
