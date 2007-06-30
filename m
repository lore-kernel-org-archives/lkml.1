Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXF3D0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXF3D0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXF3DZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:25:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35325 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbXF3DY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:59 -0400
Subject: [RFC PATCH 6/6] relay: add relay_reset_consumed()
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:24:21 -0500
Message-Id: <1183173861.24291.142.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows relay channels to be reset i.e. unconsumed.
Basically allows a 'rewind' function for flight-recorder tracing.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 Documentation/filesystems/relay.txt |   11 ++++++
 include/linux/relay.h               |    1 
 kernel/relay.c                      |   59 ++++++++++++++++++++++++++++++++----
 3 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
index 18d23f9..d31113a 100644
--- a/Documentation/filesystems/relay.txt
+++ b/Documentation/filesystems/relay.txt
@@ -161,6 +161,7 @@ TBD(curr. line MT:/API/)
     relay_close(chan)
     relay_flush(chan)
     relay_reset(chan)
+    relay_reset_consumed(chan)
 
   channel management typically called on instigation of userspace:
 
@@ -452,6 +453,16 @@ state without reallocating channel buffer memory or destroying
 existing mappings.  It should however only be called when it's safe to
 do so, i.e. when the channel isn't currently being written to.
 
+The read(2) implementation always 'consumes' the bytes read,
+i.e. those bytes won't be available again to subsequent reads.
+Certain applications may nonetheless wish to allow the 'consumed' data
+to be re-read; relay_reset_consumed() is provided for that purpose -
+it resets the internal consumed counters for all buffers in the
+channel.  For example, if a first set of reads 'drains' the channel,
+and then relay_reset_consumed() is called, a second set of reads will
+get the exact same data (assuming no new data was written between the
+first set of reads and the second).
+
 Finally, there are a couple of utility callbacks that can be used for
 different purposes.  buf_mapped() is called whenever a channel buffer
 is mmapped from user space and buf_unmapped() is called when it's
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6cd8c44..aca45fa 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -175,6 +175,7 @@ extern void relay_subbufs_consumed(struct rchan *chan,
 				   unsigned int cpu,
 				   size_t consumed);
 extern void relay_reset(struct rchan *chan);
+extern void relay_reset_consumed(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
 extern size_t relay_switch_subbuf(struct rchan_buf *buf,
diff --git a/kernel/relay.c b/kernel/relay.c
index 4311101..6806636 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -382,6 +382,57 @@ void relay_reset(struct rchan *chan)
 }
 EXPORT_SYMBOL_GPL(relay_reset);
 
+/**
+ *	__relay_reset_consumed - reset a channel buffer's consumed count
+ *	@buf: the channel buffer
+ *
+ *	See relay_reset_consumed for description of effect.
+ */
+static inline void __relay_reset_consumed(struct rchan_buf *buf)
+{
+	size_t n_subbufs = buf->chan->n_subbufs;
+	size_t produced = buf->subbufs_produced;
+	size_t consumed = buf->subbufs_consumed;
+
+	if (produced < n_subbufs)
+		buf->subbufs_consumed = 0;
+	else {
+		consumed = produced - n_subbufs;
+		if (buf->offset)
+			consumed++;
+		buf->subbufs_consumed = consumed;
+	}
+	buf->bytes_consumed = 0;
+}
+
+/**
+ *	relay_reset_consumed - reset the channel's consumed counts
+ *	@chan: the channel
+ *
+ *	This has the effect of making all data previously read (and
+ *	not overwritten by subsequent writes) from a channel available
+ *	for reading again.
+ *
+ *	NOTE: Care should be taken that the channel isn't actually
+ *	being used by anything when this call is made.
+ */
+void relay_reset_consumed(struct rchan *chan)
+{
+	unsigned int i;
+	struct rchan_buf *prev = NULL;
+
+	if (!chan)
+		return;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		if (!chan->buf[i] || chan->buf[i] == prev)
+			break;
+		__relay_reset_consumed(chan->buf[i]);
+		prev = chan->buf[i];
+	}
+}
+EXPORT_SYMBOL_GPL(relay_reset_consumed);
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -840,11 +891,9 @@ static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
 		return 1;
 	}
 
-	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = (produced / n_subbufs) * n_subbufs;
-		buf->subbufs_consumed = consumed;
-	}
-	
+	if (unlikely(produced - consumed >= n_subbufs))
+		__relay_reset_consumed(buf);
+
 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
 	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
 



