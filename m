Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbYDPSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbYDPSZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYDPSZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:25:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYDPSZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:25:34 -0400
Message-ID: <48063F80.9060404@redhat.com>
Date: Wed, 16 Apr 2008 14:03:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tom Zanussi <zanussi@comcast.net>, David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: [PATCH -mm] relayfs: support larger relay buffer take 2
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux>
In-Reply-To: <1208319769.7893.16.camel@charm-linux>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
when the array size is bigger than one page. This enables relayfs to support
bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Changes from take1 to take2:
- add relay_alloc_page_array() and relay_free_page_array()
- use is_vmalloc_addr() instead of checking array size.

This is useful for a 64-bit system which has a plenty of memory (tens of
giga bytes) and a large kernel memory space.

I tested it on x86-64 and ia64.

 kernel/relay.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

Index: 2.6.25-rc8-mm2/kernel/relay.c
===================================================================
--- 2.6.25-rc8-mm2.orig/kernel/relay.c
+++ 2.6.25-rc8-mm2/kernel/relay.c
@@ -27,6 +27,29 @@
 static DEFINE_MUTEX(relay_channels_mutex);
 static LIST_HEAD(relay_channels);

+static struct page *relay_alloc_page_array(unsigned int n_pages)
+{
+	struct page *array;
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
+static void relay_free_page_array(struct page *array)
+{
+	if (is_vmalloc_addr(array))
+		vfree(array);
+	else
+		kfree(array);
+}
+
 /*
  * close() vm_op implementation for relay file mapping.
  */
@@ -109,7 +132,7 @@ static void *relay_alloc_buf(struct rcha
 	*size = PAGE_ALIGN(*size);
 	n_pages = *size >> PAGE_SHIFT;

-	buf->page_array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
+	buf->page_array = relay_alloc_page_array(n_pages);
 	if (!buf->page_array)
 		return NULL;

@@ -130,7 +153,7 @@ static void *relay_alloc_buf(struct rcha
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
-	kfree(buf->page_array);
+	relay_free_page_array(buf->page_array);
 	return NULL;
 }

@@ -189,7 +212,7 @@ static void relay_destroy_buf(struct rch
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



