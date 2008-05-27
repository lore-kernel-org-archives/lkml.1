Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYE0Ogt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYE0Ogt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYE0Og2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:36:28 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:7648 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYE0Og0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:36:26 -0400
Message-ID: <483C1C5A.5000001@hp.com>
Date: Tue, 27 May 2008 10:36:10 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-btrace@vger.kernel.org
Subject: [PATCH] Changed blk trace msgs to directly use relay buffer
Content-Type: multipart/mixed;
 boundary="------------080602070900050801030108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080602070900050801030108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------080602070900050801030108
Content-Type: text/x-diff;
 name="0001-Changed-blk-trace-msgs-to-directly-use-relay-buffer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Changed-blk-trace-msgs-to-directly-use-relay-buffer.pat";
 filename*1="ch"

>From 43c8ea2b78f31d7ccd349384a9a2084e787aafc1 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Tue, 27 May 2008 10:32:36 -0400
Subject: [PATCH] Changed blk trace msgs to directly use relay buffer

Allows for SMP-usage without corruption, and removes an extra copy at
the expense of copying extra bytes. Reduced message size from 1024 to 128.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blktrace.c             |   42 ++++++++++++++++++++++++++----------------
 include/linux/blktrace_api.h |    2 +-
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 20e11f3..38e6b83 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -27,6 +27,20 @@
 
 static unsigned int blktrace_seq __read_mostly = 1;
 
+static inline void note_header(struct blk_io_trace *t, struct blk_trace *bt,
+				pid_t pid, int action, size_t len)
+{
+	const int cpu = smp_processor_id();
+
+	t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
+	t->time = ktime_to_ns(ktime_get());
+	t->device = bt->dev;
+	t->action = action;
+	t->pid = pid;
+	t->cpu = cpu;
+	t->pdu_len = len;
+}
+
 /*
  * Send out a notify message.
  */
@@ -37,15 +51,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 
 	t = relay_reserve(bt->rchan, sizeof(*t) + len);
 	if (t) {
-		const int cpu = smp_processor_id();
-
-		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
-		t->time = ktime_to_ns(ktime_get());
-		t->device = bt->dev;
-		t->action = action;
-		t->pid = pid;
-		t->cpu = cpu;
-		t->pdu_len = len;
+		note_header(t, bt, pid, action, len);
 		memcpy((void *) t + sizeof(*t), data, len);
 	}
 }
@@ -77,15 +83,19 @@ static void trace_note_time(struct blk_trace *bt)
 
 void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 {
-	int n;
-	va_list args;
-	static char bt_msg_buf[BLK_TN_MAX_MSG];
+	struct blk_io_trace *t;
 
-	va_start(args, fmt);
-	n = vscnprintf(bt_msg_buf, BLK_TN_MAX_MSG, fmt, args);
-	va_end(args);
+	t = relay_reserve(bt->rchan, sizeof(*t) + BLK_TN_MAX_MSG);
+	if (t) {
+		va_list args;
+		char *bt_msg_buf = (void *) t + sizeof(*t);
+
+		va_start(args, fmt);
+		vscnprintf(bt_msg_buf, BLK_TN_MAX_MSG, fmt, args);
+		va_end(args);
 
-	trace_note(bt, 0, BLK_TN_MESSAGE, bt_msg_buf, n);
+		note_header(t, bt, 0, BLK_TN_MESSAGE, BLK_TN_MAX_MSG);
+	}
 }
 EXPORT_SYMBOL_GPL(__trace_note_message);
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index b7cd8f1..3228caa 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -172,7 +172,7 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 		if (unlikely(bt))					\
 			__trace_note_message(bt, fmt, ##__VA_ARGS__);	\
 	} while (0)
-#define BLK_TN_MAX_MSG		1024
+#define BLK_TN_MAX_MSG		128
 
 /**
  * blk_add_trace_rq - Add a trace for a request oriented action
-- 
1.5.4.3


--------------080602070900050801030108--
