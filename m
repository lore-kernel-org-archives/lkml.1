Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYDOP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYDOP2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYDOP2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:28:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYDOP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:28:00 -0400
Message-ID: <4804C95F.2080204@redhat.com>
Date: Tue, 15 Apr 2008 11:27:27 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] relayfs: support larger relay buffer
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
when the array size is bigger than one page. This enables relayfs to support
bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
This is useful for a 64-bit system which has a plenty of memory (tens of
giga bytes) and a large kernel memory space.

I tested it on x86-64 and ia64.

 kernel/relay.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

Index: 2.6.25-rc8-mm2/kernel/relay.c
===================================================================
--- 2.6.25-rc8-mm2.orig/kernel/relay.c
+++ 2.6.25-rc8-mm2/kernel/relay.c
@@ -104,12 +104,20 @@ static int relay_mmap_buf(struct rchan_b
 static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 {
 	void *mem;
-	unsigned int i, j, n_pages;
+	unsigned int i, j, n_pages, pa_size;

 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;
+	pa_size = n_pages * sizeof(struct page *);

-	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	if (pa_size > PAGE_SIZE) {
+		buf->page_array = vmalloc(pa_size);
+		if (buf->page_array)
+			memset(buf->page_array, 0, pa_size);
+	} else {
+		buf->page_array = kcalloc(n_pages, sizeof(struct page *),
+					  GFP_KERNEL);
+	}
 	if (!buf->page_array)
 		return NULL;

@@ -130,7 +138,10 @@ static void *relay_alloc_buf(struct rcha
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	kfree(buf->page_array);
+	if (pa_size > PAGE_SIZE)
+		vfree(buf->page_array);
+	else
+		kfree(buf->page_array);
 	return NULL;
 }

@@ -189,7 +200,10 @@ static void relay_destroy_buf(struct rch
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		kfree(buf->page_array);
+		if (buf->page_count * sizeof(struct page *) > PAGE_SIZE)
+			vfree(buf->page_array);
+		else
+			kfree(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


