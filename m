Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0CMC7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:59:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759Ab0CMC65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:58:57 -0500
X-Authority-Analysis: v=1.0 c=1 a=IvM2YAiW80kA:10 a=GzHTLUccyWwA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=IC3tHotzItW5zZKPNX4A:9 a=IETZ_mQrS7iGj9heZukA:7 a=iXOPsagZIbTsr7gosu2E-H2WL-gA:4 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100313025854.280882947@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Mar 2010 21:56:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: [PATCH 1/5] ring-buffer: Move disabled check into preempt disable section
References: <20100313025655.104950166@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Move-disabled-check-into-preempt-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The ring buffer resizing and resetting relies on a schedule RCU
action. The buffers are disabled, a synchronize_sched() is called
and then the resize or reset takes place.

But this only works if the disabling of the buffers are within the
preempt disabled section, otherwise a window exists that the buffers
can be written to while a reset or resize takes place.

Cc: stable@kernel.org
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B949E43.2010906@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

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
-- 
1.7.0


