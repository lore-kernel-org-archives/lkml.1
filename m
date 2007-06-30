Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXF3DZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXF3DZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbXF3DYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:24:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34047 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbXF3DYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:47 -0400
Subject: [RFC PATCH 4/6] relay: add relay_reserve_cpu()
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:24:12 -0500
Message-Id: <1183173852.24291.140.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to explicitly specify the per-cpu buffer
to reserve space in.  Needed for early DTI tracing.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 relay.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6caedef..37a7306 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -269,6 +269,39 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
 }
 
 /**
+ *	relay_reserve_cpu - reserve slot in given cpu's channel buffer
+ *	@chan: relay channel
+ *	@length: number of bytes to reserve
+ *	@cpu: cpu to log to
+ *
+ *	Returns pointer to reserved slot, NULL if full.
+ *
+ *	Reserves a slot in the given cpu's channel buffer.
+ *	Does not protect the buffer at all - caller must provide
+ *	appropriate synchronization.
+ *
+ *	NOTE: this is almost certainly not the function you want -
+ *	use relay_reserve() instead for normal logging.  This version
+ *	is specialized for things like early tracing.
+ */
+static inline void *relay_reserve_cpu(struct rchan *chan, size_t length,
+				      unsigned int cpu)
+{
+	void *reserved;
+	struct rchan_buf *buf = chan->buf[cpu];
+
+	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
+		length = relay_switch_subbuf(buf, length);
+		if (!length)
+			return NULL;
+	}
+	reserved = buf->data + buf->offset;
+	buf->offset += length;
+
+	return reserved;
+}
+
+/**
  *	subbuf_start_reserve - reserve bytes at the start of a sub-buffer
  *	@buf: relay channel buffer
  *	@length: number of bytes to reserve



