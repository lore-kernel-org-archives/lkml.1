Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbZIEADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbZIEADr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933904AbZIEADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:03:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbZIEABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:21 -0400
Message-Id: <20090905000123.148772803@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/18] ring-buffer: disable all cpu buffers when one finds a problem
Content-Disposition: inline; filename=0007-ring-buffer-disable-all-cpu-buffers-when-one-finds-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the way RB_WARN_ON works, is to disable either the current
CPU buffer or all CPU buffers, depending on whether a ring_buffer or
ring_buffer_per_cpu struct was passed into the macro.

Most users of the RB_WARN_ON pass in the CPU buffer, so only the one
CPU buffer gets disabled but the rest are still active. This may
confuse users even though a warning is sent to the console.

This patch changes the macro to disable the entire buffer even if
the CPU buffer is passed in.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c8d2a66..f83a42a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -467,14 +467,19 @@ struct ring_buffer_iter {
 };
 
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
-#define RB_WARN_ON(buffer, cond)				\
-	({							\
-		int _____ret = unlikely(cond);			\
-		if (_____ret) {					\
-			atomic_inc(&buffer->record_disabled);	\
-			WARN_ON(1);				\
-		}						\
-		_____ret;					\
+#define RB_WARN_ON(b, cond)						\
+	({								\
+		int _____ret = unlikely(cond);				\
+		if (_____ret) {						\
+			if (__same_type(*(b), struct ring_buffer_per_cpu)) { \
+				struct ring_buffer_per_cpu *__b =	\
+					(void *)b;			\
+				atomic_inc(&__b->buffer->record_disabled); \
+			} else						\
+				atomic_inc(&b->record_disabled);	\
+			WARN_ON(1);					\
+		}							\
+		_____ret;						\
 	})
 
 /* Up this if you want to test the TIME_EXTENTS and normalization */
-- 
1.6.3.3

-- 
