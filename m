Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYDPT43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYDPT43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYDPT4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:56:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbYDPT4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:56:15 -0400
Message-ID: <480658DC.6030507@redhat.com>
Date: Wed, 16 Apr 2008 15:51:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <zanussi@comcast.net>,
       David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: [PATCH -mm] relayfs: support larger relay buffer take 3
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux> <48063F80.9060404@redhat.com> <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI> <480646B2.9000905@redhat.com>
In-Reply-To: <480646B2.9000905@redhat.com>
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
Changes from take2 to take3:
 - Use struct page ** instead of struct page *.
 - move functions to the place before relay_mmap_buf.
 - add comments.

This is useful for a 64-bit system which has a plenty of memory (tens of
giga bytes) and a large kernel memory space.

I tested it on x86-64 and ia64.

 kernel/relay.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: 2.6.25-rc8-mm2/kernel/relay.c
===================================================================
--- 2.6.25-rc8-mm2.orig/kernel/relay.c
+++ 2.6.25-rc8-mm2/kernel/relay.c
@@ -65,6 +65,35 @@ static struct vm_operations_struct relay
 	.close = relay_file_mmap_close,
 };

+/*
+ * allocate an array of pointers of struct page
+ */
+static struct page **relay_alloc_page_array(unsigned int n_pages)
+{
+	struct page **array;
+	unsigned int pa_size = n_pages * sizeof(struct page *);
+
+	if (pa_size > PAGE_SIZE) {
+		array = vmalloc(pa_size);
+		if (array)
+			memset(array, 0, pa_size);
+	} else {
+		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	}
+	return array;
+}
+
+/*
+ * free an array of pointers of struct page
+ */
+static void relay_free_page_array(struct page **array)
+{
+	if (is_vmalloc_addr(array))
+		vfree(array);
+	else
+		kfree(array);
+}
+
 /**
  *	relay_mmap_buf: - mmap channel buffer to process address space
  *	@buf: relay channel buffer
@@ -109,7 +138,7 @@ static void *relay_alloc_buf(struct rcha
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;

-	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	buf->page_array = relay_alloc_page_array(n_pages);
 	if (!buf->page_array)
 		return NULL;

@@ -130,7 +159,7 @@ static void *relay_alloc_buf(struct rcha
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	kfree(buf->page_array);
+	relay_free_page_array(buf->page_array);
 	return NULL;
 }

@@ -189,7 +218,7 @@ static void relay_destroy_buf(struct rch
 		vunmap(buf->start);
 		for (i = 0; i < buf->page_count; i++)
 			__free_page(buf->page_array[i]);
-		kfree(buf->page_array);
+		relay_free_page_array(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf->padding);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

