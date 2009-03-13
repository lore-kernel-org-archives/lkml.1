Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZCMCoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZCMCoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbZCMCil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549AbZCMCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:30 -0400
Message-Id: <20090313023828.288926973@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 16/16] ring-buffer: document reader page design
Content-Disposition: inline; filename=0016-ring-buffer-document-reader-page-design.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

In a private email conversation I explained how the ring buffer
page worked by using silly ASCII art. Ingo suggested that I add
that to the comments of the code.

Here it is.

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   68 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2c36be9..58128ad 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -22,6 +22,74 @@
 #include "trace.h"
 
 /*
+ * The ring buffer is made up of a list of pages. A separate list of pages is
+ * allocated for each CPU. A writer may only write to a buffer that is
+ * associated with the CPU it is currently executing on.  A reader may read
+ * from any per cpu buffer.
+ *
+ * The reader is special. For each per cpu buffer, the reader has its own
+ * reader page. When a reader has read the entire reader page, this reader
+ * page is swapped with another page in the ring buffer.
+ *
+ * Now, as long as the writer is off the reader page, the reader can do what
+ * ever it wants with that page. The writer will never write to that page
+ * again (as long as it is out of the ring buffer).
+ *
+ * Here's some silly ASCII art.
+ *
+ *   +------+
+ *   |reader|          RING BUFFER
+ *   |page  |
+ *   +------+        +---+   +---+   +---+
+ *                   |   |-->|   |-->|   |
+ *                   +---+   +---+   +---+
+ *                     ^               |
+ *                     |               |
+ *                     +---------------+
+ *
+ *
+ *   +------+
+ *   |reader|          RING BUFFER
+ *   |page  |------------------v
+ *   +------+        +---+   +---+   +---+
+ *                   |   |-->|   |-->|   |
+ *                   +---+   +---+   +---+
+ *                     ^               |
+ *                     |               |
+ *                     +---------------+
+ *
+ *
+ *   +------+
+ *   |reader|          RING BUFFER
+ *   |page  |------------------v
+ *   +------+        +---+   +---+   +---+
+ *      ^            |   |-->|   |-->|   |
+ *      |            +---+   +---+   +---+
+ *      |                              |
+ *      |                              |
+ *      +------------------------------+
+ *
+ *
+ *   +------+
+ *   |buffer|          RING BUFFER
+ *   |page  |------------------v
+ *   +------+        +---+   +---+   +---+
+ *      ^            |   |   |   |-->|   |
+ *      |   New      +---+   +---+   +---+
+ *      |  Reader------^               |
+ *      |   page                       |
+ *      +------------------------------+
+ *
+ *
+ * After we make this swap, the reader can hand this page off to the splice
+ * code and be done with it. It can even allocate a new page if it needs to
+ * and swap that into the ring buffer.
+ *
+ * We will be using cmpxchg soon to make all this lockless.
+ *
+ */
+
+/*
  * A fast way to enable or disable all ring buffers is to
  * call tracing_on or tracing_off. Turning off the ring buffers
  * prevents all ring buffers from being recorded to.
-- 
1.6.1.3

-- 
