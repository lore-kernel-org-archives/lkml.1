Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYJPGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYJPGRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYJPGND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:03 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:56330 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbYJPGNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:00 -0400
X-Authority-Analysis: v=1.0 c=1 a=IgDqfuoI0uAA:10 a=fajGSUrGfWwo8FDdz18A:9
 a=V_KXM1_BqNw28qZk5t4A:7 a=IOlJlzjrrv1zf7jkoqqsR9hgR2sA:4 a=i92e0Ub4el8A:10
 a=d_-3mwAUsuEA:10 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 15/21]  Add relay_add_pages
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
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 01:06:31 -0500
Message-Id: <1224137191.16328.234.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/relay.h |   11 +++++++--
 kernel/relay.c        |   50 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index b23ba90..a33b728 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/kref.h>
+#include <linux/pagevec.h>
 
 /*
  * relay channel flags
@@ -164,13 +165,17 @@ extern struct rchan *relay_open(const char *base_filename,
 				struct rchan_callbacks *cb,
 				void *private_data,
 				unsigned long rchan_flags);
-extern void relay_close(struct rchan *chan);
-extern void relay_flush(struct rchan *chan);
-extern void relay_reset(struct rchan *chan);
 extern void relay_add_page(struct rchan *chan,
 			   struct page *page,
 			   struct relay_page_callbacks *cb,
 			   void *private_data);
+extern void relay_add_pages(struct rchan *chan,
+			    struct pagevec *pages,
+			    struct relay_page_callbacks *cb,
+			    void *private_data);
+extern void relay_flush(struct rchan *chan);
+extern void relay_close(struct rchan *chan);
+extern void relay_reset(struct rchan *chan);
 
 extern int relay_late_setup_files(struct rchan *chan,
 				  const char *base_filename,
diff --git a/kernel/relay.c b/kernel/relay.c
index e53e729..b27b655 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/relay.h>
-#include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/splice.h>
@@ -117,6 +116,14 @@ static inline void relay_wakeup_readers(struct rchan_buf *buf)
 		__mod_timer(&buf->timer, jiffies + 1);
 }
 
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage)
+{
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, PAGE_SIZE);
+}
+
 /**
  *	__relay_add_page - add a relay page to relay
  *	@buf: the buffer struct
@@ -127,9 +134,7 @@ static void __relay_add_page(struct rchan_buf *buf, struct relay_page *rpage)
 	unsigned long flags;
 
 	spin_lock_irqsave(&buf->lock, flags);
-	list_add_tail(&rpage->list, &buf->pages);
-	buf->nr_pages++;
-	relay_update_filesize(buf, PAGE_SIZE);
+	__relay_add_page_nolock(buf, rpage);
 	spin_unlock_irqrestore(&buf->lock, flags);
 
 	relay_wakeup_readers(buf);
@@ -165,6 +170,43 @@ void relay_add_page(struct rchan *chan,
 EXPORT_SYMBOL_GPL(relay_add_page);
 
 /**
+ *	relay_add_pages - add pages to relay
+ *	@buf: the buffer struct
+ *	@page: struct page
+ *
+ *	relay now owns the page.
+ */
+void relay_add_pages(struct rchan *chan,
+		     struct pagevec *pages,
+		     struct relay_page_callbacks *cb,
+		     void *private_data)
+{
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
+	unsigned long flags;
+	int i, nr_pages = pagevec_count(pages);
+
+	buf = chan->buf[get_cpu()];
+	spin_lock_irqsave(&buf->lock, flags);
+	for (i = 0; i < nr_pages; i++) {
+		rpage = __relay_get_rpage(buf);
+
+		if (likely(rpage)) {
+			rpage->page = pages->pages[i];
+			set_page_private(rpage->page, (unsigned long)buf);
+			rpage->cb = cb;
+			rpage->private_data = private_data;
+			__relay_add_page_nolock(buf, rpage);
+		}
+	}
+	spin_unlock_irqrestore(&buf->lock, flags);
+	put_cpu();
+
+	relay_wakeup_readers(buf);
+}
+EXPORT_SYMBOL_GPL(relay_add_pages);
+
+/**
  *	relay_create_buf - allocate and initialize a channel buffer
  *	@chan: the relay channel
  *
-- 
1.5.3.5



