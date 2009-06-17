Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbZFQX1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbZFQX1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZFQX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232630.066076476@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:25:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/7] ring-buffer: remove useless compile check for buffer_page size
Content-Disposition: inline; filename=0003-ring-buffer-remove-useless-compile-check-for-buffer_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The original version of the ring buffer had a hack to map the
page struct that held the pages of the buffer to also be the structure
that the ring buffer would keep the pages in a link list.

This overlap of the page struct was very dangerous and that hack was
removed a while ago.

But there was a check to make sure the buffer_page never became bigger
than the page struct, and would fail the compile if it did. The
check was only meaningful when we had the hack. Now that we have separate
allocated descriptors for the buffer pages, we can remove this check.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6cf340e..162da23 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -620,12 +620,6 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 	kfree(cpu_buffer);
 }
 
-/*
- * Causes compile errors if the struct buffer_page gets bigger
- * than the struct page.
- */
-extern int ring_buffer_page_too_big(void);
-
 #ifdef CONFIG_HOTPLUG_CPU
 static int rb_cpu_notify(struct notifier_block *self,
 			 unsigned long action, void *hcpu);
@@ -648,11 +642,6 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	int bsize;
 	int cpu;
 
-	/* Paranoid! Optimizes out when all is well */
-	if (sizeof(struct buffer_page) > sizeof(struct page))
-		ring_buffer_page_too_big();
-
-
 	/* keep it in its own cache line */
 	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
 			 GFP_KERNEL);
-- 
1.6.3.1

-- 
