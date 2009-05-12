Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZELEMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZELEMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZELELF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZELELA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:11:00 -0400
Message-Id: <20090512041059.394777112@goodmis.org>
References: <20090512040832.681953177@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 12 May 2009 00:08:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] ring-buffer: small optimizations
Content-Disposition: inline; filename=0003-ring-buffer-small-optimizations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Doing some small changes in the fast path of the ring buffer recording
saves over 3% in the ring-buffer-benchmark test.

[ Impact: a little faster ring buffer recording ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 493cba4..f452de2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1000,7 +1000,7 @@ rb_event_index(struct ring_buffer_event *event)
 	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
 }
 
-static int
+static inline int
 rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct ring_buffer_event *event)
 {
@@ -1423,9 +1423,9 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * also be made. But only the entry that did the actual
 	 * commit will be something other than zero.
 	 */
-	if (cpu_buffer->tail_page == cpu_buffer->commit_page &&
-	    rb_page_write(cpu_buffer->tail_page) ==
-	    rb_commit_index(cpu_buffer)) {
+	if (likely(cpu_buffer->tail_page == cpu_buffer->commit_page &&
+		   rb_page_write(cpu_buffer->tail_page) ==
+		   rb_commit_index(cpu_buffer))) {
 
 		delta = ts - cpu_buffer->write_stamp;
 
@@ -1436,7 +1436,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 		if (unlikely(ts < cpu_buffer->write_stamp))
 			delta = 0;
 
-		if (test_time_stamp(delta)) {
+		else if (unlikely(test_time_stamp(delta))) {
 
 			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
 
@@ -1470,7 +1470,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * If the timestamp was commited, make the commit our entry
 	 * now so that we will update it when needed.
 	 */
-	if (commit)
+	if (unlikely(commit))
 		rb_set_commit_event(cpu_buffer, event);
 	else if (!rb_is_commit(cpu_buffer, event))
 		delta = 0;
-- 
1.6.2.4

-- 
