Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYKKDG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYKKDG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYKKDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:05:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbYKKDFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:05:20 -0500
Message-Id: <20081111030517.249928650@goodmis.org>
References: <20081111025808.946638585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Nov 2008 21:58:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring-buffer: prevent infinite looping on time stamping
Content-Disposition: inline; filename=0002-ring-buffer-prevent-infinite-looping-on-time-stampi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: removal of unnecessary looping

The lockless part of the ring buffer allows for reentry into the code
from interrupts. A timestamp is taken, a test is preformed and if it
detects that an interrupt occurred that did tracing, it tries again.

The problem arises if the timestamp code itself causes a trace.
The detection will detect this and loop again. The difference between
this and an interrupt doing tracing, is that this will fail every time,
and cause an infinite loop.

Currently, we test if the loop happens 1000 times, and if so, it will
produce a warning and disable the ring buffer.

The problem with this approach is that it makes it difficult to perform
some types of tracing (tracing the timestamp code itself).

Each trace entry has a delta timestamp from the previous entry.
If a trace entry is reserved but and interrupt occurs and traces before
the previous entry is commited, the delta timestamp for that entry will
be zero. This actually makes sense in terms of tracing, because the
interrupt entry happened before the preempted entry was commited, so
one may consider the two happening at the same time. The order is
still preserved in the buffer.

With this idea, instead of trying to get a new timestamp if an interrupt
made it in between the timestamp and the test, the entry could simply
make the delta zero and continue. This will prevent interrupts or
tracers in the timer code from causing the above loop.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3f33806..2f76193 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1060,7 +1060,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 		/* Did the write stamp get updated already? */
 		if (unlikely(ts < cpu_buffer->write_stamp))
-			goto again;
+			delta = 0;
 
 		if (test_time_stamp(delta)) {
 
-- 
1.5.6.5

-- 
