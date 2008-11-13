Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYKMFLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYKMFLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKMFLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:11:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYKMFLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:11:08 -0500
Message-Id: <20081113051105.827635641@goodmis.org>
References: <20081113050933.625130887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Nov 2008 00:09:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: show buffer size in kilobytes
Content-Disposition: inline; filename=0002-ftrace-show-buffer-size-in-kilobytes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: change the units of buffer_size to kilobytes

This patch changes the units of the buffer_size file to kilobytes.
Reading and writing to the file uses kilobytes as units. To help
users to know what units are used, the output of the file now
looks like:

  # cat /debug/tracing/buffer_size
  1408 (units kilobytes)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |   22 +++++-----------------
 kernel/trace/trace.c     |    5 ++++-
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index 01ac404..6fe99b4 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -94,10 +94,10 @@ of ftrace. Here is a list of some of the key files:
 		only be recorded if the latency is greater than
 		the value in this file. (in microseconds)
 
-  buffer_size: This sets or displays the number of bytes each CPU
+  buffer_size: This sets or displays the number of kilobytes each CPU
 		buffer can hold. The tracer buffers are the same size
 		for each CPU. The displayed number is the size of the
-		 CPU buffer and not total size of all buffers. The
+		CPU buffer and not total size of all buffers. The
 		trace buffers are allocated in pages (blocks of memory
 		that the kernel uses for allocation, usually 4 KB in size).
 		If the last page allocated has room for more bytes
@@ -1306,28 +1306,16 @@ the full size, multiply the number of possible CPUS with the
 number of entries.
 
  # cat /debug/tracing/buffer_size
-65620
+1408 (units kilobytes)
 
 Note, to modify this, you must have tracing completely disabled. To do that,
 echo "nop" into the current_tracer. If the current_tracer is not set
 to "nop", an EINVAL error will be returned.
 
  # echo nop > /debug/tracing/current_tracer
- # echo 100000 > /debug/tracing/buffer_size
+ # echo 10000 > /debug/tracing/buffer_size
  # cat /debug/tracing/buffer_size
-100045
-
-
-Notice that we echoed in 100,000 but the size is 100,045. The entries
-are held in individual pages. It allocates the number of pages it takes
-to fulfill the request. If more entries may fit on the last page
-then they will be added.
-
- # echo 1 > /debug/tracing/buffer_size
- # cat /debug/tracing/buffer_size
-85
-
-This shows us that 85 entries can fit in a single page.
+10000 (units kilobytes)
 
 The number of pages which will be allocated is limited to a percentage
 of available memory. Allocating too much will produce an error.
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 20fe77d..10f7de2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2922,7 +2922,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 	char buf[64];
 	int r;
 
-	r = sprintf(buf, "%lu\n", tr->entries);
+	r = snprintf(buf, 64, "%lu (units kilobytes)\n", tr->entries >> 10);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
@@ -2962,6 +2962,9 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 			atomic_inc(&max_tr.data[cpu]->disabled);
 	}
 
+	/* value is in KB */
+	val <<= 10;
+
 	if (val != global_trace.entries) {
 		ret = ring_buffer_resize(global_trace.buffer, val);
 		if (ret < 0) {
-- 
1.5.6.5

-- 
