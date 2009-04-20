Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZDTRk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZDTRk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZDTRkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:40:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZDTRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:40:19 -0400
Message-Id: <20090420174017.997451662@goodmis.org>
References: <20090420173819.957332585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 13:38:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] tracing: fix recursive test level calculation
Content-Disposition: inline; filename=0003-tracing-fix-recursive-test-level-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The recursive tests to detect same level recursion in the ring buffers
did not account for the hard/softirq_counts to be shifted. Thus the
numbers could be larger than then mask to be tested.

This patch includes the shift for the calculation of the irq depth.

[ Impact: stop false positives in trace recursion detection ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e145969..aa40ae9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1483,7 +1483,9 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 static int trace_irq_level(void)
 {
-	return hardirq_count() + softirq_count() + in_nmi();
+	return (hardirq_count() >> HARDIRQ_SHIFT) +
+		(softirq_count() >> + SOFTIRQ_SHIFT) +
+		!!in_nmi();
 }
 
 static int trace_recursive_lock(void)
-- 
1.6.2.1

-- 
