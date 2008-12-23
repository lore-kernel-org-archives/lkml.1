Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbYLWQfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbYLWQfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYLWQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:35:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYLWQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:35:00 -0500
Message-Id: <20081223163458.124168781@goodmis.org>
References: <20081223163223.625941559@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 11:32:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring-buffer: prevent false positive warning
Content-Disposition: inline; filename=0002-ring-buffer-prevent-false-positive-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to false WARN_ON

If an interrupt goes off after the setting of the local variable
tail_page and before incrementing the write index of that page,
the interrupt could push the commit forward to the next page.

Later a check is made to see if interrupts pushed the buffer around
the entire ring buffer by comparing the next page to the last commited
page. This can produce a false positive if the interrupt had pushed
the commit page forward as stated above.

Thanks to Jiaying Zhang for finding this race.

Reported-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f64aee5..71202ac 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -892,12 +892,15 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *tail_page, *head_page, *reader_page;
+	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
 	unsigned long tail, write;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
 	unsigned long flags;
 
+	commit_page = cpu_buffer->commit_page;
+	/* we just need to protect against interrupts */
+	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 	tail = write - length;
@@ -921,7 +924,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 * it all the way around the buffer, bail, and warn
 		 * about it.
 		 */
-		if (unlikely(next_page == cpu_buffer->commit_page)) {
+		if (unlikely(next_page == commit_page)) {
 			WARN_ON_ONCE(1);
 			goto out_unlock;
 		}
-- 
1.5.6.5

-- 
