Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYI2FqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYI2FqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 01:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYI2FqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 01:46:07 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:48999
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbYI2FqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 01:46:06 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2008 01:46:06 EDT
X-Authority-Analysis: v=1.0 c=1 a=4SADDoliQx4A:10 a=hMjZZWvslvUA:10
 a=pwDOo9SHzXu7AkJ0UYwA:9 a=Lg7La9Dtxn0CWdnFijcA:7
 a=OIsc3yIKRdXUvk7PB_1ABzLPDAEA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=si9q_4b84H0A:10 a=955elKCOoL8A:10
Subject: [RFC PATCH 8/11] relay - Clean up remaining padding-related junk.
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
Date: Mon, 29 Sep 2008 00:40:33 -0500
Message-Id: <1222666833.7637.181.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up remaining padding-related junk.

Removes the rest of the padding-related junk.  Also simplifies the
subbuf_start callback a bit.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>

---
 block/blktrace.c      |    5 +++--
 include/linux/relay.h |   12 ++----------
 kernel/relay.c        |   20 ++++----------------
 virt/kvm/kvm_trace.c  |    7 ++++---
 4 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 150c5f7..271b7b7 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -334,8 +334,9 @@ static const struct file_operations blk_msg_fops = {
  * Keep track of how many times we encountered a full subbuffer, to aid
  * the user space app in telling how many lost events there were.
  */
-static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
+static int blk_subbuf_start_callback(struct rchan_buf *buf,
+				     void *subbuf,
+				     int first_subbuf)
 {
 	struct blk_trace *bt;
 
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 21eba2a..172c904 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -51,8 +51,6 @@ struct rchan_buf
 	struct page **page_array;	/* array of current buffer pages */
 	unsigned int page_count;	/* number of current buffer pages */
 	unsigned int finalized;		/* buffer has been finalized */
-	size_t *padding;		/* padding counts per sub-buffer */
-	size_t prev_padding;		/* temporary variable */
 	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
@@ -88,23 +86,17 @@ struct rchan_callbacks
 	 * subbuf_start - called on buffer-switch to a new sub-buffer
 	 * @buf: the channel buffer containing the new sub-buffer
 	 * @subbuf: the start of the new sub-buffer
-	 * @prev_subbuf: the start of the previous sub-buffer
-	 * @prev_padding: unused space at the end of previous sub-buffer
+	 * @first_subbuf: boolean, is this the first subbuf?
 	 *
 	 * The client should return 1 to continue logging, 0 to stop
 	 * logging.
 	 *
-	 * NOTE: subbuf_start will also be invoked when the buffer is
-	 *       created, so that the first sub-buffer can be initialized
-	 *       if necessary.  In this case, prev_subbuf will be NULL.
-	 *
 	 * NOTE: the client can reserve bytes at the beginning of the new
 	 *       sub-buffer by calling subbuf_start_reserve() in this callback.
 	 */
 	int (*subbuf_start) (struct rchan_buf *buf,
 			     void *subbuf,
-			     void *prev_subbuf,
-			     size_t prev_padding);
+			     int first_subbuf);
 
 	/*
 	 * buf_mapped - relay buffer mmap notification
diff --git a/kernel/relay.c b/kernel/relay.c
index b55466d..5392833 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -178,10 +178,6 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	if (!buf)
 		return NULL;
 
-	buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
-	if (!buf->padding)
-		goto free_buf;
-
 	buf->chan = chan;
 	kref_get(&buf->chan->kref);
 
@@ -192,7 +188,6 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	return buf;
 
 free_buf:
-	kfree(buf->padding);
 	kfree(buf);
 	return NULL;
 }
@@ -225,7 +220,6 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 		relay_free_page_array(buf->page_array);
 	}
 	chan->buf[buf->cpu] = NULL;
-	kfree(buf->padding);
 	kfree(buf);
 	kref_put(&chan->kref, relay_destroy_channel);
 }
@@ -283,8 +277,7 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  */
 static int subbuf_start_default_callback (struct rchan_buf *buf,
 					  void *subbuf,
-					  void *prev_subbuf,
-					  size_t prev_padding)
+					  int first_subbuf)
 {
 	if (relay_buf_full(buf))
 		return 0;
@@ -374,8 +367,6 @@ static void wakeup_readers(unsigned long data)
  */
 static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 {
-	size_t i;
-
 	if (init) {
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
@@ -390,10 +381,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	buf->data = buf->start;
 	buf->offset = 0;
 
-	for (i = 0; i < buf->chan->n_subbufs; i++)
-		buf->padding[i] = 0;
-
-	buf->chan->cb->subbuf_start(buf, buf->data, NULL, 0);
+	buf->chan->cb->subbuf_start(buf, buf->data, 1);
 }
 
 /**
@@ -757,7 +745,7 @@ static inline int next_subbuf_free(struct rchan_buf *buf)
  *	Returns either the length passed in or 0 if full.
  *
  *	Performs sub-buffer-switch tasks such as invoking callbacks,
- *	updating padding counts, waking up readers, etc.
+ *	waking up readers, etc.
  */
 size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
 					    size_t length,
@@ -786,7 +774,7 @@ size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
 
 	buf->data = new_data;
 	buf->offset = 0; /* remainder will be added by caller */
-	buf->chan->cb->subbuf_start(buf, new_data, NULL, 0);
+	buf->chan->cb->subbuf_start(buf, new_data, 0);
 
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index d0a9e1c..4626caa 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -105,13 +105,14 @@ DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
  *  many times we encountered a full subbuffer, to tell user space app the
  *  lost records there were.
  */
-static int kvm_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
-				     void *prev_subbuf, size_t prev_padding)
+static int kvm_subbuf_start_callback(struct rchan_buf *buf,
+				     void *subbuf,
+				     int first_subbuf)
 {
 	struct kvm_trace *kt;
 
 	if (!relay_buf_full(buf)) {
-		if (!prev_subbuf) {
+		if (first_subbuf) {
 			/*
 			 * executed only once when the channel is opened
 			 * save metadata as first record
-- 
1.5.3.5



