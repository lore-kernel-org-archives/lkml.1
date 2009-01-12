Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZALDHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZALDHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZALDHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:07:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZALDHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:07:14 -0500
Message-ID: <496AB3AA.4060005@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 11:06:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: reset write when reserve buffer fail
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: reset struct buffer_page.write when interrupt storm

if struct buffer_page.write is not reset, any succedent committing
will corrupted ring_buffer:

static inline void
rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
{
	......
		cpu_buffer->commit_page->commit =
			cpu_buffer->commit_page->write;
	......
}


when "if (RB_WARN_ON(cpu_buffer, next_page == reader_page))", ring_buffer
is disabled, but some reserved buffers may haven't been committed.
we need reset struct buffer_page.write.

when "if (unlikely(next_page == cpu_buffer->commit_page))", ring_buffer
is still available, we should not corrupt it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8b0daf0..18bfd76 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1025,12 +1025,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		}
 
 		if (next_page == head_page) {
-			if (!(buffer->flags & RB_FL_OVERWRITE)) {
-				/* reset write */
-				if (tail <= BUF_PAGE_SIZE)
-					local_set(&tail_page->write, tail);
+			if (!(buffer->flags & RB_FL_OVERWRITE))
 				goto out_unlock;
-			}
 
 			/* tail_page has not moved yet? */
 			if (tail_page == cpu_buffer->tail_page) {
@@ -1105,6 +1101,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 
  out_unlock:
+	/* reset write */
+	if (tail <= BUF_PAGE_SIZE)
+		local_set(&tail_page->write, tail);
+
 	__raw_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 	return NULL;


