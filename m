Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbZIEAE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbZIEAE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934325AbZIEAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:04:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927AbZIEABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:20 -0400
Message-Id: <20090905000122.271241564@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/18] ring-buffer: remove ring_buffer_event_discard
Content-Disposition: inline; filename=0005-ring-buffer-remove-ring_buffer_event_discard.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function ring_buffer_event_discard can be used on any item in the
ring buffer, even after the item was committed. This function provides
no safety nets and is very race prone.

An item may be safely removed from the ring buffer before it is committed
with the ring_buffer_discard_commit.

Since there are currently no users of this function, and because this
function is racey and error prone, this patch removes it altogether.

Note, removing this function also allows the counters to ignore
all discarded events (patches will follow).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |   14 --------------
 kernel/trace/ring_buffer.c  |   27 ++++++---------------------
 2 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 7fca716..e061b4e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -75,20 +75,6 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 }
 
 /*
- * ring_buffer_event_discard can discard any event in the ring buffer.
- *   it is up to the caller to protect against a reader from
- *   consuming it or a writer from wrapping and replacing it.
- *
- * No external protection is needed if this is called before
- * the event is commited. But in that case it would be better to
- * use ring_buffer_discard_commit.
- *
- * Note, if an event that has not been committed is discarded
- * with ring_buffer_event_discard, it must still be committed.
- */
-void ring_buffer_event_discard(struct ring_buffer_event *event);
-
-/*
  * ring_buffer_discard_commit will remove an event that has not
  *   ben committed yet. If this is used, then ring_buffer_unlock_commit
  *   must not be called on the discarded event. This function
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9d939e7..092fe0c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2328,31 +2328,16 @@ static inline void rb_event_discard(struct ring_buffer_event *event)
 }
 
 /**
- * ring_buffer_event_discard - discard any event in the ring buffer
- * @event: the event to discard
- *
- * Sometimes a event that is in the ring buffer needs to be ignored.
- * This function lets the user discard an event in the ring buffer
- * and then that event will not be read later.
- *
- * Note, it is up to the user to be careful with this, and protect
- * against races. If the user discards an event that has been consumed
- * it is possible that it could corrupt the ring buffer.
- */
-void ring_buffer_event_discard(struct ring_buffer_event *event)
-{
-	rb_event_discard(event);
-}
-EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
-
-/**
  * ring_buffer_commit_discard - discard an event that has not been committed
  * @buffer: the ring buffer
  * @event: non committed event to discard
  *
- * This is similar to ring_buffer_event_discard but must only be
- * performed on an event that has not been committed yet. The difference
- * is that this will also try to free the event from the ring buffer
+ * Sometimes an event that is in the ring buffer needs to be ignored.
+ * This function lets the user discard an event in the ring buffer
+ * and then that event will not be read later.
+ *
+ * This function only works if it is called before the the item has been
+ * committed. It will try to free the event from the ring buffer
  * if another event has not been added behind it.
  *
  * If another event has been added behind it, it will set the event
-- 
1.6.3.3

-- 
