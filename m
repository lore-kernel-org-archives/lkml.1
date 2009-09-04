Return-Path: <linux-kernel-owner+w=401wt.eu-S934124AbZIEABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbZIEABW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZIEABU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927AbZIEABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:19 -0400
Message-Id: <20090905000120.022273594@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/18] ring-buffer: do not reset while in a commit
Content-Disposition: inline; filename=0001-ring-buffer-do-not-reset-while-in-a-commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The callers of reset must ensure that no commit can be taking place
at the time of the reset. If it does then we may corrupt the ring buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index da2c59d..79d6012 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3373,12 +3373,16 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
+	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
+		goto out;
+
 	__raw_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
 	__raw_spin_unlock(&cpu_buffer->lock);
 
+ out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
-- 
1.6.3.3

-- 
