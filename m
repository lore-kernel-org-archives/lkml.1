Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYLWQfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYLWQfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYLWQfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:35:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLWQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:35:00 -0500
Message-Id: <20081223163457.804471305@goodmis.org>
References: <20081223163223.625941559@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 11:32:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ring-buffer: fix dangling commit race
Content-Disposition: inline; filename=0001-ring-buffer-fix-dangling-commit-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to stuck buffers

If an interrupt comes in during the rb_set_commit_to_write and
pushes the tail page forward just at the right time, the commit
updates will miss the adding of the interrupt data. This will
cause the commit pointer to cease from moving forward.

Thanks to Jiaying Zhang for finding this race.

Reported-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..f64aee5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -769,6 +769,7 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	 * back to us). This allows us to do a simple loop to
 	 * assign the commit to the tail.
 	 */
+ again:
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
 		cpu_buffer->commit_page->commit =
 			cpu_buffer->commit_page->write;
@@ -783,6 +784,17 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 			cpu_buffer->commit_page->write;
 		barrier();
 	}
+
+	/* again, keep gcc from optimizing */
+	barrier();
+
+	/*
+	 * If an interrupt came in just after the first while loop
+	 * and pushed the tail page forward, we will be left with
+	 * a dangling commit that will never go forward.
+	 */
+	if (unlikely(cpu_buffer->commit_page != cpu_buffer->tail_page))
+		goto again;
 }
 
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
-- 
1.5.6.5

-- 
