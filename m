Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZHFCxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZHFCxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZHFCxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:53:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZHFCxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:53:01 -0400
Message-Id: <20090806025300.459675256@goodmis.org>
References: <20090806025206.306150861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Aug 2009 22:52:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Matt Fleming <mjf@gentoo.org>,
       Dave Airlie <airlied@gmail.com>
Subject: [PATCH 1/3] ring-buffer: fix check of try_to_discard result
Content-Disposition: inline; filename=0001-ring-buffer-fix-check-of-try_to_discard-result.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function ring_buffer_discard_commit inversed the code path
of the result of try_to_discard. It should skip incrementing the
entry counter if try_to_discard succeeded. But instead, it increments
the entry conder if it succeeded to discard, and does not increment
it if it fails.

The result of this bug is that filtering will make the stat counters
incorrect.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bf27bb7..2fd1752 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1785,7 +1785,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
-	if (!rb_try_to_discard(cpu_buffer, event))
+	if (rb_try_to_discard(cpu_buffer, event))
 		goto out;
 
 	/*
-- 
1.6.3.3

-- 
