Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZAHF3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZAHF3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 00:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZAHF3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 00:29:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbZAHF3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 00:29:35 -0500
Date: Wed, 7 Jan 2009 21:29:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-Id: <20090107212912.e2903579.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 23:58:39 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

>  kernel/trace/ring_buffer.c |    8 +++++++-

<looks>

heavens, what a lot of inlining.  Looks like something from 1997 :)

Prove me wrong!


From: Andrew Morton <akpm@linux-foundation.org>

          text    data     bss     dec     hex filename
before:  11320     228       8   11556    2d24 kernel/trace/ring_buffer.o
after:   10592     228       8   10828    2a4c kernel/trace/ring_buffer.o

Also: free_page(0) is legal.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ring_buffer.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining
+++ a/kernel/trace/ring_buffer.c
@@ -133,7 +133,7 @@ enum {
 };
 
 /* inline for ring buffer fast paths */
-static inline unsigned
+static unsigned
 rb_event_length(struct ring_buffer_event *event)
 {
 	unsigned length;
@@ -173,7 +173,7 @@ unsigned ring_buffer_event_length(struct
 EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 
 /* inline for ring buffer fast paths */
-static inline void *
+static void *
 rb_event_data(struct ring_buffer_event *event)
 {
 	BUG_ON(event->type != RINGBUF_TYPE_DATA);
@@ -223,10 +223,9 @@ static void rb_init_page(struct buffer_d
  * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
  * this issue out.
  */
-static inline void free_buffer_page(struct buffer_page *bpage)
+static void free_buffer_page(struct buffer_page *bpage)
 {
-	if (bpage->page)
-		free_page((unsigned long)bpage->page);
+	free_page((unsigned long)bpage->page);
 	kfree(bpage);
 }
 
@@ -805,7 +804,7 @@ rb_event_index(struct ring_buffer_event 
 	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
 }
 
-static inline int
+static int
 rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct ring_buffer_event *event)
 {
@@ -819,7 +818,7 @@ rb_is_commit(struct ring_buffer_per_cpu 
 		rb_commit_index(cpu_buffer) == index;
 }
 
-static inline void
+static void
 rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
 		    struct ring_buffer_event *event)
 {
@@ -844,7 +843,7 @@ rb_set_commit_event(struct ring_buffer_p
 	local_set(&cpu_buffer->commit_page->page->commit, index);
 }
 
-static inline void
+static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	/*
@@ -890,7 +889,7 @@ static void rb_reset_reader_page(struct 
 	cpu_buffer->reader_page->read = 0;
 }
 
-static inline void rb_inc_iter(struct ring_buffer_iter *iter)
+static void rb_inc_iter(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 
@@ -920,7 +919,7 @@ static inline void rb_inc_iter(struct ri
  * and with this, we can determine what to place into the
  * data field.
  */
-static inline void
+static void
 rb_update_event(struct ring_buffer_event *event,
 			 unsigned type, unsigned length)
 {
@@ -958,7 +957,7 @@ rb_update_event(struct ring_buffer_event
 	}
 }
 
-static inline unsigned rb_calculate_event_length(unsigned length)
+static unsigned rb_calculate_event_length(unsigned length)
 {
 	struct ring_buffer_event event; /* Used only for sizeof array */
 
@@ -1432,7 +1431,7 @@ int ring_buffer_write(struct ring_buffer
 }
 EXPORT_SYMBOL_GPL(ring_buffer_write);
 
-static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = cpu_buffer->reader_page;
 	struct buffer_page *head = cpu_buffer->head_page;
_

