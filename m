Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYI0GTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYI0GTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYI0GSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:18:01 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:52689 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbYI0GR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:17:59 -0400
X-Authority-Analysis: v=1.0 c=1 a=qzJOE9tFdREA:10 a=Z77S866iAhYA:10
 a=l-ZSAgIrRNUgVz6KjyUA:9 a=fmuDoAoWXAGQAq8ObDEA:7
 a=yR2lRQ-QR2_OkMvxr7M7zIpHOrYA:4 a=vNGxQsTWjH8A:10
Subject: [RFC PATCH 5/10] relay - Map the first sub-buffer at the end of
	the buffer, for temporary convenience.
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Content-Type: text/plain
Date: Sat, 27 Sep 2008 01:18:08 -0500
Message-Id: <1222496288.6710.76.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map the first sub-buffer at the end of the buffer, for temporary convenience.

Make relay buffers 'circular' for writing by mapping the first subbuf
at end of last subbuf.  This is so we can do writes across last subbuf
boundary without adding special write logic.  This is a temporary
state of affairs and it all goes away in a future patch, but it's here
now so things will still work.
---
 kernel/relay.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 6c7698a..e9dd976 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -125,20 +125,20 @@ static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 /**
  *	relay_alloc_buf - allocate a channel buffer
  *	@buf: the buffer struct
- *	@size: total size of the buffer
  *
  *	Returns a pointer to the resulting buffer, %NULL if unsuccessful. The
  *	passed in size will get page aligned, if it isn't already.
  */
-static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
+static void *relay_alloc_buf(struct rchan_buf *buf)
 {
 	void *mem;
-	unsigned int i, j, n_pages;
+	unsigned int i, j, n_pages, n_subbuf_pages;
 
-	*size = PAGE_ALIGN(*size);
-	n_pages = *size >> PAGE_SHIFT;
+	buf->chan->alloc_size = PAGE_ALIGN(buf->chan->alloc_size);
+	n_pages = buf->chan->alloc_size >> PAGE_SHIFT;
+	n_subbuf_pages = PAGE_ALIGN(buf->chan->subbuf_size) >> PAGE_SHIFT;
 
-	buf->page_array = relay_alloc_page_array(n_pages);
+	buf->page_array = relay_alloc_page_array(n_pages + n_subbuf_pages);
 	if (!buf->page_array)
 		return NULL;
 
@@ -148,11 +148,14 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
 			goto depopulate;
 		set_page_private(buf->page_array[i], (unsigned long)buf);
 	}
-	mem = vmap(buf->page_array, n_pages, VM_MAP, PAGE_KERNEL);
+	for (i = 0; i < n_subbuf_pages; i++)
+		buf->page_array[n_pages + i] = buf->page_array[i];
+	mem = vmap(buf->page_array, n_pages + n_subbuf_pages, VM_MAP,
+		   PAGE_KERNEL);
 	if (!mem)
 		goto depopulate;
 
-	memset(mem, 0, *size);
+	memset(mem, 0, buf->chan->alloc_size);
 	buf->page_count = n_pages;
 	return mem;
 
@@ -179,12 +182,13 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	if (!buf->padding)
 		goto free_buf;
 
-	buf->start = relay_alloc_buf(buf, &chan->alloc_size);
+	buf->chan = chan;
+	kref_get(&buf->chan->kref);
+
+	buf->start = relay_alloc_buf(buf);
 	if (!buf->start)
 		goto free_buf;
 
-	buf->chan = chan;
-	kref_get(&buf->chan->kref);
 	return buf;
 
 free_buf:
-- 
1.5.3.5



