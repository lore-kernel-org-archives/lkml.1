Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYKTOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYKTOww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYKTOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbYKTOnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:43:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/45] CacheFiles: Permit the page lock state to be monitored
	[ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:43:48 +0000
Message-ID: <20081120144348.10667.12243.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to install a monitor on the page lock waitqueue for a particular
page, thus allowing the page being unlocked to be detected.

This is used by CacheFiles to detect read completion on a page in the backing
filesystem so that it can then copy the data to the waiting netfs page.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/pagemap.h |    5 +++++
 mm/filemap.c            |   18 ++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cc62ee3..06da568 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -395,6 +395,11 @@ static inline void wait_on_page_owner_priv_2(struct page *page)
 extern void end_page_owner_priv_2(struct page *page);
 
 /*
+ * Add an arbitrary waiter to a page's wait queue
+ */
+extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
+
+/*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
  * This assumes that two userspace pages are always sufficient.  That's
diff --git a/mm/filemap.c b/mm/filemap.c
index 16b3c40..7e1a2ae 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -565,6 +565,24 @@ void wait_on_page_bit(struct page *page, int bit_nr)
 EXPORT_SYMBOL(wait_on_page_bit);
 
 /**
+ * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
+ * @page - Page defining the wait queue of interest
+ * @waiter - Waiter to add to the queue
+ *
+ * Add an arbitrary @waiter to the wait queue for the nominated @page.
+ */
+void add_page_wait_queue(struct page *page, wait_queue_t *waiter)
+{
+	wait_queue_head_t *q = page_waitqueue(page);
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue(q, waiter);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL_GPL(add_page_wait_queue);
+
+/**
  * unlock_page - unlock a locked page
  * @page: the page
  *

