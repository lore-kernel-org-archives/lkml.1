Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZBSD5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZBSD5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZBSD5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:57:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBSD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:57:24 -0500
Date: Wed, 18 Feb 2009 22:57:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH][git pull] tracing: limit the number of loops the ring buffer
 self test can make
Message-ID: <alpine.DEB.1.10.0902182254570.30122@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I added one more fix. Thinking about the solution, although the
disabling of the ring buffer is good enough to prevent the bug
you hit. I became worried about a corrupted ring buffer that can
cause an inifinite loop. This patch adds a fix for that too.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: limit the number of loops the ring buffer self test can make

----
 kernel/trace/trace_selftest.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
---------------------------
commit 4b3e3d228429c75d398f1aa24532e468d3220c49
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Feb 18 22:50:01 2009 -0500

    tracing: limit the number of loops the ring buffer self test can make
    
    Impact: prevent deadlock if ring buffer gets corrupted
    
    This patch adds a paranoid check to make sure the ring buffer consumer
    does not go into an infinite loop. Since the ring buffer has been set
    to read only, the consumer should not loop for more than the ring buffer
    size. A check is added to make sure the consumer does not loop more than
    the ring buffer size.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index a7e0ef6..bc8e80a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -23,10 +23,20 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer_event *event;
 	struct trace_entry *entry;
+	unsigned int loops = 0;
 
 	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
 		entry = ring_buffer_event_data(event);
 
+		/*
+		 * The ring buffer is a size of trace_buf_size, if
+		 * we loop more than the size, there's something wrong
+		 * with the ring buffer.
+		 */
+		if (loops++ > trace_buf_size) {
+			printk(KERN_CONT ".. bad ring buffer ");
+			goto failed;
+		}
 		if (!trace_valid_entry(entry)) {
 			printk(KERN_CONT ".. invalid entry %d ",
 				entry->type);

