Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZEGDPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZEGDPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZEGDOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031433.562803300@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] ring-buffer: remove unneeded conditional in rb_reserve_next
Content-Disposition: inline; filename=0001-ring-buffer-remove-unneeded-conditional-in-rb_reser.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in __rb_reserve_next checks on page overflow if it is the
original commiter and then resets the page back to the original
setting.  Although this is fine, and the code is correct, it is
a bit fragil. Some experimental work I did breaks it easily.

The better and more robust solution is to have all commiters that
overflow the page, simply subtract what they added.

[ Impact: more robust ring buffer account management ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 424129e..03ed52b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1290,9 +1290,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		rb_event_set_padding(event);
 	}
 
-	if (tail <= BUF_PAGE_SIZE)
-		/* Set the write back to the previous setting */
-		local_set(&tail_page->write, tail);
+	/* Set the write back to the previous setting */
+	local_sub(length, &tail_page->write);
 
 	/*
 	 * If this was a commit entry that failed,
@@ -1311,8 +1310,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
  out_reset:
 	/* reset write */
-	if (tail <= BUF_PAGE_SIZE)
-		local_set(&tail_page->write, tail);
+	local_sub(length, &tail_page->write);
 
 	if (likely(lock_taken))
 		__raw_spin_unlock(&cpu_buffer->lock);
-- 
1.6.2.4

-- 
