Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0CCQQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:16:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0CCQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:16:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=IeSQA1JZBT4A:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=fWOv_dRHKM8uQig2eYIA:9 a=Y-FfoIOLJhn0sSkThSWHQludiEwA:4 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Fix warning in s_next of trace file ops
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 11:16:12 -0500
Message-ID: <1267632972.10871.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (1):
      tracing: Fix warning in s_next of trace file ops

----
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit ac91d85456372a90af5b85eb6620fd2efb1e431b
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Mar 2 17:54:50 2010 +0800

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

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..5edf410 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1703,6 +1703,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		ftrace_enable_cpu();
 
+		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 


