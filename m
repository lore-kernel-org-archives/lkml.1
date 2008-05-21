Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbYEUAeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbYEUAeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765470AbYEUAcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45313 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbYEUAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:03 -0400
To: mchehab@infradead.org
Subject: [PATCH] cx18 iomem annotations
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycFN-0004qk-RI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/cx18/cx18-driver.c  |    2 +-
 drivers/media/video/cx18/cx18-driver.h  |    2 +-
 drivers/media/video/cx18/cx18-fileops.c |    3 ++-
 drivers/media/video/cx18/cx18-irq.c     |    2 +-
 drivers/media/video/cx18/cx18-mailbox.c |    8 ++++----
 drivers/media/video/cx18/cx18-streams.c |    8 ++++----
 6 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 0dd4e05..1294909 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -670,7 +670,7 @@ static int __devinit cx18_probe(struct pci_dev *dev,
 	cx18_init_power(cx, 1);
 	cx18_init_memory(cx);
 
-	cx->scb = (struct cx18_scb *)(cx->enc_mem + SCB_OFFSET);
+	cx->scb = (struct cx18_scb __iomem *)(cx->enc_mem + SCB_OFFSET);
 	cx18_init_scb(cx);
 
 	cx18_gpio_init(cx);
diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
index a2a6c58..b82e875 100644
--- a/drivers/media/video/cx18/cx18-driver.h
+++ b/drivers/media/video/cx18/cx18-driver.h
@@ -358,7 +358,7 @@ struct cx18 {
 	u32 v4l2_cap;		/* V4L2 capabilities of card */
 	u32 hw_flags; 		/* Hardware description of the board */
 	unsigned mdl_offset;
-	struct cx18_scb *scb;   /* pointer to SCB */
+	struct cx18_scb __iomem *scb;   /* pointer to SCB */
 
 	struct cx18_av_state av_state;
 
diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
index 0b3141d..b2fec09 100644
--- a/drivers/media/video/cx18/cx18-fileops.c
+++ b/drivers/media/video/cx18/cx18-fileops.c
@@ -361,7 +361,8 @@ static ssize_t cx18_read(struct cx18_stream *s, char __user *ubuf,
 				cx18_enqueue(s, buf, &s->q_free);
 				cx18_vapi(cx, CX18_CPU_DE_SET_MDL, 5,
 					s->handle,
-					(void *)&cx->scb->cpu_mdl[buf->id] - cx->enc_mem,
+					(void __iomem *)&cx->scb->cpu_mdl[buf->id] -
+					  cx->enc_mem,
 					1, buf->id, s->buf_size);
 			} else
 				cx18_enqueue(s, buf, &s->q_io);
diff --git a/drivers/media/video/cx18/cx18-irq.c b/drivers/media/video/cx18/cx18-irq.c
index 6e14f8b..0590d71 100644
--- a/drivers/media/video/cx18/cx18-irq.c
+++ b/drivers/media/video/cx18/cx18-irq.c
@@ -75,7 +75,7 @@ static void epu_dma_done(struct cx18 *cx, struct cx18_mailbox *mb)
 
 			cx18_buf_sync_for_device(s, buf);
 			cx18_vapi(cx, CX18_CPU_DE_SET_MDL, 5, s->handle,
-			    (void *)&cx->scb->cpu_mdl[buf->id] - cx->enc_mem,
+			    (void __iomem *)&cx->scb->cpu_mdl[buf->id] - cx->enc_mem,
 			    1, buf->id, s->buf_size);
 		} else
 			set_bit(CX18_F_B_NEED_BUF_SWAP, &buf->b_flags);
diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index 0c5f328..2a5ccef 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -94,10 +94,10 @@ static const struct cx18_api_info *find_api_info(u32 cmd)
 	return NULL;
 }
 
-static struct cx18_mailbox *cx18_mb_is_complete(struct cx18 *cx, int rpu,
+static struct cx18_mailbox __iomem *cx18_mb_is_complete(struct cx18 *cx, int rpu,
 		u32 *state, u32 *irq, u32 *req)
 {
-	struct cx18_mailbox *mb = NULL;
+	struct cx18_mailbox __iomem *mb = NULL;
 	int wait_count = 0;
 	u32 ack;
 
@@ -142,7 +142,7 @@ static struct cx18_mailbox *cx18_mb_is_complete(struct cx18 *cx, int rpu,
 long cx18_mb_ack(struct cx18 *cx, const struct cx18_mailbox *mb)
 {
 	const struct cx18_api_info *info = find_api_info(mb->cmd);
-	struct cx18_mailbox *ack_mb;
+	struct cx18_mailbox __iomem *ack_mb;
 	u32 ack_irq;
 	u8 rpu = CPU;
 
@@ -182,7 +182,7 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 {
 	const struct cx18_api_info *info = find_api_info(cmd);
 	u32 state = 0, irq = 0, req, oldreq, err;
-	struct cx18_mailbox *mb;
+	struct cx18_mailbox __iomem *mb;
 	wait_queue_head_t *waitq;
 	int timeout = 100;
 	int cnt = 0;
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 4ca9d84..532c10c 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -472,8 +472,8 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 	}
 
 	cx18_vapi(cx, CX18_CPU_DE_SET_MDL_ACK, 3, s->handle,
-		(void *)&cx->scb->cpu_mdl_ack[s->type][0] - cx->enc_mem,
-		(void *)&cx->scb->cpu_mdl_ack[s->type][1] - cx->enc_mem);
+		(void __iomem *)&cx->scb->cpu_mdl_ack[s->type][0] - cx->enc_mem,
+		(void __iomem *)&cx->scb->cpu_mdl_ack[s->type][1] - cx->enc_mem);
 
 	list_for_each(p, &s->q_free.list) {
 		struct cx18_buffer *buf = list_entry(p, struct cx18_buffer, list);
@@ -481,8 +481,8 @@ int cx18_start_v4l2_encode_stream(struct cx18_stream *s)
 		writel(buf->dma_handle, &cx->scb->cpu_mdl[buf->id].paddr);
 		writel(s->buf_size, &cx->scb->cpu_mdl[buf->id].length);
 		cx18_vapi(cx, CX18_CPU_DE_SET_MDL, 5, s->handle,
-			(void *)&cx->scb->cpu_mdl[buf->id] - cx->enc_mem, 1,
-			buf->id, s->buf_size);
+			(void __iomem *)&cx->scb->cpu_mdl[buf->id] - cx->enc_mem,
+			1, buf->id, s->buf_size);
 	}
 	/* begin_capture */
 	if (cx18_vapi(cx, CX18_CPU_CAPTURE_START, 1, s->handle)) {
-- 
1.5.3.GIT


