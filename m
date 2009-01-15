Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbZAOAE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbZAOAE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbZAOADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:03:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbZAOADe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:03:34 -0500
Message-Id: <20090115000332.355796420@goodmis.org>
References: <20090115000254.519563275@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 Jan 2009 19:02:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] ring_buffer: reset write when reserve buffer fail
Content-Disposition: inline; filename=0002-ring_buffer-reset-write-when-reserve-buffer-fail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

[ The following text is in the "UTF-8" character set. ]
    [ Your display is set for the "ANSI_X3.4-1968" character set.  ]
    [ Some characters may be displayed incorrectly. ]

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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4832ffa..0b9de5a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1017,12 +1017,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
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
@@ -1097,6 +1093,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 
  out_unlock:
+	/* reset write */
+	if (tail <= BUF_PAGE_SIZE)
+		local_set(&tail_page->write, tail);
+
 	__raw_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 	return NULL;
-- 
1.5.6.5

-- 
