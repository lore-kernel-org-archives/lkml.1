Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZHRICH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZHRICH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZHRICG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:02:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZHRICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:02:04 -0400
Message-ID: <4A8A5FF5.8080609@cn.fujitsu.com>
Date: Tue, 18 Aug 2009 16:01:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing, sched: mark preempt_schedule() notrace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current preempt_schedule() is not marked notrace. It may be
infinite recursion in __trace_graph_return().

preempt_schedule()
  __trace_graph_return()
    ftrace_preempt_disable() (!!return false!!)
    ftrace_preempt_enable()
      preempt_enable_notrace()
         preempt_schedule() (need_resched() may be true again)


It hardly happens, but marking preempt_schedule() notrace
makes it safer.

One interesting thing is that preempt_schedule() is in
the blacklist of kprobe subsystem. "__kprobes" implies "notrace".
But preempt_schedule() cannot be marked __kprobes for it
has been marked __sched. It is in the blacklist makes me
consider this: should it be marked "notrace" -- YES.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 5184580..2e9e209 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5534,7 +5534,7 @@ out:
  * off of preempt_enable. Kernel preemptions off return from interrupt
  * occur there and call schedule directly.
  */
-asmlinkage void __sched preempt_schedule(void)
+asmlinkage void __sched notrace preempt_schedule(void)
 {
 	struct thread_info *ti = current_thread_info();
 






     

