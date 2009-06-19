Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZFSPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZFSPV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZFSPVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:21:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZFSPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:21:16 -0400
Message-Id: <20090619151922.830665788@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Jun 2009 11:19:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH v2 0/3] [GIT PULL] Lockless Ring Buffer Version 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The code was rebased to my latest "urgent" branch, as well as some
fixes that my tests brought to light.

This is v2 of the ring buffer design. I made various updates to the
document from comments that I received.

The diff of the document is at the end of this email.


Please pull the latest tip/tracing/ring-buffer-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ring-buffer-2


Steven Rostedt (3):
      ring-buffer: make the buffer a true circular link list
      ring-buffer: make lockless
      ring-buffer: add design document

----
 Documentation/trace/ring-buffer-design.txt |  955 ++++++++++++++++++++++++++++
 include/linux/ring_buffer.h                |    1 -
 kernel/trace/ring_buffer.c                 |  935 ++++++++++++++++++++++-----
 kernel/trace/trace.c                       |    3 -
 4 files changed, 1725 insertions(+), 169 deletions(-)


diff --git a/Documentation/trace/ring-buffer-design.txt b/Documentation/trace/ring-buffer-design.txt
index cca290b..9d30b10 100644
--- a/Documentation/trace/ring-buffer-design.txt
+++ b/Documentation/trace/ring-buffer-design.txt
@@ -5,6 +5,9 @@ Copyright 2009 Red Hat Inc.
    Author:   Steven Rostedt <srostedt@redhat.com>
   License:   The GNU Free Documentation License, Version 1.2
                (dual licensed under the GPL v2)
+Reviewers:   Mathieu Desnoyers, Huang Ying, Hidetoshi Seto,
+	     and Frederic Weisbecker.
+
 
 Written for: 2.6.31
 
@@ -58,9 +61,10 @@ before the consumer could free up anything, the producer will
 overwrite the older data. This will lose the oldest events.
 
 No two writers can write at the same time (on the same per cpu buffer),
-but a writer may preempt another writer, but it must finish writing
+but a writer may interrupt another writer, but it must finish writing
 before the previous writer may continue. This is very important to the
-algorithm. The writers act like a "stack".
+algorithm. The writers act like a "stack". The way interrupts works
+enforces this behavior.
 
 
   writer1 start
@@ -74,9 +78,11 @@ This is very much like a writer being preempted by an interrupt and
 the interrupt doing a write as well.
 
 Readers can happen at any time. But no two readers may run at the
-same time, nor can a reader preempt another reader. A reader can not preempt
-a writer, but it may read/consume from the buffer at the same time as
-a writer is writing, but the reader must be on another processor.
+same time, nor can a reader preempt/interrupt another reader. A reader
+can not preempt/interrupt a writer, but it may read/consume from the
+buffer at the same time as a writer is writing, but the reader must be
+on another processor to do so. A reader may read on its own processor
+and can be preempted by a writer.
 
 A writer can preempt a reader, but a reader can not preempt a writer.
 But a reader can read the buffer at the same time (on another processor)
@@ -99,8 +105,8 @@ allocated but is not attached to the list. When the reader wants
 to read from the buffer, if its page is empty (like it is on start up)
 it will swap its page with the head_page. The old reader page will
 become part of the ring buffer and the head_page will be removed.
-A new head page goes to the page after the old head page (but not
-the page that was swapped in).
+The page after the inserted page (old reader_page) will become the
+new head page.
 
 Once the new page is given to the reader, the reader could do what
 it wants with it, as long as a writer has left that page.
@@ -141,7 +147,7 @@ only.
   +------+ <---------------+ v
     |  ^          +---+   +---+   +---+
     |  |          |   |-->|   |-->|   |
-    |  |          |   |<--|   |<--|   |<-+
+    |  |          |   |   |   |<--|   |<-+
     |  |          +---+   +---+   +---+  |
     |  |             |             ^ |   |
     |  |             +-------------+ |   |
@@ -182,7 +188,7 @@ if what is in the ring buffer is less than what is held in a buffer page.
 --->|   |<---|   |<---|   |<---|   |<---
     +---+    +---+    +---+    +---+
 
-This case is still legal for this algorithm.
+This case is still valid for this algorithm.
 When the writer leaves the page, it simply goes into the ring buffer
 since the reader page still points to the next location in the ring
 buffer.
@@ -494,7 +500,7 @@ flag set.  This action atomically moves the head page forward.
   +------+
   |reader|          RING BUFFER
   |page  |-------H-----------+
-  +------+ <---------------+ v
+  +------+                   v
     |  ^          +---+   +---+   +---+
     |  |          |   |-->|   |-->|   |
     |  |          |   |<--|   |<--|   |<-+
@@ -510,10 +516,10 @@ updated to the reader page.
   +------+
   |reader|          RING BUFFER
   |page  |-------H-----------+
-  +------+                   v
+  +------+ <---------------+ v
     |  ^          +---+   +---+   +---+
     |  |          |   |-->|   |-->|   |
-    |  |          |   |<--|   |<--|   |<-+
+    |  |          |   |   |   |<--|   |<-+
     |  |          +---+   +---+   +---+  |
     |  |             |             ^ |   |
     |  |             +-------------+ |   |
-- 
