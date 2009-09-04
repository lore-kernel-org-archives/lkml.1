Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbZIEAEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbZIEAEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZIEABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44564 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011AbZIEABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:19 -0400
Message-Id: <20090905000120.748914637@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/18] ring-buffer: do not swap buffers during a commit
Content-Disposition: inline; filename=0002-ring-buffer-do-not-swap-buffers-during-a-commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a commit is taking place on a CPU ring buffer, do not allow it to
be swapped. Return -EBUSY when this is detected instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 79d6012..2878bd4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3519,16 +3519,23 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	atomic_inc(&cpu_buffer_a->record_disabled);
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
+	ret = -EBUSY;
+	if (local_read(&cpu_buffer_a->committing))
+		goto out_dec;
+	if (local_read(&cpu_buffer_b->committing))
+		goto out_dec;
+
 	buffer_a->buffers[cpu] = cpu_buffer_b;
 	buffer_b->buffers[cpu] = cpu_buffer_a;
 
 	cpu_buffer_b->buffer = buffer_a;
 	cpu_buffer_a->buffer = buffer_b;
 
+	ret = 0;
+
+out_dec:
 	atomic_dec(&cpu_buffer_a->record_disabled);
 	atomic_dec(&cpu_buffer_b->record_disabled);
-
-	ret = 0;
 out:
 	return ret;
 }
-- 
1.6.3.3

-- 
