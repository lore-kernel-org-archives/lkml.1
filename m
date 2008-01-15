Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYAOX4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYAOX4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 18:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYAOXtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 18:49:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701AbYAOXsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 18:48:46 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/26] CacheFiles: Permit the page lock state to be monitored
To: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Tue, 15 Jan 2008 23:48:34 +0000
Message-ID: <20080115234834.22183.38805.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
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
index 6a1b317..21c35e2 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -223,6 +223,11 @@ static inline void wait_on_page_fscache_write(struct page *page)
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
index ed74864..8a8e43f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -533,6 +533,24 @@ void fastcall wait_on_page_bit(struct page *page, int bit_nr)
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

