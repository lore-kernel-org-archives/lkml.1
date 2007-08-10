Return-Path: <linux-kernel-owner+w=401wt.eu-S940927AbXHJQJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940927AbXHJQJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940238AbXHJQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:05:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765326AbXHJQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/16] CacheFiles: Permit the page lock state to be monitored
	[try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:05:32 +0100
Message-ID: <20070810160532.24698.46481.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to install a monitor on the page lock waitqueue for a particular
page, thus allowing the page being unlocked to be detected.

This is used by CacheFiles to detect read completion on a page in the backing
filesystem so that it can then copy the data to the waiting netfs page.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/pagemap.h |    5 +++++
 mm/filemap.c            |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d1049b6..452fdcf 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -220,6 +220,11 @@ static inline void wait_on_page_fscache_write(struct page *page)
 extern void end_page_fscache_write(struct page *page);
 
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
index 5e419a2..c60c24e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -518,6 +518,25 @@ void fastcall wait_on_page_bit(struct page *page, int bit_nr)
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
+
+EXPORT_SYMBOL_GPL(add_page_wait_queue);
+
+/**
  * unlock_page - unlock a locked page
  * @page: the page
  *

