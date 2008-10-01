Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYJAPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYJAPPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYJAPO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:14:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYJAPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:14:56 -0400
Date: Wed, 1 Oct 2008 11:14:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] ring_buffer: allocate buffer page pointer
In-Reply-To: <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> 
 <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>  <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com>  <20080929233539.GA31143@Krystal>  <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com>  <20080930000307.GA2929@Krystal> 
 <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>  <20080930034603.GA13801@Krystal>  <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>  <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current method of overlaying the page frame as the buffer page pointer
can be very dangerous and limits our ability to do other things with
a page from the buffer, like send it off to disk.

This patch allocates the buffer_page instead of overlaying the page's
page frame. The use of the buffer_page has hardly changed due to this.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   54 ++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-01 09:37:23.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-01 11:03:16.000000000 -0400
@@ -115,16 +115,10 @@ void *ring_buffer_event_data(struct ring
  * Thanks to Peter Zijlstra for suggesting this idea.
  */
 struct buffer_page {
-	union {
-		struct {
-			unsigned long	 flags;		/* mandatory */
-			atomic_t	 _count;	/* mandatory */
-			u64		 time_stamp;	/* page time stamp */
-			unsigned	 size;		/* size of page data */
-			struct list_head list;		/* list of free pages */
-		};
-		struct page page;
-	};
+	u64		 time_stamp;	/* page time stamp */
+	unsigned	 size;		/* size of page data */
+	struct list_head list;		/* list of free pages */
+	void *page;			/* Actual data page */
 };
 
 /*
@@ -133,9 +127,9 @@ struct buffer_page {
  */
 static inline void free_buffer_page(struct buffer_page *bpage)
 {
-	reset_page_mapcount(&bpage->page);
-	bpage->page.mapping = NULL;
-	__free_page(&bpage->page);
+	if (bpage->page)
+		__free_page(bpage->page);
+	kfree(bpage);
 }
 
 /*
@@ -237,11 +231,16 @@ static int rb_allocate_pages(struct ring
 	unsigned i;
 
 	for (i = 0; i < nr_pages; i++) {
+		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+				    GFP_KERNEL, cpu_to_node(cpu));
+		if (!page)
+			goto free_pages;
+		list_add(&page->list, &pages);
+
 		addr = __get_free_page(GFP_KERNEL);
 		if (!addr)
 			goto free_pages;
-		page = (struct buffer_page *)virt_to_page(addr);
-		list_add(&page->list, &pages);
+		page->page = (void *)addr;
 	}
 
 	list_splice(&pages, head);
@@ -262,6 +261,7 @@ static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	struct buffer_page *page;
 	unsigned long addr;
 	int ret;
 
@@ -275,10 +275,17 @@ rb_allocate_cpu_buffer(struct ring_buffe
 	spin_lock_init(&cpu_buffer->lock);
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
+	page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
+			    GFP_KERNEL, cpu_to_node(cpu));
+	if (!page)
+		goto fail_free_buffer;
+
+	cpu_buffer->reader_page = page;
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
-		goto fail_free_buffer;
-	cpu_buffer->reader_page = (struct buffer_page *)virt_to_page(addr);
+		goto fail_free_reader;
+	page->page = (void *)addr;
+
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	cpu_buffer->reader_page->size = 0;
 
@@ -523,11 +530,16 @@ int ring_buffer_resize(struct ring_buffe
 
 	for_each_buffer_cpu(buffer, cpu) {
 		for (i = 0; i < new_pages; i++) {
+			page = kzalloc_node(ALIGN(sizeof(*page),
+						  cache_line_size()),
+					    GFP_KERNEL, cpu_to_node(cpu));
+			if (!page)
+				goto free_pages;
+			list_add(&page->list, &pages);
 			addr = __get_free_page(GFP_KERNEL);
 			if (!addr)
 				goto free_pages;
-			page = (struct buffer_page *)virt_to_page(addr);
-			list_add(&page->list, &pages);
+			page->page = (void *)addr;
 		}
 	}
 
@@ -567,9 +579,7 @@ static inline int rb_null_event(struct r
 
 static inline void *rb_page_index(struct buffer_page *page, unsigned index)
 {
-	void *addr = page_address(&page->page);
-
-	return addr + index;
+	return page->page + index;
 }
 
 static inline struct ring_buffer_event *


