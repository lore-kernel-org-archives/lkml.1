Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYJPGSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYJPGSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYJPGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:20 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:41368 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYJPGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:18 -0400
X-Authority-Analysis: v=1.0 c=1 a=HQOjwqcwKhcA:10 a=sc658EVciOMA:10
 a=rYQun5c-nZEX9xE7uw0A:9 a=mgnfUcxp__t31pchgPMA:7
 a=Nw76rjaBfsPZi53NPC8ydThuwQIA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=uocofYhV6bsA:10
Subject: [RFC PATCH 19/21]  Add 'overwrite' mode back as 'flight' mode.
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
Date: Thu, 16 Oct 2008 01:06:50 -0500
Message-Id: <1224137210.16328.238.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses per-cpu page pools as flight buffers, recycling pages and adding
pagewriter_save_flight_data() to dump it all to relay.
---
 include/linux/relay_pagewriter.h |    3 ++
 kernel/relay_pagewriter.c        |   71 +++++++++++++++++++++++++++++++++++---
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
index 12378e5..91ad16b 100644
--- a/include/linux/relay_pagewriter.h
+++ b/include/linux/relay_pagewriter.h
@@ -25,6 +25,7 @@
  * pagewriter flags
  */
 #define PAGEWRITER_PAD_WRITES		0x00010000	/* don't cross pages */
+#define PAGEWRITER_FLIGHT_MODE		0x00020000	/* n_pages page ring */
 
 /*
  * Per-cpu pagewriter buffer
@@ -37,6 +38,7 @@ struct pagewriter_buf {
 	struct kref kref;		/* channel buffer refcount */
 	struct list_head pool;		/* current set of unused pages */
 	struct list_head empty_rpage_structs;	/* cached rpage structs */
+	size_t n_pages_flight;		/* number full flight pages written */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
@@ -283,5 +285,6 @@ extern struct pagewriter *pagewriter_open(const char *base_filename,
 extern void pagewriter_flush(struct pagewriter *pagewriter);
 extern void pagewriter_close(struct pagewriter *pagewriter);
 extern void pagewriter_reset(struct pagewriter *pagewriter);
+extern void pagewriter_save_flight_data(struct pagewriter *pagewriter);
 
 #endif /* _LINUX_RELAY_PAGEWRITER_H */
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
index d27267f..9bc1461 100644
--- a/kernel/relay_pagewriter.c
+++ b/kernel/relay_pagewriter.c
@@ -41,6 +41,7 @@ static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pw,
 						  unsigned int cpu);
 static void pagewriter_destroy(struct kref *kref);
 static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init);
+static void pagewriter_save_flight_buf(struct pagewriter_buf *buf);
 
 /*
  * pagewriter kernel API
@@ -201,6 +202,36 @@ void pagewriter_reset(struct pagewriter *pagewriter)
 }
 EXPORT_SYMBOL_GPL(pagewriter_reset);
 
+/**
+ *	pagewriter_save_flight_data - log all pages dirtied in flight mode
+ *	@pagewriter: pagewriter
+ *
+ *	In flight mode (PAGEWRITER_FLIGHT_MODE), the pages written to
+ *	via the pagewriter_write/reserve functions are simply cycled
+ *	around the per-cpu page pools, and not sent to relay.  This
+ *	function provides a way, at the user's request, to simply
+ *	sends all the dirty pages in the page pools to relay and
+ *	therefore onto their final destination e.g. disk or network.
+ *
+ *	The pagewriter and associated buffers will be in the same
+ *	state as if hey were reset after this call.
+ */
+void pagewriter_save_flight_data(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i)
+		if (pagewriter->buf[i])
+			pagewriter_save_flight_buf(pagewriter->buf[i]);
+	relay_flush(pagewriter->rchan);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_save_flight_data);
+
 /*
  * end relay kernel API
  */
@@ -534,11 +565,15 @@ size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
 	if (!(buf->pagewriter->flags & PAGEWRITER_PAD_WRITES))
 		remainder = length - (PAGE_SIZE - buf->offset);
 
-	relay_add_page(buf->pagewriter->rchan, buf->page->page,
-		       &pagewriter_relay_page_callbacks, (void *)buf);
-
-	buf->page->page = NULL;
-	add_empty_rpage_struct(buf, buf->page);
+	if (buf->pagewriter->flags & PAGEWRITER_FLIGHT_MODE) {
+		list_add_tail(&buf->page->list, &buf->pool);
+		buf->n_pages_flight++;
+	} else {
+		relay_add_page(buf->pagewriter->rchan, buf->page->page,
+			       &pagewriter_relay_page_callbacks, (void *)buf);
+		buf->page->page = NULL;
+		add_empty_rpage_struct(buf, buf->page);
+	}
 
 	buf->page = new_page;
 	buf->data = page_address(buf->page->page);
@@ -574,10 +609,36 @@ static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init)
 	buf->page = pagewriter_get_free_page(buf);
 	buf->data = page_address(buf->page->page);
 	buf->offset = 0;
+	buf->n_pages_flight = 0;
 
 	buf->pagewriter->cb->new_page(buf, buf->data);
 }
 
+static void pagewriter_save_flight_buf(struct pagewriter_buf *buf)
+{
+	size_t first_page, n_pages = buf->n_pages_flight;
+	struct relay_page *first_rpage;
+
+	buf->pagewriter->cb->switch_page(buf, 0, NULL);
+
+	if(buf->n_pages_flight > buf->pagewriter->n_pages)
+		n_pages = buf->pagewriter->n_pages;
+
+	first_page = buf->pagewriter->n_pages - n_pages;
+	list_for_each_entry(first_rpage, &buf->pool, list)
+		if (!first_page--)
+			break;
+
+	list_for_each_entry_from(first_rpage, &buf->pool, list) {
+		relay_add_page(buf->pagewriter->rchan, buf->page->page,
+			       &pagewriter_relay_page_callbacks, (void *)buf);
+		buf->page->page = NULL;
+		add_empty_rpage_struct(buf, buf->page);
+	}
+
+	__pagewriter_reset(buf, 0);
+}
+
 /**
  * 	pagewriter_hotcpu_callback - CPU hotplug callback
  * 	@nb: notifier block
-- 
1.5.3.5



