Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYI3DHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYI3DHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI3DGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:06:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51367 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYI3DGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:06:54 -0400
Message-Id: <20080930030652.497934332@goodmis.org>
References: <20080930030236.230994826@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 23:02:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/6] ring_buffer: reset buffer page when freeing
Content-Disposition: inline; filename=ring-buffer-page-freeing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers pointed out that the freeing of the page frame needs
to be reset otherwise we might trigger BUG_ON in the page free code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-09-29 19:59:24.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-09-29 20:07:32.000000000 -0400
@@ -128,6 +128,17 @@ struct buffer_page {
 };
 
 /*
+ * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
+ * this issue out.
+ */
+static inline void free_buffer_page(struct buffer_page *bpage)
+{
+	reset_page_mapcount(&bpage->page);
+	bpage->page.mapping = NULL;
+	__free_page(&bpage->page);
+}
+
+/*
  * We need to fit the time_stamp delta into 27 bits.
  */
 static inline int test_time_stamp(u64 delta)
@@ -240,7 +251,7 @@ static int rb_allocate_pages(struct ring
  free_pages:
 	list_for_each_entry_safe(page, tmp, &pages, list) {
 		list_del_init(&page->list);
-		__free_page(&page->page);
+		free_buffer_page(page);
 	}
 	return -ENOMEM;
 }
@@ -284,7 +295,7 @@ static void rb_free_cpu_buffer(struct ri
 
 	list_for_each_entry_safe(page, tmp, head, list) {
 		list_del_init(&page->list);
-		__free_page(&page->page);
+		free_buffer_page(page);
 	}
 	kfree(cpu_buffer);
 }
@@ -393,7 +404,7 @@ rb_remove_pages(struct ring_buffer_per_c
 		p = cpu_buffer->pages.next;
 		page = list_entry(p, struct buffer_page, list);
 		list_del_init(&page->list);
-		__free_page(&page->page);
+		free_buffer_page(page);
 	}
 	BUG_ON(list_empty(&cpu_buffer->pages));
 
@@ -520,7 +531,7 @@ int ring_buffer_resize(struct ring_buffe
  free_pages:
 	list_for_each_entry_safe(page, tmp, &pages, list) {
 		list_del_init(&page->list);
-		__free_page(&page->page);
+		free_buffer_page(page);
 	}
 	return -ENOMEM;
 }

-- 
