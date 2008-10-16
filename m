Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYJPGT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYJPGT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYJPGN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:28 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59414 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441AbYJPGNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:25 -0400
X-Authority-Analysis: v=1.0 c=1 a=8aG_8LW-thsA:10 a=ata07m3BuiIA:10
 a=IBg0jQH8y8dE10vQx4QA:9 a=1JOTrF24COkwg89G4ScA:7
 a=hCp9II6BGI3vFUJRg725TDD_QdkA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 21/21]   Re-add late setup/early tracing.
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
Date: Thu, 16 Oct 2008 01:06:59 -0500
Message-Id: <1224137219.16328.240.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/relay_pagewriter.h |    5 +++
 kernel/relay_pagewriter.c        |   66 +++++++++++++++++++++++++++++++-------
 2 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
index 91ad16b..8fb4038 100644
--- a/include/linux/relay_pagewriter.h
+++ b/include/linux/relay_pagewriter.h
@@ -26,6 +26,7 @@
  */
 #define PAGEWRITER_PAD_WRITES		0x00010000	/* don't cross pages */
 #define PAGEWRITER_FLIGHT_MODE		0x00020000	/* n_pages page ring */
+#define PAGEWRITER_LATE_SETUP		0x00040000	/* delay chan create */
 
 /*
  * Per-cpu pagewriter buffer
@@ -49,12 +50,14 @@ struct pagewriter {
 	struct rchan *rchan;		/* associated relay channel */
 	struct pagewriter_callbacks *cb;	/* client callbacks */
 	size_t n_pages;			/* number of pages per buffer */
+	size_t n_pages_wakeup;		/* save for LATE */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
 	size_t last_toobig;		/* tried to log event > page size */
 	struct pagewriter_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
 	struct list_head list;		/* for channel list */
 	atomic_t dropped;		/* dropped events due to buffer-full */
+	char base_filename[NAME_MAX];	/* saved base filename, for LATE */
 	unsigned long flags;		/* pagewriter flags for this channel */
 };
 
@@ -286,5 +289,7 @@ extern void pagewriter_flush(struct pagewriter *pagewriter);
 extern void pagewriter_close(struct pagewriter *pagewriter);
 extern void pagewriter_reset(struct pagewriter *pagewriter);
 extern void pagewriter_save_flight_data(struct pagewriter *pagewriter);
+extern int pagewriter_late_setup(struct pagewriter *pagewriter,
+				 struct dentry *parent);
 
 #endif /* _LINUX_RELAY_PAGEWRITER_H */
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
index c3369f5..369abbe 100644
--- a/kernel/relay_pagewriter.c
+++ b/kernel/relay_pagewriter.c
@@ -72,23 +72,27 @@ struct pagewriter *pagewriter_open(const char *base_filename,
 {
 	unsigned int i;
 	struct pagewriter *pagewriter;
-	struct rchan *rchan;
 
 	if (!n_pages)
 		return NULL;
 
-	rchan = relay_open(base_filename, parent, n_pages_wakeup, NULL,
-			   private_data, flags);
-	if (!rchan)
-		return NULL;
-
 	pagewriter = kzalloc(sizeof(struct pagewriter), GFP_KERNEL);
-	if (!pagewriter) {
-		relay_close(rchan);
+	if (!pagewriter)
 		return NULL;
+
+	if (flags & PAGEWRITER_LATE_SETUP) {
+		strlcpy(pagewriter->base_filename, base_filename, NAME_MAX);
+		pagewriter->n_pages_wakeup = n_pages_wakeup;
+	} else {
+		pagewriter->rchan = relay_open(base_filename, parent,
+					       n_pages_wakeup, NULL,
+					       private_data, flags);
+		if (!pagewriter->rchan) {
+			kfree(pagewriter);
+			return NULL;
+		}
 	}
 
-	pagewriter->rchan = rchan;
 	pagewriter->flags = flags;
 	pagewriter->n_pages = n_pages;
 	atomic_set(&pagewriter->dropped, 0);
@@ -115,9 +119,9 @@ free_bufs:
 		pagewriter_close_buf(pagewriter->buf[i]);
 	}
 
-	kfree(pagewriter);
-	relay_close(rchan);
+	relay_close(pagewriter->rchan);
 	kref_put(&pagewriter->kref, pagewriter_destroy);
+	kfree(pagewriter);
 	mutex_unlock(&pagewriters_mutex);
 	return NULL;
 }
@@ -240,6 +244,43 @@ void pagewriter_save_flight_data(struct pagewriter *pagewriter)
 }
 EXPORT_SYMBOL_GPL(pagewriter_save_flight_data);
 
+/**
+ *	pagewriter_late_setup - create relay channel and log early pages
+ *	@pagewriter: pagewriter
+ *	@parent: dentry of parent directory, %NULL for root directory
+ *
+ *	If the pagewriter was initially created in early mode
+ *	(PAGEWRITER_LATE_SETUP), this creates the relay channel and
+ *	sends all the early pages in the page pools to relay and
+ *	therefore onto their final destination e.g. disk or network.
+ *
+ *	Returns 0 if successful, non-zero otherwise.
+ *
+ *	Use to setup files for a previously buffer-only channel.
+ *	Useful to do early tracing in kernel, before VFS is up, for example.
+ */
+int pagewriter_late_setup(struct pagewriter *pagewriter,
+			  struct dentry *parent)
+{
+	if (!pagewriter)
+		return -EINVAL;
+
+	pagewriter->rchan = relay_open(pagewriter->base_filename,
+				       parent,
+				       pagewriter->n_pages_wakeup,
+				       NULL,
+				       pagewriter->private_data,
+				       pagewriter->flags);
+	if (!pagewriter->rchan)
+		return -ENOMEM;
+
+	pagewriter->flags &= ~PAGEWRITER_LATE_SETUP;
+	pagewriter_save_flight_data(pagewriter);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pagewriter_late_setup);
+
 /*
  * end relay kernel API
  */
@@ -573,7 +614,8 @@ size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
 	if (!(buf->pagewriter->flags & PAGEWRITER_PAD_WRITES))
 		remainder = length - (PAGE_SIZE - buf->offset);
 
-	if (buf->pagewriter->flags & PAGEWRITER_FLIGHT_MODE) {
+	if (buf->pagewriter->flags & PAGEWRITER_FLIGHT_MODE ||
+	    buf->pagewriter->flags & PAGEWRITER_LATE_SETUP) {
 		list_add_tail(&buf->page->list, &buf->pool);
 		buf->n_pages_flight++;
 	} else {
-- 
1.5.3.5



