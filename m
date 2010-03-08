Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0CHGuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:50:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57152 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0CHGur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:50:47 -0500
Message-ID: <4B949E43.2010906@cn.fujitsu.com>
Date: Mon, 08 Mar 2010 14:50:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
References: <4B94936B.8030409@cn.fujitsu.com>
In-Reply-To: <4B94936B.8030409@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> While running a ftrace test, a kernel warning showed up. The bug is not so
> easy to reproduce, normally it takes 30 mins to 2 hours.
> 
> After revering 3c05d7482777f15e71bb4cb1ba78dee2800dfec6, I ran the test
> for 15 hours, and the bug seems disapeared.
> 

This bug exhausted us, we found a issue: a tiny window which is
one of causes of this bug. This patch is to close this tiny window.
(bug is not fixed)

From: Lai Jiangshan <laijs@cn.fujitsu.com>

ringbuffer resizing and reseting will increase the ->record_disabled
and then wait until a rcu_shced grace period passes.

Contrarily, testing ->record_disabled should be at the same
preempt disabled critical region as writing into ringbuffer, otherwise
it will leave a window break ringbuffer resizing or reseting.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8c1b2d2..54191d6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2232,12 +2232,12 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
-	if (atomic_read(&buffer->record_disabled))
-		return NULL;
-
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out_nocheck;
+
 	if (trace_recursive_lock())
 		goto out_nocheck;
 
@@ -2469,11 +2469,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
-	if (atomic_read(&buffer->record_disabled))
-		return -EBUSY;
-
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))


