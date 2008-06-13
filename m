Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbYFMBK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbYFMBK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbYFMBKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:10:11 -0400
Received: from [194.117.236.238] ([194.117.236.238]:41475 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbYFMBKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:10:10 -0400
Date: Fri, 13 Jun 2008 04:09:47 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when writing to
 a CPU buffer.
Message-ID: <20080613040947.7465b9a5@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semantically, start + offset is always lower than the total size in bytes,
so the code should check against equality to size, not size + 1. When
userspace did read() (but not necessarily restricted to this), this
resulted in all-zeros data at the end of the buffer.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/linux/relay.h |    4 ++--
 kernel/relay.c        |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 6cd8c44..8593ca1 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -202,7 +202,7 @@ static inline void relay_write(struct rchan *chan,
 
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
-	if (unlikely(buf->offset + length > chan->subbuf_size))
+	if (unlikely(buf->offset + length >= chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
@@ -228,7 +228,7 @@ static inline void __relay_write(struct rchan *chan,
 	struct rchan_buf *buf;
 
 	buf = chan->buf[get_cpu()];
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
+	if (unlikely(buf->offset + length >= buf->chan->subbuf_size))
 		length = relay_switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
diff --git a/kernel/relay.c b/kernel/relay.c
index 7de644c..07f25e7 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -622,7 +622,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 	if (unlikely(length > buf->chan->subbuf_size))
 		goto toobig;
 
-	if (buf->offset != buf->chan->subbuf_size + 1) {
+	if (buf->offset != buf->chan->subbuf_size) {
 		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
 		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 		buf->padding[old_subbuf] = buf->prev_padding;
@@ -645,7 +645,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 	new = buf->start + new_subbuf * buf->chan->subbuf_size;
 	buf->offset = 0;
 	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
-		buf->offset = buf->chan->subbuf_size + 1;
+		buf->offset = buf->chan->subbuf_size;
 		return 0;
 	}
 	buf->data = new;
-- 
1.5.5.4

