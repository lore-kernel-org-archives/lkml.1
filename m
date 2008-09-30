Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbYI3DJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbYI3DJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYI3DHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:07:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53645 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYI3DG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:06:57 -0400
Message-Id: <20080930030652.298596016@goodmis.org>
References: <20080930030236.230994826@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 23:02:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/6] ring_buffer: add paranoid check for buffer page
Content-Disposition: inline; filename=ring-buffer-paranoid-buffer-page-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If for some strange reason the buffer_page gets bigger, or the page struct
gets smaller, I want to know this ASAP.  The best way is to not let the
kernel compile.

This patch adds code to test the size of the struct buffer_page against the
page struct and will cause compile issues if the buffer_page ever gets bigger
than the page struct.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-09-29 17:31:05.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-09-29 19:59:24.000000000 -0400
@@ -289,6 +289,12 @@ static void rb_free_cpu_buffer(struct ri
 	kfree(cpu_buffer);
 }
 
+/*
+ * Causes compile errors if the struct buffer_page gets bigger
+ * than the struct page.
+ */
+extern int ring_buffer_page_too_big(void);
+
 /**
  * ring_buffer_alloc - allocate a new ring_buffer
  * @size: the size in bytes that is needed.
@@ -305,6 +311,11 @@ struct ring_buffer *ring_buffer_alloc(un
 	int bsize;
 	int cpu;
 
+	/* Paranoid! Optimizes out when all is well */
+	if (sizeof(struct buffer_page) > sizeof(struct page))
+		ring_buffer_page_too_big();
+
+
 	/* keep it in its own cache line */
 	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
 			 GFP_KERNEL);

-- 
