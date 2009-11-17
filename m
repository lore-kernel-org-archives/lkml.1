Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZKQROE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZKQROE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZKQROB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:14:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbZKQRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:13:53 -0500
Message-Id: <20091117171355.389108862@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 17 Nov 2009 12:12:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] [PATCH 1/3] ring-buffer: Move access to commit_page up into function used
References: <20091117171242.761539651@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Move-access-to-commit_page-up-into-funct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the change of the way we process commits. Where a commit only happens
at the outer most level, and that we don't need to worry about
a commit ending after the rb_start_commit() has been called, the code
use to grab the commit page before the tail page to prevent a possible
race. But this race no longer exists with the rb_start_commit()
rb_end_commit() interface.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..4b8293f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1785,9 +1785,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 static struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
-	     struct buffer_page *commit_page,
 	     struct buffer_page *tail_page, u64 *ts)
 {
+	struct buffer_page *commit_page = cpu_buffer->commit_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct buffer_page *next_page;
 	int ret;
@@ -1890,13 +1890,10 @@ static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		  unsigned type, unsigned long length, u64 *ts)
 {
-	struct buffer_page *tail_page, *commit_page;
+	struct buffer_page *tail_page;
 	struct ring_buffer_event *event;
 	unsigned long tail, write;
 
-	commit_page = cpu_buffer->commit_page;
-	/* we just need to protect against interrupts */
-	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
 
@@ -1907,7 +1904,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	/* See if we shot pass the end of this buffer page */
 	if (write > BUF_PAGE_SIZE)
 		return rb_move_tail(cpu_buffer, length, tail,
-				    commit_page, tail_page, ts);
+				    tail_page, ts);
 
 	/* We reserved something on the buffer */
 
-- 
1.6.5


