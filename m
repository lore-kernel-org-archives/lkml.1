Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0CDQbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:31:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:48384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab0CDQbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:31:10 -0500
Date: Thu, 4 Mar 2010 16:30:42 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B8CE06A.9090207@cn.fujitsu.com>
References: <4B8CE06A.9090207@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix warning in s_next of trace file ops
Message-ID: <tip-ac91d85456372a90af5b85eb6620fd2efb1e431b@git.kernel.org>
Git-Commit-ID: ac91d85456372a90af5b85eb6620fd2efb1e431b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac91d85456372a90af5b85eb6620fd2efb1e431b
Gitweb:     http://git.kernel.org/tip/ac91d85456372a90af5b85eb6620fd2efb1e431b
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 2 Mar 2010 17:54:50 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 2 Mar 2010 21:11:47 -0500

tracing: Fix warning in s_next of trace file ops

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

The iterator "leftover" variable is zeroed in the opening of the trace
file. But lseek can call s_start() which will call s_next() without
reseting the "leftover" variable back to zero, which might trigger
the WARN_ON_ONCE(iter->leftover) that is in s_next().

Cc: stable@kernel.org
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B8CE06A.9090207@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..5edf410 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1703,6 +1703,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		ftrace_enable_cpu();
 
+		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 
